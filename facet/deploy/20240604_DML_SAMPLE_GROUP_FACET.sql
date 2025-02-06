-- Deploy facet: 20240604_DML_SAMPLE_GROUP_FACET

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-06-04
  Description   Add site name to displayed text
  Issue         https://github.com/humlab-sead/sead_change_control/issues/301
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
        where i_shortcut_id in (source_table_id, target_table_id;

    i_relation_id = (select max(table_relation_id) from facet.table_relation) + 1;

    insert into facet.table_relation (table_relation_id, source_table_id, target_table_id, weight, source_column_name, target_column_name)
        values
            (i_relation_id    , i_shortcut_id, 109, 200, 'taxon_id', 'taxon_id'),
            (i_relation_id + 1, i_shortcut_id,   4, 200, 'analysis_entity_id', 'analysis_entity_id')
            on conflict (table_relation_id) do nothing;

    drop view if exists facet.geochronology_taxa_shortcut;

    create or replace view facet.geochronology_taxa_shortcut as
        with geochronology_taxa as (
            select aeg.analysis_entity_id, t.taxon_id
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
            "facet_id": 13,
            "facet_code": "sample_groups",
            "display_title": "Sample groups",
            "description": "A collection of samples, usually defined by the excavator or collector",
            "facet_group_id":"2",
            "facet_type_id": 1,
            "category_id_expr": "tbl_sample_groups.sample_group_id",
            "category_id_type": "integer",
            "category_id_operator": "=",
            "category_name_expr": "concat_ws(' ', tbl_sites.site_name, replace(tbl_sample_groups.sample_group_name, tbl_sites.site_name, ''))",
            "sort_expr": "tbl_sample_groups.sample_group_name",
            "is_applicable": true,
            "is_default": true,
            "aggregate_type": "count",
            "aggregate_title": "Number of samples",
            "aggregate_facet_code": "result_facet",
            "tables": [
                {
                    "sequence_id": 1,
                    "table_name": "tbl_sample_groups",
                    "udf_call_arguments": null,
                    "alias":  null
                },
                {
                    "sequence_id": 2,
                    "table_name": "tbl_sites",
                    "udf_call_arguments": null,
                    "alias":  null
                }
            ],
            "clauses": [  ]
        }
    ]

$facets$;

    j_facets = s_facets::jsonb;

    perform facet.create_or_update_facet(v.facet::jsonb)
    from jsonb_array_elements(j_facets) as v(facet);

end $$;
commit;
