-- Deploy facet: 20240327_DML_FACET_LOCATION_TYPE

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-03-27
  Description   New location type facet
  Issue         https://github.com/humlab-sead/sead_change_control/issues/261
                https://github.com/humlab-sead/sead_query_api/issues/117
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
declare v_facet_id int;
begin

    begin

        set search_path = facet, pg_catalog;
        set client_encoding = 'UTF8';
	
		s_facets = $facets$
        [
            {
                "facet_id": 50,
                "facet_code": "location_types",
                "display_title": "Location type",
                "description": "Type of location",
                "facet_group_id":"2",
                "facet_type_id": 1,
                "category_id_expr": "tbl_location_types.location_type_id",
                "category_id_type": "integer",
                "category_id_operator": "=",
                "category_name_expr": "tbl_location_types.location_type",
                "sort_expr": "tbl_location_types.location_type",
                "is_applicable": true,
                "is_default": true,
                "aggregate_type": "count",
                "aggregate_title": "Number of samples",
                "aggregate_facet_code": "result_facet",
                "tables": [
                    {
                        "sequence_id": 1,
                        "table_name": "tbl_location_types",
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

        insert into facet.facet_children(facet_code, child_facet_code, position)
            select f.facet_code, 'location_types', coalesce((select max(position) + 1 from facet.facet_children x where x.facet_code = f.facet_code), 0)
            from facet.facet f
            left join facet.facet_children x
              on x.facet_code = f.facet_code
             and x.child_facet_code = 'location_types'
            where f.facet_group_id = 999
              and x.facet_code is null;


    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;