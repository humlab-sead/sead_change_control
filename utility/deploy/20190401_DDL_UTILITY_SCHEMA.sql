-- Deploy utility: 20190401_DDL_UTILITY_SCHEMA
/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-04-07
  Description   Schema for DB global utility objects
  Issue         https://github.com/humlab-sead/sead_change_control/issues/202
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
*****************************************************************************************************************/

begin;

    set role sead_master;
    create schema if not exists public authorization sead_master;
    reset role;

    create schema if not exists sead_utility;

    create extension if not exists "uuid-ossp" schema public;

    create or replace procedure sead_utility.set_schema_privilege(p_schema_name text, p_user_name text, level text, variadic p_for_roles text[] default null) as $$
    declare
        command text;
        v_for_role text;
    begin

        if p_for_roles is null or array_length(p_for_roles, 1) < 1 or p_for_roles[0] is null then
             p_for_roles = array['current_user'];
        end if;

        foreach v_for_role in array p_for_roles loop
            -- Revoke all privileges first
            command := format('
                revoke all on all tables in schema %1$I from %2$I; 
                revoke all on all sequences in schema %1$I from %2$I; 
                revoke all on all functions in schema %1$I from %2$I; 
                alter default privileges in schema %1$I for role %3$s revoke all on tables from %2$I; 
                alter default privileges in schema %1$I for role %3$s revoke all on sequences from %2$I; 
                alter default privileges in schema %1$I for role %3$s revoke all on functions from %2$I;
            ', p_schema_name, p_user_name, v_for_role);
            execute command;

            -- Grant privileges based on the level
            if level = 'read' then
                command := format('
                    grant select on all tables in schema %1$I to %2$I; 
                    grant select on all sequences in schema %1$I to %2$I; 
                    grant execute on all functions in schema %1$I to %2$I; 
                    alter default privileges in schema %1$I for role %3$s grant select on tables to %2$I; 
                    alter default privileges in schema %1$I for role %3$s grant select on sequences to %2$I; 
                    alter default privileges in schema %1$I for role %3$s grant execute on functions to %2$I;
                ', p_schema_name, p_user_name, v_for_role);
            elsif level = 'read/write' then
                command := format('
                    grant all on all tables in schema %1$I to %2$I; 
                    grant all on all sequences in schema %1$I to %2$I; 
                    grant execute on all functions in schema %1$I to %2$I; 
                    alter default privileges in schema %1$I for role %3$s grant all on tables to %2$I; 
                    alter default privileges in schema %1$I for role %3$s grant all on sequences to %2$I; 
                    alter default privileges in schema %1$I for role %3$s grant execute on functions to %2$I;
                ', p_schema_name, p_user_name, v_for_role);
            elsif level = 'admin' then
                command := format('
                    grant all on schema %1$I to %2$I; 
                    grant all on all tables in schema %1$I to %2$I; 
                    grant all on all sequences in schema %1$I to %2$I; 
                    grant all on all functions in schema %1$I to %2$I; 
                    alter default privileges in schema %1$I for role %3$s grant all on tables to %2$I; 
                    alter default privileges in schema %1$I for role %3$s grant all on sequences to %2$I; 
                    alter default privileges in schema %1$I for role %3$s grant all on functions to %2$I;
                ', p_schema_name, p_user_name, v_for_role);
            end if;

            if command is not null then
                -- raise notice '%', command;
                execute command;
            end if;
        end loop;
    end;
    $$ language plpgsql;

    create or replace function sead_utility.schema_exists(p_schema_name text)
      returns bool as
    $$
        select exists (
            select 1 from information_schema.schemata where schema_name = p_schema_name
        );
    $$  language sql;

    create or replace function sead_utility.view_exists(p_schema_name text, p_view_name text)
      returns bool as
    $$
        select exists (
            select 1 from information_schema.views
            where table_schema = p_schema_name
              and table_name = p_view_name
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


    create or replace view sead_utility.table_columns as (
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
            from sead_utility.table_columns fk
            join sead_utility.table_columns pk
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

    create or replace function sead_utility.set_fk_is_deferrable(p_schema text, p_is_deferrable boolean, dry_run boolean=FALSE)
        returns void as $$
    declare
        v_sql text;
        r record;
    begin

        for r in
            select distinct tc.table_schema, tc.table_name, tc.constraint_name
            from information_schema.table_constraints AS tc
            join information_schema.key_column_usage AS kcu
              on tc.constraint_name = kcu.constraint_name
             and tc.table_schema = kcu.table_schema
            join information_schema.constraint_column_usage AS ccu
              on ccu.constraint_name = tc.constraint_name
             and ccu.table_schema = tc.table_schema
            where tc.table_schema = p_schema
             and tc.constraint_type = 'FOREIGN KEY'
             and tc.is_deferrable = case when p_is_deferrable = TRUE then 'NO' else 'YES' end
        loop
            if p_is_deferrable = TRUE then
                v_sql = format('alter table %s."%s" alter constraint "%s" deferrable;', -- initially immediate
                    r.table_schema,
                    r.table_name,
                    r.constraint_name
                );
            else
                v_sql = format('alter table %s."%s" alter constraint "%s" not deferrable;',
                    r.table_schema,
                    r.table_name,
                    r.constraint_name
                );
            end if;
            if not dry_run then
                execute v_sql;
            else
	            raise notice '%', v_sql;
			end if;
        end loop;
    end $$ language plpgsql;

    create or replace function sead_utility.constraint_exists(s_schema_name text, s_table_name text, variadic v_columns text[])
        returns text
    language plpgsql
        as $function$
            declare v_constraint_name text;
        begin

        v_constraint_name = null;

        select tc.constraint_name into v_constraint_name
        from information_schema.table_constraints as tc 
        join information_schema.key_column_usage as kcu
          on tc.constraint_name = kcu.constraint_name
        join information_schema.constraint_column_usage as ccu
          on ccu.constraint_name = tc.constraint_name
        where tc.constraint_type = 'UNIQUE'
          and tc.constraint_schema = s_schema_name
          and tc.table_name=s_table_name
          and kcu.column_name = any(v_columns)
        group by tc.constraint_name, tc.table_name, kcu.column_name
        having count(*) = array_length(v_columns, 1);

        return v_constraint_name;

    end
    $function$;

    create or replace function sead_utility.get_all_table_counts(p_schema_name text = 'public')
        returns table (
            schema_name text,
            table_name text,
            count bigint
        ) as $$
    declare _t record;
    begin
        for _t in (select schemaname, tablename from pg_tables where schemaname = p_schema_name) loop
            return query execute format('select %L::text as schema_name, %L::text as table_name, count(*)::bigint as count from %I.%I',
                _t.schemaname,
                _t.tablename,
                _t.schemaname,
                _t.tablename
            );
        end loop;
    end $$ language plpgsql;

    create view sead_utility.foreign_keys_index_check2 as
        select c.connamespace::regclass, conrelid::regclass as table_with_fk, a.attname as fk_column
        from pg_attribute a 
        join pg_constraint c on a.attnum = any(c.conkey)
        where c.confrelid > 0 
         and not exists (
             select 1 
             from pg_index i 
             where i.indrelid = c.conrelid 
             and a.attnum = any(i.indkey)
         )
         and a.attnum > 0 
         and not a.attisdropped 
         and a.attrelid = c.conrelid 
         and c.connamespace = 'public'::regnamespace;
	
    -- check FKs there's no matching index on the target column
    create view sead_utility.foreign_keys_index_check as
        with fk_actions (code, action) as ( values 
            ('a', 'error'),
            ('r', 'restrict'),
            ('c', 'cascade'),
            ('n', 'set null'),
            ('d', 'set default')
        ),
        fk_list as (
            select pg_constraint.oid as fkoid,
                conrelid,
                confrelid as parentid,
                conname,
                relname,
                nspname,
                fk_actions_update.action as update_action,
                fk_actions_delete.action as delete_action,
                conkey as key_cols
            from pg_constraint
                join pg_class on conrelid = pg_class.oid
                join pg_namespace on pg_class.relnamespace = pg_namespace.oid
                join fk_actions as fk_actions_update on confupdtype = fk_actions_update.code
                join fk_actions as fk_actions_delete on confdeltype = fk_actions_delete.code
            where contype = 'f'
        ),
        fk_attributes AS (
            select fkoid, conrelid, attname, attnum
            from fk_list
            join pg_attribute on conrelid = attrelid
            and attnum = any(key_cols)
            order by fkoid, attnum
        ),
        fk_cols_list AS (
            select fkoid, array_agg(attname) as cols_list
            from fk_attributes
            group by fkoid
        ),
        index_list AS (
            select indexrelid as indexid,
                pg_class.relname as indexname,
                indrelid,
                indkey,
                indpred is not null as has_predicate,
                pg_get_indexdef(indexrelid) as indexdef
            from pg_index
            join pg_class on indexrelid = pg_class.oid
            where indisvalid
        ),
        fk_index_match AS (
            select fk_list.*,
                indexid,
                indexname,
                indkey::int [] as indexatts,
                has_predicate,
                indexdef,
                array_length(key_cols, 1) as fk_colcount,
                array_length(indkey, 1) as index_colcount,
                round(pg_relation_size(conrelid) /(1024 ^ 2)::numeric) as table_mb,
                cols_list
            from fk_list
            join fk_cols_list using (fkoid)
            left outer join index_list on conrelid = indrelid
            and (indkey::int2 []) [0:(array_length(key_cols,1) -1)] @> key_cols
        ),
        fk_perfect_match AS (
            select fkoid
            from fk_index_match
            where (index_colcount - 1) <= fk_colcount
            and not has_predicate
            and indexdef LIKE '%USING btree%'
        ),
        fk_index_check AS (
            select 'no index' as issue, *, 1 as issue_sort
            from fk_index_match
            where indexid is null
            union all
            select 'questionable index' as issue, *, 2
            from fk_index_match
            where indexid is not null
            and fkoid not in ( select fkoid from fk_perfect_match )
        ),
        parent_table_stats AS (
            select fkoid,
                tabstats.relname as parent_name,
                (
                    n_tup_ins + n_tup_upd + n_tup_del + n_tup_hot_upd
                ) as parent_writes,
                round(pg_relation_size(parentid) /(1024 ^ 2)::numeric) as parent_mb
            from pg_stat_user_tables as tabstats
            join fk_list on relid = parentid
        ),
        fk_table_stats AS (
            select fkoid,
                (
                    n_tup_ins + n_tup_upd + n_tup_del + n_tup_hot_upd
                ) as writes,
                seq_scan as table_scans
            from pg_stat_user_tables as tabstats
            join fk_list on relid = conrelid
        )
        select nspname as schema_name,
            relname as table_name,
            conname as fk_name,
            issue,
            table_mb,
            writes,
            table_scans,
            parent_name,
            parent_mb,
            parent_writes,
            cols_list,
            indexdef
        from fk_index_check
            join parent_table_stats using (fkoid)
            join fk_table_stats using (fkoid)
        where true -- table_mb > 9
            --     and ( writes > 1000
            --         or parent_writes > 1000
            --         or parent_mb > 10 )
        order by issue_sort, table_mb desc, table_name, fk_name;

        create or replace function sead_utility.pascal_case_to_underscore(p_token character varying) returns character varying
        as $$
        begin
            return lower(regexp_replace(p_token,'([[:lower:]]|[0-9])([[:upper:]]|[0-9]$)','\1_\2','g'));
        end 
        $$ language 'plpgsql';

        create or replace function sead_utility.underscore_to_pascal_case(str text, lower_first bool=false) returns text as $$
        declare v_result text;
        begin
            v_result = replace(initcap(str), '_', '');
            if lower_first = true then
                v_result = concat(lower(substring(v_result from 1 for 1)), substring(v_result from 2));
            end if;
            return v_result;
        end;
        $$ language plpgsql;


    create or replace function sead_utility.chown(in_schema character varying, new_owner character varying)
        returns void as $$
        declare
            object_types varchar[];
            object_classes varchar[];
            object_type record;
            r record;
        begin
            object_types = '{type,table,table,sequence,index,view}';
            object_classes = '{c,t,r,S,i,v}';

            for object_type in
                select unnest(object_types) type_name,
                            unnest(object_classes) code
            loop
                for r in
                    select n.nspname, c.relname
                    from pg_class c, pg_namespace n
                    where n.oid = c.relnamespace
                        and nspname = in_schema
                        and relkind = object_type.code
                loop
                raise notice 'Changing ownership of % %.% to %',
                            object_type.type_name,
                            r.nspname, r.relname, new_owner;
                execute format(
                    'alter %s %I.%I owner to %I'
                    , object_type.type_name, r.nspname, r.relname,new_owner);
                end loop;
            end loop;

            for r in
                select  p.proname, n.nspname,
                pg_catalog.pg_get_function_identity_arguments(p.oid) args
                from    pg_catalog.pg_namespace n
                join    pg_catalog.pg_proc p
                on      p.pronamespace = n.oid
                where   n.nspname = in_schema
            loop
                raise notice 'Changing ownership of function %.%(%) to %',
                            r.nspname, r.proname, r.args, new_owner;
                execute format(
                'alter function %I.%I (%s) owner to %I', r.nspname, r.proname, r.args, new_owner);
            end loop;

            for r in
                select *
                from pg_catalog.pg_namespace n
                join pg_catalog.pg_ts_dict d
                on d.dictnamespace = n.oid
                where n.nspname = in_schema
            loop
                execute format(
                'alter text search dictionary %I.%I owner to %I', r.nspname, r.dictname, new_owner );
            end loop;
        end $$ language plpgsql;


        create or replace function sead_utility.get_column_type(p_schema text, p_table text, p_column text)
        returns text as $$
        declare
            v_data_type text;
        begin
            select data_type into v_data_type
            from information_schema.columns
            where table_schema = p_schema
            and table_name = p_table
            and column_name = p_column;
            return v_data_type;
        end;
        $$ language plpgsql;

        create or replace function sead_utility.is_numeric(text) returns boolean as $$
        begin
            perform $1::numeric;
            return true;
        exception when others then
            return false;
        end;
        $$ language plpgsql immutable;

        create or replace function sead_utility.is_integer(text) returns boolean as $$
        begin
            perform $1::integer;
            return true;
        exception when others then
            return false;
        end;
        $$ language plpgsql immutable;

    create or replace function sead_utility.get_json_field(json_data jsonb, field_name text)
        returns text as $udf$
        declare
            v_value text;
        begin
            if json_data is null then
                return null;
            end if;
            execute format('select $1->>%L', field_name)
                into v_value using json_data;
            return result;
        end;
        $udf$ language plpgsql;
        
    create or replace procedure sead_utility.drop_udf(schema_name text, func_name text) 
        language plpgsql as $udf$
        declare
            r record;
        begin
            for r in
                select n.nspname as schema_name, p.proname as function_name,
                    pg_catalog.pg_get_function_identity_arguments(p.oid) as arguments
                from pg_catalog.pg_proc p
                join pg_catalog.pg_namespace n on n.oid = p.pronamespace
                where p.proname = func_name
                and n.nspname = schema_name
            loop
                execute format('drop function if exists %I.%I(%s);', r.schema_name, r.function_name, r.arguments);
            end loop;
        end $udf$;

    create or replace procedure sead_utility.drop_view(p_schema_name text, p_view_name text, p_cascade bool=TRUE) 
        language plpgsql as $udf$
        begin
            if sead_utility.view_exists(p_schema_name, p_view_name) then
                execute format('drop view %I.%I %s;', p_schema_name, p_view_name, 
                    case when p_cascade then 'cascade' else '' end);
            end if;
        end $udf$;

    create or replace procedure sead_utility.drop_view(p_view_name text, p_cascade bool=TRUE) 
        language plpgsql as $udf$
        declare
            v_schema_name text;
        begin
            if position('.' in p_view_name) > 0 then
                v_schema_name = split_part(p_view_name, '.', 1);
                p_view_name = split_part(p_view_name, '.', 2);
            else
                v_schema_name = current_schema();
            end if;
            if sead_utility.view_exists(v_schema_name, p_view_name) then
                execute format('drop view %I.%I %s;', v_schema_name, p_view_name, 
                    case when p_cascade then 'cascade' else '' end);
            end if;
        end $udf$;

    create or replace procedure sead_utility.drop_table(p_schema_name text, p_table_name text, p_cascade bool=TRUE) 
        language plpgsql as $udf$
        begin
            if sead_utility.table_exists(p_schema_name, p_table_name) then
                execute format('drop table %I.%I %s;', p_schema_name, p_table_name, 
                    case when p_cascade then 'cascade' else '' end);
            end if;
        end $udf$;

    create or replace procedure sead_utility.drop_table(p_table_name text, p_cascade bool=TRUE) 
        language plpgsql as $udf$
        declare
            v_schema_name text;
        begin
            if position('.' in p_table_name) > 0 then
                v_schema_name = split_part(p_table_name, '.', 1);
                p_table_name = split_part(p_table_name, '.', 2);
            else
                v_schema_name = current_schema();
            end if;
            if sead_utility.table_exists(v_schema_name, p_table_name) then
                execute format('drop table %I.%I %s;', v_schema_name, p_table_name, 
                    case when p_cascade then 'cascade' else '' end);
            end if;
        end $udf$;

    create table if not exists sead_utility.system_id_allocations (
        uuid UUID not null default uuid_generate_v4() primary key,
        table_name text not null,
        column_name text not null,
        submission_identifier text not null,
        change_request_identifier text not null,
        external_system_id text null,
        external_data JSON null,
        alloc_system_id int not null
    );

    call sead_utility.drop_udf('sead_utility', 'get_next_system_id');
    -- select sead_utility.get_next_system_id('tbl_sites', 'site_id') 
    create or replace function sead_utility.get_next_system_id(p_table_name text, p_column_name text) 
    /*
    * Get the next SEAD system id for table "p_table_name" and column "p_column_name".
    * The system id is allocated from the sead_utility.system_id_allocations table.
    * If no system id has been allocated for the table and column, the function will return the maximum value of the column in the table.
    */
        returns integer as $udf$
        declare
            v_next_id integer;
            v_query text;
        begin
            v_query := format('select max(%s) from %s', quote_ident(p_column_name), quote_ident(p_table_name));
            -- raise notice '%', v_query;
            execute v_query into v_next_id;

            select max(system_id) into v_next_id
            from (
                select coalesce(max(alloc_system_id), 0) as system_id
                from sead_utility.system_id_allocations
                where table_name = p_table_name
                and column_name = p_column_name
                union all
                values (v_next_id)
            );
            return v_next_id + 1;
        end;
        $udf$ language plpgsql;

	call sead_utility.drop_udf('sead_utility', 'allocate_system_id');
	
    create or replace function sead_utility.allocate_system_id(
        p_submission_identifier text,
        p_change_request_identifier text,
        p_table_name text,
        p_column_name text,
        p_system_id text = NULL,
        p_data jsonb = NULL
    ) returns integer as $udf$
        declare 
            v_next_id int;
        begin

            v_next_id = sead_utility.get_next_system_id(p_table_name, p_column_name);
            insert into sead_utility.system_id_allocations (
                table_name,
                column_name,
                submission_identifier,
                change_request_identifier,
                external_system_id,
                external_data,
                alloc_system_id
            ) values (
                p_table_name,
                p_column_name,
                p_submission_identifier,
                p_change_request_identifier,
                p_system_id,
                p_data,
                v_next_id
            );
            return v_next_id;
        end;
        $udf$ language plpgsql;

    create or replace function sead_utility.release_allocated_ids(
        p_submission_identifier text,
        p_change_request_identifier text=null,
        p_table_name text=null,
        p_column_name text=null
    ) 
        returns void as $udf$
        begin
            delete from sead_utility.system_id_allocations
            where submission_identifier = p_submission_identifier   
            and (p_change_request_identifier is null or change_request_identifier = p_change_request_identifier)
            and (p_table_name is null or table_name = p_table_name)
            and (p_column_name is null or column_name = p_column_name)
            ;
        end;
        $udf$ language plpgsql;

    create or replace function sead_utility.get_allocated_id(
        p_submission_identifier text,
        p_change_request_identifier text,
        p_table_name text,
        p_column_name text,
        p_system_id text = NULL
    ) 
        returns integer as $udf$
        declare
            v_alloc_system_id integer;
        begin

            select max(alloc_system_id::int)
                into v_alloc_system_id
                    from sead_utility.system_id_allocations
                    where submission_identifier = p_submission_identifier
                    and change_request_identifier = p_change_request_identifier
                    and table_name = p_table_name
                    and column_name = p_column_name
                    and external_system_id = p_system_id
            ;
            return v_alloc_system_id;
        end;
        $udf$ language plpgsql;

    call sead_utility.set_schema_privilege('sead_utility', 'sead_master', 'admin', 'humlab_admin');
    call sead_utility.set_schema_privilege('sead_utility', 'sead_read', 'read', 'humlab_admin', 'sead_master');

    -- Call sead_utility.set_schema_privilege with empty variadic parameter to set privileges for current user

commit;
