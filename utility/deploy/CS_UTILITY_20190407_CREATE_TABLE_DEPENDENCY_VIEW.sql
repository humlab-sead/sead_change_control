-- Deploy sead_db_change_control:CREATE_TABLE_DEPENDENCY_VIEW to pg
-- requires: CREATE_UTILITY_SCHEMA

BEGIN;


    CREATE OR REPLACE VIEW sead_utility.table_dependencies AS (
            WITH RECURSIVE t AS
             ( SELECT c.oid                                 AS origin_id,
                      c.oid::regclass::text                 AS origin_table,
                      n.nspname                             AS origin_schema,
                      c.oid                                 AS referencing_id,
                      c.oid::regclass::text                 AS referencing_table,
                      c2.oid                                AS referenced_id,
                      c2.oid::regclass::text                AS referenced_table, ARRAY[c.oid::regclass, c2.oid::regclass] AS chain
              FROM pg_catalog.pg_constraint AS co
              INNER JOIN pg_catalog.pg_class AS c
                ON c.oid = co.conrelid
              JOIN pg_catalog.pg_namespace n
                ON n.oid = c.relnamespace
              INNER JOIN pg_catalog.pg_class AS c2
                ON c2.oid = co.confrelid
              -- WHERE c.oid::regclass::text = 'YOUR TABLE'
              UNION ALL SELECT t.origin_id                  AS origin_id,
                               t.origin_table               AS origin_table,
                               t.origin_schema              AS origin_schema,
                               t.referenced_id              AS referencing_id,
                               t.referenced_table           AS referencing_table,
                               c3.oid                       AS referenced_id,
                               c3.oid::regclass::text       AS referenced_table,
                               t.chain || c3.oid::regclass  AS chain
              FROM pg_catalog.pg_constraint AS co
              INNER JOIN pg_catalog.pg_class AS c3
                ON c3.oid = co.confrelid
              INNER JOIN t
                ON t.referenced_id = co.conrelid
              WHERE -- prevent infinite recursion by pruning paths where the last entry in the path already appears somewhere else in the path
                    -- "an array containing the last element" "is contained by" "a slice of the chain from element 1 to n-1"
                NOT ( ARRAY[ t.chain[array_upper(t.chain, 1)] ] <@  t.chain[1:array_upper(t.chain, 1) - 1] )
        ) SELECT origin_table,
                 origin_schema,
                 referenced_table,
                 array_upper(chain,1) AS "depth",
                 array_to_string(chain,',') as chain
      FROM t
    );

    CREATE OR REPLACE VIEW sead_utility.foreign_key_columns AS (
        SELECT
            tc.table_schema, 
            tc.constraint_name, 
            tc.table_name, 
            kcu.column_name, 
            ccu.table_schema AS foreign_table_schema,
            ccu.table_name AS foreign_table_name,
            ccu.column_name AS foreign_column_name 
        FROM 
            information_schema.table_constraints AS tc 
            JOIN information_schema.key_column_usage AS kcu
              ON tc.constraint_name = kcu.constraint_name
              AND tc.table_schema = kcu.table_schema
            JOIN information_schema.constraint_column_usage AS ccu
              ON ccu.constraint_name = tc.constraint_name
              AND ccu.table_schema = tc.table_schema
        WHERE tc.constraint_type = 'FOREIGN KEY'
    );
                                     
COMMIT;
