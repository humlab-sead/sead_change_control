/*****************************************************************************************************************************
**	Function	fn_get_submission_table_column_names
**	Who			Roger Mähler
**	When		2013-10-14
**	What		Returns column names for specified table as an array
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Select clearing_house.fn_get_submission_table_column_names(2, 'tbl_abundances')
create or replace function clearing_house.fn_get_submission_table_column_names(p_submission_id int, p_table_name_underscored character varying(255))
returns character varying(255)[] as $$
    declare v_columns character varying(255)[];
begin
    Select array_agg(c.column_name_underscored order by c.column_id asc) Into v_columns
    From clearing_house.tbl_clearinghouse_submission_tables t
    Join clearing_house.tbl_clearinghouse_submission_xml_content_columns c
      On c.table_id = t.table_id
    Where c.submission_id = p_submission_id
      And t.table_name_underscored = p_table_name_underscored
    Group By c.submission_id, t.table_name;
    return v_columns;
end $$ language plpgsql;

/*****************************************************************************************************************************
**	Function
**	Who			Roger Mähler
**	When		2013-10-14
**	What		Returns column SQL types for specified table as an array
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Select clearing_house.fn_get_submission_table_column_types(2, 'tbl_abundances')
create or replace function clearing_house.fn_get_submission_table_column_types(p_submission_id int, p_table_name_underscored character varying(255))
Returns character varying(255)[] As $$
    Declare columns character varying(255)[];
Begin
    Select array_agg(clearing_house.fn_java_type_to_PostgreSQL(c.data_type) order by c.column_id asc) Into columns
    From clearing_house.tbl_clearinghouse_submission_tables t
    Join clearing_house.tbl_clearinghouse_submission_xml_content_columns c
      On c.table_id = t.table_id
    Where c.submission_id = p_submission_id
      And t.table_name_underscored = p_table_name_underscored
    Group By c.submission_id, t.table_name;
    return columns;
End $$ Language plpgsql;

create or replace function clearing_house.fn_get_submission_table_value_field_array(p_submission_id int, p_table_name_underscored text)
Returns character varying(255)[] As $$
Declare
    v_types character varying(255)[];
    v_fields character varying(255)[];
Begin

    /**
    **	Function    fn_get_submission_table_value_field_array
    **	Who			Roger Mähler
    **	When		2018-07-01
    **	What		Returns dynamic array of fields, types and name used in select query from XML value table
    **	Uses
    **	Used By
    **	Revisions
    **/

    v_types := clearing_house.fn_get_submission_table_column_types(p_submission_id, p_table_name_underscored);
    Select array_agg(format('values[%s]::%s', column_id, replace(column_type, 'integer', 'float::integer')) Order By column_id)
        Into v_fields
    From unnest(v_types) WITH ORDINALITY AS a(column_type, column_id);
    Return v_fields;
End $$ Language plpgsql;

create or replace function clearing_house.fn_select_xml_content_tables(p_submission_id int)
Returns Table(
    submission_id int,
    table_name    character varying(255),
    row_count     int
) As $$
Begin

    /**
    **	Who			Roger Mähler
    **	When		2013-10-14
    **	What		Returns all listed tables in a submission XML
    **  Note
    **	Uses
    **	Used By
    **	Revisions
    **/

    Return Query
        Select	d.submission_id																as submission_id,
                substring(d.xml::text from '^<([[:alnum:]]+).*>')::character varying(255)	as table_name,
                (xpath('/*/@length', d.xml))[1]::text::int								    as row_count
        From (
            Select x.submission_id, unnest(xpath('/sead-data-upload/*', x.xml)) As xml
            From clearing_house.tbl_clearinghouse_submission_xml as x
            Where 1 = 1
              And x.submission_id = p_submission_id
              And Not xml Is Null
              And xml Is Document
        ) d;
End $$ Language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_select_xml_content_columns
**	Who			Roger Mähler
**	When		2013-10-14
**	What		Returns all listed columns in a submission XML
**  Note        First (not cloned) record per table is selected
**	Uses
**	Used By     fn_extract_and_store_submission_columns
**	Revisions
******************************************************************************************************************************/
-- Select * From clearing_house.fn_select_xml_content_columns(3)
create or replace function clearing_house.fn_select_xml_content_columns(p_submission_id int)
Returns Table(
    submission_id int,
    table_name	  character varying(255),
    column_name	  character varying(255),
    column_type	  character varying(255)
) As $$
Begin
    Return Query
        Select	d.submission_id                                   							as submission_id,
                d.table_name																as table_name,
                substring(d.xml::text from '^<([[:alnum:]]+).*>')::character varying(255)	as column_name,
                (xpath('/*/@class', d.xml))[1]::character varying(255)					    as column_type
        From (
            Select x.submission_id, t.table_name, unnest(xpath('/sead-data-upload/' || t.table_name || '/*[not(@clonedId)][1]/*', xml)) As xml
            From clearing_house.tbl_clearinghouse_submission_xml x
            Join clearing_house.fn_select_xml_content_tables(p_submission_id) t
              Using (submission_id)
            Where 1 = 1
              And x.submission_id = p_submission_id
              And Not xml Is Null
              And xml Is Document
        ) as d;
