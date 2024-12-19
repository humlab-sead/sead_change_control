/*****************************************************************************************************************************
 **	Function	fn_DD2DMS
 **	Who			Roger Mähler
 **	When		2013-10-14
 **	What		Converts geoposition DD to DMS
 **	Uses
 **	Used By     DEPREACTED - NOT USED
 **	Revisions
 ******************************************************************************************************************************/
create or replace function clearing_house.fn_DD2DMS(p_decimal_degree in float, p_degree_symbol in varchar(1) = 'd', p_minute_symbol in varchar(1) = 'm', p_second_symbol in varchar(1) = 's')
    returns varchar (50)
    as $$
declare
    v_degree int;
    v_minute int;
    v_second float;
begin
    v_degree := trunc(p_decimal_degree)::int;
    v_minute := trunc((abs(p_decimal_degree) - abs(v_degree)) * 60)::int;
    v_second := round(((((abs(p_decimal_degree) - abs(v_degree)) * 60) - v_minute) * 60)::numeric, 3)::float;
    return trim(to_char(v_degree, '9999')) || p_degree_symbol::text || trim(to_char(v_minute, '99')) || p_minute_symbol::text || case when v_second = 0::float then
        '0'
    else
        replace(trim(to_char(v_second, '99.999')), '.000', '')
    end || p_second_symbol::text;
end
$$
language plpgsql;


/*****************************************************************************************************************************
 **	Function	fn_pascal_case_to_underscore i.e. pascal/camel_case_to_snake_case
 **	Who			Roger Mähler
 **	When		2013-10-14
 **	What		Converts PascalCase to pascal_case
 **	Uses
 **	Used By
 **	Revisions   Add underscore before digits as well e.g. "address1" becomes "address_1"
 **              previously: lower(Left(p_token, 1) || regexp_replace(substring(p_token from 2), E'([A-Z])', E'\_\\1','g'));
 ******************************************************************************************************************************/
-- Select fn_pascal_case_to_underscore('c14AgeOlder'), clearing_house.fn_pascal_case_to_underscore('address1');
create or replace function clearing_house.fn_pascal_case_to_underscore(p_token character varying(255))
    returns character varying (255)
    as $$
begin
    return lower(regexp_replace(p_token, '([[:lower:]]|[0-9])([[:upper:]]|[0-9]$)', '\1_\2', 'g'));
end
$$
language plpgsql;


/*****************************************************************************************************************************
**	Function	fn_java_type_to_postgresql
**	Who			Roger Mähler
**	When		2013-10-14
**	What		Converts Java type to PostgreSQL data type
**	Uses
**	Used By
**	Revisions
******************************************************************************************************************************/
-- Select fn_pascal_case_to_underscore('RogerMahler')
create or replace function clearing_house.fn_java_type_to_postgresql(s_type_name character varying)
    returns character varying
    language 'plpgsql'
    as $BODY$
begin

    if (s_type_name like 'com.sead.database.Tbl%' or s_type_name like 'Tbl%') then
        /* FK type must always be of integer type */
        return 'integer';
    end if;

    return case lower(s_type_name)
            when 'java.util.date' then 'date'
            when 'java.sql.date' then 'date'
            when 'java.math.bigdecimal' then 'numeric'
            when 'java.lang.double' then 'numeric'
            when 'java.lang.integer' then 'integer'
            when 'java.util.integer' then 'integer'
            when 'java.lang.short' then 'integer'
            when 'java.lang.boolean' then 'boolean'
            when 'java.lang.string' then 'text'
            when 'java.lang.character' then 'text'
            when 'java.util.uuid' then 'uuid'
            -- the following types are not supported:
            when 'java.util.intrange' then 'int4range'
            when 'java.util.numrange' then 'numrange'
            else 'error[unknown java type: ' || s_type_name || ']'
        end;
    -- raise exception 'Fatal error: Java type % encountered in XML not expected', s_type_name;
end
$BODY$;    

