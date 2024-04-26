-- Deploy sead_api: 20220831_DDL_NEW_DENDRO_FACETS
-- Active: 1661931903212@@humlabseadserv.srv.its.umu.se@5432@sead_development@facet

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2022-08-31
  Issue         https://github.com/humlab-sead/sead_change_control/issues/91
  Description   New dendro facets (see issue #91)
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

-- create or replace function facet.delete_facet(i_facet_id int) returns bool language 'plpgsql'
-- as $body$
-- 	declare j_tables json;
-- 	declare j_clauses json;
-- 	declare s_facet_code text;
-- 	declare i_aggregate_facet_id int = 0;
-- begin

-- 	s_facet_code = (select max(facet_code) from facet.facet where facet_id = i_facet_id);
-- 	raise notice 'facet code: %', i_facet_id;

-- 	if s_facet_code is null then
-- 		raise notice 'facet not found %', i_facet_id;
-- 		return false;
-- 	end if;

-- 	delete from facet.facet_clause where facet_id = i_facet_id;
-- 	delete from facet.facet_table where facet_id = i_facet_id;
-- 	delete from facet.facet_children where s_facet_code in (facet_code, child_facet_code);
-- 	delete from facet.facet_dependency where i_facet_id in (facet_id, dependency_facet_id);
-- 	delete from facet.facet where facet_id = i_facet_id;

-- 	return true;

-- end
-- $body$;

-- alter function facet.delete_facet(int)
--     owner to humlab_admin;

-- grant execute on function facet.delete_facet(int) to humlab_admin;

-- select facet.delete_facet(48);

/*
select group_description, count(distinct analysis_entity_id)
from tbl_sites s
join tbl_sample_groups sg using (site_id)
join tbl_sample_group_descriptions sgd using (sample_group_id)
join tbl_sample_group_description_types sgdt using (sample_group_description_type_id)
join tbl_physical_samples ps using (sample_group_id)
join tbl_analysis_entities ae using (physical_sample_id)
where sgd.sample_group_description_type_id = 60
group by group_description;
*/

begin;
do $$
declare s_facets text;
declare j_facets jsonb;
declare i_next_position int;
begin

    begin

        set search_path = facet, pg_catalog;
        set client_encoding = 'UTF8';

		s_facets = $facets$
        [

            {
                "facet_id": 48,
                "facet_code": "construction_type",
                "display_title": "Construction types",
                "description": "Construction types",
                "facet_group_id": "1",
                "facet_type_id": "1",
                "category_id_expr": "tbl_sample_group_descriptions.sample_group_description_id",
                "category_id_type": "integer",
                "category_name_expr": "tbl_sample_group_descriptions.group_description || ' ' || tbl_sample_groups.sample_group_name",
                "sort_expr": "tbl_sample_group_descriptions.group_description",
                "is_applicable": true,
                "is_default": false,
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
                        "table_name": "tbl_sample_group_descriptions",
                        "udf_call_arguments": null,
                        "alias":  null
                    },
                    {
                        "sequence_id": 3,
                        "table_name": "tbl_sample_group_description_types",
                        "udf_call_arguments": null,
                        "alias":  null
                    },
                    {
                        "sequence_id": 4,
                        "table_name": "tbl_sites",
                        "udf_call_arguments": null,
                        "alias":  null
                    },
                    {
                        "sequence_id": 5,
                        "table_name": "tbl_physical_samples",
                        "udf_call_arguments": null,
                        "alias":  null
                    }
                ],
                "clauses": [
                    {
                        "clause": "tbl_sample_group_descriptions.sample_group_description_type_id=60",
                        "enforce_constraint": true
                    } ]
            }
        ]

$facets$;

        j_facets = s_facets::jsonb;

        perform facet.create_or_update_facet(v.facet::jsonb)
        from jsonb_array_elements(j_facets) as v(facet);


    i_next_position = coalesce((select max(position) + 1 from facet.facet_children where facet_code = 'dendrochronology'), 0);

	insert into facet.facet_children (facet_code, child_facet_code, position)
		select 'dendrochronology', facet_code, position
		from facet.facet
		join (values
			('construction_type', i_next_position + 0)
		) as v(facet_code, position) using (facet_code)
		where is_applicable = TRUE
          on conflict (facet_code, child_facet_code)
          do nothing
          ;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
