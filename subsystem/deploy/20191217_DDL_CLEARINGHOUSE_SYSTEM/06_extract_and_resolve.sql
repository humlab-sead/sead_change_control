
/*****************************************************************************************************************************
**	Function	view_clearinghouse_ignore_columns
**	Who			Roger Mähler
**	When		2024-12-15
**	What		Returns column names to ignore in extraction
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/

create or replace view clearing_house.view_clearinghouse_ignore_columns as
	select column_name
    from (values ('date_updated'), ('%_uuid')) as a(column_name);   

/*****************************************************************************************************************************
**	Function	fn_get_submission_table_column_names
**	Who			Roger Mähler
**	When		2013-10-14
**	What		Returns column names for specified table as an array
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- select clearing_house.fn_get_submission_table_column_names(2, 'tbl_abundances')
create or replace function clearing_house.fn_get_submission_table_column_names(
    p_submission_id int,
    p_table_name_underscored character varying(255)
)
returns character varying(255)[] as $$
    declare v_columns character varying(255)[];
begin
    select array_agg(c.column_name_underscored order by c.column_id asc) into v_columns
    from clearing_house.tbl_clearinghouse_submission_tables t
    join clearing_house.tbl_clearinghouse_submission_xml_content_columns c
      on c.table_id = t.table_id
    where c.submission_id = p_submission_id
      and t.table_name_underscored = p_table_name_underscored
      and not exists(select 1 from clearing_house.view_clearinghouse_ignore_columns i where c.column_name_underscored like i.column_name)
    group by c.submission_id, t.table_name;
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
-- select clearing_house.fn_get_submission_table_column_types(2, 'tbl_abundances')
create or replace function clearing_house.fn_get_submission_table_column_types(
    p_submission_id int,
    p_table_name_underscored character varying(255)
)
returns character varying(255)[] as $$
    declare columns character varying(255)[];
begin
    select array_agg(clearing_house.fn_java_type_to_postgresql(c.data_type) order by c.column_id asc) into columns
    from clearing_house.tbl_clearinghouse_submission_tables t
    join clearing_house.tbl_clearinghouse_submission_xml_content_columns c
      on c.table_id = t.table_id
    where c.submission_id = p_submission_id
      and t.table_name_underscored = p_table_name_underscored
      and not exists(select 1 from clearing_house.view_clearinghouse_ignore_columns i where c.column_name_underscored like i.column_name)
    group by c.submission_id, t.table_name;
    return columns;
end $$ language plpgsql;

create or replace function clearing_house.fn_get_submission_table_value_field_array(p_submission_id int, p_table_name_underscored text)
Returns character varying(255)[] As $$
Declare
    v_types character varying(255)[];
    v_fields character varying(255)[];
begin

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
    select array_agg(format('values[%s]::%s', column_id, replace(column_type, 'integer', 'float::integer')) Order By column_id)
        into v_fields
    from unnest(v_types) WITH ORDINALITY as a(column_type, column_id);
    return v_fields;
end $$ language plpgsql;

create or replace function clearing_house.fn_select_xml_content_tables(p_submission_id int)
returns Table(
    submission_id int,
    table_name    character varying(255),
    row_count     int
) As $$
begin

    /**
    **	Who			Roger Mähler
    **	When		2013-10-14
    **	What		Returns all listed tables in a submission XML
    **  Note
    **	Uses
    **	Used By
    **	Revisions
    **/

    return Query
        select	d.submission_id																as submission_id,
                substring(d.xml::text from '^<([[:alnum:]]+).*>')::character varying(255)	as table_name,
                (xpath('/*/@length', d.xml))[1]::text::int								    as row_count
        from (
            select x.submission_id, unnest(xpath('/sead-data-upload/*', x.xml)) As xml
            from clearing_house.tbl_clearinghouse_submission_xml as x
            where 1 = 1
              and x.submission_id = p_submission_id
              and not xml Is null
              and xml Is Document
        ) d;
end $$ language plpgsql;

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
-- select * from clearing_house.fn_select_xml_content_columns(3)
create or replace function clearing_house.fn_select_xml_content_columns(p_submission_id int)
Returns Table(
    submission_id int,
    table_name	  character varying(255),
    column_name	  character varying(255),
    column_type	  character varying(255)
) As $$
begin
    return Query
        select	d.submission_id                                   							as submission_id,
                d.table_name																as table_name,
                substring(d.xml::text from '^<([[:alnum:]]+).*>')::character varying(255)	as column_name,
                (xpath('/*/@class', d.xml))[1]::character varying(255)					    as column_type
        from (
            select x.submission_id, t.table_name, unnest(xpath('/sead-data-upload/' || t.table_name || '/*[not(@clonedId)][1]/*', xml)) As xml
            from clearing_house.tbl_clearinghouse_submission_xml x
            join clearing_house.fn_select_xml_content_tables(p_submission_id) t using (submission_id)
            where 1 = 1
              and x.submission_id = p_submission_id
              and not xml Is null
              and xml Is Document
        ) as d;
