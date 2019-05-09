-- Deploy sead_db_change_control:CREATE_TABLE_DEPENDENCY_VIEW to pg
-- requires: CREATE_UTILITY_SCHEMA

begin;

    create or replace view sead_utility.table_dependencies as (
            with recursive t as
             ( select c.oid                                 as origin_id,
                      c.oid::regclass::text                 as origin_table,
                      n.nspname                             as origin_schema,
                      c.oid                                 as referencing_id,
                      c.oid::regclass::text                 as referencing_table,
                      c2.oid                                as referenced_id,
                      c2.oid::regclass::text                as referenced_table, array[c.oid::regclass, c2.oid::regclass] as chain
              from pg_catalog.pg_constraint as co
              inner join pg_catalog.pg_class as c
                on c.oid = co.conrelid
              join pg_catalog.pg_namespace n
                on n.oid = c.relnamespace
              inner join pg_catalog.pg_class as c2
                on c2.oid = co.confrelid
              -- where c.oid::regclass::text = 'your table'
              union all select t.origin_id                  as origin_id,
                               t.origin_table               as origin_table,
                               t.origin_schema              as origin_schema,
                               t.referenced_id              as referencing_id,
                               t.referenced_table           as referencing_table,
                               c3.oid                       as referenced_id,
                               c3.oid::regclass::text       as referenced_table,
                               t.chain || c3.oid::regclass  as chain
              from pg_catalog.pg_constraint as co
              inner join pg_catalog.pg_class as c3
                on c3.oid = co.confrelid
              inner join t
                on t.referenced_id = co.conrelid
              where -- prevent infinite recursion by pruning paths where the last entry in the path already appears somewhere else in the path
                    -- "an array containing the last element" "is contained by" "a slice of the chain from element 1 to n-1"
                not ( array[ t.chain[array_upper(t.chain, 1)] ] <@  t.chain[1:array_upper(t.chain, 1) - 1] )
        ) select origin_table,
                 origin_schema,
                 referenced_table,
                 array_upper(chain,1) as "depth",
                 array_to_string(chain,',') as chain
      from t
    );

    create or replace view sead_utility.foreign_key_columns as (
        select
            tc.table_schema,
            tc.constraint_name,
            tc.table_name,
            kcu.column_name,
            ccu.table_schema as foreign_table_schema,
            ccu.table_name as foreign_table_name,
            ccu.column_name as foreign_column_name
        from
            information_schema.table_constraints as tc
            join information_schema.key_column_usage as kcu
              on tc.constraint_name = kcu.constraint_name
              and tc.table_schema = kcu.table_schema
            join information_schema.constraint_column_usage as ccu
              on ccu.constraint_name = tc.constraint_name
              and ccu.table_schema = tc.table_schema
        where tc.constraint_type = 'FOREIGN KEY'
    );

commit;
