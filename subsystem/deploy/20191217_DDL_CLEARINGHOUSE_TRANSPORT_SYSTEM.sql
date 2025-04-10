-- Deploy subsystem: 20191217_DDL_CLEARINGHOUSE_TRANSPORT_SYSTEM

-- NOTE! DO NOT CHANGE THIS FILE!

-- THIS FILE IS AUTOMATICALLY GENERATED BY SEAD CHANGE CONTROL SYSTEM

-- Use bin/deploy-clearinghouse-commit to generate this file.

/***************************************************************************
  Author         
  Date           2025-02-17
  Description    Deploy of Clearinghouse Transport System
  Issue          https://github.com/humlab-sead/sead_change_control/issues/215
  Prerequisites  
  Reviewer
  Approver
  Idempotent     YES
  Notes          Use --single-transaction on execute!
***************************************************************************/

set client_encoding = 'UTF8';
set standard_conforming_strings = on;
set client_min_messages to warning;

drop schema if exists clearing_house_commit cascade;

-- /home/roger/source/sead_change_control/../sead_clearinghouse/transport_system//01_setup_transport_schema.sql
/*********************************************************************************************************************************
**  Schema    clearing_house_commit
**  What      all stuff related to ch data commit
**********************************************************************************************************************************/

reset role;

set role humlab_admin;

drop schema if exists clearing_house_commit cascade;
create schema if not exists clearing_house_commit authorization clearinghouse_worker;

reset role;

set role clearinghouse_worker;

create or replace function clearing_house_commit.commit_submission(p_submission_id int)
	returns void
as $$
begin
	update clearing_house.tbl_clearinghouse_submissions
		set submission_state_id = 4
	where submission_id = p_submission_id;
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
		select distinct x.table_name, x.column_name, clearing_house.fn_sead_table_entity_name(x.table_name::text)
		from clearing_house.fn_dba_get_sead_public_db_schema() x
		where true
          and x.table_schema = 'public'
          and x.is_pk = 'YES';
        -- on conflict (table_name)
        -- do update set (pk_name, entity_name) = (excluded.pk_name, excluded.entity_name);

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



-- /home/roger/source/sead_change_control/../sead_clearinghouse/transport_system//02_resolve_primary_keys.sql
set session schema 'clearing_house_commit';

/*********************************************************************************************************************************
**  Function    clearing_house_commit.get_max_transported_id
**  Who         Roger Mähler
**  When
**  What        Gets the max transported/commited ID for a given table in the transport system
**  Used By     Transport system, during resolve and assignment of primary keys
**  Revisions
**********************************************************************************************************************************/

create or replace function clearing_house_commit.get_max_transported_id(p_table_name character varying) returns int as $$
declare
    v_id int = 0;
    v_sql text = '';
begin
    v_sql = format(
        'select coalesce(max(transport_id), 0) + 1 from clearing_house.%s',
        case when p_table_name not like '%.%' then p_table_name else split_part(p_table_name, '.', 2) end
    );
    execute v_sql into v_id;
    return coalesce(v_id, 0);
end $$ language plpgsql;

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
    v_id integer;
    v_sequence_name text;
    v_max_transport_id int = 0;
begin

    v_sequence_name  = pg_get_serial_sequence(format('%s', p_table_name), p_column_name);

    v_max_transport_id = clearing_house_commit.get_max_transported_id(p_table_name);

    if p_table_name not like format('%s.%%', p_schema_name) then
        p_table_name = format('%s.%s', p_schema_name, p_table_name);
    end if;

    v_sql = format('select max(%s) from %s', p_column_name, p_table_name);
    execute v_sql into v_id;

    v_id = greatest(coalesce(v_id, 1), 1, v_max_transport_id);

    perform setval(v_sequence_name, v_id);

    return v_id;
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
    v_next_id              int = 0;
    v_sequence_name        text;
    v_transport_id_sql     text = '';
    v_max_transport_id     int = 0;
    v_dynamic_sql          text = '';
begin

    v_max_transport_id = clearing_house_commit.get_max_transported_id(p_table_name);

    if p_table_name not like format('%s.%%', p_schema_name) then
        p_table_name = format('%s.%s', p_schema_name, p_table_name);
    end if;

    v_sequence_name = pg_get_serial_sequence(p_table_name, p_column_name);
    if v_sequence_name is not null then
        if p_reset_id is TRUE then
            perform clearing_house_commit.reset_serial_id(p_schema_name, p_table_name, p_column_name);
        end if;
        v_next_id = nextval(v_sequence_name);
    else
        v_dynamic_sql = format('select max(%s) + 1 from %s', p_column_name, p_table_name);
        execute v_dynamic_sql into v_next_id;
    end if;

    -- Find MAX assigned id from transport_system (pending insert)
    v_transport_id_sql = format(
        'select coalesce(max(transport_id), 0) + 1 from clearing_house.%s',
        case when p_table_name not like '%.%' then p_table_name else split_part(p_table_name, '.', 2) end
    );

    execute v_transport_id_sql into v_max_transport_id;

    v_next_id = greatest(v_next_id, v_max_transport_id);

    return v_next_id;

