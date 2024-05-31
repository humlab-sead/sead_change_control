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

    if not exists (select 1 from facet.facet_type where facet_type_id = 4) then
        insert into facet.facet_type (facet_type_id, facet_type_name, reload_as_target)
            values (4, 'rangesintersect', TRUE);
    end if;

    alter table public.tbl_analysis_entity_ages
        drop column if exists age_range;

	/* BP (Before Present), age_older >= age_younger */
    alter table public.tbl_analysis_entity_ages
        add column age_range int4range null
            generated always as (
                case when age_younger is null and age_older is null then null
                else int4range(
                    coalesce(age_younger::int, age_older::int),
                    coalesce(age_older::int, age_younger::int) + 1
                )
            	end) stored;


    alter table public.tbl_dendro_dates
        drop column if exists age_range;

	/* BCE/CE age_older <= age_younger */
    alter table public.tbl_dendro_dates
        add column age_range int4range null
            generated always as (
                case when age_younger is null and age_older is null then null
                else int4range(
                    coalesce(age_older::int, age_younger::int),
                    coalesce(age_younger::int, age_older::int) + 1
                )
            	end) stored;

	alter table facet.facet drop column if exists category_id_operator;

    alter table facet.facet
        add column if not exists category_id_operator varchar(40) not null DEFAULT ('=');

    s_facets = $facets$
    [
        {
            "facet_id": 52,
            "facet_code": "analysis_entity_ages",
            "display_title": "Analysis entity ages",
            "description": "Analysis entity ages (intersects)",
            "facet_group_id":"2",
            "facet_type_id": 4,
            "category_id_expr": "age_range",
            "category_id_type": "int4range",
            "category_id_operator": "&&",
            "category_name_expr": "age_range",
            "sort_expr": "1",
            "is_applicable": true,
            "is_default": true,
            "aggregate_type": "count",
            "aggregate_title": "Number of samples",
            "aggregate_facet_code": "result_facet",
            "tables": [
                {
                    "sequence_id": 1,
                    "table_name": "tbl_analysis_entity_ages",
                    "udf_call_arguments": null,
                    "alias":  null
                } ],
            "clauses": [  ]
        },
        {
            "facet_id": 53,
            "facet_code": "dendro_age_contained_by",
            "display_title": "Dendro chronology age ranges",
            "description": "Dendrochronology ages (contained by)",
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


