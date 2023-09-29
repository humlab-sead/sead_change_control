/*
**  Change request ID       20190407_DDL_UTILITY_SYNC_ALL_SEQUENCES
**  Change request tag
**  Change origin
**  Description             Resets all sequences to MAX value of parent column
**  Motivation              Use whenever sequences are out-of-sync
**  Dependencies
**  Timestamp
**  Rollback                N/A
**  Commited
**  Idempotent              YES
**/

drop view if exists sead_utility.out_of_sync_sequences;
drop view if exists sead_utility.id_sequences;
drop function if exists sead_utility.get_max_sequence_id(p_table_schema text, p_table_name text, p_column_name text);
drop function if exists sead_utility.sync_sequences();
drop function if exists sead_utility.sync_sequences(text);
drop function if exists sead_utility.sync_sequences(text, text, text);
drop function if exists sead_utility.sync_sequence(p_schema_name character varying, p_table_name character varying, p_column_name character varying);


create or replace view sead_utility.id_sequences as
    /* Source: https://wiki.postgresql.org/wiki/Fixing_Sequences */
	select
			table_namespace.nspname as table_schema,
			class_table.relname as table_name,
			pg_attribute.attname as column_name,
			sequence_namespace.nspname as sequence_namespace,
			class_sequence.relname as sequence_name
	from pg_depend
	inner join pg_class as class_sequence
	  on class_sequence.oid = pg_depend.objid
	 and class_sequence.relkind = 'S'
	inner join pg_class as class_table
	  on class_table.oid = pg_depend.refobjid
	inner join pg_attribute
	  on pg_attribute.attrelid = class_table.oid
	 and pg_depend.refobjsubid = pg_attribute.attnum
	inner join pg_namespace as table_namespace
	  on table_namespace.oid = class_table.relnamespace
	inner join pg_namespace as sequence_namespace
	  on sequence_namespace.oid = class_sequence.relnamespace
	order by sequence_namespace.nspname, class_sequence.relname;


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
		from sead_utility.id_sequences
	)
	select table_schema, table_name, column_name, sequence_namespace, sequence_name, current_value, max_value
	from sequence_counter_values
	where current_value <> coalesce(max_value, current_value);


create or replace function sead_utility.sync_sequences(p_table_schema text = null, p_table_name text = null, p_column_name text = null)
returns void language 'plpgsql' as $BODY$
    declare sql record;
begin
	for sql in
        select format('select setval(''%I.%I'', coalesce(max(%I), 1) ) from %I.%I;', sequence_namespace, sequence_name, column_name, table_schema, table_name) as fix_query
        from sead_utility.id_sequences
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
        from sead_utility.id_sequences
        where table_schema = p_schema_name
          and table_name = p_table_name
        limit 1;
    end if;

    v_sequence_name = pg_get_serial_sequence(p_schema_name || '.' || p_table_name, p_column_name);
    if v_sequence_name is not null then
        execute (select format('select setval(''%s''::regclass, coalesce(max(%I), 1)) from %s.%s', v_sequence_name, p_column_name, p_schema_name, p_table_name::regclass));
    else
        raise notice 'Column %.%.% has no sequence', p_schema_name, p_table_name, p_column_name;
    end if;
end;
$$;