end $$ language plpgsql;

create or replace function clearing_house.fn_select_xml_content_records(p_submission_id integer)
  returns table(submission_id integer, table_name character varying, local_db_id integer, public_db_id_attr integer, public_db_id_tag integer) as
$BODY$
begin

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

    return Query
        With submission_xml_data_rows As (
            select x.submission_id,
                   unnest(xpath('/sead-data-upload/*/*', x.xml)) As xml
            from clearing_house.tbl_clearinghouse_submission_xml x
            where not xml Is null
              and xml Is Document
              and x.submission_id = p_submission_id
        )
            select v.submission_id,
                   v.table_name::character varying(255),
                   case When v.local_db_id ~ '^[0-9\.]+$' then v.local_db_id::numeric::int else null end,
                   case When v.public_db_id_attribute ~ '^[0-9\.]+$' then v.public_db_id_attribute::numeric::int else null end,
                   case When v.public_db_id_value ~ '^[0-9\.]+$' then v.public_db_id_value::numeric::int else null end
            from (
                select	d.submission_id																			as submission_id,
                        replace(substring(d.xml::text from '^<([[:alnum:]\.]+).*>'), 'com.sead.database.', '')	as table_name,
                        ((xpath('/*/@id', d.xml))[1])::character varying(255)									as local_db_id,
                        ((xpath('/*/@clonedId', d.xml))[1])::character varying(255)							    as public_db_id_attribute,
                        ((xpath('/*/clonedId/text()', d.xml))[1])::character varying(255)						as public_db_id_value
                from submission_xml_data_rows as d
            ) As v;

end $BODY$ language plpgsql VOLATILE;

create or replace function clearing_house.fn_select_xml_content_values(p_submission_id integer, p_table_name character varying)
returns table(
    submission_id integer,
    table_name character varying,
    local_db_id integer,
    public_db_id integer,
    column_name character varying,
    column_type character varying,
    fk_local_db_id integer,
    fk_public_db_id integer,
    value text)
language 'plpgsql'
as $BODY$
begin
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
    return Query
        With record_xml As (
            select x.submission_id, unnest(xpath('/sead-data-upload/' || p_table_name || '/*', x.xml))			As xml
            from clearing_house.tbl_clearinghouse_submission_xml x
            where x.submission_id = p_submission_id
              and not x.xml Is null
              and x.xml Is Document
        ), record_value_xml As (
            select	x.submission_id																				As submission_id,
                    replace(substring(x.xml::text from '^<([[:alnum:]\.]+).*>'), 'com.sead.database.', '')		As table_name,
                    nullif((xpath('/*/@id', x.xml))[1]::character varying(255), 'NULL')::numeric::int			As local_db_id,
                    nullif((xpath('/*/@clonedId', x.xml))[1]::character varying(255), 'NULL')::numeric::int	    As public_db_id,
                    unnest(xpath( '/*/*', x.xml))																As "xml"
            from record_xml x
        )   select	x.submission_id																				As submission_id,
                    x.table_name::character varying																As table_name,
                    x.local_db_id																				As local_db_id,
                    x.public_db_id																				As public_db_id,
                    substring(x.xml::character varying(255) from '^<([[:alnum:]]+).*>')::character varying(255)	As column_name,
                    nullif((xpath('/*/@class', x.xml))[1]::character varying, 'NULL')::character varying		As column_type,
                    nullif((xpath('/*/@id', x.xml))[1]::character varying(255), 'NULL')::numeric::int			As fk_local_db_id,
                    nullif((xpath('/*/@clonedId', x.xml))[1]::character varying(255), 'NULL')::numeric::int	    As fk_public_db_id,
                    nullif((xpath('/*/text()', x.xml))[1]::text, 'NULL')::text									As "value"
            from record_value_xml x;
end
$BODY$;

