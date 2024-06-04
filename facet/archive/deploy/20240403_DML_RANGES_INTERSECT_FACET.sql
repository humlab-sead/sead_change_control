-- Deploy facet: 20240403_DML_RANGES_INTERSECT_FACET

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-04-03
  Description   See https://github.com/humlab-sead/sead_query_api/issues/118 and https://github.com/humlab-sead/sead_query_api/issues/115
  Issue         https://github.com/humlab-sead/sead_change_control/issues/269
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

    s_facets = $facets$
    [
        {
            "facet_id": 53,
            "facet_code": "dendro_age_contained_by",
            "display_title": "Dendro chronology age ranges",
            "description": "Dendrochronology ages (contained by)",
            "facet_group_id":"2",
            "facet_type_id": 4,
            "category_id_expr": "tbl_dendro_dates.age_range",
            "category_id_type": "int4range",
            "category_id_operator": "@>",
            "category_name_expr": "tbl_dendro_dates.age_range",
            "sort_expr": "1",
            "is_applicable": true,
            "is_default": true,
            "aggregate_type": "count",
            "aggregate_title": "Number of samples",
            "aggregate_facet_code": "result_facet",
            "tables": [
                {
                    "sequence_id": 1,
                    "table_name": "tbl_dendro_dates",
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
		select 'dendrochronology', facet_code, position
		from facet.facet
		join (values
			('dendro_age_contained_by', coalesce((select max(position) + 1 from facet.facet_children where facet_code = 'dendrochronology'), 0) + 0)
		) as v(facet_code, position) using (facet_code)
		where is_applicable = TRUE
          on conflict (facet_code, child_facet_code)
          do nothing
          ;
          
end $$;
commit;