/*****************************************************************************************************************************
 **	Function	fn_postgresql_java_type
 **	Who			Roger Mähler
 **	When		2024-12-15
 **	What		Converts PostgreSQL type to Java type
 **	Uses
 **	Used By
 **	Revisions
 ******************************************************************************************************************************/
-- Select fn_pascal_case_to_underscore('RogerMahler')
create or replace function clearing_house.fn_postgresql_java_type(s_type_name character varying)
    returns character varying
    language 'plpgsql'
    as $BODY$
begin
    if s_type_name like 'timestamp%' then
        return 'java.util.Date';
    end if;
    return case lower(s_type_name)
        --when is_fk = 'YES' then sead_utility.underscore_to_pascal_case(p_fk_table_name)
        when 'integer' then 'java.lang.Integer'
        when 'int' then 'java.lang.Integer'
        when 'bigint' then 'java.lang.Integer'
        when 'smallint' then 'java.lang.Short'
        when 'boolean' then 'java.lang.Boolean'
        when 'character varying' then 'java.lang.String'
        when 'text' then 'java.lang.String'
        when 'date' then 'java.util.Date'
        when 'numeric' then 'java.math.BigDecimal'
        when 'uuid' then 'java.util.UUID' -- We must support this
        when 'int4range' then 'java.util.IntRange' --This is not supported
        when 'numrange' then 'java.util.NumRange'--This is not supported
        else 'error[unknown type' || s_type_name || ']'
    end;
end
$BODY$;    

/*****************************************************************************************************************************
 **	Function	fn_table_exists
 **	Who			Roger Mähler
 **	When		2013-10-14
 **	What		Checks if table exists in current DB-schema
 **	Uses
 **	Used By
 **	Revisions
 ******************************************************************************************************************************/
-- Select fn_table_exists('tbl_submission_xml_content_meta_tables')
create or replace function clearing_house.fn_table_exists(p_table_name character varying(255))
    returns boolean
    as $$
declare
    exists boolean;
begin
    select
        count(*) > 0 into exists
    from
        information_schema.tables
    where
        table_catalog = CURRENT_CATALOG
        and table_schema = CURRENT_SCHEMA
        and table_name = p_table_name;
    return exists;
end
$$
language plpgsql;


/*****************************************************************************************************************************
 **	Function	fn_get_entity_type_for
 **	Who			Roger Mähler
 **	When		2013-10-14
 **	What		Returns entity type for table
 **	Uses
 **	Used By
 **	Revisions
 ******************************************************************************************************************************/
-- Select clearing_house.fn_get_entity_type_for('tbl_sites')
create or replace function clearing_house.fn_get_entity_type_for(p_table_name character varying(255))
    returns int
    as $$
declare
    table_entity_type_id int;
begin
    select
        x.entity_type_id into table_entity_type_id
    from
        clearing_house.tbl_clearinghouse_reject_entity_types x
        join clearing_house.tbl_clearinghouse_submission_tables t on x.table_id = t.table_id
    where
        table_name_underscored = p_table_name;

    return coalesce(table_entity_type_id, 0);
end
$$
language plpgsql;


/*****************************************************************************************************************************
 **	Function	fn_sead_table_entity_name
 **	Who			Roger Mähler
 **	When		2018-10-21
 **	What        Computes a noun from a sead table name in singular form
 **	Uses
 **	Used By     Clearinghouse transfer & commit
 **	Revisions
 ******************************************************************************************************************************/
create or replace function clearing_house.fn_sead_table_entity_name(p_table_name text)
    returns information_schema.sql_identifier
    as $$
begin
    return replace(
        case when p_table_name like '%ies' then
            regexp_replace(p_table_name, 'ies$', 'y')
        when not p_table_name like '%status' then
            rtrim(p_table_name, 's')
        else
            p_table_name
        end, 'tbl_', '')::information_schema.sql_identifier as entity_name;
end;
$$
language plpgsql;