end $$ language plpgsql;


create or replace function clearing_house_commit.allocate_sequence_ids()
returns void as
$$
declare
  v_data record;
  v_sql text;
  v_max_transport_id int;
  v_max_pk_value int;
  v_sequence_name character varying;
begin

	for v_data in (

		with clearinghouse_pk_columns as (

			select table_name_underscored as tablename, st.column_name as columnname
			from clearing_house.tbl_clearinghouse_submission_xml_content_tables cxt
			join clearing_house.tbl_clearinghouse_submission_tables ct using (table_id)
			join clearing_house.fn_dba_get_sead_public_db_schema() st on st.table_name = ct.table_name_underscored
			where TRUE
			  and st.table_schema = 'public'
			  and 'YES' in (st.is_pk)
			group by table_name_underscored, column_name

		), sead_sequence_columns as (

			with sequences as (
				select oid, relname as sequencename
				from pg_class
				where relkind = 'S'
			)
				select sch.nspname as schemaname, tab.relname as tablename, col.attname as columnname, col.attnum as columnnumber, seqs.sequencename
				from pg_attribute col
				join pg_class tab on col.attrelid = tab.oid
				join pg_namespace sch on tab.relnamespace = sch.oid
				left join pg_attrdef def on tab.oid = def.adrelid and col.attnum = def.adnum
				left join pg_depend deps on def.oid = deps.objid and deps.deptype = 'n'
				left join sequences seqs on deps.refobjid = seqs.oid
				where sch.nspname = 'public'
				  and col.attnum > 0
				  and seqs.sequencename is not null
				order by sch.nspname, tab.relname, col.attnum

		) select *
		  from clearinghouse_pk_columns
		  join sead_sequence_columns using (tablename, columnname)

	) Loop

		v_sql := format('select max(transport_id) from clearing_house.%s', v_data.tablename);

		execute v_sql into v_max_transport_id;

		v_sql := format('select max(%s) from public.%s', v_data.columnname, v_data.tablename);

		execute v_sql into v_max_pk_value;

		if coalesce(v_max_transport_id, 0) > coalesce(v_max_pk_value,0) then

			v_sequence_name = pg_get_serial_sequence(format('%s', v_data.tablename), v_data.columnname);

			raise info 'Adjusting sequence % on %.% to % (was %)',
				v_sequence_name, v_data.tablename, v_data.columnname, v_max_transport_id, v_max_pk_value;

			perform setval(v_sequence_name, v_max_transport_id);

		end if;

	End Loop;

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
--select * from clearing_house_commit.resolve_primary_key(1, 'public', 'tbl_sites', 'site_id', 'source_name', 'cr_name')
--drop function clearing_house_commit.resolve_primary_key(int, text,text,text,text,text)
create or replace function clearing_house_commit.resolve_primary_key(
    p_submission_id int,
    p_schema_name text,
    p_table_name text,
    p_pk_name text,
    p_source_name text, -- name of submission's import file
    p_cr_name text -- name of CR that pre-allocated keys for this table
) returns text as $$
declare
    v_sql text;
    v_next_id integer;
