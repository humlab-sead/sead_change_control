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
		where s.relkind = 's'
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
                                                                                                  
                                                                                                  