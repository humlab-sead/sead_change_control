-- Deploy utility: 20190407_DDL_UTILITY_SYNC_ALL_SEQUENCES
/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-04-07
  Description   Resets all sequences to MAX value of parent column
  Issue        
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
*****************************************************************************************************************/

-- drop view if exists sead_utility.out_of_sync_sequences;
-- drop view if exists sead_utility.id_sequences;
-- drop function if exists sead_utility.get_max_sequence_id(p_table_schema text, p_table_name text, p_column_name text);
-- drop function if exists sead_utility.sync_sequences();
-- drop function if exists sead_utility.sync_sequences(text);
-- drop function if exists sead_utility.sync_sequences(text, text, text);
-- drop function if exists sead_utility.sync_sequence(p_schema_name character varying, p_table_name character varying, p_column_name character varying);


create or replace view sead_utility.column_sequences as 
	select  n.nspname as table_schema,
			t.relname as table_name,
			a.attname as column_name,
			q.nspname as sequence_namespace,
			s.relname as sequence_name
	from pg_class as s
	join pg_depend d on s.oid = d.objid
	join pg_class as t on t.oid = d.refobjid
	join pg_attribute a on a.attrelid = t.oid and d.refobjsubid = a.attnum
	join pg_namespace as n on n.oid = t.relnamespace
	join pg_namespace as q on q.oid = s.relnamespace
	where s.relkind = 'S'
	order by q.nspname, s.relname;

create or replace function sead_utility.get_max_sequence_id(p_table_schema text, p_table_name text, p_column_name text)
returns int as $$
	declare p_value int;
begin
	execute format('select max(%I) from %I.%I', p_column_name, p_table_schema, p_table_name) into p_value;
	return p_value;
end; $$ language 'plpgsql';


create or replace view sead_utility.out_of_sync_sequences as
	with sequence_counter_values as (
		select table_schema, table_name, column_name, sequence_namespace, sequence_name,
			coalesce(currval(pg_get_serial_sequence(format('%I.%I', table_schema, table_name), column_name)), 1) as current_value,
		    sead_utility.get_max_sequence_id(table_schema, table_name, column_name) as max_value
		from sead_utility.column_sequences
	)
	select table_schema, table_name, column_name, sequence_namespace, sequence_name, current_value, max_value
	from sequence_counter_values
	where current_value <> coalesce(max_value, current_value);


create or replace function sead_utility.sync_sequences(p_table_schema text = null, p_table_name text = null, p_column_name text = null)
returns void language 'plpgsql' as $BODY$
    declare sql record;
begin
	for sql in
        select format('select setval(''%I.%I'', greatest(coalesce(max(%I), 1), 1)) from %I.%I;', sequence_namespace, sequence_name, column_name, table_schema, table_name) as fix_query
        from sead_utility.column_sequences
        where table_schema = coalesce(p_table_schema, table_schema)
          and table_name = coalesce(p_table_name, table_name)
          and column_name = coalesce(p_column_name, column_name)
        order by sequence_name
    loop
		execute sql.fix_query;
	end loop;
end;
$BODY$;

create or replace function sead_utility.sync_sequence(p_schema_name character varying, p_table_name character varying, p_column_name character varying = NULL)
returns void language plpgsql as $$
    declare	v_sequence_name text;
begin

    if p_column_name is null then
        select column_name into p_column_name
        from sead_utility.column_sequences
        where table_schema = p_schema_name
          and table_name = p_table_name
        limit 1;
    end if;

    v_sequence_name = pg_get_serial_sequence(p_schema_name || '.' || p_table_name, p_column_name);
    if v_sequence_name is not null then
        execute (select format('select setval(''%s''::regclass, greatest(coalesce(max(%I), 1), 1)) from %s.%s', v_sequence_name, p_column_name, p_schema_name, p_table_name::regclass));
    else
        raise notice 'Column %.%.% has no sequence', p_schema_name, p_table_name, p_column_name;
    end if;
end;
$$;

