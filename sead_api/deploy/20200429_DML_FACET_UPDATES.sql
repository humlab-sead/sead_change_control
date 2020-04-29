-- Deploy sead_api:20200429_DML_FACET_UPDATES to pg
/****************************************************************************************************************
  Author        Roger Mähler
  Date          2020
  Description
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

        set search_path = facet, pg_catalog;
        set client_encoding = 'UTF8';

		s_facets = $facets$
        [
            {
                "facet_id": 41,
                "facet_code": "region",
                "display_title": "Region",
                "description": "Region",
                "facet_group_id": "2",
                "facet_type_id": 1,
                "category_id_expr": "region.location_id ",
                "category_name_expr": "region.location_name || '  ' || tbl_sites.site_name",
                "sort_expr": "region.location_name",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_locations",
                        "udf_call_arguments": null,
                        "alias":  "region"
                    },
                    {
                        "sequence_id": 2,
                        "table_name": "tbl_site_locations",
                        "udf_call_arguments": null,
                        "alias":  null
                    },
                    {
                        "sequence_id": 3,
                        "table_name": "tbl_sites",
                        "udf_call_arguments": null,
                        "alias":  null
                    }
                ],
                "clauses": [ {
                    "clause": "region.location_type_id in (2, 7, 14, 16, 18)"
                } ]
            },
            {
                "facet_id": 34,
                "facet_code": "activeseason",
                "display_title": "Insect activity seasons",
                "description": "Insect activity seasons",
                "facet_group_id":"2",
                "facet_type_id": 1,
                "category_id_expr": "tbl_seasons.season_id",
                "category_name_expr": "tbl_seasons.season_name",
                "sort_expr": "tbl_seasons.season_type ",
                "is_applicable": true,
                "is_default": false,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                {
                    "sequence_id": 1,
                    "table_name": "tbl_seasons",
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

   exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
