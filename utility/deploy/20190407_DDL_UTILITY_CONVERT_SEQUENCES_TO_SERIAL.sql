-- Deploy utility: 20190407_DDL_UTILITY_CONVERT_SEQUENCES_TO_SERIAL
/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-04-07
  Description   Assign an "owned by" column to all public sequences
  Issue        
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Note          Assign "owned by column" to all public sequences
                I.e. makes all incrementals local to specific table column
                Enables sequence auto removal
  Rollback      Execute OWNED BY NONE for each table
*****************************************************************************************************************/


do $$
declare
  v_schema_name varchar;
  v_table_name varchar;
  v_column_name varchar;
  v_sequence_name varchar;
  v_sql varchar;
begin

    for v_schema_name, v_table_name, v_column_name, v_sequence_name in
        with candidates as (
            select table_schema, table_name, column_name, pg_get_serial_sequence(table_schema || '.' || table_name, column_name) as sequence_name
            from information_schema.columns
            where table_schema = 'public'
              and data_type = 'integer'
              and column_default like 'nextval%'
        )
            select table_schema, table_name, column_name, sequence_name
            from candidates c
            where sequence_name is not null
    loop
        v_sql = 'alter sequence if exists ' || v_sequence_name || ' owned by "' || v_schema_name || '"."' || v_table_name || '"."' || v_column_name || '";';
        execute v_sql;
        -- if substr(v_sequence_name, length(v_schema_name) + 2) <> (v_table_name || '_' || v_column_name || '_seq') then
        --     raise notice '% != %', substr(v_sequence_name, length(v_schema_name) + 2), (v_table_name || '_' || v_column_name || '_seq') ;
        -- end if;
        -- raise notice '%', v_sql;
    end loop;

end $$ language plpgsql;
