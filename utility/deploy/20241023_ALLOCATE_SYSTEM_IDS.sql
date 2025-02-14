-- Deploy utility: 20241023_ALLOCATE_SYSTEM_IDS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-10-23
  Description   Helpful utilities for pre-allocating SEAD system IDs
  Issue         https://github.com/humlab-sead/sead_change_control/issues/322
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes         This script has been backported tp 20190401_DDL_UTILITY_SCHEMA
*****************************************************************************************************************/

-- begin;
-- do $block$
-- begin
--     create or replace function sead_utility.get_json_field(json_data jsonb, field_name text)
--         returns text as $udf$
--         declare
--             v_value text;
--         begin
--             if json_data is null then
--                 return null;
--             end if;
--             execute format('select $1->>%L', field_name)
--                 into v_value using json_data;
--             return result;
--         end;
--         $udf$ language plpgsql;
        
--     create or replace function sead_utility.rm_udfs_by_name(schema_name text, func_name text) 
--         returns void as $udf$
--         declare
--             r record;
--         begin
--             for r in
--                 select n.nspname as schema_name, p.proname as function_name,
--                     pg_catalog.pg_get_function_identity_arguments(p.oid) as arguments
--                 from pg_catalog.pg_proc p
--                 join pg_catalog.pg_namespace n on n.oid = p.pronamespace
--                 where p.proname = func_name
--                 and n.nspname = schema_name
--             loop
--                 execute format('drop function if exists %I.%I(%s);', r.schema_name, r.function_name, r.arguments);
--             end loop;
--         end $udf$ language plpgsql;

--     drop table if exists sead_utility.system_id_allocations;

--     create table if not exists sead_utility.system_id_allocations (
--         uuid UUID not null default uuid_generate_v4() primary key,
--         table_name text not null,
--         column_name text not null,
--         submission_identifier text not null,
--         change_request_identifier text not null,
--         external_system_id text null,
--         external_data JSON null,
--         alloc_system_id int not null
--     );

--     perform sead_utility.rm_udfs_by_name('sead_utility', 'get_next_system_id');
--     -- select sead_utility.get_next_system_id('tbl_sites', 'site_id') 
--     create or replace function sead_utility.get_next_system_id(p_table_name text, p_column_name text) 
--     /*
--     * Get the next SEAD system id for table "p_table_name" and column "p_column_name".
--     * The system id is allocated from the sead_utility.system_id_allocations table.
--     * If no system id has been allocated for the table and column, the function will return the maximum value of the column in the table.
--     */
--         returns integer as $udf$
--         declare
--             v_next_id integer;
--             v_query text;
--         begin
--             v_query := format('select max(%s) from %s', quote_ident(p_column_name), quote_ident(p_table_name));
--             -- raise notice '%', v_query;
--             execute v_query into v_next_id;

--             select max(system_id) into v_next_id
--             from (
--                 select coalesce(max(alloc_system_id), 0) as system_id
--                 from sead_utility.system_id_allocations
--                 where table_name = p_table_name
--                 and column_name = p_column_name
--                 union all
--                 values (v_next_id)
--             );
--             return v_next_id + 1;
--         end;
--         $udf$ language plpgsql;

-- 	perform sead_utility.rm_udfs_by_name('sead_utility', 'allocate_system_id');
	
--     create or replace function sead_utility.allocate_system_id(
--         p_submission_identifier text,
--         p_change_request_identifier text,
--         p_table_name text,
--         p_column_name text,
--         p_system_id text = NULL,
--         p_data jsonb = NULL
--     ) returns integer as $udf$
--         declare 
--             v_next_id int;
--         begin

--             v_next_id = sead_utility.get_next_system_id(p_table_name, p_column_name);
--             insert into sead_utility.system_id_allocations (
--                 table_name,
--                 column_name,
--                 submission_identifier,
--                 change_request_identifier,
--                 external_system_id,
--                 external_data,
--                 alloc_system_id
--             ) values (
--                 p_table_name,
--                 p_column_name,
--                 p_submission_identifier,
--                 p_change_request_identifier,
--                 p_system_id,
--                 p_data,
--                 v_next_id
--             );
--             return v_next_id;
--         end;
--         $udf$ language plpgsql;

--     create or replace function sead_utility.release_allocated_ids(
--         p_submission_identifier text,
--         p_change_request_identifier text=null,
--         p_table_name text=null,
--         p_column_name text=null
--     ) 
--         returns void as $udf$
--         begin
--             delete from sead_utility.system_id_allocations
--             where submission_identifier = p_submission_identifier   
--             and (p_change_request_identifier is null or change_request_identifier = p_change_request_identifier)
--             and (p_table_name is null or table_name = p_table_name)
--             and (p_column_name is null or column_name = p_column_name)
--             ;
--         end;
--         $udf$ language plpgsql;

--     create or replace function sead_utility.get_allocated_id(
--         p_submission_identifier text,
--         p_change_request_identifier text,
--         p_table_name text,
--         p_column_name text,
--         p_system_id text = NULL
--     ) 
--         returns integer as $udf$
--         declare
--             v_alloc_system_id integer;
--         begin

--             select max(alloc_system_id::int)
--                 into v_alloc_system_id
--                     from sead_utility.system_id_allocations
--                     where submission_identifier = p_submission_identifier
--                     and change_request_identifier = p_change_request_identifier
--                     and table_name = p_table_name
--                     and column_name = p_column_name
--                     and external_system_id = p_system_id
--             ;
--             return v_alloc_system_id;
--         end;
--         $udf$ language plpgsql;

-- end $block$;
-- commit;