-- Drop Function If Exists clearing_house.fn_dba_get_sead_public_db_schema(text, text);
/*********************************************************************************************************************************
 **  Function    view_foreign_keys
 **  When        2019-04-24
 **  What        Retrieves foreign keys from all schemas
 **  Who         Roger Mähler
 **  Uses        information_schema
 **  Used By     Clearing House installation. DBA.
 **  Note        Assumes all FK-constraints are single key value
 **  Revisions
 **********************************************************************************************************************************/
create or replace view clearing_house.view_foreign_keys as (
    with table_columns as (
        select
            t.oid,
            ns.nspname,
            t.relname,
            attr.attname,
            attr.attnum
        from
            pg_class t
            join pg_namespace ns on ns.oid = t.relnamespace
            join pg_attribute attr on attr.attrelid = t.oid
                and attr.attnum > 0
)
            select distinct
                t.nspname as schema_name,
                t.oid as table_oid,
                t.relname as table_name,
                t.attname as column_name,
                t.attnum as attnum,
                s.nspname as f_schema_name,
                s.relname as f_table_name,
                s.attname as f_column_name,
                s.oid as f_table_oid,
                t.attnum as f_attnum
            from
                pg_constraint
            join table_columns t on t.oid = pg_constraint.conrelid
                and t.attnum = pg_constraint.conkey[1]
                and (t.attnum = any (pg_constraint.conkey))
            join table_columns s on s.oid = pg_constraint.confrelid
                and (s.attnum = any (pg_constraint.confkey))
        where
            pg_constraint.contype = 'f'::"char");


/*********************************************************************************************************************************
 **  Function    fn_dba_get_sead_public_db_schema
 **  When        2013-10-18
 **  What        Retrieves SEAD public db schema catalog
 **  Who         Roger Mähler
 **  Uses        INFORMATION_SCHEMA.catalog in SEAD production
 **  Used By     Clearing House installation. DBA.
 **  Revisions   2018-06-23 Major rewrite using pg_xxx tables for faster performance and FK inclusion
 **********************************************************************************************************************************/
-- select * from clearing_house.fn_dba_get_sead_public_db_schema3('public')
create or replace function clearing_house.fn_dba_get_sead_public_db_schema(p_schema_name text default 'public', p_owner text default 'sead_master')
    returns table(
        table_schema information_schema.sql_identifier,
        table_name information_schema.sql_identifier,
        column_name information_schema.sql_identifier,
        ordinal_position information_schema.cardinal_number,
        data_type information_schema.character_data,
        numeric_precision information_schema.cardinal_number,
        numeric_scale information_schema.cardinal_number,
        character_maximum_length information_schema.cardinal_number,
        is_nullable information_schema.yes_or_no,
        is_pk information_schema.yes_or_no,
        is_fk information_schema.yes_or_no,
        fk_table_name information_schema.sql_identifier,
        fk_column_name information_schema.sql_identifier,
        column_default text)
    language 'plpgsql'
    as $body$
