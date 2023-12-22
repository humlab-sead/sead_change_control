-- Deploy utility: 20190407_DDL_UTILITY_CREATE_UTILITY_SCHEMA
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

    create or replace function get_all_table_counts(p_schema_name text = 'public')
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

    create view sead_utility.view_fk_index_check2 as
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
    create view sead_utility.view_fk_index_check as
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


commit;
