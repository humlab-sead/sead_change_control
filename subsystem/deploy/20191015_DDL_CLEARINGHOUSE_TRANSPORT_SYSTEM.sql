/***************************************************************************
Author         roger
Date           
Description    
Prerequisites  
Reviewer
Approver
Idempotent     YES
Notes          Use --single-transactin on execute!
***************************************************************************/
--set constraints all deferred;
set client_min_messages to warning;
-- set autocommit off;
-- begin;
/*********************************************************************************************************************************
**  Schema    clearing_house_commit
**  What      all stuff related to ch data commit
**********************************************************************************************************************************/

do $$
begin

    drop schema if exists clearing_house_commit cascade;

    create schema if not exists clearing_house_commit;

    create type clearing_house_commit.resolve_primary_keys_result as (
        submission_id int,
        table_name text,
        column_name text,
        update_sql text,
        action text,
        row_count int,
        start_id int,
        status_id int,
        execute_date timestamp
    );

end $$ language plpgsql;

/*********************************************************************************************************************************
**  Function    clearing_house_commit.generate_sead_tables
**  Who         Roger Mähler
**  When
**  What        Fetches relevant schema information from the public SEAD database
**  Used By     Transport system install script
**  Revisions
**********************************************************************************************************************************/

create or replace function clearing_house_commit.generate_sead_tables()
returns void language 'plpgsql' as $body$
begin

    drop table if exists clearing_house_commit.tbl_sead_tables;
    drop table if exists clearing_house_commit.tbl_sead_table_keys;
    -- drop index if exists clearing_house_commit.idx_tbl_sead_tables_entity_name;

    create table if not exists clearing_house_commit.tbl_sead_tables (
        table_name information_schema.sql_identifier primary key,
        pk_name information_schema.sql_identifier not null,
        entity_name information_schema.sql_identifier not null,
        is_global_lookup information_schema.yes_or_no not null default('NO'),
        is_local_lookup information_schema.yes_or_no not null default('NO'),
		is_aggregate_root information_schema.yes_or_no not null default('NO'),
        has_foreign_key information_schema.yes_or_no not null default('NO'),
		parent_aggregate information_schema.sql_identifier null
    );

    create unique index if not exists idx_clearinghouse_entity_tables_entity_name
        on clearing_house_commit.tbl_sead_tables (entity_name);

	--, is_lookup, is_aggregate_root, aggregate_root
	insert into clearing_house_commit.tbl_sead_tables (table_name, pk_name, entity_name)
		select x.table_name, x.column_name, clearing_house.fn_sead_table_entity_name(x.table_name::text)
		from clearing_house.fn_dba_get_sead_public_db_schema() x
		where true
          and x.table_schema = 'public'
          and x.is_pk = 'YES'
        on conflict (table_name)
        do update set (pk_name, entity_name) = (excluded.pk_name, excluded.entity_name);

    update clearing_house_commit.tbl_sead_tables
        set is_global_lookup = 'YES'
    where table_name like '%_types';

    create table if not exists clearing_house_commit.tbl_sead_table_keys (
        table_name information_schema.sql_identifier not null,
        column_name information_schema.sql_identifier not null,
        is_pk information_schema.yes_or_no not null default('NO'),
        is_fk information_schema.yes_or_no not null default('NO'),
        fk_table_name information_schema.sql_identifier null,
        fk_column_name information_schema.sql_identifier null,
        constraint pk_tbl_sead_table_keys primary key (table_name, column_name)
    );

	insert into clearing_house_commit.tbl_sead_table_keys (table_name, column_name, is_pk, is_fk, fk_table_name, fk_column_name)
		select table_name, column_name, is_pk, is_fk, fk_table_name, fk_column_name
		from clearing_house.fn_dba_get_sead_public_db_schema() x
		where TRUE
          and x.table_schema = 'public'
          and 'YES' in (x.is_pk, x.is_fk)
        on conflict (table_name, column_name)
        do update set (is_pk, is_fk, fk_table_name, fk_column_name) = (excluded.is_pk, excluded.is_fk, excluded.fk_table_name, excluded.fk_column_name);

    with tables_with_foreign_keys as (
        select distinct table_name
        from clearing_house_commit.tbl_sead_table_keys
        where is_fk = 'YES'
    )
        update clearing_house_commit.tbl_sead_tables t set has_foreign_key = 'YES'
        from tables_with_foreign_keys k
        where k.table_name = t.table_name;