begin
    return query
    select
        pg_tables.schemaname::information_schema.sql_identifier as table_schema,
        pg_tables.tablename::information_schema.sql_identifier as table_name,
        pg_attribute.attname::information_schema.sql_identifier as column_name,
        pg_attribute.attnum::information_schema.cardinal_number as ordinal_position,
        format_type(pg_attribute.atttypid, null)::information_schema.character_data as data_type,
        case pg_attribute.atttypid
            when 21 /*int2*/ then 16
            when 23 /*int4*/ then 32
            when 20 /*int8*/ then 64
            when 1700 /*numeric*/ then
                case
                    when pg_attribute.atttypmod = - 1 then null
                    else ((pg_attribute.atttypmod - 4) >> 16) & 65535 -- calculate the precision
                end
            when 700 /*float4*/ then 24 /*flt_mant_dig*/
            when 701 /*float8*/ then 53 /*dbl_mant_dig*/
            else null
            end::information_schema.cardinal_number as numeric_precision,
        case
            when pg_attribute.atttypid in (21, 23, 20) then 0
            when pg_attribute.atttypid in (1700) then
                case when pg_attribute.atttypmod = - 1 then
                    null
                else
                    (pg_attribute.atttypmod - 4) & 65535 -- calculate the scale
                end
            else
                null
            end::information_schema.cardinal_number as numeric_scale,
        case
            when pg_attribute.atttypid not in (1042, 1043) or pg_attribute.atttypmod = - 1 then
                null
            else
                pg_attribute.atttypmod - 4
            end::information_schema.cardinal_number as character_maximum_length,
        case pg_attribute.attnotnull
            when false
                then 'YES'
            else 'NO'
            end::information_schema.yes_or_no as is_nullable,
        case when pk.contype is null then 'NO' else 'YES' end::information_schema.yes_or_no as is_pk,
        case when fk.table_oid is null then 'NO' else 'YES' end::information_schema.yes_or_no as is_fk,
        fk.f_table_name::information_schema.sql_identifier,
        fk.f_column_name::information_schema.sql_identifier,
        d.column_default::text
    from pg_tables
    join pg_class
      on pg_class.relname = pg_tables.tablename
    join pg_namespace ns
      on ns.oid = pg_class.relnamespace
     and ns.nspname = pg_tables.schemaname
    join pg_attribute
      on pg_class.oid = pg_attribute.attrelid
     and pg_attribute.attnum > 0
    left join pg_constraint pk
      on pk.contype = 'p'::"char"
     and pk.conrelid = pg_class.oid
     and (pg_attribute.attnum = any(pk.conkey))
    left join clearing_house.view_foreign_keys as fk
      on fk.table_oid = pg_class.oid
     and fk.attnum = pg_attribute.attnum
    left join information_schema.columns d
      on d.table_schema = pg_tables.schemaname::information_schema.sql_identifier
     and d.table_name = pg_tables.tablename::information_schema.sql_identifier
     and d.column_name = pg_attribute.attname::information_schema.sql_identifier        
    where true
      and pg_tables.tableowner = p_owner
      and pg_attribute.atttypid <> 0::oid
      and pg_tables.schemaname = p_schema_name
    order by 2, 4 asc;
end
$body$;

create or replace function clearing_house.chown(in_schema character varying, new_owner character varying)
    returns void
    as $$
declare
    object_types varchar[];
    object_classes varchar[];
    object_type record;
    r record;
begin
    object_types = '{type,table,table,sequence,index,view}';
    object_classes = '{c,t,r,S,i,v}';

    for object_type in
    select
        unnest(object_types) type_name,
        unnest(object_classes) code loop
            for r in
            select
                n.nspname,
                c.relname
            from
                pg_class c,
                pg_namespace n
            where
                n.oid = c.relnamespace
                and nspname = in_schema
                and relkind = object_type.code loop
                    raise notice 'Changing ownership of % %.% to %', object_type.type_name, r.nspname, r.relname, new_owner;
                    execute format('alter %s %I.%I owner to %I', object_type.type_name, r.nspname, r.relname, new_owner);
                end loop;
        end loop;

    for r in
    select
        p.proname,
        n.nspname,
        pg_catalog.pg_get_function_identity_arguments(p.oid) args
    from
        pg_catalog.pg_namespace n
        join pg_catalog.pg_proc p on p.pronamespace = n.oid
    where
        n.nspname = in_schema loop
            raise notice 'Changing ownership of function %.%(%) to %', r.nspname, r.proname, r.args, new_owner;
            execute format('alter function %I.%I (%s) owner to %I', r.nspname, r.proname, r.args, new_owner);
        end loop;

    for r in
    select
        *
    from
        pg_catalog.pg_namespace n
        join pg_catalog.pg_ts_dict d on d.dictnamespace = n.oid
    where
        n.nspname = in_schema loop
            execute format('alter text search dictionary %I.%I owner to %I', r.nspname, r.dictname, new_owner);
        end loop;
end
$$
language plpgsql;

