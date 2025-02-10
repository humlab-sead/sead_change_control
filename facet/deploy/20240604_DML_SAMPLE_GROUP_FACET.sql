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
  Notes         Backported to 20190101_DML_FACETS (#213)
*****************************************************************************************************************/

begin;

do $$
-- declare s_facets text;
-- declare j_facets jsonb;
begin

    raise notice 'Backported to 20190101_DML_FACETS (#213)';

--     set client_encoding = 'UTF8';

--     s_facets = $facets$
--     [
--         {
--             "facet_id": 13,
--             "facet_code": "sample_groups",
--             "display_title": "Sample groups",
--             "description": "A collection of samples, usually defined by the excavator or collector",
--             "facet_group_id":"2",
--             "facet_type_id": 1,
--             "category_id_expr": "tbl_sample_groups.sample_group_id",
--             "category_id_type": "integer",
--             "category_id_operator": "=",
--             "category_name_expr": "concat_ws(' ', tbl_sites.site_name, replace(tbl_sample_groups.sample_group_name, tbl_sites.site_name, ''))",
--             "sort_expr": "tbl_sample_groups.sample_group_name",
--             "is_applicable": true,
--             "is_default": true,
--             "aggregate_type": "count",
--             "aggregate_title": "Number of samples",
--             "aggregate_facet_code": "result_facet",
--             "tables": [
--                 {
--                     "sequence_id": 1,
--                     "table_name": "tbl_sample_groups",
--                     "udf_call_arguments": null,
--                     "alias":  null
--                 },
--                 {
--                     "sequence_id": 2,
--                     "table_name": "tbl_sites",
--                     "udf_call_arguments": null,
--                     "alias":  null
--                 }
--             ],
--             "clauses": [  ]
--         }
--     ]

-- $facets$;

--     j_facets = s_facets::jsonb;

--     perform facet.create_or_update_facet(v.facet::jsonb)
--     from jsonb_array_elements(j_facets) as v(facet);

end $$;
commit;
