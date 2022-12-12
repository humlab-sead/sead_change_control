-- Deploy sead_api:20220921_DML_UDF_REST_API_VIEWS from pg
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

create or replace function sead_utility.create_postgrest_default_api_view(p_table_name text) returns void as $$
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

    drop_sql = 'drop view if exists postgrest_default_api.' || entity_name || ';';
    create_sql = 'create or replace view postgrest_default_api.' || entity_name || ' as select * from public.' || p_table_name || ';';
    owner_sql = 'alter table postgrest_default_api.' || entity_name || ' owner to humlab_read;';

    Execute drop_sql;
    Execute create_sql;
    Execute owner_sql;

    Raise Notice 'Done: %', entity_name;

End $$ language plpgsql;

create or replace function sead_utility.create_postgrest_default_api_schema() returns void as $$
    Declare x record;
Begin
    /*
        Create `postgrest_default_api` schema. Views for all tables are added to this schema.
    */

    if not exists(
            select schema_name
            from information_schema.schemata
            where schema_name = 'postgrest_default_api'
        ) then

        if not exists (select from pg_catalog.pg_roles where rolname = 'anonymous_rest_user') then
            create role anonymous_rest_user nologin;
            grant anonymous_rest_user to humlab_admin, humlab_read;
        end if;

        create schema if not exists postgrest_default_api authorization humlab_read;

        grant usage on schema postgrest_default_api, public to anonymous_rest_user, humlab_read, humlab_admin;
        grant select on all tables in schema postgrest_default_api to humlab_read, humlab_admin, anonymous_rest_user;
        grant execute on all functions in schema postgrest_default_api, public to humlab_read, humlab_admin, anonymous_rest_user;
        grant execute on all functions in schema public to anonymous_rest_user;

    end if;

    For x In (
        select distinct table_name
        from information_schema.tables
        where table_schema = 'public'
          and table_type = 'BASE TABLE'
    ) Loop
        perform sead_utility.create_postgrest_default_api_view(x.table_name);
        Raise Notice 'Done: %', x.table_name;
    End Loop;
End $$ language plpgsql;


commit;

