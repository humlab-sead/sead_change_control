/*
**  Change request ID       SEAD_CR_00000
**  Change request tag
**  Change origin
**  Description             Assign "owned by column" to all public sequences
**                          I.e. makes all incrementals local to specific table column
**  Motivation              Enables sequence auto removal
**  Dependencies
**  Timestamp
**  Rollback                Execute OWNED BY NONE for each table
**  Commited
**  Idempotent              YES
**/

DO $$
DECLARE
  v_schema_name varchar;
  v_table_name varchar;
  v_column_name varchar;
  v_sequence_name varchar;
  v_sql varchar;
BEGIN

    FOR v_schema_name, v_table_name, v_column_name, v_sequence_name IN
        WITH candidates AS (
            SELECT table_schema, table_name, column_name, pg_get_serial_sequence(table_schema || '.' || table_name, column_name) as sequence_name
            FROM information_schema.columns
            WHERE table_schema = 'public'
              AND data_type = 'integer'
              AND column_default like 'nextval%'
        )
            SELECT table_schema, table_name, column_name, sequence_name
            FROM candidates c
            WHERE sequence_name is not null
    LOOP
        v_sql = 'ALTER SEQUENCE IF EXISTS ' || v_sequence_name || ' OWNED BY "' || v_schema_name || '"."' || v_table_name || '"."' || v_column_name || '";';
        EXECUTE v_sql;
        -- IF substr(v_sequence_name, LENGTH(v_schema_name) + 2) <> (v_table_name || '_' || v_column_name || '_seq') THEN
        --     RAISE NOTICE '% != %', substr(v_sequence_name, LENGTH(v_schema_name) + 2), (v_table_name || '_' || v_column_name || '_seq') ;
        -- END IF;
        -- RAISE NOTICE '%', v_sql;
    END LOOP;

END $$ LANGUAGE plpgsql;