End $$ Language plpgsql;

create or replace function clearing_house.fn_select_xml_content_records(p_submission_id integer)
  RETURNS TABLE(submission_id integer, table_name character varying, local_db_id integer, public_db_id_attr integer, public_db_id_tag integer) AS
$BODY$
Begin

    /**
    **	Function	fn_select_xml_content_records
    **	Who			Roger Mähler
    **	When		2013-10-14
    **	What		Returns all individual records found in a submission XML
    **  Note
    **	Uses
    **	Used By     fn_extract_and_store_submission_records
    **	Revisions
    **/

    Return Query
        With submission_xml_data_rows As (
            Select x.submission_id,
                   unnest(xpath('/sead-data-upload/*/*', x.xml)) As xml
            From clearing_house.tbl_clearinghouse_submission_xml x
            Where Not xml Is Null
              And xml Is Document
              And x.submission_id = p_submission_id
        )
            Select v.submission_id,
                   v.table_name::character varying(255),
                   Case When v.local_db_id ~ '^[0-9\.]+$' Then v.local_db_id::numeric::int Else Null End,
                   Case When v.public_db_id_attribute ~ '^[0-9\.]+$' Then v.public_db_id_attribute::numeric::int Else Null End,
                   Case When v.public_db_id_value ~ '^[0-9\.]+$' Then v.public_db_id_value::numeric::int Else Null End
            From (
                Select	d.submission_id																			as submission_id,
                        replace(substring(d.xml::text from '^<([[:alnum:]\.]+).*>'), 'com.sead.database.', '')	as table_name,
                        ((xpath('/*/@id', d.xml))[1])::character varying(255)									as local_db_id,
                        ((xpath('/*/@clonedId', d.xml))[1])::character varying(255)							    as public_db_id_attribute,
                        ((xpath('/*/clonedId/text()', d.xml))[1])::character varying(255)						as public_db_id_value
                From submission_xml_data_rows as d
            ) As v;

End $BODY$ LANGUAGE plpgsql VOLATILE;

create or replace function clearing_house.fn_select_xml_content_values(p_submission_id integer, p_table_name character varying)
RETURNS TABLE(
    submission_id integer,
    table_name character varying,
    local_db_id integer,
    public_db_id integer,
    column_name character varying,
    column_type character varying,
    fk_local_db_id integer,
    fk_public_db_id integer,
    value text)
LANGUAGE 'plpgsql'
AS $BODY$
Begin
    /**
    **	Function	fn_select_xml_content_values
    **	Who			Roger Mähler
    **	When		2013-10-14
    **	What		Returns all values found in a submission XML
    **  Note
    **	Uses
    **	Used By     fn_extract_and_store_submission_values
    **	Revisions
    **/

    p_table_name := Coalesce(p_table_name, '*');
    Return Query
        With record_xml As (
            Select x.submission_id, unnest(xpath('/sead-data-upload/' || p_table_name || '/*', x.xml))			As xml
            From clearing_house.tbl_clearinghouse_submission_xml x
            Where x.submission_id = p_submission_id
              And Not x.xml Is Null
              And x.xml Is Document
        ), record_value_xml As (
            Select	x.submission_id																				As submission_id,
                    replace(substring(x.xml::text from '^<([[:alnum:]\.]+).*>'), 'com.sead.database.', '')		As table_name,
                    nullif((xpath('/*/@id', x.xml))[1]::character varying(255), 'NULL')::numeric::int			As local_db_id,
                    nullif((xpath('/*/@clonedId', x.xml))[1]::character varying(255), 'NULL')::numeric::int	    As public_db_id,
                    unnest(xpath( '/*/*', x.xml))																As "xml"
            From record_xml x
        )   Select	x.submission_id																				As submission_id,
                    x.table_name::character varying																As table_name,
                    x.local_db_id																				As local_db_id,
                    x.public_db_id																				As public_db_id,
                    substring(x.xml::character varying(255) from '^<([[:alnum:]]+).*>')::character varying(255)	As column_name,
                    nullif((xpath('/*/@class', x.xml))[1]::character varying, 'NULL')::character varying		As column_type,
                    nullif((xpath('/*/@id', x.xml))[1]::character varying(255), 'NULL')::numeric::int			As fk_local_db_id,
                    nullif((xpath('/*/@clonedId', x.xml))[1]::character varying(255), 'NULL')::numeric::int	    As fk_public_db_id,
                    nullif((xpath('/*/text()', x.xml))[1]::text, 'NULL')::text									As "value"
            From record_value_xml x;
