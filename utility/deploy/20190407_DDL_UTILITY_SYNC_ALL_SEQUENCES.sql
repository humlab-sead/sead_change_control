/*
**  Change request ID       ADMIN_SYNC_ALL_SEQUENCES
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

create or replace function sead_utility.sync_sequences() returns void language plpgsql as $$
declare
	sql record;
begin
	for sql in
        select 'select setval(' || quote_literal(quote_ident(pgt.schemaname) || '.'|| quote_ident(s.relname)) ||
                ', max(' || quote_ident(c.attname) || ') ) from ' || quote_ident(pgt.schemaname) || '.' || quote_ident(t.relname) || ';' as fix_query
		from pg_class as s, pg_depend as d, pg_class as t, pg_attribute as c, pg_tables as pgt
		where s.relkind = 'S'
		  and s.oid = d.objid
		  and d.refobjid = t.oid
		  and d.refobjid = c.attrelid
		  and d.refobjsubid = c.attnum
		  and t.relname = pgt.tablename
		order by s.relname
    loop
		execute sql.fix_query;
	end loop;
end;
$$;

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
        execute (select format('select setval(''%s''::regclass, max(%I)) from %s.%s', v_sequence_name, p_column_name, p_schema_name, p_table_name::regclass));
        -- raise notice 'Sequence %s updated', v_sequence_name;
    else
        raise notice 'Column %.%.% has no sequence', p_schema_name, p_table_name, p_column_name;
    end if;
end;
$$;

