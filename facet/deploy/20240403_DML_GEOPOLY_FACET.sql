-- Deploy facet: 20240403_DML_GEOPOLY_FACET

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-04-03
  Description   See https://github.com/humlab-sead/sead_query_api/issues/94
  Issue         https://github.com/humlab-sead/sead_change_control/issues/268
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

    set search_path = facet, pg_catalog;
    set client_encoding = 'UTF8';

    update facet.facet_type set facet_type_name = 'geopolygon'
    	where facet_type_id = 3 and facet_type_name <> 'geopolygon';

    s_facets = $facets$
    [
        {
            "facet_id": 51,
            "facet_code": "sites_polygon",
            "display_title": "Sites (map)",
            "description": "General name for the excavation or sampling location",
            "facet_group_id":"2",
            "facet_type_id": 3,
            "category_id_expr": "tbl_sites.site_id",
            "category_id_type": "integer",
            "category_id_operator": "=",
            "category_name_expr": "tbl_sites.site_name",
            "sort_expr": "tbl_sites.site_name",
            "is_applicable": true,
            "is_default": true,
            "aggregate_type": "count",
            "aggregate_title": "Number of samples",
            "aggregate_facet_code": "result_facet",
            "tables": [
                {
                    "sequence_id": 1,
                    "table_name": "tbl_sites",
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

    insert into facet.facet_children (facet_code, child_facet_code, position)
        select facet_code, 'sites_polygon', position
        from  (values
            ('geoarchaeology', 99),
            ('archaeobotany', 99),
            ('dendrochronology', 99),
            ('palaeoentomology', 99),
            ('isotope', 99),
            ('pollen', 99),
            ('ceramic', 99)
        ) as v(facet_code, position)
            on conflict (facet_code, child_facet_code) do nothing;

end $$;
commit;