End
$BODY$;

create or replace function clearing_house.fn_extract_and_store_submission_tables(p_submission_id int) Returns void As $$
Begin

    /**
    **	Function	fn_extract_and_store_submission_tables
    **	Who			Roger Mähler
    **	When		2013-10-14
    **	What        Extracts and stores tables found in XML
    **  Note
    **	Uses        fn_select_xml_content_tables
    **	Used By     fn_explode_submission_xml_to_rdb
    **	Revisions
    **/

    -- TODO Move to import client

    /* Register new tables not previously encountered */
    Insert Into clearing_house.tbl_clearinghouse_submission_tables (table_name, table_name_underscored)
        Select t.table_name, clearing_house.fn_pascal_case_to_underscore(t.table_name)
        From  clearing_house.fn_select_xml_content_tables(p_submission_id) t
        Left Join clearing_house.tbl_clearinghouse_submission_tables x
          On x.table_name = t.table_name
        Where x.table_name Is NULL;

    /* Store all tables that exists in submission */
    Insert Into clearing_house.tbl_clearinghouse_submission_xml_content_tables (submission_id, table_id, record_count)
        Select t.submission_id, x.table_id, t.row_count
        From  clearing_house.fn_select_xml_content_tables(p_submission_id) t
        Join clearing_house.tbl_clearinghouse_submission_tables x
          On x.table_name = t.table_name
        ;
End $$ Language plpgsql;

create or replace function clearing_house.fn_extract_and_store_submission_columns(p_submission_id int) Returns void As $$
Begin

    /**
    **	Function	fn_extract_and_store_submission_columns
    **	Who			Roger Mähler
    **	When		2013-10-14
    **	What		Extract all unique column names from XML per table
    **  Note
    **	Uses
    **	Used By     fn_explode_submission_xml_to_rdb
    **	Revisions
    **/

    Delete From clearing_house.tbl_clearinghouse_submission_xml_content_columns
        Where submission_id = p_submission_id;

    Insert Into clearing_house.tbl_clearinghouse_submission_xml_content_columns (submission_id, table_id, column_name, column_name_underscored, data_type, fk_flag, fk_table, fk_table_underscored)
        Select	c.submission_id,
                t.table_id,
                c.column_name,
                clearing_house.fn_pascal_case_to_underscore(c.column_name),
                c.column_type,
                left(c.column_type, 18) = 'com.sead.database.',
                Case When left(c.column_type, 18) = 'com.sead.database.' Then substring(c.column_type from 19) Else Null End,
                ''
        From  clearing_house.fn_select_xml_content_columns(p_submission_id) c
        Join clearing_house.tbl_clearinghouse_submission_tables t
          On t.table_name = c.table_name
        Where c.submission_id = p_submission_id;

    Update clearing_house.tbl_clearinghouse_submission_xml_content_columns
        Set fk_table_underscored = clearing_house.fn_pascal_case_to_underscore(fk_table)
    Where submission_id = p_submission_id;

End $$ Language plpgsql;

-- Select clearing_house.fn_extract_and_store_submission_records(2)
create or replace function clearing_house.fn_extract_and_store_submission_records(p_submission_id int) Returns void As $$
Begin
    /**
    **	Function  fn_extract_and_store_submission_records
    **	Who       Roger Mähler
    **	When      2013-10-14
    **	What      Stores all unique table rows found in XML in tbl_clearinghouse_submission_xml_content_records
    **  Note
    **	Uses      fn_select_xml_content_records
    **	Used By   fn_explode_submission_xml_to_rdb
    **	Revisions
    **/

    Delete From clearing_house.tbl_clearinghouse_submission_xml_content_records
        Where submission_id = p_submission_id;

    /* Extract all unique records */
    Insert Into clearing_house.tbl_clearinghouse_submission_xml_content_records (submission_id, table_id, local_db_id, public_db_id)
        Select r.submission_id, t.table_id, r.local_db_id, coalesce(r.public_db_id_tag, public_db_id_attr)
        From clearing_house.fn_select_xml_content_records(p_submission_id) r
        Join clearing_house.tbl_clearinghouse_submission_tables t
          On t.table_name = r.table_name
        Where r.submission_id = p_submission_id;

    --Raise Notice 'XML record headers extracted and stored for submission id %', p_submission_id;