end
$body$;

/*********************************************************************************************************************************
**  Function    clearing_house_commit.sorted_table_names
**  Who         Roger Mähler
**  When
**  What        Returns table name sorted in a way that dependent tables are returned after referred tables
**              This function defines the order in shich table data are inserted into the public database.
**  Used By     Transport system install script
**  Note
**  Revisions
**********************************************************************************************************************************/

create or replace function clearing_house_commit.sorted_table_names()
returns table (table_name text, sort_order int) as $$
  declare v_processed_tables text[] := '{}';
  declare v_table_count int;
  declare v_count int;
  declare v_table_name text = '';
begin
    v_count = 0;
    v_table_count = (select count(*) from clearing_house_commit.tbl_sead_tables);
    v_processed_tables = (
        select array_agg(t.table_name)
        from clearing_house_commit.tbl_sead_tables t
        where t.table_name not in (
            select fk.table_name
            from clearing_house_commit.tbl_sead_table_keys fk
            where fk.is_fk = 'YES'
        )
    );
    while cardinality(v_processed_tables) <= v_table_count loop
        v_count = v_count + 1;
        v_table_name = (
            select min(t.table_name)
            from clearing_house_commit.tbl_sead_tables t
            where not t.table_name = ANY (v_processed_tables)
              and not t.table_name in (
                  select fk.table_name
                  from clearing_house_commit.tbl_sead_table_keys fk
                  where TRUE
                    and fk.table_name <> fk.fk_table_name
                    and fk.is_fk = 'YES'
                    and not fk.fk_table_name = ANY (v_processed_tables)
             )
        );
        if v_table_name is null then
            exit;
        end if;
        v_processed_tables = array_append(v_processed_tables, v_table_name);
    end loop;

    return query
        select unnest(v_processed_tables), generate_subscripts(v_processed_tables, 1);

end $$ language plpgsql;

set session schema 'clearing_house_commit';

/*********************************************************************************************************************************
**  Function    clearing_house_commit.reset_serial_id
**  Who         Roger Mähler
**  When
**  What        Resets a database sequence given name of schema, table and column
**  Used By     Transport system, during resolve and assignment of primary keys
**  Returns     Next serial ID in sequence
**  Revisions
**********************************************************************************************************************************/

create or replace function clearing_house_commit.reset_serial_id(
    p_schema_name character varying,
    p_table_name character varying,
    p_column_name character varying
) returns int as $$
declare
    v_sql text = '';
    v_next_id integer;
    v_seq_id character varying;
begin

    if p_table_name not like format('%s.%%', p_schema_name) then
        p_table_name = format('%s.%s', p_schema_name, p_table_name);
    end if;

    v_sql = format('select max(%s) from %s', p_column_name, p_table_name);

    execute v_sql into v_next_id;

    v_next_id = coalesce(v_next_id, 1);
    v_seq_id  = pg_get_serial_sequence(format('%s', p_table_name), p_column_name);

    perform setval(v_seq_id, v_next_id);

    return v_next_id;

end $$ language plpgsql;

/*********************************************************************************************************************************
**  Function    clearing_house_commit.get_next_id
**  Who         Roger Mähler
**  When
**  What        Returns (and optionally resets) next ID in given sequence
**  Used By     Transport system, during resolve and assignment of primary keys
**  Returns     Next serial ID in sequence
**  Revisions
**********************************************************************************************************************************/

create or replace function clearing_house_commit.get_next_id(
    p_schema_name character varying,
    p_table_name character varying,
    p_column_name character varying,
    p_reset_id boolean = FALSE
) returns int as $$
declare
    v_next_id       int = 0;
    v_sequence_name character varying;
