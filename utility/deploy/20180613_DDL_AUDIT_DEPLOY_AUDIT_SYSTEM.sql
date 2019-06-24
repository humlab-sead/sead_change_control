-- Deploy sead_db_change_control:CSA_20180613_DEPLOY_AUDIT_SYSTEM to pg

BEGIN;

/****************************************************************************************************************
  Change author
        Roger Mähler, 2018-06-13
  Change description
        Field date_sampled in tbl_physical_samples has type "character varying", should be "timestamp with time zone"
  Risk assessment
    N/A
  Planning
  Change execution and rollback
    Apply this script.
    Steps to verify change: N/A
    Steps to rollback change: N/A
  Change prerequisites (e.g. tests)
  Change reviewer
  Change Approver Signoff
  Notes:
  Impact on dependent modules
    Changes must be propagated to Clearing House
*****************************************************************************************************************/

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
        alter default privileges for role humlab_admin in schema audit
            grant select on tables to sead_master, sead_read, humlab_admin, mattias, phil, humlab_read;

    end
$$;

/********************************************************************************************************
**  FUNCTION    sead_utility.audit_schema
**  WHO         Roger Mähler
**  WHAT        Adds DML audit triggers on all tables in schema
*********************************************************************************************************/
create or replace function sead_utility.audit_schema(p_table_schema text) returns void as $$
declare
   v_record record;
   v_table_name text;
   v_table_audit_view text;
begin

	for v_record in
		select  t.table_name
		from information_schema.tables t
		left join pg_trigger g
		  on not g.tgisinternal
		 and g.tgrelid = (t.table_schema || '.' || t.table_name)::regclass
		where t.table_schema = p_table_schema
		  and t.table_type = 'BASE TABLE'
		  and g.tgrelid is NULL
		order by 1
	loop
		v_table_name = p_table_schema || '.' || v_record.table_name;
		perform audit.audit_table(v_table_name);

        -- v_table_audit_view_sql = clearing_house.fn_script_audit_views(p_table_schema, v_record.table_name);
        -- Execute v_table_audit_view_sql;

		raise notice 'done: %', v_table_name;
	end loop;

end
$$ language plpgsql volatile;

/********************************************************************************************************
**  FUNCTION    sead_utility.fn_script_audit_views
**  WHO         Roger Mähler
**  WHAT        Script view DDL over audit HSTORE data for a specific table
*********************************************************************************************************/
-- DROP FUNCTION IF EXISTS sead_utility.fn_script_audit_views(character varying(255), character varying(255))
Create Or Replace Function sead_utility.fn_script_audit_views(source_schema character varying(255), p_table_name character varying(255)) Returns text As $$
	Declare v_template text;
	Declare v_view_name text;
	Declare v_view_dml text;
	Declare v_column_list text;
	Declare v_column_type text;
Begin

    v_view_name = Replace(p_table_name, 'tbl_', 'view_');

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

    WITH table_columns AS (
        SELECT column_name,
            clearing_house.fn_create_schema_type_string(data_type, character_maximum_length, numeric_precision, numeric_scale, 'YES') as column_type
        FROM clearing_house.fn_dba_get_sead_public_db_schema('public', 'sead_master') s
        WHERE s.table_schema = 'public'
        AND s.table_name = 'tbl_locations'
        ORDER BY ordinal_position
    )
        SELECT string_agg('(row_data->''' || column_name || ''')::' || replace(column_type, ' null', '') || ' AS ' || column_name, ', ' || CHR(13))
        INTO v_column_list
        FROM table_columns;

	v_view_dml := v_template;
	v_view_dml := replace(v_view_dml, '#VIEW-NAME#', v_view_name);
	v_view_dml := replace(v_view_dml, '#TABLE-NAME#', p_table_name);
	v_view_dml := replace(v_view_dml, '#COLUMN-LIST#', v_column_list);

	Return v_view_dml;

End $$ Language plpgsql;

create or replace function sead_utility.create_typed_audit_views(p_table_schema text = 'public') returns void as $$
declare
   v_record record;
   v_view_dml text;
begin

	for v_record in
		select  distinct t.table_name
		from information_schema.tables t
		join pg_trigger g
		  on not g.tgisinternal
		 and g.tgrelid = (t.table_schema || '.' || t.table_name)::regclass
		where t.table_schema = p_table_schema
		  and t.table_type = 'BASE TABLE'
		order by 1
	loop
        v_view_dml = sead_utility.fn_script_audit_views(p_table_schema, v_record.table_name);
        execute v_view_dml;
		raise notice 'done: %', v_record.table_name;
	end loop;

end
$$ language plpgsql volatile;

-- SELECT sead_utility.create_typed_audit_views('public');

commit;
