
/*****************************************************************************************************************************
**	Function	fn_rdb_schema_script_table
**	Who			Roger Mähler
**	When		2013-10-17
**	What		Create type string based on schema type fields.
**	Revisions
******************************************************************************************************************************/
-- Select clearing_house.fn_create_schema_type_string('character varying', 255, null, null, 'YES')
create or replace function clearing_house.fn_create_schema_type_string(
	data_type character varying(255),
	character_maximum_length int,
	numeric_precision int,
	numeric_scale int,
	is_nullable character varying(10),
  column_default text = null
) returns text as $$
	declare type_string text;
begin
	type_string :=  data_type
		||	case
          when data_type = 'character varying' and coalesce(character_maximum_length, 0) > 0
            then '(' || coalesce(character_maximum_length::text, '255') || ')'
				  when data_type = 'numeric'
            then
              case
                when numeric_precision is null and numeric_scale is null then  ''
                when numeric_scale is null then  '(' || numeric_precision::text || ')'
                else '(' || numeric_precision::text || ', ' || numeric_scale::text || ')'
              End
				  else ''
        end || ' ' ||
          case
            when coalesce(is_nullable,'') = 'YES'
              then 'null'
            else 'not null'
          end ||
          case
            when coalesce(column_default, '') != '' then ' default ' || column_default
            when data_type = 'uuid' then ' default uuid_generate_v4()'
            else ''
          end
        ;
	return type_string;

end $$ language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_script_public_db_entity_table
**	Who			Roger Mähler
**	When		2018-06-25
**	What		Creates new CHDB tables based on SEAD information_schema.catalog
**					- All columns in SEAD catalog is included, and using the same data_types and null attribute
**					- CHDB specific columns submission_id and source_id (LDB or PDB) is added
**					- XML attribute "id" is mapped to CHDB field "local_db_id"
**					- XML attribute "cloned_id" is mapped to CHDB field "public_db_id"
**					- PK in new table is submission_id + source_id + "PK:s in Local DB'
**  Uses
**  Used By
**	Revisions   2018-06-25 / removed loop
**	TODO		Add keys on foreign indexes to improve performance.
******************************************************************************************************************************/
-- Select clearing_house.fn_script_public_db_entity_table('public', 'clearing_house', 'tbl_sites')
create or replace function clearing_house.fn_script_public_db_entity_table(p_source_schema character varying(255), p_target_schema character varying(255), p_table_name character varying(255)) Returns text As $$
	Declare sql_stmt text;
	Declare data_columns text;
	Declare pk_columns text;
Begin

    Select string_agg(column_name || ' ' || clearing_house.fn_create_schema_type_string(data_type, character_maximum_length, numeric_precision, numeric_scale, is_nullable, column_default), E',\n        ' ORDER BY ordinal_position ASC),
           string_agg(Case When is_pk = 'YES' Then column_name Else Null End, E', ' ORDER BY ordinal_position ASC)
    Into Strict data_columns, pk_columns
    From clearing_house.fn_dba_get_sead_public_db_schema('public', 'sead_master') s
    Where s.table_schema = p_source_schema
      And s.table_name = p_table_name;

    -- ASSERT NOT pk_columns IS NULL;

	sql_stmt = format('Create Table %I.%I (

        %s,

        submission_id int not null,
        source_id int not null,
        local_db_id int not null,
        public_db_id int null,

        transport_type clearing_house.transport_type,
        transport_date timestamp with time zone,
        transport_id int,

        Constraint pk_%s Primary Key (submission_id, source_id, %s)

	);
    Create Index idx_%s_submission_id_public_id On %I.%I (submission_id, public_db_id);',
        p_target_schema, p_table_name, data_columns, p_table_name, pk_columns,
        p_table_name, p_target_schema, p_table_name);

	Return sql_stmt;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_create_public_db_entity_tables
**	Who			Roger Mähler
**	When		2013-10-14
**	What		Creates a local copy in schema clearing_house of all public db entity tables
**  Note
**  Uses
**  Used By
**	Revisions
******************************************************************************************************************************/
-- Select clearing_house.fn_create_public_db_entity_tables('clearing_house')
-- Select * From clearing_house.tbl_clearinghouse_sead_create_table_log
create or replace function clearing_house.fn_create_public_db_entity_tables(
    target_schema character varying(255),
    p_only_drop BOOLEAN = FALSE,
    p_dry_run BOOLEAN = TRUE
) Returns void As $$
	Declare x RECORD;
	Declare create_script text;
	Declare drop_script text;