begin

    if p_reset_id is TRUE then
        perform clearing_house_commit.reset_serial_id(p_schema_name, p_table_name, p_column_name);
    end if;

    if p_table_name not like format('%s.%%', p_schema_name) then
        p_table_name = format('%s.%s', p_schema_name, p_table_name);
    end if;

    v_sequence_name = pg_get_serial_sequence(p_table_name, p_column_name);
    v_next_id = nextval(v_sequence_name);

    return v_next_id;

end $$ language plpgsql;

/*********************************************************************************************************************************
**  Function    clearing_house_commit.resolve_primary_key
**  Who         Roger Mähler
**  When
**  What        Assigns a public ID in field "transport_id" to all records in given table. Type of CRUD op. (C or U)
**              are stored in field "transport_type".
**              Existing records are assign "public_db_id", and new records are assigned next ID in sequence.
**              Note that the serial in the public DB is left untouched (apart from a reset) by this function.
**  Used By     Transport system, during packaging of a new CH submission transfer
**  Returns     Next serial ID in sequence
**  Idempotant  YES
**  Revisions
**********************************************************************************************************************************/

create or replace function clearing_house_commit.resolve_primary_key(
    p_submission_id int,
    p_table_name character varying,
    p_next_id integer
) returns text as $$
declare v_sql text;
begin
    begin

        v_sql = format('
with new_keys as (
    select local_db_id, %s + row_number() over (order by local_db_id asc) as new_db_id
    from clearing_house.%s
    where submission_id = %s
        and public_db_id is null
) update clearing_house.%s
    set transport_id = case when public_db_id is null then n.new_db_id else public_db_id end,
        transport_date = now(),
        transport_type = case when public_db_id is null then ''C'' else ''U'' end
    from new_keys n
    where clearing_house.%s.submission_id = %s
        and clearing_house.%s.local_db_id = n.local_db_id;
        ', p_next_id - 1, p_table_name, p_submission_id, p_table_name, p_table_name, p_submission_id, p_table_name);

        --raise notice '%', v_sql;
        return v_sql;
    exception
        when sqlstate 'GUARD' then
            raise notice '%', 'GUARDED';
    end;
end;$$ language plpgsql;

/*********************************************************************************************************************************
**  Function    clearing_house_commit.resolve_primary_keys
**  Who         Roger Mähler
**  When
**  What        Loops through all data tables in a SEAD submission and resolves the primary keys if table has data
**  Used By     Transport system, during packaging of a new CH submission transfer
**  Returns     Statistics of affected records
**  Idempotant  YES
**  Revisions
**********************************************************************************************************************************/

create or replace function clearing_house_commit.resolve_primary_keys(
    p_submission_id int,
    p_schema_name character varying,
    p_dry_run boolean
) returns setof clearing_house_commit.resolve_primary_keys_result as $$
declare v_schema_name character varying;
    v_table_name character varying;
    v_pk_name character varying;
    v_sql text = '';
    v_next_id integer;
    v_count integer;
    v_row clearing_house_commit.resolve_primary_keys_result%rowtype;
begin
    begin

        perform clearing_house_commit.generate_sead_tables();

        for v_table_name, v_pk_name in (
            select table_name, pk_name
            from clearing_house_commit.tbl_sead_tables
            order by 1, 2
        )
        loop

            execute format('select count(*) from clearing_house.%s where submission_id = $1', v_table_name)
                into v_count
                    using p_submission_id;

            if v_count = 0 then
                --raise notice 'SKIPPED: % no data', v_table_name;
                continue;
            end if;

            v_next_id = clearing_house_commit.get_next_id(p_schema_name, v_table_name, v_pk_name, TRUE);

            raise notice 'UPDATING: % (% rows, using % as first id )', v_table_name, v_count, v_next_id;

            v_sql = clearing_house_commit.resolve_primary_key(p_submission_id, v_table_name, v_next_id);

            if (not p_dry_run) then
                 execute v_sql;
            end if;

            v_row.submission_id = p_submission_id;
            v_row.table_name = v_table_name;
            v_row.column_name = v_pk_name;
            v_row.action = 'ASSIGN_PK';
            v_row.update_sql = v_sql;
            v_row.row_count = v_count;
            v_row.start_id = v_next_id;
            v_row.status_id = 1;
            v_row.execute_date = now();

            return next v_row;

        end loop;

    exception
        when sqlstate 'GUARD' then
            raise notice '%', 'GUARDED';
    end;
end;$$ language plpgsql;


set session schema 'clearing_house_commit';

/*********************************************************************************************************************************
**  Function    clearing_house_commit.generate_resolve_function
**  Who         Roger Mähler
**  When
**  What        Generates a function that returns all records with primary and foreign keys resolved
**              Each function result has the same return type as corresponding SEAD table
**  Used By     Transport system install: generate_resolve_functions
**              Resulting functions are used during packaging of a CH transfer
**  Returns     Function DDL script
**  Idempotant  YES
**  Revisions
**********************************************************************************************************************************/

create or replace function clearing_house_commit.generate_resolve_function(p_schema_name character varying, p_table_name character varying) returns text as $$
declare
    v_entity_name character varying;
    v_field_clause text;
    v_join_clause text;
    v_sql text = '';
begin

    v_entity_name = clearing_house.fn_sead_table_entity_name(p_table_name::name)::character varying;

    select array_to_string(array_agg(
                case
                    when is_pk = 'YES'  then
                        format(E'\t\t\tcase when e.transport_id <= 0 then null else e.transport_id end as %I', column_name)
                    when is_fk = 'YES' then
                        format(E'\t\t\tcase when e.%I > 0 then e.%I else fk%s.transport_id end as %s', column_name, column_name, ordinal_position, column_name)
                    when column_name = 'date_updated' then
                        format(E'\t\t\tcase when e.date_updated is null then now() else e.date_updated end as %s', column_name)
                    else
                        E'\t\t\te.' || column_name
                end order by ordinal_position), E',\n') as field_clauses,

            array_to_string(array_agg(
                case when is_fk = 'YES' then
                    format(E'\tleft join clearing_house.%I fk%s on e.submission_id = fk%s.submission_id and e.%I = fk%s.local_db_id',
                           fk_table_name, ordinal_position, ordinal_position, column_name, ordinal_position)
                else
                    null
                end order by ordinal_position), E'\n') as join_clauses

        into v_field_clause, v_join_clause
        from clearing_house.fn_dba_get_sead_public_db_schema(p_schema_name) x
        where table_name = p_table_name;

        v_sql = format('
create or replace function clearing_house_commit.resolve_%s(p_submission_id int) returns setof public.%s as $xyz$
begin
    return query
        select
        %s
        from clearing_house.%I e
        %s
        where e.submission_id = p_submission_id;
end $xyz$ language plpgsql;', v_entity_name, p_table_name, v_field_clause, p_table_name, v_join_clause);

        -- raise notice '%', v_sql;
        return v_sql;

end $$ language plpgsql;

/*********************************************************************************************************************************
**  Function    clearing_house_commit.generate_resolve_functions
**  Who         Roger Mähler
**  When
**  What        Generates a functions that for each SEAD table returns data with resolved PK/FK
**  Used By     Function is called during install of transport system.
**              The function should be called whenever public DB schema has changes
**              Resulting functions are used during packaging of a CH transfer
**  Returns     None
**  Idempotant  YES
**  Revisions
**********************************************************************************************************************************/

create or replace function clearing_house_commit.generate_resolve_functions(p_schema_name character varying, p_dry_run boolean)
    returns void /* setof text */ as $$
declare
    v_table_name character varying;
    v_sql text = '';
begin
    begin
        for v_table_name in (select distinct table_name from clearing_house_commit.tbl_sead_tables)
        loop
            v_sql = clearing_house_commit.generate_resolve_function(p_schema_name, v_table_name);
            if (not p_dry_run) then
                 execute v_sql;
            end if;
            -- return next v_sql;
        end loop;
    end;
end;$$ language plpgsql;




create or replace function clearing_house_commit.generate_copy_out_script(p_submission_id int, p_entity text, p_target_folder text) returns text as $$
declare v_sql text;
begin

    -- program ''gzip > %s/submission_%s_%s.zip''
    v_sql = format('\copy (select * from clearing_house_commit.resolve_%s(%s)) to program ''gzip -qa9 > %s/submission_%s_%s.gz'' with (format text, delimiter E''\t'', encoding ''utf-8'');
    ',
        p_entity, p_submission_id, p_target_folder, p_submission_id, p_entity);

    return v_sql;

end $$ language plpgsql;


create or replace function clearing_house_commit.generate_copy_in_script(
    p_submission_id int,
    p_entity_name text,
    p_table_name text,
    p_pk_name text,
    p_target_folder text = '/tmp'
) returns text as $$
declare v_sql text;
begin

    -- from program ''gunzip < %s/submission_%s_%s.zip''
    v_sql = E'
/************************************************************************************************************************************
 ** #ENTITY#
 ************************************************************************************************************************************/

do \$\$ begin
    raise notice ''Deploying %...'', ''#ENTITY#'';
    drop table if exists clearing_house_commit.temp_#TABLE#;
    create table clearing_house_commit.temp_#TABLE# as select * from public.#TABLE# where FALSE;
end \$\$ language plpgsql;

\\copy clearing_house_commit.temp_#TABLE# from program ''zcat -qac #DIR#/submission_#ID#_#ENTITY#.gz'' with (FORMAT text, DELIMITER E''\t'', ENCODING ''utf-8'');

do \$\$ begin

    delete from public.#TABLE#
        where #PK# in (select #PK# from clearing_house_commit.temp_#TABLE#);

    insert into public.#TABLE#
        select *
        from clearing_house_commit.temp_#TABLE#
        /* on conflict (v_pk_name) update set list-of-all-fields */;

    perform clearing_house_commit.reset_serial_id(''public'', ''#TABLE#'', ''#PK#'');

    drop table if exists clearing_house_commit.temp_#TABLE#;

end \$\$ language plpgsql;
';

    v_sql = replace(v_sql, '#TABLE#', p_table_name);
    v_sql = replace(v_sql, '#ID#', p_submission_id::text);
    v_sql = replace(v_sql, '#ENTITY#', p_entity_name);
    v_sql = replace(v_sql, '#PK#', p_pk_name);
    v_sql = replace(v_sql, '#DIR#', p_target_folder);
    return v_sql;

end $$ language plpgsql;

create or replace function clearing_house_commit.generate_resolved_submission_copy_script(
    p_submission_id int,
    p_folder character varying,
    p_is_out boolean
) returns text as $xyz$
declare
    v_sql character varying;
    v_table_name character varying;
    v_entity_name character varying;
    v_count integer;
    v_pk_name character varying;
    v_sort_order integer;
begin
    begin

        -- perform clearing_house_commit.generate_resolve_functions('public', FALSE);
        -- perform clearing_house_commit.resolve_primary_keys(p_submission_id, 'public', FALSE);


        v_sql := '';

        for v_table_name, v_pk_name, v_entity_name, v_sort_order in (
            select distinct t.table_name, t.pk_name, t.entity_name, coalesce(x.sort_order, 999)
            from clearing_house_commit.tbl_sead_tables t
            left join clearing_house_commit.sorted_table_names() x
              on x.table_name = t.table_name
            order by 4 asc
        )
        loop

            execute format('select count(*) from clearing_house.%s where submission_id = $1', v_table_name)
                into v_count
                    using p_submission_id;

            if v_count = 0 then
                -- raise notice 'SKIPPED: % no data', v_table_name;
                continue;
            end if;

            if p_is_out then
                v_sql = v_sql || E'\n' || clearing_house_commit.generate_copy_out_script(p_submission_id, v_entity_name, p_folder);
            else
                v_sql = v_sql || E'\n' || clearing_house_commit.generate_copy_in_script(p_submission_id, v_entity_name, v_table_name, v_pk_name, p_folder) || E'\n';
            end if;

        end loop;

    end;

    return v_sql;

end $xyz$ language plpgsql;



select clearing_house_commit.generate_sead_tables();
select clearing_house_commit.generate_resolve_functions('public', false);

-- commit;
