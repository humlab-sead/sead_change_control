-- Deploy facet: 20240601_DML_RRB_SYSTEMS_FACET
/****************************************************************************************************************
Author        Roger Mähler
Date          2024-06-01
Description   Add location name to displayed text
Issue         https://github.com/humlab-sead/sead_change_control/issues/115
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

    set client_encoding = 'UTF8';

    -- Update weight to 25 for tbl_rdb_systems (143) -> tbl_locations (35)
    update facet.table_relation
        set weight = 25
        where source_table_id = 143 and target_table_id = 35;

    s_facets = $facets$
    [
        {
            "facet_id": 43,
            "facet_code": "rdb_systems",
            "display_title": "RDB system",
            "description": "RDB system",
            "facet_group_id":"1",
            "facet_type_id": 1,
            "category_id_expr": "tbl_rdb_systems.rdb_system_id",
            "category_id_type": "integer",
            "category_id_operator": "=",
            "category_name_expr": "concat_ws(' ', tbl_rdb_systems.rdb_system, tbl_locations.location_name)",
            "sort_expr": "tbl_rdb_systems.rdb_system",
            "is_applicable": true,
            "is_default": false,
            "aggregate_type": "count",
            "aggregate_title": "Number of samples",
            "aggregate_facet_code": "result_facet",
            "tables": [
                {
                    "sequence_id": 1,
                    "table_name": "tbl_rdb_systems",
                    "udf_call_arguments": null,
                    "alias":  null
                },
                {
                    "sequence_id": 2,
                    "table_name": "tbl_locations",
                    "udf_call_arguments": null,
                    "alias":  null
                }],
            "clauses": [  ]
        }
    ]

$facets$;

    j_facets = s_facets::jsonb;

    perform facet.create_or_update_facet(v.facet::jsonb)
    from jsonb_array_elements(j_facets) as v(facet);

end $$;


commit;