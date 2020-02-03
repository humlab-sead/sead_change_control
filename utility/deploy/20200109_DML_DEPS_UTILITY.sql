-- Deploy utility:20200109_DML_DEPS_UTILITY to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2020-01-09
  Description
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

create or replace function table_dependency_levels()
returns table (
	schema_name text,
	table_name text,
	level int
) as $$
declare
	v_level int;
	v_count int;
begin

	drop table if exists table_level;
	drop view  if exists all_fks_aggs;
	drop view  if exists all_tables;
	drop view  if exists all_fks;

	create temporary view all_tables as (
		select s.nspname as schema_name, p.relname as table_name
		from pg_class p
		join pg_namespace s on s.oid = p.relnamespace
		where true
		  and p.relkind = 'r'
		  and s.nspname = 'public'
	);

	create temporary view all_fks as (
		select rs.nspname as schema_name, ref.relname as table_name, p.relname as referenced_table_name
		from pg_class ref
		join pg_namespace rs on rs.oid = ref.relnamespace
		join pg_constraint c on c.contype = 'f' and c.conrelid = ref.oid
		join pg_class p on p.oid = c.confrelid
		join pg_namespace s on s.oid = p.relnamespace
		where true
		  and rs.nspname = 'public'
		  and ref.relname <> p.relname
	);

	create temporary view all_fks_aggs as
		select table_name, array_agg(referenced_table_name) as referenced_table_names
		from all_fks
		group by table_name;

	create temporary table table_level as

		/* All tables with no dependendencies */
		select t.schema_name::text as schema_name, t.table_name::text as table_name, 0::int as level
		from all_tables t
		left join all_fks r
		  on t.schema_name = r.schema_name
		 and t.table_name = r.table_name
		where r.table_name is null;

	v_level = 0;

	loop

		v_level = v_level + 1;

		insert into table_level
			with processed_count as (
				select f.schema_name, f.table_name
				from all_fks f
				left join table_level x
				  on x.schema_name = f.schema_name
				 and x.table_name = f.referenced_table_name
				group by f.schema_name, f.table_name
				having count(f.referenced_table_name) = count(x.table_name)
			) select processed_count.schema_name, processed_count.table_name, v_level
			  from processed_count
			  left join table_level using (schema_name, table_name)
			  where table_level.table_name is null;


		get diagnostics v_count = row_count;

		exit when v_count = 0 or v_level = 10;

		-- raise notice '%', v_level;

	end loop;

	return query
		select t.schema_name, t.table_name, t.level
		from table_level t;

end $$ language plpgsql;

