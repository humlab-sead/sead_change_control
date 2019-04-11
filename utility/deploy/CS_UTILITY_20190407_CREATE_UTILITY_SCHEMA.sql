-- Deploy sead_db_change_control:create_sead_utility_schema to pg

BEGIN;

    CREATE SCHEMA IF NOT EXISTS sead_utility;
    
    CREATE OR REPLACE FUNCTION sead_utility.schema_exists(p_schema_name text)
      RETURNS bool AS
    $$
        SELECT EXISTS (
            SELECT 1 FROM information_schema.schemata WHERE schema_name = p_schema_name;
        );
    $$  LANGUAGE sql;
    
SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'name';

    CREATE OR REPLACE FUNCTION sead_utility.table_exists(p_schema_name text, p_table_name text)
      RETURNS bool AS
    $$
        SELECT EXISTS (
            SELECT 1
            FROM pg_catalog.pg_class AS c
            JOIN pg_catalog.pg_namespace AS ns
              ON c.relnamespace = ns.oid
            WHERE c.oid::regclass::text = p_table_name
              AND ns.nspname = p_schema_name
        );
    $$  LANGUAGE sql;

    CREATE OR REPLACE FUNCTION sead_utility.column_exists(p_schema_name text, p_table_name text, p_column_name text)
      RETURNS bool AS
    $$
        SELECT EXISTS (
            SELECT 1
            FROM pg_catalog.pg_attribute AS a
            JOIN pg_catalog.pg_class AS c
              ON a.attrelid = c.oid
            JOIN pg_catalog.pg_namespace AS ns
              ON c.relnamespace = ns.oid
            WHERE c.oid::regclass::text = p_table_name
              AND a.attname = p_column_name
              AND ns.nspname = p_schema_name
              AND attnum > 0
        );
    $$  LANGUAGE sql;

COMMIT;