create or replace function clearing_house.fn_extract_and_store_submission_tables(p_submission_id int) Returns void As $$
begin

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
    insert into clearing_house.tbl_clearinghouse_submission_tables (table_name, table_name_underscored)
        select t.table_name, clearing_house.fn_pascal_case_to_underscore(t.table_name)
        from  clearing_house.fn_select_xml_content_tables(p_submission_id) t
        Left join clearing_house.tbl_clearinghouse_submission_tables x
          on x.table_name = t.table_name
        where x.table_name Is NULL;

    /* Store all tables that exists in submission */
    insert into clearing_house.tbl_clearinghouse_submission_xml_content_tables (submission_id, table_id, record_count)
        select t.submission_id, x.table_id, t.row_count
        from  clearing_house.fn_select_xml_content_tables(p_submission_id) t
        join clearing_house.tbl_clearinghouse_submission_tables x
          on x.table_name = t.table_name
        ;
end $$ language plpgsql;

create or replace function clearing_house.fn_extract_and_store_submission_columns(p_submission_id int) Returns void As $$
begin

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

    delete from clearing_house.tbl_clearinghouse_submission_xml_content_columns
        where submission_id = p_submission_id;

    insert into clearing_house.tbl_clearinghouse_submission_xml_content_columns (submission_id, table_id, column_name, column_name_underscored, data_type, fk_flag, fk_table, fk_table_underscored)
        select	c.submission_id,
                t.table_id,
                c.column_name,
                clearing_house.fn_pascal_case_to_underscore(c.column_name),
                c.column_type,
                left(c.column_type, 18) = 'com.sead.database.',
                case When left(c.column_type, 18) = 'com.sead.database.' then substring(c.column_type from 19) else null end,
                ''
        from  clearing_house.fn_select_xml_content_columns(p_submission_id) c
        join clearing_house.tbl_clearinghouse_submission_tables t
          on t.table_name = c.table_name
        where c.submission_id = p_submission_id;

    Update clearing_house.tbl_clearinghouse_submission_xml_content_columns
        Set fk_table_underscored = clearing_house.fn_pascal_case_to_underscore(fk_table)
    where submission_id = p_submission_id;

end $$ language plpgsql;

-- select clearing_house.fn_extract_and_store_submission_records(2)
create or replace function clearing_house.fn_extract_and_store_submission_records(p_submission_id int) returns void As $$
begin
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

    delete from clearing_house.tbl_clearinghouse_submission_xml_content_records
        where submission_id = p_submission_id;

    /* Extract all unique records */
    insert into clearing_house.tbl_clearinghouse_submission_xml_content_records (submission_id, table_id, local_db_id, public_db_id)
        select r.submission_id, t.table_id, r.local_db_id, coalesce(r.public_db_id_tag, public_db_id_attr)
        from clearing_house.fn_select_xml_content_records(p_submission_id) r
        join clearing_house.tbl_clearinghouse_submission_tables t
          on t.table_name = r.table_name
        where r.submission_id = p_submission_id;

    --Raise Notice 'XML record headers extracted and stored for submission id %', p_submission_id;

end $$ language plpgsql;
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
-- select clearing_house.fn_extract_and_store_submission_values(2)
create or replace function clearing_house.fn_extract_and_store_submission_values(p_submission_id int) Returns void As $$
    declare x RECORD;
