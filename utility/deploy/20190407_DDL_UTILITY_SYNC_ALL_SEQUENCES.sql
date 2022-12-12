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

CREATE OR REPLACE FUNCTION sead_utility.sync_sequences(
	)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
declare
	sql record;
begin

	for sql in
		select format('select setval(pg_get_serial_sequence(''%I.%I'', ''%I''), coalesce(max(%I), 1)) from %I.%I;',
			table_schema, table_name, column_name, column_name, table_schema, table_name) as fix_query
		from information_schema.columns
		where column_default like 'nextval%'
		order by table_schema, table_name, column_name

    loop
		execute sql.fix_query;
		--raise notice '%', sql.fix_query;
	end loop;
end;
$BODY$;

create or replace function sead_utility.sync_sequence(p_schema_name character varying, p_table_name character varying, p_column_name character varying = NULL) returns void language plpgsql as $$
declare
	v_sequence_name text;
begin
    assert p_schema_name is not null;
    if p_column_name is NULL then
        select a.attname into p_column_name
        from pg_index i
        join pg_class cr on (cr.oid = i.indrelid)
        join pg_attribute a on (a.attrelid = cr.oid)
        join pg_namespace ns on cr.relnamespace = ns.oid
        where i.indisprimary
          and ns.nspname = p_schema_name
          and cr.relname = p_table_name
          and exists (select from unnest(i.indkey) p(c) where p.c = a.attnum)
        limit 1;
    end if;

    v_sequence_name = pg_get_serial_sequence(p_schema_name || '.' || p_table_name, p_column_name);
    if v_sequence_name is not null then
        execute (select format('select setval(''%s''::regclass, coalesce(max(%I), 1)) from %s.%s', v_sequence_name, p_column_name, p_schema_name, p_table_name::regclass));
        -- raise notice 'Sequence %s updated', v_sequence_name;
    else
        raise notice 'Column %.%.% has no sequence', p_schema_name, p_table_name, p_column_name;
    end if;
end;
$$;

