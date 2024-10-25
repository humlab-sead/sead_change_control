-- Deploy utility: 20241025_STORE_VIEW_DEFINITIONS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-10-25
  Description   Helpful utilities for temporary drop of view
  Issue         https://github.com/humlab-sead/sead_change_control/issues/324
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin

    -- drop function sead_utility.store_view_definition(text,text)
    -- create table if not exists sead_utility.temp_view_definitions (
    --     schema_name text not null,
    --     view_name text not null,
    --     view_definition text not null,
    --     timestamp timestamp default now(),
    --     primary key (schema_name, view_name)
    -- );
    
    create or replace function sead_utility.store_view_definition(p_schema_name text, p_view_name text) returns void as $x$
    declare
        v_view_definition text;
    begin
        if not exists (
                select 1
                from pg_class c
                join pg_namespace n on n.oid = c.relnamespace
                where c.relname = 'temp_view_definitions'
                and n.nspname = 'sead_utility'
                and c.relkind = 'r'
            ) then
            create table if not exists sead_utility.temp_view_definitions (
                schema_name text not null,
                view_name text not null,
                view_definition text not null,
                timestamp timestamp default now(),
                primary key (schema_name, view_name)
            );
        end if;
        select pg_get_viewdef(format('%s.%s', p_schema_name, p_view_name), true) into v_view_definition;
        insert into sead_utility.temp_view_definitions (schema_name, view_name, view_definition)
            values (p_schema_name, p_view_name, v_view_definition)
            on conflict (schema_name, view_name) do update set view_definition = v_view_definition; 
    end;
    $x$ language plpgsql;
    
    
    create or replace function sead_utility.restore_view_definition(p_schema_name text, p_view_name text) returns void as $x$
    declare
        v_view_definition text;
    begin
        select view_definition
            into v_view_definition
        from sead_utility.temp_view_definitions
        where schema_name = p_schema_name
          and view_name = p_view_name;
        v_view_definition = format('CREATE OR REPLACE VIEW %s.%s AS %s', p_schema_name, p_view_name, v_view_definition);
        execute v_view_definition;
    end;
    $x$ language plpgsql;

end $$;
commit;
