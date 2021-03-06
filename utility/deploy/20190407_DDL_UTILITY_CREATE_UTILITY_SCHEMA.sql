-- Deploy sead_db_change_control:create_sead_utility_schema to pg


begin;

    create schema if not exists sead_utility;

    create or replace function sead_utility.schema_exists(p_schema_name text)
      returns bool as
    $$
        select exists (
            select 1 from information_schema.schemata where schema_name = p_schema_name
        );
    $$  language sql;

    create or replace function sead_utility.table_exists(p_schema_name text, p_table_name text)
      returns bool as
    $$
        select exists (
            select 1
            from pg_catalog.pg_class as c
            join pg_catalog.pg_namespace as ns
              on c.relnamespace = ns.oid
            where c.oid::regclass::text = p_table_name
              and ns.nspname = p_schema_name
        );
    $$  language sql;

    create or replace function sead_utility.column_exists(p_schema_name text, p_table_name text, p_column_name text)
      returns bool as
    $$
        select exists (
            select 1
            from pg_catalog.pg_attribute as a
            join pg_catalog.pg_class as c
              on a.attrelid = c.oid
            join pg_catalog.pg_namespace as ns
              on c.relnamespace = ns.oid
            where c.oid::regclass::text in ( p_table_name, p_schema_name || '.' || p_table_name )
              and a.attname = p_column_name
              and ns.nspname = p_schema_name
              and attnum > 0
        );
    $$  language sql;


    create or replace view sead_utility.view_table_columns as (
        with fk_constraint as (
            select distinct fk.conrelid, fk.confrelid, fk.conkey,
                    fk.confrelid::regclass::information_schema.sql_identifier as fk_table_name,
                    fkc.attname::information_schema.sql_identifier as fk_column_name
            from pg_constraint as fk
            join pg_attribute fkc
            on fkc.attrelid = fk.confrelid
            and fkc.attnum = fk.confkey[1]
            where fk.contype = 'f'::char
        )
            select  pg_tables.schemaname::information_schema.sql_identifier as table_schema,
                pg_tables.tablename::information_schema.sql_identifier as table_name,
                pg_attribute.attname::information_schema.sql_identifier as column_name,
                pg_attribute.attnum::information_schema.cardinal_number as ordinal_position,
                format_type(pg_attribute.atttypid, null)::information_schema.character_data as data_type,
                case pg_attribute.atttypid
                    when 21 /*int2*/ then 16
                    when 23 /*int4*/ then 32
                    when 20 /*int8*/ then 64
                    when 1700 /*numeric*/ then
                        case when pg_attribute.atttypmod = -1
                            then null
                            else ((pg_attribute.atttypmod - 4) >> 16) & 65535     -- calculate the precision
                            end
                    when 700 /*float4*/ then 24 /*flt_mant_dig*/
                    when 701 /*float8*/ then 53 /*dbl_mant_dig*/
                    else null
                end::information_schema.cardinal_number as numeric_precision,
                case
                when pg_attribute.atttypid in (21, 23, 20) then 0
                when pg_attribute.atttypid in (1700) then
                    case
                        when pg_attribute.atttypmod = -1 then null
                        else (pg_attribute.atttypmod - 4) & 65535            -- calculate the scale
                    end
                else null
                end::information_schema.cardinal_number as numeric_scale,
                case when pg_attribute.atttypid not in (1042,1043) or pg_attribute.atttypmod = -1 then null
                    else pg_attribute.atttypmod - 4 end::information_schema.cardinal_number as character_maximum_length,
                case pg_attribute.attnotnull when false then 'YES' else 'NO' end::information_schema.yes_or_no as is_nullable,
                case when pk.contype is null then 'NO' else 'YES' end::information_schema.yes_or_no as is_pk,
                case when fk.conrelid is null then 'NO' else 'YES' end::information_schema.yes_or_no as is_fk,
                fk.fk_table_name,
                fk.fk_column_name
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
        left join fk_constraint as fk
          on fk.conrelid = pg_class.oid
         and (pg_attribute.attnum = any (fk.conkey))
        where true
          --and pg_tables.tableowner = 'sead_master'
          and pg_attribute.atttypid <> 0::oid
          and pg_tables.schemaname = 'public'
        order by table_name, ordinal_position asc
    );

    create or replace function sead_utility.create_consolidated_references_view(p_fk_column_name varchar)
        returns text as $$
    declare
        v_sql text;
        v_table_name varchar;
        v_view_name varchar;
        v_pk_column_name varchar;
    begin
        v_sql = '';
        v_view_name = 'sead_utility.view_consolidated_' || p_fk_column_name;
        for v_table_name, v_pk_column_name in
            select fk.table_name, pk.column_name as pk_column_name
            from sead_utility.view_table_columns fk
            join sead_utility.view_table_columns pk
              on pk.table_name = fk.table_name
             and pk.is_pk = 'YES'
            where fk.is_fk = 'YES'
              and fk.column_name = p_fk_column_name
        loop
                if v_sql <> '' then
                    v_sql = v_sql || '    union all' || E'\n';
                end if;
                v_sql = v_sql || '    select ''' || v_table_name || ''' as table_name, ''' || v_pk_column_name || ''' as pk_column_name, ' ||
                    v_pk_column_name || ' as pk_id, ' ||
                    p_fk_column_name || ' as fk_id ' ||
                    'from ' || v_table_name || E'\n';
                raise notice '%', v_table_name;
        end loop;
        v_sql = 'create or replace view ' || v_view_name || ' as (' || E'\n' || v_sql || ');' || E'\n';
        raise notice '%', v_sql;
        return v_sql;
    end $$ language plpgsql;

    create or replace function sead_utility.set_as_serial(p_table_name character varying, p_column_name character varying)
              returns integer as $$
    declare
        v_start_with integer;
        v_sequence_name text;
        v_sql text;
    begin

        select pg_get_serial_sequence(p_table_name, p_column_name)
            into v_sequence_name;

        execute format('select coalesce(max(%s), 0) + 1 from %s;', p_column_name, p_table_name) into v_start_with;

        if v_sequence_name is null then
            v_sequence_name = format('%s_%s_seq', p_table_name, p_column_name);
            execute format('create sequence %s start with %s owned by %s.%s;', v_sequence_name, v_start_with, p_table_name, p_column_name);
            execute format('alter sequence %s owner to sead_master;', v_sequence_name);
            execute format('alter table %s alter column %s set default nextval(''%s'');', p_table_name, p_column_name, v_sequence_name);
        else
            execute format('alter sequence %s owned by %s.%s;', v_sequence_name, p_table_name, p_column_name);
        end if;
        return v_start_with;
    end;
    $$ language plpgsql volatile;

commit;