begin

    delete from clearing_house.tbl_clearinghouse_submission_xml_content_values
        where submission_id = p_submission_id;

    insert into clearing_house.tbl_clearinghouse_submission_xml_content_values (submission_id, table_id, local_db_id, column_id, fk_flag, fk_local_db_id, fk_public_db_id, value)
        select	p_submission_id,
                t.table_id,
                v.local_db_id,
                c.column_id,
                not (v.fk_local_db_id Is null),
                v.fk_local_db_id,
                v.fk_public_db_id,
                case When v.value = 'NULL' then NULL else v.value end
        from clearing_house.fn_select_xml_content_values(p_submission_id, '*') v
        join clearing_house.tbl_clearinghouse_submission_tables t
            on t.table_name = v.table_name
        join clearing_house.tbl_clearinghouse_submission_xml_content_columns c
          on c.submission_id = v.submission_id
         and c.table_id = t.table_id
         and c.column_name = v.column_name;

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
        select table_schema, table_name, column_name
        from clearing_house.fn_dba_get_sead_public_db_schema('public', 'sead_master')
        where is_pk = 'YES'
    )
        select v.submission_id, v.local_db_id, c.table_id, c.column_id,
                v.fk_local_db_id, fk_t.table_id as fk_table_id, fk_c.column_id as fk_column_id
        from clearing_house.tbl_clearinghouse_submission_xml_content_values v
        join clearing_house.tbl_clearinghouse_submission_xml_content_columns c
            on c.submission_id = v.submission_id
            and c.table_id = v.table_id
            and c.column_id = v.column_id
        join clearing_house.tbl_clearinghouse_submission_tables fk_t
            on fk_t.table_name_underscored = c.fk_table_underscored
        join sead_rdb_schema_pk_columns s
            on s.table_schema = 'public'
            and s.table_name = fk_t.table_name_underscored
        join clearing_house.tbl_clearinghouse_submission_xml_content_columns fk_c
            on fk_c.submission_id = v.submission_id
            and fk_c.table_id = fk_t.table_id
            and fk_c.column_name_underscored = s.column_name
        join clearing_house.tbl_clearinghouse_submission_xml_content_values fk_v
            on fk_v.submission_id = v.submission_id
            and fk_v.table_id = fk_t.table_id
            and fk_v.column_id = fk_c.column_id
            and fk_v.local_db_id = v.fk_local_db_id
        where v.fk_flag = true;

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
    	on temp_fk_references (
    		submission_id, table_id, column_id, local_db_id
    	);

    select t.table_id, t.table_name into STRICT v_table_id, v_table_name
    from clearing_house.tbl_clearinghouse_submission_tables t
    where table_name_underscored = p_table_name_underscored;

    return Query
		select p_submission_id, v_table_name, r.local_db_id, r.public_db_id, array_agg(
			case when v.fk_flag = TRUE then
					case When not v.fk_public_db_id Is null and f.fk_local_db_id Is null
					then v.fk_public_db_id::text else (-v.fk_local_db_id)::text end
			else v.value end
			Order by c.column_id asc
		) as values
		from clearing_house.tbl_clearinghouse_submission_xml_content_records r
		join clearing_house.tbl_clearinghouse_submission_xml_content_columns c
		  on c.submission_id = r.submission_id
		 and c.table_id = r.table_id
		/* Left */ join clearing_house.tbl_clearinghouse_submission_xml_content_values v
		  on v.submission_id = r.submission_id
		 and v.table_id = r.table_id
		 and v.local_db_id = r.local_db_id
		 and v.column_id = c.column_id
		/* Check if public record pointed to by FK exists in local DB. In such case set FK value to -fk_local_db_id */
		Left join temp_fk_references f
		  on f.submission_id = r.submission_id
		 and f.table_id = r.table_id
		 and f.column_id = c.column_id
		 and f.local_db_id = v.local_db_id
		 and f.fk_local_db_id = v.fk_local_db_id
		where 1 = 1
		 and r.submission_id = p_submission_id
		 and r.table_id = v_table_id
		group by r.local_db_id, r.public_db_id;

    Drop Table If Exists temp_fk_references;

end $$ language plpgsql;

create or replace function clearing_house.fn_copy_extracted_values_to_entity_table(
    p_submission_id int,
    p_table_name_underscored character varying(255),
    p_dry_run boolean=FALSE
) Returns text As $$

    declare v_field_names character varying(255)[];
    declare v_fields character varying(255)[];

    declare insert_columns_string text;
    declare select_columns_string text;

    declare v_sql text;
    declare i integer;

begin

    If clearing_house.fn_table_exists(p_table_name_underscored) = false then
        Raise Exception 'Table does not exist: %', p_table_name_underscored;
        return null;
    end if;

    v_sql := format('delete from clearing_house.%I where submission_id = %s;', p_table_name_underscored, p_submission_id);

    if not p_dry_run then
        execute v_sql;
    end if;

    v_field_names := clearing_house.fn_get_submission_table_column_names(p_submission_id, p_table_name_underscored);
    v_fields :=  clearing_house.fn_get_submission_table_value_field_array(p_submission_id, p_table_name_underscored);

    if not (v_field_names is null or array_length(v_field_names, 1) = 0) then

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
        insert into clearing_house.%s (submission_id, source_id, local_db_id, %s)
            select v.submission_id, 1 as source_id, -v.local_db_id, %s
            from clearing_house.fn_get_extracted_values_as_arrays(%s, ''%s'') as v(submission_id, table_name, local_db_id, public_db_id, values)
        ', p_table_name_underscored, insert_columns_string, select_columns_string, p_submission_id, p_table_name_underscored);

        if not p_dry_run then
            execute v_sql;
        end if;

    end if;

    return v_sql;

end $$ language plpgsql;