begin
    begin

        -- FIXME update preallocated ids
        v_sql = format('
            update clearing_house.%1$I
            set transport_id = null, transport_date = null, transport_type = null
            where clearing_house.%1$I.submission_id = %2$s;
        ', p_table_name, p_submission_id);

        if coalesce(p_cr_name,'') != '' and coalesce(p_source_name,'') != '' then
            v_sql = v_sql || format('
            with allocated_identities as (
                select external_system_id::int as local_db_id, alloc_system_id::int as public_id
                from sead_utility.system_id_allocations
                where submission_identifier = ''%1$s''
                  and change_request_identifier = ''%2$s''
                  and table_name = ''%3$s''
                  and column_name = ''%4$s''
            ) update clearing_house.%3$I
                set transport_id =  a.public_id,
                    transport_date = now(),
                    transport_type = ''A''
                from allocated_identities a
                where clearing_house.%3$I.submission_id = %5$s
                  and -(clearing_house.%3$I.local_db_id::int) = a.local_db_id;
            ', p_source_name, p_cr_name, p_table_name, p_pk_name, p_submission_id);
        end if;
        
        v_next_id = clearing_house_commit.get_next_id(p_schema_name, p_table_name, p_pk_name, true);
        v_sql = v_sql || format('
            with new_keys as (
                select local_db_id, %1$s + row_number() over (order by local_db_id asc) as new_db_id
                from clearing_house.%2$I
                where submission_id = %3$s
                and public_db_id is null
                and transport_id is null
            ) update clearing_house.%2$I
                set transport_id = case when public_db_id is null then n.new_db_id else public_db_id end,
                    transport_date = now(),
                    transport_type = case when public_db_id is null then ''C'' else ''U'' end
                from new_keys n
                where clearing_house.%2$I.submission_id = %3$s
                and clearing_house.%2$I.local_db_id = n.local_db_id;
        ', v_next_id - 1, p_table_name, p_submission_id);

        --raise notice '%', v_sql;
        return v_sql;
    end;
end;$$ language plpgsql;

        
/*********************************************************************************************************************************
**  Function    clearing_house_commit.resolve_primary_keys
**  Who         Roger Mähler
**  When
**  What        Loops through all data tables in a SEAD submission and resolves the primary keys if table has data
**              and has a primary key.
**              The primary key is resolved by assigning a new public ID in field "transport_id".
**              
**              If `p_alloc_ids_cr_name` is set, the function will use the pre-allocated identity
**              for the given table and system id value if such an identity exists.
**              Otherwise, the function will use the next available identity based on primary keys
**              next incremental value (serial) and the maximum pre-allocated value for given table and column.
**              
**              The function returns a list of all affected primary keys with some statistical attributes.   
**  Used By     Transport system, during packaging of a new CH submission transfer
**  Returns     Statistics of affected records
**  Idempotant  YES
**  Revisions
**********************************************************************************************************************************/

-- FIXME: resolve_primary_keys allocates an existing public_id to a new record, which is not correct

create or replace procedure clearing_house_commit.resolve_primary_keys(
    p_submission_id int,
    p_schema_name text,
    p_cr_name text = null,  -- name of CR if keys are pre-allocated 
    p_dry_run boolean = false
) as $$
    declare v_schema_name character varying;
        v_table_name character varying;
        v_pk_name character varying;
        v_sql text = '';
        v_source_name text;
        v_count integer;
begin

    begin

        v_source_name := (select source_name from clearing_house.tbl_clearinghouse_submissions where submission_id = p_submission_id);

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
                continue;
            end if;


            v_sql = clearing_house_commit.resolve_primary_key(
                p_submission_id,
                p_schema_name,
                v_table_name,
                v_pk_name,
                v_source_name,
                p_cr_name
            );

            if (not p_dry_run) then
                 execute v_sql;
            end if;

        end loop;

    exception
        when sqlstate 'GUARD' then
            raise notice '%', 'GUARDED';
    end;
end;$$ language plpgsql;




-- /home/roger/source/sead_change_control/../sead_clearinghouse/transport_system//03_resolve_foreign_keys.sql
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
                        format(E'\t\t\tcase when e.transport_id <= 0 then null else e.transport_id end::%2$s as %1$I', column_name, data_type)
                    when is_fk = 'YES' then
                        format(E'\t\t\tcase when e.%1$I > 0 then e.%1$I else fk%2$s.transport_id end::%3$s as %1$s', column_name, ordinal_position, data_type)
                    when column_name = 'date_updated' then
                        format(E'\t\t\tcase when e.date_updated is null then now() else e.date_updated end::%2$s as %1$s', column_name, data_type)
                    when column_name like '%_uuid' then
                        format(E'\t\t\tcase when e.%1$s is null then uuid_generate_v4() else e.%1$s end::%2$s as %1$s', column_name, data_type)
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





-- /home/roger/source/sead_change_control/../sead_clearinghouse/transport_system//04_script_data_transport.sql
-- FIXME: #48 Improve resilience of the transport system (copy in/out) scripts
create or replace function clearing_house_commit.get_data_column_names(p_schema_name text, p_table_name text)
returns text as
$$
declare
    v_columns text;
begin
    select string_agg(column_name, ', ')
        into v_columns
        from (
            select column_name
            from information_schema.columns
            where table_schema = p_schema_name
              and table_name = p_table_name
              and is_generated = 'NEVER'
            order by ordinal_position
        ) as t;
    return v_columns;

end;
$$ language plpgsql;

create or replace function clearing_house_commit.generate_copy_out_script(
    p_submission_id int,
    p_entity text,
    p_table_name text,
    p_target_folder text) returns text as $$
declare v_sql text;
declare v_columns text;
begin

    v_columns = clearing_house_commit.get_data_column_names('public', p_table_name);

    -- program ''gzip > %s/submission_%s_%s.zip''
    v_sql = format('\copy (select %s from clearing_house_commit.resolve_%s(%s)) to program ''gzip -qa9 > %s/submission_%s_%s.gz'' with (format text, delimiter E''\t'', encoding ''utf-8'');
    ',
        v_columns, p_entity, p_submission_id, p_target_folder, p_submission_id, p_entity);

    return v_sql;

end $$ language plpgsql;

create or replace function clearing_house_commit.generate_copy_in_script(
    p_submission_id int,
    p_entity_name text,
    p_table_name text,
    p_pk_name text,
    p_target_folder text = '/tmp',
    p_delete_existing boolean = FALSE
) returns text as $$
declare v_sql text;
declare v_delete_sql text;
declare v_columns text;
begin

    v_columns = clearing_house_commit.get_data_column_names('public', p_table_name);

    -- from program ''gunzip < %s/submission_%s_%s.zip''
    v_sql = E'
/************************************************************************************************************************************
 ** #ENTITY#
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_#TABLE#;
create table clearing_house_commit.temp_#TABLE# as select #COLUMNS# from public.#TABLE# where FALSE;

\\copy clearing_house_commit.temp_#TABLE# from program ''zcat -qac #DIR#/submission_#ID#_#ENTITY#.gz'' with (FORMAT text, DELIMITER E''\t'', ENCODING ''utf-8'');
#DELETE-SQL#

insert into public.#TABLE# (#COLUMNS#)
    select #COLUMNS#
    from clearing_house_commit.temp_#TABLE# ;

\\o /dev/null
select clearing_house_commit.reset_serial_id(''public'', ''#TABLE#'', ''#PK#'');
\\o

drop table if exists clearing_house_commit.temp_#TABLE#;
';
-- \\echo Deployed #ENTITY#, rows inserted: :ROW_COUNT

    v_delete_sql = case when p_delete_existing then E'
delete from public.#TABLE#
    where #PK# in (select #PK# from clearing_house_commit.temp_#TABLE#);' else '' end;

    v_sql = replace(v_sql, '#COLUMNS#', v_columns);
    v_sql = replace(v_sql, '#DELETE-SQL#', v_delete_sql);
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
                v_sql = v_sql || E'\n' || clearing_house_commit.generate_copy_out_script(p_submission_id, v_entity_name, v_table_name, p_folder);
            else
                v_sql = v_sql || E'\n' || clearing_house_commit.generate_copy_in_script(p_submission_id, v_entity_name, v_table_name, v_pk_name, p_folder) || E'\n';
            end if;

        end loop;

    end;

    return v_sql;

end $xyz$ language plpgsql;

-- select clearing_house_commit.rollback_commit(1)

create or replace function clearing_house_commit.rollback_commit(p_submission_id int)
returns void as
$$
declare
  v_data record;
  v_sql text;
  v_sql_script text = '';
  v_sql_count_template text;
  v_sql_delete_template text;
  v_record_count int;
begin

	v_sql_count_template := '
		select count(*)
		from clearing_house.%s
		where submission_id = %s
		  and transport_id is not null;
	';

	v_sql_delete_template = '
		delete from public.%s
		where %s in (
			select transport_id
			from clearing_house.%s
			where submission_id = %s
			  and transport_id is not null
		);
	';

	for v_data in (

		select distinct t.table_name, t.pk_name, coalesce(x.sort_order, 999) as sort_key
		from clearing_house_commit.tbl_sead_tables t
		left join clearing_house_commit.sorted_table_names() x
		  on x.table_name = t.table_name
		order by 3 desc

	) Loop

		v_sql := format(v_sql_count_template, v_data.table_name, p_submission_id);

		execute v_sql into v_record_count;

		if v_record_count > 0 then

			v_sql = format(v_sql_delete_template, v_data.table_name, v_data.pk_name, v_data.table_name, p_submission_id);

			raise info 'Table %: %', v_data.table_name, v_record_count;

			v_sql_script = v_sql_script || v_sql;

		end if;

	End Loop;

	raise info '%', v_sql_script;

end $$ language plpgsql;


-- /home/roger/source/sead_change_control/../sead_clearinghouse/transport_system//05_install_transport_system.sql
create or replace procedure clearing_house_commit.create_or_update_clearinghouse_system(
    p_only_drop boolean = false,
    p_dry_run boolean = false,
    p_only_update boolean = true
) as $$
begin

    set role clearinghouse_worker;

    call clearing_house.create_public_model(p_only_drop, p_dry_run, p_only_update);

    perform clearing_house_commit.generate_sead_tables();
    perform clearing_house_commit.generate_resolve_functions('public', p_dry_run);

    reset role;
    
end $$ language plpgsql;

call clearing_house_commit.create_or_update_clearinghouse_system(false, false, false);

reset role;
