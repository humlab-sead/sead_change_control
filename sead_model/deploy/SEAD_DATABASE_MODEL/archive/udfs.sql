drop function if exists "public"."create_sample_position_view"();

create or replace function "public"."create_sample_position_view"()
    returns "pg_catalog"."void"
    as $BODY$
declare
    methods record;
    pos_cols text;
    sub_select_clause text := '';
    select_clause text := '';
    point_clause varchar;
    normalized_method_name varchar := '';
    transform_string varchar;
begin
    for methods in (
        select
            *
        from
            tbl_methods m
        where
            m.method_group_id = 17)
        loop
            normalized_method_name := replace(methods.method_name, ' ', '_');
            normalized_method_name := replace(normalized_method_name, '.', '_');
            normalized_method_name := replace(normalized_method_name, '(', '_');
            normalized_method_name := replace(normalized_method_name, ')', '_');

            transform_string := get_transform_string(normalized_method_name);
            if transform_string = '-1' then
                continue;
            end if;

            if select_clause != '' then
                select_clause := select_clause || ',';
            end if;

            select_clause := select_clause || ' ' || transform_string || 'as "' || methods.method_name || '"';

            sub_select_clause := sub_select_clause || ' ' || 'left join (select x.measurement as x, y.measurement as y, sc.physical_sample_id as sample
		from
		tbl_sample_coordinates sc
		join tbl_coordinate_method_dimensions cmd
		on cmd.coordinate_method_dimension_id = sc.coordinate_method_dimension_id
		join
		(select
		sc.physical_sample_id as id,
		sc.measurement as measurement,
		cmd.method_id as method_id
		from tbl_sample_coordinates sc
		join tbl_coordinate_method_dimensions cmd
		on sc.coordinate_method_dimension_id = cmd.coordinate_method_dimension_id
		join tbl_dimensions d
		on d.dimension_id = cmd.dimension_id
		where d.dimension_name like ''Y%'') as y
		on y.id = sc.physical_sample_id
		and y.method_id = cmd.method_id

		join
		(select
		sc.physical_sample_id as id,
		sc.measurement as measurement,
		cmd.method_id as method_id
		from tbl_sample_coordinates sc
		join tbl_coordinate_method_dimensions cmd
		on sc.coordinate_method_dimension_id = cmd.coordinate_method_dimension_id
		join tbl_dimensions d
		on d.dimension_id = cmd.dimension_id
		where d.dimension_name like ''X%'') as x
		on x.id = sc.physical_sample_id
		and x.method_id = cmd.method_id

		where cmd.method_id = ' || methods.method_id || ') as ' || normalized_method_name || ' on ' || normalized_method_name || '.sample = sc.physical_sample_id';

        end loop;
    select_clause := 'select sc.physical_sample_id, ' || select_clause || ' from tbl_sample_coordinates sc ' || sub_select_clause;
    raise info '%', select_clause;
end;
$BODY$
language plpgsql
volatile
cost 100;

drop function if exists "public"."get_transform_string"("method_name" varchar, "target_srid" int4);

create or replace function "public"."get_transform_string"("method_name" varchar, "target_srid" int4 = 4326)
    returns "pg_catalog"."text"
    as $BODY$
declare
    srid integer := - 1;
    n_adj integer := 0;
    e_adj integer := 0;
    result_string text := '';
begin
    case when method_name = 'WGS84_UTM_zone_32' then
        srid := 32632;
    when method_name = 'EPSG:4326' then
        srid := 4326;
    when method_name = 'UTM_U32_euref89' then
        srid := 4647;
    when method_name = 'Swedish_RT90[2.5_gon_V]' then
        srid := 3021;
    when method_name = 'RT90_5_gon_V' then
        srid := 3020;
    when method_name = 'SWEREF_99_TM_(Swedish)' then
        srid := 3006;
    when method_name = 'Truncated_RT90_5_gon_V_(6M,_1M_adjustment)' then
        srid := 3020; n_adj := 6000000; e_adj := 1000000;
    when method_name = 'WGS84_UTM_zone_33N' then
        srid := 32633;
    else
        raise warning 'no matching coordinate method id found for method %', method_name; return '-1';
    end case;

    result_string := 'st_transform(st_setsrid(st_point(' || method_name || '.y + ' || n_adj || ',' || method_name || '.x + ' || e_adj || '), ' || srid || '), ' || target_srid || ')'; return result_string;
    end;
$BODY$
language plpgsql
volatile
cost 100;

drop function if exists "public"."requiredtablestructurechanges"();

create or replace function "public"."requiredtablestructurechanges"()
    returns "pg_catalog"."void"
    as $BODY$
begin
    alter table tbl_bugs_tsite
        alter column "Country" type character varying(255);
    perform
        BugsTransferLog('tbl_bugs_tsite', 'U', 'alter table, alter column "Country" type character varying(255)');
    perform
        NumericifyColumn(t_name := 'tbl_bugs_tspeciesassociations', col_name := 'CODE');
    perform
        NumericifyColumn(t_name := 'tbl_bugs_tspeciesassociations', col_name := 'AssociatedSpeciesCODE');
    perform
        NumericifyColumn(t_name := 'tbl_bugs_tecodefbugs', col_name := 'SortOrder', numeric_type := 'smallint');
    perform
        NumericifyColumn(t_name := 'tbl_bugs_tecobugs', col_name := 'CODE');
    perform
        NumericifyColumn(t_name := 'tbl_bugs_tecokoch', col_name := 'CODE');
    perform
        NumericifyColumn(t_name := 'tbl_bugs_tseasonactiveadult', col_name := 'CODE');
    perform
        NumericifyColumn(t_name := 'tbl_bugs_tperiods', col_name := 'Begin');
    perform
        NumericifyColumn(t_name := 'tbl_bugs_tperiods', col_name := 'End');
end;
$BODY$
language plpgsql
volatile
cost 100;

drop function if exists "public"."smallbiblioupdates"();

create or replace function "public"."smallbiblioupdates"()
    returns "pg_catalog"."void"
    as $BODY$
declare
    cnt_Lott2010 integer := - 1;
begin
    select
        count(*)
    from
        tbl_bugs_tbiblio
    where
        "REFERENCE" like 'Lott 2010%' into cnt_Lott2010;
    if cnt_Lott2010 = 1 then
        -- small fix to handle the current state of
        -- bugs, this should be ineffective after
        -- fixes in original data.
        update
            tbl_bugs_tbiblio
        set
            "REFERENCE" = 'Lott 2010'
        where
            "REFERENCE" = 'Lott 2010a';
    end if;
end;
$BODY$
language plpgsql
volatile
cost 100;

drop function if exists "public"."syncsequences"();

create or replace function "public"."syncsequences"()
    returns "pg_catalog"."void"
    as $BODY$
declare
    sql record;
begin
    for sql in
    select
        'SELECT SETVAL(' || quote_literal(quote_ident(PGT.schemaname) || '.' || quote_ident(S.relname)) || ', MAX(' || quote_ident(C.attname) || ') ) FROM ' || quote_ident(PGT.schemaname) || '.' || quote_ident(T.relname) || ';' as fix_query
    from
        pg_class as S,
        pg_depend as D,
        pg_class as T,
        pg_attribute as C,
        pg_tables as PGT
    where
        S.relkind = 'S'
        and S.oid = D.objid
        and D.refobjid = T.oid
        and D.refobjid = C.attrelid
        and D.refobjsubid = C.attnum
        and T.relname = PGT.tablename
    order by
        S.relname loop
            execute sql.fix_query;
        end loop;
end;
$BODY$
language plpgsql
volatile
cost 100;