Begin
    If Not p_dry_run Then
        Create Table If Not Exists clearing_house.tbl_clearinghouse_sead_create_table_log (
            create_log_id SERIAL PRIMARY KEY,
            create_script text,
            drop_script text,
            date_updated timestamp with time zone DEFAULT now()
        );
        Delete From clearing_house.tbl_clearinghouse_sead_create_table_log;
    End If;
	For x In (
		Select distinct table_schema As source_schema, table_name
		From clearing_house.fn_dba_get_sead_public_db_schema('public', 'sead_master')
	)
	Loop
        drop_script := format('Drop Table If Exists %I.%I CASCADE;', target_schema, x.table_name);
        create_script := clearing_house.fn_script_public_db_entity_table(x.source_schema::text, target_schema, x.table_name::text);
        If p_dry_run Then
            Raise Notice '%', drop_script;
            Raise Notice '%', create_script;
        Else
            Execute drop_script;
            If Not p_only_drop Then
                Execute create_script;
            End If;
            Insert Into clearing_house.tbl_clearinghouse_sead_create_table_log (create_script, drop_script) Values (create_script, drop_script);
        End If;
	End Loop;
End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_create_local_public_primary_key_view
**	Who			Roger Mähler
**	When		2018-06-15
**	What		Fast lookup of public_db_id given submission_id, local_db_id to public_db_id
**  Note        Is a MTERIALIZED view that MUST BE UPDATED!
**  Uses
**  Used By     Transfer CH-data to SEAD module
**	Revisions
******************************************************************************************************************************/

