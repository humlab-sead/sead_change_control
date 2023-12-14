-- Deploy utility: 20221118_DDL_GENERATE_SQLITE_SCHEMA

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin

    begin

        if sead_utility.column_exists('public'::text, 'table_name'::text, 'column_name'::text) = TRUE then
            raise exception SQLSTATE 'GUARD';
        end if;

        create or replace function sead_utility.fn_script_to_sqlite_columns(
            )
            returns table(table_name information_schema.sql_identifier, column_name information_schema.sql_identifier, ordinal_position information_schema.cardinal_number, data_type text, is_nullable information_schema.yes_or_no, is_pk information_schema.yes_or_no, is_fk information_schema.yes_or_no, fk_table_name information_schema.sql_identifier, fk_column_name information_schema.sql_identifier)
            LANGUAGE 'plpgsql'

        as $BODY$
        begin
                return query
                    select
                        pg_tables.tablename::information_schema.sql_identifier  as table_name,
                        pg_attribute.attname::information_schema.sql_identifier as column_name,
                        pg_attribute.attnum::information_schema.cardinal_number as ordinal_position,
                        case
                        when pg_attribute.atttypid in (16, 20, 21, 23) then 'integer'
                        when pg_attribute.atttypid in (18, 19, 25, 1002, 1043, 1082, 1114, 1184, 12790, 12797) then 'text'
                        when pg_attribute.atttypid in (700, 1700) then 'numeric'
                        when pg_attribute.atttypid in (17, 1005, 1009, 1021) then 'blob'
                        else null end::text,
                        case pg_attribute.attnotnull when false then 'YES' else 'NO' end::information_schema.yes_or_no as is_nullable,
                        case when pk.contype is null then 'NO' else 'YES' end::information_schema.yes_or_no as is_pk,
                        case when fk.table_oid is null then 'NO' else 'YES' end::information_schema.yes_or_no as is_fk,
                        fk.f_table_name::information_schema.sql_identifier,
                        fk.f_column_name::information_schema.sql_identifier
                from pg_tables
                join pg_class
                on pg_class.relname = pg_tables.tablename
                join pg_namespace ns
                on ns.oid = pg_class.relnamespace
                and ns.nspname  = pg_tables.schemaname
                join pg_attribute
                on pg_class.oid = pg_attribute.attrelid
                and pg_attribute.attnum > 0
                left join pg_constraint pk
                on pk.contype = 'p'::"char"
                and pk.conrelid = pg_class.oid
                and (pg_attribute.attnum = any (pk.conkey))
                left join clearing_house.view_foreign_keys as fk
                on fk.table_oid = pg_class.oid
                and fk.attnum = pg_attribute.attnum
                where true
                and pg_tables.tableowner = 'sead_master'
                and pg_attribute.atttypid <> 0::oid
                and pg_tables.schemaname = 'public'
                order by table_name, ordinal_position asc;
        end
$BODY$;

        create or replace function sead_utility.fn_script_to_sqlite_table(
            p_source_schema character varying,
            p_table_name character varying)
            returns text
            language 'plpgsql'
        as $BODY$
            Declare sql_stmt text;
            Declare data_columns text;
            Declare foreign_key_columns text;
        Begin

            Select string_agg(
                format('%s %s%s%s', column_name, data_type,
                    case when is_nullable = 'NO' then ' NOT NULL' else '' end,
                    case when is_pk = 'YES' then ' PRIMARY' else '' end
                ), E',\n        ' ORDER BY ordinal_position ASC),
                string_agg(
                    case when is_fk = 'NO' then ''
                        else format(E'      , FOREIGN KEY (%s) REFERENCES %s (%s) ON DELETE NO ACTION ON UPDATE NO ACTION\n',
                                    column_name, fk_table_name, fk_column_name) end
                    , '')

            Into Strict data_columns, foreign_key_columns
            From sead_utility.fn_script_to_sqlite_columns() s
            Where table_name = p_table_name;

            sql_stmt = format('Create Table %s (
                %s
                %s
            );', p_table_name, data_columns, foreign_key_columns);

            Return sql_stmt;
        End
$BODY$;

        create or replace function sead_utility.fn_script_to_sqlite_tables(
            )
            returns character varying
            language 'plpgsql'
        as $BODY$
        Declare x RECORD;
            Declare create_script text;
        Begin
            create_script := '';
            For x In (

                with recursive fk_tree as (
                -- All tables not referencing anything else
                select t.oid as reloid,
                        t.relname as table_name,
                        s.nspname as schema_name,
                        null::text as referenced_table_name,
                        null::text as referenced_schema_name,
                        1 as level
                from pg_class t
                    join pg_namespace s on s.oid = t.relnamespace
                where relkind = 'r'
                    and not exists (select * from pg_constraint where contype = 'f' and conrelid = t.oid)
                    and s.nspname = 'public' -- limit to one schema
                union all
                select ref.oid, ref.relname, rs.nspname, p.table_name, p.schema_name, p.level + 1
                from pg_class ref
                join pg_namespace rs on rs.oid = ref.relnamespace
                join pg_constraint c on c.contype = 'f' and c.conrelid = ref.oid
                join fk_tree p on p.reloid = c.confrelid
                where ref.oid != p.reloid  -- do not enter to tables referencing theirselves.
                ), all_tables as (
                -- this picks the highest level for each table
                select schema_name, table_name, level,
                        row_number() over (partition by schema_name, table_name order by level desc) as last_table_row
                from fk_tree
                )
                select schema_name, table_name
                from all_tables at
                where last_table_row = 1
                order by level

            )
            Loop
                create_script := create_script || E'\n' || sead_utility.fn_script_to_sqlite_table(x.schema_name::character varying, x.table_name::character varying);
                Raise Notice '%', create_script;
            End Loop;
            return create_script;
        End
        $BODY$;

        alter function sead_utility.fn_script_to_sqlite_tables()
            owner to humlab_admin;

        alter function sead_utility.fn_script_to_sqlite_table(character varying, character varying)
            owner to humlab_admin;

        alter function sead_utility.fn_script_to_sqlite_columns()
            owner to humlab_admin;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
