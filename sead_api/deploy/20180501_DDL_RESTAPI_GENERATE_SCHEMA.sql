-- Deploy sead_db_change_control:CSA_20180501_GENERATE_REST_API_SCHEMA to pg

/****************************************************************************************************************
  Change author
    Roger Mähler, 2018-06-12
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

-- Drop Schema If Exists postgrest_default_api;
-- Drop Role If Exists anonymous_rest_user;

BEGIN;

Do $$
Begin

    create schema if not exists postgrest_api authorization seadwrite;

    grant all on schema postgrest_api to johan;
    grant usage on schema postgrest_api to postgrest;
    grant usage on schema postgrest_api to postgrest_anon;
    grant all on schema postgrest_api to seadwrite;

End $$ language plpgsql;

Do $$
Begin
    If Not Exists (Select From pg_catalog.pg_roles Where rolname = 'anonymous_rest_user') Then
        Create Role anonymous_rest_user nologin;
        Grant anonymous_rest_user to humlab_admin, humlab_read;
    End If;

    Create Schema If Not Exists postgrest_default_api AUTHORIZATION humlab_read;

    Grant Usage On Schema postgrest_default_api, public To anonymous_rest_user, humlab_read, humlab_admin;
    Grant Select On All Tables in Schema postgrest_default_api To humlab_read, humlab_admin, anonymous_rest_user;
    Grant Execute On All Functions In Schema postgrest_default_api, public To humlab_read, humlab_admin, anonymous_rest_user;
    Grant Execute On All Functions In Schema public To anonymous_rest_user;
End $$ language plpgsql;

Do $$
    Declare x record;
    Declare entity_name text;
    Declare drop_sql text;
    Declare create_sql text;
    Declare owner_sql text;
Begin

    For x In (
        select distinct table_name
        from information_schema.tables
        where table_schema = 'public'
          and table_type = 'BASE TABLE'
    ) Loop

        entity_name = replace(x.table_name, 'tbl_', '');

        If entity_name Like '%entities' Then
            entity_name = replace(entity_name, 'entities', 'entity');
        ElseIf entity_name Like '%ies' Then
            entity_name = regexp_replace(entity_name, 'ies$', 'y');
        ElseIf Not entity_name Like '%status' Then
            entity_name = rtrim(entity_name, 's');
        End If;

        drop_sql = 'drop view if exists postgrest_default_api.' || entity_name || ';';
        create_sql = 'create or replace view postgrest_default_api.' || entity_name || ' as select * from public.' || x.table_name || ';';
        owner_sql = 'alter table postgrest_default_api.' || entity_name || ' owner to humlab_read;';

        Execute drop_sql;
        Execute create_sql;
        Execute owner_sql;

        Raise Notice 'Done: %', entity_name;

    End Loop;
End $$ language plpgsql;


COMMIT;
