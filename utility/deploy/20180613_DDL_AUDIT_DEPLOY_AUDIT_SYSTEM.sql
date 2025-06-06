-- Deploy utility: 20180613_DDL_AUDIT_DEPLOY_AUDIT_SYSTEM
/****************************************************************************************************************
  Author        Roger Mähler
  Date          2018-06-13
  Description   https://github.com/2ndQuadrant/audit-trigger
  Issue         https://github.com/humlab-sead/sead_change_control/issues/5
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
*****************************************************************************************************************/
begin;
-- STEP #1: Install audit-trigger
-- See https://wiki.postgresql.org/wiki/Audit_trigger_91plus
do $$
begin
    -- apply as humlab_admin: https://github.com/2ndquadrant/audit-trigger (audit.sql)
    create schema if not exists audit;

    grant usage on schema audit to humlab_admin;
    grant select on all tables in schema audit to humlab_admin;

    grant usage on schema audit to sead_master, sead_read, humlab_admin, humlab_read, phil, mattias, postgres;
    grant all on all tables in schema audit to sead_master, sead_read, humlab_admin, mattias, phil, postgres;
    alter default privileges for role humlab_admin in schema audit grant
    select
        on tables to sead_master, sead_read, humlab_admin, mattias, phil, humlab_read;

end
$$;

/********************************************************************************************************
 **  FUNCTION    sead_utility.audit_schema
 **  WHO         Roger Mähler
 **  WHAT        Adds DML audit triggers on all tables in schema
 *********************************************************************************************************/
create or replace function sead_utility.audit_schema(p_table_schema text)
    returns void
    as $$
declare
    v_record record;
    v_table_name text;
    v_table_audit_view text;
begin
    for v_record in
    select
        t.table_name
    from
        information_schema.tables t
    left join pg_trigger g on not g.tgisinternal
        and g.tgrelid =(t.table_schema || '.' || t.table_name)::regclass
where
    t.table_schema = p_table_schema
        and t.table_type = 'BASE TABLE'
        and g.tgrelid is null
    order by
        1 loop
            v_table_name = p_table_schema || '.' || v_record.table_name;
            perform
                audit.audit_table(v_table_name);
            -- v_table_audit_view_sql = clearing_house.fn_script_audit_views(p_table_schema, v_record.table_name);
            -- Execute v_table_audit_view_sql;
            raise notice 'done: %', v_table_name;
        end loop;

end
$$
language plpgsql
volatile;

/********************************************************************************************************
 **  FUNCTION    sead_utility.fn_script_audit_views
 **  WHO         Roger Mähler
 **  WHAT        Script view DDL over audit HSTORE data for a specific table
 *********************************************************************************************************/
-- DROP FUNCTION IF EXISTS sead_utility.fn_script_audit_views(character varying(255), character varying(255))
create or replace function sead_utility.fn_script_audit_views(source_schema character varying(255), p_table_name character varying(255))
    returns text
    as $$
declare
    v_template text;
    declare v_view_name text;
    declare v_view_dml text;
    declare v_column_list text;
    declare v_column_type text;
begin
    v_view_name = replace(p_table_name, 'tbl_', 'view_');

    v_template = '
    DROP VIEW IF EXISTS audit.#VIEW-NAME#;
    CREATE VIEW audit.#VIEW-NAME# AS
		SELECT #COLUMN-LIST#,
		transaction_id,
		action,
		session_user_name,
		action_tstamp_tx
		FROM audit.logged_actions
		WHERE table_name = ''#TABLE-NAME#''
	;';

    with table_columns as (
        select
            column_name,
            clearing_house.fn_create_schema_type_string(data_type, character_maximum_length, numeric_precision, numeric_scale, 'YES', null) as column_type
        from
            clearing_house.fn_dba_get_sead_public_db_schema('public', 'sead_master') s
        where
            s.table_schema = 'public'
            and s.table_name = 'tbl_locations'
        order by
            ordinal_position
)
    select
        string_agg('(row_data->''' || column_name || ''')::' || replace(column_type, ' null', '') || ' AS ' || column_name, ', ' || chr(13)) into v_column_list
    from
        table_columns;

    v_view_dml := v_template;
    v_view_dml := replace(v_view_dml, '#VIEW-NAME#', v_view_name);
    v_view_dml := replace(v_view_dml, '#TABLE-NAME#', p_table_name);
    v_view_dml := replace(v_view_dml, '#COLUMN-LIST#', v_column_list);

    return v_view_dml;

end
$$
language plpgsql;
create or replace function sead_utility.create_typed_audit_views(p_table_schema text = 'public')
    returns void
    as $$
declare
    v_record record;
    v_view_dml text;
begin
    for v_record in select distinct
        t.table_name
    from
        information_schema.tables t
        join pg_trigger g on not g.tgisinternal
            and g.tgrelid =(t.table_schema || '.' || t.table_name)::regclass
    where
        t.table_schema = p_table_schema
        and t.table_type = 'BASE TABLE'
    order by
        1 loop
            v_view_dml = sead_utility.fn_script_audit_views(p_table_schema, v_record.table_name);
            execute v_view_dml;
            raise notice 'done: %', v_record.table_name;
        end loop;
end
$$
language plpgsql
volatile;
-- SELECT sead_utility.create_typed_audit_views('public');
commit;

