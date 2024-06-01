-- Deploy facet: 20240531_DML_ESTIMATED_FELLING_YEAR

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-05-31
  Description   Dendrochronology. New range intersect facet. 
  Issue         https://github.com/humlab-sead/sead_change_control/issues/287
                Moved from https://github.com/humlab-sead/sead_change_control/issues/269
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
            "facet_id": 56,
            "facet_code": "outermost_tree_ring_date",
            "display_title": "Outermost Tree Ring Date",
            "description": "Dendrochronology outermost tring ring date. Displays age ranges contained by selection.",
            "facet_group_id":"2",
            "facet_type_id": 4,
            "category_id_expr": "tbl_dendro_dates.age_range",
            "category_id_type": "int4range",
            "category_id_operator": "<@",
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
                }, {
                    "sequence_id": 2,
                    "table_name": "tbl_dendro_lookup",
                    "udf_call_arguments": null,
                    "alias":  null
                } 
            ],
            "clauses":  [
                    {
                        "clause": "tbl_dendro_lookup.dendro_lookup_id = 137",
                        "enforce_constraint": true
                    } ]
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
			('outermost_tree_ring_date', coalesce((select max(position) + 1 from facet.facet_children where facet_code = 'dendrochronology'), 0) + 0)
		) as v(facet_code, position) using (facet_code)
		where is_applicable = TRUE
          on conflict (facet_code, child_facet_code)
          do nothing
          ;

end $$;
commit;

