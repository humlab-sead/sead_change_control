-- Deploy sead_api:20191012_DDL_FACET_MEASURED_VALUE_UDF to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin

    if current_database() not like 'sead_staging%' then
        raise exception 'this script must be run in sead_staging!';
    end if;

    if sead_utility.column_exists('facet'::text, 'facet_table'::text, 'table_name'::text) = true then
		alter table facet.facet_table rename column table_name to table_or_udf_name;
    end if;

    if not sead_utility.column_exists('facet'::text, 'facet_table'::text, 'udf_call_arguments'::text) = true then
		alter table facet.facet_table add column udf_call_arguments character varying(80) null;
    end if;

	update facet.facet
	    set category_id_expr = 'method_values.measured_value',
	        category_name_expr = 'method_values.measured_value',
	        icon_id_expr = 'method_values.measured_value',
	        sort_expr = 'method_values.measured_value'
	where facet_id = 3
	  and category_id_expr <> 'method_values.measured_value';

	update facet.facet_table
	    set table_or_udf_name = 'facet.method_measured_values',
	        alias = 'method_values',
	        udf_call_arguments =  case
				when facet_id = 3 then '(33, 0)'
				when facet_id = 4 then '(33, 82)'
				when facet_id = 5 then '(32, 0)'
				when facet_id = 6 then '(37, 0)'
				else null end
	where facet_id in (3, 4, 5, 6)
	  and sequence_id = 1
	  and alias <> 'method_values';

	with new_node (table_id, table_name) as (
	    values (149, 'facet.method_measured_values')
	)
	    insert into facet.graph_table (table_id, table_name)
	        select n.table_id, n.table_name
	        from new_node n
	        left join facet.graph_table r using (table_name)
	        where r.table_name is null;

	with new_edge (source_table_id, target_table_id, weight, source_column_name, target_column_name) as (
	    values (102, 149, 20, 'physical_sample_id', 'physical_sample_id')
	)
	    insert into facet.graph_table_relation (relation_id, source_table_id, target_table_id, weight, source_column_name, target_column_name)
	        select (select max(relation_id) + 1 from facet.graph_table_relation),
	                n.source_table_id, n.target_table_id, n.weight, n.source_column_name, n.target_column_name
	        from new_edge n
	        left join facet.graph_table_relation r using (source_table_id, target_table_id)
	        where r.source_table_id is null;

end $$;

commit;


begin;

	create or replace function facet.method_measured_values(p_dataset_method_id int, p_prep_method_id int)
	returns table (
	    physical_sample_id int,
	    -- analysis_entity_id int,
	    measured_value numeric(20,10)
	) as $$
	begin

	    return query
	        select distinct ae.physical_sample_id, /* mv.analysis_entity_id, */ mv.measured_value
	        from tbl_measured_values mv
	        join tbl_analysis_entities ae using (analysis_entity_id)
	        join tbl_datasets ds using (dataset_id)
	        left join tbl_analysis_entity_prep_methods pm using (analysis_entity_id)
	        where ds.method_id = p_dataset_method_id
	          and coalesce(pm.method_id, 0) = p_prep_method_id;

	end $$ language plpgsql;

commit;


/*
select ds.method_id as dataset_method_id, coalesce(aepm.method_id, 0) as prep_method_id, count(*)
from tbl_analysis_entities ae
join (select distinct analysis_entity_id from tbl_measured_values) as mv using (analysis_entity_id)
left join tbl_analysis_entity_prep_methods aepm using (analysis_entity_id)
join tbl_datasets ds using (dataset_id)
where ds.method_id is not null
group by ds.method_id, prep_method_id
order by ds.method_id
*/

/*
select ds.method_id as dataset_method_id, coalesce(aepm.method_id, 0) as prep_method_id, count(*)
from tbl_analysis_entities ae
join (select distinct analysis_entity_id from tbl_measured_values) as mv using (analysis_entity_id)
left join tbl_analysis_entity_prep_methods aepm using (analysis_entity_id)
join tbl_datasets ds using (dataset_id)
where ds.method_id is not null
group by ds.method_id, prep_method_id
order by ds.method_id
*/



