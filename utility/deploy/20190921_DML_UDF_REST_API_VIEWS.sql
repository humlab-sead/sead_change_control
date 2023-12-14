-- Deploy utility: 20190921_DML_UDF_REST_API_VIEWS
/****************************************************************************************************************
  Change author
    Roger Mähler, 2022-09-21
  Change description
    New schema used for POSTGREST REST API publication of SEAD base table
  Risk assessment
  Planning
    Low risk
  Change execution and rollback
    Apply this script.
    Steps to verify change: N/A
    Steps to rollback change: N/A
  Change prerequisites (e.g. tests)
  Change reviewer
  Change Approver Signoff
  Notes:
  Impact on dependent modules
*****************************************************************************************************************/
Set client_min_messages = warning;

begin;

drop function if exists sead_utility.create_postgrest_default_api_view(p_table_name text);
drop function if exists sead_utility.create_postgrest_default_api_schema();

create or replace function sead_utility.create_postgrest_default_api_view(p_table_name text, p_schema_name text default 'postgrest_default_api') returns void as $$
    Declare entity_name text;
    Declare drop_sql text;
    Declare create_sql text;
    Declare owner_sql text;
Begin
    /*
        Create a default postgrest api view for given table.
    */
    entity_name = replace(p_table_name, 'tbl_', '');

    If entity_name Like '%entities' Then
        entity_name = replace(entity_name, 'entities', 'entity');
    ElseIf entity_name Like '%ies' Then
        entity_name = regexp_replace(entity_name, 'ies$', 'y');
    ElseIf Not entity_name Like '%status' Then
        entity_name = rtrim(entity_name, 's');
    End If;

    drop_sql = format('drop view if exists %s.%s;', p_schema_name, entity_name);
    create_sql = format('create or replace view %s.%s as select * from public.%s;', p_schema_name, entity_name, p_table_name);
    owner_sql = format('alter table %s.%s owner to humlab_read;', p_schema_name, entity_name);

    Execute drop_sql;
    Execute create_sql;
    Execute owner_sql;

    Raise Notice 'Done: %', entity_name;

End $$ language plpgsql;

create or replace function sead_utility.create_postgrest_default_api_schema(p_schema_name text default 'postgrest_default_api') returns void as $$
    Declare x record;
    Declare create_sql text;
    Declare grant_sql text;
Begin
    /*
        Create `postgrest_default_api` schema. Views for all tables are added to this schema.
    */

    if not exists(
            select schema_name
            from information_schema.schemata
            where schema_name = p_schema_name
        ) then

        if not exists (select from pg_catalog.pg_roles where rolname = 'anonymous_rest_user') then
            create role anonymous_rest_user nologin;
            grant anonymous_rest_user to humlab_admin, humlab_read;
        end if;

        create_sql = format('create schema if not exists %s authorization humlab_read', p_schema_name);

        grant_sql = format('
            grant usage on schema %1$s, public to anonymous_rest_user, humlab_read, humlab_admin;
            grant select on all tables in schema %1$s to humlab_read, humlab_admin, anonymous_rest_user;
            grant execute on all functions in schema %1$s, public to humlab_read, humlab_admin, anonymous_rest_user;
            grant execute on all functions in schema public to anonymous_rest_user;
        ', p_schema_name);

        execute grant_sql;

    end if;

    For x In (
        select distinct table_name
        from information_schema.tables
        where table_schema = 'public'
          and table_type = 'BASE TABLE'
    ) Loop
        perform sead_utility.create_postgrest_default_api_view(x.table_name, p_schema_name);
        Raise Notice 'Done: %', x.table_name;
    End Loop;
End $$ language plpgsql;


commit;

