-- Deploy facet: 20240604_DML_GEOCHRONOLOGY_FACET

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-06-04
  Description   Fix geochronology facet
  Issue         https://github.com/humlab-sead/sead_change_control/issues/300
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
declare i_relation_id int;
declare i_shortcut_id int;
begin

    set client_encoding = 'UTF8';

    i_shortcut_id = (select max(table_id) from facet.table where table_or_udf_name = 'facet.geochronology_taxa_shortcut');

    if i_shortcut_id is null then
        i_shortcut_id = (select max(table_id) from facet.table) + 1;
        insert into facet.table (table_id, schema_name, table_or_udf_name, primary_key_name, is_udf)
            values (i_shortcut_id, '', 'facet.geochronology_taxa_shortcut', 'xxx', false)
                on conflict (table_id) do nothing;
    end if;

    delete from facet.table_relation
        where i_shortcut_id in (source_table_id, target_table_id);

    i_relation_id = (select max(table_relation_id) from facet.table_relation) + 1;

    insert into facet.table_relation (table_relation_id, source_table_id, target_table_id, weight, source_column_name, target_column_name)
        values
            (i_relation_id    , i_shortcut_id, 109, 200, 'taxon_id', 'taxon_id'),
            (i_relation_id + 1, i_shortcut_id,   4, 200, 'analysis_entity_id', 'analysis_entity_id')
            on conflict (table_relation_id) do nothing;

    call sead_utility.drop_view('facet.geochronology_taxa_shortcut');

    create or replace view facet.geochronology_taxa_shortcut as
        with geochronology_taxa as (
            select g.geochron_id, t.taxon_id, aeg.analysis_entity_id
            from tbl_physical_samples ps
            join tbl_analysis_entities aea using (physical_sample_id)
            join tbl_abundances a on a.analysis_entity_id = aea.analysis_entity_id
            join tbl_taxa_tree_master t using (taxon_id)
            join tbl_analysis_entities aeg using (physical_sample_id)
            join tbl_geochronology g on g.analysis_entity_id = aeg.analysis_entity_id
        ) select analysis_entity_id, taxon_id
        from geochronology_taxa;

    s_facets = $facets$
    [
        {
            "facet_id": 10,
            "facet_code": "geochronology",
            "display_title": "Geochronology",
            "description": "Sample ages as retrieved through absolute methods such as radiocarbon dating or other radiometric methods (in method based years before present - e.g. 14C years)",
            "facet_group_id":"2",
            "facet_type_id": 2,
            "category_id_expr": "tbl_geochronology.age",
            "category_id_type": "integer",
            "category_id_operator": "=",
            "category_name_expr": "tbl_geochronology.age",
            "sort_expr": "tbl_geochronology.age",
            "is_applicable": true,
            "is_default": false,
            "aggregate_type": "",
            "aggregate_title": "Number of samples",
            "aggregate_facet_code": "result_facet",
            "tables": [
                {
                    "sequence_id": 1,
                    "table_name": "tbl_geochronology",
                    "udf_call_arguments": null,
                    "alias":  null
                } ],
            "clauses": [  ]
        }
    ]

$facets$;

    j_facets = s_facets::jsonb;

    perform facet.create_or_update_facet(v.facet::jsonb)
    from jsonb_array_elements(j_facets) as v(facet);

end $$;
commit;
