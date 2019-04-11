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

DO $BODY$
DECLARE
	sql record;
BEGIN
	FOR sql in SELECT 'SELECT SETVAL(' ||
				quote_literal(quote_ident(PGT.schemaname) ||
				'.'||quote_ident(S.relname)) ||
				', MAX(' ||quote_ident(C.attname)||
				') ) FROM ' ||
				quote_ident(PGT.schemaname)|| '.'||quote_ident(T.relname)|| ';' as fix_query
			FROM pg_class AS S, pg_depend AS D, pg_class AS T, pg_attribute AS C, pg_tables AS PGT
			WHERE S.relkind = 'S'
			    AND S.oid = D.objid
			    AND D.refobjid = T.oid
			    AND D.refobjid = C.attrelid
			    AND D.refobjsubid = C.attnum
			    AND T.relname = PGT.tablename
			ORDER BY S.relname LOOP
		EXECUTE sql.fix_query;
	END LOOP;
END;
$BODY$;