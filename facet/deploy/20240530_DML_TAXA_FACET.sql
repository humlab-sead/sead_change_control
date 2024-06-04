-- Deploy facet: 20240530_DML_TAXA_FACET

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-05-30
  Description   Fix faulty inner join using helper view
  Issue         https://github.com/humlab-sead/sead_change_control/issues/279
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
declare s_facets text;
declare j_facets jsonb;
begin

    begin

        set client_encoding = 'UTF8';

        insert into facet.table (table_id, schema_name, table_or_udf_name, primary_key_name, is_udf)
            values (176, '', 'facet.abundance_taxon_shortcut', 'xxx', false)
                on conflict (table_id) do nothing;

        insert into facet.table_relation (table_relation_id, source_table_id, target_table_id, weight, source_column_name, target_column_name)
            values
                (235, 176, 109, 25, 'taxon_id', 'taxon_id'),
                (236, 176,   4, 25, 'analysis_entity_id', 'analysis_entity_id')
                on conflict (table_relation_id) do nothing;

        drop view if exists facet.abundance_taxon_shortcut;
        create or replace view facet.abundance_taxon_shortcut as
            with analysis as (
                select ae.analysis_entity_id, m.method_name
                from tbl_analysis_entities ae
                join tbl_datasets d using (dataset_id)
                join tbl_methods m using (method_id)
            ),
            modification as (
                select am.abundance_id, mt.modification_type_name
                from tbl_abundance_modifications am
                join tbl_modification_types mt using (modification_type_id)
            ),
            taxon as (
                select taxon_id, concat_ws(' ', g.genus_name, t.species, a.author_name) as taxon_name
                from tbl_taxa_tree_master t
                join tbl_taxa_tree_genera g using (genus_id) 
                left join tbl_taxa_tree_authors a using (author_id)
            )
            select
                abundance.analysis_entity_id,
                abundance.abundance_id,
                abundance.taxon_id,
                taxon.taxon_name,
                concat_ws(' ', analysis.method_name, modification.modification_type_name) as elements_part_mod,
                abundance.abundance
            from tbl_abundances abundance
            join taxon using (taxon_id)
            join analysis using (analysis_entity_id)
            left join modification using (abundance_id);


    s_facets = $facets$
    [
		{
			"facet_id": 25,
			"facet_code": "species",
			"display_title": "Taxa",
			"description": "Taxonomic species (under genus)",
			"facet_group_id":"6",
			"facet_type_id": 1,
			"category_id_expr": "facet.abundance_taxon_shortcut.taxon_id",
			"category_id_type": "integer",
			"category_id_operator": "=",
			"category_name_expr": "facet.abundance_taxon_shortcut.taxon_name",
			"sort_expr": "1",
			"is_applicable": true,
			"is_default": false,
			"aggregate_type": "count",
			"aggregate_title": "Count of Anaylysis",
			"aggregate_facet_code": "result_facet",
			"tables": [
				{
					"sequence_id": 1,
					"table_name": "facet.abundance_taxon_shortcut",
					"udf_call_arguments": null,
					"alias":  null
				},
				{
					"sequence_id": 2,
					"table_name": "tbl_sites",
					"udf_call_arguments": null,
					"alias":  null
				} ],
			"clauses": [
				{
					"clause": "tbl_sites.site_id is not null",
					"enforce_constraint": true
				}
			]
		} 
    ]

$facets$;

    j_facets = s_facets::jsonb;

    perform facet.create_or_update_facet(v.facet::jsonb)
    from jsonb_array_elements(j_facets) as v(facet);

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