create or replace function clearing_house.fn_create_local_to_public_id_view() RETURNS VOID AS $$
declare v_sql text;
begin

	SELECT string_agg(' SELECT submission_id, ''' || table_name || ''' as table_name, local_db_id, public_db_id from clearing_house.' || table_name || '', E'  \nUNION ')
		INTO STRICT v_sql
	FROM clearing_house.fn_dba_get_sead_public_db_schema('public', 'sead_master')
	WHERE table_name LIKE 'tbl%'
	  AND is_pk = 'YES';

	v_sql = E'
		drop view if exists clearing_house.view_local_to_public_id;
		create materialized view clearing_house.view_local_to_public_id as \n' || v_sql	|| ';
		drop index if exists idx_view_local_to_public_id;
		create index idx_view_local_to_public_id on clearing_house.view_local_to_public_id (submission_id, table_name, local_db_id);';

	EXECUTE v_sql;

END;
$$ LANGUAGE plpgsql;

-- SELECT clearing_house.fn_create_local_to_public_id_view();
-- create or replace function clearing_house.fn_local_to_public_id(int,varchar,int) RETURNS INT
-- 	AS 'SELECT public_db_id FROM clearing_house.view_local_to_public_id WHERE submission_id = $1 and table_name = $2 and local_db_id = $3; '
-- 	LANGUAGE SQL STABLE RETURNS NULL ON NULL INPUT;

-- REFRESH MATERIALIZED VIEW clearing_house.view_local_to_public_id;

/*****************************************************************************************************************************
**	Function	fn_add_new_public_db_columns
**	Who			Roger Mähler
**	When		2013-10-14
**	What		Adds missing columns found in public db to local entity table
**  Note
**  Uses
**  Used By
**	Revisions
******************************************************************************************************************************/
-- Select clearing_house.fn_add_new_public_db_columns(2, 'tbl_datasets')
create or replace function clearing_house.fn_add_new_public_db_columns(
    p_submission_id int, p_table_name character varying(255)
) Returns void As $$

	Declare xml_columns character varying(255)[];
	Declare sql text;
	Declare x RECORD;

Begin
	xml_columns := clearing_house.fn_get_submission_table_column_names(p_submission_id, p_table_name);
	If array_length(xml_columns, 1) = 0 Then
		Raise Exception 'Fatal error. Table % has unknown fields.', p_table_name;
		Return;
	End If;

	If Not clearing_house.fn_table_exists(p_table_name) Then
        sql := clearing_house.fn_script_public_db_entity_table('public', 'clearing_house', p_table_name);
		Raise Notice '%', sql;
--		Execute sql;
		Raise Exception 'Fatal error. Table % does not exist.', p_table_name;
	End If;

	For x In (
		Select Distinct t.table_name_underscored, c.column_name_underscored, c.data_type
		From clearing_house.tbl_clearinghouse_submission_tables t
		Join clearing_house.tbl_clearinghouse_submission_xml_content_columns c
		  On c.table_id = t.table_id
		Left Join INFORMATION_SCHEMA.columns ic
		  On ic.table_schema = 'clearing_house'
		 And ic.table_name = t.table_name_underscored
		 And ic.column_name = c.column_name_underscored
		Where c.submission_id = p_submission_id
		  And t.table_name_underscored = p_table_name
		  And c.column_name_underscored <> 'cloned_id'
		  And ic.table_name Is Null
	) Loop

        -- Break instead of automatic INSERT
		Raise Exception 'Fatal error. Unknown column found in XML. Target table %, column %s does not exist.',  x.table_name_underscored,  x.column_name_underscored;

		sql := format('Alter Table clearing_house.%I Add Column %I %s null;',
            p_table_name, x.column_name_underscored, clearing_house.fn_java_type_to_postgresql(x.data_type)
        );

		Execute sql;

		Raise Notice 'Added new column: % % % [%]', x.table_name_underscored,  x.column_name_underscored , clearing_house.fn_java_type_to_postgresql(x.data_type), sql;

        Insert Into clearing_house.tbl_clearinghouse_sead_unknown_column_log (submission_id, table_name, column_name, column_type, alter_sql)
            Values (p_submission_id, x.table_name_underscored, x.column_name_underscored, clearing_house.fn_java_type_to_postgresql(x.data_type), sql);

	End Loop;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_script_local_union_public_entity_view
**	Who			Roger Mähler
**	When		2013-10-14
**	What		Creates union views of local and public data
**  Uses
**  Used By
**	Revisions
******************************************************************************************************************************/
-- Select clearing_house.fn_script_local_union_public_entity_view('clearing_house', 'clearing_house', 'public', 'tbl_dating_uncertainty')
create or replace function clearing_house.fn_script_local_union_public_entity_view(
    target_schema character varying(255),
    local_schema character varying(255),
    public_schema character varying(255),
    table_name character varying(255)
) Returns text As $$
	#variable_conflict use_variable
	Declare sql_template text;
	Declare sql text;
	Declare column_list text;
	Declare pk_field text;
Begin

	sql_template =
'
Create Or Replace View #TARGET-SCHEMA#.#VIEW-NAME# As
    /*
    **	Function #VIEW-NAME#
    **	Who      THIS VIEW IS AUTO-GENERATED BY fn_create_local_union_public_entity_views / Roger Mähler
    **	When     #DATE#
    **	What     Returns union of local and public versions of #TABLE-NAME#
    **  Uses     clearing_house.fn_dba_get_sead_public_db_schema
    **	Note     Please re-run fn_create_local_union_public_entity_views whenever public schema is changed
    **  Used By  SEAD Clearing House
    **/

    Select #COLUMN-LIST#, submission_id, source_id, local_db_id as merged_db_id, local_db_id, public_db_id
    From #LOCAL-SCHEMA#.#TABLE-NAME#
    Union
    Select #COLUMN-LIST#, 0 As submission_id, 2 As source_id, #PK-COLUMN# as merged_db_id, 0 As local_db_id, #PK-COLUMN# As public_db_id
    From #PUBLIC-SCHEMA#.#TABLE-NAME#
;';

	Select array_to_string(array_agg(s.column_name::text Order By s.ordinal_position), ',') Into column_list
	From clearing_house.fn_dba_get_sead_public_db_schema('public', 'sead_master') s
	Join information_schema.columns c /* Column must exist in public and local schema */
	  On c.table_schema = local_schema
	 And c.table_name = table_name
	 And c.column_name = s.column_name
	Where s.table_schema = public_schema
	  And s.table_name = table_name;

	Select column_name Into pk_field
	From clearing_house.fn_dba_get_sead_public_db_schema('public', 'sead_master') s
	Where s.table_schema = public_schema
	  And s.table_name = table_name
	  And s.is_pk = 'YES';

	sql := sql_template;
	sql := replace(sql, '#DATE#', to_char(now(), 'YYYY-MM-DD HH24:MI:SS'));
	sql := replace(sql, '#COLUMN-LIST#', column_list);
	sql := replace(sql, '#PK-COLUMN#', pk_field);
	sql := replace(sql, '#TARGET-SCHEMA#', target_schema);
	sql := replace(sql, '#LOCAL-SCHEMA#', local_schema);
	sql := replace(sql, '#PUBLIC-SCHEMA#', public_schema);
	sql := replace(sql, '#VIEW-NAME#', replace(table_name, 'tbl_', 'view_'));
	sql := replace(sql, '#TABLE-NAME#', table_name);

	Return sql;

End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_create_local_union_public_entity_views
**	Who			Roger Mähler
**	When		2013-10-14
**	What		Creates "union-views" of local and public entity tables
**  Note
**  Todo        Option for total recreate - now existing views are untouched
**  Uses
**  Used By
**	Revisions
******************************************************************************************************************************/
-- Select clearing_house.fn_create_local_union_public_entity_views('clearing_house', 'clearing_house', FALSE, TRUE)
-- Select * From clearing_house.tbl_clearinghouse_sead_create_view_log
-- Drop Function clearing_house.fn_create_local_union_public_entity_views(character varying(255), character varying(255), BOOLEAN, BOOLEAN);
create or replace function clearing_house.fn_create_local_union_public_entity_views(
    target_schema character varying(255),
    local_schema character varying(255),
    p_only_drop BOOLEAN = FALSE,
    p_dry_run BOOLEAN = TRUE
)
Returns void As $$
	Declare v_row RECORD;
	Declare drop_script text;
	Declare create_script text;
Begin

	Create Table If Not Exists clearing_house.tbl_clearinghouse_sead_create_view_log (create_script text, drop_script text);

	For v_row In (
        Select distinct table_schema As public_schema, table_name, replace(table_name, 'tbl_', 'view_') As view_name
        From clearing_house.fn_dba_get_sead_public_db_schema('public', 'sead_master')
        Where is_pk = 'YES' -- /* Måste finnas PK */
          And table_name Like 'tbl_%'
	) Loop

		drop_script = format('Drop View If Exists %I.%I CASCADE;', target_schema, v_row.view_name);
		create_script := clearing_house.fn_script_local_union_public_entity_view(target_schema, local_schema, v_row.public_schema::text, v_row.table_name::text);

        Insert Into clearing_house.tbl_clearinghouse_sead_create_view_log (create_script, drop_script) Values (create_script, drop_script);

        If p_dry_run Then
            Raise Notice '%', drop_script;
            Raise Notice '%', create_script;
        Else
            Execute drop_script;
            If Not p_only_drop Then
                Execute create_script;
            End If;
        End If;

	End Loop;

End $$ Language plpgsql;
/*****************************************************************************************************************************
**	Function	fn_generate_foreign_key_indexes
**	Who			Roger Mähler
**	When		2013-10-14
**	What		Generates DDL create index statement if column (via name matching) is FK in public DB and lacks index.
**  Note
**  Uses
**  Used By
**	Revisions
******************************************************************************************************************************/

create or replace function clearing_house.fn_generate_foreign_key_indexes()
  returns void as $$
  declare x record;
begin
	for x In (

        select 'create index idx_' || target_constraint_name || ' on clearing_house.' || target_table || ' (' || target_colname || ');' as create_script,
               'drop index if exists clearing_house.idx_' || target_constraint_name || ';' as drop_script
        from (
            select
                (select nspname from pg_namespace where oid=m.relnamespace) as target_ns,
                m.relname as target_table,
                (select a.attname from pg_attribute a where a.attrelid = m.oid and a.attnum = o.conkey[1] and a.attisdropped = false)	as target_colname,
                o.conname as target_constraint_name,
                (select nspname from pg_namespace where oid=f.relnamespace)	as foreign_ns,
                f.relname as foreign_table,
                (select a.attname from pg_attribute a where a.attrelid = f.oid and a.attnum = o.confkey[1] and a.attisdropped = false)as foreign_colname
            from pg_constraint o
            left join pg_class c
              on c.oid = o.conrelid
            left join pg_class f
              on f.oid = o.confrelid
            left join pg_class m
              on m.oid = o.conrelid
            where o.contype = 'f'
              and o.conrelid in (select oid from pg_class c where c.relkind = 'r')
            order by 2
        ) as x
        left Join pg_indexes i
          on i.schemaname = 'clearing_house'
         and i.tablename =  target_table
         and i.indexname =  'idx_' || target_constraint_name
        where target_ns = 'public'
          and i.indexname is null
          and target_table in (
            select table_name
            from information_schema.tables
            where table_schema = 'clearing_house'
          )
    ) loop
        raise notice '%', x.drop_script;
        raise notice '%', x.create_script;

        execute x.drop_script;
        execute x.create_script;
    end loop;

end $$ language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_create_clearinghouse_public_db_model
**	Who			Roger Mähler
**	When		2017-11-16
**	What		Calls functions above to create a CH version of public entity tables and viewes that merges
**              local and public entity tables
**  Uses
**  Used By
**	Revisions
******************************************************************************************************************************/

create or replace procedure clearing_house.create_public_model(
    p_only_drop boolean = false,
    p_dry_run boolean = true
) as $$
begin

    perform clearing_house.fn_create_public_db_entity_tables('clearing_house', p_only_drop, p_dry_run);
    perform clearing_house.fn_generate_foreign_key_indexes();
    perform clearing_house.fn_create_local_union_public_entity_views('clearing_house', 'clearing_house', p_only_drop, p_dry_run);

end $$ language plpgsql;