End $$ Language plpgsql;
/*****************************************************************************************************************************
**	Function	fn_extract_and_store_submission_values
**	Who			Roger Mähler
**	When		2013-10-14
**	What		Extract values from XML and store in generic table clearing_house.tbl_clearinghouse_submission_xml_content_values
**  Note
**	Uses
**	Used By     fn_explode_submission_xml_to_rdb
**	Revisions
******************************************************************************************************************************/
-- Select clearing_house.fn_extract_and_store_submission_values(2)
create or replace function clearing_house.fn_extract_and_store_submission_values(p_submission_id int) Returns void As $$
    Declare x RECORD;
Begin

    Delete From clearing_house.tbl_clearinghouse_submission_xml_content_values
        Where submission_id = p_submission_id;

    Insert Into clearing_house.tbl_clearinghouse_submission_xml_content_values (submission_id, table_id, local_db_id, column_id, fk_flag, fk_local_db_id, fk_public_db_id, value)
        Select	p_submission_id,
                t.table_id,
                v.local_db_id,
                c.column_id,
                Not (v.fk_local_db_id Is Null),
                v.fk_local_db_id,
                v.fk_public_db_id,
                Case When v.value = 'NULL' Then NULL Else v.value End
        From clearing_house.fn_select_xml_content_values(p_submission_id, '*') v
        Join clearing_house.tbl_clearinghouse_submission_tables t
            On t.table_name = v.table_name
        Join clearing_house.tbl_clearinghouse_submission_xml_content_columns c
          On c.submission_id = v.submission_id
         And c.table_id = t.table_id
         And c.column_name = v.column_name;

end $$ language plpgsql;

/*****************************************************************************************************************************
**	Function	fn_copy_extracted_values_to_entity_table
**	Who			Roger Mähler
**	When		2013-10-14
**	What		Copies explodes (vertical) XML data to corresponding CHDB table
**  Note        Note that CHDB table is in underscore notation e.g. "tblAbundances"
**	Uses        fn_get_submission_table_column_names, fn_get_submission_table_column_types
**	Used By     fn_explode_submission_xml_to_rdb
**	Revisions
******************************************************************************************************************************/

create or replace view clearing_house.view_clearinghouse_local_fk_references as

    /*
    **	Who			Roger Mähler
    **	When		2013-11-06
    **	What		Gives FK-column that references a local record in the CHDB database
    **  Note        fn_copy_extracted_values_to_entity_table
    **	Uses        fn_get_submission_table_column_names, fn_get_submission_table_column_types
    **	Used By     fn_explode_submission_xml_to_rdb
    **	Revisions
    **/

    with sead_rdb_schema_pk_columns as (
        Select table_schema, table_name, column_name
        From clearing_house.fn_dba_get_sead_public_db_schema('public', 'sead_master')
        Where is_pk = 'YES'
    )
        Select v.submission_id, v.local_db_id, c.table_id, c.column_id,
                v.fk_local_db_id, fk_t.table_id as fk_table_id, fk_c.column_id as fk_column_id
        From clearing_house.tbl_clearinghouse_submission_xml_content_values v
        Join clearing_house.tbl_clearinghouse_submission_xml_content_columns c
            On c.submission_id = v.submission_id
            And c.table_id = v.table_id
            And c.column_id = v.column_id
        Join clearing_house.tbl_clearinghouse_submission_tables fk_t
            On fk_t.table_name_underscored = c.fk_table_underscored
        Join sead_rdb_schema_pk_columns s
            On s.table_schema = 'public'
            And s.table_name = fk_t.table_name_underscored
        Join clearing_house.tbl_clearinghouse_submission_xml_content_columns fk_c
            On fk_c.submission_id = v.submission_id
            And fk_c.table_id = fk_t.table_id
            And fk_c.column_name_underscored = s.column_name
        Join clearing_house.tbl_clearinghouse_submission_xml_content_values fk_v
            On fk_v.submission_id = v.submission_id
            And fk_v.table_id = fk_t.table_id
            And fk_v.column_id = fk_c.column_id
            And fk_v.local_db_id = v.fk_local_db_id
        Where v.fk_flag = true;

create or replace function clearing_house.fn_get_extracted_values_as_arrays(p_submission_id int, p_table_name_underscored character varying(255))
returns table(
    submission_id int,
    table_name character varying(255),
    local_db_id int,
    public_db_id int,
    row_values text[]
) as $$
declare v_table_id int;
declare v_table_name character varying(255);
begin

    /*
    ** Helper function for clearing_house.fn_copy_extracted_values_to_entity_table
    */

    drop table if exists temp_fk_references;

    create temp table if not exists temp_fk_references as
        select *
        from clearing_house.view_clearinghouse_local_fk_references f
        where f.submission_id = p_submission_id
          and f.table_id = v_table_id;

    Create Index idx_temp_fk_references
    	On temp_fk_references (
    		submission_id, table_id, column_id, local_db_id
    	);

    Select t.table_id, t.table_name Into STRICT v_table_id, v_table_name
    From clearing_house.tbl_clearinghouse_submission_tables t
    Where table_name_underscored = p_table_name_underscored;

    Return Query
		Select p_submission_id, v_table_name, r.local_db_id, r.public_db_id, array_agg(
			Case when v.fk_flag = TRUE Then
					Case When Not v.fk_public_db_id Is Null And f.fk_local_db_id Is Null
					Then v.fk_public_db_id::text Else (-v.fk_local_db_id)::text End
			Else v.value End
			Order by c.column_id asc
		) as values
		From clearing_house.tbl_clearinghouse_submission_xml_content_records r
		Join clearing_house.tbl_clearinghouse_submission_xml_content_columns c
		  On c.submission_id = r.submission_id
		 And c.table_id = r.table_id
		/* Left */ Join clearing_house.tbl_clearinghouse_submission_xml_content_values v
		  On v.submission_id = r.submission_id
		 And v.table_id = r.table_id
		 And v.local_db_id = r.local_db_id
		 And v.column_id = c.column_id
		/* Check if public record pointed to by FK exists in local DB. In such case set FK value to -fk_local_db_id */
		Left Join temp_fk_references f
		  On f.submission_id = r.submission_id
		 And f.table_id = r.table_id
		 And f.column_id = c.column_id
		 And f.local_db_id = v.local_db_id
		 And f.fk_local_db_id = v.fk_local_db_id
		Where 1 = 1
		 And r.submission_id = p_submission_id
		 And r.table_id = v_table_id
		Group By r.local_db_id, r.public_db_id;

    Drop Table If Exists temp_fk_references;

End $$ Language plpgsql;

create or replace function clearing_house.fn_copy_extracted_values_to_entity_table(
    p_submission_id int,
    p_table_name_underscored character varying(255),
    p_dry_run boolean=FALSE
) Returns text As $$

    Declare v_field_names character varying(255)[];
    Declare v_fields character varying(255)[];

    Declare insert_columns_string text;
    Declare select_columns_string text;

    Declare v_sql text;
    Declare i integer;

Begin

    If clearing_house.fn_table_exists(p_table_name_underscored) = false Then
        Raise Exception 'Table does not exist: %', p_table_name_underscored;
        Return Null;
    End If;

    v_sql := format('Delete From clearing_house.%I Where submission_id = %s;', p_table_name_underscored, p_submission_id);

    If Not p_dry_run Then
        Execute v_sql;
    End If;

    v_field_names := clearing_house.fn_get_submission_table_column_names(p_submission_id, p_table_name_underscored);
    v_fields :=  clearing_house.fn_get_submission_table_value_field_array(p_submission_id, p_table_name_underscored);

    If Not (v_field_names is Null or array_length(v_field_names, 1) = 0) Then

        insert_columns_string := replace(array_to_string(v_field_names, ', '), 'cloned_id', 'public_db_id');

        select string_agg(field_expr, ', ' order by field_id)
            into select_columns_string
        from (
            select field_id, string_agg(field_part, ' as ') as field_expr
            from (values (v_fields), (v_field_names)) as t(a), unnest(t.a) with ordinality x(field_part, field_id)
            group by field_id
        ) as x;

        -- select_columns_string = string_agg(v_fields, ', '); -- Enough, but without column names

        v_sql := format('
        Insert Into clearing_house.%s (submission_id, source_id, local_db_id, %s)
            Select v.submission_id, 1 as source_id, -v.local_db_id, %s
            From clearing_house.fn_get_extracted_values_as_arrays(%s, ''%s'') as v(submission_id, table_name, local_db_id, public_db_id, values)
        ', p_table_name_underscored, insert_columns_string, select_columns_string, p_submission_id, p_table_name_underscored);

        If Not p_dry_run Then
            Execute v_sql;
        End If;

    End If;

    Return v_sql;

End $$ Language plpgsql;
