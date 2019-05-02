--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.21
-- Dumped by pg_dump version 9.6.11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: breakpoint; Type: TYPE; Schema: public; Owner: sead_master
--

CREATE TYPE public.breakpoint AS (
	func oid,
	linenumber integer,
	targetname text
);


ALTER TYPE public.breakpoint OWNER TO sead_master;

--
-- Name: dblink_pkey_results; Type: TYPE; Schema: public; Owner: sead_master
--

CREATE TYPE public.dblink_pkey_results AS (
	"position" integer,
	colname text
);


ALTER TYPE public.dblink_pkey_results OWNER TO sead_master;

--
-- Name: frame; Type: TYPE; Schema: public; Owner: sead_master
--

CREATE TYPE public.frame AS (
	level integer,
	targetname text,
	func oid,
	linenumber integer,
	args text
);


ALTER TYPE public.frame OWNER TO sead_master;

--
-- Name: proxyinfo; Type: TYPE; Schema: public; Owner: sead_master
--

CREATE TYPE public.proxyinfo AS (
	serverversionstr text,
	serverversionnum integer,
	proxyapiver integer,
	serverprocessid integer
);


ALTER TYPE public.proxyinfo OWNER TO sead_master;

--
-- Name: targetinfo; Type: TYPE; Schema: public; Owner: sead_master
--

CREATE TYPE public.targetinfo AS (
	target oid,
	schema oid,
	nargs integer,
	argtypes oidvector,
	targetname name,
	argmodes character(1)[],
	argnames text[],
	targetlang oid,
	fqname text,
	returnsset boolean,
	returntype oid
);


ALTER TYPE public.targetinfo OWNER TO sead_master;

--
-- Name: tbiblio; Type: TYPE; Schema: public; Owner: sead_master
--

CREATE TYPE public.tbiblio AS (
	reference character varying(60),
	author character varying(255),
	title text,
	notes text
);


ALTER TYPE public.tbiblio OWNER TO sead_master;

--
-- Name: tcountsheet; Type: TYPE; Schema: public; Owner: sead_master
--

CREATE TYPE public.tcountsheet AS (
	countsheetcode character varying(10),
	countsheetname character varying(100),
	sitecode character varying(10),
	sheetcontext character varying(25),
	sheettype character varying(25)
);


ALTER TYPE public.tcountsheet OWNER TO sead_master;

--
-- Name: tfossil; Type: TYPE; Schema: public; Owner: sead_master
--

CREATE TYPE public.tfossil AS (
	fossilbugscode character varying(10),
	code numeric(18,10),
	samplecode character varying(10),
	abundance integer
);


ALTER TYPE public.tfossil OWNER TO sead_master;

--
-- Name: tsample; Type: TYPE; Schema: public; Owner: sead_master
--

CREATE TYPE public.tsample AS (
	samplecode character varying(10),
	sitecode character varying(10),
	x character varying(50),
	y character varying(50),
	zordepthtop numeric(18,10),
	zordepthbot numeric(18,10),
	refnrcontext character varying(50),
	countsheetcode character varying(10)
);


ALTER TYPE public.tsample OWNER TO sead_master;

--
-- Name: var; Type: TYPE; Schema: public; Owner: sead_master
--

CREATE TYPE public.var AS (
	name text,
	varclass character(1),
	linenumber integer,
	isunique boolean,
	isconst boolean,
	isnotnull boolean,
	dtype oid,
	value text
);


ALTER TYPE public.var OWNER TO sead_master;

--
-- Name: create_sample_position_view(); Type: FUNCTION; Schema: public; Owner: sead_master
--

CREATE FUNCTION public.create_sample_position_view() RETURNS void
    LANGUAGE plpgsql
    AS $$
declare
	methods record;
	pos_cols text;
	sub_select_clause text := '';
	select_clause text := '';
	point_clause varchar;
	normalized_method_name varchar := '';
	transform_string varchar;
begin

	for methods in (select *
			from tbl_methods m
			where m.method_group_id = 17) loop

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
	
	select_clause := select_clause || ' '
		|| transform_string
		|| 'as "' || methods.method_name || '"';
	
	sub_select_clause := sub_select_clause || ' ' ||
	  'left join (select x.measurement as x, y.measurement as y, sc.physical_sample_id as sample
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

		where cmd.method_id = ' || methods.method_id || 
		') as ' || normalized_method_name ||
		' on ' || normalized_method_name || '.sample = sc.physical_sample_id';
		
	end loop;
	select_clause :=
		'select sc.physical_sample_id, '
		||select_clause || ' from tbl_sample_coordinates sc '
		|| sub_select_clause;
	raise info '%', select_clause;
end;
$$;


ALTER FUNCTION public.create_sample_position_view() OWNER TO sead_master;

--
-- Name: fn_copy_schema_tables(text, text); Type: FUNCTION; Schema: public; Owner: clearinghouse_worker
--

CREATE FUNCTION public.fn_copy_schema_tables(source_schema text, target_schema text) RETURNS void
    LANGUAGE plpgsql
    AS $$
 DECLARE
  v_table_name text;
  v_object_name text;
  v_default text;
  v_column text;
  v_sql text;
BEGIN
	v_sql = 'CREATE SCHEMA IF NOT EXISTS ' || target_schema; -- || ' AUTHORIZATION ' || schema_owner;
	-- EXECUTE v_sql;
	RAISE NOTICE '%', v_sql;
 
	FOR v_object_name IN
		SELECT sequence_name::text
		FROM information_schema.SEQUENCES
		WHERE sequence_schema = source_schema
	LOOP
		v_sql = 'CREATE SEQUENCE ' || target_schema || '.' || v_object_name;
		-- EXECUTE v_sql;
		RAISE NOTICE '%', v_sql;
	END LOOP;
 
	FOR v_table_name IN
		SELECT TABLE_NAME::text
		FROM information_schema.TABLES
		WHERE table_schema = source_schema
	LOOP

		v_sql = 'CREATE TABLE ' || target_schema || '.' || v_table_name || ' (LIKE ' || source_schema || '.' || v_table_name || ' INCLUDING CONSTRAINTS INCLUDING INDEXES INCLUDING DEFAULTS)';
		-- EXECUTE v_sql;
		RAISE NOTICE '%', v_sql;
 
		FOR v_column, v_default IN
			SELECT column_name::text, REPLACE(column_default::text, source_schema, target_schema)
			FROM information_schema.COLUMNS
			WHERE TRUE
			  AND table_schema = target_schema
			  AND TABLE_NAME = v_table_name
			  AND column_default LIKE 'nextval(%' || source_schema || '%::regclass)'
		LOOP
			v_sql = 'ALTER TABLE ' || target_schema || '.' || v_table_name || ' ALTER COLUMN ' || v_column || ' SET DEFAULT ' || v_default;
			-- EXECUTE v_sql;
			RAISE NOTICE '%', v_sql;
		END LOOP;
	END LOOP;
 
END;
 
$$;


ALTER FUNCTION public.fn_copy_schema_tables(source_schema text, target_schema text) OWNER TO clearinghouse_worker;

--
-- Name: fn_copy_schema_tables(text, text, boolean); Type: FUNCTION; Schema: public; Owner: clearinghouse_worker
--

CREATE FUNCTION public.fn_copy_schema_tables(source_schema text, target_schema text, p_dry_run boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
 DECLARE
  v_table_name text;
  v_column_name text;
  v_sequence_name text;
  v_sql text;
BEGIN
	v_sql = 'CREATE SCHEMA IF NOT EXISTS ' || target_schema; -- || ' AUTHORIZATION ' || schema_owner;
    IF p_dry_run THEN
    	RAISE NOTICE '%', v_sql;
    ELSE
	    EXECUTE v_sql;
    END IF;

	FOR v_table_name IN
		SELECT TABLE_NAME::text
		FROM information_schema.TABLES
		WHERE table_schema = source_schema
	LOOP

		v_sql = 'CREATE TABLE ' || target_schema || '.' || v_table_name || ' (LIKE ' || source_schema || '.' || v_table_name || ' INCLUDING CONSTRAINTS INCLUDING INDEXES INCLUDING DEFAULTS)';
		
		IF p_dry_run THEN
			RAISE NOTICE '%', v_sql;
		ELSE
			EXECUTE v_sql;
		END IF;

	END LOOP;

	FOR v_table_name, v_column_name, v_sequence_name IN
		SELECT table_name, column_name, sequence_name
		FROM (
			SELECT table_name, column_name, replace(pg_get_serial_sequence(table_name, column_name), 'public.', 'staging.') As sequence_name
			FROM clearing_house.fn_dba_get_sead_public_db_schema('public')
		) s
		WHERE NOT s.sequence_name IS NULL
	LOOP
		v_sql = '
			CREATE SEQUENCE ' || target_schema || '.' || v_sequence_name || ';
			ALTER TABLE ' || target_schema || '.' || v_table_name || ' ALTER COLUMN ' || v_column_name || ' SET DEFAULT nextval(''' || v_sequence_name || ''');
		';
			
		IF p_dry_run THEN
			RAISE NOTICE '%', v_sql;
		ELSE
			EXECUTE v_sql;
		END IF;
	END LOOP;
	
END;

$$;


ALTER FUNCTION public.fn_copy_schema_tables(source_schema text, target_schema text, p_dry_run boolean) OWNER TO clearinghouse_worker;

--
-- Name: fn_copy_schema_tables(text, text, text, boolean); Type: FUNCTION; Schema: public; Owner: clearinghouse_worker
--

CREATE FUNCTION public.fn_copy_schema_tables(p_source_schema text, p_target_schema text, p_table_name text DEFAULT NULL::text, p_dry_run boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
 DECLARE
  v_table_name text;
  v_column_name text;
  v_sequence_name text;
  v_sql text;
  x RECORD;
BEGIN
	v_sql = format(E'\nCREATE SCHEMA IF NOT EXISTS %I;\n', p_target_schema);
	FOR v_table_name IN
		SELECT table_name::text
		FROM information_schema.tables
		WHERE table_catalog = current_database()
		  AND table_type = 'BASE TABLE'
		  AND table_schema = p_source_schema
		  AND coalesce(p_table_name, table_name) = table_name
	LOOP
		v_sql = v_sql || format(E'\nDROP TABLE IF EXISTS %I.%I;', p_target_schema, v_table_name);
		v_sql = v_sql || format(E'\nCREATE TABLE %I.%I (LIKE %I.%I INCLUDING CONSTRAINTS INCLUDING INDEXES INCLUDING DEFAULTS);', p_target_schema, v_table_name, p_source_schema, v_table_name);
		FOR v_column_name, v_sequence_name IN
			WITH columns AS (
				SELECT column_name, replace(pg_get_serial_sequence(v_table_name, column_name), p_source_schema || '.', '') As sequence_name
				FROM information_schema.columns
				WHERE table_catalog = current_database()
				  AND NOT column_default IS NULL
				  AND table_schema = p_source_schema
				  AND table_name = v_table_name
				  AND data_type in ('integer', 'bigint', 'smallint')
			)
			SELECT column_name, sequence_name
			FROM columns
			WHERE NOT sequence_name IS NULL
		LOOP
			v_sql = v_sql || format(E'\nDROP SEQUENCE IF EXISTS %I.%I;', p_target_schema, v_sequence_name);
			v_sql = v_sql || format(E'\nCREATE SEQUENCE %I.%I;', p_target_schema, v_sequence_name);
			v_sql = v_sql || format(E'\nALTER TABLE %I.%I ALTER COLUMN %I SET DEFAULT nextval(''%I.%I'');\n', p_target_schema, v_table_name, v_column_name, p_target_schema, v_sequence_name);
		END LOOP;	
	END LOOP;
	
	v_sql = v_sql || format(E'\nSET search_path TO %I, public', p_target_schema);
	for x in
        select c.conrelid::regclass as table_name, c.oid, c.conname
        from pg_constraint c
		join information_schema.tables t
		  on t.table_schema = 'proof_of_concept' -- p_target_schema
		 and t.table_name::text = c.conrelid::regclass::text
        where c.contype = 'f' 
    loop
        v_sql = v_sql || format(E'\nALTER TABLE %I.%I ADD CONSTRAINT %I.%I %s',
            p_target_schema, x.table_name,
			p_target_schema, x.conname,			
            REPLACE(pg_get_constraintdef(x.oid), 'REFERENCES ', 'REFERENCES ' || p_target_schema || '.'));
    end loop;
	
	IF p_dry_run THEN
		RAISE NOTICE '%', v_sql;
	ELSE
		EXECUTE v_sql;
	END IF;
END;

$$;


ALTER FUNCTION public.fn_copy_schema_tables(p_source_schema text, p_target_schema text, p_table_name text, p_dry_run boolean) OWNER TO clearinghouse_worker;

--
-- Name: get_transform_string(character varying, integer); Type: FUNCTION; Schema: public; Owner: sead_master
--

CREATE FUNCTION public.get_transform_string(method_name character varying, target_srid integer DEFAULT 4326) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
   srid		integer := -1;
   n_adj	integer := 0;
   e_adj	integer := 0;
   result_string text := '';
begin
   case
	when method_name = 'WGS84_UTM_zone_32' then
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
	  srid := 3020;
	  n_adj := 6000000;
	  e_adj := 1000000;
	when method_name = 'WGS84_UTM_zone_33N' then
	  srid := 32633;
	else
	  raise warning 'no matching coordinate method id found for method %', method_name;
	  return '-1';
   end case;

	result_string :=
		'st_transform(st_setsrid(st_point('
		|| method_name || '.y + ' || n_adj || ',' 
		|| method_name || '.x + ' || e_adj
		|| '), '
		|| srid
		|| '), ' 
		|| target_srid
		|| ')';
	return result_string;
		
   
end;
$$;


ALTER FUNCTION public.get_transform_string(method_name character varying, target_srid integer) OWNER TO sead_master;

--
-- Name: requiredtablestructurechanges(); Type: FUNCTION; Schema: public; Owner: sead_master
--

CREATE FUNCTION public.requiredtablestructurechanges() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	ALTER TABLE tbl_bugs_tsite ALTER COLUMN "Country" TYPE character varying(255);
	Perform BugsTransferLog('tbl_bugs_tsite', 'U', 'alter table, alter column "Country" type character varying(255)');

	Perform NumericifyColumn(
		t_name :=    'tbl_bugs_tspeciesassociations', 
		col_name :=  'CODE');
	Perform NumericifyColumn(
		t_name :=    'tbl_bugs_tspeciesassociations', 
		col_name :=  'AssociatedSpeciesCODE');
	Perform NumericifyColumn(
		t_name :=    'tbl_bugs_tecodefbugs', 
		col_name :=  'SortOrder',
		numeric_type := 'smallint');
	Perform NumericifyColumn(
		t_name :=    'tbl_bugs_tecobugs', 
		col_name :=  'CODE');
	Perform NumericifyColumn(
		t_name :=    'tbl_bugs_tecokoch', 
		col_name :=  'CODE');
	Perform NumericifyColumn(
		t_name :=    'tbl_bugs_tseasonactiveadult', 
		col_name :=  'CODE');
	Perform NumericifyColumn(
		t_name :=    'tbl_bugs_tperiods', 
		col_name :=  'Begin');
	Perform NumericifyColumn(
		t_name :=    'tbl_bugs_tperiods', 
		col_name :=  'End');		
END;
$$;


ALTER FUNCTION public.requiredtablestructurechanges() OWNER TO sead_master;

--
-- Name: site_landing_page_site(integer); Type: FUNCTION; Schema: public; Owner: clearinghouse_worker
--

CREATE FUNCTION public.site_landing_page_site(p_site_id integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE 
	v_json json;
BEGIN
	WITH T AS (
		SELECT json_build_object(
			'siteId', s.site_id,
			'siteName', s.site_name,
			'siteDescription', COALESCE(s.site_description,''),
			'places', site_landing_page_site_locations(p_site_id),
			'coordinates',  json_build_object(
				'lat', s.latitude_dd,
				'lng', s.longitude_dd,
				'epsg', '4326' -- FIXME!
			),
			'sections', json_build_array(
				site_landing_page_site_sample_section(p_site_id),
				null
			)
		) AS json_site
		FROM tbl_sites s
		WHERE s.site_id = p_site_id
	) SELECT json_site INTO v_json
	  FROM T;
	RETURN v_json;
END	
$$;


ALTER FUNCTION public.site_landing_page_site(p_site_id integer) OWNER TO clearinghouse_worker;

--
-- Name: site_landing_page_site_locations(integer); Type: FUNCTION; Schema: public; Owner: clearinghouse_worker
--

CREATE FUNCTION public.site_landing_page_site_locations(p_site_id integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE 
	v_json json;
BEGIN
	WITH T AS (
		SELECT L.location_name as name, L.location_type_id as level
		FROM tbl_site_locations SL
		JOIN tbl_locations L
		  ON L.location_id = SL.location_id
		WHERE SL.site_id = p_site_id
		ORDER BY L.location_type_id ASC
	) SELECT array_to_json(array_agg(T))
		INTO v_json
	  FROM T;
	RETURN v_json;
END	
$$;


ALTER FUNCTION public.site_landing_page_site_locations(p_site_id integer) OWNER TO clearinghouse_worker;

--
-- Name: site_landing_page_site_sample_groups(integer); Type: FUNCTION; Schema: public; Owner: clearinghouse_worker
--

CREATE FUNCTION public.site_landing_page_site_sample_groups(p_site_id integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE 
	v_sample_group_columns json;
	v_sample_group_rows json;
BEGIN
	 WITH data_columns AS (
		 SELECT *
		 FROM (
			 VALUES 
				('Samples', false, 'subtable'),
				('Site ID', false, 'numeric'),
				('Sample group ID', true, 'numeric'),
				('Sample group name', false, 'string'),
				('Sampling context', false, 'string'),
				('Sampling method', false, 'string'),
				('Number of samples', false, 'numeric'),
				('Datasets ID', false, 'string')
		) AS A(title,pkey,dataType)
	) SELECT array_to_json(array_agg(data_columns))
	  INTO v_sample_group_columns
	  FROM data_columns;
  
	WITH T AS (
		SELECT null
		FROM tbl_sites s
		WHERE s.site_id = 1
	) SELECT array_to_json(array_agg(T))
		INTO v_sample_group_rows
	  FROM T;
	  
	RETURN json_build_object(
			'name', 'samplegroups',
			'title', 'Sample groups',
			'data', json_build_object(
				'columns', v_sample_group_columns,
				'rows', v_sample_group_rows
			)
		);
END	
$$;


ALTER FUNCTION public.site_landing_page_site_sample_groups(p_site_id integer) OWNER TO clearinghouse_worker;

--
-- Name: site_landing_page_site_sample_section(integer); Type: FUNCTION; Schema: public; Owner: clearinghouse_worker
--

CREATE FUNCTION public.site_landing_page_site_sample_section(p_site_id integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE 
	v_json json;
BEGIN
	WITH T AS (
		SELECT json_build_object(
			'name', 'samples',
			'title', 'Samples',
			'description', 'Samples collected from this site',
			'contentItems', site_landing_page_site_sample_groups(p_site_id)
		) AS json_site
		FROM tbl_sites s
		WHERE s.site_id = p_site_id
	) SELECT json_site INTO v_json
	  FROM T;
	RETURN v_json;
END	
$$;


ALTER FUNCTION public.site_landing_page_site_sample_section(p_site_id integer) OWNER TO clearinghouse_worker;

--
-- Name: smallbiblioupdates(); Type: FUNCTION; Schema: public; Owner: sead_master
--

CREATE FUNCTION public.smallbiblioupdates() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	cnt_Lott2010 integer := -1;
BEGIN
	select count(*) from tbl_bugs_tbiblio 
		where "REFERENCE" like 'Lott 2010%'
		into cnt_Lott2010;
	if cnt_Lott2010 = 1 then
		-- small fix to handle the current state of 
		-- bugs, this should be ineffective after 
		-- fixes in original data.
		update tbl_bugs_tbiblio
		set "REFERENCE" = 'Lott 2010'
		where "REFERENCE" = 'Lott 2010a';
	end if;
END;
$$;


ALTER FUNCTION public.smallbiblioupdates() OWNER TO sead_master;

--
-- Name: syncsequences(); Type: FUNCTION; Schema: public; Owner: sead_master
--

CREATE FUNCTION public.syncsequences() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	sql record;
BEGIN
	FOR sql in SELECT 'SELECT SETVAL(' ||
				quote_literal(quote_ident(PGT.schemaname)|| 
				'.'||quote_ident(S.relname))|| 
				', MAX(' ||quote_ident(C.attname)|| 
				') ) FROM ' ||
				quote_ident(PGT.schemaname)|| '.'||quote_ident(T.relname)|| ';' as fix_query
			FROM pg_class AS S, pg_depend AS D, pg_class AS T, pg_attribute AS C, pg_tables AS PGT
			WHERE S.relkind = 'S'
			    AND S.oid = D.objid
			    AND D.refobjid = T.oid
			    AND D.refobjid = C.attrelid
			    AND D.refobjsubid = C.attnum
			    AND T.relname = PGT.tablename
			ORDER BY S.relname LOOP
		EXECUTE sql.fix_query;
	END LOOP;	
END;
$$;


ALTER FUNCTION public.syncsequences() OWNER TO sead_master;

SET default_with_oids = false;

--
-- Name: tbl_abundance_elements; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_abundance_elements (
    abundance_element_id integer NOT NULL,
    record_type_id integer,
    element_name character varying(100) NOT NULL,
    element_description text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_abundance_elements OWNER TO sead_master;

--
-- Name: COLUMN tbl_abundance_elements.record_type_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_abundance_elements.record_type_id IS 'used to restrict list of available elements according to record type. enables specific use of single term for multiple proxies whilst avoiding confusion, e.g. mni insects, mni seeds';


--
-- Name: COLUMN tbl_abundance_elements.element_name; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_abundance_elements.element_name IS 'short name for element, e.g. mni, seed, leaf';


--
-- Name: COLUMN tbl_abundance_elements.element_description; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_abundance_elements.element_description IS 'explanation of short name, e.g. minimum number of individuals, base of seed grain, covering of leaf or flower bud';


--
-- Name: tbl_abundance_ident_levels; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_abundance_ident_levels (
    abundance_ident_level_id integer NOT NULL,
    abundance_id integer NOT NULL,
    identification_level_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_abundance_ident_levels OWNER TO sead_master;

--
-- Name: tbl_abundance_modifications; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_abundance_modifications (
    abundance_modification_id integer NOT NULL,
    abundance_id integer NOT NULL,
    modification_type_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_abundance_modifications OWNER TO sead_master;

--
-- Name: tbl_abundances; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_abundances (
    abundance_id integer NOT NULL,
    taxon_id integer NOT NULL,
    analysis_entity_id integer NOT NULL,
    abundance_element_id integer,
    abundance integer DEFAULT 0 NOT NULL,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_abundances OWNER TO sead_master;

--
-- Name: TABLE tbl_abundances; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_abundances IS '20120503pib deleted column "abundance_modification_id" as appeared superfluous with "abundance_id" in tbl_adbundance_modifications';


--
-- Name: COLUMN tbl_abundances.abundance_element_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_abundances.abundance_element_id IS 'allows recording of different parts for single taxon, e.g. leaf, seed, mni etc.';


--
-- Name: COLUMN tbl_abundances.abundance; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_abundances.abundance IS 'usually count value (abundance) but can be presence (1) or catagorical or relative scale, as defined by tbl_data_types through tbl_datasets';


--
-- Name: tbl_activity_types; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_activity_types (
    activity_type_id integer NOT NULL,
    activity_type character varying(50) DEFAULT NULL::character varying,
    description text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_activity_types OWNER TO sead_master;

--
-- Name: tbl_age_types; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_age_types (
    age_type_id integer NOT NULL,
    age_type character varying(150) NOT NULL,
    description text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_age_types OWNER TO sead_master;

--
-- Name: tbl_aggregate_datasets; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_aggregate_datasets (
    aggregate_dataset_id integer NOT NULL,
    aggregate_order_type_id integer NOT NULL,
    biblio_id integer,
    aggregate_dataset_name character varying(255),
    date_updated timestamp with time zone DEFAULT now(),
    description text
);


ALTER TABLE public.tbl_aggregate_datasets OWNER TO sead_master;

--
-- Name: COLUMN tbl_aggregate_datasets.aggregate_dataset_name; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_aggregate_datasets.aggregate_dataset_name IS 'name of aggregated dataset';


--
-- Name: COLUMN tbl_aggregate_datasets.description; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_aggregate_datasets.description IS 'Notes explaining the purpose of the aggregated set of analysis entities';


--
-- Name: tbl_aggregate_order_types; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_aggregate_order_types (
    aggregate_order_type_id integer NOT NULL,
    aggregate_order_type character varying(60) NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    description text
);


ALTER TABLE public.tbl_aggregate_order_types OWNER TO sead_master;

--
-- Name: TABLE tbl_aggregate_order_types; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_aggregate_order_types IS '20120504pib: drop this? or replace with alternative?';


--
-- Name: COLUMN tbl_aggregate_order_types.aggregate_order_type; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_aggregate_order_types.aggregate_order_type IS 'aggregate order name, e.g. site name, age, sample depth, altitude';


--
-- Name: COLUMN tbl_aggregate_order_types.description; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_aggregate_order_types.description IS 'explanation of ordering system';


--
-- Name: tbl_aggregate_sample_ages; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_aggregate_sample_ages (
    aggregate_sample_age_id integer NOT NULL,
    aggregate_dataset_id integer NOT NULL,
    analysis_entity_age_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_aggregate_sample_ages OWNER TO sead_master;

--
-- Name: tbl_aggregate_samples; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_aggregate_samples (
    aggregate_sample_id integer NOT NULL,
    aggregate_dataset_id integer NOT NULL,
    analysis_entity_id integer NOT NULL,
    aggregate_sample_name character varying(50),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_aggregate_samples OWNER TO sead_master;

--
-- Name: TABLE tbl_aggregate_samples; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_aggregate_samples IS '20120504pib: can we drop aggregate sample name? seems excessive and unnecessary sample names can be traced.';


--
-- Name: COLUMN tbl_aggregate_samples.aggregate_sample_name; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_aggregate_samples.aggregate_sample_name IS 'optional name for aggregated entity.';


--
-- Name: tbl_alt_ref_types; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_alt_ref_types (
    alt_ref_type_id integer NOT NULL,
    alt_ref_type character varying(50) NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    description text
);


ALTER TABLE public.tbl_alt_ref_types OWNER TO sead_master;

--
-- Name: tbl_analysis_entities; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_analysis_entities (
    analysis_entity_id integer NOT NULL,
    physical_sample_id integer,
    dataset_id integer,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_analysis_entities OWNER TO sead_master;

--
-- Name: TABLE tbl_analysis_entities; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_analysis_entities IS '20120503pib deleted column preparation_method_id, but may need to cater for this in datasets...
20120506pib: deleted method_id and added table for multiple methods per entity';


--
-- Name: tbl_analysis_entity_ages; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_analysis_entity_ages (
    analysis_entity_age_id integer NOT NULL,
    age numeric(20,5) NOT NULL,
    age_older numeric(20,5),
    age_younger numeric(20,5),
    analysis_entity_id integer,
    chronology_id integer,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_analysis_entity_ages OWNER TO sead_master;

--
-- Name: TABLE tbl_analysis_entity_ages; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_analysis_entity_ages IS '20170911PIB: Changed numeric ranges of values to 20,5 to match tbl_relative_ages
20120504PIB: Should this be connected to physical sample instead of analysis entities? Allowing multiple ages (from multiple dates) for a sample. At the moment it requires a lot of backtracing to find a sample''s age... but then again, it allows... what, exactly?';


--
-- Name: tbl_analysis_entity_dimensions; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_analysis_entity_dimensions (
    analysis_entity_dimension_id integer NOT NULL,
    analysis_entity_id integer NOT NULL,
    dimension_id integer NOT NULL,
    dimension_value numeric NOT NULL,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_analysis_entity_dimensions OWNER TO sead_master;

--
-- Name: tbl_analysis_entity_prep_methods; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_analysis_entity_prep_methods (
    analysis_entity_prep_method_id integer NOT NULL,
    analysis_entity_id integer NOT NULL,
    method_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_analysis_entity_prep_methods OWNER TO sead_master;

--
-- Name: TABLE tbl_analysis_entity_prep_methods; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_analysis_entity_prep_methods IS '20170907PIB: Devolved due to problems in isolating measurement datasets with pretreatment/without. Many to many between datasets and methods used as replacement.
20120506PIB: created to cater for multiple preparation methods for analysis but maintaining simple dataset concept.';


--
-- Name: COLUMN tbl_analysis_entity_prep_methods.method_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_analysis_entity_prep_methods.method_id IS 'preparation methods only';


--
-- Name: tbl_biblio; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_biblio (
    biblio_id integer NOT NULL,
    authors character varying,
    bugs_reference character varying(60) DEFAULT NULL::character varying,
    date_updated timestamp with time zone DEFAULT now(),
    doi character varying(255) DEFAULT NULL::character varying,
    isbn character varying(128) DEFAULT NULL::character varying,
    notes text,
    title character varying,
    year character varying(255) DEFAULT NULL::character varying,
    full_reference text DEFAULT ''::text NOT NULL,
    url character varying
);


ALTER TABLE public.tbl_biblio OWNER TO sead_master;

--
-- Name: tbl_ceramics; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_ceramics (
    ceramics_id integer NOT NULL,
    analysis_entity_id integer NOT NULL,
    measurement_value character varying NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    ceramics_lookup_id integer NOT NULL
);


ALTER TABLE public.tbl_ceramics OWNER TO sead_master;

--
-- Name: tbl_ceramics_lookup; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_ceramics_lookup (
    ceramics_lookup_id integer NOT NULL,
    method_id integer NOT NULL,
    description text,
    name character varying NOT NULL,
    date_updated timestamp(6) with time zone DEFAULT now()
);


ALTER TABLE public.tbl_ceramics_lookup OWNER TO sead_master;

--
-- Name: TABLE tbl_ceramics_lookup; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_ceramics_lookup IS 'Type=lookup';


--
-- Name: tbl_ceramics_measurements; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_ceramics_measurements (
    ceramics_measurement_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    method_id integer
);


ALTER TABLE public.tbl_ceramics_measurements OWNER TO sead_master;

--
-- Name: TABLE tbl_ceramics_measurements; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_ceramics_measurements IS 'Type=lookup';


--
-- Name: tbl_chron_control_types; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_chron_control_types (
    chron_control_type_id integer NOT NULL,
    chron_control_type character varying(50),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_chron_control_types OWNER TO sead_master;

--
-- Name: tbl_chron_controls; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_chron_controls (
    chron_control_id integer NOT NULL,
    age numeric(20,5),
    age_limit_older numeric(20,5),
    age_limit_younger numeric(20,5),
    chron_control_type_id integer,
    chronology_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    depth_bottom numeric(20,5),
    depth_top numeric(20,5),
    notes text
);


ALTER TABLE public.tbl_chron_controls OWNER TO sead_master;

--
-- Name: tbl_chronologies; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_chronologies (
    chronology_id integer NOT NULL,
    age_bound_older integer,
    age_bound_younger integer,
    age_model character varying(255),
    chronology_name character varying(255),
    contact_id integer,
    date_prepared timestamp(0) without time zone,
    date_updated timestamp with time zone DEFAULT now(),
    is_default boolean DEFAULT false NOT NULL,
    notes text,
    sample_group_id integer,
    relative_age_type_id integer
);


ALTER TABLE public.tbl_chronologies OWNER TO sead_master;

--
-- Name: TABLE tbl_chronologies; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_chronologies IS '20170911PIB: Removed Not Null requirement for sample-group_id to allow for chronologies not tied to a single sample group (e.e. calibrated ages for DataArc or other projects)
Increased length of some fields.
20120504PIB: Note that the dropped age type recorded the type of dates (C14 etc) used in constructing the chronology... but is only one per chonology enough? Can a chronology not be made up of mulitple types of age? (No, years types can only be of one sort - need to calibrate if mixed?)';


--
-- Name: COLUMN tbl_chronologies.relative_age_type_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_chronologies.relative_age_type_id IS 'Constraint removed to obsolete table (tbl_age_types), replaced by non-binding id of relative_age_types - but not fully implemented. Notes should be used to inform on chronology years types and construction.';


--
-- Name: tbl_colours; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_colours (
    colour_id integer NOT NULL,
    colour_name character varying(30) NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    method_id integer NOT NULL,
    rgb integer
);


ALTER TABLE public.tbl_colours OWNER TO sead_master;

--
-- Name: tbl_contact_types; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_contact_types (
    contact_type_id integer NOT NULL,
    contact_type_name character varying(150) NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    description text
);


ALTER TABLE public.tbl_contact_types OWNER TO sead_master;

--
-- Name: tbl_contacts; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_contacts (
    contact_id integer NOT NULL,
    address_1 character varying(255),
    address_2 character varying(255),
    location_id integer,
    email character varying,
    first_name character varying(50),
    last_name character varying(100),
    phone_number character varying(50),
    url text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_contacts OWNER TO sead_master;

--
-- Name: tbl_coordinate_method_dimensions; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_coordinate_method_dimensions (
    coordinate_method_dimension_id integer NOT NULL,
    dimension_id integer NOT NULL,
    method_id integer NOT NULL,
    limit_upper numeric(18,10),
    limit_lower numeric(18,10),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_coordinate_method_dimensions OWNER TO sead_master;

--
-- Name: tbl_data_type_groups; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_data_type_groups (
    data_type_group_id integer NOT NULL,
    data_type_group_name character varying(25),
    date_updated timestamp with time zone DEFAULT now(),
    description text
);


ALTER TABLE public.tbl_data_type_groups OWNER TO sead_master;

--
-- Name: tbl_data_types; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_data_types (
    data_type_id integer NOT NULL,
    data_type_group_id integer NOT NULL,
    data_type_name character varying(25) DEFAULT NULL::character varying,
    date_updated timestamp with time zone DEFAULT now(),
    definition text
);


ALTER TABLE public.tbl_data_types OWNER TO sead_master;

--
-- Name: tbl_identification_levels; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_identification_levels (
    identification_level_id integer NOT NULL,
    identification_level_abbrev character varying(50) DEFAULT NULL::character varying,
    identification_level_name character varying(50) DEFAULT NULL::character varying,
    notes text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_identification_levels OWNER TO sead_master;

--
-- Name: tbl_modification_types; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_modification_types (
    modification_type_id integer NOT NULL,
    modification_type_name character varying(128),
    modification_type_description text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_modification_types OWNER TO sead_master;

--
-- Name: COLUMN tbl_modification_types.modification_type_name; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_modification_types.modification_type_name IS 'short name of modification, e.g. carbonised';


--
-- Name: COLUMN tbl_modification_types.modification_type_description; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_modification_types.modification_type_description IS 'clear explanation of modification so that name makes sense to non-domain scientists';


--
-- Name: tbl_datasets; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_datasets (
    dataset_id integer NOT NULL,
    master_set_id integer,
    data_type_id integer NOT NULL,
    method_id integer,
    biblio_id integer,
    updated_dataset_id integer,
    project_id integer,
    dataset_name character varying(50) NOT NULL,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_datasets OWNER TO sead_master;

--
-- Name: COLUMN tbl_datasets.dataset_name; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_datasets.dataset_name IS 'something uniquely identifying the dataset for this site. may be same as sample group name, or created adhoc if necessary, but preferably with some meaning.';


--
-- Name: tbl_physical_samples; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_physical_samples (
    physical_sample_id integer NOT NULL,
    sample_group_id integer DEFAULT 0 NOT NULL,
    alt_ref_type_id integer,
    sample_type_id integer NOT NULL,
    sample_name character varying(50) NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    date_sampled character varying
);


ALTER TABLE public.tbl_physical_samples OWNER TO sead_master;

--
-- Name: TABLE tbl_physical_samples; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_physical_samples IS '20120504PIB: deleted columns XYZ and created external tbl_sample_coodinates
20120506PIB: deleted columns depth_top & depth_bottom and moved to tbl_sample_dimensions
20130416PIB: changed to date_sampled from date to varchar format to increase flexibility';


--
-- Name: COLUMN tbl_physical_samples.alt_ref_type_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_physical_samples.alt_ref_type_id IS 'type of name represented by primary sample name, e.g. lab number, museum number etc.';


--
-- Name: COLUMN tbl_physical_samples.sample_type_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_physical_samples.sample_type_id IS 'physical form of sample, e.g. bulk sample, kubienta subsample, core subsample, dendro core, dendro slice...';


--
-- Name: COLUMN tbl_physical_samples.sample_name; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_physical_samples.sample_name IS 'reference number or name of sample. multiple references/names can be added as alternative references.';


--
-- Name: COLUMN tbl_physical_samples.date_sampled; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_physical_samples.date_sampled IS 'Date samples were taken. ';


--
-- Name: tbl_taxa_tree_genera; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_taxa_tree_genera (
    genus_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    family_id integer,
    genus_name character varying(100) DEFAULT NULL::character varying
);


ALTER TABLE public.tbl_taxa_tree_genera OWNER TO sead_master;

--
-- Name: tbl_taxa_tree_master; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_taxa_tree_master (
    taxon_id integer NOT NULL,
    author_id integer,
    date_updated timestamp with time zone DEFAULT now(),
    genus_id integer,
    species character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.tbl_taxa_tree_master OWNER TO sead_master;

--
-- Name: TABLE tbl_taxa_tree_master; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_taxa_tree_master IS '20130416PIB: removed default=0 for author_id and genus_id as was incorrect';


--
-- Name: tbl_dataset_contacts; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_dataset_contacts (
    dataset_contact_id integer NOT NULL,
    contact_id integer NOT NULL,
    contact_type_id integer NOT NULL,
    dataset_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_dataset_contacts OWNER TO sead_master;

--
-- Name: tbl_dataset_masters; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_dataset_masters (
    master_set_id integer NOT NULL,
    contact_id integer,
    biblio_id integer,
    master_name character varying(100),
    master_notes text,
    url text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_dataset_masters OWNER TO sead_master;

--
-- Name: COLUMN tbl_dataset_masters.biblio_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_dataset_masters.biblio_id IS 'primary reference for master dataset if available, e.g. buckland & buckland 2006 for bugscep';


--
-- Name: COLUMN tbl_dataset_masters.master_name; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_dataset_masters.master_name IS 'identification of master dataset, e.g. mal, bugscep, dendrolab';


--
-- Name: COLUMN tbl_dataset_masters.master_notes; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_dataset_masters.master_notes IS 'description of master dataset, its form (e.g. database, lab) and any other relevant information for tracing it.';


--
-- Name: COLUMN tbl_dataset_masters.url; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_dataset_masters.url IS 'website or other url for master dataset, be it a project, lab or... other';


--
-- Name: tbl_dimensions; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_dimensions (
    dimension_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    dimension_abbrev character varying(16),
    dimension_description text,
    dimension_name character varying(50) NOT NULL,
    unit_id integer,
    method_group_id integer
);


ALTER TABLE public.tbl_dimensions OWNER TO sead_master;

--
-- Name: COLUMN tbl_dimensions.method_group_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_dimensions.method_group_id IS 'Limits choice of dimension by method group (e.g. size measurements, coordinate systems)';


--
-- Name: tbl_measured_value_dimensions; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_measured_value_dimensions (
    measured_value_dimension_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    dimension_id integer NOT NULL,
    dimension_value numeric(18,10) NOT NULL,
    measured_value_id integer NOT NULL
);


ALTER TABLE public.tbl_measured_value_dimensions OWNER TO sead_master;

--
-- Name: tbl_measured_values; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_measured_values (
    measured_value_id integer NOT NULL,
    analysis_entity_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    measured_value numeric(20,10) NOT NULL
);


ALTER TABLE public.tbl_measured_values OWNER TO sead_master;

--
-- Name: tbl_methods; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_methods (
    method_id integer NOT NULL,
    biblio_id integer,
    date_updated timestamp with time zone DEFAULT now(),
    description text NOT NULL,
    method_abbrev_or_alt_name character varying(50),
    method_group_id integer NOT NULL,
    method_name character varying(50) NOT NULL,
    record_type_id integer,
    unit_id integer
);


ALTER TABLE public.tbl_methods OWNER TO sead_master;

--
-- Name: tbl_dataset_submission_types; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_dataset_submission_types (
    submission_type_id integer NOT NULL,
    submission_type character varying(60) NOT NULL,
    description text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_dataset_submission_types OWNER TO sead_master;

--
-- Name: COLUMN tbl_dataset_submission_types.submission_type; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_dataset_submission_types.submission_type IS 'descriptive name for type of submission, e.g. original submission, ingestion from another database';


--
-- Name: COLUMN tbl_dataset_submission_types.description; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_dataset_submission_types.description IS 'explanation of submission type, explaining clearly data ingestion mechanism';


--
-- Name: tbl_dataset_submissions; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_dataset_submissions (
    dataset_submission_id integer NOT NULL,
    dataset_id integer NOT NULL,
    submission_type_id integer NOT NULL,
    contact_id integer NOT NULL,
    date_submitted date NOT NULL,
    notes text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_dataset_submissions OWNER TO sead_master;

--
-- Name: COLUMN tbl_dataset_submissions.notes; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_dataset_submissions.notes IS 'any details of submission not covered by submission_type information, such as name of source from which submission originates if not covered elsewhere in database, e.g. from bugscep';


--
-- Name: tbl_dating_labs; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_dating_labs (
    dating_lab_id integer NOT NULL,
    contact_id integer,
    international_lab_id character varying(10) NOT NULL,
    lab_name character varying(100) DEFAULT NULL::character varying,
    country_id integer,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_dating_labs OWNER TO sead_master;

--
-- Name: TABLE tbl_dating_labs; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_dating_labs IS '20120504pib: reduced this table and linked to tbl_contacts for address related data';


--
-- Name: COLUMN tbl_dating_labs.contact_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_dating_labs.contact_id IS 'address details are stored in tbl_contacts';


--
-- Name: COLUMN tbl_dating_labs.international_lab_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_dating_labs.international_lab_id IS 'international standard radiocarbon lab identifier.
from http://www.radiocarbon.org/info/labcodes.html';


--
-- Name: COLUMN tbl_dating_labs.lab_name; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_dating_labs.lab_name IS 'international standard name of radiocarbon lab, from http://www.radiocarbon.org/info/labcodes.html';


--
-- Name: tbl_dating_material; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_dating_material (
    dating_material_id integer NOT NULL,
    geochron_id integer NOT NULL,
    taxon_id integer,
    material_dated character varying,
    description text,
    abundance_element_id integer,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_dating_material OWNER TO sead_master;

--
-- Name: TABLE tbl_dating_material; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_dating_material IS '20130722PIB: Added field date_updated';


--
-- Name: tbl_dating_uncertainty; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_dating_uncertainty (
    dating_uncertainty_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    description text,
    uncertainty character varying
);


ALTER TABLE public.tbl_dating_uncertainty OWNER TO sead_master;

--
-- Name: tbl_dendro; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_dendro (
    dendro_id integer NOT NULL,
    analysis_entity_id integer NOT NULL,
    measurement_value character varying NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    dendro_lookup_id integer NOT NULL
);


ALTER TABLE public.tbl_dendro OWNER TO sead_master;

--
-- Name: tbl_dendro_date_notes; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_dendro_date_notes (
    dendro_date_note_id integer NOT NULL,
    dendro_date_id integer NOT NULL,
    note text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_dendro_date_notes OWNER TO sead_master;

--
-- Name: tbl_dendro_dates; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_dendro_dates (
    dendro_date_id integer NOT NULL,
    analysis_entity_id integer NOT NULL,
    age_younger integer,
    dating_uncertainty_id integer,
    season_or_qualifier_id integer,
    date_updated timestamp with time zone DEFAULT now(),
    age_older integer,
    error_plus integer,
    error_minus integer,
    dendro_lookup_id integer NOT NULL,
    error_uncertainty_id integer,
    age_type_id integer NOT NULL
);


ALTER TABLE public.tbl_dendro_dates OWNER TO sead_master;

--
-- Name: TABLE tbl_dendro_dates; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_dendro_dates IS '20130722PIB: Added field dating_uncertainty_id to cater for >< etc.
20130722PIB: prefixed fieldnames age_younger and age_older with "cal_" to conform with equivalent names in other tables';


--
-- Name: tbl_dendro_lookup; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_dendro_lookup (
    dendro_lookup_id integer NOT NULL,
    method_id integer,
    name character varying NOT NULL,
    description text,
    date_updated timestamp(6) with time zone DEFAULT now()
);


ALTER TABLE public.tbl_dendro_lookup OWNER TO sead_master;

--
-- Name: TABLE tbl_dendro_lookup; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_dendro_lookup IS 'Type=lookup';


--
-- Name: tbl_dendro_measurements; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_dendro_measurements (
    dendro_measurement_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    method_id integer
);


ALTER TABLE public.tbl_dendro_measurements OWNER TO sead_master;

--
-- Name: TABLE tbl_dendro_measurements; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_dendro_measurements IS 'Type=lookup';


--
-- Name: tbl_ecocode_definitions; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_ecocode_definitions (
    ecocode_definition_id integer NOT NULL,
    abbreviation character varying(10) DEFAULT NULL::character varying,
    date_updated timestamp with time zone DEFAULT now(),
    definition text,
    ecocode_group_id integer DEFAULT 0,
    name character varying(150) DEFAULT NULL::character varying,
    notes text,
    sort_order smallint DEFAULT 0
);


ALTER TABLE public.tbl_ecocode_definitions OWNER TO sead_master;

--
-- Name: tbl_ecocode_groups; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_ecocode_groups (
    ecocode_group_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    definition text DEFAULT NULL::character varying,
    ecocode_system_id integer DEFAULT 0,
    name character varying(200) DEFAULT NULL::character varying,
    abbreviation character varying(50)
);


ALTER TABLE public.tbl_ecocode_groups OWNER TO sead_master;

--
-- Name: tbl_ecocode_systems; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_ecocode_systems (
    ecocode_system_id integer NOT NULL,
    biblio_id integer,
    date_updated timestamp with time zone DEFAULT now(),
    definition text DEFAULT NULL::character varying,
    name character varying(50) DEFAULT NULL::character varying,
    notes text
);


ALTER TABLE public.tbl_ecocode_systems OWNER TO sead_master;

--
-- Name: tbl_ecocodes; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_ecocodes (
    ecocode_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    ecocode_definition_id integer DEFAULT 0,
    taxon_id integer DEFAULT 0
);


ALTER TABLE public.tbl_ecocodes OWNER TO sead_master;

--
-- Name: tbl_error_uncertainties; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_error_uncertainties (
    error_uncertainty_id integer NOT NULL,
    error_uncertainty_type character varying(150) NOT NULL,
    description text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_error_uncertainties OWNER TO sead_master;

--
-- Name: tbl_feature_types; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_feature_types (
    feature_type_id integer NOT NULL,
    feature_type_name character varying(128),
    feature_type_description text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_feature_types OWNER TO sead_master;

--
-- Name: tbl_features; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_features (
    feature_id integer NOT NULL,
    feature_type_id integer NOT NULL,
    feature_name character varying,
    feature_description text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_features OWNER TO sead_master;

--
-- Name: COLUMN tbl_features.feature_name; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_features.feature_name IS 'estabilished reference name/number for the feature (note: not the sample). e.g. well 47, anl.3, c107.
remember that a sample can come from multiple features (e.g. c107 in well 47) but each feature should have a separate record.';


--
-- Name: COLUMN tbl_features.feature_description; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_features.feature_description IS 'description of the feature. may include any field notes, lab notes or interpretation information useful for interpreting the sample data.';


--
-- Name: tbl_geochron_refs; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_geochron_refs (
    geochron_ref_id integer NOT NULL,
    geochron_id integer NOT NULL,
    biblio_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_geochron_refs OWNER TO sead_master;

--
-- Name: COLUMN tbl_geochron_refs.biblio_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_geochron_refs.biblio_id IS 'reference for specific date';


--
-- Name: tbl_geochronology; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_geochronology (
    geochron_id integer NOT NULL,
    analysis_entity_id integer NOT NULL,
    dating_lab_id integer,
    lab_number character varying(40),
    age numeric(20,5),
    error_older numeric(20,5),
    error_younger numeric(20,5),
    delta_13c numeric(10,5),
    notes text,
    date_updated timestamp with time zone DEFAULT now(),
    dating_uncertainty_id integer
);


ALTER TABLE public.tbl_geochronology OWNER TO sead_master;

--
-- Name: TABLE tbl_geochronology; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_geochronology IS '20130722PIB: Altered field uncertainty (varchar) to dating_uncertainty_id and linked to tbl_dating_uncertainty to enable lookup of uncertainty modifiers for dates';


--
-- Name: COLUMN tbl_geochronology.age; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_geochronology.age IS 'radiocarbon (or other radiometric) age.';


--
-- Name: COLUMN tbl_geochronology.error_older; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_geochronology.error_older IS 'plus (+) side of the measured error (set same as error_younger if standard +/- error)';


--
-- Name: COLUMN tbl_geochronology.error_younger; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_geochronology.error_younger IS 'minus (-) side of the measured error (set same as error_younger if standard +/- error)';


--
-- Name: COLUMN tbl_geochronology.delta_13c; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_geochronology.delta_13c IS 'delta 13c where available for calibration correction.';


--
-- Name: COLUMN tbl_geochronology.notes; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_geochronology.notes IS 'notes specific to this date';


--
-- Name: tbl_horizons; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_horizons (
    horizon_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    description text,
    horizon_name character varying(15) NOT NULL,
    method_id integer NOT NULL
);


ALTER TABLE public.tbl_horizons OWNER TO sead_master;

--
-- Name: tbl_image_types; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_image_types (
    image_type_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    description text,
    image_type character varying(40) NOT NULL
);


ALTER TABLE public.tbl_image_types OWNER TO sead_master;

--
-- Name: tbl_imported_taxa_replacements; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_imported_taxa_replacements (
    imported_taxa_replacement_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    imported_name_replaced character varying(100) NOT NULL,
    taxon_id integer NOT NULL
);


ALTER TABLE public.tbl_imported_taxa_replacements OWNER TO sead_master;

--
-- Name: tbl_languages; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_languages (
    language_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    language_name_english character varying(100) DEFAULT NULL::character varying,
    language_name_native character varying(100) DEFAULT NULL::character varying
);


ALTER TABLE public.tbl_languages OWNER TO sead_master;

--
-- Name: tbl_lithology; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_lithology (
    lithology_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    depth_bottom numeric(20,5),
    depth_top numeric(20,5) NOT NULL,
    description text NOT NULL,
    lower_boundary character varying(255),
    sample_group_id integer NOT NULL
);


ALTER TABLE public.tbl_lithology OWNER TO sead_master;

--
-- Name: tbl_location_types; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_location_types (
    location_type_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    description text,
    location_type character varying(40)
);


ALTER TABLE public.tbl_location_types OWNER TO sead_master;

--
-- Name: tbl_locations; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_locations (
    location_id integer NOT NULL,
    location_name character varying(255) NOT NULL,
    location_type_id integer NOT NULL,
    default_lat_dd numeric(18,10),
    default_long_dd numeric(18,10),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_locations OWNER TO sead_master;

--
-- Name: COLUMN tbl_locations.default_lat_dd; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_locations.default_lat_dd IS 'default latitude in decimal degrees for location, e.g. mid point of country. leave empty if not known.';


--
-- Name: COLUMN tbl_locations.default_long_dd; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_locations.default_long_dd IS 'default longitude in decimal degrees for location, e.g. mid point of country';


--
-- Name: tbl_mcr_names; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_mcr_names (
    taxon_id integer NOT NULL,
    comparison_notes character varying(255) DEFAULT NULL::character varying,
    date_updated timestamp with time zone DEFAULT now(),
    mcr_name_trim character varying(80) DEFAULT NULL::character varying,
    mcr_number smallint DEFAULT 0,
    mcr_species_name character varying(200) DEFAULT NULL::character varying
);


ALTER TABLE public.tbl_mcr_names OWNER TO sead_master;

--
-- Name: tbl_mcr_summary_data; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_mcr_summary_data (
    mcr_summary_data_id integer NOT NULL,
    cog_mid_tmax smallint DEFAULT 0,
    cog_mid_trange smallint DEFAULT 0,
    date_updated timestamp with time zone DEFAULT now(),
    taxon_id integer NOT NULL,
    tmax_hi smallint DEFAULT 0,
    tmax_lo smallint DEFAULT 0,
    tmin_hi smallint DEFAULT 0,
    tmin_lo smallint DEFAULT 0,
    trange_hi smallint DEFAULT 0,
    trange_lo smallint DEFAULT 0
);


ALTER TABLE public.tbl_mcr_summary_data OWNER TO sead_master;

--
-- Name: tbl_mcrdata_birmbeetledat; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_mcrdata_birmbeetledat (
    mcrdata_birmbeetledat_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    mcr_data text,
    mcr_row smallint NOT NULL,
    taxon_id integer NOT NULL
);


ALTER TABLE public.tbl_mcrdata_birmbeetledat OWNER TO sead_master;

--
-- Name: tbl_method_groups; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_method_groups (
    method_group_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    description text NOT NULL,
    group_name character varying(100) NOT NULL
);


ALTER TABLE public.tbl_method_groups OWNER TO sead_master;

--
-- Name: tbl_physical_sample_features; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_physical_sample_features (
    physical_sample_feature_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    feature_id integer NOT NULL,
    physical_sample_id integer NOT NULL
);


ALTER TABLE public.tbl_physical_sample_features OWNER TO sead_master;

--
-- Name: tbl_project_stages; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_project_stages (
    project_stage_id integer NOT NULL,
    stage_name character varying,
    description text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_project_stages OWNER TO sead_master;

--
-- Name: COLUMN tbl_project_stages.stage_name; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_project_stages.stage_name IS 'stage of project in investigative cycle, e.g. desktop study, prospection, final excavation';


--
-- Name: COLUMN tbl_project_stages.description; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_project_stages.description IS 'explanation of stage name term, including details of purpose and general contents';


--
-- Name: tbl_project_types; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_project_types (
    project_type_id integer NOT NULL,
    project_type_name character varying,
    description text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_project_types OWNER TO sead_master;

--
-- Name: COLUMN tbl_project_types.project_type_name; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_project_types.project_type_name IS 'descriptive name for project type, e.g. consultancy, research, teaching; also combinations consultancy/teaching';


--
-- Name: COLUMN tbl_project_types.description; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_project_types.description IS 'project type combinations can be used where appropriate, e.g. teaching/research';


--
-- Name: tbl_projects; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_projects (
    project_id integer NOT NULL,
    project_type_id integer,
    project_stage_id integer,
    project_name character varying(150),
    project_abbrev_name character varying(25),
    description text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_projects OWNER TO sead_master;

--
-- Name: COLUMN tbl_projects.project_name; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_projects.project_name IS 'name of project (e.g. phil''s phd thesis, malmö ringroad vägverket)';


--
-- Name: COLUMN tbl_projects.project_abbrev_name; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_projects.project_abbrev_name IS 'optional. abbreviation of project name or acronym (e.g. vgv, swedab)';


--
-- Name: COLUMN tbl_projects.description; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_projects.description IS 'brief description of project and any useful information for finding out more.';


--
-- Name: tbl_rdb; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_rdb (
    rdb_id integer NOT NULL,
    location_id integer NOT NULL,
    rdb_code_id integer,
    taxon_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_rdb OWNER TO sead_master;

--
-- Name: COLUMN tbl_rdb.location_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_rdb.location_id IS 'geographical source/relevance of the specific code. e.g. the international iucn classification of species in the uk.';


--
-- Name: tbl_rdb_codes; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_rdb_codes (
    rdb_code_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    rdb_category character varying(4) DEFAULT NULL::character varying,
    rdb_definition character varying(200) DEFAULT NULL::character varying,
    rdb_system_id integer DEFAULT 0
);


ALTER TABLE public.tbl_rdb_codes OWNER TO sead_master;

--
-- Name: tbl_rdb_systems; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_rdb_systems (
    rdb_system_id integer NOT NULL,
    biblio_id integer NOT NULL,
    location_id integer NOT NULL,
    rdb_first_published smallint,
    rdb_system character varying(10) DEFAULT NULL::character varying,
    rdb_system_date integer,
    rdb_version character varying(10) DEFAULT NULL::character varying,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_rdb_systems OWNER TO sead_master;

--
-- Name: COLUMN tbl_rdb_systems.location_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_rdb_systems.location_id IS 'geaographical relevance of rdb code system, e.g. uk, international, new forest';


--
-- Name: tbl_record_types; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_record_types (
    record_type_id integer NOT NULL,
    record_type_name character varying(50) DEFAULT NULL::character varying,
    record_type_description text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_record_types OWNER TO sead_master;

--
-- Name: TABLE tbl_record_types; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_record_types IS 'may also use this to group methods - e.g. phosphate analyses (whereas tbl_method_groups would store the larger group "palaeo chemical/physical" methods)';


--
-- Name: COLUMN tbl_record_types.record_type_name; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_record_types.record_type_name IS 'short name of proxy/proxies in group';


--
-- Name: COLUMN tbl_record_types.record_type_description; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_record_types.record_type_description IS 'detailed description of group and explanation for grouping';


--
-- Name: tbl_relative_age_refs; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_relative_age_refs (
    relative_age_ref_id integer NOT NULL,
    biblio_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    relative_age_id integer NOT NULL
);


ALTER TABLE public.tbl_relative_age_refs OWNER TO sead_master;

--
-- Name: tbl_relative_age_types; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_relative_age_types (
    relative_age_type_id integer NOT NULL,
    age_type character varying,
    description text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_relative_age_types OWNER TO sead_master;

--
-- Name: TABLE tbl_relative_age_types; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_relative_age_types IS '20130723PIB: replaced date_updated column with new one with same name but correct data type
20140226EE: replaced date_updated column with correct time data type';


--
-- Name: COLUMN tbl_relative_age_types.age_type; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_relative_age_types.age_type IS 'name of chronological age type, e.g. archaeological period, single calendar date, calendar age range, blytt-sernander';


--
-- Name: COLUMN tbl_relative_age_types.description; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_relative_age_types.description IS 'description of chronological age type, e.g. period defined by archaeological and or geological dates representing cultural activity period, climate period defined by palaeo-vegetation records';


--
-- Name: tbl_relative_ages; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_relative_ages (
    relative_age_id integer NOT NULL,
    relative_age_type_id integer,
    relative_age_name character varying(50),
    description text,
    c14_age_older numeric(20,5),
    c14_age_younger numeric(20,5),
    cal_age_older numeric(20,5),
    cal_age_younger numeric(20,5),
    notes text,
    date_updated timestamp with time zone DEFAULT now(),
    location_id integer,
    abbreviation character varying
);


ALTER TABLE public.tbl_relative_ages OWNER TO sead_master;

--
-- Name: TABLE tbl_relative_ages; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_relative_ages IS '20120504PIB: removed biblio_id as is replaced by tbl_relative_age_refs
20130722PIB: changed colour in model to AliceBlue to reflect degree of user addition possible (i.e. ages can be added for reference in tbl_relative_dates)';


--
-- Name: COLUMN tbl_relative_ages.relative_age_name; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_relative_ages.relative_age_name IS 'name of the dating period, e.g. bronze age. calendar ages should be given appropriate names such as ad 1492, 74 bc';


--
-- Name: COLUMN tbl_relative_ages.description; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_relative_ages.description IS 'a description of the (usually) period.';


--
-- Name: COLUMN tbl_relative_ages.c14_age_older; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_relative_ages.c14_age_older IS 'c14 age of younger boundary of period (where relevant).';


--
-- Name: COLUMN tbl_relative_ages.c14_age_younger; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_relative_ages.c14_age_younger IS 'c14 age of later boundary of period (where relevant). leave blank for calendar ages.';


--
-- Name: COLUMN tbl_relative_ages.cal_age_older; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_relative_ages.cal_age_older IS '(approximate) age before present (1950) of earliest boundary of period. or if calendar age then the calendar age converted to bp.';


--
-- Name: COLUMN tbl_relative_ages.cal_age_younger; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_relative_ages.cal_age_younger IS '(approximate) age before present (1950) of latest boundary of period. or if calendar age then the calendar age converted to bp.';


--
-- Name: COLUMN tbl_relative_ages.notes; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_relative_ages.notes IS 'any further notes not included in the description, such as reliability of definition or fuzzyness of boundaries.';


--
-- Name: COLUMN tbl_relative_ages.abbreviation; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_relative_ages.abbreviation IS 'Standard abbreviated form of name if available';


--
-- Name: tbl_relative_dates; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_relative_dates (
    relative_date_id integer NOT NULL,
    relative_age_id integer,
    method_id integer,
    notes text,
    date_updated timestamp with time zone DEFAULT now(),
    dating_uncertainty_id integer,
    analysis_entity_id integer NOT NULL
);


ALTER TABLE public.tbl_relative_dates OWNER TO sead_master;

--
-- Name: TABLE tbl_relative_dates; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_relative_dates IS '20120504PIB: Added method_id to store dating method used to attribute sample to period or calendar date (e.g. strategraphic dating, typological)
20130722PIB: added field dating_uncertainty_id to cater for "from", "to" and "ca." etc. especially from import of BugsCEP
20170906PIB: removed fk physical_samples_id and replaced with analysis_entity_id';


--
-- Name: COLUMN tbl_relative_dates.method_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_relative_dates.method_id IS 'dating method used to attribute sample to period or calendar date.';


--
-- Name: COLUMN tbl_relative_dates.notes; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_relative_dates.notes IS 'any notes specific to the dating of this sample to this calendar or period based age';


--
-- Name: tbl_sample_alt_refs; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_alt_refs (
    sample_alt_ref_id integer NOT NULL,
    alt_ref character varying(60) NOT NULL,
    alt_ref_type_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    physical_sample_id integer NOT NULL
);


ALTER TABLE public.tbl_sample_alt_refs OWNER TO sead_master;

--
-- Name: tbl_sample_colours; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_colours (
    sample_colour_id integer NOT NULL,
    colour_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    physical_sample_id integer NOT NULL
);


ALTER TABLE public.tbl_sample_colours OWNER TO sead_master;

--
-- Name: tbl_sample_coordinates; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_coordinates (
    sample_coordinate_id integer NOT NULL,
    physical_sample_id integer NOT NULL,
    coordinate_method_dimension_id integer NOT NULL,
    measurement numeric(20,10) NOT NULL,
    accuracy numeric(20,10),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_sample_coordinates OWNER TO sead_master;

--
-- Name: COLUMN tbl_sample_coordinates.accuracy; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_sample_coordinates.accuracy IS 'GPS type accuracy, e.g. 5m 10m 0.01m';


--
-- Name: tbl_sample_description_sample_group_contexts; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_description_sample_group_contexts (
    sample_description_sample_group_context_id integer NOT NULL,
    sampling_context_id integer,
    sample_description_type_id integer,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_sample_description_sample_group_contexts OWNER TO sead_master;

--
-- Name: tbl_sample_description_types; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_description_types (
    sample_description_type_id integer NOT NULL,
    type_name character varying(255),
    type_description text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_sample_description_types OWNER TO sead_master;

--
-- Name: tbl_sample_descriptions; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_descriptions (
    sample_description_id integer NOT NULL,
    sample_description_type_id integer NOT NULL,
    physical_sample_id integer NOT NULL,
    description character varying,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_sample_descriptions OWNER TO sead_master;

--
-- Name: tbl_sample_dimensions; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_dimensions (
    sample_dimension_id integer NOT NULL,
    physical_sample_id integer NOT NULL,
    dimension_id integer NOT NULL,
    method_id integer NOT NULL,
    dimension_value numeric(20,10) NOT NULL,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_sample_dimensions OWNER TO sead_master;

--
-- Name: TABLE tbl_sample_dimensions; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_sample_dimensions IS '20120506pib: depth measurements for samples moved here from tbl_physical_samples';


--
-- Name: COLUMN tbl_sample_dimensions.dimension_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_sample_dimensions.dimension_id IS 'details of the dimension measured';


--
-- Name: COLUMN tbl_sample_dimensions.method_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_sample_dimensions.method_id IS 'method describing dimension measurement, with link to units used';


--
-- Name: COLUMN tbl_sample_dimensions.dimension_value; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_sample_dimensions.dimension_value IS 'numerical value of dimension, in the units indicated in the documentation and interface.';


--
-- Name: tbl_sample_group_coordinates; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_group_coordinates (
    sample_group_position_id integer NOT NULL,
    coordinate_method_dimension_id integer NOT NULL,
    sample_group_position numeric(20,10),
    position_accuracy character varying(128),
    sample_group_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_sample_group_coordinates OWNER TO sead_master;

--
-- Name: tbl_sample_group_description_type_sampling_contexts; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_group_description_type_sampling_contexts (
    sample_group_description_type_sampling_context_id integer NOT NULL,
    sampling_context_id integer NOT NULL,
    sample_group_description_type_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_sample_group_description_type_sampling_contexts OWNER TO sead_master;

--
-- Name: tbl_sample_group_description_types; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_group_description_types (
    sample_group_description_type_id integer NOT NULL,
    type_name character varying(255),
    type_description character varying,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_sample_group_description_types OWNER TO sead_master;

--
-- Name: tbl_sample_group_descriptions; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_group_descriptions (
    sample_group_description_id integer NOT NULL,
    group_description character varying,
    sample_group_description_type_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    sample_group_id integer
);


ALTER TABLE public.tbl_sample_group_descriptions OWNER TO sead_master;

--
-- Name: tbl_sample_group_dimensions; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_group_dimensions (
    sample_group_dimension_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    dimension_id integer NOT NULL,
    dimension_value numeric(20,5) NOT NULL,
    sample_group_id integer NOT NULL
);


ALTER TABLE public.tbl_sample_group_dimensions OWNER TO sead_master;

--
-- Name: tbl_sample_group_images; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_group_images (
    sample_group_image_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    description text,
    image_location text NOT NULL,
    image_name character varying(80),
    image_type_id integer NOT NULL,
    sample_group_id integer NOT NULL
);


ALTER TABLE public.tbl_sample_group_images OWNER TO sead_master;

--
-- Name: tbl_sample_group_notes; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_group_notes (
    sample_group_note_id integer NOT NULL,
    sample_group_id integer NOT NULL,
    note character varying,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_sample_group_notes OWNER TO sead_master;

--
-- Name: tbl_sample_group_references; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_group_references (
    sample_group_reference_id integer NOT NULL,
    biblio_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    sample_group_id integer DEFAULT 0
);


ALTER TABLE public.tbl_sample_group_references OWNER TO sead_master;

--
-- Name: tbl_sample_group_sampling_contexts; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_group_sampling_contexts (
    sampling_context_id integer NOT NULL,
    sampling_context character varying(60) NOT NULL,
    description text,
    sort_order smallint DEFAULT 0 NOT NULL,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_sample_group_sampling_contexts OWNER TO sead_master;

--
-- Name: TABLE tbl_sample_group_sampling_contexts; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_sample_group_sampling_contexts IS 'Type=lookup';


--
-- Name: COLUMN tbl_sample_group_sampling_contexts.sampling_context; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_sample_group_sampling_contexts.sampling_context IS 'short but meaningful name defining sample group context, e.g. stratigraphic sequence, archaeological excavation';


--
-- Name: COLUMN tbl_sample_group_sampling_contexts.description; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_sample_group_sampling_contexts.description IS 'full explanation of the grouping term';


--
-- Name: COLUMN tbl_sample_group_sampling_contexts.sort_order; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_sample_group_sampling_contexts.sort_order IS 'allows lists to group similar or associated group context close to each other, e.g. modern investigations together, palaeo investigations together';


--
-- Name: tbl_sample_groups; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_groups (
    sample_group_id integer NOT NULL,
    site_id integer DEFAULT 0,
    sampling_context_id integer,
    method_id integer NOT NULL,
    sample_group_name character varying(100) DEFAULT NULL::character varying,
    sample_group_description text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_sample_groups OWNER TO sead_master;

--
-- Name: COLUMN tbl_sample_groups.method_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_sample_groups.method_id IS 'sampling method, e.g. russian auger core, pitfall traps. note different from context in that it is specific to method of sample retrieval and not type of investigation.';


--
-- Name: COLUMN tbl_sample_groups.sample_group_name; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_sample_groups.sample_group_name IS 'Name which identifies the collection of samples. For ceramics, use vessel number.';


--
-- Name: tbl_sample_horizons; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_horizons (
    sample_horizon_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    horizon_id integer NOT NULL,
    physical_sample_id integer NOT NULL
);


ALTER TABLE public.tbl_sample_horizons OWNER TO sead_master;

--
-- Name: tbl_sample_images; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_images (
    sample_image_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    description text,
    image_location text NOT NULL,
    image_name character varying(80),
    image_type_id integer NOT NULL,
    physical_sample_id integer NOT NULL
);


ALTER TABLE public.tbl_sample_images OWNER TO sead_master;

--
-- Name: tbl_sample_location_type_sampling_contexts; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_location_type_sampling_contexts (
    sample_location_type_sampling_context_id integer NOT NULL,
    sampling_context_id integer NOT NULL,
    sample_location_type_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_sample_location_type_sampling_contexts OWNER TO sead_master;

--
-- Name: tbl_sample_location_types; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_location_types (
    sample_location_type_id integer NOT NULL,
    location_type character varying(255),
    location_type_description text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_sample_location_types OWNER TO sead_master;

--
-- Name: tbl_sample_locations; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_locations (
    sample_location_id integer NOT NULL,
    sample_location_type_id integer NOT NULL,
    physical_sample_id integer NOT NULL,
    location character varying(255),
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_sample_locations OWNER TO sead_master;

--
-- Name: tbl_sample_notes; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_notes (
    sample_note_id integer NOT NULL,
    physical_sample_id integer NOT NULL,
    note_type character varying,
    note text NOT NULL,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_sample_notes OWNER TO sead_master;

--
-- Name: COLUMN tbl_sample_notes.note_type; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_sample_notes.note_type IS 'origin of the note, e.g. field note, lab note';


--
-- Name: COLUMN tbl_sample_notes.note; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_sample_notes.note IS 'note contents';


--
-- Name: tbl_sample_types; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sample_types (
    sample_type_id integer NOT NULL,
    type_name character varying(40) NOT NULL,
    description text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_sample_types OWNER TO sead_master;

--
-- Name: tbl_season_or_qualifier; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_season_or_qualifier (
    season_or_qualifier_id integer NOT NULL,
    season_or_qualifier_type character varying(150) NOT NULL,
    description text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_season_or_qualifier OWNER TO sead_master;

--
-- Name: tbl_season_types; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_season_types (
    season_type_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    description text,
    season_type character varying(30)
);


ALTER TABLE public.tbl_season_types OWNER TO sead_master;

--
-- Name: tbl_seasons; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_seasons (
    season_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    season_name character varying(20) DEFAULT NULL::character varying,
    season_type character varying(30) DEFAULT NULL::character varying,
    season_type_id integer,
    sort_order smallint DEFAULT 0
);


ALTER TABLE public.tbl_seasons OWNER TO sead_master;

--
-- Name: tbl_site_images; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_site_images (
    site_image_id integer NOT NULL,
    contact_id integer,
    credit character varying(100),
    date_taken date,
    date_updated timestamp with time zone DEFAULT now(),
    description text,
    image_location text NOT NULL,
    image_name character varying(80),
    image_type_id integer NOT NULL,
    site_id integer NOT NULL
);


ALTER TABLE public.tbl_site_images OWNER TO sead_master;

--
-- Name: tbl_site_locations; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_site_locations (
    site_location_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    location_id integer NOT NULL,
    site_id integer NOT NULL
);


ALTER TABLE public.tbl_site_locations OWNER TO sead_master;

--
-- Name: tbl_site_natgridrefs; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_site_natgridrefs (
    site_natgridref_id integer NOT NULL,
    site_id integer NOT NULL,
    method_id integer NOT NULL,
    natgridref character varying NOT NULL,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_site_natgridrefs OWNER TO sead_master;

--
-- Name: TABLE tbl_site_natgridrefs; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_site_natgridrefs IS '20120507pib: removed tbl_national_grids and trasfered storage of coordinate systems to tbl_methods';


--
-- Name: COLUMN tbl_site_natgridrefs.method_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_site_natgridrefs.method_id IS 'points to coordinate system.';


--
-- Name: tbl_site_other_records; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_site_other_records (
    site_other_records_id integer NOT NULL,
    site_id integer,
    biblio_id integer,
    record_type_id integer,
    description text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_site_other_records OWNER TO sead_master;

--
-- Name: COLUMN tbl_site_other_records.biblio_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_site_other_records.biblio_id IS 'reference to publication containing data';


--
-- Name: COLUMN tbl_site_other_records.record_type_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_site_other_records.record_type_id IS 'reference to type of data (proxy)';


--
-- Name: tbl_site_preservation_status; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_site_preservation_status (
    site_preservation_status_id integer NOT NULL,
    site_id integer,
    preservation_status_or_threat character varying,
    description text,
    assessment_type character varying,
    assessment_author_contact_id integer,
    date_updated timestamp with time zone DEFAULT now(),
    "Evaluation_date" date
);


ALTER TABLE public.tbl_site_preservation_status OWNER TO sead_master;

--
-- Name: COLUMN tbl_site_preservation_status.site_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_site_preservation_status.site_id IS 'allows multiple preservation/threat records per site';


--
-- Name: COLUMN tbl_site_preservation_status.preservation_status_or_threat; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_site_preservation_status.preservation_status_or_threat IS 'descriptive name for:
preservation status, e.g. (e.g. lost, damaged, threatened) or
main reason for potential or real risk to site (e.g. hydroelectric, oil exploitation, mining, forestry, climate change, erosion)';


--
-- Name: COLUMN tbl_site_preservation_status.description; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_site_preservation_status.description IS 'brief description of site preservation status or threat to site preservation. include data here that does not fit in the other fields (for now - we may expand these features later if demand exists)';


--
-- Name: COLUMN tbl_site_preservation_status.assessment_type; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_site_preservation_status.assessment_type IS 'type of assessment giving information on preservation status and threat, e.g. unesco report, archaeological survey';


--
-- Name: COLUMN tbl_site_preservation_status.assessment_author_contact_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_site_preservation_status.assessment_author_contact_id IS 'person or authority in tbl_contacts responsible for the assessment of preservation status and threat';


--
-- Name: COLUMN tbl_site_preservation_status."Evaluation_date"; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_site_preservation_status."Evaluation_date" IS 'Date of assessment, either formal or informal';


--
-- Name: tbl_site_references; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_site_references (
    site_reference_id integer NOT NULL,
    site_id integer DEFAULT 0,
    biblio_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_site_references OWNER TO sead_master;

--
-- Name: tbl_sites; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_sites (
    site_id integer NOT NULL,
    altitude numeric(18,10),
    latitude_dd numeric(18,10),
    longitude_dd numeric(18,10),
    national_site_identifier character varying(255),
    site_description text DEFAULT NULL::character varying,
    site_name character varying(60) DEFAULT NULL::character varying,
    site_preservation_status_id integer,
    date_updated timestamp with time zone DEFAULT now(),
    site_location_accuracy character varying
);


ALTER TABLE public.tbl_sites OWNER TO sead_master;

--
-- Name: COLUMN tbl_sites.site_location_accuracy; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_sites.site_location_accuracy IS 'Accuracy of highest location resolution level. E.g. Nearest settlement, lake, bog, ancient monument, approximate';


--
-- Name: tbl_species_association_types; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_species_association_types (
    association_type_id integer NOT NULL,
    association_type_name character varying(255),
    association_description text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_species_association_types OWNER TO sead_master;

--
-- Name: tbl_species_associations; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_species_associations (
    species_association_id integer NOT NULL,
    associated_taxon_id integer NOT NULL,
    biblio_id integer,
    date_updated timestamp with time zone DEFAULT now(),
    taxon_id integer NOT NULL,
    association_type_id integer,
    referencing_type text
);


ALTER TABLE public.tbl_species_associations OWNER TO sead_master;

--
-- Name: COLUMN tbl_species_associations.associated_taxon_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_species_associations.associated_taxon_id IS 'Taxon with which the primary taxon (taxon_id) is associated. ';


--
-- Name: COLUMN tbl_species_associations.biblio_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_species_associations.biblio_id IS 'Reference where relationship between taxa is described or mentioned';


--
-- Name: COLUMN tbl_species_associations.taxon_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_species_associations.taxon_id IS 'Primary taxon in relationship, i.e. this taxon has x relationship with the associated taxon';


--
-- Name: COLUMN tbl_species_associations.association_type_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_species_associations.association_type_id IS 'Type of association between primary taxon (taxon_id) and associated taxon. Note that the direction of the association is important in most cases (e.g. x predates on y)';


--
-- Name: tbl_taxa_common_names; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_taxa_common_names (
    taxon_common_name_id integer NOT NULL,
    common_name character varying(255) DEFAULT NULL::character varying,
    date_updated timestamp with time zone DEFAULT now(),
    language_id integer DEFAULT 0,
    taxon_id integer DEFAULT 0
);


ALTER TABLE public.tbl_taxa_common_names OWNER TO sead_master;

--
-- Name: tbl_taxa_images; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_taxa_images (
    taxa_images_id integer NOT NULL,
    image_name character varying,
    description text,
    image_location text,
    image_type_id integer,
    taxon_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_taxa_images OWNER TO sead_master;

--
-- Name: TABLE tbl_taxa_images; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_taxa_images IS '20140226EE: changed the data type for date_updated';


--
-- Name: tbl_taxa_measured_attributes; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_taxa_measured_attributes (
    measured_attribute_id integer NOT NULL,
    attribute_measure character varying(20) DEFAULT NULL::character varying,
    attribute_type character varying(25) DEFAULT NULL::character varying,
    attribute_units character varying(10) DEFAULT NULL::character varying,
    data numeric(18,10) DEFAULT 0,
    date_updated timestamp with time zone DEFAULT now(),
    taxon_id integer NOT NULL
);


ALTER TABLE public.tbl_taxa_measured_attributes OWNER TO sead_master;

--
-- Name: tbl_taxa_reference_specimens; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_taxa_reference_specimens (
    taxa_reference_specimen_id integer NOT NULL,
    taxon_id integer NOT NULL,
    contact_id integer NOT NULL,
    notes text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_taxa_reference_specimens OWNER TO sead_master;

--
-- Name: TABLE tbl_taxa_reference_specimens; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_taxa_reference_specimens IS '20140226EE: changed date_updated to correct data type';


--
-- Name: tbl_taxa_seasonality; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_taxa_seasonality (
    seasonality_id integer NOT NULL,
    activity_type_id integer NOT NULL,
    season_id integer DEFAULT 0,
    taxon_id integer NOT NULL,
    location_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_taxa_seasonality OWNER TO sead_master;

--
-- Name: COLUMN tbl_taxa_seasonality.location_id; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_taxa_seasonality.location_id IS 'geographical relevance of seasonality data';


--
-- Name: tbl_taxa_synonyms; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_taxa_synonyms (
    synonym_id integer NOT NULL,
    biblio_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    family_id integer,
    genus_id integer,
    notes text DEFAULT NULL::character varying,
    taxon_id integer,
    author_id integer,
    synonym character varying(255),
    reference_type character varying
);


ALTER TABLE public.tbl_taxa_synonyms OWNER TO sead_master;

--
-- Name: COLUMN tbl_taxa_synonyms.notes; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_taxa_synonyms.notes IS 'Any information useful to the history or usage of the synonym.';


--
-- Name: COLUMN tbl_taxa_synonyms.synonym; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_taxa_synonyms.synonym IS 'Synonym at level defined by id level. I.e. if synonym is at genus level, then only the genus synonym is included here. Another synonym record is used for the species level synonym for the same taxon only if the name is different to that used in the master list.';


--
-- Name: COLUMN tbl_taxa_synonyms.reference_type; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON COLUMN public.tbl_taxa_synonyms.reference_type IS 'Form of information relating to the synonym in the given bibliographic link, e.g. by use, definition, incorrect usage.';


--
-- Name: tbl_taxa_tree_authors; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_taxa_tree_authors (
    author_id integer NOT NULL,
    author_name character varying(100) DEFAULT NULL::character varying,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_taxa_tree_authors OWNER TO sead_master;

--
-- Name: tbl_taxa_tree_families; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_taxa_tree_families (
    family_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    family_name character varying(100) DEFAULT NULL::character varying,
    order_id integer NOT NULL
);


ALTER TABLE public.tbl_taxa_tree_families OWNER TO sead_master;

--
-- Name: tbl_taxa_tree_orders; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_taxa_tree_orders (
    order_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    order_name character varying(50) DEFAULT NULL::character varying,
    record_type_id integer,
    sort_order integer
);


ALTER TABLE public.tbl_taxa_tree_orders OWNER TO sead_master;

--
-- Name: tbl_taxonomic_order; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_taxonomic_order (
    taxonomic_order_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    taxon_id integer DEFAULT 0,
    taxonomic_code numeric(18,10) DEFAULT 0,
    taxonomic_order_system_id integer DEFAULT 0
);


ALTER TABLE public.tbl_taxonomic_order OWNER TO sead_master;

--
-- Name: tbl_taxonomic_order_biblio; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_taxonomic_order_biblio (
    taxonomic_order_biblio_id integer NOT NULL,
    biblio_id integer DEFAULT 0,
    date_updated timestamp with time zone DEFAULT now(),
    taxonomic_order_system_id integer DEFAULT 0
);


ALTER TABLE public.tbl_taxonomic_order_biblio OWNER TO sead_master;

--
-- Name: tbl_taxonomic_order_systems; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_taxonomic_order_systems (
    taxonomic_order_system_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    system_description text,
    system_name character varying(50) DEFAULT NULL::character varying
);


ALTER TABLE public.tbl_taxonomic_order_systems OWNER TO sead_master;

--
-- Name: tbl_taxonomy_notes; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_taxonomy_notes (
    taxonomy_notes_id integer NOT NULL,
    biblio_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    taxon_id integer NOT NULL,
    taxonomy_notes text
);


ALTER TABLE public.tbl_taxonomy_notes OWNER TO sead_master;

--
-- Name: tbl_tephra_dates; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_tephra_dates (
    tephra_date_id integer NOT NULL,
    analysis_entity_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    notes text,
    tephra_id integer NOT NULL,
    dating_uncertainty_id integer
);


ALTER TABLE public.tbl_tephra_dates OWNER TO sead_master;

--
-- Name: TABLE tbl_tephra_dates; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON TABLE public.tbl_tephra_dates IS '20130722PIB: Added field dating_uncertainty_id to cater for >< etc.';


--
-- Name: tbl_tephra_refs; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_tephra_refs (
    tephra_ref_id integer NOT NULL,
    biblio_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    tephra_id integer NOT NULL
);


ALTER TABLE public.tbl_tephra_refs OWNER TO sead_master;

--
-- Name: tbl_tephras; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_tephras (
    tephra_id integer NOT NULL,
    c14_age numeric(20,5),
    c14_age_older numeric(20,5),
    c14_age_younger numeric(20,5),
    cal_age numeric(20,5),
    cal_age_older numeric(20,5),
    cal_age_younger numeric(20,5),
    date_updated timestamp with time zone DEFAULT now(),
    notes text,
    tephra_name character varying(80)
);


ALTER TABLE public.tbl_tephras OWNER TO sead_master;

--
-- Name: tbl_text_biology; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_text_biology (
    biology_id integer NOT NULL,
    biblio_id integer NOT NULL,
    biology_text text,
    date_updated timestamp with time zone DEFAULT now(),
    taxon_id integer NOT NULL
);


ALTER TABLE public.tbl_text_biology OWNER TO sead_master;

--
-- Name: tbl_text_distribution; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_text_distribution (
    distribution_id integer NOT NULL,
    biblio_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    distribution_text text,
    taxon_id integer NOT NULL
);


ALTER TABLE public.tbl_text_distribution OWNER TO sead_master;

--
-- Name: tbl_text_identification_keys; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_text_identification_keys (
    key_id integer NOT NULL,
    biblio_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    key_text text,
    taxon_id integer NOT NULL
);


ALTER TABLE public.tbl_text_identification_keys OWNER TO sead_master;

--
-- Name: tbl_units; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_units (
    unit_id integer NOT NULL,
    date_updated timestamp with time zone DEFAULT now(),
    description text,
    unit_abbrev character varying(15),
    unit_name character varying(50) NOT NULL
);


ALTER TABLE public.tbl_units OWNER TO sead_master;

--
-- Name: tbl_updates_log; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_updates_log (
    updates_log_id integer NOT NULL,
    table_name character varying(150) NOT NULL,
    last_updated date NOT NULL
);


ALTER TABLE public.tbl_updates_log OWNER TO sead_master;

--
-- Name: tbl_years_types; Type: TABLE; Schema: public; Owner: sead_master
--

CREATE TABLE public.tbl_years_types (
    years_type_id integer NOT NULL,
    name character varying NOT NULL,
    description text,
    date_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tbl_years_types OWNER TO sead_master;

--
-- Name: tbl_biblio_original; Type: TABLE; Schema: public; Owner: clearinghouse_worker
--

CREATE TABLE public.tbl_biblio_original (
    biblio_id integer,
    author character varying,
    biblio_keyword_id integer,
    bugs_author character varying(255),
    bugs_biblio_id integer,
    bugs_reference character varying(60),
    bugs_title character varying,
    collection_or_journal_id integer,
    date_updated timestamp with time zone,
    doi character varying(255),
    edition character varying(128),
    isbn character varying(128),
    keywords character varying,
    notes text,
    number character varying(128),
    pages character varying(50),
    pdf_link character varying,
    publication_type_id integer,
    publisher_id integer,
    title character varying,
    volume character varying(128),
    year character varying(255),
    authors character varying,
    full_reference text,
    url character varying
);


ALTER TABLE public.tbl_biblio_original OWNER TO clearinghouse_worker;

--
-- Name: columns; Type: TABLE; Schema: public; Owner: humlab_admin
--

CREATE TABLE public.columns (
    array_agg character varying[]
);


ALTER TABLE public.columns OWNER TO humlab_admin;

--
-- Name: tbl_abundance_elements_abundance_element_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_abundance_elements_abundance_element_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_abundance_elements_abundance_element_id_seq OWNER TO sead_master;

--
-- Name: tbl_abundance_elements_abundance_element_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_abundance_elements_abundance_element_id_seq OWNED BY public.tbl_abundance_elements.abundance_element_id;


--
-- Name: tbl_abundance_ident_levels_abundance_ident_level_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_abundance_ident_levels_abundance_ident_level_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_abundance_ident_levels_abundance_ident_level_id_seq OWNER TO sead_master;

--
-- Name: tbl_abundance_ident_levels_abundance_ident_level_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_abundance_ident_levels_abundance_ident_level_id_seq OWNED BY public.tbl_abundance_ident_levels.abundance_ident_level_id;


--
-- Name: tbl_abundance_modifications_abundance_modification_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_abundance_modifications_abundance_modification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_abundance_modifications_abundance_modification_id_seq OWNER TO sead_master;

--
-- Name: tbl_abundance_modifications_abundance_modification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_abundance_modifications_abundance_modification_id_seq OWNED BY public.tbl_abundance_modifications.abundance_modification_id;


--
-- Name: tbl_abundances_abundance_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_abundances_abundance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_abundances_abundance_id_seq OWNER TO sead_master;

--
-- Name: tbl_abundances_abundance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_abundances_abundance_id_seq OWNED BY public.tbl_abundances.abundance_id;


--
-- Name: tbl_activity_types_activity_type_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_activity_types_activity_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_activity_types_activity_type_id_seq OWNER TO sead_master;

--
-- Name: tbl_activity_types_activity_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_activity_types_activity_type_id_seq OWNED BY public.tbl_activity_types.activity_type_id;


--
-- Name: tbl_age_types_age_type_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_age_types_age_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_age_types_age_type_id_seq OWNER TO sead_master;

--
-- Name: tbl_age_types_age_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_age_types_age_type_id_seq OWNED BY public.tbl_age_types.age_type_id;


--
-- Name: tbl_aggregate_datasets_aggregate_dataset_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_aggregate_datasets_aggregate_dataset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_aggregate_datasets_aggregate_dataset_id_seq OWNER TO sead_master;

--
-- Name: tbl_aggregate_datasets_aggregate_dataset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_aggregate_datasets_aggregate_dataset_id_seq OWNED BY public.tbl_aggregate_datasets.aggregate_dataset_id;


--
-- Name: tbl_aggregate_order_types_aggregate_order_type_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_aggregate_order_types_aggregate_order_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_aggregate_order_types_aggregate_order_type_id_seq OWNER TO sead_master;

--
-- Name: tbl_aggregate_order_types_aggregate_order_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_aggregate_order_types_aggregate_order_type_id_seq OWNED BY public.tbl_aggregate_order_types.aggregate_order_type_id;


--
-- Name: tbl_aggregate_sample_ages_aggregate_sample_age_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_aggregate_sample_ages_aggregate_sample_age_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_aggregate_sample_ages_aggregate_sample_age_id_seq OWNER TO sead_master;

--
-- Name: tbl_aggregate_sample_ages_aggregate_sample_age_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_aggregate_sample_ages_aggregate_sample_age_id_seq OWNED BY public.tbl_aggregate_sample_ages.aggregate_sample_age_id;


--
-- Name: tbl_aggregate_samples_aggregate_sample_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_aggregate_samples_aggregate_sample_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_aggregate_samples_aggregate_sample_id_seq OWNER TO sead_master;

--
-- Name: tbl_aggregate_samples_aggregate_sample_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_aggregate_samples_aggregate_sample_id_seq OWNED BY public.tbl_aggregate_samples.aggregate_sample_id;


--
-- Name: tbl_alt_ref_types_alt_ref_type_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_alt_ref_types_alt_ref_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_alt_ref_types_alt_ref_type_id_seq OWNER TO sead_master;

--
-- Name: tbl_alt_ref_types_alt_ref_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_alt_ref_types_alt_ref_type_id_seq OWNED BY public.tbl_alt_ref_types.alt_ref_type_id;


--
-- Name: tbl_analysis_entities_analysis_entity_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_analysis_entities_analysis_entity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_analysis_entities_analysis_entity_id_seq OWNER TO sead_master;

--
-- Name: tbl_analysis_entities_analysis_entity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_analysis_entities_analysis_entity_id_seq OWNED BY public.tbl_analysis_entities.analysis_entity_id;


--
-- Name: tbl_analysis_entity_ages_analysis_entity_age_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_analysis_entity_ages_analysis_entity_age_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_analysis_entity_ages_analysis_entity_age_id_seq OWNER TO sead_master;

--
-- Name: tbl_analysis_entity_ages_analysis_entity_age_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_analysis_entity_ages_analysis_entity_age_id_seq OWNED BY public.tbl_analysis_entity_ages.analysis_entity_age_id;


--
-- Name: tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq OWNER TO sead_master;

--
-- Name: tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq OWNED BY public.tbl_analysis_entity_dimensions.analysis_entity_dimension_id;


--
-- Name: tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq OWNER TO sead_master;

--
-- Name: tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq OWNED BY public.tbl_analysis_entity_prep_methods.analysis_entity_prep_method_id;


--
-- Name: tbl_association_types_association_type_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_association_types_association_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_association_types_association_type_id_seq OWNER TO sead_master;

--
-- Name: tbl_association_types_association_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_association_types_association_type_id_seq OWNED BY public.tbl_species_association_types.association_type_id;


--
-- Name: tbl_biblio_biblio_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_biblio_biblio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_biblio_biblio_id_seq OWNER TO sead_master;

--
-- Name: tbl_biblio_biblio_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_biblio_biblio_id_seq OWNED BY public.tbl_biblio.biblio_id;


--
-- Name: tbl_ceramics_ceramics_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_ceramics_ceramics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_ceramics_ceramics_id_seq OWNER TO sead_master;

--
-- Name: tbl_ceramics_ceramics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_ceramics_ceramics_id_seq OWNED BY public.tbl_ceramics.ceramics_id;


--
-- Name: tbl_ceramics_lookup_ceramics_lookup_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_ceramics_lookup_ceramics_lookup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_ceramics_lookup_ceramics_lookup_id_seq OWNER TO sead_master;

--
-- Name: tbl_ceramics_lookup_ceramics_lookup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_ceramics_lookup_ceramics_lookup_id_seq OWNED BY public.tbl_ceramics_lookup.ceramics_lookup_id;


--
-- Name: tbl_ceramics_measurements_ceramics_measurement_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_ceramics_measurements_ceramics_measurement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_ceramics_measurements_ceramics_measurement_id_seq OWNER TO sead_master;

--
-- Name: tbl_ceramics_measurements_ceramics_measurement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_ceramics_measurements_ceramics_measurement_id_seq OWNED BY public.tbl_ceramics_measurements.ceramics_measurement_id;


--
-- Name: tbl_chron_control_types_chron_control_type_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_chron_control_types_chron_control_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_chron_control_types_chron_control_type_id_seq OWNER TO sead_master;

--
-- Name: tbl_chron_control_types_chron_control_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_chron_control_types_chron_control_type_id_seq OWNED BY public.tbl_chron_control_types.chron_control_type_id;


--
-- Name: tbl_chron_controls_chron_control_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_chron_controls_chron_control_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_chron_controls_chron_control_id_seq OWNER TO sead_master;

--
-- Name: tbl_chron_controls_chron_control_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_chron_controls_chron_control_id_seq OWNED BY public.tbl_chron_controls.chron_control_id;


--
-- Name: tbl_chronologies_chronology_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_chronologies_chronology_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_chronologies_chronology_id_seq OWNER TO sead_master;

--
-- Name: tbl_chronologies_chronology_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_chronologies_chronology_id_seq OWNED BY public.tbl_chronologies.chronology_id;


--
-- Name: tbl_colours_colour_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_colours_colour_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_colours_colour_id_seq OWNER TO sead_master;

--
-- Name: tbl_colours_colour_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_colours_colour_id_seq OWNED BY public.tbl_colours.colour_id;


--
-- Name: tbl_contact_types_contact_type_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_contact_types_contact_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_contact_types_contact_type_id_seq OWNER TO sead_master;

--
-- Name: tbl_contact_types_contact_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_contact_types_contact_type_id_seq OWNED BY public.tbl_contact_types.contact_type_id;


--
-- Name: tbl_contacts_contact_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_contacts_contact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_contacts_contact_id_seq OWNER TO sead_master;

--
-- Name: tbl_contacts_contact_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_contacts_contact_id_seq OWNED BY public.tbl_contacts.contact_id;


--
-- Name: tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq OWNER TO sead_master;

--
-- Name: tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq OWNED BY public.tbl_coordinate_method_dimensions.coordinate_method_dimension_id;


--
-- Name: tbl_data_type_groups_data_type_group_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_data_type_groups_data_type_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_data_type_groups_data_type_group_id_seq OWNER TO sead_master;

--
-- Name: tbl_data_type_groups_data_type_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_data_type_groups_data_type_group_id_seq OWNED BY public.tbl_data_type_groups.data_type_group_id;


--
-- Name: tbl_data_types_data_type_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_data_types_data_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_data_types_data_type_id_seq OWNER TO sead_master;

--
-- Name: tbl_data_types_data_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_data_types_data_type_id_seq OWNED BY public.tbl_data_types.data_type_id;


--
-- Name: tbl_dataset_contacts_dataset_contact_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_dataset_contacts_dataset_contact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_dataset_contacts_dataset_contact_id_seq OWNER TO sead_master;

--
-- Name: tbl_dataset_contacts_dataset_contact_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_dataset_contacts_dataset_contact_id_seq OWNED BY public.tbl_dataset_contacts.dataset_contact_id;


--
-- Name: tbl_dataset_masters_master_set_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_dataset_masters_master_set_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_dataset_masters_master_set_id_seq OWNER TO sead_master;

--
-- Name: tbl_dataset_masters_master_set_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_dataset_masters_master_set_id_seq OWNED BY public.tbl_dataset_masters.master_set_id;


--
-- Name: tbl_dataset_submission_types_submission_type_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_dataset_submission_types_submission_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_dataset_submission_types_submission_type_id_seq OWNER TO sead_master;

--
-- Name: tbl_dataset_submission_types_submission_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_dataset_submission_types_submission_type_id_seq OWNED BY public.tbl_dataset_submission_types.submission_type_id;


--
-- Name: tbl_dataset_submissions_dataset_submission_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_dataset_submissions_dataset_submission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_dataset_submissions_dataset_submission_id_seq OWNER TO sead_master;

--
-- Name: tbl_dataset_submissions_dataset_submission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_dataset_submissions_dataset_submission_id_seq OWNED BY public.tbl_dataset_submissions.dataset_submission_id;


--
-- Name: tbl_datasets_dataset_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_datasets_dataset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_datasets_dataset_id_seq OWNER TO sead_master;

--
-- Name: tbl_datasets_dataset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_datasets_dataset_id_seq OWNED BY public.tbl_datasets.dataset_id;


--
-- Name: tbl_dating_labs_dating_lab_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_dating_labs_dating_lab_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_dating_labs_dating_lab_id_seq OWNER TO sead_master;

--
-- Name: tbl_dating_labs_dating_lab_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_dating_labs_dating_lab_id_seq OWNED BY public.tbl_dating_labs.dating_lab_id;


--
-- Name: tbl_dating_material_dating_material_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_dating_material_dating_material_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_dating_material_dating_material_id_seq OWNER TO sead_master;

--
-- Name: tbl_dating_material_dating_material_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_dating_material_dating_material_id_seq OWNED BY public.tbl_dating_material.dating_material_id;


--
-- Name: tbl_dating_uncertainty_dating_uncertainty_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_dating_uncertainty_dating_uncertainty_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_dating_uncertainty_dating_uncertainty_id_seq OWNER TO sead_master;

--
-- Name: tbl_dating_uncertainty_dating_uncertainty_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_dating_uncertainty_dating_uncertainty_id_seq OWNED BY public.tbl_dating_uncertainty.dating_uncertainty_id;


--
-- Name: tbl_dendro_date_notes_dendro_date_note_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_dendro_date_notes_dendro_date_note_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_dendro_date_notes_dendro_date_note_id_seq OWNER TO sead_master;

--
-- Name: tbl_dendro_date_notes_dendro_date_note_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_dendro_date_notes_dendro_date_note_id_seq OWNED BY public.tbl_dendro_date_notes.dendro_date_note_id;


--
-- Name: tbl_dendro_dates_dendro_date_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_dendro_dates_dendro_date_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_dendro_dates_dendro_date_id_seq OWNER TO sead_master;

--
-- Name: tbl_dendro_dates_dendro_date_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_dendro_dates_dendro_date_id_seq OWNED BY public.tbl_dendro_dates.dendro_date_id;


--
-- Name: tbl_dendro_dendro_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_dendro_dendro_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_dendro_dendro_id_seq OWNER TO sead_master;

--
-- Name: tbl_dendro_dendro_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_dendro_dendro_id_seq OWNED BY public.tbl_dendro.dendro_id;


--
-- Name: tbl_dendro_lookup_dendro_lookup_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_dendro_lookup_dendro_lookup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_dendro_lookup_dendro_lookup_id_seq OWNER TO sead_master;

--
-- Name: tbl_dendro_lookup_dendro_lookup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_dendro_lookup_dendro_lookup_id_seq OWNED BY public.tbl_dendro_lookup.dendro_lookup_id;


--
-- Name: tbl_dendro_measurements_dendro_measurement_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_dendro_measurements_dendro_measurement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_dendro_measurements_dendro_measurement_id_seq OWNER TO sead_master;

--
-- Name: tbl_dendro_measurements_dendro_measurement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_dendro_measurements_dendro_measurement_id_seq OWNED BY public.tbl_dendro_measurements.dendro_measurement_id;


--
-- Name: tbl_dimensions_dimension_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_dimensions_dimension_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_dimensions_dimension_id_seq OWNER TO sead_master;

--
-- Name: tbl_dimensions_dimension_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_dimensions_dimension_id_seq OWNED BY public.tbl_dimensions.dimension_id;


--
-- Name: tbl_ecocode_definitions_ecocode_definition_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_ecocode_definitions_ecocode_definition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_ecocode_definitions_ecocode_definition_id_seq OWNER TO sead_master;

--
-- Name: tbl_ecocode_definitions_ecocode_definition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_ecocode_definitions_ecocode_definition_id_seq OWNED BY public.tbl_ecocode_definitions.ecocode_definition_id;


--
-- Name: tbl_ecocode_groups_ecocode_group_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_ecocode_groups_ecocode_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_ecocode_groups_ecocode_group_id_seq OWNER TO sead_master;

--
-- Name: tbl_ecocode_groups_ecocode_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_ecocode_groups_ecocode_group_id_seq OWNED BY public.tbl_ecocode_groups.ecocode_group_id;


--
-- Name: tbl_ecocode_systems_ecocode_system_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_ecocode_systems_ecocode_system_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_ecocode_systems_ecocode_system_id_seq OWNER TO sead_master;

--
-- Name: tbl_ecocode_systems_ecocode_system_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_ecocode_systems_ecocode_system_id_seq OWNED BY public.tbl_ecocode_systems.ecocode_system_id;


--
-- Name: tbl_ecocodes_ecocode_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_ecocodes_ecocode_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_ecocodes_ecocode_id_seq OWNER TO sead_master;

--
-- Name: tbl_ecocodes_ecocode_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_ecocodes_ecocode_id_seq OWNED BY public.tbl_ecocodes.ecocode_id;


--
-- Name: tbl_error_uncertainties_error_uncertainty_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_error_uncertainties_error_uncertainty_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_error_uncertainties_error_uncertainty_id_seq OWNER TO sead_master;

--
-- Name: tbl_error_uncertainties_error_uncertainty_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_error_uncertainties_error_uncertainty_id_seq OWNED BY public.tbl_error_uncertainties.error_uncertainty_id;


--
-- Name: tbl_feature_types_feature_type_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_feature_types_feature_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_feature_types_feature_type_id_seq OWNER TO sead_master;

--
-- Name: tbl_feature_types_feature_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_feature_types_feature_type_id_seq OWNED BY public.tbl_feature_types.feature_type_id;


--
-- Name: tbl_features_feature_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_features_feature_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_features_feature_id_seq OWNER TO sead_master;

--
-- Name: tbl_features_feature_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_features_feature_id_seq OWNED BY public.tbl_features.feature_id;


--
-- Name: tbl_geochron_refs_geochron_ref_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_geochron_refs_geochron_ref_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_geochron_refs_geochron_ref_id_seq OWNER TO sead_master;

--
-- Name: tbl_geochron_refs_geochron_ref_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_geochron_refs_geochron_ref_id_seq OWNED BY public.tbl_geochron_refs.geochron_ref_id;


--
-- Name: tbl_geochronology_geochron_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_geochronology_geochron_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_geochronology_geochron_id_seq OWNER TO sead_master;

--
-- Name: tbl_geochronology_geochron_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_geochronology_geochron_id_seq OWNED BY public.tbl_geochronology.geochron_id;


--
-- Name: tbl_horizons_horizon_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_horizons_horizon_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_horizons_horizon_id_seq OWNER TO sead_master;

--
-- Name: tbl_horizons_horizon_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_horizons_horizon_id_seq OWNED BY public.tbl_horizons.horizon_id;


--
-- Name: tbl_identification_levels_identification_level_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_identification_levels_identification_level_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_identification_levels_identification_level_id_seq OWNER TO sead_master;

--
-- Name: tbl_identification_levels_identification_level_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_identification_levels_identification_level_id_seq OWNED BY public.tbl_identification_levels.identification_level_id;


--
-- Name: tbl_image_types_image_type_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_image_types_image_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_image_types_image_type_id_seq OWNER TO sead_master;

--
-- Name: tbl_image_types_image_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_image_types_image_type_id_seq OWNED BY public.tbl_image_types.image_type_id;


--
-- Name: tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq OWNER TO sead_master;

--
-- Name: tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq OWNED BY public.tbl_imported_taxa_replacements.imported_taxa_replacement_id;


--
-- Name: tbl_languages_language_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_languages_language_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_languages_language_id_seq OWNER TO sead_master;

--
-- Name: tbl_languages_language_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_languages_language_id_seq OWNED BY public.tbl_languages.language_id;


--
-- Name: tbl_lithology_lithology_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_lithology_lithology_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_lithology_lithology_id_seq OWNER TO sead_master;

--
-- Name: tbl_lithology_lithology_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_lithology_lithology_id_seq OWNED BY public.tbl_lithology.lithology_id;


--
-- Name: tbl_location_types_location_type_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_location_types_location_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_location_types_location_type_id_seq OWNER TO sead_master;

--
-- Name: tbl_location_types_location_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_location_types_location_type_id_seq OWNED BY public.tbl_location_types.location_type_id;


--
-- Name: tbl_locations_location_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_locations_location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_locations_location_id_seq OWNER TO sead_master;

--
-- Name: tbl_locations_location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_locations_location_id_seq OWNED BY public.tbl_locations.location_id;


--
-- Name: tbl_mcr_names_taxon_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_mcr_names_taxon_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_mcr_names_taxon_id_seq OWNER TO sead_master;

--
-- Name: tbl_mcr_names_taxon_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_mcr_names_taxon_id_seq OWNED BY public.tbl_mcr_names.taxon_id;


--
-- Name: tbl_mcr_summary_data_mcr_summary_data_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_mcr_summary_data_mcr_summary_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_mcr_summary_data_mcr_summary_data_id_seq OWNER TO sead_master;

--
-- Name: tbl_mcr_summary_data_mcr_summary_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_mcr_summary_data_mcr_summary_data_id_seq OWNED BY public.tbl_mcr_summary_data.mcr_summary_data_id;


--
-- Name: tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq OWNER TO sead_master;

--
-- Name: tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq OWNED BY public.tbl_mcrdata_birmbeetledat.mcrdata_birmbeetledat_id;


--
-- Name: tbl_measured_value_dimensions_measured_value_dimension_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_measured_value_dimensions_measured_value_dimension_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_measured_value_dimensions_measured_value_dimension_id_seq OWNER TO sead_master;

--
-- Name: tbl_measured_value_dimensions_measured_value_dimension_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_measured_value_dimensions_measured_value_dimension_id_seq OWNED BY public.tbl_measured_value_dimensions.measured_value_dimension_id;


--
-- Name: tbl_measured_values_measured_value_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_measured_values_measured_value_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_measured_values_measured_value_id_seq OWNER TO sead_master;

--
-- Name: tbl_measured_values_measured_value_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_measured_values_measured_value_id_seq OWNED BY public.tbl_measured_values.measured_value_id;


--
-- Name: tbl_method_groups_method_group_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_method_groups_method_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_method_groups_method_group_id_seq OWNER TO sead_master;

--
-- Name: tbl_method_groups_method_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_method_groups_method_group_id_seq OWNED BY public.tbl_method_groups.method_group_id;


--
-- Name: tbl_methods_method_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_methods_method_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_methods_method_id_seq OWNER TO sead_master;

--
-- Name: tbl_methods_method_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_methods_method_id_seq OWNED BY public.tbl_methods.method_id;


--
-- Name: tbl_modification_types_modification_type_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_modification_types_modification_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_modification_types_modification_type_id_seq OWNER TO sead_master;

--
-- Name: tbl_modification_types_modification_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_modification_types_modification_type_id_seq OWNED BY public.tbl_modification_types.modification_type_id;


--
-- Name: tbl_physical_sample_features_physical_sample_feature_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_physical_sample_features_physical_sample_feature_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_physical_sample_features_physical_sample_feature_id_seq OWNER TO sead_master;

--
-- Name: tbl_physical_sample_features_physical_sample_feature_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_physical_sample_features_physical_sample_feature_id_seq OWNED BY public.tbl_physical_sample_features.physical_sample_feature_id;


--
-- Name: tbl_physical_samples_physical_sample_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_physical_samples_physical_sample_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_physical_samples_physical_sample_id_seq OWNER TO sead_master;

--
-- Name: tbl_physical_samples_physical_sample_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_physical_samples_physical_sample_id_seq OWNED BY public.tbl_physical_samples.physical_sample_id;


--
-- Name: tbl_project_stage_project_stage_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_project_stage_project_stage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_project_stage_project_stage_id_seq OWNER TO sead_master;

--
-- Name: tbl_project_stage_project_stage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_project_stage_project_stage_id_seq OWNED BY public.tbl_project_stages.project_stage_id;


--
-- Name: tbl_project_types_project_type_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_project_types_project_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_project_types_project_type_id_seq OWNER TO sead_master;

--
-- Name: tbl_project_types_project_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_project_types_project_type_id_seq OWNED BY public.tbl_project_types.project_type_id;


--
-- Name: tbl_projects_project_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_projects_project_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_projects_project_id_seq OWNER TO sead_master;

--
-- Name: tbl_projects_project_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_projects_project_id_seq OWNED BY public.tbl_projects.project_id;


--
-- Name: tbl_rdb_codes_rdb_code_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_rdb_codes_rdb_code_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_rdb_codes_rdb_code_id_seq OWNER TO sead_master;

--
-- Name: tbl_rdb_codes_rdb_code_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_rdb_codes_rdb_code_id_seq OWNED BY public.tbl_rdb_codes.rdb_code_id;


--
-- Name: tbl_rdb_rdb_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_rdb_rdb_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_rdb_rdb_id_seq OWNER TO sead_master;

--
-- Name: tbl_rdb_rdb_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_rdb_rdb_id_seq OWNED BY public.tbl_rdb.rdb_id;


--
-- Name: tbl_rdb_systems_rdb_system_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_rdb_systems_rdb_system_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_rdb_systems_rdb_system_id_seq OWNER TO sead_master;

--
-- Name: tbl_rdb_systems_rdb_system_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_rdb_systems_rdb_system_id_seq OWNED BY public.tbl_rdb_systems.rdb_system_id;


--
-- Name: tbl_record_types_record_type_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_record_types_record_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_record_types_record_type_id_seq OWNER TO sead_master;

--
-- Name: tbl_record_types_record_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_record_types_record_type_id_seq OWNED BY public.tbl_record_types.record_type_id;


--
-- Name: tbl_relative_age_refs_relative_age_ref_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_relative_age_refs_relative_age_ref_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_relative_age_refs_relative_age_ref_id_seq OWNER TO sead_master;

--
-- Name: tbl_relative_age_refs_relative_age_ref_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_relative_age_refs_relative_age_ref_id_seq OWNED BY public.tbl_relative_age_refs.relative_age_ref_id;


--
-- Name: tbl_relative_age_types_relative_age_type_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_relative_age_types_relative_age_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_relative_age_types_relative_age_type_id_seq OWNER TO sead_master;

--
-- Name: tbl_relative_age_types_relative_age_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_relative_age_types_relative_age_type_id_seq OWNED BY public.tbl_relative_age_types.relative_age_type_id;


--
-- Name: tbl_relative_ages_relative_age_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_relative_ages_relative_age_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_relative_ages_relative_age_id_seq OWNER TO sead_master;

--
-- Name: tbl_relative_ages_relative_age_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_relative_ages_relative_age_id_seq OWNED BY public.tbl_relative_ages.relative_age_id;


--
-- Name: tbl_relative_dates_relative_date_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_relative_dates_relative_date_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_relative_dates_relative_date_id_seq OWNER TO sead_master;

--
-- Name: tbl_relative_dates_relative_date_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_relative_dates_relative_date_id_seq OWNED BY public.tbl_relative_dates.relative_date_id;


--
-- Name: tbl_sample_alt_refs_sample_alt_ref_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_alt_refs_sample_alt_ref_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_alt_refs_sample_alt_ref_id_seq OWNER TO sead_master;

--
-- Name: tbl_sample_alt_refs_sample_alt_ref_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_alt_refs_sample_alt_ref_id_seq OWNED BY public.tbl_sample_alt_refs.sample_alt_ref_id;


--
-- Name: tbl_sample_colours_sample_colour_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_colours_sample_colour_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_colours_sample_colour_id_seq OWNER TO sead_master;

--
-- Name: tbl_sample_colours_sample_colour_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_colours_sample_colour_id_seq OWNED BY public.tbl_sample_colours.sample_colour_id;


--
-- Name: tbl_sample_coordinates_sample_coordinates_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_coordinates_sample_coordinates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_coordinates_sample_coordinates_id_seq OWNER TO sead_master;

--
-- Name: tbl_sample_coordinates_sample_coordinates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_coordinates_sample_coordinates_id_seq OWNED BY public.tbl_sample_coordinates.sample_coordinate_id;


--
-- Name: tbl_sample_description_sample_sample_description_sample_gro_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_description_sample_sample_description_sample_gro_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_description_sample_sample_description_sample_gro_seq OWNER TO sead_master;

--
-- Name: tbl_sample_description_sample_sample_description_sample_gro_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_description_sample_sample_description_sample_gro_seq OWNED BY public.tbl_sample_description_sample_group_contexts.sample_description_sample_group_context_id;


--
-- Name: tbl_sample_description_types_sample_description_type_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_description_types_sample_description_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_description_types_sample_description_type_id_seq OWNER TO sead_master;

--
-- Name: tbl_sample_description_types_sample_description_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_description_types_sample_description_type_id_seq OWNED BY public.tbl_sample_description_types.sample_description_type_id;


--
-- Name: tbl_sample_descriptions_sample_description_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_descriptions_sample_description_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_descriptions_sample_description_id_seq OWNER TO sead_master;

--
-- Name: tbl_sample_descriptions_sample_description_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_descriptions_sample_description_id_seq OWNED BY public.tbl_sample_descriptions.sample_description_id;


--
-- Name: tbl_sample_dimensions_sample_dimension_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_dimensions_sample_dimension_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_dimensions_sample_dimension_id_seq OWNER TO sead_master;

--
-- Name: tbl_sample_dimensions_sample_dimension_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_dimensions_sample_dimension_id_seq OWNED BY public.tbl_sample_dimensions.sample_dimension_id;


--
-- Name: tbl_sample_geometry_sample_geometry_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_geometry_sample_geometry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_geometry_sample_geometry_id_seq OWNER TO sead_master;

--
-- Name: tbl_sample_group_coordinates_sample_group_position_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_group_coordinates_sample_group_position_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_group_coordinates_sample_group_position_id_seq OWNER TO sead_master;

--
-- Name: tbl_sample_group_coordinates_sample_group_position_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_group_coordinates_sample_group_position_id_seq OWNED BY public.tbl_sample_group_coordinates.sample_group_position_id;


--
-- Name: tbl_sample_group_description__sample_group_desciption_sampl_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_group_description__sample_group_desciption_sampl_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_group_description__sample_group_desciption_sampl_seq OWNER TO sead_master;

--
-- Name: tbl_sample_group_description__sample_group_desciption_sampl_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_group_description__sample_group_desciption_sampl_seq OWNED BY public.tbl_sample_group_description_type_sampling_contexts.sample_group_description_type_sampling_context_id;


--
-- Name: tbl_sample_group_description__sample_group_description_type_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_group_description__sample_group_description_type_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_group_description__sample_group_description_type_seq OWNER TO sead_master;

--
-- Name: tbl_sample_group_description__sample_group_description_type_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_group_description__sample_group_description_type_seq OWNED BY public.tbl_sample_group_description_types.sample_group_description_type_id;


--
-- Name: tbl_sample_group_descriptions_sample_group_description_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_group_descriptions_sample_group_description_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_group_descriptions_sample_group_description_id_seq OWNER TO sead_master;

--
-- Name: tbl_sample_group_descriptions_sample_group_description_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_group_descriptions_sample_group_description_id_seq OWNED BY public.tbl_sample_group_descriptions.sample_group_description_id;


--
-- Name: tbl_sample_group_dimensions_sample_group_dimension_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_group_dimensions_sample_group_dimension_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_group_dimensions_sample_group_dimension_id_seq OWNER TO sead_master;

--
-- Name: tbl_sample_group_dimensions_sample_group_dimension_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_group_dimensions_sample_group_dimension_id_seq OWNED BY public.tbl_sample_group_dimensions.sample_group_dimension_id;


--
-- Name: tbl_sample_group_images_sample_group_image_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_group_images_sample_group_image_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_group_images_sample_group_image_id_seq OWNER TO sead_master;

--
-- Name: tbl_sample_group_images_sample_group_image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_group_images_sample_group_image_id_seq OWNED BY public.tbl_sample_group_images.sample_group_image_id;


--
-- Name: tbl_sample_group_notes_sample_group_note_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_group_notes_sample_group_note_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_group_notes_sample_group_note_id_seq OWNER TO sead_master;

--
-- Name: tbl_sample_group_notes_sample_group_note_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_group_notes_sample_group_note_id_seq OWNED BY public.tbl_sample_group_notes.sample_group_note_id;


--
-- Name: tbl_sample_group_references_sample_group_reference_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_group_references_sample_group_reference_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_group_references_sample_group_reference_id_seq OWNER TO sead_master;

--
-- Name: tbl_sample_group_references_sample_group_reference_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_group_references_sample_group_reference_id_seq OWNED BY public.tbl_sample_group_references.sample_group_reference_id;


--
-- Name: tbl_sample_group_sampling_contexts_sampling_context_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_group_sampling_contexts_sampling_context_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_group_sampling_contexts_sampling_context_id_seq OWNER TO sead_master;

--
-- Name: tbl_sample_group_sampling_contexts_sampling_context_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_group_sampling_contexts_sampling_context_id_seq OWNED BY public.tbl_sample_group_sampling_contexts.sampling_context_id;


--
-- Name: tbl_sample_groups_sample_group_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_groups_sample_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_groups_sample_group_id_seq OWNER TO sead_master;

--
-- Name: tbl_sample_groups_sample_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_groups_sample_group_id_seq OWNED BY public.tbl_sample_groups.sample_group_id;


--
-- Name: tbl_sample_horizons_sample_horizon_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_horizons_sample_horizon_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_horizons_sample_horizon_id_seq OWNER TO sead_master;

--
-- Name: tbl_sample_horizons_sample_horizon_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_horizons_sample_horizon_id_seq OWNED BY public.tbl_sample_horizons.sample_horizon_id;


--
-- Name: tbl_sample_images_sample_image_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_images_sample_image_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_images_sample_image_id_seq OWNER TO sead_master;

--
-- Name: tbl_sample_images_sample_image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_images_sample_image_id_seq OWNED BY public.tbl_sample_images.sample_image_id;


--
-- Name: tbl_sample_location_sampling__sample_location_type_sampling_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_location_sampling__sample_location_type_sampling_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_location_sampling__sample_location_type_sampling_seq OWNER TO sead_master;

--
-- Name: tbl_sample_location_sampling__sample_location_type_sampling_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_location_sampling__sample_location_type_sampling_seq OWNED BY public.tbl_sample_location_type_sampling_contexts.sample_location_type_sampling_context_id;


--
-- Name: tbl_sample_location_sampling_contex_sample_location_type_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_location_sampling_contex_sample_location_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_location_sampling_contex_sample_location_type_id_seq OWNER TO sead_master;

--
-- Name: tbl_sample_location_sampling_contex_sample_location_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_location_sampling_contex_sample_location_type_id_seq OWNED BY public.tbl_sample_location_type_sampling_contexts.sample_location_type_id;


--
-- Name: tbl_sample_location_types_sample_location_type_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_location_types_sample_location_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_location_types_sample_location_type_id_seq OWNER TO sead_master;

--
-- Name: tbl_sample_location_types_sample_location_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_location_types_sample_location_type_id_seq OWNED BY public.tbl_sample_location_types.sample_location_type_id;


--
-- Name: tbl_sample_locations_sample_location_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_locations_sample_location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_locations_sample_location_id_seq OWNER TO sead_master;

--
-- Name: tbl_sample_locations_sample_location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_locations_sample_location_id_seq OWNED BY public.tbl_sample_locations.sample_location_id;


--
-- Name: tbl_sample_notes_sample_note_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_notes_sample_note_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_notes_sample_note_id_seq OWNER TO sead_master;

--
-- Name: tbl_sample_notes_sample_note_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_notes_sample_note_id_seq OWNED BY public.tbl_sample_notes.sample_note_id;


--
-- Name: tbl_sample_types_sample_type_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sample_types_sample_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sample_types_sample_type_id_seq OWNER TO sead_master;

--
-- Name: tbl_sample_types_sample_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sample_types_sample_type_id_seq OWNED BY public.tbl_sample_types.sample_type_id;


--
-- Name: tbl_season_or_qualifier_season_or_qualifier_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_season_or_qualifier_season_or_qualifier_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_season_or_qualifier_season_or_qualifier_id_seq OWNER TO sead_master;

--
-- Name: tbl_season_or_qualifier_season_or_qualifier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_season_or_qualifier_season_or_qualifier_id_seq OWNED BY public.tbl_season_or_qualifier.season_or_qualifier_id;


--
-- Name: tbl_season_types_season_type_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_season_types_season_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_season_types_season_type_id_seq OWNER TO sead_master;

--
-- Name: tbl_season_types_season_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_season_types_season_type_id_seq OWNED BY public.tbl_season_types.season_type_id;


--
-- Name: tbl_seasons_season_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_seasons_season_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_seasons_season_id_seq OWNER TO sead_master;

--
-- Name: tbl_seasons_season_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_seasons_season_id_seq OWNED BY public.tbl_seasons.season_id;


--
-- Name: tbl_site_images_site_image_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_site_images_site_image_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_site_images_site_image_id_seq OWNER TO sead_master;

--
-- Name: tbl_site_images_site_image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_site_images_site_image_id_seq OWNED BY public.tbl_site_images.site_image_id;


--
-- Name: tbl_site_locations_site_location_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_site_locations_site_location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_site_locations_site_location_id_seq OWNER TO sead_master;

--
-- Name: tbl_site_locations_site_location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_site_locations_site_location_id_seq OWNED BY public.tbl_site_locations.site_location_id;


--
-- Name: tbl_site_natgridrefs_site_natgridref_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_site_natgridrefs_site_natgridref_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_site_natgridrefs_site_natgridref_id_seq OWNER TO sead_master;

--
-- Name: tbl_site_natgridrefs_site_natgridref_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_site_natgridrefs_site_natgridref_id_seq OWNED BY public.tbl_site_natgridrefs.site_natgridref_id;


--
-- Name: tbl_site_other_records_site_other_records_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_site_other_records_site_other_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_site_other_records_site_other_records_id_seq OWNER TO sead_master;

--
-- Name: tbl_site_other_records_site_other_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_site_other_records_site_other_records_id_seq OWNED BY public.tbl_site_other_records.site_other_records_id;


--
-- Name: tbl_site_preservation_status_site_preservation_status_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_site_preservation_status_site_preservation_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_site_preservation_status_site_preservation_status_id_seq OWNER TO sead_master;

--
-- Name: tbl_site_preservation_status_site_preservation_status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_site_preservation_status_site_preservation_status_id_seq OWNED BY public.tbl_site_preservation_status.site_preservation_status_id;


--
-- Name: tbl_site_references_site_reference_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_site_references_site_reference_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_site_references_site_reference_id_seq OWNER TO sead_master;

--
-- Name: tbl_site_references_site_reference_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_site_references_site_reference_id_seq OWNED BY public.tbl_site_references.site_reference_id;


--
-- Name: tbl_sites_site_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_sites_site_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sites_site_id_seq OWNER TO sead_master;

--
-- Name: tbl_sites_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_sites_site_id_seq OWNED BY public.tbl_sites.site_id;


--
-- Name: tbl_species_associations_species_association_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_species_associations_species_association_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_species_associations_species_association_id_seq OWNER TO sead_master;

--
-- Name: tbl_species_associations_species_association_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_species_associations_species_association_id_seq OWNED BY public.tbl_species_associations.species_association_id;


--
-- Name: tbl_taxa_common_names_taxon_common_name_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_taxa_common_names_taxon_common_name_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_taxa_common_names_taxon_common_name_id_seq OWNER TO sead_master;

--
-- Name: tbl_taxa_common_names_taxon_common_name_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_taxa_common_names_taxon_common_name_id_seq OWNED BY public.tbl_taxa_common_names.taxon_common_name_id;


--
-- Name: tbl_taxa_images_taxa_images_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_taxa_images_taxa_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_taxa_images_taxa_images_id_seq OWNER TO sead_master;

--
-- Name: tbl_taxa_images_taxa_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_taxa_images_taxa_images_id_seq OWNED BY public.tbl_taxa_images.taxa_images_id;


--
-- Name: tbl_taxa_measured_attributes_measured_attribute_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_taxa_measured_attributes_measured_attribute_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_taxa_measured_attributes_measured_attribute_id_seq OWNER TO sead_master;

--
-- Name: tbl_taxa_measured_attributes_measured_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_taxa_measured_attributes_measured_attribute_id_seq OWNED BY public.tbl_taxa_measured_attributes.measured_attribute_id;


--
-- Name: tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq OWNER TO sead_master;

--
-- Name: tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq OWNED BY public.tbl_taxa_reference_specimens.taxa_reference_specimen_id;


--
-- Name: tbl_taxa_seasonality_seasonality_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_taxa_seasonality_seasonality_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_taxa_seasonality_seasonality_id_seq OWNER TO sead_master;

--
-- Name: tbl_taxa_seasonality_seasonality_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_taxa_seasonality_seasonality_id_seq OWNED BY public.tbl_taxa_seasonality.seasonality_id;


--
-- Name: tbl_taxa_synonyms_synonym_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_taxa_synonyms_synonym_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_taxa_synonyms_synonym_id_seq OWNER TO sead_master;

--
-- Name: tbl_taxa_synonyms_synonym_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_taxa_synonyms_synonym_id_seq OWNED BY public.tbl_taxa_synonyms.synonym_id;


--
-- Name: tbl_taxa_tree_authors_author_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_taxa_tree_authors_author_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_taxa_tree_authors_author_id_seq OWNER TO sead_master;

--
-- Name: tbl_taxa_tree_authors_author_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_taxa_tree_authors_author_id_seq OWNED BY public.tbl_taxa_tree_authors.author_id;


--
-- Name: tbl_taxa_tree_families_family_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_taxa_tree_families_family_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_taxa_tree_families_family_id_seq OWNER TO sead_master;

--
-- Name: tbl_taxa_tree_families_family_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_taxa_tree_families_family_id_seq OWNED BY public.tbl_taxa_tree_families.family_id;


--
-- Name: tbl_taxa_tree_genera_genus_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_taxa_tree_genera_genus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_taxa_tree_genera_genus_id_seq OWNER TO sead_master;

--
-- Name: tbl_taxa_tree_genera_genus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_taxa_tree_genera_genus_id_seq OWNED BY public.tbl_taxa_tree_genera.genus_id;


--
-- Name: tbl_taxa_tree_master_taxon_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_taxa_tree_master_taxon_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_taxa_tree_master_taxon_id_seq OWNER TO sead_master;

--
-- Name: tbl_taxa_tree_master_taxon_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_taxa_tree_master_taxon_id_seq OWNED BY public.tbl_taxa_tree_master.taxon_id;


--
-- Name: tbl_taxa_tree_orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_taxa_tree_orders_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_taxa_tree_orders_order_id_seq OWNER TO sead_master;

--
-- Name: tbl_taxa_tree_orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_taxa_tree_orders_order_id_seq OWNED BY public.tbl_taxa_tree_orders.order_id;


--
-- Name: tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq OWNER TO sead_master;

--
-- Name: tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq OWNED BY public.tbl_taxonomic_order_biblio.taxonomic_order_biblio_id;


--
-- Name: tbl_taxonomic_order_systems_taxonomic_order_system_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_taxonomic_order_systems_taxonomic_order_system_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_taxonomic_order_systems_taxonomic_order_system_id_seq OWNER TO sead_master;

--
-- Name: tbl_taxonomic_order_systems_taxonomic_order_system_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_taxonomic_order_systems_taxonomic_order_system_id_seq OWNED BY public.tbl_taxonomic_order_systems.taxonomic_order_system_id;


--
-- Name: tbl_taxonomic_order_taxonomic_order_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_taxonomic_order_taxonomic_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_taxonomic_order_taxonomic_order_id_seq OWNER TO sead_master;

--
-- Name: tbl_taxonomic_order_taxonomic_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_taxonomic_order_taxonomic_order_id_seq OWNED BY public.tbl_taxonomic_order.taxonomic_order_id;


--
-- Name: tbl_taxonomy_notes_taxonomy_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_taxonomy_notes_taxonomy_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_taxonomy_notes_taxonomy_notes_id_seq OWNER TO sead_master;

--
-- Name: tbl_taxonomy_notes_taxonomy_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_taxonomy_notes_taxonomy_notes_id_seq OWNED BY public.tbl_taxonomy_notes.taxonomy_notes_id;


--
-- Name: tbl_tephra_dates_tephra_date_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_tephra_dates_tephra_date_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_tephra_dates_tephra_date_id_seq OWNER TO sead_master;

--
-- Name: tbl_tephra_dates_tephra_date_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_tephra_dates_tephra_date_id_seq OWNED BY public.tbl_tephra_dates.tephra_date_id;


--
-- Name: tbl_tephra_refs_tephra_ref_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_tephra_refs_tephra_ref_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_tephra_refs_tephra_ref_id_seq OWNER TO sead_master;

--
-- Name: tbl_tephra_refs_tephra_ref_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_tephra_refs_tephra_ref_id_seq OWNED BY public.tbl_tephra_refs.tephra_ref_id;


--
-- Name: tbl_tephras_tephra_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_tephras_tephra_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_tephras_tephra_id_seq OWNER TO sead_master;

--
-- Name: tbl_tephras_tephra_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_tephras_tephra_id_seq OWNED BY public.tbl_tephras.tephra_id;


--
-- Name: tbl_text_biology_biology_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_text_biology_biology_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_text_biology_biology_id_seq OWNER TO sead_master;

--
-- Name: tbl_text_biology_biology_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_text_biology_biology_id_seq OWNED BY public.tbl_text_biology.biology_id;


--
-- Name: tbl_text_distribution_distribution_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_text_distribution_distribution_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_text_distribution_distribution_id_seq OWNER TO sead_master;

--
-- Name: tbl_text_distribution_distribution_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_text_distribution_distribution_id_seq OWNED BY public.tbl_text_distribution.distribution_id;


--
-- Name: tbl_text_identification_keys_key_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_text_identification_keys_key_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_text_identification_keys_key_id_seq OWNER TO sead_master;

--
-- Name: tbl_text_identification_keys_key_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_text_identification_keys_key_id_seq OWNED BY public.tbl_text_identification_keys.key_id;


--
-- Name: tbl_units_unit_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_units_unit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_units_unit_id_seq OWNER TO sead_master;

--
-- Name: tbl_units_unit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_units_unit_id_seq OWNED BY public.tbl_units.unit_id;


--
-- Name: tbl_years_types_years_type_id_seq; Type: SEQUENCE; Schema: public; Owner: sead_master
--

CREATE SEQUENCE public.tbl_years_types_years_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_years_types_years_type_id_seq OWNER TO sead_master;

--
-- Name: tbl_years_types_years_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sead_master
--

ALTER SEQUENCE public.tbl_years_types_years_type_id_seq OWNED BY public.tbl_years_types.years_type_id;


--
-- Name: v_json_array; Type: TABLE; Schema: public; Owner: clearinghouse_worker
--

CREATE TABLE public.v_json_array (
    array_to_json json
);


ALTER TABLE public.v_json_array OWNER TO clearinghouse_worker;

--
-- Name: view_taxa_tree; Type: VIEW; Schema: public; Owner: sead_master
--

CREATE VIEW public.view_taxa_tree AS
 SELECT tbl_taxa_tree_authors.author_name,
    tbl_taxa_tree_master.species,
    tbl_taxa_tree_genera.genus_name,
    tbl_taxa_tree_families.family_name,
    tbl_taxa_tree_orders.order_name,
    tbl_taxa_tree_orders.sort_order
   FROM public.tbl_taxa_tree_orders,
    public.tbl_taxa_tree_master,
    public.tbl_taxa_tree_genera,
    public.tbl_taxa_tree_families,
    public.tbl_taxa_tree_authors
  WHERE ((((tbl_taxa_tree_master.genus_id = tbl_taxa_tree_genera.genus_id) AND (tbl_taxa_tree_genera.family_id = tbl_taxa_tree_families.family_id)) AND (tbl_taxa_tree_families.order_id = tbl_taxa_tree_orders.order_id)) AND (tbl_taxa_tree_authors.author_id = tbl_taxa_tree_master.author_id));


ALTER TABLE public.view_taxa_tree OWNER TO sead_master;

--
-- Name: VIEW view_taxa_tree; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON VIEW public.view_taxa_tree IS 'Used to view the entire taxanomic tree in one go.';


--
-- Name: view_taxa_tree_select; Type: VIEW; Schema: public; Owner: sead_master
--

CREATE VIEW public.view_taxa_tree_select AS
 SELECT a.author_name AS author,
    s.species,
    s.taxon_id,
    g.genus_name AS genus,
    g.genus_id,
    f.family_name AS family,
    f.family_id,
    o.order_name,
    o.order_id
   FROM ((((public.tbl_taxa_tree_master s
     JOIN public.tbl_taxa_tree_genera g ON ((s.genus_id = g.genus_id)))
     JOIN public.tbl_taxa_tree_families f ON ((g.family_id = f.family_id)))
     JOIN public.tbl_taxa_tree_orders o ON ((f.order_id = o.order_id)))
     LEFT JOIN public.tbl_taxa_tree_authors a ON ((s.author_id = a.author_id)));


ALTER TABLE public.view_taxa_tree_select OWNER TO sead_master;

--
-- Name: VIEW view_taxa_tree_select; Type: COMMENT; Schema: public; Owner: sead_master
--

COMMENT ON VIEW public.view_taxa_tree_select IS 'view with all taxa with one row per taxon. Includes the primary ids for each of the included items for easy selections.';


--
-- Name: tbl_abundance_elements abundance_element_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_abundance_elements ALTER COLUMN abundance_element_id SET DEFAULT nextval('public.tbl_abundance_elements_abundance_element_id_seq'::regclass);


--
-- Name: tbl_abundance_ident_levels abundance_ident_level_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_abundance_ident_levels ALTER COLUMN abundance_ident_level_id SET DEFAULT nextval('public.tbl_abundance_ident_levels_abundance_ident_level_id_seq'::regclass);


--
-- Name: tbl_abundance_modifications abundance_modification_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_abundance_modifications ALTER COLUMN abundance_modification_id SET DEFAULT nextval('public.tbl_abundance_modifications_abundance_modification_id_seq'::regclass);


--
-- Name: tbl_abundances abundance_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_abundances ALTER COLUMN abundance_id SET DEFAULT nextval('public.tbl_abundances_abundance_id_seq'::regclass);


--
-- Name: tbl_activity_types activity_type_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_activity_types ALTER COLUMN activity_type_id SET DEFAULT nextval('public.tbl_activity_types_activity_type_id_seq'::regclass);


--
-- Name: tbl_age_types age_type_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_age_types ALTER COLUMN age_type_id SET DEFAULT nextval('public.tbl_age_types_age_type_id_seq'::regclass);


--
-- Name: tbl_aggregate_datasets aggregate_dataset_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_aggregate_datasets ALTER COLUMN aggregate_dataset_id SET DEFAULT nextval('public.tbl_aggregate_datasets_aggregate_dataset_id_seq'::regclass);


--
-- Name: tbl_aggregate_order_types aggregate_order_type_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_aggregate_order_types ALTER COLUMN aggregate_order_type_id SET DEFAULT nextval('public.tbl_aggregate_order_types_aggregate_order_type_id_seq'::regclass);


--
-- Name: tbl_aggregate_sample_ages aggregate_sample_age_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_aggregate_sample_ages ALTER COLUMN aggregate_sample_age_id SET DEFAULT nextval('public.tbl_aggregate_sample_ages_aggregate_sample_age_id_seq'::regclass);


--
-- Name: tbl_aggregate_samples aggregate_sample_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_aggregate_samples ALTER COLUMN aggregate_sample_id SET DEFAULT nextval('public.tbl_aggregate_samples_aggregate_sample_id_seq'::regclass);


--
-- Name: tbl_alt_ref_types alt_ref_type_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_alt_ref_types ALTER COLUMN alt_ref_type_id SET DEFAULT nextval('public.tbl_alt_ref_types_alt_ref_type_id_seq'::regclass);


--
-- Name: tbl_analysis_entities analysis_entity_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_analysis_entities ALTER COLUMN analysis_entity_id SET DEFAULT nextval('public.tbl_analysis_entities_analysis_entity_id_seq'::regclass);


--
-- Name: tbl_analysis_entity_ages analysis_entity_age_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_analysis_entity_ages ALTER COLUMN analysis_entity_age_id SET DEFAULT nextval('public.tbl_analysis_entity_ages_analysis_entity_age_id_seq'::regclass);


--
-- Name: tbl_analysis_entity_dimensions analysis_entity_dimension_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_analysis_entity_dimensions ALTER COLUMN analysis_entity_dimension_id SET DEFAULT nextval('public.tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq'::regclass);


--
-- Name: tbl_analysis_entity_prep_methods analysis_entity_prep_method_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_analysis_entity_prep_methods ALTER COLUMN analysis_entity_prep_method_id SET DEFAULT nextval('public.tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq'::regclass);


--
-- Name: tbl_biblio biblio_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_biblio ALTER COLUMN biblio_id SET DEFAULT nextval('public.tbl_biblio_biblio_id_seq'::regclass);


--
-- Name: tbl_ceramics ceramics_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_ceramics ALTER COLUMN ceramics_id SET DEFAULT nextval('public.tbl_ceramics_ceramics_id_seq'::regclass);


--
-- Name: tbl_ceramics_lookup ceramics_lookup_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_ceramics_lookup ALTER COLUMN ceramics_lookup_id SET DEFAULT nextval('public.tbl_ceramics_lookup_ceramics_lookup_id_seq'::regclass);


--
-- Name: tbl_ceramics_measurements ceramics_measurement_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_ceramics_measurements ALTER COLUMN ceramics_measurement_id SET DEFAULT nextval('public.tbl_ceramics_measurements_ceramics_measurement_id_seq'::regclass);


--
-- Name: tbl_chron_control_types chron_control_type_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_chron_control_types ALTER COLUMN chron_control_type_id SET DEFAULT nextval('public.tbl_chron_control_types_chron_control_type_id_seq'::regclass);


--
-- Name: tbl_chron_controls chron_control_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_chron_controls ALTER COLUMN chron_control_id SET DEFAULT nextval('public.tbl_chron_controls_chron_control_id_seq'::regclass);


--
-- Name: tbl_chronologies chronology_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_chronologies ALTER COLUMN chronology_id SET DEFAULT nextval('public.tbl_chronologies_chronology_id_seq'::regclass);


--
-- Name: tbl_colours colour_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_colours ALTER COLUMN colour_id SET DEFAULT nextval('public.tbl_colours_colour_id_seq'::regclass);


--
-- Name: tbl_contact_types contact_type_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_contact_types ALTER COLUMN contact_type_id SET DEFAULT nextval('public.tbl_contact_types_contact_type_id_seq'::regclass);


--
-- Name: tbl_contacts contact_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_contacts ALTER COLUMN contact_id SET DEFAULT nextval('public.tbl_contacts_contact_id_seq'::regclass);


--
-- Name: tbl_coordinate_method_dimensions coordinate_method_dimension_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_coordinate_method_dimensions ALTER COLUMN coordinate_method_dimension_id SET DEFAULT nextval('public.tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq'::regclass);


--
-- Name: tbl_data_type_groups data_type_group_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_data_type_groups ALTER COLUMN data_type_group_id SET DEFAULT nextval('public.tbl_data_type_groups_data_type_group_id_seq'::regclass);


--
-- Name: tbl_data_types data_type_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_data_types ALTER COLUMN data_type_id SET DEFAULT nextval('public.tbl_data_types_data_type_id_seq'::regclass);


--
-- Name: tbl_dataset_contacts dataset_contact_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dataset_contacts ALTER COLUMN dataset_contact_id SET DEFAULT nextval('public.tbl_dataset_contacts_dataset_contact_id_seq'::regclass);


--
-- Name: tbl_dataset_masters master_set_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dataset_masters ALTER COLUMN master_set_id SET DEFAULT nextval('public.tbl_dataset_masters_master_set_id_seq'::regclass);


--
-- Name: tbl_dataset_submission_types submission_type_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dataset_submission_types ALTER COLUMN submission_type_id SET DEFAULT nextval('public.tbl_dataset_submission_types_submission_type_id_seq'::regclass);


--
-- Name: tbl_dataset_submissions dataset_submission_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dataset_submissions ALTER COLUMN dataset_submission_id SET DEFAULT nextval('public.tbl_dataset_submissions_dataset_submission_id_seq'::regclass);


--
-- Name: tbl_datasets dataset_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_datasets ALTER COLUMN dataset_id SET DEFAULT nextval('public.tbl_datasets_dataset_id_seq'::regclass);


--
-- Name: tbl_dating_labs dating_lab_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dating_labs ALTER COLUMN dating_lab_id SET DEFAULT nextval('public.tbl_dating_labs_dating_lab_id_seq'::regclass);


--
-- Name: tbl_dating_material dating_material_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dating_material ALTER COLUMN dating_material_id SET DEFAULT nextval('public.tbl_dating_material_dating_material_id_seq'::regclass);


--
-- Name: tbl_dating_uncertainty dating_uncertainty_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dating_uncertainty ALTER COLUMN dating_uncertainty_id SET DEFAULT nextval('public.tbl_dating_uncertainty_dating_uncertainty_id_seq'::regclass);


--
-- Name: tbl_dendro dendro_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dendro ALTER COLUMN dendro_id SET DEFAULT nextval('public.tbl_dendro_dendro_id_seq'::regclass);


--
-- Name: tbl_dendro_date_notes dendro_date_note_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dendro_date_notes ALTER COLUMN dendro_date_note_id SET DEFAULT nextval('public.tbl_dendro_date_notes_dendro_date_note_id_seq'::regclass);


--
-- Name: tbl_dendro_dates dendro_date_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dendro_dates ALTER COLUMN dendro_date_id SET DEFAULT nextval('public.tbl_dendro_dates_dendro_date_id_seq'::regclass);


--
-- Name: tbl_dendro_lookup dendro_lookup_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dendro_lookup ALTER COLUMN dendro_lookup_id SET DEFAULT nextval('public.tbl_dendro_lookup_dendro_lookup_id_seq'::regclass);


--
-- Name: tbl_dendro_measurements dendro_measurement_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dendro_measurements ALTER COLUMN dendro_measurement_id SET DEFAULT nextval('public.tbl_dendro_measurements_dendro_measurement_id_seq'::regclass);


--
-- Name: tbl_dimensions dimension_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dimensions ALTER COLUMN dimension_id SET DEFAULT nextval('public.tbl_dimensions_dimension_id_seq'::regclass);


--
-- Name: tbl_ecocode_definitions ecocode_definition_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_ecocode_definitions ALTER COLUMN ecocode_definition_id SET DEFAULT nextval('public.tbl_ecocode_definitions_ecocode_definition_id_seq'::regclass);


--
-- Name: tbl_ecocode_groups ecocode_group_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_ecocode_groups ALTER COLUMN ecocode_group_id SET DEFAULT nextval('public.tbl_ecocode_groups_ecocode_group_id_seq'::regclass);


--
-- Name: tbl_ecocode_systems ecocode_system_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_ecocode_systems ALTER COLUMN ecocode_system_id SET DEFAULT nextval('public.tbl_ecocode_systems_ecocode_system_id_seq'::regclass);


--
-- Name: tbl_ecocodes ecocode_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_ecocodes ALTER COLUMN ecocode_id SET DEFAULT nextval('public.tbl_ecocodes_ecocode_id_seq'::regclass);


--
-- Name: tbl_error_uncertainties error_uncertainty_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_error_uncertainties ALTER COLUMN error_uncertainty_id SET DEFAULT nextval('public.tbl_error_uncertainties_error_uncertainty_id_seq'::regclass);


--
-- Name: tbl_feature_types feature_type_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_feature_types ALTER COLUMN feature_type_id SET DEFAULT nextval('public.tbl_feature_types_feature_type_id_seq'::regclass);


--
-- Name: tbl_features feature_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_features ALTER COLUMN feature_id SET DEFAULT nextval('public.tbl_features_feature_id_seq'::regclass);


--
-- Name: tbl_geochron_refs geochron_ref_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_geochron_refs ALTER COLUMN geochron_ref_id SET DEFAULT nextval('public.tbl_geochron_refs_geochron_ref_id_seq'::regclass);


--
-- Name: tbl_geochronology geochron_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_geochronology ALTER COLUMN geochron_id SET DEFAULT nextval('public.tbl_geochronology_geochron_id_seq'::regclass);


--
-- Name: tbl_horizons horizon_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_horizons ALTER COLUMN horizon_id SET DEFAULT nextval('public.tbl_horizons_horizon_id_seq'::regclass);


--
-- Name: tbl_identification_levels identification_level_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_identification_levels ALTER COLUMN identification_level_id SET DEFAULT nextval('public.tbl_identification_levels_identification_level_id_seq'::regclass);


--
-- Name: tbl_image_types image_type_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_image_types ALTER COLUMN image_type_id SET DEFAULT nextval('public.tbl_image_types_image_type_id_seq'::regclass);


--
-- Name: tbl_imported_taxa_replacements imported_taxa_replacement_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_imported_taxa_replacements ALTER COLUMN imported_taxa_replacement_id SET DEFAULT nextval('public.tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq'::regclass);


--
-- Name: tbl_languages language_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_languages ALTER COLUMN language_id SET DEFAULT nextval('public.tbl_languages_language_id_seq'::regclass);


--
-- Name: tbl_lithology lithology_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_lithology ALTER COLUMN lithology_id SET DEFAULT nextval('public.tbl_lithology_lithology_id_seq'::regclass);


--
-- Name: tbl_location_types location_type_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_location_types ALTER COLUMN location_type_id SET DEFAULT nextval('public.tbl_location_types_location_type_id_seq'::regclass);


--
-- Name: tbl_locations location_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_locations ALTER COLUMN location_id SET DEFAULT nextval('public.tbl_locations_location_id_seq'::regclass);


--
-- Name: tbl_mcr_names taxon_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_mcr_names ALTER COLUMN taxon_id SET DEFAULT nextval('public.tbl_mcr_names_taxon_id_seq'::regclass);


--
-- Name: tbl_mcr_summary_data mcr_summary_data_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_mcr_summary_data ALTER COLUMN mcr_summary_data_id SET DEFAULT nextval('public.tbl_mcr_summary_data_mcr_summary_data_id_seq'::regclass);


--
-- Name: tbl_mcrdata_birmbeetledat mcrdata_birmbeetledat_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_mcrdata_birmbeetledat ALTER COLUMN mcrdata_birmbeetledat_id SET DEFAULT nextval('public.tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq'::regclass);


--
-- Name: tbl_measured_value_dimensions measured_value_dimension_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_measured_value_dimensions ALTER COLUMN measured_value_dimension_id SET DEFAULT nextval('public.tbl_measured_value_dimensions_measured_value_dimension_id_seq'::regclass);


--
-- Name: tbl_measured_values measured_value_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_measured_values ALTER COLUMN measured_value_id SET DEFAULT nextval('public.tbl_measured_values_measured_value_id_seq'::regclass);


--
-- Name: tbl_method_groups method_group_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_method_groups ALTER COLUMN method_group_id SET DEFAULT nextval('public.tbl_method_groups_method_group_id_seq'::regclass);


--
-- Name: tbl_methods method_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_methods ALTER COLUMN method_id SET DEFAULT nextval('public.tbl_methods_method_id_seq'::regclass);


--
-- Name: tbl_modification_types modification_type_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_modification_types ALTER COLUMN modification_type_id SET DEFAULT nextval('public.tbl_modification_types_modification_type_id_seq'::regclass);


--
-- Name: tbl_physical_sample_features physical_sample_feature_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_physical_sample_features ALTER COLUMN physical_sample_feature_id SET DEFAULT nextval('public.tbl_physical_sample_features_physical_sample_feature_id_seq'::regclass);


--
-- Name: tbl_physical_samples physical_sample_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_physical_samples ALTER COLUMN physical_sample_id SET DEFAULT nextval('public.tbl_physical_samples_physical_sample_id_seq'::regclass);


--
-- Name: tbl_project_stages project_stage_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_project_stages ALTER COLUMN project_stage_id SET DEFAULT nextval('public.tbl_project_stage_project_stage_id_seq'::regclass);


--
-- Name: tbl_project_types project_type_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_project_types ALTER COLUMN project_type_id SET DEFAULT nextval('public.tbl_project_types_project_type_id_seq'::regclass);


--
-- Name: tbl_projects project_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_projects ALTER COLUMN project_id SET DEFAULT nextval('public.tbl_projects_project_id_seq'::regclass);


--
-- Name: tbl_rdb rdb_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_rdb ALTER COLUMN rdb_id SET DEFAULT nextval('public.tbl_rdb_rdb_id_seq'::regclass);


--
-- Name: tbl_rdb_codes rdb_code_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_rdb_codes ALTER COLUMN rdb_code_id SET DEFAULT nextval('public.tbl_rdb_codes_rdb_code_id_seq'::regclass);


--
-- Name: tbl_rdb_systems rdb_system_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_rdb_systems ALTER COLUMN rdb_system_id SET DEFAULT nextval('public.tbl_rdb_systems_rdb_system_id_seq'::regclass);


--
-- Name: tbl_record_types record_type_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_record_types ALTER COLUMN record_type_id SET DEFAULT nextval('public.tbl_record_types_record_type_id_seq'::regclass);


--
-- Name: tbl_relative_age_refs relative_age_ref_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_relative_age_refs ALTER COLUMN relative_age_ref_id SET DEFAULT nextval('public.tbl_relative_age_refs_relative_age_ref_id_seq'::regclass);


--
-- Name: tbl_relative_age_types relative_age_type_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_relative_age_types ALTER COLUMN relative_age_type_id SET DEFAULT nextval('public.tbl_relative_age_types_relative_age_type_id_seq'::regclass);


--
-- Name: tbl_relative_ages relative_age_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_relative_ages ALTER COLUMN relative_age_id SET DEFAULT nextval('public.tbl_relative_ages_relative_age_id_seq'::regclass);


--
-- Name: tbl_relative_dates relative_date_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_relative_dates ALTER COLUMN relative_date_id SET DEFAULT nextval('public.tbl_relative_dates_relative_date_id_seq'::regclass);


--
-- Name: tbl_sample_alt_refs sample_alt_ref_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_alt_refs ALTER COLUMN sample_alt_ref_id SET DEFAULT nextval('public.tbl_sample_alt_refs_sample_alt_ref_id_seq'::regclass);


--
-- Name: tbl_sample_colours sample_colour_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_colours ALTER COLUMN sample_colour_id SET DEFAULT nextval('public.tbl_sample_colours_sample_colour_id_seq'::regclass);


--
-- Name: tbl_sample_coordinates sample_coordinate_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_coordinates ALTER COLUMN sample_coordinate_id SET DEFAULT nextval('public.tbl_sample_coordinates_sample_coordinates_id_seq'::regclass);


--
-- Name: tbl_sample_description_sample_group_contexts sample_description_sample_group_context_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_description_sample_group_contexts ALTER COLUMN sample_description_sample_group_context_id SET DEFAULT nextval('public.tbl_sample_description_sample_sample_description_sample_gro_seq'::regclass);


--
-- Name: tbl_sample_description_types sample_description_type_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_description_types ALTER COLUMN sample_description_type_id SET DEFAULT nextval('public.tbl_sample_description_types_sample_description_type_id_seq'::regclass);


--
-- Name: tbl_sample_descriptions sample_description_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_descriptions ALTER COLUMN sample_description_id SET DEFAULT nextval('public.tbl_sample_descriptions_sample_description_id_seq'::regclass);


--
-- Name: tbl_sample_dimensions sample_dimension_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_dimensions ALTER COLUMN sample_dimension_id SET DEFAULT nextval('public.tbl_sample_dimensions_sample_dimension_id_seq'::regclass);


--
-- Name: tbl_sample_group_coordinates sample_group_position_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_coordinates ALTER COLUMN sample_group_position_id SET DEFAULT nextval('public.tbl_sample_group_coordinates_sample_group_position_id_seq'::regclass);


--
-- Name: tbl_sample_group_description_type_sampling_contexts sample_group_description_type_sampling_context_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_description_type_sampling_contexts ALTER COLUMN sample_group_description_type_sampling_context_id SET DEFAULT nextval('public.tbl_sample_group_description__sample_group_desciption_sampl_seq'::regclass);


--
-- Name: tbl_sample_group_description_types sample_group_description_type_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_description_types ALTER COLUMN sample_group_description_type_id SET DEFAULT nextval('public.tbl_sample_group_description__sample_group_description_type_seq'::regclass);


--
-- Name: tbl_sample_group_descriptions sample_group_description_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_descriptions ALTER COLUMN sample_group_description_id SET DEFAULT nextval('public.tbl_sample_group_descriptions_sample_group_description_id_seq'::regclass);


--
-- Name: tbl_sample_group_dimensions sample_group_dimension_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_dimensions ALTER COLUMN sample_group_dimension_id SET DEFAULT nextval('public.tbl_sample_group_dimensions_sample_group_dimension_id_seq'::regclass);


--
-- Name: tbl_sample_group_images sample_group_image_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_images ALTER COLUMN sample_group_image_id SET DEFAULT nextval('public.tbl_sample_group_images_sample_group_image_id_seq'::regclass);


--
-- Name: tbl_sample_group_notes sample_group_note_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_notes ALTER COLUMN sample_group_note_id SET DEFAULT nextval('public.tbl_sample_group_notes_sample_group_note_id_seq'::regclass);


--
-- Name: tbl_sample_group_references sample_group_reference_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_references ALTER COLUMN sample_group_reference_id SET DEFAULT nextval('public.tbl_sample_group_references_sample_group_reference_id_seq'::regclass);


--
-- Name: tbl_sample_group_sampling_contexts sampling_context_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_sampling_contexts ALTER COLUMN sampling_context_id SET DEFAULT nextval('public.tbl_sample_group_sampling_contexts_sampling_context_id_seq'::regclass);


--
-- Name: tbl_sample_groups sample_group_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_groups ALTER COLUMN sample_group_id SET DEFAULT nextval('public.tbl_sample_groups_sample_group_id_seq'::regclass);


--
-- Name: tbl_sample_horizons sample_horizon_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_horizons ALTER COLUMN sample_horizon_id SET DEFAULT nextval('public.tbl_sample_horizons_sample_horizon_id_seq'::regclass);


--
-- Name: tbl_sample_images sample_image_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_images ALTER COLUMN sample_image_id SET DEFAULT nextval('public.tbl_sample_images_sample_image_id_seq'::regclass);


--
-- Name: tbl_sample_location_type_sampling_contexts sample_location_type_sampling_context_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_location_type_sampling_contexts ALTER COLUMN sample_location_type_sampling_context_id SET DEFAULT nextval('public.tbl_sample_location_sampling__sample_location_type_sampling_seq'::regclass);


--
-- Name: tbl_sample_location_type_sampling_contexts sample_location_type_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_location_type_sampling_contexts ALTER COLUMN sample_location_type_id SET DEFAULT nextval('public.tbl_sample_location_sampling_contex_sample_location_type_id_seq'::regclass);


--
-- Name: tbl_sample_location_types sample_location_type_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_location_types ALTER COLUMN sample_location_type_id SET DEFAULT nextval('public.tbl_sample_location_types_sample_location_type_id_seq'::regclass);


--
-- Name: tbl_sample_locations sample_location_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_locations ALTER COLUMN sample_location_id SET DEFAULT nextval('public.tbl_sample_locations_sample_location_id_seq'::regclass);


--
-- Name: tbl_sample_notes sample_note_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_notes ALTER COLUMN sample_note_id SET DEFAULT nextval('public.tbl_sample_notes_sample_note_id_seq'::regclass);


--
-- Name: tbl_sample_types sample_type_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_types ALTER COLUMN sample_type_id SET DEFAULT nextval('public.tbl_sample_types_sample_type_id_seq'::regclass);


--
-- Name: tbl_season_or_qualifier season_or_qualifier_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_season_or_qualifier ALTER COLUMN season_or_qualifier_id SET DEFAULT nextval('public.tbl_season_or_qualifier_season_or_qualifier_id_seq'::regclass);


--
-- Name: tbl_season_types season_type_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_season_types ALTER COLUMN season_type_id SET DEFAULT nextval('public.tbl_season_types_season_type_id_seq'::regclass);


--
-- Name: tbl_seasons season_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_seasons ALTER COLUMN season_id SET DEFAULT nextval('public.tbl_seasons_season_id_seq'::regclass);


--
-- Name: tbl_site_images site_image_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_images ALTER COLUMN site_image_id SET DEFAULT nextval('public.tbl_site_images_site_image_id_seq'::regclass);


--
-- Name: tbl_site_locations site_location_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_locations ALTER COLUMN site_location_id SET DEFAULT nextval('public.tbl_site_locations_site_location_id_seq'::regclass);


--
-- Name: tbl_site_natgridrefs site_natgridref_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_natgridrefs ALTER COLUMN site_natgridref_id SET DEFAULT nextval('public.tbl_site_natgridrefs_site_natgridref_id_seq'::regclass);


--
-- Name: tbl_site_other_records site_other_records_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_other_records ALTER COLUMN site_other_records_id SET DEFAULT nextval('public.tbl_site_other_records_site_other_records_id_seq'::regclass);


--
-- Name: tbl_site_preservation_status site_preservation_status_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_preservation_status ALTER COLUMN site_preservation_status_id SET DEFAULT nextval('public.tbl_site_preservation_status_site_preservation_status_id_seq'::regclass);


--
-- Name: tbl_site_references site_reference_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_references ALTER COLUMN site_reference_id SET DEFAULT nextval('public.tbl_site_references_site_reference_id_seq'::regclass);


--
-- Name: tbl_sites site_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sites ALTER COLUMN site_id SET DEFAULT nextval('public.tbl_sites_site_id_seq'::regclass);


--
-- Name: tbl_species_association_types association_type_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_species_association_types ALTER COLUMN association_type_id SET DEFAULT nextval('public.tbl_association_types_association_type_id_seq'::regclass);


--
-- Name: tbl_species_associations species_association_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_species_associations ALTER COLUMN species_association_id SET DEFAULT nextval('public.tbl_species_associations_species_association_id_seq'::regclass);


--
-- Name: tbl_taxa_common_names taxon_common_name_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_common_names ALTER COLUMN taxon_common_name_id SET DEFAULT nextval('public.tbl_taxa_common_names_taxon_common_name_id_seq'::regclass);


--
-- Name: tbl_taxa_images taxa_images_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_images ALTER COLUMN taxa_images_id SET DEFAULT nextval('public.tbl_taxa_images_taxa_images_id_seq'::regclass);


--
-- Name: tbl_taxa_measured_attributes measured_attribute_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_measured_attributes ALTER COLUMN measured_attribute_id SET DEFAULT nextval('public.tbl_taxa_measured_attributes_measured_attribute_id_seq'::regclass);


--
-- Name: tbl_taxa_reference_specimens taxa_reference_specimen_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_reference_specimens ALTER COLUMN taxa_reference_specimen_id SET DEFAULT nextval('public.tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq'::regclass);


--
-- Name: tbl_taxa_seasonality seasonality_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_seasonality ALTER COLUMN seasonality_id SET DEFAULT nextval('public.tbl_taxa_seasonality_seasonality_id_seq'::regclass);


--
-- Name: tbl_taxa_synonyms synonym_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_synonyms ALTER COLUMN synonym_id SET DEFAULT nextval('public.tbl_taxa_synonyms_synonym_id_seq'::regclass);


--
-- Name: tbl_taxa_tree_authors author_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_tree_authors ALTER COLUMN author_id SET DEFAULT nextval('public.tbl_taxa_tree_authors_author_id_seq'::regclass);


--
-- Name: tbl_taxa_tree_families family_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_tree_families ALTER COLUMN family_id SET DEFAULT nextval('public.tbl_taxa_tree_families_family_id_seq'::regclass);


--
-- Name: tbl_taxa_tree_genera genus_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_tree_genera ALTER COLUMN genus_id SET DEFAULT nextval('public.tbl_taxa_tree_genera_genus_id_seq'::regclass);


--
-- Name: tbl_taxa_tree_master taxon_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_tree_master ALTER COLUMN taxon_id SET DEFAULT nextval('public.tbl_taxa_tree_master_taxon_id_seq'::regclass);


--
-- Name: tbl_taxa_tree_orders order_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_tree_orders ALTER COLUMN order_id SET DEFAULT nextval('public.tbl_taxa_tree_orders_order_id_seq'::regclass);


--
-- Name: tbl_taxonomic_order taxonomic_order_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxonomic_order ALTER COLUMN taxonomic_order_id SET DEFAULT nextval('public.tbl_taxonomic_order_taxonomic_order_id_seq'::regclass);


--
-- Name: tbl_taxonomic_order_biblio taxonomic_order_biblio_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxonomic_order_biblio ALTER COLUMN taxonomic_order_biblio_id SET DEFAULT nextval('public.tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq'::regclass);


--
-- Name: tbl_taxonomic_order_systems taxonomic_order_system_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxonomic_order_systems ALTER COLUMN taxonomic_order_system_id SET DEFAULT nextval('public.tbl_taxonomic_order_systems_taxonomic_order_system_id_seq'::regclass);


--
-- Name: tbl_taxonomy_notes taxonomy_notes_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxonomy_notes ALTER COLUMN taxonomy_notes_id SET DEFAULT nextval('public.tbl_taxonomy_notes_taxonomy_notes_id_seq'::regclass);


--
-- Name: tbl_tephra_dates tephra_date_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_tephra_dates ALTER COLUMN tephra_date_id SET DEFAULT nextval('public.tbl_tephra_dates_tephra_date_id_seq'::regclass);


--
-- Name: tbl_tephra_refs tephra_ref_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_tephra_refs ALTER COLUMN tephra_ref_id SET DEFAULT nextval('public.tbl_tephra_refs_tephra_ref_id_seq'::regclass);


--
-- Name: tbl_tephras tephra_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_tephras ALTER COLUMN tephra_id SET DEFAULT nextval('public.tbl_tephras_tephra_id_seq'::regclass);


--
-- Name: tbl_text_biology biology_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_text_biology ALTER COLUMN biology_id SET DEFAULT nextval('public.tbl_text_biology_biology_id_seq'::regclass);


--
-- Name: tbl_text_distribution distribution_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_text_distribution ALTER COLUMN distribution_id SET DEFAULT nextval('public.tbl_text_distribution_distribution_id_seq'::regclass);


--
-- Name: tbl_text_identification_keys key_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_text_identification_keys ALTER COLUMN key_id SET DEFAULT nextval('public.tbl_text_identification_keys_key_id_seq'::regclass);


--
-- Name: tbl_units unit_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_units ALTER COLUMN unit_id SET DEFAULT nextval('public.tbl_units_unit_id_seq'::regclass);


--
-- Name: tbl_years_types years_type_id; Type: DEFAULT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_years_types ALTER COLUMN years_type_id SET DEFAULT nextval('public.tbl_years_types_years_type_id_seq'::regclass);


--
-- Name: tbl_project_stages dataset_stage_id; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_project_stages
    ADD CONSTRAINT dataset_stage_id PRIMARY KEY (project_stage_id);


--
-- Name: tbl_mcr_summary_data key_mcr_summary_data_taxon_id; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_mcr_summary_data
    ADD CONSTRAINT key_mcr_summary_data_taxon_id UNIQUE (taxon_id);


--
-- Name: tbl_abundance_elements pk_abundance_elements; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_abundance_elements
    ADD CONSTRAINT pk_abundance_elements PRIMARY KEY (abundance_element_id);


--
-- Name: tbl_abundance_ident_levels pk_abundance_ident_levels; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_abundance_ident_levels
    ADD CONSTRAINT pk_abundance_ident_levels PRIMARY KEY (abundance_ident_level_id);


--
-- Name: tbl_abundance_modifications pk_abundance_modifications; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_abundance_modifications
    ADD CONSTRAINT pk_abundance_modifications PRIMARY KEY (abundance_modification_id);


--
-- Name: tbl_abundances pk_abundances; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_abundances
    ADD CONSTRAINT pk_abundances PRIMARY KEY (abundance_id);


--
-- Name: tbl_activity_types pk_activity_types; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_activity_types
    ADD CONSTRAINT pk_activity_types PRIMARY KEY (activity_type_id);


--
-- Name: tbl_aggregate_datasets pk_aggregate_datasets; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_aggregate_datasets
    ADD CONSTRAINT pk_aggregate_datasets PRIMARY KEY (aggregate_dataset_id);


--
-- Name: tbl_aggregate_order_types pk_aggregate_order_types; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_aggregate_order_types
    ADD CONSTRAINT pk_aggregate_order_types PRIMARY KEY (aggregate_order_type_id);


--
-- Name: tbl_aggregate_sample_ages pk_aggregate_sample_ages; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_aggregate_sample_ages
    ADD CONSTRAINT pk_aggregate_sample_ages PRIMARY KEY (aggregate_sample_age_id);


--
-- Name: tbl_aggregate_samples pk_aggregate_samples; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_aggregate_samples
    ADD CONSTRAINT pk_aggregate_samples PRIMARY KEY (aggregate_sample_id);


--
-- Name: tbl_alt_ref_types pk_alt_ref_types; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_alt_ref_types
    ADD CONSTRAINT pk_alt_ref_types PRIMARY KEY (alt_ref_type_id);


--
-- Name: tbl_analysis_entities pk_analysis_entities; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_analysis_entities
    ADD CONSTRAINT pk_analysis_entities PRIMARY KEY (analysis_entity_id);


--
-- Name: tbl_biblio pk_biblio; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_biblio
    ADD CONSTRAINT pk_biblio PRIMARY KEY (biblio_id);


--
-- Name: tbl_chron_control_types pk_chron_control_types; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_chron_control_types
    ADD CONSTRAINT pk_chron_control_types PRIMARY KEY (chron_control_type_id);


--
-- Name: tbl_chron_controls pk_chron_controls; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_chron_controls
    ADD CONSTRAINT pk_chron_controls PRIMARY KEY (chron_control_id);


--
-- Name: tbl_chronologies pk_chronologies; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_chronologies
    ADD CONSTRAINT pk_chronologies PRIMARY KEY (chronology_id);


--
-- Name: tbl_colours pk_colours; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_colours
    ADD CONSTRAINT pk_colours PRIMARY KEY (colour_id);


--
-- Name: tbl_contact_types pk_contact_types; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_contact_types
    ADD CONSTRAINT pk_contact_types PRIMARY KEY (contact_type_id);


--
-- Name: tbl_contacts pk_contacts; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_contacts
    ADD CONSTRAINT pk_contacts PRIMARY KEY (contact_id);


--
-- Name: tbl_data_type_groups pk_data_type_groups; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_data_type_groups
    ADD CONSTRAINT pk_data_type_groups PRIMARY KEY (data_type_group_id);


--
-- Name: tbl_dataset_contacts pk_dataset_contacts; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dataset_contacts
    ADD CONSTRAINT pk_dataset_contacts PRIMARY KEY (dataset_contact_id);


--
-- Name: tbl_dataset_masters pk_dataset_masters; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dataset_masters
    ADD CONSTRAINT pk_dataset_masters PRIMARY KEY (master_set_id);


--
-- Name: tbl_dataset_submission_types pk_dataset_submission_types; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dataset_submission_types
    ADD CONSTRAINT pk_dataset_submission_types PRIMARY KEY (submission_type_id);


--
-- Name: tbl_dataset_submissions pk_dataset_submissions; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dataset_submissions
    ADD CONSTRAINT pk_dataset_submissions PRIMARY KEY (dataset_submission_id);


--
-- Name: tbl_datasets pk_datasets; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_datasets
    ADD CONSTRAINT pk_datasets PRIMARY KEY (dataset_id);


--
-- Name: tbl_dating_labs pk_dating_labs; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dating_labs
    ADD CONSTRAINT pk_dating_labs PRIMARY KEY (dating_lab_id);


--
-- Name: tbl_dimensions pk_dimensions; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dimensions
    ADD CONSTRAINT pk_dimensions PRIMARY KEY (dimension_id);


--
-- Name: tbl_ecocode_definitions pk_ecocode_definitions; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_ecocode_definitions
    ADD CONSTRAINT pk_ecocode_definitions PRIMARY KEY (ecocode_definition_id);


--
-- Name: tbl_ecocode_groups pk_ecocode_groups; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_ecocode_groups
    ADD CONSTRAINT pk_ecocode_groups PRIMARY KEY (ecocode_group_id);


--
-- Name: tbl_ecocode_systems pk_ecocode_systems; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_ecocode_systems
    ADD CONSTRAINT pk_ecocode_systems PRIMARY KEY (ecocode_system_id);


--
-- Name: tbl_ecocodes pk_ecocodes; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_ecocodes
    ADD CONSTRAINT pk_ecocodes PRIMARY KEY (ecocode_id);


--
-- Name: tbl_feature_types pk_feature_type_id; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_feature_types
    ADD CONSTRAINT pk_feature_type_id PRIMARY KEY (feature_type_id);


--
-- Name: tbl_features pk_features; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_features
    ADD CONSTRAINT pk_features PRIMARY KEY (feature_id);


--
-- Name: tbl_geochron_refs pk_geochron_refs; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_geochron_refs
    ADD CONSTRAINT pk_geochron_refs PRIMARY KEY (geochron_ref_id);


--
-- Name: tbl_geochronology pk_geochronology; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_geochronology
    ADD CONSTRAINT pk_geochronology PRIMARY KEY (geochron_id);


--
-- Name: tbl_horizons pk_horizons; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_horizons
    ADD CONSTRAINT pk_horizons PRIMARY KEY (horizon_id);


--
-- Name: tbl_identification_levels pk_identification_levels; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_identification_levels
    ADD CONSTRAINT pk_identification_levels PRIMARY KEY (identification_level_id);


--
-- Name: tbl_image_types pk_image_types; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_image_types
    ADD CONSTRAINT pk_image_types PRIMARY KEY (image_type_id);


--
-- Name: tbl_imported_taxa_replacements pk_imported_taxa_replacements; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_imported_taxa_replacements
    ADD CONSTRAINT pk_imported_taxa_replacements PRIMARY KEY (imported_taxa_replacement_id);


--
-- Name: tbl_languages pk_languages; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_languages
    ADD CONSTRAINT pk_languages PRIMARY KEY (language_id);


--
-- Name: tbl_lithology pk_lithologies; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_lithology
    ADD CONSTRAINT pk_lithologies PRIMARY KEY (lithology_id);


--
-- Name: tbl_location_types pk_location_types; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_location_types
    ADD CONSTRAINT pk_location_types PRIMARY KEY (location_type_id);


--
-- Name: tbl_locations pk_locations; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_locations
    ADD CONSTRAINT pk_locations PRIMARY KEY (location_id);


--
-- Name: tbl_mcr_names pk_mcr_names; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_mcr_names
    ADD CONSTRAINT pk_mcr_names PRIMARY KEY (taxon_id);


--
-- Name: tbl_mcr_summary_data pk_mcr_summary_data; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_mcr_summary_data
    ADD CONSTRAINT pk_mcr_summary_data PRIMARY KEY (mcr_summary_data_id);


--
-- Name: tbl_mcrdata_birmbeetledat pk_mcrdata_birmbeetledat; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_mcrdata_birmbeetledat
    ADD CONSTRAINT pk_mcrdata_birmbeetledat PRIMARY KEY (mcrdata_birmbeetledat_id);


--
-- Name: tbl_measured_values pk_measured_values; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_measured_values
    ADD CONSTRAINT pk_measured_values PRIMARY KEY (measured_value_id);


--
-- Name: tbl_measured_value_dimensions pk_measured_weights; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_measured_value_dimensions
    ADD CONSTRAINT pk_measured_weights PRIMARY KEY (measured_value_dimension_id);


--
-- Name: tbl_method_groups pk_method_groups; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_method_groups
    ADD CONSTRAINT pk_method_groups PRIMARY KEY (method_group_id);


--
-- Name: tbl_methods pk_methods; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_methods
    ADD CONSTRAINT pk_methods PRIMARY KEY (method_id);


--
-- Name: tbl_modification_types pk_modification_types; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_modification_types
    ADD CONSTRAINT pk_modification_types PRIMARY KEY (modification_type_id);


--
-- Name: tbl_physical_samples pk_physical_samples; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_physical_samples
    ADD CONSTRAINT pk_physical_samples PRIMARY KEY (physical_sample_id);


--
-- Name: tbl_project_types pk_project_type_id; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_project_types
    ADD CONSTRAINT pk_project_type_id PRIMARY KEY (project_type_id);


--
-- Name: tbl_projects pk_projects; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_projects
    ADD CONSTRAINT pk_projects PRIMARY KEY (project_id);


--
-- Name: tbl_rdb pk_rdb; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_rdb
    ADD CONSTRAINT pk_rdb PRIMARY KEY (rdb_id);


--
-- Name: tbl_rdb_codes pk_rdb_codes; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_rdb_codes
    ADD CONSTRAINT pk_rdb_codes PRIMARY KEY (rdb_code_id);


--
-- Name: tbl_rdb_systems pk_rdb_systems; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_rdb_systems
    ADD CONSTRAINT pk_rdb_systems PRIMARY KEY (rdb_system_id);


--
-- Name: tbl_record_types pk_record_types; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_record_types
    ADD CONSTRAINT pk_record_types PRIMARY KEY (record_type_id);


--
-- Name: tbl_relative_age_refs pk_relative_age_refs; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_relative_age_refs
    ADD CONSTRAINT pk_relative_age_refs PRIMARY KEY (relative_age_ref_id);


--
-- Name: tbl_relative_ages pk_relative_ages; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_relative_ages
    ADD CONSTRAINT pk_relative_ages PRIMARY KEY (relative_age_id);


--
-- Name: tbl_relative_dates pk_relative_dates; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_relative_dates
    ADD CONSTRAINT pk_relative_dates PRIMARY KEY (relative_date_id);


--
-- Name: tbl_analysis_entity_ages pk_sample_ages; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_analysis_entity_ages
    ADD CONSTRAINT pk_sample_ages PRIMARY KEY (analysis_entity_age_id);


--
-- Name: tbl_sample_alt_refs pk_sample_alt_refs; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_alt_refs
    ADD CONSTRAINT pk_sample_alt_refs PRIMARY KEY (sample_alt_ref_id);


--
-- Name: tbl_sample_colours pk_sample_colours; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_colours
    ADD CONSTRAINT pk_sample_colours PRIMARY KEY (sample_colour_id);


--
-- Name: tbl_sample_dimensions pk_sample_dimensions; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_dimensions
    ADD CONSTRAINT pk_sample_dimensions PRIMARY KEY (sample_dimension_id);


--
-- Name: tbl_sample_group_descriptions pk_sample_group_description_id; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_descriptions
    ADD CONSTRAINT pk_sample_group_description_id PRIMARY KEY (sample_group_description_id);


--
-- Name: tbl_sample_group_dimensions pk_sample_group_dimensions; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_dimensions
    ADD CONSTRAINT pk_sample_group_dimensions PRIMARY KEY (sample_group_dimension_id);


--
-- Name: tbl_sample_group_images pk_sample_group_images; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_images
    ADD CONSTRAINT pk_sample_group_images PRIMARY KEY (sample_group_image_id);


--
-- Name: tbl_sample_group_notes pk_sample_group_note_id; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_notes
    ADD CONSTRAINT pk_sample_group_note_id PRIMARY KEY (sample_group_note_id);


--
-- Name: tbl_sample_group_references pk_sample_group_references; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_references
    ADD CONSTRAINT pk_sample_group_references PRIMARY KEY (sample_group_reference_id);


--
-- Name: tbl_sample_group_sampling_contexts pk_sample_group_sampling_contexts; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_sampling_contexts
    ADD CONSTRAINT pk_sample_group_sampling_contexts PRIMARY KEY (sampling_context_id);


--
-- Name: tbl_sample_groups pk_sample_groups; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_groups
    ADD CONSTRAINT pk_sample_groups PRIMARY KEY (sample_group_id);


--
-- Name: tbl_sample_horizons pk_sample_horizons; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_horizons
    ADD CONSTRAINT pk_sample_horizons PRIMARY KEY (sample_horizon_id);


--
-- Name: tbl_sample_images pk_sample_images; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_images
    ADD CONSTRAINT pk_sample_images PRIMARY KEY (sample_image_id);


--
-- Name: tbl_sample_notes pk_sample_notes; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_notes
    ADD CONSTRAINT pk_sample_notes PRIMARY KEY (sample_note_id);


--
-- Name: tbl_sample_types pk_sample_types; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_types
    ADD CONSTRAINT pk_sample_types PRIMARY KEY (sample_type_id);


--
-- Name: tbl_data_types pk_samplegroup_data_types; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_data_types
    ADD CONSTRAINT pk_samplegroup_data_types PRIMARY KEY (data_type_id);


--
-- Name: tbl_season_types pk_season_types; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_season_types
    ADD CONSTRAINT pk_season_types PRIMARY KEY (season_type_id);


--
-- Name: tbl_seasons pk_seasons; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_seasons
    ADD CONSTRAINT pk_seasons PRIMARY KEY (season_id);


--
-- Name: tbl_site_images pk_site_images; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_images
    ADD CONSTRAINT pk_site_images PRIMARY KEY (site_image_id);


--
-- Name: tbl_site_locations pk_site_location; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_locations
    ADD CONSTRAINT pk_site_location PRIMARY KEY (site_location_id);


--
-- Name: tbl_site_other_records pk_site_other_records; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_other_records
    ADD CONSTRAINT pk_site_other_records PRIMARY KEY (site_other_records_id);


--
-- Name: tbl_site_preservation_status pk_site_preservation_status; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_preservation_status
    ADD CONSTRAINT pk_site_preservation_status PRIMARY KEY (site_preservation_status_id);


--
-- Name: tbl_site_references pk_site_references; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_references
    ADD CONSTRAINT pk_site_references PRIMARY KEY (site_reference_id);


--
-- Name: tbl_site_natgridrefs pk_sitenatgridrefs; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_natgridrefs
    ADD CONSTRAINT pk_sitenatgridrefs PRIMARY KEY (site_natgridref_id);


--
-- Name: tbl_sites pk_sites; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sites
    ADD CONSTRAINT pk_sites PRIMARY KEY (site_id);


--
-- Name: tbl_species_associations pk_species_associations; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_species_associations
    ADD CONSTRAINT pk_species_associations PRIMARY KEY (species_association_id);


--
-- Name: tbl_taxa_common_names pk_taxa_common_names; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_common_names
    ADD CONSTRAINT pk_taxa_common_names PRIMARY KEY (taxon_common_name_id);


--
-- Name: tbl_taxa_measured_attributes pk_taxa_measured_attributes; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_measured_attributes
    ADD CONSTRAINT pk_taxa_measured_attributes PRIMARY KEY (measured_attribute_id);


--
-- Name: tbl_taxa_seasonality pk_taxa_seasonality; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_seasonality
    ADD CONSTRAINT pk_taxa_seasonality PRIMARY KEY (seasonality_id);


--
-- Name: tbl_taxa_synonyms pk_taxa_synonyms; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_synonyms
    ADD CONSTRAINT pk_taxa_synonyms PRIMARY KEY (synonym_id);


--
-- Name: tbl_taxa_tree_authors pk_taxa_tree_authors; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_tree_authors
    ADD CONSTRAINT pk_taxa_tree_authors PRIMARY KEY (author_id);


--
-- Name: tbl_taxa_tree_families pk_taxa_tree_families; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_tree_families
    ADD CONSTRAINT pk_taxa_tree_families PRIMARY KEY (family_id);


--
-- Name: tbl_taxa_tree_genera pk_taxa_tree_genera; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_tree_genera
    ADD CONSTRAINT pk_taxa_tree_genera PRIMARY KEY (genus_id);


--
-- Name: tbl_taxa_tree_master pk_taxa_tree_master; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_tree_master
    ADD CONSTRAINT pk_taxa_tree_master PRIMARY KEY (taxon_id);


--
-- Name: tbl_taxa_tree_orders pk_taxa_tree_orders; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_tree_orders
    ADD CONSTRAINT pk_taxa_tree_orders PRIMARY KEY (order_id);


--
-- Name: tbl_taxonomic_order pk_taxonomic_order; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxonomic_order
    ADD CONSTRAINT pk_taxonomic_order PRIMARY KEY (taxonomic_order_id);


--
-- Name: tbl_taxonomic_order_biblio pk_taxonomic_order_biblio; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxonomic_order_biblio
    ADD CONSTRAINT pk_taxonomic_order_biblio PRIMARY KEY (taxonomic_order_biblio_id);


--
-- Name: tbl_taxonomic_order_systems pk_taxonomic_order_systems; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxonomic_order_systems
    ADD CONSTRAINT pk_taxonomic_order_systems PRIMARY KEY (taxonomic_order_system_id);


--
-- Name: tbl_taxonomy_notes pk_taxonomy_notes; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxonomy_notes
    ADD CONSTRAINT pk_taxonomy_notes PRIMARY KEY (taxonomy_notes_id);


--
-- Name: tbl_tephra_dates pk_tephra_dates; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_tephra_dates
    ADD CONSTRAINT pk_tephra_dates PRIMARY KEY (tephra_date_id);


--
-- Name: tbl_tephra_refs pk_tephra_refs; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_tephra_refs
    ADD CONSTRAINT pk_tephra_refs PRIMARY KEY (tephra_ref_id);


--
-- Name: tbl_tephras pk_tephras; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_tephras
    ADD CONSTRAINT pk_tephras PRIMARY KEY (tephra_id);


--
-- Name: tbl_text_biology pk_text_biology; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_text_biology
    ADD CONSTRAINT pk_text_biology PRIMARY KEY (biology_id);


--
-- Name: tbl_text_distribution pk_text_distribution; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_text_distribution
    ADD CONSTRAINT pk_text_distribution PRIMARY KEY (distribution_id);


--
-- Name: tbl_text_identification_keys pk_text_identification_keys; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_text_identification_keys
    ADD CONSTRAINT pk_text_identification_keys PRIMARY KEY (key_id);


--
-- Name: tbl_units pk_units; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_units
    ADD CONSTRAINT pk_units PRIMARY KEY (unit_id);


--
-- Name: tbl_updates_log pk_updates_log; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_updates_log
    ADD CONSTRAINT pk_updates_log PRIMARY KEY (updates_log_id);


--
-- Name: tbl_age_types tbl_age_types_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_age_types
    ADD CONSTRAINT tbl_age_types_pkey PRIMARY KEY (age_type_id);


--
-- Name: tbl_analysis_entity_dimensions tbl_analysis_entity_dimensions_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_analysis_entity_dimensions
    ADD CONSTRAINT tbl_analysis_entity_dimensions_pkey PRIMARY KEY (analysis_entity_dimension_id);


--
-- Name: tbl_analysis_entity_prep_methods tbl_analysis_entity_prep_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_analysis_entity_prep_methods
    ADD CONSTRAINT tbl_analysis_entity_prep_methods_pkey PRIMARY KEY (analysis_entity_prep_method_id);


--
-- Name: tbl_species_association_types tbl_association_types_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_species_association_types
    ADD CONSTRAINT tbl_association_types_pkey PRIMARY KEY (association_type_id);


--
-- Name: tbl_ceramics_lookup tbl_ceramics_lookup_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_ceramics_lookup
    ADD CONSTRAINT tbl_ceramics_lookup_pkey PRIMARY KEY (ceramics_lookup_id);


--
-- Name: tbl_ceramics_measurements tbl_ceramics_measurements_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_ceramics_measurements
    ADD CONSTRAINT tbl_ceramics_measurements_pkey PRIMARY KEY (ceramics_measurement_id);


--
-- Name: tbl_ceramics tbl_ceramics_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_ceramics
    ADD CONSTRAINT tbl_ceramics_pkey PRIMARY KEY (ceramics_id);


--
-- Name: tbl_coordinate_method_dimensions tbl_coordinate_method_dimensions_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_coordinate_method_dimensions
    ADD CONSTRAINT tbl_coordinate_method_dimensions_pkey PRIMARY KEY (coordinate_method_dimension_id);


--
-- Name: tbl_dating_material tbl_dating_material_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dating_material
    ADD CONSTRAINT tbl_dating_material_pkey PRIMARY KEY (dating_material_id);


--
-- Name: tbl_dating_uncertainty tbl_dating_uncertainty_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dating_uncertainty
    ADD CONSTRAINT tbl_dating_uncertainty_pkey PRIMARY KEY (dating_uncertainty_id);


--
-- Name: tbl_dendro_date_notes tbl_dendro_date_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dendro_date_notes
    ADD CONSTRAINT tbl_dendro_date_notes_pkey PRIMARY KEY (dendro_date_note_id);


--
-- Name: tbl_dendro_dates tbl_dendro_dates_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dendro_dates
    ADD CONSTRAINT tbl_dendro_dates_pkey PRIMARY KEY (dendro_date_id);


--
-- Name: tbl_dendro_lookup tbl_dendro_lookup_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dendro_lookup
    ADD CONSTRAINT tbl_dendro_lookup_pkey PRIMARY KEY (dendro_lookup_id);


--
-- Name: tbl_dendro_measurements tbl_dendro_measurements_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dendro_measurements
    ADD CONSTRAINT tbl_dendro_measurements_pkey PRIMARY KEY (dendro_measurement_id);


--
-- Name: tbl_dendro tbl_dendro_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dendro
    ADD CONSTRAINT tbl_dendro_pkey PRIMARY KEY (dendro_id);


--
-- Name: tbl_error_uncertainties tbl_error_uncertainties_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_error_uncertainties
    ADD CONSTRAINT tbl_error_uncertainties_pkey PRIMARY KEY (error_uncertainty_id);


--
-- Name: tbl_physical_sample_features tbl_physical_sample_features_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_physical_sample_features
    ADD CONSTRAINT tbl_physical_sample_features_pkey PRIMARY KEY (physical_sample_feature_id);


--
-- Name: tbl_relative_age_types tbl_relative_age_types_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_relative_age_types
    ADD CONSTRAINT tbl_relative_age_types_pkey PRIMARY KEY (relative_age_type_id);


--
-- Name: tbl_sample_coordinates tbl_sample_coordinates_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_coordinates
    ADD CONSTRAINT tbl_sample_coordinates_pkey PRIMARY KEY (sample_coordinate_id);


--
-- Name: tbl_sample_description_sample_group_contexts tbl_sample_description_sample_group_contexts_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_description_sample_group_contexts
    ADD CONSTRAINT tbl_sample_description_sample_group_contexts_pkey PRIMARY KEY (sample_description_sample_group_context_id);


--
-- Name: tbl_sample_description_types tbl_sample_description_types_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_description_types
    ADD CONSTRAINT tbl_sample_description_types_pkey PRIMARY KEY (sample_description_type_id);


--
-- Name: tbl_sample_descriptions tbl_sample_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_descriptions
    ADD CONSTRAINT tbl_sample_descriptions_pkey PRIMARY KEY (sample_description_id);


--
-- Name: tbl_sample_group_coordinates tbl_sample_group_coordinates_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_coordinates
    ADD CONSTRAINT tbl_sample_group_coordinates_pkey PRIMARY KEY (sample_group_position_id);


--
-- Name: tbl_sample_group_description_type_sampling_contexts tbl_sample_group_description_type_sample_contexts_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_description_type_sampling_contexts
    ADD CONSTRAINT tbl_sample_group_description_type_sample_contexts_pkey PRIMARY KEY (sample_group_description_type_sampling_context_id);


--
-- Name: tbl_sample_group_description_types tbl_sample_group_description_types_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_description_types
    ADD CONSTRAINT tbl_sample_group_description_types_pkey PRIMARY KEY (sample_group_description_type_id);


--
-- Name: tbl_sample_location_type_sampling_contexts tbl_sample_location_sampling_contexts_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_location_type_sampling_contexts
    ADD CONSTRAINT tbl_sample_location_sampling_contexts_pkey PRIMARY KEY (sample_location_type_sampling_context_id);


--
-- Name: tbl_sample_location_types tbl_sample_location_types_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_location_types
    ADD CONSTRAINT tbl_sample_location_types_pkey PRIMARY KEY (sample_location_type_id);


--
-- Name: tbl_sample_locations tbl_sample_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_locations
    ADD CONSTRAINT tbl_sample_locations_pkey PRIMARY KEY (sample_location_id);


--
-- Name: tbl_season_or_qualifier tbl_season_or_qualifier_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_season_or_qualifier
    ADD CONSTRAINT tbl_season_or_qualifier_pkey PRIMARY KEY (season_or_qualifier_id);


--
-- Name: tbl_taxa_images tbl_taxa_images_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_images
    ADD CONSTRAINT tbl_taxa_images_pkey PRIMARY KEY (taxa_images_id);


--
-- Name: tbl_taxa_reference_specimens tbl_taxa_reference_specimens_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_reference_specimens
    ADD CONSTRAINT tbl_taxa_reference_specimens_pkey PRIMARY KEY (taxa_reference_specimen_id);


--
-- Name: tbl_years_types tbl_years_types_pkey; Type: CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_years_types
    ADD CONSTRAINT tbl_years_types_pkey PRIMARY KEY (years_type_id);


--
-- Name: idx_biblio_id; Type: INDEX; Schema: public; Owner: sead_master
--

CREATE INDEX idx_biblio_id ON public.tbl_sample_group_references USING btree (biblio_id);


--
-- Name: idx_sample_group_id; Type: INDEX; Schema: public; Owner: sead_master
--

CREATE INDEX idx_sample_group_id ON public.tbl_sample_group_references USING btree (sample_group_id);


--
-- Name: idx_tbl_physical_sample_features_feature_id; Type: INDEX; Schema: public; Owner: sead_master
--

CREATE INDEX idx_tbl_physical_sample_features_feature_id ON public.tbl_physical_sample_features USING btree (feature_id);


--
-- Name: tbl_ecocode_groups_idx_ecocodesystemid; Type: INDEX; Schema: public; Owner: sead_master
--

CREATE INDEX tbl_ecocode_groups_idx_ecocodesystemid ON public.tbl_ecocode_groups USING btree (ecocode_system_id);


--
-- Name: tbl_ecocode_groups_idx_label; Type: INDEX; Schema: public; Owner: sead_master
--

CREATE INDEX tbl_ecocode_groups_idx_label ON public.tbl_ecocode_groups USING btree (name);


--
-- Name: tbl_ecocode_systems_biblioid; Type: INDEX; Schema: public; Owner: sead_master
--

CREATE INDEX tbl_ecocode_systems_biblioid ON public.tbl_ecocode_systems USING btree (biblio_id);


--
-- Name: tbl_ecocode_systems_ecocodegroupid; Type: INDEX; Schema: public; Owner: sead_master
--

CREATE INDEX tbl_ecocode_systems_ecocodegroupid ON public.tbl_ecocode_systems USING btree (name);


--
-- Name: tbl_languages_language_id; Type: INDEX; Schema: public; Owner: sead_master
--

CREATE INDEX tbl_languages_language_id ON public.tbl_languages USING btree (language_id);


--
-- Name: tbl_taxa_tree_authors_name; Type: INDEX; Schema: public; Owner: sead_master
--

CREATE INDEX tbl_taxa_tree_authors_name ON public.tbl_taxa_tree_authors USING btree (author_name);


--
-- Name: tbl_taxa_tree_families_name; Type: INDEX; Schema: public; Owner: sead_master
--

CREATE INDEX tbl_taxa_tree_families_name ON public.tbl_taxa_tree_families USING btree (family_name);


--
-- Name: tbl_taxa_tree_families_order_id; Type: INDEX; Schema: public; Owner: sead_master
--

CREATE INDEX tbl_taxa_tree_families_order_id ON public.tbl_taxa_tree_families USING btree (order_id);


--
-- Name: tbl_taxa_tree_genera_family_id; Type: INDEX; Schema: public; Owner: sead_master
--

CREATE INDEX tbl_taxa_tree_genera_family_id ON public.tbl_taxa_tree_genera USING btree (family_id);


--
-- Name: tbl_taxa_tree_genera_name; Type: INDEX; Schema: public; Owner: sead_master
--

CREATE INDEX tbl_taxa_tree_genera_name ON public.tbl_taxa_tree_genera USING btree (genus_name);


--
-- Name: tbl_taxa_tree_orders_order_id; Type: INDEX; Schema: public; Owner: sead_master
--

CREATE INDEX tbl_taxa_tree_orders_order_id ON public.tbl_taxa_tree_orders USING btree (order_id);


--
-- Name: tbl_taxonomic_order_biblio_biblio_id; Type: INDEX; Schema: public; Owner: sead_master
--

CREATE INDEX tbl_taxonomic_order_biblio_biblio_id ON public.tbl_taxonomic_order_biblio USING btree (biblio_id);


--
-- Name: tbl_taxonomic_order_biblio_taxonomic_order_biblio_id; Type: INDEX; Schema: public; Owner: sead_master
--

CREATE INDEX tbl_taxonomic_order_biblio_taxonomic_order_biblio_id ON public.tbl_taxonomic_order_biblio USING btree (taxonomic_order_biblio_id);


--
-- Name: tbl_taxonomic_order_biblio_taxonomic_order_system_id; Type: INDEX; Schema: public; Owner: sead_master
--

CREATE INDEX tbl_taxonomic_order_biblio_taxonomic_order_system_id ON public.tbl_taxonomic_order_biblio USING btree (taxonomic_order_system_id);


--
-- Name: tbl_taxonomic_order_systems_taxonomic_system_id; Type: INDEX; Schema: public; Owner: sead_master
--

CREATE INDEX tbl_taxonomic_order_systems_taxonomic_system_id ON public.tbl_taxonomic_order_systems USING btree (taxonomic_order_system_id);


--
-- Name: tbl_taxonomic_order_taxon_id; Type: INDEX; Schema: public; Owner: sead_master
--

CREATE INDEX tbl_taxonomic_order_taxon_id ON public.tbl_taxonomic_order USING btree (taxon_id);


--
-- Name: tbl_taxonomic_order_taxonomic_code; Type: INDEX; Schema: public; Owner: sead_master
--

CREATE INDEX tbl_taxonomic_order_taxonomic_code ON public.tbl_taxonomic_order USING btree (taxonomic_code);


--
-- Name: tbl_taxonomic_order_taxonomic_order_id; Type: INDEX; Schema: public; Owner: sead_master
--

CREATE INDEX tbl_taxonomic_order_taxonomic_order_id ON public.tbl_taxonomic_order USING btree (taxonomic_order_id);


--
-- Name: tbl_taxonomic_order_taxonomic_system_id; Type: INDEX; Schema: public; Owner: sead_master
--

CREATE INDEX tbl_taxonomic_order_taxonomic_system_id ON public.tbl_taxonomic_order USING btree (taxonomic_order_system_id);


--
-- Name: tbl_abundance_elements audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_abundance_elements FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_abundance_ident_levels audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_abundance_ident_levels FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_abundance_modifications audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_abundance_modifications FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_abundances audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_abundances FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_activity_types audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_activity_types FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_age_types audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_age_types FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_aggregate_datasets audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_aggregate_datasets FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_aggregate_order_types audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_aggregate_order_types FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_aggregate_sample_ages audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_aggregate_sample_ages FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_aggregate_samples audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_aggregate_samples FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_alt_ref_types audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_alt_ref_types FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_analysis_entities audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_analysis_entities FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_analysis_entity_ages audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_analysis_entity_ages FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_analysis_entity_dimensions audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_analysis_entity_dimensions FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_analysis_entity_prep_methods audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_analysis_entity_prep_methods FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_biblio audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_biblio FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_biblio_original audit_trigger_row; Type: TRIGGER; Schema: public; Owner: clearinghouse_worker
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_biblio_original FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_ceramics audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_ceramics FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_ceramics_lookup audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_ceramics_lookup FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_ceramics_measurements audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_ceramics_measurements FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_chron_controls audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_chron_controls FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_chron_control_types audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_chron_control_types FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_chronologies audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_chronologies FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_colours audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_colours FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_contacts audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_contacts FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_contact_types audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_contact_types FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_coordinate_method_dimensions audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_coordinate_method_dimensions FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dataset_contacts audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_dataset_contacts FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dataset_masters audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_dataset_masters FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_datasets audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_datasets FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dataset_submissions audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_dataset_submissions FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dataset_submission_types audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_dataset_submission_types FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_data_type_groups audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_data_type_groups FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_data_types audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_data_types FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dating_labs audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_dating_labs FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dating_material audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_dating_material FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dating_uncertainty audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_dating_uncertainty FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dendro audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_dendro FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dendro_date_notes audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_dendro_date_notes FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dendro_dates audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_dendro_dates FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dendro_lookup audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_dendro_lookup FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dendro_measurements audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_dendro_measurements FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dimensions audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_dimensions FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_ecocode_definitions audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_ecocode_definitions FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_ecocode_groups audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_ecocode_groups FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_ecocodes audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_ecocodes FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_ecocode_systems audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_ecocode_systems FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_error_uncertainties audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_error_uncertainties FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_features audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_features FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_feature_types audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_feature_types FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_geochronology audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_geochronology FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_geochron_refs audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_geochron_refs FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_horizons audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_horizons FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_identification_levels audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_identification_levels FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_image_types audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_image_types FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_imported_taxa_replacements audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_imported_taxa_replacements FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_languages audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_languages FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_lithology audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_lithology FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_locations audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_locations FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_location_types audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_location_types FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_mcrdata_birmbeetledat audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_mcrdata_birmbeetledat FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_mcr_names audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_mcr_names FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_mcr_summary_data audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_mcr_summary_data FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_measured_value_dimensions audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_measured_value_dimensions FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_measured_values audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_measured_values FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_method_groups audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_method_groups FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_methods audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_methods FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_modification_types audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_modification_types FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_physical_sample_features audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_physical_sample_features FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_physical_samples audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_physical_samples FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_projects audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_projects FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_project_stages audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_project_stages FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_project_types audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_project_types FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_rdb audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_rdb FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_rdb_codes audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_rdb_codes FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_rdb_systems audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_rdb_systems FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_record_types audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_record_types FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_relative_age_refs audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_relative_age_refs FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_relative_ages audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_relative_ages FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_relative_age_types audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_relative_age_types FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_relative_dates audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_relative_dates FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_alt_refs audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_alt_refs FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_colours audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_colours FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_coordinates audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_coordinates FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_descriptions audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_descriptions FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_description_sample_group_contexts audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_description_sample_group_contexts FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_description_types audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_description_types FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_dimensions audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_dimensions FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_group_coordinates audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_group_coordinates FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_group_descriptions audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_group_descriptions FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_group_description_types audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_group_description_types FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_group_description_type_sampling_contexts audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_group_description_type_sampling_contexts FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_group_dimensions audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_group_dimensions FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_group_images audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_group_images FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_group_notes audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_group_notes FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_group_references audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_group_references FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_groups audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_groups FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_group_sampling_contexts audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_group_sampling_contexts FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_horizons audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_horizons FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_images audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_images FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_locations audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_locations FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_location_types audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_location_types FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_location_type_sampling_contexts audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_location_type_sampling_contexts FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_notes audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_notes FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_types audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sample_types FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_season_or_qualifier audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_season_or_qualifier FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_seasons audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_seasons FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_season_types audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_season_types FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_site_images audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_site_images FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_site_locations audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_site_locations FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_site_natgridrefs audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_site_natgridrefs FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_site_other_records audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_site_other_records FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_site_preservation_status audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_site_preservation_status FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_site_references audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_site_references FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sites audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_sites FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_species_associations audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_species_associations FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_species_association_types audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_species_association_types FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxa_common_names audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_taxa_common_names FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxa_images audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_taxa_images FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxa_measured_attributes audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_taxa_measured_attributes FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxa_reference_specimens audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_taxa_reference_specimens FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxa_seasonality audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_taxa_seasonality FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxa_synonyms audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_taxa_synonyms FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxa_tree_authors audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_taxa_tree_authors FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxa_tree_families audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_taxa_tree_families FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxa_tree_genera audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_taxa_tree_genera FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxa_tree_master audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_taxa_tree_master FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxa_tree_orders audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_taxa_tree_orders FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxonomic_order audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_taxonomic_order FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxonomic_order_biblio audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_taxonomic_order_biblio FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxonomic_order_systems audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_taxonomic_order_systems FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxonomy_notes audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_taxonomy_notes FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_tephra_dates audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_tephra_dates FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_tephra_refs audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_tephra_refs FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_tephras audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_tephras FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_text_biology audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_text_biology FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_text_distribution audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_text_distribution FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_text_identification_keys audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_text_identification_keys FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_units audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_units FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_updates_log audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_updates_log FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_years_types audit_trigger_row; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.tbl_years_types FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: v_json_array audit_trigger_row; Type: TRIGGER; Schema: public; Owner: clearinghouse_worker
--

CREATE TRIGGER audit_trigger_row AFTER INSERT OR DELETE OR UPDATE ON public.v_json_array FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_abundance_elements audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_abundance_elements FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_abundance_ident_levels audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_abundance_ident_levels FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_abundance_modifications audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_abundance_modifications FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_abundances audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_abundances FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_activity_types audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_activity_types FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_age_types audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_age_types FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_aggregate_datasets audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_aggregate_datasets FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_aggregate_order_types audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_aggregate_order_types FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_aggregate_sample_ages audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_aggregate_sample_ages FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_aggregate_samples audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_aggregate_samples FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_alt_ref_types audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_alt_ref_types FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_analysis_entities audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_analysis_entities FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_analysis_entity_ages audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_analysis_entity_ages FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_analysis_entity_dimensions audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_analysis_entity_dimensions FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_analysis_entity_prep_methods audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_analysis_entity_prep_methods FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_biblio audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_biblio FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_biblio_original audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: clearinghouse_worker
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_biblio_original FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_ceramics audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_ceramics FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_ceramics_lookup audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_ceramics_lookup FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_ceramics_measurements audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_ceramics_measurements FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_chron_controls audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_chron_controls FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_chron_control_types audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_chron_control_types FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_chronologies audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_chronologies FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_colours audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_colours FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_contacts audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_contacts FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_contact_types audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_contact_types FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_coordinate_method_dimensions audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_coordinate_method_dimensions FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dataset_contacts audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_dataset_contacts FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dataset_masters audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_dataset_masters FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_datasets audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_datasets FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dataset_submissions audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_dataset_submissions FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dataset_submission_types audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_dataset_submission_types FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_data_type_groups audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_data_type_groups FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_data_types audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_data_types FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dating_labs audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_dating_labs FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dating_material audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_dating_material FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dating_uncertainty audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_dating_uncertainty FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dendro audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_dendro FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dendro_date_notes audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_dendro_date_notes FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dendro_dates audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_dendro_dates FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dendro_lookup audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_dendro_lookup FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dendro_measurements audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_dendro_measurements FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_dimensions audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_dimensions FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_ecocode_definitions audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_ecocode_definitions FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_ecocode_groups audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_ecocode_groups FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_ecocodes audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_ecocodes FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_ecocode_systems audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_ecocode_systems FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_error_uncertainties audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_error_uncertainties FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_features audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_features FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_feature_types audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_feature_types FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_geochronology audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_geochronology FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_geochron_refs audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_geochron_refs FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_horizons audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_horizons FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_identification_levels audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_identification_levels FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_image_types audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_image_types FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_imported_taxa_replacements audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_imported_taxa_replacements FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_languages audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_languages FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_lithology audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_lithology FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_locations audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_locations FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_location_types audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_location_types FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_mcrdata_birmbeetledat audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_mcrdata_birmbeetledat FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_mcr_names audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_mcr_names FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_mcr_summary_data audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_mcr_summary_data FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_measured_value_dimensions audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_measured_value_dimensions FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_measured_values audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_measured_values FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_method_groups audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_method_groups FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_methods audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_methods FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_modification_types audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_modification_types FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_physical_sample_features audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_physical_sample_features FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_physical_samples audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_physical_samples FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_projects audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_projects FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_project_stages audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_project_stages FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_project_types audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_project_types FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_rdb audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_rdb FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_rdb_codes audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_rdb_codes FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_rdb_systems audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_rdb_systems FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_record_types audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_record_types FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_relative_age_refs audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_relative_age_refs FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_relative_ages audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_relative_ages FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_relative_age_types audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_relative_age_types FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_relative_dates audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_relative_dates FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_alt_refs audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_alt_refs FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_colours audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_colours FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_coordinates audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_coordinates FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_descriptions audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_descriptions FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_description_sample_group_contexts audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_description_sample_group_contexts FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_description_types audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_description_types FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_dimensions audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_dimensions FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_group_coordinates audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_group_coordinates FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_group_descriptions audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_group_descriptions FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_group_description_types audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_group_description_types FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_group_description_type_sampling_contexts audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_group_description_type_sampling_contexts FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_group_dimensions audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_group_dimensions FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_group_images audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_group_images FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_group_notes audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_group_notes FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_group_references audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_group_references FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_groups audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_groups FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_group_sampling_contexts audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_group_sampling_contexts FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_horizons audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_horizons FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_images audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_images FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_locations audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_locations FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_location_types audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_location_types FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_location_type_sampling_contexts audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_location_type_sampling_contexts FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_notes audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_notes FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sample_types audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sample_types FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_season_or_qualifier audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_season_or_qualifier FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_seasons audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_seasons FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_season_types audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_season_types FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_site_images audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_site_images FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_site_locations audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_site_locations FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_site_natgridrefs audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_site_natgridrefs FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_site_other_records audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_site_other_records FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_site_preservation_status audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_site_preservation_status FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_site_references audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_site_references FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_sites audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_sites FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_species_associations audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_species_associations FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_species_association_types audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_species_association_types FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxa_common_names audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_taxa_common_names FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxa_images audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_taxa_images FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxa_measured_attributes audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_taxa_measured_attributes FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxa_reference_specimens audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_taxa_reference_specimens FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxa_seasonality audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_taxa_seasonality FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxa_synonyms audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_taxa_synonyms FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxa_tree_authors audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_taxa_tree_authors FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxa_tree_families audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_taxa_tree_families FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxa_tree_genera audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_taxa_tree_genera FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxa_tree_master audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_taxa_tree_master FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxa_tree_orders audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_taxa_tree_orders FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxonomic_order audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_taxonomic_order FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxonomic_order_biblio audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_taxonomic_order_biblio FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxonomic_order_systems audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_taxonomic_order_systems FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_taxonomy_notes audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_taxonomy_notes FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_tephra_dates audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_tephra_dates FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_tephra_refs audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_tephra_refs FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_tephras audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_tephras FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_text_biology audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_text_biology FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_text_distribution audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_text_distribution FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_text_identification_keys audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_text_identification_keys FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_units audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_units FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_updates_log audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_updates_log FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_years_types audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: sead_master
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.tbl_years_types FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: v_json_array audit_trigger_stm; Type: TRIGGER; Schema: public; Owner: clearinghouse_worker
--

CREATE TRIGGER audit_trigger_stm AFTER TRUNCATE ON public.v_json_array FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('true');


--
-- Name: tbl_abundance_elements fk_abundance_elements_record_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_abundance_elements
    ADD CONSTRAINT fk_abundance_elements_record_type_id FOREIGN KEY (record_type_id) REFERENCES public.tbl_record_types(record_type_id) ON UPDATE CASCADE;


--
-- Name: tbl_abundance_ident_levels fk_abundance_ident_levels_abundance_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_abundance_ident_levels
    ADD CONSTRAINT fk_abundance_ident_levels_abundance_id FOREIGN KEY (abundance_id) REFERENCES public.tbl_abundances(abundance_id);


--
-- Name: tbl_abundance_ident_levels fk_abundance_ident_levels_identification_level_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_abundance_ident_levels
    ADD CONSTRAINT fk_abundance_ident_levels_identification_level_id FOREIGN KEY (identification_level_id) REFERENCES public.tbl_identification_levels(identification_level_id) ON UPDATE CASCADE;


--
-- Name: tbl_abundance_modifications fk_abundance_modifications_abundance_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_abundance_modifications
    ADD CONSTRAINT fk_abundance_modifications_abundance_id FOREIGN KEY (abundance_id) REFERENCES public.tbl_abundances(abundance_id) ON UPDATE CASCADE;


--
-- Name: tbl_abundance_modifications fk_abundance_modifications_modification_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_abundance_modifications
    ADD CONSTRAINT fk_abundance_modifications_modification_type_id FOREIGN KEY (modification_type_id) REFERENCES public.tbl_modification_types(modification_type_id) ON UPDATE CASCADE;


--
-- Name: tbl_abundances fk_abundances_abundance_elements_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_abundances
    ADD CONSTRAINT fk_abundances_abundance_elements_id FOREIGN KEY (abundance_element_id) REFERENCES public.tbl_abundance_elements(abundance_element_id) ON UPDATE CASCADE;


--
-- Name: tbl_abundances fk_abundances_analysis_entity_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_abundances
    ADD CONSTRAINT fk_abundances_analysis_entity_id FOREIGN KEY (analysis_entity_id) REFERENCES public.tbl_analysis_entities(analysis_entity_id) ON UPDATE CASCADE;


--
-- Name: tbl_abundances fk_abundances_taxon_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_abundances
    ADD CONSTRAINT fk_abundances_taxon_id FOREIGN KEY (taxon_id) REFERENCES public.tbl_taxa_tree_master(taxon_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbl_aggregate_samples fk_aggragate_samples_analysis_entity_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_aggregate_samples
    ADD CONSTRAINT fk_aggragate_samples_analysis_entity_id FOREIGN KEY (analysis_entity_id) REFERENCES public.tbl_analysis_entities(analysis_entity_id) ON UPDATE CASCADE;


--
-- Name: tbl_aggregate_datasets fk_aggregate_datasets_aggregate_order_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_aggregate_datasets
    ADD CONSTRAINT fk_aggregate_datasets_aggregate_order_type_id FOREIGN KEY (aggregate_order_type_id) REFERENCES public.tbl_aggregate_order_types(aggregate_order_type_id) ON UPDATE CASCADE;


--
-- Name: tbl_aggregate_datasets fk_aggregate_datasets_biblio_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_aggregate_datasets
    ADD CONSTRAINT fk_aggregate_datasets_biblio_id FOREIGN KEY (biblio_id) REFERENCES public.tbl_biblio(biblio_id) ON UPDATE CASCADE;


--
-- Name: tbl_aggregate_sample_ages fk_aggregate_sample_ages_aggregate_dataset_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_aggregate_sample_ages
    ADD CONSTRAINT fk_aggregate_sample_ages_aggregate_dataset_id FOREIGN KEY (aggregate_dataset_id) REFERENCES public.tbl_aggregate_datasets(aggregate_dataset_id) ON UPDATE CASCADE;


--
-- Name: tbl_aggregate_sample_ages fk_aggregate_sample_ages_analysis_entity_age_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_aggregate_sample_ages
    ADD CONSTRAINT fk_aggregate_sample_ages_analysis_entity_age_id FOREIGN KEY (analysis_entity_age_id) REFERENCES public.tbl_analysis_entity_ages(analysis_entity_age_id) ON UPDATE CASCADE;


--
-- Name: tbl_aggregate_samples fk_aggregate_samples_aggregate_dataset_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_aggregate_samples
    ADD CONSTRAINT fk_aggregate_samples_aggregate_dataset_id FOREIGN KEY (aggregate_dataset_id) REFERENCES public.tbl_aggregate_datasets(aggregate_dataset_id) ON UPDATE CASCADE;


--
-- Name: tbl_analysis_entities fk_analysis_entities_dataset_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_analysis_entities
    ADD CONSTRAINT fk_analysis_entities_dataset_id FOREIGN KEY (dataset_id) REFERENCES public.tbl_datasets(dataset_id) ON UPDATE CASCADE;


--
-- Name: tbl_analysis_entities fk_analysis_entities_physical_sample_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_analysis_entities
    ADD CONSTRAINT fk_analysis_entities_physical_sample_id FOREIGN KEY (physical_sample_id) REFERENCES public.tbl_physical_samples(physical_sample_id);


--
-- Name: tbl_analysis_entity_ages fk_analysis_entity_ages_analysis_entity_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_analysis_entity_ages
    ADD CONSTRAINT fk_analysis_entity_ages_analysis_entity_id FOREIGN KEY (analysis_entity_id) REFERENCES public.tbl_analysis_entities(analysis_entity_id) ON UPDATE CASCADE;


--
-- Name: tbl_analysis_entity_ages fk_analysis_entity_ages_chronology_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_analysis_entity_ages
    ADD CONSTRAINT fk_analysis_entity_ages_chronology_id FOREIGN KEY (chronology_id) REFERENCES public.tbl_chronologies(chronology_id) ON UPDATE CASCADE;


--
-- Name: tbl_analysis_entity_dimensions fk_analysis_entity_dimensions_analysis_entity_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_analysis_entity_dimensions
    ADD CONSTRAINT fk_analysis_entity_dimensions_analysis_entity_id FOREIGN KEY (analysis_entity_id) REFERENCES public.tbl_analysis_entities(analysis_entity_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbl_analysis_entity_dimensions fk_analysis_entity_dimensions_dimension_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_analysis_entity_dimensions
    ADD CONSTRAINT fk_analysis_entity_dimensions_dimension_id FOREIGN KEY (dimension_id) REFERENCES public.tbl_dimensions(dimension_id) ON UPDATE CASCADE;


--
-- Name: tbl_analysis_entity_prep_methods fk_analysis_entity_prep_methods_analysis_entity_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_analysis_entity_prep_methods
    ADD CONSTRAINT fk_analysis_entity_prep_methods_analysis_entity_id FOREIGN KEY (analysis_entity_id) REFERENCES public.tbl_analysis_entities(analysis_entity_id);


--
-- Name: tbl_analysis_entity_prep_methods fk_analysis_entity_prep_methods_method_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_analysis_entity_prep_methods
    ADD CONSTRAINT fk_analysis_entity_prep_methods_method_id FOREIGN KEY (method_id) REFERENCES public.tbl_methods(method_id);


--
-- Name: tbl_ceramics fk_ceramics_analysis_entity_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_ceramics
    ADD CONSTRAINT fk_ceramics_analysis_entity_id FOREIGN KEY (analysis_entity_id) REFERENCES public.tbl_analysis_entities(analysis_entity_id);


--
-- Name: tbl_ceramics fk_ceramics_ceramics_lookup_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_ceramics
    ADD CONSTRAINT fk_ceramics_ceramics_lookup_id FOREIGN KEY (ceramics_lookup_id) REFERENCES public.tbl_ceramics_lookup(ceramics_lookup_id);


--
-- Name: tbl_ceramics_lookup fk_ceramics_lookup_method_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_ceramics_lookup
    ADD CONSTRAINT fk_ceramics_lookup_method_id FOREIGN KEY (method_id) REFERENCES public.tbl_methods(method_id);


--
-- Name: tbl_ceramics_measurements fk_ceramics_measurements_method_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_ceramics_measurements
    ADD CONSTRAINT fk_ceramics_measurements_method_id FOREIGN KEY (method_id) REFERENCES public.tbl_methods(method_id);


--
-- Name: tbl_chron_controls fk_chron_controls_chron_control_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_chron_controls
    ADD CONSTRAINT fk_chron_controls_chron_control_type_id FOREIGN KEY (chron_control_type_id) REFERENCES public.tbl_chron_control_types(chron_control_type_id) ON UPDATE CASCADE;


--
-- Name: tbl_chron_controls fk_chron_controls_chronology_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_chron_controls
    ADD CONSTRAINT fk_chron_controls_chronology_id FOREIGN KEY (chronology_id) REFERENCES public.tbl_chronologies(chronology_id) ON UPDATE CASCADE;


--
-- Name: tbl_chronologies fk_chronologies_contact_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_chronologies
    ADD CONSTRAINT fk_chronologies_contact_id FOREIGN KEY (contact_id) REFERENCES public.tbl_contacts(contact_id) ON UPDATE CASCADE;


--
-- Name: tbl_chronologies fk_chronologies_sample_group_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_chronologies
    ADD CONSTRAINT fk_chronologies_sample_group_id FOREIGN KEY (sample_group_id) REFERENCES public.tbl_sample_groups(sample_group_id) ON UPDATE CASCADE;


--
-- Name: tbl_colours fk_colours_method_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_colours
    ADD CONSTRAINT fk_colours_method_id FOREIGN KEY (method_id) REFERENCES public.tbl_methods(method_id) ON UPDATE CASCADE;


--
-- Name: tbl_coordinate_method_dimensions fk_coordinate_method_dimensions_dimensions_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_coordinate_method_dimensions
    ADD CONSTRAINT fk_coordinate_method_dimensions_dimensions_id FOREIGN KEY (dimension_id) REFERENCES public.tbl_dimensions(dimension_id) ON UPDATE CASCADE;


--
-- Name: tbl_coordinate_method_dimensions fk_coordinate_method_dimensions_method_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_coordinate_method_dimensions
    ADD CONSTRAINT fk_coordinate_method_dimensions_method_id FOREIGN KEY (method_id) REFERENCES public.tbl_methods(method_id) ON UPDATE CASCADE;


--
-- Name: tbl_data_types fk_data_types_data_type_group_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_data_types
    ADD CONSTRAINT fk_data_types_data_type_group_id FOREIGN KEY (data_type_group_id) REFERENCES public.tbl_data_type_groups(data_type_group_id) ON UPDATE CASCADE;


--
-- Name: tbl_dataset_contacts fk_dataset_contacts_contact_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dataset_contacts
    ADD CONSTRAINT fk_dataset_contacts_contact_id FOREIGN KEY (contact_id) REFERENCES public.tbl_contacts(contact_id) ON UPDATE CASCADE;


--
-- Name: tbl_dataset_contacts fk_dataset_contacts_contact_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dataset_contacts
    ADD CONSTRAINT fk_dataset_contacts_contact_type_id FOREIGN KEY (contact_type_id) REFERENCES public.tbl_contact_types(contact_type_id) ON UPDATE CASCADE;


--
-- Name: tbl_dataset_contacts fk_dataset_contacts_dataset_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dataset_contacts
    ADD CONSTRAINT fk_dataset_contacts_dataset_id FOREIGN KEY (dataset_id) REFERENCES public.tbl_datasets(dataset_id) ON UPDATE CASCADE;


--
-- Name: tbl_dataset_masters fk_dataset_masters_biblio_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dataset_masters
    ADD CONSTRAINT fk_dataset_masters_biblio_id FOREIGN KEY (biblio_id) REFERENCES public.tbl_biblio(biblio_id);


--
-- Name: tbl_dataset_masters fk_dataset_masters_contact_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dataset_masters
    ADD CONSTRAINT fk_dataset_masters_contact_id FOREIGN KEY (contact_id) REFERENCES public.tbl_contacts(contact_id) ON UPDATE CASCADE;


--
-- Name: tbl_dataset_submissions fk_dataset_submission_submission_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dataset_submissions
    ADD CONSTRAINT fk_dataset_submission_submission_type_id FOREIGN KEY (submission_type_id) REFERENCES public.tbl_dataset_submission_types(submission_type_id) ON UPDATE CASCADE;


--
-- Name: tbl_dataset_submissions fk_dataset_submissions_contact_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dataset_submissions
    ADD CONSTRAINT fk_dataset_submissions_contact_id FOREIGN KEY (contact_id) REFERENCES public.tbl_contacts(contact_id) ON UPDATE CASCADE;


--
-- Name: tbl_dataset_submissions fk_dataset_submissions_dataset_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dataset_submissions
    ADD CONSTRAINT fk_dataset_submissions_dataset_id FOREIGN KEY (dataset_id) REFERENCES public.tbl_datasets(dataset_id) ON UPDATE CASCADE;


--
-- Name: tbl_datasets fk_datasets_biblio_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_datasets
    ADD CONSTRAINT fk_datasets_biblio_id FOREIGN KEY (biblio_id) REFERENCES public.tbl_biblio(biblio_id) ON UPDATE CASCADE;


--
-- Name: tbl_datasets fk_datasets_data_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_datasets
    ADD CONSTRAINT fk_datasets_data_type_id FOREIGN KEY (data_type_id) REFERENCES public.tbl_data_types(data_type_id) ON UPDATE CASCADE;


--
-- Name: tbl_datasets fk_datasets_master_set_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_datasets
    ADD CONSTRAINT fk_datasets_master_set_id FOREIGN KEY (master_set_id) REFERENCES public.tbl_dataset_masters(master_set_id) ON UPDATE CASCADE;


--
-- Name: tbl_datasets fk_datasets_method_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_datasets
    ADD CONSTRAINT fk_datasets_method_id FOREIGN KEY (method_id) REFERENCES public.tbl_methods(method_id) ON UPDATE CASCADE;


--
-- Name: tbl_datasets fk_datasets_project_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_datasets
    ADD CONSTRAINT fk_datasets_project_id FOREIGN KEY (project_id) REFERENCES public.tbl_projects(project_id);


--
-- Name: tbl_datasets fk_datasets_updated_dataset_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_datasets
    ADD CONSTRAINT fk_datasets_updated_dataset_id FOREIGN KEY (updated_dataset_id) REFERENCES public.tbl_datasets(dataset_id) ON UPDATE CASCADE;


--
-- Name: tbl_dating_labs fk_dating_labs_contact_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dating_labs
    ADD CONSTRAINT fk_dating_labs_contact_id FOREIGN KEY (contact_id) REFERENCES public.tbl_contacts(contact_id);


--
-- Name: tbl_dating_material fk_dating_material_abundance_elements_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dating_material
    ADD CONSTRAINT fk_dating_material_abundance_elements_id FOREIGN KEY (abundance_element_id) REFERENCES public.tbl_abundance_elements(abundance_element_id);


--
-- Name: tbl_dating_material fk_dating_material_geochronology_geochron_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dating_material
    ADD CONSTRAINT fk_dating_material_geochronology_geochron_id FOREIGN KEY (geochron_id) REFERENCES public.tbl_geochronology(geochron_id);


--
-- Name: tbl_dating_material fk_dating_material_taxa_tree_master_taxon_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dating_material
    ADD CONSTRAINT fk_dating_material_taxa_tree_master_taxon_id FOREIGN KEY (taxon_id) REFERENCES public.tbl_taxa_tree_master(taxon_id);


--
-- Name: tbl_dendro fk_dendro_analysis_entity_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dendro
    ADD CONSTRAINT fk_dendro_analysis_entity_id FOREIGN KEY (analysis_entity_id) REFERENCES public.tbl_analysis_entities(analysis_entity_id);


--
-- Name: tbl_dendro_date_notes fk_dendro_date_notes_dendro_date_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dendro_date_notes
    ADD CONSTRAINT fk_dendro_date_notes_dendro_date_id FOREIGN KEY (dendro_date_id) REFERENCES public.tbl_dendro_dates(dendro_date_id);


--
-- Name: tbl_dendro_dates fk_dendro_dates_analysis_entity_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dendro_dates
    ADD CONSTRAINT fk_dendro_dates_analysis_entity_id FOREIGN KEY (analysis_entity_id) REFERENCES public.tbl_analysis_entities(analysis_entity_id);


--
-- Name: tbl_dendro_dates fk_dendro_dates_dating_uncertainty_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dendro_dates
    ADD CONSTRAINT fk_dendro_dates_dating_uncertainty_id FOREIGN KEY (dating_uncertainty_id) REFERENCES public.tbl_dating_uncertainty(dating_uncertainty_id);


--
-- Name: tbl_dendro fk_dendro_dendro_lookup_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dendro
    ADD CONSTRAINT fk_dendro_dendro_lookup_id FOREIGN KEY (dendro_lookup_id) REFERENCES public.tbl_dendro_lookup(dendro_lookup_id);


--
-- Name: tbl_dendro_dates fk_dendro_lookup_dendro_lookup_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dendro_dates
    ADD CONSTRAINT fk_dendro_lookup_dendro_lookup_id FOREIGN KEY (dendro_lookup_id) REFERENCES public.tbl_dendro_lookup(dendro_lookup_id);


--
-- Name: tbl_dendro_lookup fk_dendro_lookup_method_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dendro_lookup
    ADD CONSTRAINT fk_dendro_lookup_method_id FOREIGN KEY (method_id) REFERENCES public.tbl_methods(method_id);


--
-- Name: tbl_dendro_measurements fk_dendro_measurements_method_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dendro_measurements
    ADD CONSTRAINT fk_dendro_measurements_method_id FOREIGN KEY (method_id) REFERENCES public.tbl_methods(method_id);


--
-- Name: tbl_dimensions fk_dimensions_method_group_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dimensions
    ADD CONSTRAINT fk_dimensions_method_group_id FOREIGN KEY (method_group_id) REFERENCES public.tbl_method_groups(method_group_id);


--
-- Name: tbl_dimensions fk_dimensions_unit_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dimensions
    ADD CONSTRAINT fk_dimensions_unit_id FOREIGN KEY (unit_id) REFERENCES public.tbl_units(unit_id) ON UPDATE CASCADE;


--
-- Name: tbl_ecocode_definitions fk_ecocode_definitions_ecocode_group_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_ecocode_definitions
    ADD CONSTRAINT fk_ecocode_definitions_ecocode_group_id FOREIGN KEY (ecocode_group_id) REFERENCES public.tbl_ecocode_groups(ecocode_group_id) ON UPDATE CASCADE;


--
-- Name: tbl_ecocode_groups fk_ecocode_groups_ecocode_system_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_ecocode_groups
    ADD CONSTRAINT fk_ecocode_groups_ecocode_system_id FOREIGN KEY (ecocode_system_id) REFERENCES public.tbl_ecocode_systems(ecocode_system_id) ON UPDATE CASCADE;


--
-- Name: tbl_ecocode_systems fk_ecocode_systems_biblio_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_ecocode_systems
    ADD CONSTRAINT fk_ecocode_systems_biblio_id FOREIGN KEY (biblio_id) REFERENCES public.tbl_biblio(biblio_id) ON UPDATE CASCADE;


--
-- Name: tbl_ecocodes fk_ecocodes_ecocodedef_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_ecocodes
    ADD CONSTRAINT fk_ecocodes_ecocodedef_id FOREIGN KEY (ecocode_definition_id) REFERENCES public.tbl_ecocode_definitions(ecocode_definition_id) ON UPDATE CASCADE;


--
-- Name: tbl_ecocodes fk_ecocodes_taxon_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_ecocodes
    ADD CONSTRAINT fk_ecocodes_taxon_id FOREIGN KEY (taxon_id) REFERENCES public.tbl_taxa_tree_master(taxon_id) ON UPDATE CASCADE;


--
-- Name: tbl_features fk_feature_type_id_feature_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_features
    ADD CONSTRAINT fk_feature_type_id_feature_type_id FOREIGN KEY (feature_type_id) REFERENCES public.tbl_feature_types(feature_type_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbl_geochron_refs fk_geochron_refs_biblio_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_geochron_refs
    ADD CONSTRAINT fk_geochron_refs_biblio_id FOREIGN KEY (biblio_id) REFERENCES public.tbl_biblio(biblio_id) ON UPDATE CASCADE;


--
-- Name: tbl_geochron_refs fk_geochron_refs_geochron_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_geochron_refs
    ADD CONSTRAINT fk_geochron_refs_geochron_id FOREIGN KEY (geochron_id) REFERENCES public.tbl_geochronology(geochron_id) ON UPDATE CASCADE;


--
-- Name: tbl_geochronology fk_geochronology_analysis_entity_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_geochronology
    ADD CONSTRAINT fk_geochronology_analysis_entity_id FOREIGN KEY (analysis_entity_id) REFERENCES public.tbl_analysis_entities(analysis_entity_id) ON UPDATE CASCADE;


--
-- Name: tbl_geochronology fk_geochronology_dating_labs_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_geochronology
    ADD CONSTRAINT fk_geochronology_dating_labs_id FOREIGN KEY (dating_lab_id) REFERENCES public.tbl_dating_labs(dating_lab_id) ON UPDATE CASCADE;


--
-- Name: tbl_geochronology fk_geochronology_dating_uncertainty_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_geochronology
    ADD CONSTRAINT fk_geochronology_dating_uncertainty_id FOREIGN KEY (dating_uncertainty_id) REFERENCES public.tbl_dating_uncertainty(dating_uncertainty_id);


--
-- Name: tbl_horizons fk_horizons_method_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_horizons
    ADD CONSTRAINT fk_horizons_method_id FOREIGN KEY (method_id) REFERENCES public.tbl_methods(method_id) ON UPDATE CASCADE;


--
-- Name: tbl_imported_taxa_replacements fk_imported_taxa_replacements_taxon_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_imported_taxa_replacements
    ADD CONSTRAINT fk_imported_taxa_replacements_taxon_id FOREIGN KEY (taxon_id) REFERENCES public.tbl_taxa_tree_master(taxon_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbl_lithology fk_lithology_sample_group_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_lithology
    ADD CONSTRAINT fk_lithology_sample_group_id FOREIGN KEY (sample_group_id) REFERENCES public.tbl_sample_groups(sample_group_id) ON UPDATE CASCADE;


--
-- Name: tbl_site_locations fk_locations_location_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_locations
    ADD CONSTRAINT fk_locations_location_id FOREIGN KEY (location_id) REFERENCES public.tbl_locations(location_id);


--
-- Name: tbl_locations fk_locations_location_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_locations
    ADD CONSTRAINT fk_locations_location_type_id FOREIGN KEY (location_type_id) REFERENCES public.tbl_location_types(location_type_id) ON UPDATE CASCADE;


--
-- Name: tbl_site_locations fk_locations_site_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_locations
    ADD CONSTRAINT fk_locations_site_id FOREIGN KEY (site_id) REFERENCES public.tbl_sites(site_id);


--
-- Name: tbl_mcr_names fk_mcr_names_taxon_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_mcr_names
    ADD CONSTRAINT fk_mcr_names_taxon_id FOREIGN KEY (taxon_id) REFERENCES public.tbl_taxa_tree_master(taxon_id) ON UPDATE CASCADE;


--
-- Name: tbl_mcr_summary_data fk_mcr_summary_data_taxon_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_mcr_summary_data
    ADD CONSTRAINT fk_mcr_summary_data_taxon_id FOREIGN KEY (taxon_id) REFERENCES public.tbl_taxa_tree_master(taxon_id) ON UPDATE CASCADE;


--
-- Name: tbl_mcrdata_birmbeetledat fk_mcrdata_birmbeetledat_taxon_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_mcrdata_birmbeetledat
    ADD CONSTRAINT fk_mcrdata_birmbeetledat_taxon_id FOREIGN KEY (taxon_id) REFERENCES public.tbl_taxa_tree_master(taxon_id) ON UPDATE CASCADE;


--
-- Name: tbl_measured_value_dimensions fk_measured_value_dimensions_dimension_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_measured_value_dimensions
    ADD CONSTRAINT fk_measured_value_dimensions_dimension_id FOREIGN KEY (dimension_id) REFERENCES public.tbl_dimensions(dimension_id) ON UPDATE CASCADE;


--
-- Name: tbl_measured_values fk_measured_values_analysis_entity_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_measured_values
    ADD CONSTRAINT fk_measured_values_analysis_entity_id FOREIGN KEY (analysis_entity_id) REFERENCES public.tbl_analysis_entities(analysis_entity_id);


--
-- Name: tbl_measured_value_dimensions fk_measured_weights_value_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_measured_value_dimensions
    ADD CONSTRAINT fk_measured_weights_value_id FOREIGN KEY (measured_value_id) REFERENCES public.tbl_measured_values(measured_value_id) ON UPDATE CASCADE;


--
-- Name: tbl_methods fk_methods_biblio_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_methods
    ADD CONSTRAINT fk_methods_biblio_id FOREIGN KEY (biblio_id) REFERENCES public.tbl_biblio(biblio_id) ON UPDATE CASCADE;


--
-- Name: tbl_methods fk_methods_method_group_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_methods
    ADD CONSTRAINT fk_methods_method_group_id FOREIGN KEY (method_group_id) REFERENCES public.tbl_method_groups(method_group_id) ON UPDATE CASCADE;


--
-- Name: tbl_methods fk_methods_record_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_methods
    ADD CONSTRAINT fk_methods_record_type_id FOREIGN KEY (record_type_id) REFERENCES public.tbl_record_types(record_type_id) ON UPDATE CASCADE;


--
-- Name: tbl_methods fk_methods_unit_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_methods
    ADD CONSTRAINT fk_methods_unit_id FOREIGN KEY (unit_id) REFERENCES public.tbl_units(unit_id) ON UPDATE CASCADE;


--
-- Name: tbl_physical_sample_features fk_physical_sample_features_feature_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_physical_sample_features
    ADD CONSTRAINT fk_physical_sample_features_feature_id FOREIGN KEY (feature_id) REFERENCES public.tbl_features(feature_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbl_physical_sample_features fk_physical_sample_features_physical_sample_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_physical_sample_features
    ADD CONSTRAINT fk_physical_sample_features_physical_sample_id FOREIGN KEY (physical_sample_id) REFERENCES public.tbl_physical_samples(physical_sample_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbl_physical_samples fk_physical_samples_sample_name_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_physical_samples
    ADD CONSTRAINT fk_physical_samples_sample_name_type_id FOREIGN KEY (alt_ref_type_id) REFERENCES public.tbl_alt_ref_types(alt_ref_type_id) ON UPDATE CASCADE;


--
-- Name: tbl_physical_samples fk_physical_samples_sample_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_physical_samples
    ADD CONSTRAINT fk_physical_samples_sample_type_id FOREIGN KEY (sample_type_id) REFERENCES public.tbl_sample_types(sample_type_id) ON UPDATE CASCADE;


--
-- Name: tbl_projects fk_projects_project_stage_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_projects
    ADD CONSTRAINT fk_projects_project_stage_id FOREIGN KEY (project_stage_id) REFERENCES public.tbl_project_stages(project_stage_id);


--
-- Name: tbl_projects fk_projects_project_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_projects
    ADD CONSTRAINT fk_projects_project_type_id FOREIGN KEY (project_type_id) REFERENCES public.tbl_project_types(project_type_id);


--
-- Name: tbl_rdb_codes fk_rdb_codes_rdb_system_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_rdb_codes
    ADD CONSTRAINT fk_rdb_codes_rdb_system_id FOREIGN KEY (rdb_system_id) REFERENCES public.tbl_rdb_systems(rdb_system_id);


--
-- Name: tbl_rdb fk_rdb_rdb_code_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_rdb
    ADD CONSTRAINT fk_rdb_rdb_code_id FOREIGN KEY (rdb_code_id) REFERENCES public.tbl_rdb_codes(rdb_code_id);


--
-- Name: tbl_rdb_systems fk_rdb_systems_biblio_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_rdb_systems
    ADD CONSTRAINT fk_rdb_systems_biblio_id FOREIGN KEY (biblio_id) REFERENCES public.tbl_biblio(biblio_id) ON UPDATE CASCADE;


--
-- Name: tbl_rdb_systems fk_rdb_systems_location_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_rdb_systems
    ADD CONSTRAINT fk_rdb_systems_location_id FOREIGN KEY (location_id) REFERENCES public.tbl_locations(location_id);


--
-- Name: tbl_rdb fk_rdb_taxon_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_rdb
    ADD CONSTRAINT fk_rdb_taxon_id FOREIGN KEY (taxon_id) REFERENCES public.tbl_taxa_tree_master(taxon_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbl_relative_age_refs fk_relative_age_refs_biblio_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_relative_age_refs
    ADD CONSTRAINT fk_relative_age_refs_biblio_id FOREIGN KEY (biblio_id) REFERENCES public.tbl_biblio(biblio_id) ON UPDATE CASCADE;


--
-- Name: tbl_relative_age_refs fk_relative_age_refs_relative_age_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_relative_age_refs
    ADD CONSTRAINT fk_relative_age_refs_relative_age_id FOREIGN KEY (relative_age_id) REFERENCES public.tbl_relative_ages(relative_age_id) ON UPDATE CASCADE;


--
-- Name: tbl_relative_ages fk_relative_ages_location_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_relative_ages
    ADD CONSTRAINT fk_relative_ages_location_id FOREIGN KEY (location_id) REFERENCES public.tbl_locations(location_id);


--
-- Name: tbl_relative_ages fk_relative_ages_relative_age_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_relative_ages
    ADD CONSTRAINT fk_relative_ages_relative_age_type_id FOREIGN KEY (relative_age_type_id) REFERENCES public.tbl_relative_age_types(relative_age_type_id);


--
-- Name: tbl_relative_dates fk_relative_dates_dating_uncertainty_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_relative_dates
    ADD CONSTRAINT fk_relative_dates_dating_uncertainty_id FOREIGN KEY (dating_uncertainty_id) REFERENCES public.tbl_dating_uncertainty(dating_uncertainty_id);


--
-- Name: tbl_relative_dates fk_relative_dates_method_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_relative_dates
    ADD CONSTRAINT fk_relative_dates_method_id FOREIGN KEY (method_id) REFERENCES public.tbl_methods(method_id);


--
-- Name: tbl_relative_dates fk_relative_dates_relative_age_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_relative_dates
    ADD CONSTRAINT fk_relative_dates_relative_age_id FOREIGN KEY (relative_age_id) REFERENCES public.tbl_relative_ages(relative_age_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_alt_refs fk_sample_alt_refs_alt_ref_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_alt_refs
    ADD CONSTRAINT fk_sample_alt_refs_alt_ref_type_id FOREIGN KEY (alt_ref_type_id) REFERENCES public.tbl_alt_ref_types(alt_ref_type_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_alt_refs fk_sample_alt_refs_physical_sample_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_alt_refs
    ADD CONSTRAINT fk_sample_alt_refs_physical_sample_id FOREIGN KEY (physical_sample_id) REFERENCES public.tbl_physical_samples(physical_sample_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_colours fk_sample_colours_colour_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_colours
    ADD CONSTRAINT fk_sample_colours_colour_id FOREIGN KEY (colour_id) REFERENCES public.tbl_colours(colour_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_colours fk_sample_colours_physical_sample_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_colours
    ADD CONSTRAINT fk_sample_colours_physical_sample_id FOREIGN KEY (physical_sample_id) REFERENCES public.tbl_physical_samples(physical_sample_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_coordinates fk_sample_coordinates_coordinate_method_dimension_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_coordinates
    ADD CONSTRAINT fk_sample_coordinates_coordinate_method_dimension_id FOREIGN KEY (coordinate_method_dimension_id) REFERENCES public.tbl_coordinate_method_dimensions(coordinate_method_dimension_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_coordinates fk_sample_coordinates_physical_sample_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_coordinates
    ADD CONSTRAINT fk_sample_coordinates_physical_sample_id FOREIGN KEY (physical_sample_id) REFERENCES public.tbl_physical_samples(physical_sample_id);


--
-- Name: tbl_sample_description_sample_group_contexts fk_sample_description_sample_group_contexts_sampling_context_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_description_sample_group_contexts
    ADD CONSTRAINT fk_sample_description_sample_group_contexts_sampling_context_id FOREIGN KEY (sampling_context_id) REFERENCES public.tbl_sample_group_sampling_contexts(sampling_context_id);


--
-- Name: tbl_sample_description_sample_group_contexts fk_sample_description_types_sample_group_context_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_description_sample_group_contexts
    ADD CONSTRAINT fk_sample_description_types_sample_group_context_id FOREIGN KEY (sample_description_type_id) REFERENCES public.tbl_sample_description_types(sample_description_type_id);


--
-- Name: tbl_sample_descriptions fk_sample_descriptions_physical_sample_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_descriptions
    ADD CONSTRAINT fk_sample_descriptions_physical_sample_id FOREIGN KEY (physical_sample_id) REFERENCES public.tbl_physical_samples(physical_sample_id);


--
-- Name: tbl_sample_descriptions fk_sample_descriptions_sample_description_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_descriptions
    ADD CONSTRAINT fk_sample_descriptions_sample_description_type_id FOREIGN KEY (sample_description_type_id) REFERENCES public.tbl_sample_description_types(sample_description_type_id);


--
-- Name: tbl_sample_dimensions fk_sample_dimensions_dimension_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_dimensions
    ADD CONSTRAINT fk_sample_dimensions_dimension_id FOREIGN KEY (dimension_id) REFERENCES public.tbl_dimensions(dimension_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_dimensions fk_sample_dimensions_measurement_method_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_dimensions
    ADD CONSTRAINT fk_sample_dimensions_measurement_method_id FOREIGN KEY (method_id) REFERENCES public.tbl_methods(method_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_dimensions fk_sample_dimensions_physical_sample_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_dimensions
    ADD CONSTRAINT fk_sample_dimensions_physical_sample_id FOREIGN KEY (physical_sample_id) REFERENCES public.tbl_physical_samples(physical_sample_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_group_description_type_sampling_contexts fk_sample_group_description_type_sampling_context_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_description_type_sampling_contexts
    ADD CONSTRAINT fk_sample_group_description_type_sampling_context_id FOREIGN KEY (sample_group_description_type_id) REFERENCES public.tbl_sample_group_description_types(sample_group_description_type_id);


--
-- Name: tbl_sample_group_descriptions fk_sample_group_descriptions_sample_group_description_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_descriptions
    ADD CONSTRAINT fk_sample_group_descriptions_sample_group_description_type_id FOREIGN KEY (sample_group_description_type_id) REFERENCES public.tbl_sample_group_description_types(sample_group_description_type_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_group_dimensions fk_sample_group_dimensions_dimension_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_dimensions
    ADD CONSTRAINT fk_sample_group_dimensions_dimension_id FOREIGN KEY (dimension_id) REFERENCES public.tbl_dimensions(dimension_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_group_dimensions fk_sample_group_dimensions_sample_group_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_dimensions
    ADD CONSTRAINT fk_sample_group_dimensions_sample_group_id FOREIGN KEY (sample_group_id) REFERENCES public.tbl_sample_groups(sample_group_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_group_images fk_sample_group_images_image_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_images
    ADD CONSTRAINT fk_sample_group_images_image_type_id FOREIGN KEY (image_type_id) REFERENCES public.tbl_image_types(image_type_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_group_images fk_sample_group_images_sample_group_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_images
    ADD CONSTRAINT fk_sample_group_images_sample_group_id FOREIGN KEY (sample_group_id) REFERENCES public.tbl_sample_groups(sample_group_id);


--
-- Name: tbl_sample_group_coordinates fk_sample_group_positions_coordinate_method_dimension_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_coordinates
    ADD CONSTRAINT fk_sample_group_positions_coordinate_method_dimension_id FOREIGN KEY (coordinate_method_dimension_id) REFERENCES public.tbl_coordinate_method_dimensions(coordinate_method_dimension_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_group_coordinates fk_sample_group_positions_sample_group_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_coordinates
    ADD CONSTRAINT fk_sample_group_positions_sample_group_id FOREIGN KEY (sample_group_id) REFERENCES public.tbl_sample_groups(sample_group_id);


--
-- Name: tbl_sample_group_references fk_sample_group_references_biblio_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_references
    ADD CONSTRAINT fk_sample_group_references_biblio_id FOREIGN KEY (biblio_id) REFERENCES public.tbl_biblio(biblio_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_group_references fk_sample_group_references_sample_group_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_references
    ADD CONSTRAINT fk_sample_group_references_sample_group_id FOREIGN KEY (sample_group_id) REFERENCES public.tbl_sample_groups(sample_group_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_groups fk_sample_group_sampling_context_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_groups
    ADD CONSTRAINT fk_sample_group_sampling_context_id FOREIGN KEY (sampling_context_id) REFERENCES public.tbl_sample_group_sampling_contexts(sampling_context_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_group_description_type_sampling_contexts fk_sample_group_sampling_context_id0; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_description_type_sampling_contexts
    ADD CONSTRAINT fk_sample_group_sampling_context_id0 FOREIGN KEY (sampling_context_id) REFERENCES public.tbl_sample_group_sampling_contexts(sampling_context_id);


--
-- Name: tbl_sample_groups fk_sample_groups_method_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_groups
    ADD CONSTRAINT fk_sample_groups_method_id FOREIGN KEY (method_id) REFERENCES public.tbl_methods(method_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_group_descriptions fk_sample_groups_sample_group_descriptions_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_descriptions
    ADD CONSTRAINT fk_sample_groups_sample_group_descriptions_id FOREIGN KEY (sample_group_id) REFERENCES public.tbl_sample_groups(sample_group_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_groups fk_sample_groups_site_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_groups
    ADD CONSTRAINT fk_sample_groups_site_id FOREIGN KEY (site_id) REFERENCES public.tbl_sites(site_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_horizons fk_sample_horizons_horizon_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_horizons
    ADD CONSTRAINT fk_sample_horizons_horizon_id FOREIGN KEY (horizon_id) REFERENCES public.tbl_horizons(horizon_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_horizons fk_sample_horizons_physical_sample_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_horizons
    ADD CONSTRAINT fk_sample_horizons_physical_sample_id FOREIGN KEY (physical_sample_id) REFERENCES public.tbl_physical_samples(physical_sample_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_images fk_sample_images_image_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_images
    ADD CONSTRAINT fk_sample_images_image_type_id FOREIGN KEY (image_type_id) REFERENCES public.tbl_image_types(image_type_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_images fk_sample_images_physical_sample_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_images
    ADD CONSTRAINT fk_sample_images_physical_sample_id FOREIGN KEY (physical_sample_id) REFERENCES public.tbl_physical_samples(physical_sample_id) ON UPDATE CASCADE;


--
-- Name: tbl_sample_location_type_sampling_contexts fk_sample_location_sampling_contexts_sampling_context_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_location_type_sampling_contexts
    ADD CONSTRAINT fk_sample_location_sampling_contexts_sampling_context_id FOREIGN KEY (sample_location_type_id) REFERENCES public.tbl_sample_location_types(sample_location_type_id);


--
-- Name: tbl_sample_location_type_sampling_contexts fk_sample_location_type_sampling_context_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_location_type_sampling_contexts
    ADD CONSTRAINT fk_sample_location_type_sampling_context_id FOREIGN KEY (sampling_context_id) REFERENCES public.tbl_sample_group_sampling_contexts(sampling_context_id);


--
-- Name: tbl_sample_locations fk_sample_locations_physical_sample_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_locations
    ADD CONSTRAINT fk_sample_locations_physical_sample_id FOREIGN KEY (physical_sample_id) REFERENCES public.tbl_physical_samples(physical_sample_id);


--
-- Name: tbl_sample_locations fk_sample_locations_sample_location_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_locations
    ADD CONSTRAINT fk_sample_locations_sample_location_type_id FOREIGN KEY (sample_location_type_id) REFERENCES public.tbl_sample_location_types(sample_location_type_id);


--
-- Name: tbl_sample_notes fk_sample_notes_physical_sample_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_notes
    ADD CONSTRAINT fk_sample_notes_physical_sample_id FOREIGN KEY (physical_sample_id) REFERENCES public.tbl_physical_samples(physical_sample_id) ON UPDATE CASCADE;


--
-- Name: tbl_physical_samples fk_samples_sample_group_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_physical_samples
    ADD CONSTRAINT fk_samples_sample_group_id FOREIGN KEY (sample_group_id) REFERENCES public.tbl_sample_groups(sample_group_id) ON UPDATE CASCADE;


--
-- Name: tbl_seasons fk_seasons_season_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_seasons
    ADD CONSTRAINT fk_seasons_season_type_id FOREIGN KEY (season_type_id) REFERENCES public.tbl_season_types(season_type_id) ON UPDATE CASCADE;


--
-- Name: tbl_site_images fk_site_images_contact_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_images
    ADD CONSTRAINT fk_site_images_contact_id FOREIGN KEY (contact_id) REFERENCES public.tbl_contacts(contact_id) ON UPDATE CASCADE;


--
-- Name: tbl_site_images fk_site_images_image_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_images
    ADD CONSTRAINT fk_site_images_image_type_id FOREIGN KEY (image_type_id) REFERENCES public.tbl_image_types(image_type_id) ON UPDATE CASCADE;


--
-- Name: tbl_site_images fk_site_images_site_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_images
    ADD CONSTRAINT fk_site_images_site_id FOREIGN KEY (site_id) REFERENCES public.tbl_sites(site_id);


--
-- Name: tbl_site_natgridrefs fk_site_natgridrefs_method_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_natgridrefs
    ADD CONSTRAINT fk_site_natgridrefs_method_id FOREIGN KEY (method_id) REFERENCES public.tbl_methods(method_id);


--
-- Name: tbl_site_natgridrefs fk_site_natgridrefs_sites_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_natgridrefs
    ADD CONSTRAINT fk_site_natgridrefs_sites_id FOREIGN KEY (site_id) REFERENCES public.tbl_sites(site_id);


--
-- Name: tbl_site_other_records fk_site_other_records_biblio_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_other_records
    ADD CONSTRAINT fk_site_other_records_biblio_id FOREIGN KEY (biblio_id) REFERENCES public.tbl_biblio(biblio_id) ON UPDATE CASCADE;


--
-- Name: tbl_site_other_records fk_site_other_records_record_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_other_records
    ADD CONSTRAINT fk_site_other_records_record_type_id FOREIGN KEY (record_type_id) REFERENCES public.tbl_record_types(record_type_id) ON UPDATE CASCADE;


--
-- Name: tbl_site_other_records fk_site_other_records_site_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_other_records
    ADD CONSTRAINT fk_site_other_records_site_id FOREIGN KEY (site_id) REFERENCES public.tbl_sites(site_id) ON UPDATE CASCADE;


--
-- Name: tbl_site_preservation_status fk_site_preservation_status_site_id ; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_preservation_status
    ADD CONSTRAINT "fk_site_preservation_status_site_id " FOREIGN KEY (site_id) REFERENCES public.tbl_sites(site_id) ON UPDATE CASCADE;


--
-- Name: tbl_site_references fk_site_references_biblio_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_references
    ADD CONSTRAINT fk_site_references_biblio_id FOREIGN KEY (biblio_id) REFERENCES public.tbl_biblio(biblio_id) ON UPDATE CASCADE;


--
-- Name: tbl_site_references fk_site_references_site_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_site_references
    ADD CONSTRAINT fk_site_references_site_id FOREIGN KEY (site_id) REFERENCES public.tbl_sites(site_id) ON UPDATE CASCADE;


--
-- Name: tbl_species_associations fk_species_associations_associated_taxon_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_species_associations
    ADD CONSTRAINT fk_species_associations_associated_taxon_id FOREIGN KEY (taxon_id) REFERENCES public.tbl_taxa_tree_master(taxon_id) ON UPDATE CASCADE;


--
-- Name: tbl_species_associations fk_species_associations_association_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_species_associations
    ADD CONSTRAINT fk_species_associations_association_type_id FOREIGN KEY (association_type_id) REFERENCES public.tbl_species_association_types(association_type_id);


--
-- Name: tbl_species_associations fk_species_associations_biblio_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_species_associations
    ADD CONSTRAINT fk_species_associations_biblio_id FOREIGN KEY (biblio_id) REFERENCES public.tbl_biblio(biblio_id) ON UPDATE CASCADE;


--
-- Name: tbl_species_associations fk_species_associations_taxon_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_species_associations
    ADD CONSTRAINT fk_species_associations_taxon_id FOREIGN KEY (taxon_id) REFERENCES public.tbl_taxa_tree_master(taxon_id);


--
-- Name: tbl_taxa_common_names fk_taxa_common_names_language_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_common_names
    ADD CONSTRAINT fk_taxa_common_names_language_id FOREIGN KEY (language_id) REFERENCES public.tbl_languages(language_id) ON UPDATE CASCADE;


--
-- Name: tbl_taxa_common_names fk_taxa_common_names_taxon_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_common_names
    ADD CONSTRAINT fk_taxa_common_names_taxon_id FOREIGN KEY (taxon_id) REFERENCES public.tbl_taxa_tree_master(taxon_id) ON UPDATE CASCADE;


--
-- Name: tbl_taxa_images fk_taxa_images_image_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_images
    ADD CONSTRAINT fk_taxa_images_image_type_id FOREIGN KEY (image_type_id) REFERENCES public.tbl_image_types(image_type_id);


--
-- Name: tbl_taxa_images fk_taxa_images_taxa_tree_master_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_images
    ADD CONSTRAINT fk_taxa_images_taxa_tree_master_id FOREIGN KEY (taxon_id) REFERENCES public.tbl_taxa_tree_master(taxon_id);


--
-- Name: tbl_taxa_measured_attributes fk_taxa_measured_attributes_taxon_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_measured_attributes
    ADD CONSTRAINT fk_taxa_measured_attributes_taxon_id FOREIGN KEY (taxon_id) REFERENCES public.tbl_taxa_tree_master(taxon_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbl_taxa_reference_specimens fk_taxa_reference_specimens_contact_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_reference_specimens
    ADD CONSTRAINT fk_taxa_reference_specimens_contact_id FOREIGN KEY (contact_id) REFERENCES public.tbl_contacts(contact_id);


--
-- Name: tbl_taxa_reference_specimens fk_taxa_reference_specimens_taxon_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_reference_specimens
    ADD CONSTRAINT fk_taxa_reference_specimens_taxon_id FOREIGN KEY (taxon_id) REFERENCES public.tbl_taxa_tree_master(taxon_id);


--
-- Name: tbl_taxa_seasonality fk_taxa_seasonality_activity_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_seasonality
    ADD CONSTRAINT fk_taxa_seasonality_activity_type_id FOREIGN KEY (activity_type_id) REFERENCES public.tbl_activity_types(activity_type_id) ON UPDATE CASCADE;


--
-- Name: tbl_taxa_seasonality fk_taxa_seasonality_location_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_seasonality
    ADD CONSTRAINT fk_taxa_seasonality_location_id FOREIGN KEY (location_id) REFERENCES public.tbl_locations(location_id);


--
-- Name: tbl_taxa_seasonality fk_taxa_seasonality_season_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_seasonality
    ADD CONSTRAINT fk_taxa_seasonality_season_id FOREIGN KEY (season_id) REFERENCES public.tbl_seasons(season_id) ON UPDATE CASCADE;


--
-- Name: tbl_taxa_seasonality fk_taxa_seasonality_taxon_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_seasonality
    ADD CONSTRAINT fk_taxa_seasonality_taxon_id FOREIGN KEY (taxon_id) REFERENCES public.tbl_taxa_tree_master(taxon_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbl_taxa_synonyms fk_taxa_synonyms_biblio_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_synonyms
    ADD CONSTRAINT fk_taxa_synonyms_biblio_id FOREIGN KEY (biblio_id) REFERENCES public.tbl_biblio(biblio_id) ON UPDATE CASCADE;


--
-- Name: tbl_taxa_synonyms fk_taxa_synonyms_family_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_synonyms
    ADD CONSTRAINT fk_taxa_synonyms_family_id FOREIGN KEY (family_id) REFERENCES public.tbl_taxa_tree_families(family_id) ON UPDATE CASCADE;


--
-- Name: tbl_taxa_synonyms fk_taxa_synonyms_genus_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_synonyms
    ADD CONSTRAINT fk_taxa_synonyms_genus_id FOREIGN KEY (genus_id) REFERENCES public.tbl_taxa_tree_genera(genus_id) ON UPDATE CASCADE;


--
-- Name: tbl_taxa_synonyms fk_taxa_synonyms_taxa_tree_author_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_synonyms
    ADD CONSTRAINT fk_taxa_synonyms_taxa_tree_author_id FOREIGN KEY (author_id) REFERENCES public.tbl_taxa_tree_authors(author_id);


--
-- Name: tbl_taxa_synonyms fk_taxa_synonyms_taxon_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_synonyms
    ADD CONSTRAINT fk_taxa_synonyms_taxon_id FOREIGN KEY (taxon_id) REFERENCES public.tbl_taxa_tree_master(taxon_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbl_taxa_tree_families fk_taxa_tree_families_order_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_tree_families
    ADD CONSTRAINT fk_taxa_tree_families_order_id FOREIGN KEY (order_id) REFERENCES public.tbl_taxa_tree_orders(order_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbl_taxa_tree_genera fk_taxa_tree_genera_family_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_tree_genera
    ADD CONSTRAINT fk_taxa_tree_genera_family_id FOREIGN KEY (family_id) REFERENCES public.tbl_taxa_tree_families(family_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbl_taxa_tree_master fk_taxa_tree_master_author_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_tree_master
    ADD CONSTRAINT fk_taxa_tree_master_author_id FOREIGN KEY (author_id) REFERENCES public.tbl_taxa_tree_authors(author_id) ON UPDATE CASCADE;


--
-- Name: tbl_taxa_tree_master fk_taxa_tree_master_genus_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_tree_master
    ADD CONSTRAINT fk_taxa_tree_master_genus_id FOREIGN KEY (genus_id) REFERENCES public.tbl_taxa_tree_genera(genus_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbl_taxa_tree_orders fk_taxa_tree_orders_record_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxa_tree_orders
    ADD CONSTRAINT fk_taxa_tree_orders_record_type_id FOREIGN KEY (record_type_id) REFERENCES public.tbl_record_types(record_type_id) ON UPDATE CASCADE;


--
-- Name: tbl_taxonomic_order_biblio fk_taxonomic_order_biblio_biblio_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxonomic_order_biblio
    ADD CONSTRAINT fk_taxonomic_order_biblio_biblio_id FOREIGN KEY (biblio_id) REFERENCES public.tbl_biblio(biblio_id) ON UPDATE CASCADE;


--
-- Name: tbl_taxonomic_order_biblio fk_taxonomic_order_biblio_taxonomic_order_system_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxonomic_order_biblio
    ADD CONSTRAINT fk_taxonomic_order_biblio_taxonomic_order_system_id FOREIGN KEY (taxonomic_order_system_id) REFERENCES public.tbl_taxonomic_order_systems(taxonomic_order_system_id) ON UPDATE CASCADE;


--
-- Name: tbl_taxonomic_order fk_taxonomic_order_taxon_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxonomic_order
    ADD CONSTRAINT fk_taxonomic_order_taxon_id FOREIGN KEY (taxon_id) REFERENCES public.tbl_taxa_tree_master(taxon_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbl_taxonomic_order fk_taxonomic_order_taxonomic_order_system_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxonomic_order
    ADD CONSTRAINT fk_taxonomic_order_taxonomic_order_system_id FOREIGN KEY (taxonomic_order_system_id) REFERENCES public.tbl_taxonomic_order_systems(taxonomic_order_system_id) ON UPDATE CASCADE;


--
-- Name: tbl_taxonomy_notes fk_taxonomy_notes_biblio_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxonomy_notes
    ADD CONSTRAINT fk_taxonomy_notes_biblio_id FOREIGN KEY (biblio_id) REFERENCES public.tbl_biblio(biblio_id) ON UPDATE CASCADE;


--
-- Name: tbl_taxonomy_notes fk_taxonomy_notes_taxon_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_taxonomy_notes
    ADD CONSTRAINT fk_taxonomy_notes_taxon_id FOREIGN KEY (taxon_id) REFERENCES public.tbl_taxa_tree_master(taxon_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbl_dendro_dates fk_tbl_age_types_age_type_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dendro_dates
    ADD CONSTRAINT fk_tbl_age_types_age_type_id FOREIGN KEY (age_type_id) REFERENCES public.tbl_age_types(age_type_id);


--
-- Name: tbl_dendro_dates fk_tbl_error_uncertainties_error_uncertainty_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_dendro_dates
    ADD CONSTRAINT fk_tbl_error_uncertainties_error_uncertainty_id FOREIGN KEY (error_uncertainty_id) REFERENCES public.tbl_error_uncertainties(error_uncertainty_id);


--
-- Name: tbl_rdb fk_tbl_rdb_tbl_location_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_rdb
    ADD CONSTRAINT fk_tbl_rdb_tbl_location_id FOREIGN KEY (location_id) REFERENCES public.tbl_locations(location_id);


--
-- Name: tbl_relative_dates fk_tbl_relative_dates_to_tbl_analysis_entities; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_relative_dates
    ADD CONSTRAINT fk_tbl_relative_dates_to_tbl_analysis_entities FOREIGN KEY (analysis_entity_id) REFERENCES public.tbl_analysis_entities(analysis_entity_id);


--
-- Name: tbl_sample_group_notes fk_tbl_sample_group_notes_sample_groups; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_sample_group_notes
    ADD CONSTRAINT fk_tbl_sample_group_notes_sample_groups FOREIGN KEY (sample_group_id) REFERENCES public.tbl_sample_groups(sample_group_id) ON UPDATE CASCADE;


--
-- Name: tbl_tephra_dates fk_tephra_dates_analysis_entity_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_tephra_dates
    ADD CONSTRAINT fk_tephra_dates_analysis_entity_id FOREIGN KEY (analysis_entity_id) REFERENCES public.tbl_analysis_entities(analysis_entity_id) ON UPDATE CASCADE;


--
-- Name: tbl_tephra_dates fk_tephra_dates_dating_uncertainty_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_tephra_dates
    ADD CONSTRAINT fk_tephra_dates_dating_uncertainty_id FOREIGN KEY (dating_uncertainty_id) REFERENCES public.tbl_dating_uncertainty(dating_uncertainty_id);


--
-- Name: tbl_tephra_dates fk_tephra_dates_tephra_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_tephra_dates
    ADD CONSTRAINT fk_tephra_dates_tephra_id FOREIGN KEY (tephra_id) REFERENCES public.tbl_tephras(tephra_id) ON UPDATE CASCADE;


--
-- Name: tbl_tephra_refs fk_tephra_refs_biblio_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_tephra_refs
    ADD CONSTRAINT fk_tephra_refs_biblio_id FOREIGN KEY (biblio_id) REFERENCES public.tbl_biblio(biblio_id) ON UPDATE CASCADE;


--
-- Name: tbl_tephra_refs fk_tephra_refs_tephra_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_tephra_refs
    ADD CONSTRAINT fk_tephra_refs_tephra_id FOREIGN KEY (tephra_id) REFERENCES public.tbl_tephras(tephra_id) ON UPDATE CASCADE;


--
-- Name: tbl_text_biology fk_text_biology_biblio_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_text_biology
    ADD CONSTRAINT fk_text_biology_biblio_id FOREIGN KEY (biblio_id) REFERENCES public.tbl_biblio(biblio_id) ON UPDATE CASCADE;


--
-- Name: tbl_text_biology fk_text_biology_taxon_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_text_biology
    ADD CONSTRAINT fk_text_biology_taxon_id FOREIGN KEY (taxon_id) REFERENCES public.tbl_taxa_tree_master(taxon_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbl_text_distribution fk_text_distribution_biblio_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_text_distribution
    ADD CONSTRAINT fk_text_distribution_biblio_id FOREIGN KEY (biblio_id) REFERENCES public.tbl_biblio(biblio_id) ON UPDATE CASCADE;


--
-- Name: tbl_text_distribution fk_text_distribution_taxon_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_text_distribution
    ADD CONSTRAINT fk_text_distribution_taxon_id FOREIGN KEY (taxon_id) REFERENCES public.tbl_taxa_tree_master(taxon_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbl_text_identification_keys fk_text_identification_keys_biblio_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_text_identification_keys
    ADD CONSTRAINT fk_text_identification_keys_biblio_id FOREIGN KEY (biblio_id) REFERENCES public.tbl_biblio(biblio_id) ON UPDATE CASCADE;


--
-- Name: tbl_text_identification_keys fk_text_identification_keys_taxon_id; Type: FK CONSTRAINT; Schema: public; Owner: sead_master
--

ALTER TABLE ONLY public.tbl_text_identification_keys
    ADD CONSTRAINT fk_text_identification_keys_taxon_id FOREIGN KEY (taxon_id) REFERENCES public.tbl_taxa_tree_master(taxon_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
GRANT USAGE ON SCHEMA public TO humlab_read;
GRANT ALL ON SCHEMA public TO johan;
GRANT USAGE ON SCHEMA public TO querysead_owner;
GRANT USAGE ON SCHEMA public TO querysead_worker;
GRANT USAGE ON SCHEMA public TO sead_read;
GRANT USAGE ON SCHEMA public TO sead_write;


--
-- Name: FUNCTION create_sample_position_view(); Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON FUNCTION public.create_sample_position_view() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.create_sample_position_view() FROM sead_master;
GRANT ALL ON FUNCTION public.create_sample_position_view() TO sead_master;
GRANT ALL ON FUNCTION public.create_sample_position_view() TO postgres;
GRANT ALL ON FUNCTION public.create_sample_position_view() TO PUBLIC;
GRANT ALL ON FUNCTION public.create_sample_position_view() TO sead_read;
GRANT ALL ON FUNCTION public.create_sample_position_view() TO querysead_owner;
GRANT ALL ON FUNCTION public.create_sample_position_view() TO querysead_worker;


--
-- Name: FUNCTION fn_copy_schema_tables(source_schema text, target_schema text); Type: ACL; Schema: public; Owner: clearinghouse_worker
--

REVOKE ALL ON FUNCTION public.fn_copy_schema_tables(source_schema text, target_schema text) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.fn_copy_schema_tables(source_schema text, target_schema text) FROM clearinghouse_worker;
GRANT ALL ON FUNCTION public.fn_copy_schema_tables(source_schema text, target_schema text) TO clearinghouse_worker;
GRANT ALL ON FUNCTION public.fn_copy_schema_tables(source_schema text, target_schema text) TO PUBLIC;
GRANT ALL ON FUNCTION public.fn_copy_schema_tables(source_schema text, target_schema text) TO querysead_owner;
GRANT ALL ON FUNCTION public.fn_copy_schema_tables(source_schema text, target_schema text) TO querysead_worker;


--
-- Name: FUNCTION fn_copy_schema_tables(source_schema text, target_schema text, p_dry_run boolean); Type: ACL; Schema: public; Owner: clearinghouse_worker
--

REVOKE ALL ON FUNCTION public.fn_copy_schema_tables(source_schema text, target_schema text, p_dry_run boolean) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.fn_copy_schema_tables(source_schema text, target_schema text, p_dry_run boolean) FROM clearinghouse_worker;
GRANT ALL ON FUNCTION public.fn_copy_schema_tables(source_schema text, target_schema text, p_dry_run boolean) TO clearinghouse_worker;
GRANT ALL ON FUNCTION public.fn_copy_schema_tables(source_schema text, target_schema text, p_dry_run boolean) TO PUBLIC;
GRANT ALL ON FUNCTION public.fn_copy_schema_tables(source_schema text, target_schema text, p_dry_run boolean) TO querysead_owner;
GRANT ALL ON FUNCTION public.fn_copy_schema_tables(source_schema text, target_schema text, p_dry_run boolean) TO querysead_worker;


--
-- Name: FUNCTION fn_copy_schema_tables(p_source_schema text, p_target_schema text, p_table_name text, p_dry_run boolean); Type: ACL; Schema: public; Owner: clearinghouse_worker
--

REVOKE ALL ON FUNCTION public.fn_copy_schema_tables(p_source_schema text, p_target_schema text, p_table_name text, p_dry_run boolean) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.fn_copy_schema_tables(p_source_schema text, p_target_schema text, p_table_name text, p_dry_run boolean) FROM clearinghouse_worker;
GRANT ALL ON FUNCTION public.fn_copy_schema_tables(p_source_schema text, p_target_schema text, p_table_name text, p_dry_run boolean) TO clearinghouse_worker;
GRANT ALL ON FUNCTION public.fn_copy_schema_tables(p_source_schema text, p_target_schema text, p_table_name text, p_dry_run boolean) TO PUBLIC;
GRANT ALL ON FUNCTION public.fn_copy_schema_tables(p_source_schema text, p_target_schema text, p_table_name text, p_dry_run boolean) TO querysead_owner;
GRANT ALL ON FUNCTION public.fn_copy_schema_tables(p_source_schema text, p_target_schema text, p_table_name text, p_dry_run boolean) TO querysead_worker;


--
-- Name: FUNCTION get_transform_string(method_name character varying, target_srid integer); Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON FUNCTION public.get_transform_string(method_name character varying, target_srid integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.get_transform_string(method_name character varying, target_srid integer) FROM sead_master;
GRANT ALL ON FUNCTION public.get_transform_string(method_name character varying, target_srid integer) TO sead_master;
GRANT ALL ON FUNCTION public.get_transform_string(method_name character varying, target_srid integer) TO postgres;
GRANT ALL ON FUNCTION public.get_transform_string(method_name character varying, target_srid integer) TO PUBLIC;
GRANT ALL ON FUNCTION public.get_transform_string(method_name character varying, target_srid integer) TO sead_read;
GRANT ALL ON FUNCTION public.get_transform_string(method_name character varying, target_srid integer) TO querysead_owner;
GRANT ALL ON FUNCTION public.get_transform_string(method_name character varying, target_srid integer) TO querysead_worker;


--
-- Name: FUNCTION requiredtablestructurechanges(); Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON FUNCTION public.requiredtablestructurechanges() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.requiredtablestructurechanges() FROM sead_master;
GRANT ALL ON FUNCTION public.requiredtablestructurechanges() TO sead_master;
GRANT ALL ON FUNCTION public.requiredtablestructurechanges() TO postgres;
GRANT ALL ON FUNCTION public.requiredtablestructurechanges() TO PUBLIC;
GRANT ALL ON FUNCTION public.requiredtablestructurechanges() TO sead_read;
GRANT ALL ON FUNCTION public.requiredtablestructurechanges() TO querysead_owner;
GRANT ALL ON FUNCTION public.requiredtablestructurechanges() TO querysead_worker;


--
-- Name: FUNCTION site_landing_page_site(p_site_id integer); Type: ACL; Schema: public; Owner: clearinghouse_worker
--

REVOKE ALL ON FUNCTION public.site_landing_page_site(p_site_id integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.site_landing_page_site(p_site_id integer) FROM clearinghouse_worker;
GRANT ALL ON FUNCTION public.site_landing_page_site(p_site_id integer) TO clearinghouse_worker;
GRANT ALL ON FUNCTION public.site_landing_page_site(p_site_id integer) TO PUBLIC;
GRANT ALL ON FUNCTION public.site_landing_page_site(p_site_id integer) TO querysead_owner;
GRANT ALL ON FUNCTION public.site_landing_page_site(p_site_id integer) TO querysead_worker;


--
-- Name: FUNCTION site_landing_page_site_locations(p_site_id integer); Type: ACL; Schema: public; Owner: clearinghouse_worker
--

REVOKE ALL ON FUNCTION public.site_landing_page_site_locations(p_site_id integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.site_landing_page_site_locations(p_site_id integer) FROM clearinghouse_worker;
GRANT ALL ON FUNCTION public.site_landing_page_site_locations(p_site_id integer) TO clearinghouse_worker;
GRANT ALL ON FUNCTION public.site_landing_page_site_locations(p_site_id integer) TO PUBLIC;
GRANT ALL ON FUNCTION public.site_landing_page_site_locations(p_site_id integer) TO querysead_owner;
GRANT ALL ON FUNCTION public.site_landing_page_site_locations(p_site_id integer) TO querysead_worker;


--
-- Name: FUNCTION site_landing_page_site_sample_groups(p_site_id integer); Type: ACL; Schema: public; Owner: clearinghouse_worker
--

REVOKE ALL ON FUNCTION public.site_landing_page_site_sample_groups(p_site_id integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.site_landing_page_site_sample_groups(p_site_id integer) FROM clearinghouse_worker;
GRANT ALL ON FUNCTION public.site_landing_page_site_sample_groups(p_site_id integer) TO clearinghouse_worker;
GRANT ALL ON FUNCTION public.site_landing_page_site_sample_groups(p_site_id integer) TO PUBLIC;
GRANT ALL ON FUNCTION public.site_landing_page_site_sample_groups(p_site_id integer) TO querysead_owner;
GRANT ALL ON FUNCTION public.site_landing_page_site_sample_groups(p_site_id integer) TO querysead_worker;


--
-- Name: FUNCTION site_landing_page_site_sample_section(p_site_id integer); Type: ACL; Schema: public; Owner: clearinghouse_worker
--

REVOKE ALL ON FUNCTION public.site_landing_page_site_sample_section(p_site_id integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.site_landing_page_site_sample_section(p_site_id integer) FROM clearinghouse_worker;
GRANT ALL ON FUNCTION public.site_landing_page_site_sample_section(p_site_id integer) TO clearinghouse_worker;
GRANT ALL ON FUNCTION public.site_landing_page_site_sample_section(p_site_id integer) TO PUBLIC;
GRANT ALL ON FUNCTION public.site_landing_page_site_sample_section(p_site_id integer) TO querysead_owner;
GRANT ALL ON FUNCTION public.site_landing_page_site_sample_section(p_site_id integer) TO querysead_worker;


--
-- Name: FUNCTION smallbiblioupdates(); Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON FUNCTION public.smallbiblioupdates() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.smallbiblioupdates() FROM sead_master;
GRANT ALL ON FUNCTION public.smallbiblioupdates() TO sead_master;
GRANT ALL ON FUNCTION public.smallbiblioupdates() TO postgres;
GRANT ALL ON FUNCTION public.smallbiblioupdates() TO PUBLIC;
GRANT ALL ON FUNCTION public.smallbiblioupdates() TO sead_read;
GRANT ALL ON FUNCTION public.smallbiblioupdates() TO querysead_owner;
GRANT ALL ON FUNCTION public.smallbiblioupdates() TO querysead_worker;


--
-- Name: FUNCTION syncsequences(); Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON FUNCTION public.syncsequences() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.syncsequences() FROM sead_master;
GRANT ALL ON FUNCTION public.syncsequences() TO sead_master;
GRANT ALL ON FUNCTION public.syncsequences() TO postgres;
GRANT ALL ON FUNCTION public.syncsequences() TO PUBLIC;
GRANT ALL ON FUNCTION public.syncsequences() TO sead_read;
GRANT ALL ON FUNCTION public.syncsequences() TO querysead_owner;
GRANT ALL ON FUNCTION public.syncsequences() TO querysead_worker;


--
-- Name: TABLE tbl_abundance_elements; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_abundance_elements FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_abundance_elements FROM sead_master;
GRANT ALL ON TABLE public.tbl_abundance_elements TO sead_master;
GRANT ALL ON TABLE public.tbl_abundance_elements TO postgres;
GRANT ALL ON TABLE public.tbl_abundance_elements TO sead_read;
GRANT ALL ON TABLE public.tbl_abundance_elements TO mattias;
GRANT SELECT ON TABLE public.tbl_abundance_elements TO humlab_read;
GRANT SELECT ON TABLE public.tbl_abundance_elements TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_abundance_elements TO querysead_worker;
GRANT ALL ON TABLE public.tbl_abundance_elements TO johan;


--
-- Name: TABLE tbl_abundance_ident_levels; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_abundance_ident_levels FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_abundance_ident_levels FROM sead_master;
GRANT ALL ON TABLE public.tbl_abundance_ident_levels TO sead_master;
GRANT ALL ON TABLE public.tbl_abundance_ident_levels TO postgres;
GRANT ALL ON TABLE public.tbl_abundance_ident_levels TO sead_read;
GRANT ALL ON TABLE public.tbl_abundance_ident_levels TO mattias;
GRANT SELECT ON TABLE public.tbl_abundance_ident_levels TO humlab_read;
GRANT SELECT ON TABLE public.tbl_abundance_ident_levels TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_abundance_ident_levels TO querysead_worker;
GRANT ALL ON TABLE public.tbl_abundance_ident_levels TO johan;


--
-- Name: TABLE tbl_abundance_modifications; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_abundance_modifications FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_abundance_modifications FROM sead_master;
GRANT ALL ON TABLE public.tbl_abundance_modifications TO sead_master;
GRANT ALL ON TABLE public.tbl_abundance_modifications TO postgres;
GRANT ALL ON TABLE public.tbl_abundance_modifications TO sead_read;
GRANT ALL ON TABLE public.tbl_abundance_modifications TO mattias;
GRANT SELECT ON TABLE public.tbl_abundance_modifications TO humlab_read;
GRANT SELECT ON TABLE public.tbl_abundance_modifications TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_abundance_modifications TO querysead_worker;
GRANT ALL ON TABLE public.tbl_abundance_modifications TO johan;


--
-- Name: TABLE tbl_abundances; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_abundances FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_abundances FROM sead_master;
GRANT ALL ON TABLE public.tbl_abundances TO sead_master;
GRANT ALL ON TABLE public.tbl_abundances TO postgres;
GRANT ALL ON TABLE public.tbl_abundances TO sead_read;
GRANT ALL ON TABLE public.tbl_abundances TO mattias;
GRANT SELECT ON TABLE public.tbl_abundances TO humlab_read;
GRANT SELECT ON TABLE public.tbl_abundances TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_abundances TO querysead_worker;
GRANT ALL ON TABLE public.tbl_abundances TO johan;


--
-- Name: TABLE tbl_activity_types; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_activity_types FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_activity_types FROM sead_master;
GRANT ALL ON TABLE public.tbl_activity_types TO sead_master;
GRANT ALL ON TABLE public.tbl_activity_types TO postgres;
GRANT ALL ON TABLE public.tbl_activity_types TO sead_read;
GRANT ALL ON TABLE public.tbl_activity_types TO mattias;
GRANT SELECT ON TABLE public.tbl_activity_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_activity_types TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_activity_types TO querysead_worker;
GRANT ALL ON TABLE public.tbl_activity_types TO johan;


--
-- Name: TABLE tbl_age_types; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_age_types FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_age_types FROM sead_master;
GRANT ALL ON TABLE public.tbl_age_types TO sead_master;
GRANT ALL ON TABLE public.tbl_age_types TO sead_read;
GRANT ALL ON TABLE public.tbl_age_types TO humlab_admin;
GRANT ALL ON TABLE public.tbl_age_types TO mattias;
GRANT ALL ON TABLE public.tbl_age_types TO postgres;
GRANT SELECT ON TABLE public.tbl_age_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_age_types TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_age_types TO querysead_worker;
GRANT ALL ON TABLE public.tbl_age_types TO johan;


--
-- Name: TABLE tbl_aggregate_datasets; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_aggregate_datasets FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_aggregate_datasets FROM sead_master;
GRANT ALL ON TABLE public.tbl_aggregate_datasets TO sead_master;
GRANT ALL ON TABLE public.tbl_aggregate_datasets TO postgres;
GRANT ALL ON TABLE public.tbl_aggregate_datasets TO sead_read;
GRANT ALL ON TABLE public.tbl_aggregate_datasets TO mattias;
GRANT SELECT ON TABLE public.tbl_aggregate_datasets TO humlab_read;
GRANT SELECT ON TABLE public.tbl_aggregate_datasets TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_aggregate_datasets TO querysead_worker;
GRANT ALL ON TABLE public.tbl_aggregate_datasets TO johan;


--
-- Name: TABLE tbl_aggregate_order_types; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_aggregate_order_types FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_aggregate_order_types FROM sead_master;
GRANT ALL ON TABLE public.tbl_aggregate_order_types TO sead_master;
GRANT ALL ON TABLE public.tbl_aggregate_order_types TO postgres;
GRANT ALL ON TABLE public.tbl_aggregate_order_types TO sead_read;
GRANT ALL ON TABLE public.tbl_aggregate_order_types TO mattias;
GRANT SELECT ON TABLE public.tbl_aggregate_order_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_aggregate_order_types TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_aggregate_order_types TO querysead_worker;
GRANT ALL ON TABLE public.tbl_aggregate_order_types TO johan;


--
-- Name: TABLE tbl_aggregate_sample_ages; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_aggregate_sample_ages FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_aggregate_sample_ages FROM sead_master;
GRANT ALL ON TABLE public.tbl_aggregate_sample_ages TO sead_master;
GRANT ALL ON TABLE public.tbl_aggregate_sample_ages TO postgres;
GRANT ALL ON TABLE public.tbl_aggregate_sample_ages TO sead_read;
GRANT ALL ON TABLE public.tbl_aggregate_sample_ages TO mattias;
GRANT SELECT ON TABLE public.tbl_aggregate_sample_ages TO humlab_read;
GRANT SELECT ON TABLE public.tbl_aggregate_sample_ages TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_aggregate_sample_ages TO querysead_worker;
GRANT ALL ON TABLE public.tbl_aggregate_sample_ages TO johan;


--
-- Name: TABLE tbl_aggregate_samples; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_aggregate_samples FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_aggregate_samples FROM sead_master;
GRANT ALL ON TABLE public.tbl_aggregate_samples TO sead_master;
GRANT ALL ON TABLE public.tbl_aggregate_samples TO postgres;
GRANT ALL ON TABLE public.tbl_aggregate_samples TO sead_read;
GRANT ALL ON TABLE public.tbl_aggregate_samples TO mattias;
GRANT SELECT ON TABLE public.tbl_aggregate_samples TO humlab_read;
GRANT SELECT ON TABLE public.tbl_aggregate_samples TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_aggregate_samples TO querysead_worker;
GRANT ALL ON TABLE public.tbl_aggregate_samples TO johan;


--
-- Name: TABLE tbl_alt_ref_types; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_alt_ref_types FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_alt_ref_types FROM sead_master;
GRANT ALL ON TABLE public.tbl_alt_ref_types TO sead_master;
GRANT ALL ON TABLE public.tbl_alt_ref_types TO postgres;
GRANT ALL ON TABLE public.tbl_alt_ref_types TO sead_read;
GRANT ALL ON TABLE public.tbl_alt_ref_types TO mattias;
GRANT SELECT ON TABLE public.tbl_alt_ref_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_alt_ref_types TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_alt_ref_types TO querysead_worker;
GRANT ALL ON TABLE public.tbl_alt_ref_types TO johan;


--
-- Name: TABLE tbl_analysis_entities; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_analysis_entities FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_analysis_entities FROM sead_master;
GRANT ALL ON TABLE public.tbl_analysis_entities TO sead_master;
GRANT ALL ON TABLE public.tbl_analysis_entities TO postgres;
GRANT ALL ON TABLE public.tbl_analysis_entities TO sead_read;
GRANT ALL ON TABLE public.tbl_analysis_entities TO mattias;
GRANT SELECT ON TABLE public.tbl_analysis_entities TO humlab_read;
GRANT SELECT ON TABLE public.tbl_analysis_entities TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_analysis_entities TO querysead_worker;
GRANT ALL ON TABLE public.tbl_analysis_entities TO johan;


--
-- Name: TABLE tbl_analysis_entity_ages; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_analysis_entity_ages FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_analysis_entity_ages FROM sead_master;
GRANT ALL ON TABLE public.tbl_analysis_entity_ages TO sead_master;
GRANT ALL ON TABLE public.tbl_analysis_entity_ages TO postgres;
GRANT ALL ON TABLE public.tbl_analysis_entity_ages TO sead_read;
GRANT ALL ON TABLE public.tbl_analysis_entity_ages TO mattias;
GRANT SELECT ON TABLE public.tbl_analysis_entity_ages TO humlab_read;
GRANT SELECT ON TABLE public.tbl_analysis_entity_ages TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_analysis_entity_ages TO querysead_worker;
GRANT ALL ON TABLE public.tbl_analysis_entity_ages TO johan;


--
-- Name: TABLE tbl_analysis_entity_dimensions; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_analysis_entity_dimensions FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_analysis_entity_dimensions FROM sead_master;
GRANT ALL ON TABLE public.tbl_analysis_entity_dimensions TO sead_master;
GRANT ALL ON TABLE public.tbl_analysis_entity_dimensions TO postgres;
GRANT ALL ON TABLE public.tbl_analysis_entity_dimensions TO sead_read;
GRANT ALL ON TABLE public.tbl_analysis_entity_dimensions TO mattias;
GRANT SELECT ON TABLE public.tbl_analysis_entity_dimensions TO humlab_read;
GRANT SELECT ON TABLE public.tbl_analysis_entity_dimensions TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_analysis_entity_dimensions TO querysead_worker;
GRANT ALL ON TABLE public.tbl_analysis_entity_dimensions TO johan;


--
-- Name: TABLE tbl_analysis_entity_prep_methods; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_analysis_entity_prep_methods FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_analysis_entity_prep_methods FROM sead_master;
GRANT ALL ON TABLE public.tbl_analysis_entity_prep_methods TO sead_master;
GRANT ALL ON TABLE public.tbl_analysis_entity_prep_methods TO postgres;
GRANT ALL ON TABLE public.tbl_analysis_entity_prep_methods TO sead_read;
GRANT ALL ON TABLE public.tbl_analysis_entity_prep_methods TO mattias;
GRANT SELECT ON TABLE public.tbl_analysis_entity_prep_methods TO humlab_read;
GRANT SELECT ON TABLE public.tbl_analysis_entity_prep_methods TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_analysis_entity_prep_methods TO querysead_worker;
GRANT ALL ON TABLE public.tbl_analysis_entity_prep_methods TO johan;


--
-- Name: TABLE tbl_biblio; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_biblio FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_biblio FROM sead_master;
GRANT ALL ON TABLE public.tbl_biblio TO sead_master;
GRANT ALL ON TABLE public.tbl_biblio TO postgres;
GRANT ALL ON TABLE public.tbl_biblio TO sead_read;
GRANT ALL ON TABLE public.tbl_biblio TO mattias;
GRANT SELECT ON TABLE public.tbl_biblio TO humlab_read;
GRANT SELECT ON TABLE public.tbl_biblio TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_biblio TO querysead_worker;
GRANT ALL ON TABLE public.tbl_biblio TO johan;


--
-- Name: TABLE tbl_ceramics; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_ceramics FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_ceramics FROM sead_master;
GRANT ALL ON TABLE public.tbl_ceramics TO sead_master;
GRANT ALL ON TABLE public.tbl_ceramics TO postgres;
GRANT ALL ON TABLE public.tbl_ceramics TO sead_read;
GRANT ALL ON TABLE public.tbl_ceramics TO mattias;
GRANT SELECT ON TABLE public.tbl_ceramics TO humlab_read;
GRANT SELECT ON TABLE public.tbl_ceramics TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_ceramics TO querysead_worker;
GRANT ALL ON TABLE public.tbl_ceramics TO johan;


--
-- Name: TABLE tbl_ceramics_lookup; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_ceramics_lookup FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_ceramics_lookup FROM sead_master;
GRANT ALL ON TABLE public.tbl_ceramics_lookup TO sead_master;
GRANT SELECT ON TABLE public.tbl_ceramics_lookup TO mattias;
GRANT SELECT ON TABLE public.tbl_ceramics_lookup TO humlab_read;
GRANT SELECT ON TABLE public.tbl_ceramics_lookup TO clearinghouse_worker;
GRANT SELECT ON TABLE public.tbl_ceramics_lookup TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_ceramics_lookup TO querysead_worker;
GRANT ALL ON TABLE public.tbl_ceramics_lookup TO johan;


--
-- Name: TABLE tbl_ceramics_measurements; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_ceramics_measurements FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_ceramics_measurements FROM sead_master;
GRANT ALL ON TABLE public.tbl_ceramics_measurements TO sead_master;
GRANT ALL ON TABLE public.tbl_ceramics_measurements TO postgres;
GRANT ALL ON TABLE public.tbl_ceramics_measurements TO sead_read;
GRANT ALL ON TABLE public.tbl_ceramics_measurements TO mattias;
GRANT SELECT ON TABLE public.tbl_ceramics_measurements TO humlab_read;
GRANT SELECT ON TABLE public.tbl_ceramics_measurements TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_ceramics_measurements TO querysead_worker;
GRANT ALL ON TABLE public.tbl_ceramics_measurements TO johan;


--
-- Name: TABLE tbl_chron_control_types; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_chron_control_types FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_chron_control_types FROM sead_master;
GRANT ALL ON TABLE public.tbl_chron_control_types TO sead_master;
GRANT ALL ON TABLE public.tbl_chron_control_types TO postgres;
GRANT ALL ON TABLE public.tbl_chron_control_types TO sead_read;
GRANT ALL ON TABLE public.tbl_chron_control_types TO mattias;
GRANT SELECT ON TABLE public.tbl_chron_control_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_chron_control_types TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_chron_control_types TO querysead_worker;
GRANT ALL ON TABLE public.tbl_chron_control_types TO johan;


--
-- Name: TABLE tbl_chron_controls; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_chron_controls FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_chron_controls FROM sead_master;
GRANT ALL ON TABLE public.tbl_chron_controls TO sead_master;
GRANT ALL ON TABLE public.tbl_chron_controls TO postgres;
GRANT ALL ON TABLE public.tbl_chron_controls TO sead_read;
GRANT ALL ON TABLE public.tbl_chron_controls TO mattias;
GRANT SELECT ON TABLE public.tbl_chron_controls TO humlab_read;
GRANT SELECT ON TABLE public.tbl_chron_controls TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_chron_controls TO querysead_worker;
GRANT ALL ON TABLE public.tbl_chron_controls TO johan;


--
-- Name: TABLE tbl_chronologies; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_chronologies FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_chronologies FROM sead_master;
GRANT ALL ON TABLE public.tbl_chronologies TO sead_master;
GRANT ALL ON TABLE public.tbl_chronologies TO postgres;
GRANT ALL ON TABLE public.tbl_chronologies TO sead_read;
GRANT ALL ON TABLE public.tbl_chronologies TO mattias;
GRANT SELECT ON TABLE public.tbl_chronologies TO humlab_read;
GRANT SELECT ON TABLE public.tbl_chronologies TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_chronologies TO querysead_worker;
GRANT ALL ON TABLE public.tbl_chronologies TO johan;


--
-- Name: TABLE tbl_colours; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_colours FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_colours FROM sead_master;
GRANT ALL ON TABLE public.tbl_colours TO sead_master;
GRANT ALL ON TABLE public.tbl_colours TO postgres;
GRANT ALL ON TABLE public.tbl_colours TO sead_read;
GRANT ALL ON TABLE public.tbl_colours TO mattias;
GRANT SELECT ON TABLE public.tbl_colours TO humlab_read;
GRANT SELECT ON TABLE public.tbl_colours TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_colours TO querysead_worker;
GRANT ALL ON TABLE public.tbl_colours TO johan;


--
-- Name: TABLE tbl_contact_types; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_contact_types FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_contact_types FROM sead_master;
GRANT ALL ON TABLE public.tbl_contact_types TO sead_master;
GRANT ALL ON TABLE public.tbl_contact_types TO postgres;
GRANT ALL ON TABLE public.tbl_contact_types TO sead_read;
GRANT ALL ON TABLE public.tbl_contact_types TO mattias;
GRANT SELECT ON TABLE public.tbl_contact_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_contact_types TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_contact_types TO querysead_worker;
GRANT ALL ON TABLE public.tbl_contact_types TO johan;


--
-- Name: TABLE tbl_contacts; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_contacts FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_contacts FROM sead_master;
GRANT ALL ON TABLE public.tbl_contacts TO sead_master;
GRANT ALL ON TABLE public.tbl_contacts TO postgres;
GRANT ALL ON TABLE public.tbl_contacts TO sead_read;
GRANT ALL ON TABLE public.tbl_contacts TO mattias;
GRANT SELECT ON TABLE public.tbl_contacts TO humlab_read;
GRANT SELECT ON TABLE public.tbl_contacts TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_contacts TO querysead_worker;
GRANT ALL ON TABLE public.tbl_contacts TO johan;


--
-- Name: TABLE tbl_coordinate_method_dimensions; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_coordinate_method_dimensions FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_coordinate_method_dimensions FROM sead_master;
GRANT ALL ON TABLE public.tbl_coordinate_method_dimensions TO sead_master;
GRANT ALL ON TABLE public.tbl_coordinate_method_dimensions TO postgres;
GRANT ALL ON TABLE public.tbl_coordinate_method_dimensions TO sead_read;
GRANT ALL ON TABLE public.tbl_coordinate_method_dimensions TO mattias;
GRANT SELECT ON TABLE public.tbl_coordinate_method_dimensions TO humlab_read;
GRANT SELECT ON TABLE public.tbl_coordinate_method_dimensions TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_coordinate_method_dimensions TO querysead_worker;
GRANT ALL ON TABLE public.tbl_coordinate_method_dimensions TO johan;


--
-- Name: TABLE tbl_data_type_groups; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_data_type_groups FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_data_type_groups FROM sead_master;
GRANT ALL ON TABLE public.tbl_data_type_groups TO sead_master;
GRANT ALL ON TABLE public.tbl_data_type_groups TO postgres;
GRANT ALL ON TABLE public.tbl_data_type_groups TO sead_read;
GRANT ALL ON TABLE public.tbl_data_type_groups TO mattias;
GRANT SELECT ON TABLE public.tbl_data_type_groups TO humlab_read;
GRANT SELECT ON TABLE public.tbl_data_type_groups TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_data_type_groups TO querysead_worker;
GRANT ALL ON TABLE public.tbl_data_type_groups TO johan;


--
-- Name: TABLE tbl_data_types; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_data_types FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_data_types FROM sead_master;
GRANT ALL ON TABLE public.tbl_data_types TO sead_master;
GRANT ALL ON TABLE public.tbl_data_types TO postgres;
GRANT ALL ON TABLE public.tbl_data_types TO sead_read;
GRANT ALL ON TABLE public.tbl_data_types TO mattias;
GRANT SELECT ON TABLE public.tbl_data_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_data_types TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_data_types TO querysead_worker;
GRANT ALL ON TABLE public.tbl_data_types TO johan;


--
-- Name: TABLE tbl_identification_levels; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_identification_levels FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_identification_levels FROM sead_master;
GRANT ALL ON TABLE public.tbl_identification_levels TO sead_master;
GRANT ALL ON TABLE public.tbl_identification_levels TO postgres;
GRANT ALL ON TABLE public.tbl_identification_levels TO sead_read;
GRANT ALL ON TABLE public.tbl_identification_levels TO mattias;
GRANT SELECT ON TABLE public.tbl_identification_levels TO humlab_read;
GRANT SELECT ON TABLE public.tbl_identification_levels TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_identification_levels TO querysead_worker;
GRANT ALL ON TABLE public.tbl_identification_levels TO johan;


--
-- Name: TABLE tbl_modification_types; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_modification_types FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_modification_types FROM sead_master;
GRANT ALL ON TABLE public.tbl_modification_types TO sead_master;
GRANT ALL ON TABLE public.tbl_modification_types TO postgres;
GRANT ALL ON TABLE public.tbl_modification_types TO sead_read;
GRANT ALL ON TABLE public.tbl_modification_types TO mattias;
GRANT SELECT ON TABLE public.tbl_modification_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_modification_types TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_modification_types TO querysead_worker;
GRANT ALL ON TABLE public.tbl_modification_types TO johan;


--
-- Name: TABLE tbl_datasets; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_datasets FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_datasets FROM sead_master;
GRANT ALL ON TABLE public.tbl_datasets TO sead_master;
GRANT ALL ON TABLE public.tbl_datasets TO postgres;
GRANT ALL ON TABLE public.tbl_datasets TO sead_read;
GRANT ALL ON TABLE public.tbl_datasets TO mattias;
GRANT SELECT ON TABLE public.tbl_datasets TO humlab_read;
GRANT SELECT ON TABLE public.tbl_datasets TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_datasets TO querysead_worker;
GRANT ALL ON TABLE public.tbl_datasets TO johan;


--
-- Name: TABLE tbl_physical_samples; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_physical_samples FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_physical_samples FROM sead_master;
GRANT ALL ON TABLE public.tbl_physical_samples TO sead_master;
GRANT ALL ON TABLE public.tbl_physical_samples TO postgres;
GRANT ALL ON TABLE public.tbl_physical_samples TO sead_read;
GRANT ALL ON TABLE public.tbl_physical_samples TO mattias;
GRANT SELECT ON TABLE public.tbl_physical_samples TO humlab_read;
GRANT SELECT ON TABLE public.tbl_physical_samples TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_physical_samples TO querysead_worker;
GRANT ALL ON TABLE public.tbl_physical_samples TO johan;


--
-- Name: TABLE tbl_taxa_tree_genera; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_taxa_tree_genera FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_taxa_tree_genera FROM sead_master;
GRANT ALL ON TABLE public.tbl_taxa_tree_genera TO sead_master;
GRANT ALL ON TABLE public.tbl_taxa_tree_genera TO postgres;
GRANT ALL ON TABLE public.tbl_taxa_tree_genera TO sead_read;
GRANT ALL ON TABLE public.tbl_taxa_tree_genera TO mattias;
GRANT SELECT ON TABLE public.tbl_taxa_tree_genera TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxa_tree_genera TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_taxa_tree_genera TO querysead_worker;
GRANT ALL ON TABLE public.tbl_taxa_tree_genera TO johan;


--
-- Name: TABLE tbl_taxa_tree_master; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_taxa_tree_master FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_taxa_tree_master FROM sead_master;
GRANT ALL ON TABLE public.tbl_taxa_tree_master TO sead_master;
GRANT ALL ON TABLE public.tbl_taxa_tree_master TO postgres;
GRANT ALL ON TABLE public.tbl_taxa_tree_master TO sead_read;
GRANT ALL ON TABLE public.tbl_taxa_tree_master TO mattias;
GRANT SELECT ON TABLE public.tbl_taxa_tree_master TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxa_tree_master TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_taxa_tree_master TO querysead_worker;
GRANT ALL ON TABLE public.tbl_taxa_tree_master TO johan;


--
-- Name: TABLE tbl_dataset_contacts; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_dataset_contacts FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_dataset_contacts FROM sead_master;
GRANT ALL ON TABLE public.tbl_dataset_contacts TO sead_master;
GRANT ALL ON TABLE public.tbl_dataset_contacts TO postgres;
GRANT ALL ON TABLE public.tbl_dataset_contacts TO sead_read;
GRANT ALL ON TABLE public.tbl_dataset_contacts TO mattias;
GRANT SELECT ON TABLE public.tbl_dataset_contacts TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dataset_contacts TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_dataset_contacts TO querysead_worker;
GRANT ALL ON TABLE public.tbl_dataset_contacts TO johan;


--
-- Name: TABLE tbl_dataset_masters; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_dataset_masters FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_dataset_masters FROM sead_master;
GRANT ALL ON TABLE public.tbl_dataset_masters TO sead_master;
GRANT ALL ON TABLE public.tbl_dataset_masters TO postgres;
GRANT ALL ON TABLE public.tbl_dataset_masters TO sead_read;
GRANT ALL ON TABLE public.tbl_dataset_masters TO mattias;
GRANT SELECT ON TABLE public.tbl_dataset_masters TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dataset_masters TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_dataset_masters TO querysead_worker;
GRANT ALL ON TABLE public.tbl_dataset_masters TO johan;


--
-- Name: TABLE tbl_dimensions; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_dimensions FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_dimensions FROM sead_master;
GRANT ALL ON TABLE public.tbl_dimensions TO sead_master;
GRANT ALL ON TABLE public.tbl_dimensions TO postgres;
GRANT ALL ON TABLE public.tbl_dimensions TO sead_read;
GRANT ALL ON TABLE public.tbl_dimensions TO mattias;
GRANT SELECT ON TABLE public.tbl_dimensions TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dimensions TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_dimensions TO querysead_worker;
GRANT ALL ON TABLE public.tbl_dimensions TO johan;


--
-- Name: TABLE tbl_measured_value_dimensions; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_measured_value_dimensions FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_measured_value_dimensions FROM sead_master;
GRANT ALL ON TABLE public.tbl_measured_value_dimensions TO sead_master;
GRANT ALL ON TABLE public.tbl_measured_value_dimensions TO postgres;
GRANT ALL ON TABLE public.tbl_measured_value_dimensions TO sead_read;
GRANT ALL ON TABLE public.tbl_measured_value_dimensions TO mattias;
GRANT SELECT ON TABLE public.tbl_measured_value_dimensions TO humlab_read;
GRANT SELECT ON TABLE public.tbl_measured_value_dimensions TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_measured_value_dimensions TO querysead_worker;
GRANT ALL ON TABLE public.tbl_measured_value_dimensions TO johan;


--
-- Name: TABLE tbl_measured_values; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_measured_values FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_measured_values FROM sead_master;
GRANT ALL ON TABLE public.tbl_measured_values TO sead_master;
GRANT ALL ON TABLE public.tbl_measured_values TO postgres;
GRANT ALL ON TABLE public.tbl_measured_values TO sead_read;
GRANT ALL ON TABLE public.tbl_measured_values TO mattias;
GRANT SELECT ON TABLE public.tbl_measured_values TO humlab_read;
GRANT SELECT ON TABLE public.tbl_measured_values TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_measured_values TO querysead_worker;
GRANT ALL ON TABLE public.tbl_measured_values TO johan;


--
-- Name: TABLE tbl_methods; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_methods FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_methods FROM sead_master;
GRANT ALL ON TABLE public.tbl_methods TO sead_master;
GRANT ALL ON TABLE public.tbl_methods TO postgres;
GRANT ALL ON TABLE public.tbl_methods TO sead_read;
GRANT ALL ON TABLE public.tbl_methods TO mattias;
GRANT SELECT ON TABLE public.tbl_methods TO humlab_read;
GRANT SELECT ON TABLE public.tbl_methods TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_methods TO querysead_worker;
GRANT ALL ON TABLE public.tbl_methods TO johan;


--
-- Name: TABLE tbl_dataset_submission_types; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_dataset_submission_types FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_dataset_submission_types FROM sead_master;
GRANT ALL ON TABLE public.tbl_dataset_submission_types TO sead_master;
GRANT ALL ON TABLE public.tbl_dataset_submission_types TO postgres;
GRANT ALL ON TABLE public.tbl_dataset_submission_types TO sead_read;
GRANT ALL ON TABLE public.tbl_dataset_submission_types TO mattias;
GRANT SELECT ON TABLE public.tbl_dataset_submission_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dataset_submission_types TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_dataset_submission_types TO querysead_worker;
GRANT ALL ON TABLE public.tbl_dataset_submission_types TO johan;


--
-- Name: TABLE tbl_dataset_submissions; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_dataset_submissions FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_dataset_submissions FROM sead_master;
GRANT ALL ON TABLE public.tbl_dataset_submissions TO sead_master;
GRANT ALL ON TABLE public.tbl_dataset_submissions TO postgres;
GRANT ALL ON TABLE public.tbl_dataset_submissions TO sead_read;
GRANT ALL ON TABLE public.tbl_dataset_submissions TO mattias;
GRANT SELECT ON TABLE public.tbl_dataset_submissions TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dataset_submissions TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_dataset_submissions TO querysead_worker;
GRANT ALL ON TABLE public.tbl_dataset_submissions TO johan;


--
-- Name: TABLE tbl_dating_labs; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_dating_labs FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_dating_labs FROM sead_master;
GRANT ALL ON TABLE public.tbl_dating_labs TO sead_master;
GRANT ALL ON TABLE public.tbl_dating_labs TO postgres;
GRANT ALL ON TABLE public.tbl_dating_labs TO sead_read;
GRANT ALL ON TABLE public.tbl_dating_labs TO mattias;
GRANT SELECT ON TABLE public.tbl_dating_labs TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dating_labs TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_dating_labs TO querysead_worker;
GRANT ALL ON TABLE public.tbl_dating_labs TO johan;


--
-- Name: TABLE tbl_dating_material; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_dating_material FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_dating_material FROM sead_master;
GRANT ALL ON TABLE public.tbl_dating_material TO sead_master;
GRANT ALL ON TABLE public.tbl_dating_material TO postgres;
GRANT ALL ON TABLE public.tbl_dating_material TO sead_read;
GRANT ALL ON TABLE public.tbl_dating_material TO mattias;
GRANT SELECT ON TABLE public.tbl_dating_material TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dating_material TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_dating_material TO querysead_worker;
GRANT ALL ON TABLE public.tbl_dating_material TO johan;


--
-- Name: TABLE tbl_dating_uncertainty; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_dating_uncertainty FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_dating_uncertainty FROM sead_master;
GRANT ALL ON TABLE public.tbl_dating_uncertainty TO sead_master;
GRANT ALL ON TABLE public.tbl_dating_uncertainty TO postgres;
GRANT ALL ON TABLE public.tbl_dating_uncertainty TO sead_read;
GRANT ALL ON TABLE public.tbl_dating_uncertainty TO mattias;
GRANT SELECT ON TABLE public.tbl_dating_uncertainty TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dating_uncertainty TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_dating_uncertainty TO querysead_worker;
GRANT ALL ON TABLE public.tbl_dating_uncertainty TO johan;


--
-- Name: TABLE tbl_dendro; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_dendro FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_dendro FROM sead_master;
GRANT ALL ON TABLE public.tbl_dendro TO sead_master;
GRANT ALL ON TABLE public.tbl_dendro TO postgres;
GRANT ALL ON TABLE public.tbl_dendro TO sead_read;
GRANT ALL ON TABLE public.tbl_dendro TO mattias;
GRANT SELECT ON TABLE public.tbl_dendro TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dendro TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_dendro TO querysead_worker;
GRANT ALL ON TABLE public.tbl_dendro TO johan;


--
-- Name: TABLE tbl_dendro_date_notes; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_dendro_date_notes FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_dendro_date_notes FROM sead_master;
GRANT ALL ON TABLE public.tbl_dendro_date_notes TO sead_master;
GRANT ALL ON TABLE public.tbl_dendro_date_notes TO postgres;
GRANT ALL ON TABLE public.tbl_dendro_date_notes TO sead_read;
GRANT ALL ON TABLE public.tbl_dendro_date_notes TO mattias;
GRANT SELECT ON TABLE public.tbl_dendro_date_notes TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dendro_date_notes TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_dendro_date_notes TO querysead_worker;
GRANT ALL ON TABLE public.tbl_dendro_date_notes TO johan;


--
-- Name: TABLE tbl_dendro_dates; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_dendro_dates FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_dendro_dates FROM sead_master;
GRANT ALL ON TABLE public.tbl_dendro_dates TO sead_master;
GRANT ALL ON TABLE public.tbl_dendro_dates TO postgres;
GRANT ALL ON TABLE public.tbl_dendro_dates TO sead_read;
GRANT ALL ON TABLE public.tbl_dendro_dates TO mattias;
GRANT SELECT ON TABLE public.tbl_dendro_dates TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dendro_dates TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_dendro_dates TO querysead_worker;
GRANT ALL ON TABLE public.tbl_dendro_dates TO johan;


--
-- Name: TABLE tbl_dendro_lookup; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_dendro_lookup FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_dendro_lookup FROM sead_master;
GRANT ALL ON TABLE public.tbl_dendro_lookup TO sead_master;
GRANT SELECT ON TABLE public.tbl_dendro_lookup TO mattias;
GRANT SELECT ON TABLE public.tbl_dendro_lookup TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_dendro_lookup TO querysead_worker;
GRANT ALL ON TABLE public.tbl_dendro_lookup TO johan;


--
-- Name: TABLE tbl_dendro_measurements; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_dendro_measurements FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_dendro_measurements FROM sead_master;
GRANT ALL ON TABLE public.tbl_dendro_measurements TO sead_master;
GRANT ALL ON TABLE public.tbl_dendro_measurements TO postgres;
GRANT ALL ON TABLE public.tbl_dendro_measurements TO sead_read;
GRANT ALL ON TABLE public.tbl_dendro_measurements TO mattias;
GRANT SELECT ON TABLE public.tbl_dendro_measurements TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dendro_measurements TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_dendro_measurements TO querysead_worker;
GRANT ALL ON TABLE public.tbl_dendro_measurements TO johan;


--
-- Name: TABLE tbl_ecocode_definitions; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_ecocode_definitions FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_ecocode_definitions FROM sead_master;
GRANT ALL ON TABLE public.tbl_ecocode_definitions TO sead_master;
GRANT ALL ON TABLE public.tbl_ecocode_definitions TO postgres;
GRANT ALL ON TABLE public.tbl_ecocode_definitions TO sead_read;
GRANT ALL ON TABLE public.tbl_ecocode_definitions TO mattias;
GRANT SELECT ON TABLE public.tbl_ecocode_definitions TO humlab_read;
GRANT SELECT ON TABLE public.tbl_ecocode_definitions TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_ecocode_definitions TO querysead_worker;
GRANT ALL ON TABLE public.tbl_ecocode_definitions TO johan;


--
-- Name: TABLE tbl_ecocode_groups; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_ecocode_groups FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_ecocode_groups FROM sead_master;
GRANT ALL ON TABLE public.tbl_ecocode_groups TO sead_master;
GRANT ALL ON TABLE public.tbl_ecocode_groups TO postgres;
GRANT ALL ON TABLE public.tbl_ecocode_groups TO sead_read;
GRANT ALL ON TABLE public.tbl_ecocode_groups TO mattias;
GRANT SELECT ON TABLE public.tbl_ecocode_groups TO humlab_read;
GRANT SELECT ON TABLE public.tbl_ecocode_groups TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_ecocode_groups TO querysead_worker;
GRANT ALL ON TABLE public.tbl_ecocode_groups TO johan;


--
-- Name: TABLE tbl_ecocode_systems; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_ecocode_systems FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_ecocode_systems FROM sead_master;
GRANT ALL ON TABLE public.tbl_ecocode_systems TO sead_master;
GRANT ALL ON TABLE public.tbl_ecocode_systems TO postgres;
GRANT ALL ON TABLE public.tbl_ecocode_systems TO sead_read;
GRANT ALL ON TABLE public.tbl_ecocode_systems TO mattias;
GRANT SELECT ON TABLE public.tbl_ecocode_systems TO humlab_read;
GRANT SELECT ON TABLE public.tbl_ecocode_systems TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_ecocode_systems TO querysead_worker;
GRANT ALL ON TABLE public.tbl_ecocode_systems TO johan;


--
-- Name: TABLE tbl_ecocodes; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_ecocodes FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_ecocodes FROM sead_master;
GRANT ALL ON TABLE public.tbl_ecocodes TO sead_master;
GRANT ALL ON TABLE public.tbl_ecocodes TO postgres;
GRANT ALL ON TABLE public.tbl_ecocodes TO sead_read;
GRANT ALL ON TABLE public.tbl_ecocodes TO mattias;
GRANT SELECT ON TABLE public.tbl_ecocodes TO humlab_read;
GRANT SELECT ON TABLE public.tbl_ecocodes TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_ecocodes TO querysead_worker;
GRANT ALL ON TABLE public.tbl_ecocodes TO johan;


--
-- Name: TABLE tbl_error_uncertainties; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_error_uncertainties FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_error_uncertainties FROM sead_master;
GRANT ALL ON TABLE public.tbl_error_uncertainties TO sead_master;
GRANT ALL ON TABLE public.tbl_error_uncertainties TO sead_read;
GRANT ALL ON TABLE public.tbl_error_uncertainties TO humlab_admin;
GRANT ALL ON TABLE public.tbl_error_uncertainties TO mattias;
GRANT ALL ON TABLE public.tbl_error_uncertainties TO postgres;
GRANT SELECT ON TABLE public.tbl_error_uncertainties TO humlab_read;
GRANT SELECT ON TABLE public.tbl_error_uncertainties TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_error_uncertainties TO querysead_worker;
GRANT ALL ON TABLE public.tbl_error_uncertainties TO johan;


--
-- Name: TABLE tbl_feature_types; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_feature_types FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_feature_types FROM sead_master;
GRANT ALL ON TABLE public.tbl_feature_types TO sead_master;
GRANT ALL ON TABLE public.tbl_feature_types TO postgres;
GRANT ALL ON TABLE public.tbl_feature_types TO sead_read;
GRANT ALL ON TABLE public.tbl_feature_types TO mattias;
GRANT SELECT ON TABLE public.tbl_feature_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_feature_types TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_feature_types TO querysead_worker;
GRANT ALL ON TABLE public.tbl_feature_types TO johan;


--
-- Name: TABLE tbl_features; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_features FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_features FROM sead_master;
GRANT ALL ON TABLE public.tbl_features TO sead_master;
GRANT ALL ON TABLE public.tbl_features TO postgres;
GRANT ALL ON TABLE public.tbl_features TO sead_read;
GRANT ALL ON TABLE public.tbl_features TO mattias;
GRANT SELECT ON TABLE public.tbl_features TO humlab_read;
GRANT SELECT ON TABLE public.tbl_features TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_features TO querysead_worker;
GRANT ALL ON TABLE public.tbl_features TO johan;


--
-- Name: TABLE tbl_geochron_refs; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_geochron_refs FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_geochron_refs FROM sead_master;
GRANT ALL ON TABLE public.tbl_geochron_refs TO sead_master;
GRANT ALL ON TABLE public.tbl_geochron_refs TO postgres;
GRANT ALL ON TABLE public.tbl_geochron_refs TO sead_read;
GRANT ALL ON TABLE public.tbl_geochron_refs TO mattias;
GRANT SELECT ON TABLE public.tbl_geochron_refs TO humlab_read;
GRANT SELECT ON TABLE public.tbl_geochron_refs TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_geochron_refs TO querysead_worker;
GRANT ALL ON TABLE public.tbl_geochron_refs TO johan;


--
-- Name: TABLE tbl_geochronology; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_geochronology FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_geochronology FROM sead_master;
GRANT ALL ON TABLE public.tbl_geochronology TO sead_master;
GRANT ALL ON TABLE public.tbl_geochronology TO postgres;
GRANT ALL ON TABLE public.tbl_geochronology TO sead_read;
GRANT ALL ON TABLE public.tbl_geochronology TO mattias;
GRANT SELECT ON TABLE public.tbl_geochronology TO humlab_read;
GRANT SELECT ON TABLE public.tbl_geochronology TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_geochronology TO querysead_worker;
GRANT ALL ON TABLE public.tbl_geochronology TO johan;


--
-- Name: TABLE tbl_horizons; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_horizons FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_horizons FROM sead_master;
GRANT ALL ON TABLE public.tbl_horizons TO sead_master;
GRANT ALL ON TABLE public.tbl_horizons TO postgres;
GRANT ALL ON TABLE public.tbl_horizons TO sead_read;
GRANT ALL ON TABLE public.tbl_horizons TO mattias;
GRANT SELECT ON TABLE public.tbl_horizons TO humlab_read;
GRANT SELECT ON TABLE public.tbl_horizons TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_horizons TO querysead_worker;
GRANT ALL ON TABLE public.tbl_horizons TO johan;


--
-- Name: TABLE tbl_image_types; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_image_types FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_image_types FROM sead_master;
GRANT ALL ON TABLE public.tbl_image_types TO sead_master;
GRANT ALL ON TABLE public.tbl_image_types TO postgres;
GRANT ALL ON TABLE public.tbl_image_types TO sead_read;
GRANT ALL ON TABLE public.tbl_image_types TO mattias;
GRANT SELECT ON TABLE public.tbl_image_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_image_types TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_image_types TO querysead_worker;
GRANT ALL ON TABLE public.tbl_image_types TO johan;


--
-- Name: TABLE tbl_imported_taxa_replacements; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_imported_taxa_replacements FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_imported_taxa_replacements FROM sead_master;
GRANT ALL ON TABLE public.tbl_imported_taxa_replacements TO sead_master;
GRANT ALL ON TABLE public.tbl_imported_taxa_replacements TO postgres;
GRANT ALL ON TABLE public.tbl_imported_taxa_replacements TO sead_read;
GRANT ALL ON TABLE public.tbl_imported_taxa_replacements TO mattias;
GRANT SELECT ON TABLE public.tbl_imported_taxa_replacements TO humlab_read;
GRANT SELECT ON TABLE public.tbl_imported_taxa_replacements TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_imported_taxa_replacements TO querysead_worker;
GRANT ALL ON TABLE public.tbl_imported_taxa_replacements TO johan;


--
-- Name: TABLE tbl_languages; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_languages FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_languages FROM sead_master;
GRANT ALL ON TABLE public.tbl_languages TO sead_master;
GRANT ALL ON TABLE public.tbl_languages TO postgres;
GRANT ALL ON TABLE public.tbl_languages TO sead_read;
GRANT ALL ON TABLE public.tbl_languages TO mattias;
GRANT SELECT ON TABLE public.tbl_languages TO humlab_read;
GRANT SELECT ON TABLE public.tbl_languages TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_languages TO querysead_worker;
GRANT ALL ON TABLE public.tbl_languages TO johan;


--
-- Name: TABLE tbl_lithology; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_lithology FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_lithology FROM sead_master;
GRANT ALL ON TABLE public.tbl_lithology TO sead_master;
GRANT ALL ON TABLE public.tbl_lithology TO postgres;
GRANT ALL ON TABLE public.tbl_lithology TO sead_read;
GRANT ALL ON TABLE public.tbl_lithology TO mattias;
GRANT SELECT ON TABLE public.tbl_lithology TO humlab_read;
GRANT SELECT ON TABLE public.tbl_lithology TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_lithology TO querysead_worker;
GRANT ALL ON TABLE public.tbl_lithology TO johan;


--
-- Name: TABLE tbl_location_types; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_location_types FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_location_types FROM sead_master;
GRANT ALL ON TABLE public.tbl_location_types TO sead_master;
GRANT ALL ON TABLE public.tbl_location_types TO postgres;
GRANT ALL ON TABLE public.tbl_location_types TO sead_read;
GRANT ALL ON TABLE public.tbl_location_types TO mattias;
GRANT SELECT ON TABLE public.tbl_location_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_location_types TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_location_types TO querysead_worker;
GRANT ALL ON TABLE public.tbl_location_types TO johan;


--
-- Name: TABLE tbl_locations; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_locations FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_locations FROM sead_master;
GRANT ALL ON TABLE public.tbl_locations TO sead_master;
GRANT ALL ON TABLE public.tbl_locations TO postgres;
GRANT ALL ON TABLE public.tbl_locations TO sead_read;
GRANT ALL ON TABLE public.tbl_locations TO mattias;
GRANT SELECT ON TABLE public.tbl_locations TO humlab_read;
GRANT SELECT ON TABLE public.tbl_locations TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_locations TO querysead_worker;
GRANT ALL ON TABLE public.tbl_locations TO johan;


--
-- Name: TABLE tbl_mcr_names; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_mcr_names FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_mcr_names FROM sead_master;
GRANT ALL ON TABLE public.tbl_mcr_names TO sead_master;
GRANT ALL ON TABLE public.tbl_mcr_names TO postgres;
GRANT ALL ON TABLE public.tbl_mcr_names TO sead_read;
GRANT ALL ON TABLE public.tbl_mcr_names TO mattias;
GRANT SELECT ON TABLE public.tbl_mcr_names TO humlab_read;
GRANT SELECT ON TABLE public.tbl_mcr_names TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_mcr_names TO querysead_worker;
GRANT ALL ON TABLE public.tbl_mcr_names TO johan;


--
-- Name: TABLE tbl_mcr_summary_data; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_mcr_summary_data FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_mcr_summary_data FROM sead_master;
GRANT ALL ON TABLE public.tbl_mcr_summary_data TO sead_master;
GRANT ALL ON TABLE public.tbl_mcr_summary_data TO postgres;
GRANT ALL ON TABLE public.tbl_mcr_summary_data TO sead_read;
GRANT ALL ON TABLE public.tbl_mcr_summary_data TO mattias;
GRANT SELECT ON TABLE public.tbl_mcr_summary_data TO humlab_read;
GRANT SELECT ON TABLE public.tbl_mcr_summary_data TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_mcr_summary_data TO querysead_worker;
GRANT ALL ON TABLE public.tbl_mcr_summary_data TO johan;


--
-- Name: TABLE tbl_mcrdata_birmbeetledat; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_mcrdata_birmbeetledat FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_mcrdata_birmbeetledat FROM sead_master;
GRANT ALL ON TABLE public.tbl_mcrdata_birmbeetledat TO sead_master;
GRANT ALL ON TABLE public.tbl_mcrdata_birmbeetledat TO postgres;
GRANT ALL ON TABLE public.tbl_mcrdata_birmbeetledat TO sead_read;
GRANT ALL ON TABLE public.tbl_mcrdata_birmbeetledat TO mattias;
GRANT SELECT ON TABLE public.tbl_mcrdata_birmbeetledat TO humlab_read;
GRANT SELECT ON TABLE public.tbl_mcrdata_birmbeetledat TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_mcrdata_birmbeetledat TO querysead_worker;
GRANT ALL ON TABLE public.tbl_mcrdata_birmbeetledat TO johan;


--
-- Name: TABLE tbl_method_groups; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_method_groups FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_method_groups FROM sead_master;
GRANT ALL ON TABLE public.tbl_method_groups TO sead_master;
GRANT ALL ON TABLE public.tbl_method_groups TO postgres;
GRANT ALL ON TABLE public.tbl_method_groups TO sead_read;
GRANT ALL ON TABLE public.tbl_method_groups TO mattias;
GRANT SELECT ON TABLE public.tbl_method_groups TO humlab_read;
GRANT SELECT ON TABLE public.tbl_method_groups TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_method_groups TO querysead_worker;
GRANT ALL ON TABLE public.tbl_method_groups TO johan;


--
-- Name: TABLE tbl_physical_sample_features; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_physical_sample_features FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_physical_sample_features FROM sead_master;
GRANT ALL ON TABLE public.tbl_physical_sample_features TO sead_master;
GRANT ALL ON TABLE public.tbl_physical_sample_features TO postgres;
GRANT ALL ON TABLE public.tbl_physical_sample_features TO sead_read;
GRANT ALL ON TABLE public.tbl_physical_sample_features TO mattias;
GRANT SELECT ON TABLE public.tbl_physical_sample_features TO humlab_read;
GRANT SELECT ON TABLE public.tbl_physical_sample_features TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_physical_sample_features TO querysead_worker;
GRANT ALL ON TABLE public.tbl_physical_sample_features TO johan;


--
-- Name: TABLE tbl_project_stages; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_project_stages FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_project_stages FROM sead_master;
GRANT ALL ON TABLE public.tbl_project_stages TO sead_master;
GRANT ALL ON TABLE public.tbl_project_stages TO postgres;
GRANT ALL ON TABLE public.tbl_project_stages TO sead_read;
GRANT ALL ON TABLE public.tbl_project_stages TO mattias;
GRANT SELECT ON TABLE public.tbl_project_stages TO humlab_read;
GRANT SELECT ON TABLE public.tbl_project_stages TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_project_stages TO querysead_worker;
GRANT ALL ON TABLE public.tbl_project_stages TO johan;


--
-- Name: TABLE tbl_project_types; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_project_types FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_project_types FROM sead_master;
GRANT ALL ON TABLE public.tbl_project_types TO sead_master;
GRANT ALL ON TABLE public.tbl_project_types TO postgres;
GRANT ALL ON TABLE public.tbl_project_types TO sead_read;
GRANT ALL ON TABLE public.tbl_project_types TO mattias;
GRANT SELECT ON TABLE public.tbl_project_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_project_types TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_project_types TO querysead_worker;
GRANT ALL ON TABLE public.tbl_project_types TO johan;


--
-- Name: TABLE tbl_projects; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_projects FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_projects FROM sead_master;
GRANT ALL ON TABLE public.tbl_projects TO sead_master;
GRANT ALL ON TABLE public.tbl_projects TO postgres;
GRANT ALL ON TABLE public.tbl_projects TO sead_read;
GRANT ALL ON TABLE public.tbl_projects TO mattias;
GRANT SELECT ON TABLE public.tbl_projects TO humlab_read;
GRANT SELECT ON TABLE public.tbl_projects TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_projects TO querysead_worker;
GRANT ALL ON TABLE public.tbl_projects TO johan;


--
-- Name: TABLE tbl_rdb; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_rdb FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_rdb FROM sead_master;
GRANT ALL ON TABLE public.tbl_rdb TO sead_master;
GRANT ALL ON TABLE public.tbl_rdb TO postgres;
GRANT ALL ON TABLE public.tbl_rdb TO sead_read;
GRANT ALL ON TABLE public.tbl_rdb TO mattias;
GRANT SELECT ON TABLE public.tbl_rdb TO humlab_read;
GRANT SELECT ON TABLE public.tbl_rdb TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_rdb TO querysead_worker;
GRANT ALL ON TABLE public.tbl_rdb TO johan;


--
-- Name: TABLE tbl_rdb_codes; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_rdb_codes FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_rdb_codes FROM sead_master;
GRANT ALL ON TABLE public.tbl_rdb_codes TO sead_master;
GRANT ALL ON TABLE public.tbl_rdb_codes TO postgres;
GRANT ALL ON TABLE public.tbl_rdb_codes TO sead_read;
GRANT ALL ON TABLE public.tbl_rdb_codes TO mattias;
GRANT SELECT ON TABLE public.tbl_rdb_codes TO humlab_read;
GRANT SELECT ON TABLE public.tbl_rdb_codes TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_rdb_codes TO querysead_worker;
GRANT ALL ON TABLE public.tbl_rdb_codes TO johan;


--
-- Name: TABLE tbl_rdb_systems; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_rdb_systems FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_rdb_systems FROM sead_master;
GRANT ALL ON TABLE public.tbl_rdb_systems TO sead_master;
GRANT ALL ON TABLE public.tbl_rdb_systems TO postgres;
GRANT ALL ON TABLE public.tbl_rdb_systems TO sead_read;
GRANT ALL ON TABLE public.tbl_rdb_systems TO mattias;
GRANT SELECT ON TABLE public.tbl_rdb_systems TO humlab_read;
GRANT SELECT ON TABLE public.tbl_rdb_systems TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_rdb_systems TO querysead_worker;
GRANT ALL ON TABLE public.tbl_rdb_systems TO johan;


--
-- Name: TABLE tbl_record_types; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_record_types FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_record_types FROM sead_master;
GRANT ALL ON TABLE public.tbl_record_types TO sead_master;
GRANT ALL ON TABLE public.tbl_record_types TO postgres;
GRANT ALL ON TABLE public.tbl_record_types TO sead_read;
GRANT ALL ON TABLE public.tbl_record_types TO mattias;
GRANT SELECT ON TABLE public.tbl_record_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_record_types TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_record_types TO querysead_worker;
GRANT ALL ON TABLE public.tbl_record_types TO johan;


--
-- Name: TABLE tbl_relative_age_refs; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_relative_age_refs FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_relative_age_refs FROM sead_master;
GRANT ALL ON TABLE public.tbl_relative_age_refs TO sead_master;
GRANT ALL ON TABLE public.tbl_relative_age_refs TO postgres;
GRANT ALL ON TABLE public.tbl_relative_age_refs TO sead_read;
GRANT ALL ON TABLE public.tbl_relative_age_refs TO mattias;
GRANT SELECT ON TABLE public.tbl_relative_age_refs TO humlab_read;
GRANT SELECT ON TABLE public.tbl_relative_age_refs TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_relative_age_refs TO querysead_worker;
GRANT ALL ON TABLE public.tbl_relative_age_refs TO johan;


--
-- Name: TABLE tbl_relative_age_types; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_relative_age_types FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_relative_age_types FROM sead_master;
GRANT ALL ON TABLE public.tbl_relative_age_types TO sead_master;
GRANT ALL ON TABLE public.tbl_relative_age_types TO postgres;
GRANT ALL ON TABLE public.tbl_relative_age_types TO sead_read;
GRANT ALL ON TABLE public.tbl_relative_age_types TO mattias;
GRANT SELECT ON TABLE public.tbl_relative_age_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_relative_age_types TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_relative_age_types TO querysead_worker;
GRANT ALL ON TABLE public.tbl_relative_age_types TO johan;


--
-- Name: TABLE tbl_relative_ages; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_relative_ages FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_relative_ages FROM sead_master;
GRANT ALL ON TABLE public.tbl_relative_ages TO sead_master;
GRANT ALL ON TABLE public.tbl_relative_ages TO postgres;
GRANT ALL ON TABLE public.tbl_relative_ages TO sead_read;
GRANT ALL ON TABLE public.tbl_relative_ages TO mattias;
GRANT SELECT ON TABLE public.tbl_relative_ages TO humlab_read;
GRANT SELECT ON TABLE public.tbl_relative_ages TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_relative_ages TO querysead_worker;
GRANT ALL ON TABLE public.tbl_relative_ages TO johan;


--
-- Name: TABLE tbl_relative_dates; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_relative_dates FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_relative_dates FROM sead_master;
GRANT ALL ON TABLE public.tbl_relative_dates TO sead_master;
GRANT ALL ON TABLE public.tbl_relative_dates TO postgres;
GRANT ALL ON TABLE public.tbl_relative_dates TO sead_read;
GRANT ALL ON TABLE public.tbl_relative_dates TO mattias;
GRANT SELECT ON TABLE public.tbl_relative_dates TO humlab_read;
GRANT SELECT ON TABLE public.tbl_relative_dates TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_relative_dates TO querysead_worker;
GRANT ALL ON TABLE public.tbl_relative_dates TO johan;


--
-- Name: TABLE tbl_sample_alt_refs; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_alt_refs FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_alt_refs FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_alt_refs TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_alt_refs TO postgres;
GRANT ALL ON TABLE public.tbl_sample_alt_refs TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_alt_refs TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_alt_refs TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_alt_refs TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_alt_refs TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_alt_refs TO johan;


--
-- Name: TABLE tbl_sample_colours; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_colours FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_colours FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_colours TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_colours TO postgres;
GRANT ALL ON TABLE public.tbl_sample_colours TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_colours TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_colours TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_colours TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_colours TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_colours TO johan;


--
-- Name: TABLE tbl_sample_coordinates; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_coordinates FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_coordinates FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_coordinates TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_coordinates TO postgres;
GRANT ALL ON TABLE public.tbl_sample_coordinates TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_coordinates TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_coordinates TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_coordinates TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_coordinates TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_coordinates TO johan;


--
-- Name: TABLE tbl_sample_description_sample_group_contexts; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_description_sample_group_contexts FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_description_sample_group_contexts FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_description_sample_group_contexts TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_description_sample_group_contexts TO postgres;
GRANT ALL ON TABLE public.tbl_sample_description_sample_group_contexts TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_description_sample_group_contexts TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_description_sample_group_contexts TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_description_sample_group_contexts TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_description_sample_group_contexts TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_description_sample_group_contexts TO johan;


--
-- Name: TABLE tbl_sample_description_types; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_description_types FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_description_types FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_description_types TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_description_types TO postgres;
GRANT ALL ON TABLE public.tbl_sample_description_types TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_description_types TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_description_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_description_types TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_description_types TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_description_types TO johan;


--
-- Name: TABLE tbl_sample_descriptions; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_descriptions FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_descriptions FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_descriptions TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_descriptions TO postgres;
GRANT ALL ON TABLE public.tbl_sample_descriptions TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_descriptions TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_descriptions TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_descriptions TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_descriptions TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_descriptions TO johan;


--
-- Name: TABLE tbl_sample_dimensions; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_dimensions FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_dimensions FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_dimensions TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_dimensions TO postgres;
GRANT ALL ON TABLE public.tbl_sample_dimensions TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_dimensions TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_dimensions TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_dimensions TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_dimensions TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_dimensions TO johan;


--
-- Name: TABLE tbl_sample_group_coordinates; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_group_coordinates FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_group_coordinates FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_group_coordinates TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_group_coordinates TO postgres;
GRANT ALL ON TABLE public.tbl_sample_group_coordinates TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_group_coordinates TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_group_coordinates TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_group_coordinates TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_group_coordinates TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_group_coordinates TO johan;


--
-- Name: TABLE tbl_sample_group_description_type_sampling_contexts; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_group_description_type_sampling_contexts FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_group_description_type_sampling_contexts FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_group_description_type_sampling_contexts TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_group_description_type_sampling_contexts TO postgres;
GRANT ALL ON TABLE public.tbl_sample_group_description_type_sampling_contexts TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_group_description_type_sampling_contexts TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_group_description_type_sampling_contexts TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_group_description_type_sampling_contexts TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_group_description_type_sampling_contexts TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_group_description_type_sampling_contexts TO johan;


--
-- Name: TABLE tbl_sample_group_description_types; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_group_description_types FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_group_description_types FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_group_description_types TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_group_description_types TO postgres;
GRANT ALL ON TABLE public.tbl_sample_group_description_types TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_group_description_types TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_group_description_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_group_description_types TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_group_description_types TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_group_description_types TO johan;


--
-- Name: TABLE tbl_sample_group_descriptions; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_group_descriptions FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_group_descriptions FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_group_descriptions TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_group_descriptions TO postgres;
GRANT ALL ON TABLE public.tbl_sample_group_descriptions TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_group_descriptions TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_group_descriptions TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_group_descriptions TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_group_descriptions TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_group_descriptions TO johan;


--
-- Name: TABLE tbl_sample_group_dimensions; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_group_dimensions FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_group_dimensions FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_group_dimensions TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_group_dimensions TO postgres;
GRANT ALL ON TABLE public.tbl_sample_group_dimensions TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_group_dimensions TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_group_dimensions TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_group_dimensions TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_group_dimensions TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_group_dimensions TO johan;


--
-- Name: TABLE tbl_sample_group_images; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_group_images FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_group_images FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_group_images TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_group_images TO postgres;
GRANT ALL ON TABLE public.tbl_sample_group_images TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_group_images TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_group_images TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_group_images TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_group_images TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_group_images TO johan;


--
-- Name: TABLE tbl_sample_group_notes; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_group_notes FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_group_notes FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_group_notes TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_group_notes TO postgres;
GRANT ALL ON TABLE public.tbl_sample_group_notes TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_group_notes TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_group_notes TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_group_notes TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_group_notes TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_group_notes TO johan;


--
-- Name: TABLE tbl_sample_group_references; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_group_references FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_group_references FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_group_references TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_group_references TO postgres;
GRANT ALL ON TABLE public.tbl_sample_group_references TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_group_references TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_group_references TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_group_references TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_group_references TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_group_references TO johan;


--
-- Name: TABLE tbl_sample_group_sampling_contexts; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_group_sampling_contexts FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_group_sampling_contexts FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_group_sampling_contexts TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_group_sampling_contexts TO postgres;
GRANT ALL ON TABLE public.tbl_sample_group_sampling_contexts TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_group_sampling_contexts TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_group_sampling_contexts TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_group_sampling_contexts TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_group_sampling_contexts TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_group_sampling_contexts TO johan;


--
-- Name: TABLE tbl_sample_groups; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_groups FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_groups FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_groups TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_groups TO postgres;
GRANT ALL ON TABLE public.tbl_sample_groups TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_groups TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_groups TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_groups TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_groups TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_groups TO johan;


--
-- Name: TABLE tbl_sample_horizons; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_horizons FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_horizons FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_horizons TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_horizons TO postgres;
GRANT ALL ON TABLE public.tbl_sample_horizons TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_horizons TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_horizons TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_horizons TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_horizons TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_horizons TO johan;


--
-- Name: TABLE tbl_sample_images; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_images FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_images FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_images TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_images TO postgres;
GRANT ALL ON TABLE public.tbl_sample_images TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_images TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_images TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_images TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_images TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_images TO johan;


--
-- Name: TABLE tbl_sample_location_type_sampling_contexts; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_location_type_sampling_contexts FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_location_type_sampling_contexts FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_location_type_sampling_contexts TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_location_type_sampling_contexts TO postgres;
GRANT ALL ON TABLE public.tbl_sample_location_type_sampling_contexts TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_location_type_sampling_contexts TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_location_type_sampling_contexts TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_location_type_sampling_contexts TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_location_type_sampling_contexts TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_location_type_sampling_contexts TO johan;


--
-- Name: TABLE tbl_sample_location_types; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_location_types FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_location_types FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_location_types TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_location_types TO postgres;
GRANT ALL ON TABLE public.tbl_sample_location_types TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_location_types TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_location_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_location_types TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_location_types TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_location_types TO johan;


--
-- Name: TABLE tbl_sample_locations; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_locations FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_locations FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_locations TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_locations TO postgres;
GRANT ALL ON TABLE public.tbl_sample_locations TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_locations TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_locations TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_locations TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_locations TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_locations TO johan;


--
-- Name: TABLE tbl_sample_notes; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_notes FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_notes FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_notes TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_notes TO postgres;
GRANT ALL ON TABLE public.tbl_sample_notes TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_notes TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_notes TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_notes TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_notes TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_notes TO johan;


--
-- Name: TABLE tbl_sample_types; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sample_types FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sample_types FROM sead_master;
GRANT ALL ON TABLE public.tbl_sample_types TO sead_master;
GRANT ALL ON TABLE public.tbl_sample_types TO postgres;
GRANT ALL ON TABLE public.tbl_sample_types TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_types TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_types TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sample_types TO querysead_worker;
GRANT ALL ON TABLE public.tbl_sample_types TO johan;


--
-- Name: TABLE tbl_season_or_qualifier; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_season_or_qualifier FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_season_or_qualifier FROM sead_master;
GRANT ALL ON TABLE public.tbl_season_or_qualifier TO sead_master;
GRANT ALL ON TABLE public.tbl_season_or_qualifier TO sead_read;
GRANT ALL ON TABLE public.tbl_season_or_qualifier TO humlab_admin;
GRANT ALL ON TABLE public.tbl_season_or_qualifier TO mattias;
GRANT ALL ON TABLE public.tbl_season_or_qualifier TO postgres;
GRANT SELECT ON TABLE public.tbl_season_or_qualifier TO humlab_read;
GRANT SELECT ON TABLE public.tbl_season_or_qualifier TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_season_or_qualifier TO querysead_worker;
GRANT ALL ON TABLE public.tbl_season_or_qualifier TO johan;


--
-- Name: TABLE tbl_season_types; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_season_types FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_season_types FROM sead_master;
GRANT ALL ON TABLE public.tbl_season_types TO sead_master;
GRANT ALL ON TABLE public.tbl_season_types TO postgres;
GRANT ALL ON TABLE public.tbl_season_types TO sead_read;
GRANT ALL ON TABLE public.tbl_season_types TO mattias;
GRANT SELECT ON TABLE public.tbl_season_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_season_types TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_season_types TO querysead_worker;
GRANT ALL ON TABLE public.tbl_season_types TO johan;


--
-- Name: TABLE tbl_seasons; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_seasons FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_seasons FROM sead_master;
GRANT ALL ON TABLE public.tbl_seasons TO sead_master;
GRANT ALL ON TABLE public.tbl_seasons TO postgres;
GRANT ALL ON TABLE public.tbl_seasons TO sead_read;
GRANT ALL ON TABLE public.tbl_seasons TO mattias;
GRANT SELECT ON TABLE public.tbl_seasons TO humlab_read;
GRANT SELECT ON TABLE public.tbl_seasons TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_seasons TO querysead_worker;
GRANT ALL ON TABLE public.tbl_seasons TO johan;


--
-- Name: TABLE tbl_site_images; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_site_images FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_site_images FROM sead_master;
GRANT ALL ON TABLE public.tbl_site_images TO sead_master;
GRANT ALL ON TABLE public.tbl_site_images TO postgres;
GRANT ALL ON TABLE public.tbl_site_images TO sead_read;
GRANT ALL ON TABLE public.tbl_site_images TO mattias;
GRANT SELECT ON TABLE public.tbl_site_images TO humlab_read;
GRANT SELECT ON TABLE public.tbl_site_images TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_site_images TO querysead_worker;
GRANT ALL ON TABLE public.tbl_site_images TO johan;


--
-- Name: TABLE tbl_site_locations; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_site_locations FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_site_locations FROM sead_master;
GRANT ALL ON TABLE public.tbl_site_locations TO sead_master;
GRANT ALL ON TABLE public.tbl_site_locations TO postgres;
GRANT ALL ON TABLE public.tbl_site_locations TO sead_read;
GRANT ALL ON TABLE public.tbl_site_locations TO mattias;
GRANT SELECT ON TABLE public.tbl_site_locations TO humlab_read;
GRANT SELECT ON TABLE public.tbl_site_locations TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_site_locations TO querysead_worker;
GRANT ALL ON TABLE public.tbl_site_locations TO johan;


--
-- Name: TABLE tbl_site_natgridrefs; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_site_natgridrefs FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_site_natgridrefs FROM sead_master;
GRANT ALL ON TABLE public.tbl_site_natgridrefs TO sead_master;
GRANT ALL ON TABLE public.tbl_site_natgridrefs TO postgres;
GRANT ALL ON TABLE public.tbl_site_natgridrefs TO sead_read;
GRANT ALL ON TABLE public.tbl_site_natgridrefs TO mattias;
GRANT SELECT ON TABLE public.tbl_site_natgridrefs TO humlab_read;
GRANT SELECT ON TABLE public.tbl_site_natgridrefs TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_site_natgridrefs TO querysead_worker;
GRANT ALL ON TABLE public.tbl_site_natgridrefs TO johan;


--
-- Name: TABLE tbl_site_other_records; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_site_other_records FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_site_other_records FROM sead_master;
GRANT ALL ON TABLE public.tbl_site_other_records TO sead_master;
GRANT ALL ON TABLE public.tbl_site_other_records TO postgres;
GRANT ALL ON TABLE public.tbl_site_other_records TO sead_read;
GRANT ALL ON TABLE public.tbl_site_other_records TO mattias;
GRANT SELECT ON TABLE public.tbl_site_other_records TO humlab_read;
GRANT SELECT ON TABLE public.tbl_site_other_records TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_site_other_records TO querysead_worker;
GRANT ALL ON TABLE public.tbl_site_other_records TO johan;


--
-- Name: TABLE tbl_site_preservation_status; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_site_preservation_status FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_site_preservation_status FROM sead_master;
GRANT ALL ON TABLE public.tbl_site_preservation_status TO sead_master;
GRANT ALL ON TABLE public.tbl_site_preservation_status TO postgres;
GRANT ALL ON TABLE public.tbl_site_preservation_status TO sead_read;
GRANT ALL ON TABLE public.tbl_site_preservation_status TO mattias;
GRANT SELECT ON TABLE public.tbl_site_preservation_status TO humlab_read;
GRANT SELECT ON TABLE public.tbl_site_preservation_status TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_site_preservation_status TO querysead_worker;
GRANT ALL ON TABLE public.tbl_site_preservation_status TO johan;


--
-- Name: TABLE tbl_site_references; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_site_references FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_site_references FROM sead_master;
GRANT ALL ON TABLE public.tbl_site_references TO sead_master;
GRANT ALL ON TABLE public.tbl_site_references TO postgres;
GRANT ALL ON TABLE public.tbl_site_references TO sead_read;
GRANT ALL ON TABLE public.tbl_site_references TO mattias;
GRANT SELECT ON TABLE public.tbl_site_references TO humlab_read;
GRANT SELECT ON TABLE public.tbl_site_references TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_site_references TO querysead_worker;
GRANT ALL ON TABLE public.tbl_site_references TO johan;


--
-- Name: TABLE tbl_sites; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_sites FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_sites FROM sead_master;
GRANT ALL ON TABLE public.tbl_sites TO sead_master;
GRANT ALL ON TABLE public.tbl_sites TO postgres;
GRANT ALL ON TABLE public.tbl_sites TO sead_read;
GRANT ALL ON TABLE public.tbl_sites TO mattias;
GRANT SELECT ON TABLE public.tbl_sites TO humlab_read;
GRANT ALL ON TABLE public.tbl_sites TO johan;
GRANT SELECT ON TABLE public.tbl_sites TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_sites TO querysead_worker;


--
-- Name: TABLE tbl_species_association_types; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_species_association_types FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_species_association_types FROM sead_master;
GRANT ALL ON TABLE public.tbl_species_association_types TO sead_master;
GRANT ALL ON TABLE public.tbl_species_association_types TO postgres;
GRANT ALL ON TABLE public.tbl_species_association_types TO sead_read;
GRANT ALL ON TABLE public.tbl_species_association_types TO mattias;
GRANT SELECT ON TABLE public.tbl_species_association_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_species_association_types TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_species_association_types TO querysead_worker;
GRANT ALL ON TABLE public.tbl_species_association_types TO johan;


--
-- Name: TABLE tbl_species_associations; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_species_associations FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_species_associations FROM sead_master;
GRANT ALL ON TABLE public.tbl_species_associations TO sead_master;
GRANT ALL ON TABLE public.tbl_species_associations TO postgres;
GRANT ALL ON TABLE public.tbl_species_associations TO sead_read;
GRANT ALL ON TABLE public.tbl_species_associations TO mattias;
GRANT SELECT ON TABLE public.tbl_species_associations TO humlab_read;
GRANT SELECT ON TABLE public.tbl_species_associations TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_species_associations TO querysead_worker;
GRANT ALL ON TABLE public.tbl_species_associations TO johan;


--
-- Name: TABLE tbl_taxa_common_names; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_taxa_common_names FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_taxa_common_names FROM sead_master;
GRANT ALL ON TABLE public.tbl_taxa_common_names TO sead_master;
GRANT ALL ON TABLE public.tbl_taxa_common_names TO postgres;
GRANT ALL ON TABLE public.tbl_taxa_common_names TO sead_read;
GRANT ALL ON TABLE public.tbl_taxa_common_names TO mattias;
GRANT SELECT ON TABLE public.tbl_taxa_common_names TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxa_common_names TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_taxa_common_names TO querysead_worker;
GRANT ALL ON TABLE public.tbl_taxa_common_names TO johan;


--
-- Name: TABLE tbl_taxa_images; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_taxa_images FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_taxa_images FROM sead_master;
GRANT ALL ON TABLE public.tbl_taxa_images TO sead_master;
GRANT ALL ON TABLE public.tbl_taxa_images TO postgres;
GRANT ALL ON TABLE public.tbl_taxa_images TO sead_read;
GRANT ALL ON TABLE public.tbl_taxa_images TO mattias;
GRANT SELECT ON TABLE public.tbl_taxa_images TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxa_images TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_taxa_images TO querysead_worker;
GRANT ALL ON TABLE public.tbl_taxa_images TO johan;


--
-- Name: TABLE tbl_taxa_measured_attributes; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_taxa_measured_attributes FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_taxa_measured_attributes FROM sead_master;
GRANT ALL ON TABLE public.tbl_taxa_measured_attributes TO sead_master;
GRANT ALL ON TABLE public.tbl_taxa_measured_attributes TO postgres;
GRANT ALL ON TABLE public.tbl_taxa_measured_attributes TO sead_read;
GRANT ALL ON TABLE public.tbl_taxa_measured_attributes TO mattias;
GRANT SELECT ON TABLE public.tbl_taxa_measured_attributes TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxa_measured_attributes TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_taxa_measured_attributes TO querysead_worker;
GRANT ALL ON TABLE public.tbl_taxa_measured_attributes TO johan;


--
-- Name: TABLE tbl_taxa_reference_specimens; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_taxa_reference_specimens FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_taxa_reference_specimens FROM sead_master;
GRANT ALL ON TABLE public.tbl_taxa_reference_specimens TO sead_master;
GRANT ALL ON TABLE public.tbl_taxa_reference_specimens TO postgres;
GRANT ALL ON TABLE public.tbl_taxa_reference_specimens TO sead_read;
GRANT ALL ON TABLE public.tbl_taxa_reference_specimens TO mattias;
GRANT SELECT ON TABLE public.tbl_taxa_reference_specimens TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxa_reference_specimens TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_taxa_reference_specimens TO querysead_worker;
GRANT ALL ON TABLE public.tbl_taxa_reference_specimens TO johan;


--
-- Name: TABLE tbl_taxa_seasonality; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_taxa_seasonality FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_taxa_seasonality FROM sead_master;
GRANT ALL ON TABLE public.tbl_taxa_seasonality TO sead_master;
GRANT ALL ON TABLE public.tbl_taxa_seasonality TO postgres;
GRANT ALL ON TABLE public.tbl_taxa_seasonality TO sead_read;
GRANT ALL ON TABLE public.tbl_taxa_seasonality TO mattias;
GRANT SELECT ON TABLE public.tbl_taxa_seasonality TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxa_seasonality TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_taxa_seasonality TO querysead_worker;
GRANT ALL ON TABLE public.tbl_taxa_seasonality TO johan;


--
-- Name: TABLE tbl_taxa_synonyms; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_taxa_synonyms FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_taxa_synonyms FROM sead_master;
GRANT ALL ON TABLE public.tbl_taxa_synonyms TO sead_master;
GRANT ALL ON TABLE public.tbl_taxa_synonyms TO postgres;
GRANT ALL ON TABLE public.tbl_taxa_synonyms TO sead_read;
GRANT ALL ON TABLE public.tbl_taxa_synonyms TO mattias;
GRANT SELECT ON TABLE public.tbl_taxa_synonyms TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxa_synonyms TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_taxa_synonyms TO querysead_worker;
GRANT ALL ON TABLE public.tbl_taxa_synonyms TO johan;


--
-- Name: TABLE tbl_taxa_tree_authors; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_taxa_tree_authors FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_taxa_tree_authors FROM sead_master;
GRANT ALL ON TABLE public.tbl_taxa_tree_authors TO sead_master;
GRANT ALL ON TABLE public.tbl_taxa_tree_authors TO postgres;
GRANT ALL ON TABLE public.tbl_taxa_tree_authors TO sead_read;
GRANT ALL ON TABLE public.tbl_taxa_tree_authors TO mattias;
GRANT SELECT ON TABLE public.tbl_taxa_tree_authors TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxa_tree_authors TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_taxa_tree_authors TO querysead_worker;
GRANT ALL ON TABLE public.tbl_taxa_tree_authors TO johan;


--
-- Name: TABLE tbl_taxa_tree_families; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_taxa_tree_families FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_taxa_tree_families FROM sead_master;
GRANT ALL ON TABLE public.tbl_taxa_tree_families TO sead_master;
GRANT ALL ON TABLE public.tbl_taxa_tree_families TO postgres;
GRANT ALL ON TABLE public.tbl_taxa_tree_families TO sead_read;
GRANT ALL ON TABLE public.tbl_taxa_tree_families TO mattias;
GRANT SELECT ON TABLE public.tbl_taxa_tree_families TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxa_tree_families TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_taxa_tree_families TO querysead_worker;
GRANT ALL ON TABLE public.tbl_taxa_tree_families TO johan;


--
-- Name: TABLE tbl_taxa_tree_orders; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_taxa_tree_orders FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_taxa_tree_orders FROM sead_master;
GRANT ALL ON TABLE public.tbl_taxa_tree_orders TO sead_master;
GRANT ALL ON TABLE public.tbl_taxa_tree_orders TO postgres;
GRANT ALL ON TABLE public.tbl_taxa_tree_orders TO sead_read;
GRANT ALL ON TABLE public.tbl_taxa_tree_orders TO mattias;
GRANT SELECT ON TABLE public.tbl_taxa_tree_orders TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxa_tree_orders TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_taxa_tree_orders TO querysead_worker;
GRANT ALL ON TABLE public.tbl_taxa_tree_orders TO johan;


--
-- Name: TABLE tbl_taxonomic_order; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_taxonomic_order FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_taxonomic_order FROM sead_master;
GRANT ALL ON TABLE public.tbl_taxonomic_order TO sead_master;
GRANT ALL ON TABLE public.tbl_taxonomic_order TO postgres;
GRANT ALL ON TABLE public.tbl_taxonomic_order TO sead_read;
GRANT ALL ON TABLE public.tbl_taxonomic_order TO mattias;
GRANT SELECT ON TABLE public.tbl_taxonomic_order TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxonomic_order TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_taxonomic_order TO querysead_worker;
GRANT ALL ON TABLE public.tbl_taxonomic_order TO johan;


--
-- Name: TABLE tbl_taxonomic_order_biblio; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_taxonomic_order_biblio FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_taxonomic_order_biblio FROM sead_master;
GRANT ALL ON TABLE public.tbl_taxonomic_order_biblio TO sead_master;
GRANT ALL ON TABLE public.tbl_taxonomic_order_biblio TO postgres;
GRANT ALL ON TABLE public.tbl_taxonomic_order_biblio TO sead_read;
GRANT ALL ON TABLE public.tbl_taxonomic_order_biblio TO mattias;
GRANT SELECT ON TABLE public.tbl_taxonomic_order_biblio TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxonomic_order_biblio TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_taxonomic_order_biblio TO querysead_worker;
GRANT ALL ON TABLE public.tbl_taxonomic_order_biblio TO johan;


--
-- Name: TABLE tbl_taxonomic_order_systems; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_taxonomic_order_systems FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_taxonomic_order_systems FROM sead_master;
GRANT ALL ON TABLE public.tbl_taxonomic_order_systems TO sead_master;
GRANT ALL ON TABLE public.tbl_taxonomic_order_systems TO postgres;
GRANT ALL ON TABLE public.tbl_taxonomic_order_systems TO sead_read;
GRANT ALL ON TABLE public.tbl_taxonomic_order_systems TO mattias;
GRANT SELECT ON TABLE public.tbl_taxonomic_order_systems TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxonomic_order_systems TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_taxonomic_order_systems TO querysead_worker;
GRANT ALL ON TABLE public.tbl_taxonomic_order_systems TO johan;


--
-- Name: TABLE tbl_taxonomy_notes; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_taxonomy_notes FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_taxonomy_notes FROM sead_master;
GRANT ALL ON TABLE public.tbl_taxonomy_notes TO sead_master;
GRANT ALL ON TABLE public.tbl_taxonomy_notes TO postgres;
GRANT ALL ON TABLE public.tbl_taxonomy_notes TO sead_read;
GRANT ALL ON TABLE public.tbl_taxonomy_notes TO mattias;
GRANT SELECT ON TABLE public.tbl_taxonomy_notes TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxonomy_notes TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_taxonomy_notes TO querysead_worker;
GRANT ALL ON TABLE public.tbl_taxonomy_notes TO johan;


--
-- Name: TABLE tbl_tephra_dates; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_tephra_dates FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_tephra_dates FROM sead_master;
GRANT ALL ON TABLE public.tbl_tephra_dates TO sead_master;
GRANT ALL ON TABLE public.tbl_tephra_dates TO postgres;
GRANT ALL ON TABLE public.tbl_tephra_dates TO sead_read;
GRANT ALL ON TABLE public.tbl_tephra_dates TO mattias;
GRANT SELECT ON TABLE public.tbl_tephra_dates TO humlab_read;
GRANT SELECT ON TABLE public.tbl_tephra_dates TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_tephra_dates TO querysead_worker;
GRANT ALL ON TABLE public.tbl_tephra_dates TO johan;


--
-- Name: TABLE tbl_tephra_refs; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_tephra_refs FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_tephra_refs FROM sead_master;
GRANT ALL ON TABLE public.tbl_tephra_refs TO sead_master;
GRANT ALL ON TABLE public.tbl_tephra_refs TO postgres;
GRANT ALL ON TABLE public.tbl_tephra_refs TO sead_read;
GRANT ALL ON TABLE public.tbl_tephra_refs TO mattias;
GRANT SELECT ON TABLE public.tbl_tephra_refs TO humlab_read;
GRANT SELECT ON TABLE public.tbl_tephra_refs TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_tephra_refs TO querysead_worker;
GRANT ALL ON TABLE public.tbl_tephra_refs TO johan;


--
-- Name: TABLE tbl_tephras; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_tephras FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_tephras FROM sead_master;
GRANT ALL ON TABLE public.tbl_tephras TO sead_master;
GRANT ALL ON TABLE public.tbl_tephras TO postgres;
GRANT ALL ON TABLE public.tbl_tephras TO sead_read;
GRANT ALL ON TABLE public.tbl_tephras TO mattias;
GRANT SELECT ON TABLE public.tbl_tephras TO humlab_read;
GRANT SELECT ON TABLE public.tbl_tephras TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_tephras TO querysead_worker;
GRANT ALL ON TABLE public.tbl_tephras TO johan;


--
-- Name: TABLE tbl_text_biology; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_text_biology FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_text_biology FROM sead_master;
GRANT ALL ON TABLE public.tbl_text_biology TO sead_master;
GRANT ALL ON TABLE public.tbl_text_biology TO postgres;
GRANT ALL ON TABLE public.tbl_text_biology TO sead_read;
GRANT ALL ON TABLE public.tbl_text_biology TO mattias;
GRANT SELECT ON TABLE public.tbl_text_biology TO humlab_read;
GRANT SELECT ON TABLE public.tbl_text_biology TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_text_biology TO querysead_worker;
GRANT ALL ON TABLE public.tbl_text_biology TO johan;


--
-- Name: TABLE tbl_text_distribution; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_text_distribution FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_text_distribution FROM sead_master;
GRANT ALL ON TABLE public.tbl_text_distribution TO sead_master;
GRANT ALL ON TABLE public.tbl_text_distribution TO postgres;
GRANT ALL ON TABLE public.tbl_text_distribution TO sead_read;
GRANT ALL ON TABLE public.tbl_text_distribution TO mattias;
GRANT SELECT ON TABLE public.tbl_text_distribution TO humlab_read;
GRANT SELECT ON TABLE public.tbl_text_distribution TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_text_distribution TO querysead_worker;
GRANT ALL ON TABLE public.tbl_text_distribution TO johan;


--
-- Name: TABLE tbl_text_identification_keys; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_text_identification_keys FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_text_identification_keys FROM sead_master;
GRANT ALL ON TABLE public.tbl_text_identification_keys TO sead_master;
GRANT ALL ON TABLE public.tbl_text_identification_keys TO postgres;
GRANT ALL ON TABLE public.tbl_text_identification_keys TO sead_read;
GRANT ALL ON TABLE public.tbl_text_identification_keys TO mattias;
GRANT SELECT ON TABLE public.tbl_text_identification_keys TO humlab_read;
GRANT SELECT ON TABLE public.tbl_text_identification_keys TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_text_identification_keys TO querysead_worker;
GRANT ALL ON TABLE public.tbl_text_identification_keys TO johan;


--
-- Name: TABLE tbl_units; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_units FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_units FROM sead_master;
GRANT ALL ON TABLE public.tbl_units TO sead_master;
GRANT ALL ON TABLE public.tbl_units TO postgres;
GRANT ALL ON TABLE public.tbl_units TO sead_read;
GRANT ALL ON TABLE public.tbl_units TO mattias;
GRANT SELECT ON TABLE public.tbl_units TO humlab_read;
GRANT SELECT ON TABLE public.tbl_units TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_units TO querysead_worker;
GRANT ALL ON TABLE public.tbl_units TO johan;


--
-- Name: TABLE tbl_updates_log; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_updates_log FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_updates_log FROM sead_master;
GRANT ALL ON TABLE public.tbl_updates_log TO sead_master;
GRANT ALL ON TABLE public.tbl_updates_log TO postgres;
GRANT ALL ON TABLE public.tbl_updates_log TO sead_read;
GRANT ALL ON TABLE public.tbl_updates_log TO mattias;
GRANT SELECT ON TABLE public.tbl_updates_log TO humlab_read;
GRANT SELECT ON TABLE public.tbl_updates_log TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_updates_log TO querysead_worker;
GRANT ALL ON TABLE public.tbl_updates_log TO johan;


--
-- Name: TABLE tbl_years_types; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.tbl_years_types FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_years_types FROM sead_master;
GRANT ALL ON TABLE public.tbl_years_types TO sead_master;
GRANT ALL ON TABLE public.tbl_years_types TO postgres;
GRANT ALL ON TABLE public.tbl_years_types TO sead_read;
GRANT ALL ON TABLE public.tbl_years_types TO mattias;
GRANT SELECT ON TABLE public.tbl_years_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_years_types TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_years_types TO querysead_worker;
GRANT ALL ON TABLE public.tbl_years_types TO johan;


--
-- Name: TABLE tbl_biblio_original; Type: ACL; Schema: public; Owner: clearinghouse_worker
--

REVOKE ALL ON TABLE public.tbl_biblio_original FROM PUBLIC;
REVOKE ALL ON TABLE public.tbl_biblio_original FROM clearinghouse_worker;
GRANT ALL ON TABLE public.tbl_biblio_original TO clearinghouse_worker;
GRANT SELECT ON TABLE public.tbl_biblio_original TO querysead_owner;
GRANT SELECT ON TABLE public.tbl_biblio_original TO querysead_worker;
GRANT ALL ON TABLE public.tbl_biblio_original TO johan;


--
-- Name: TABLE columns; Type: ACL; Schema: public; Owner: humlab_admin
--

REVOKE ALL ON TABLE public.columns FROM PUBLIC;
REVOKE ALL ON TABLE public.columns FROM humlab_admin;
GRANT ALL ON TABLE public.columns TO humlab_admin;
GRANT SELECT ON TABLE public.columns TO querysead_owner;
GRANT SELECT ON TABLE public.columns TO querysead_worker;
GRANT ALL ON TABLE public.columns TO johan;


--
-- Name: SEQUENCE tbl_abundance_elements_abundance_element_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_abundance_elements_abundance_element_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_abundance_elements_abundance_element_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_abundance_elements_abundance_element_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_abundance_elements_abundance_element_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_abundance_elements_abundance_element_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_abundance_elements_abundance_element_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_abundance_elements_abundance_element_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_abundance_elements_abundance_element_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_abundance_ident_levels_abundance_ident_level_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_abundance_ident_levels_abundance_ident_level_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_abundance_ident_levels_abundance_ident_level_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_abundance_ident_levels_abundance_ident_level_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_abundance_ident_levels_abundance_ident_level_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_abundance_ident_levels_abundance_ident_level_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_abundance_ident_levels_abundance_ident_level_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_abundance_ident_levels_abundance_ident_level_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_abundance_ident_levels_abundance_ident_level_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_abundance_modifications_abundance_modification_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_abundance_modifications_abundance_modification_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_abundance_modifications_abundance_modification_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_abundance_modifications_abundance_modification_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_abundance_modifications_abundance_modification_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_abundance_modifications_abundance_modification_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_abundance_modifications_abundance_modification_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_abundance_modifications_abundance_modification_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_abundance_modifications_abundance_modification_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_abundances_abundance_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_abundances_abundance_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_abundances_abundance_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_abundances_abundance_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_abundances_abundance_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_abundances_abundance_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_abundances_abundance_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_abundances_abundance_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_abundances_abundance_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_activity_types_activity_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_activity_types_activity_type_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_activity_types_activity_type_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_activity_types_activity_type_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_activity_types_activity_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_activity_types_activity_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_activity_types_activity_type_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_activity_types_activity_type_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_activity_types_activity_type_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_age_types_age_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_age_types_age_type_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_age_types_age_type_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_age_types_age_type_id_seq TO sead_master;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_age_types_age_type_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_age_types_age_type_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_aggregate_datasets_aggregate_dataset_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_aggregate_datasets_aggregate_dataset_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_aggregate_datasets_aggregate_dataset_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_aggregate_datasets_aggregate_dataset_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_aggregate_datasets_aggregate_dataset_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_aggregate_datasets_aggregate_dataset_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_aggregate_datasets_aggregate_dataset_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_aggregate_datasets_aggregate_dataset_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_aggregate_datasets_aggregate_dataset_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_aggregate_order_types_aggregate_order_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_aggregate_order_types_aggregate_order_type_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_aggregate_order_types_aggregate_order_type_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_aggregate_order_types_aggregate_order_type_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_aggregate_order_types_aggregate_order_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_aggregate_order_types_aggregate_order_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_aggregate_order_types_aggregate_order_type_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_aggregate_order_types_aggregate_order_type_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_aggregate_order_types_aggregate_order_type_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_aggregate_sample_ages_aggregate_sample_age_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_aggregate_sample_ages_aggregate_sample_age_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_aggregate_sample_ages_aggregate_sample_age_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_aggregate_sample_ages_aggregate_sample_age_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_aggregate_sample_ages_aggregate_sample_age_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_aggregate_sample_ages_aggregate_sample_age_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_aggregate_sample_ages_aggregate_sample_age_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_aggregate_sample_ages_aggregate_sample_age_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_aggregate_sample_ages_aggregate_sample_age_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_aggregate_samples_aggregate_sample_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_aggregate_samples_aggregate_sample_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_aggregate_samples_aggregate_sample_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_aggregate_samples_aggregate_sample_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_aggregate_samples_aggregate_sample_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_aggregate_samples_aggregate_sample_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_aggregate_samples_aggregate_sample_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_aggregate_samples_aggregate_sample_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_aggregate_samples_aggregate_sample_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_alt_ref_types_alt_ref_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_alt_ref_types_alt_ref_type_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_alt_ref_types_alt_ref_type_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_alt_ref_types_alt_ref_type_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_alt_ref_types_alt_ref_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_alt_ref_types_alt_ref_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_alt_ref_types_alt_ref_type_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_alt_ref_types_alt_ref_type_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_alt_ref_types_alt_ref_type_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_analysis_entities_analysis_entity_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_analysis_entities_analysis_entity_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_analysis_entities_analysis_entity_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_analysis_entities_analysis_entity_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_analysis_entities_analysis_entity_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_analysis_entities_analysis_entity_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_analysis_entities_analysis_entity_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_analysis_entities_analysis_entity_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_analysis_entities_analysis_entity_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_analysis_entity_ages_analysis_entity_age_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_analysis_entity_ages_analysis_entity_age_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_analysis_entity_ages_analysis_entity_age_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_analysis_entity_ages_analysis_entity_age_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_analysis_entity_ages_analysis_entity_age_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_analysis_entity_ages_analysis_entity_age_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_analysis_entity_ages_analysis_entity_age_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_analysis_entity_ages_analysis_entity_age_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_analysis_entity_ages_analysis_entity_age_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_association_types_association_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_association_types_association_type_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_association_types_association_type_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_association_types_association_type_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_association_types_association_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_association_types_association_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_association_types_association_type_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_association_types_association_type_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_association_types_association_type_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_biblio_biblio_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_biblio_biblio_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_biblio_biblio_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_biblio_biblio_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_biblio_biblio_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_biblio_biblio_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_biblio_biblio_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_biblio_biblio_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_biblio_biblio_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_ceramics_ceramics_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_ceramics_ceramics_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_ceramics_ceramics_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_ceramics_ceramics_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_ceramics_ceramics_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_ceramics_ceramics_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_ceramics_ceramics_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_ceramics_ceramics_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_ceramics_ceramics_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_ceramics_lookup_ceramics_lookup_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_ceramics_lookup_ceramics_lookup_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_ceramics_lookup_ceramics_lookup_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_ceramics_lookup_ceramics_lookup_id_seq TO sead_master;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_ceramics_lookup_ceramics_lookup_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_ceramics_lookup_ceramics_lookup_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_ceramics_measurements_ceramics_measurement_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_ceramics_measurements_ceramics_measurement_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_ceramics_measurements_ceramics_measurement_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_ceramics_measurements_ceramics_measurement_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_ceramics_measurements_ceramics_measurement_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_ceramics_measurements_ceramics_measurement_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_ceramics_measurements_ceramics_measurement_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_ceramics_measurements_ceramics_measurement_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_ceramics_measurements_ceramics_measurement_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_chron_control_types_chron_control_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_chron_control_types_chron_control_type_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_chron_control_types_chron_control_type_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_chron_control_types_chron_control_type_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_chron_control_types_chron_control_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_chron_control_types_chron_control_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_chron_control_types_chron_control_type_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_chron_control_types_chron_control_type_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_chron_control_types_chron_control_type_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_chron_controls_chron_control_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_chron_controls_chron_control_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_chron_controls_chron_control_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_chron_controls_chron_control_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_chron_controls_chron_control_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_chron_controls_chron_control_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_chron_controls_chron_control_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_chron_controls_chron_control_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_chron_controls_chron_control_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_chronologies_chronology_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_chronologies_chronology_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_chronologies_chronology_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_chronologies_chronology_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_chronologies_chronology_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_chronologies_chronology_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_chronologies_chronology_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_chronologies_chronology_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_chronologies_chronology_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_colours_colour_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_colours_colour_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_colours_colour_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_colours_colour_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_colours_colour_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_colours_colour_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_colours_colour_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_colours_colour_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_colours_colour_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_contact_types_contact_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_contact_types_contact_type_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_contact_types_contact_type_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_contact_types_contact_type_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_contact_types_contact_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_contact_types_contact_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_contact_types_contact_type_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_contact_types_contact_type_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_contact_types_contact_type_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_contacts_contact_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_contacts_contact_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_contacts_contact_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_contacts_contact_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_contacts_contact_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_contacts_contact_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_contacts_contact_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_contacts_contact_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_contacts_contact_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_data_type_groups_data_type_group_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_data_type_groups_data_type_group_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_data_type_groups_data_type_group_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_data_type_groups_data_type_group_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_data_type_groups_data_type_group_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_data_type_groups_data_type_group_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_data_type_groups_data_type_group_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_data_type_groups_data_type_group_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_data_type_groups_data_type_group_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_data_types_data_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_data_types_data_type_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_data_types_data_type_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_data_types_data_type_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_data_types_data_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_data_types_data_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_data_types_data_type_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_data_types_data_type_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_data_types_data_type_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_dataset_contacts_dataset_contact_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_dataset_contacts_dataset_contact_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_dataset_contacts_dataset_contact_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_dataset_contacts_dataset_contact_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_dataset_contacts_dataset_contact_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dataset_contacts_dataset_contact_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dataset_contacts_dataset_contact_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dataset_contacts_dataset_contact_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dataset_contacts_dataset_contact_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_dataset_masters_master_set_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_dataset_masters_master_set_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_dataset_masters_master_set_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_dataset_masters_master_set_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_dataset_masters_master_set_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dataset_masters_master_set_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dataset_masters_master_set_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dataset_masters_master_set_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dataset_masters_master_set_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_dataset_submission_types_submission_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_dataset_submission_types_submission_type_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_dataset_submission_types_submission_type_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_dataset_submission_types_submission_type_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_dataset_submission_types_submission_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dataset_submission_types_submission_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dataset_submission_types_submission_type_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dataset_submission_types_submission_type_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dataset_submission_types_submission_type_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_dataset_submissions_dataset_submission_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_dataset_submissions_dataset_submission_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_dataset_submissions_dataset_submission_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_dataset_submissions_dataset_submission_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_dataset_submissions_dataset_submission_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dataset_submissions_dataset_submission_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dataset_submissions_dataset_submission_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dataset_submissions_dataset_submission_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dataset_submissions_dataset_submission_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_datasets_dataset_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_datasets_dataset_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_datasets_dataset_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_datasets_dataset_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_datasets_dataset_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_datasets_dataset_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_datasets_dataset_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_datasets_dataset_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_datasets_dataset_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_dating_labs_dating_lab_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_dating_labs_dating_lab_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_dating_labs_dating_lab_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_dating_labs_dating_lab_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_dating_labs_dating_lab_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dating_labs_dating_lab_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dating_labs_dating_lab_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dating_labs_dating_lab_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dating_labs_dating_lab_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_dating_material_dating_material_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_dating_material_dating_material_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_dating_material_dating_material_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_dating_material_dating_material_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_dating_material_dating_material_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dating_material_dating_material_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dating_material_dating_material_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dating_material_dating_material_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dating_material_dating_material_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_dating_uncertainty_dating_uncertainty_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_dating_uncertainty_dating_uncertainty_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_dating_uncertainty_dating_uncertainty_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_dating_uncertainty_dating_uncertainty_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_dating_uncertainty_dating_uncertainty_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dating_uncertainty_dating_uncertainty_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dating_uncertainty_dating_uncertainty_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dating_uncertainty_dating_uncertainty_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dating_uncertainty_dating_uncertainty_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_dendro_date_notes_dendro_date_note_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_dendro_date_notes_dendro_date_note_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_dendro_date_notes_dendro_date_note_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_dendro_date_notes_dendro_date_note_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_dendro_date_notes_dendro_date_note_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dendro_date_notes_dendro_date_note_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dendro_date_notes_dendro_date_note_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dendro_date_notes_dendro_date_note_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dendro_date_notes_dendro_date_note_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_dendro_dates_dendro_date_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_dendro_dates_dendro_date_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_dendro_dates_dendro_date_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_dendro_dates_dendro_date_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_dendro_dates_dendro_date_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dendro_dates_dendro_date_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dendro_dates_dendro_date_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dendro_dates_dendro_date_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dendro_dates_dendro_date_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_dendro_dendro_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_dendro_dendro_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_dendro_dendro_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_dendro_dendro_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_dendro_dendro_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dendro_dendro_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dendro_dendro_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dendro_dendro_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dendro_dendro_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_dendro_lookup_dendro_lookup_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_dendro_lookup_dendro_lookup_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_dendro_lookup_dendro_lookup_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_dendro_lookup_dendro_lookup_id_seq TO sead_master;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dendro_lookup_dendro_lookup_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dendro_lookup_dendro_lookup_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_dendro_measurements_dendro_measurement_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_dendro_measurements_dendro_measurement_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_dendro_measurements_dendro_measurement_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_dendro_measurements_dendro_measurement_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_dendro_measurements_dendro_measurement_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dendro_measurements_dendro_measurement_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dendro_measurements_dendro_measurement_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dendro_measurements_dendro_measurement_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dendro_measurements_dendro_measurement_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_dimensions_dimension_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_dimensions_dimension_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_dimensions_dimension_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_dimensions_dimension_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_dimensions_dimension_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dimensions_dimension_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dimensions_dimension_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dimensions_dimension_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_dimensions_dimension_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_ecocode_definitions_ecocode_definition_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_ecocode_definitions_ecocode_definition_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_ecocode_definitions_ecocode_definition_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_ecocode_definitions_ecocode_definition_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_ecocode_definitions_ecocode_definition_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_ecocode_definitions_ecocode_definition_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_ecocode_definitions_ecocode_definition_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_ecocode_definitions_ecocode_definition_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_ecocode_definitions_ecocode_definition_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_ecocode_groups_ecocode_group_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_ecocode_groups_ecocode_group_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_ecocode_groups_ecocode_group_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_ecocode_groups_ecocode_group_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_ecocode_groups_ecocode_group_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_ecocode_groups_ecocode_group_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_ecocode_groups_ecocode_group_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_ecocode_groups_ecocode_group_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_ecocode_groups_ecocode_group_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_ecocode_systems_ecocode_system_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_ecocode_systems_ecocode_system_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_ecocode_systems_ecocode_system_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_ecocode_systems_ecocode_system_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_ecocode_systems_ecocode_system_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_ecocode_systems_ecocode_system_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_ecocode_systems_ecocode_system_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_ecocode_systems_ecocode_system_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_ecocode_systems_ecocode_system_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_ecocodes_ecocode_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_ecocodes_ecocode_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_ecocodes_ecocode_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_ecocodes_ecocode_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_ecocodes_ecocode_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_ecocodes_ecocode_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_ecocodes_ecocode_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_ecocodes_ecocode_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_ecocodes_ecocode_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_error_uncertainties_error_uncertainty_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_error_uncertainties_error_uncertainty_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_error_uncertainties_error_uncertainty_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_error_uncertainties_error_uncertainty_id_seq TO sead_master;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_error_uncertainties_error_uncertainty_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_error_uncertainties_error_uncertainty_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_feature_types_feature_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_feature_types_feature_type_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_feature_types_feature_type_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_feature_types_feature_type_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_feature_types_feature_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_feature_types_feature_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_feature_types_feature_type_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_feature_types_feature_type_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_feature_types_feature_type_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_features_feature_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_features_feature_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_features_feature_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_features_feature_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_features_feature_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_features_feature_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_features_feature_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_features_feature_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_features_feature_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_geochron_refs_geochron_ref_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_geochron_refs_geochron_ref_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_geochron_refs_geochron_ref_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_geochron_refs_geochron_ref_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_geochron_refs_geochron_ref_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_geochron_refs_geochron_ref_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_geochron_refs_geochron_ref_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_geochron_refs_geochron_ref_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_geochron_refs_geochron_ref_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_geochronology_geochron_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_geochronology_geochron_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_geochronology_geochron_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_geochronology_geochron_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_geochronology_geochron_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_geochronology_geochron_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_geochronology_geochron_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_geochronology_geochron_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_geochronology_geochron_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_horizons_horizon_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_horizons_horizon_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_horizons_horizon_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_horizons_horizon_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_horizons_horizon_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_horizons_horizon_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_horizons_horizon_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_horizons_horizon_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_horizons_horizon_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_identification_levels_identification_level_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_identification_levels_identification_level_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_identification_levels_identification_level_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_identification_levels_identification_level_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_identification_levels_identification_level_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_identification_levels_identification_level_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_identification_levels_identification_level_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_identification_levels_identification_level_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_identification_levels_identification_level_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_image_types_image_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_image_types_image_type_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_image_types_image_type_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_image_types_image_type_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_image_types_image_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_image_types_image_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_image_types_image_type_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_image_types_image_type_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_image_types_image_type_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_languages_language_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_languages_language_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_languages_language_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_languages_language_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_languages_language_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_languages_language_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_languages_language_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_languages_language_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_languages_language_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_lithology_lithology_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_lithology_lithology_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_lithology_lithology_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_lithology_lithology_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_lithology_lithology_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_lithology_lithology_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_lithology_lithology_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_lithology_lithology_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_lithology_lithology_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_location_types_location_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_location_types_location_type_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_location_types_location_type_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_location_types_location_type_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_location_types_location_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_location_types_location_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_location_types_location_type_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_location_types_location_type_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_location_types_location_type_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_locations_location_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_locations_location_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_locations_location_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_locations_location_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_locations_location_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_locations_location_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_locations_location_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_locations_location_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_locations_location_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_mcr_names_taxon_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_mcr_names_taxon_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_mcr_names_taxon_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_mcr_names_taxon_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_mcr_names_taxon_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_mcr_names_taxon_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_mcr_names_taxon_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_mcr_names_taxon_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_mcr_names_taxon_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_mcr_summary_data_mcr_summary_data_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_mcr_summary_data_mcr_summary_data_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_mcr_summary_data_mcr_summary_data_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_mcr_summary_data_mcr_summary_data_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_mcr_summary_data_mcr_summary_data_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_mcr_summary_data_mcr_summary_data_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_mcr_summary_data_mcr_summary_data_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_mcr_summary_data_mcr_summary_data_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_mcr_summary_data_mcr_summary_data_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_measured_value_dimensions_measured_value_dimension_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_measured_value_dimensions_measured_value_dimension_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_measured_value_dimensions_measured_value_dimension_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_measured_value_dimensions_measured_value_dimension_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_measured_value_dimensions_measured_value_dimension_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_measured_value_dimensions_measured_value_dimension_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_measured_value_dimensions_measured_value_dimension_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_measured_value_dimensions_measured_value_dimension_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_measured_value_dimensions_measured_value_dimension_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_measured_values_measured_value_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_measured_values_measured_value_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_measured_values_measured_value_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_measured_values_measured_value_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_measured_values_measured_value_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_measured_values_measured_value_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_measured_values_measured_value_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_measured_values_measured_value_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_measured_values_measured_value_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_method_groups_method_group_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_method_groups_method_group_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_method_groups_method_group_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_method_groups_method_group_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_method_groups_method_group_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_method_groups_method_group_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_method_groups_method_group_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_method_groups_method_group_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_method_groups_method_group_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_methods_method_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_methods_method_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_methods_method_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_methods_method_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_methods_method_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_methods_method_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_methods_method_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_methods_method_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_methods_method_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_modification_types_modification_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_modification_types_modification_type_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_modification_types_modification_type_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_modification_types_modification_type_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_modification_types_modification_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_modification_types_modification_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_modification_types_modification_type_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_modification_types_modification_type_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_modification_types_modification_type_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_physical_sample_features_physical_sample_feature_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_physical_sample_features_physical_sample_feature_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_physical_sample_features_physical_sample_feature_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_physical_sample_features_physical_sample_feature_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_physical_sample_features_physical_sample_feature_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_physical_sample_features_physical_sample_feature_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_physical_sample_features_physical_sample_feature_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_physical_sample_features_physical_sample_feature_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_physical_sample_features_physical_sample_feature_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_physical_samples_physical_sample_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_physical_samples_physical_sample_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_physical_samples_physical_sample_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_physical_samples_physical_sample_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_physical_samples_physical_sample_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_physical_samples_physical_sample_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_physical_samples_physical_sample_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_physical_samples_physical_sample_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_physical_samples_physical_sample_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_project_stage_project_stage_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_project_stage_project_stage_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_project_stage_project_stage_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_project_stage_project_stage_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_project_stage_project_stage_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_project_stage_project_stage_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_project_stage_project_stage_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_project_stage_project_stage_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_project_stage_project_stage_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_project_types_project_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_project_types_project_type_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_project_types_project_type_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_project_types_project_type_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_project_types_project_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_project_types_project_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_project_types_project_type_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_project_types_project_type_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_project_types_project_type_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_projects_project_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_projects_project_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_projects_project_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_projects_project_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_projects_project_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_projects_project_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_projects_project_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_projects_project_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_projects_project_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_rdb_codes_rdb_code_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_rdb_codes_rdb_code_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_rdb_codes_rdb_code_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_rdb_codes_rdb_code_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_rdb_codes_rdb_code_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_rdb_codes_rdb_code_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_rdb_codes_rdb_code_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_rdb_codes_rdb_code_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_rdb_codes_rdb_code_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_rdb_rdb_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_rdb_rdb_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_rdb_rdb_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_rdb_rdb_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_rdb_rdb_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_rdb_rdb_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_rdb_rdb_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_rdb_rdb_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_rdb_rdb_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_rdb_systems_rdb_system_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_rdb_systems_rdb_system_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_rdb_systems_rdb_system_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_rdb_systems_rdb_system_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_rdb_systems_rdb_system_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_rdb_systems_rdb_system_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_rdb_systems_rdb_system_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_rdb_systems_rdb_system_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_rdb_systems_rdb_system_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_record_types_record_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_record_types_record_type_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_record_types_record_type_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_record_types_record_type_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_record_types_record_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_record_types_record_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_record_types_record_type_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_record_types_record_type_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_record_types_record_type_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_relative_age_refs_relative_age_ref_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_relative_age_refs_relative_age_ref_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_relative_age_refs_relative_age_ref_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_relative_age_refs_relative_age_ref_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_relative_age_refs_relative_age_ref_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_relative_age_refs_relative_age_ref_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_relative_age_refs_relative_age_ref_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_relative_age_refs_relative_age_ref_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_relative_age_refs_relative_age_ref_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_relative_age_types_relative_age_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_relative_age_types_relative_age_type_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_relative_age_types_relative_age_type_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_relative_age_types_relative_age_type_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_relative_age_types_relative_age_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_relative_age_types_relative_age_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_relative_age_types_relative_age_type_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_relative_age_types_relative_age_type_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_relative_age_types_relative_age_type_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_relative_ages_relative_age_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_relative_ages_relative_age_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_relative_ages_relative_age_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_relative_ages_relative_age_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_relative_ages_relative_age_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_relative_ages_relative_age_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_relative_ages_relative_age_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_relative_ages_relative_age_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_relative_ages_relative_age_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_relative_dates_relative_date_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_relative_dates_relative_date_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_relative_dates_relative_date_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_relative_dates_relative_date_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_relative_dates_relative_date_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_relative_dates_relative_date_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_relative_dates_relative_date_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_relative_dates_relative_date_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_relative_dates_relative_date_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_alt_refs_sample_alt_ref_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_alt_refs_sample_alt_ref_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_alt_refs_sample_alt_ref_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_alt_refs_sample_alt_ref_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_alt_refs_sample_alt_ref_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_alt_refs_sample_alt_ref_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_alt_refs_sample_alt_ref_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_alt_refs_sample_alt_ref_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_alt_refs_sample_alt_ref_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_colours_sample_colour_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_colours_sample_colour_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_colours_sample_colour_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_colours_sample_colour_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_colours_sample_colour_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_colours_sample_colour_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_colours_sample_colour_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_colours_sample_colour_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_colours_sample_colour_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_coordinates_sample_coordinates_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_coordinates_sample_coordinates_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_coordinates_sample_coordinates_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_coordinates_sample_coordinates_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_coordinates_sample_coordinates_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_coordinates_sample_coordinates_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_coordinates_sample_coordinates_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_coordinates_sample_coordinates_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_coordinates_sample_coordinates_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_description_sample_sample_description_sample_gro_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_description_sample_sample_description_sample_gro_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_description_sample_sample_description_sample_gro_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_description_sample_sample_description_sample_gro_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_description_sample_sample_description_sample_gro_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_description_sample_sample_description_sample_gro_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_description_sample_sample_description_sample_gro_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_description_sample_sample_description_sample_gro_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_description_sample_sample_description_sample_gro_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_description_types_sample_description_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_description_types_sample_description_type_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_description_types_sample_description_type_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_description_types_sample_description_type_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_description_types_sample_description_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_description_types_sample_description_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_description_types_sample_description_type_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_description_types_sample_description_type_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_description_types_sample_description_type_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_descriptions_sample_description_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_descriptions_sample_description_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_descriptions_sample_description_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_descriptions_sample_description_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_descriptions_sample_description_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_descriptions_sample_description_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_descriptions_sample_description_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_descriptions_sample_description_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_descriptions_sample_description_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_dimensions_sample_dimension_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_dimensions_sample_dimension_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_dimensions_sample_dimension_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_dimensions_sample_dimension_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_dimensions_sample_dimension_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_dimensions_sample_dimension_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_dimensions_sample_dimension_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_dimensions_sample_dimension_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_dimensions_sample_dimension_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_geometry_sample_geometry_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_geometry_sample_geometry_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_geometry_sample_geometry_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_geometry_sample_geometry_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_geometry_sample_geometry_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_geometry_sample_geometry_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_geometry_sample_geometry_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_geometry_sample_geometry_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_geometry_sample_geometry_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_group_coordinates_sample_group_position_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_group_coordinates_sample_group_position_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_group_coordinates_sample_group_position_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_group_coordinates_sample_group_position_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_group_coordinates_sample_group_position_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_group_coordinates_sample_group_position_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_group_coordinates_sample_group_position_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_group_coordinates_sample_group_position_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_group_coordinates_sample_group_position_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_group_description__sample_group_desciption_sampl_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_group_description__sample_group_desciption_sampl_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_group_description__sample_group_desciption_sampl_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_group_description__sample_group_desciption_sampl_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_group_description__sample_group_desciption_sampl_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_group_description__sample_group_desciption_sampl_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_group_description__sample_group_desciption_sampl_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_group_description__sample_group_desciption_sampl_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_group_description__sample_group_desciption_sampl_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_group_description__sample_group_description_type_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_group_description__sample_group_description_type_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_group_description__sample_group_description_type_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_group_description__sample_group_description_type_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_group_description__sample_group_description_type_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_group_description__sample_group_description_type_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_group_description__sample_group_description_type_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_group_description__sample_group_description_type_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_group_description__sample_group_description_type_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_group_descriptions_sample_group_description_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_group_descriptions_sample_group_description_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_group_descriptions_sample_group_description_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_group_descriptions_sample_group_description_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_group_descriptions_sample_group_description_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_group_descriptions_sample_group_description_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_group_descriptions_sample_group_description_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_group_descriptions_sample_group_description_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_group_descriptions_sample_group_description_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_group_dimensions_sample_group_dimension_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_group_dimensions_sample_group_dimension_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_group_dimensions_sample_group_dimension_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_group_dimensions_sample_group_dimension_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_group_dimensions_sample_group_dimension_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_group_dimensions_sample_group_dimension_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_group_dimensions_sample_group_dimension_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_group_dimensions_sample_group_dimension_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_group_dimensions_sample_group_dimension_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_group_images_sample_group_image_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_group_images_sample_group_image_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_group_images_sample_group_image_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_group_images_sample_group_image_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_group_images_sample_group_image_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_group_images_sample_group_image_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_group_images_sample_group_image_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_group_images_sample_group_image_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_group_images_sample_group_image_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_group_notes_sample_group_note_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_group_notes_sample_group_note_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_group_notes_sample_group_note_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_group_notes_sample_group_note_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_group_notes_sample_group_note_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_group_notes_sample_group_note_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_group_notes_sample_group_note_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_group_notes_sample_group_note_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_group_notes_sample_group_note_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_group_references_sample_group_reference_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_group_references_sample_group_reference_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_group_references_sample_group_reference_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_group_references_sample_group_reference_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_group_references_sample_group_reference_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_group_references_sample_group_reference_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_group_references_sample_group_reference_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_group_references_sample_group_reference_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_group_references_sample_group_reference_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_group_sampling_contexts_sampling_context_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_group_sampling_contexts_sampling_context_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_group_sampling_contexts_sampling_context_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_group_sampling_contexts_sampling_context_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_group_sampling_contexts_sampling_context_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_group_sampling_contexts_sampling_context_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_group_sampling_contexts_sampling_context_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_group_sampling_contexts_sampling_context_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_group_sampling_contexts_sampling_context_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_groups_sample_group_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_groups_sample_group_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_groups_sample_group_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_groups_sample_group_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_groups_sample_group_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_groups_sample_group_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_groups_sample_group_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_groups_sample_group_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_groups_sample_group_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_horizons_sample_horizon_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_horizons_sample_horizon_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_horizons_sample_horizon_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_horizons_sample_horizon_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_horizons_sample_horizon_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_horizons_sample_horizon_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_horizons_sample_horizon_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_horizons_sample_horizon_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_horizons_sample_horizon_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_images_sample_image_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_images_sample_image_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_images_sample_image_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_images_sample_image_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_images_sample_image_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_images_sample_image_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_images_sample_image_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_images_sample_image_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_images_sample_image_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_location_sampling__sample_location_type_sampling_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_location_sampling__sample_location_type_sampling_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_location_sampling__sample_location_type_sampling_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_location_sampling__sample_location_type_sampling_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_location_sampling__sample_location_type_sampling_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_location_sampling__sample_location_type_sampling_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_location_sampling__sample_location_type_sampling_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_location_sampling__sample_location_type_sampling_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_location_sampling__sample_location_type_sampling_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_location_sampling_contex_sample_location_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_location_sampling_contex_sample_location_type_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_location_sampling_contex_sample_location_type_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_location_sampling_contex_sample_location_type_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_location_sampling_contex_sample_location_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_location_sampling_contex_sample_location_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_location_sampling_contex_sample_location_type_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_location_sampling_contex_sample_location_type_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_location_sampling_contex_sample_location_type_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_location_types_sample_location_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_location_types_sample_location_type_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_location_types_sample_location_type_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_location_types_sample_location_type_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_location_types_sample_location_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_location_types_sample_location_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_location_types_sample_location_type_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_location_types_sample_location_type_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_location_types_sample_location_type_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_locations_sample_location_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_locations_sample_location_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_locations_sample_location_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_locations_sample_location_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_locations_sample_location_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_locations_sample_location_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_locations_sample_location_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_locations_sample_location_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_locations_sample_location_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_notes_sample_note_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_notes_sample_note_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_notes_sample_note_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_notes_sample_note_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_notes_sample_note_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_notes_sample_note_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_notes_sample_note_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_notes_sample_note_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_notes_sample_note_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sample_types_sample_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sample_types_sample_type_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sample_types_sample_type_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_types_sample_type_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sample_types_sample_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_types_sample_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_types_sample_type_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_types_sample_type_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sample_types_sample_type_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_season_or_qualifier_season_or_qualifier_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_season_or_qualifier_season_or_qualifier_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_season_or_qualifier_season_or_qualifier_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_season_or_qualifier_season_or_qualifier_id_seq TO sead_master;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_season_or_qualifier_season_or_qualifier_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_season_or_qualifier_season_or_qualifier_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_season_types_season_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_season_types_season_type_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_season_types_season_type_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_season_types_season_type_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_season_types_season_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_season_types_season_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_season_types_season_type_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_season_types_season_type_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_season_types_season_type_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_seasons_season_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_seasons_season_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_seasons_season_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_seasons_season_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_seasons_season_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_seasons_season_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_seasons_season_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_seasons_season_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_seasons_season_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_site_images_site_image_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_site_images_site_image_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_site_images_site_image_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_site_images_site_image_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_site_images_site_image_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_site_images_site_image_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_site_images_site_image_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_site_images_site_image_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_site_images_site_image_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_site_locations_site_location_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_site_locations_site_location_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_site_locations_site_location_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_site_locations_site_location_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_site_locations_site_location_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_site_locations_site_location_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_site_locations_site_location_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_site_locations_site_location_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_site_locations_site_location_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_site_natgridrefs_site_natgridref_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_site_natgridrefs_site_natgridref_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_site_natgridrefs_site_natgridref_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_site_natgridrefs_site_natgridref_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_site_natgridrefs_site_natgridref_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_site_natgridrefs_site_natgridref_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_site_natgridrefs_site_natgridref_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_site_natgridrefs_site_natgridref_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_site_natgridrefs_site_natgridref_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_site_other_records_site_other_records_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_site_other_records_site_other_records_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_site_other_records_site_other_records_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_site_other_records_site_other_records_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_site_other_records_site_other_records_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_site_other_records_site_other_records_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_site_other_records_site_other_records_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_site_other_records_site_other_records_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_site_other_records_site_other_records_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_site_preservation_status_site_preservation_status_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_site_preservation_status_site_preservation_status_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_site_preservation_status_site_preservation_status_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_site_preservation_status_site_preservation_status_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_site_preservation_status_site_preservation_status_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_site_preservation_status_site_preservation_status_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_site_preservation_status_site_preservation_status_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_site_preservation_status_site_preservation_status_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_site_preservation_status_site_preservation_status_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_site_references_site_reference_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_site_references_site_reference_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_site_references_site_reference_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_site_references_site_reference_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_site_references_site_reference_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_site_references_site_reference_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_site_references_site_reference_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_site_references_site_reference_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_site_references_site_reference_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_sites_site_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_sites_site_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_sites_site_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_sites_site_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_sites_site_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sites_site_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sites_site_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sites_site_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_sites_site_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_species_associations_species_association_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_species_associations_species_association_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_species_associations_species_association_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_species_associations_species_association_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_species_associations_species_association_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_species_associations_species_association_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_species_associations_species_association_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_species_associations_species_association_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_species_associations_species_association_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_taxa_common_names_taxon_common_name_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_taxa_common_names_taxon_common_name_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_taxa_common_names_taxon_common_name_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxa_common_names_taxon_common_name_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxa_common_names_taxon_common_name_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxa_common_names_taxon_common_name_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxa_common_names_taxon_common_name_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxa_common_names_taxon_common_name_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxa_common_names_taxon_common_name_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_taxa_images_taxa_images_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_taxa_images_taxa_images_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_taxa_images_taxa_images_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxa_images_taxa_images_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxa_images_taxa_images_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxa_images_taxa_images_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxa_images_taxa_images_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxa_images_taxa_images_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxa_images_taxa_images_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_taxa_measured_attributes_measured_attribute_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_taxa_measured_attributes_measured_attribute_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_taxa_measured_attributes_measured_attribute_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxa_measured_attributes_measured_attribute_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxa_measured_attributes_measured_attribute_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxa_measured_attributes_measured_attribute_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxa_measured_attributes_measured_attribute_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxa_measured_attributes_measured_attribute_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxa_measured_attributes_measured_attribute_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_taxa_seasonality_seasonality_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_taxa_seasonality_seasonality_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_taxa_seasonality_seasonality_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxa_seasonality_seasonality_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxa_seasonality_seasonality_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxa_seasonality_seasonality_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxa_seasonality_seasonality_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxa_seasonality_seasonality_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxa_seasonality_seasonality_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_taxa_synonyms_synonym_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_taxa_synonyms_synonym_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_taxa_synonyms_synonym_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxa_synonyms_synonym_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxa_synonyms_synonym_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxa_synonyms_synonym_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxa_synonyms_synonym_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxa_synonyms_synonym_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxa_synonyms_synonym_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_taxa_tree_authors_author_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_taxa_tree_authors_author_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_taxa_tree_authors_author_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxa_tree_authors_author_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxa_tree_authors_author_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxa_tree_authors_author_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxa_tree_authors_author_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxa_tree_authors_author_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxa_tree_authors_author_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_taxa_tree_families_family_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_taxa_tree_families_family_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_taxa_tree_families_family_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxa_tree_families_family_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxa_tree_families_family_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxa_tree_families_family_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxa_tree_families_family_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxa_tree_families_family_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxa_tree_families_family_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_taxa_tree_genera_genus_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_taxa_tree_genera_genus_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_taxa_tree_genera_genus_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxa_tree_genera_genus_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxa_tree_genera_genus_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxa_tree_genera_genus_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxa_tree_genera_genus_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxa_tree_genera_genus_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxa_tree_genera_genus_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_taxa_tree_master_taxon_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_taxa_tree_master_taxon_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_taxa_tree_master_taxon_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxa_tree_master_taxon_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxa_tree_master_taxon_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxa_tree_master_taxon_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxa_tree_master_taxon_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxa_tree_master_taxon_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxa_tree_master_taxon_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_taxa_tree_orders_order_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_taxa_tree_orders_order_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_taxa_tree_orders_order_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxa_tree_orders_order_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxa_tree_orders_order_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxa_tree_orders_order_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxa_tree_orders_order_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxa_tree_orders_order_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxa_tree_orders_order_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_taxonomic_order_systems_taxonomic_order_system_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_taxonomic_order_systems_taxonomic_order_system_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_taxonomic_order_systems_taxonomic_order_system_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxonomic_order_systems_taxonomic_order_system_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxonomic_order_systems_taxonomic_order_system_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxonomic_order_systems_taxonomic_order_system_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxonomic_order_systems_taxonomic_order_system_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxonomic_order_systems_taxonomic_order_system_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxonomic_order_systems_taxonomic_order_system_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_taxonomic_order_taxonomic_order_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_taxonomic_order_taxonomic_order_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_taxonomic_order_taxonomic_order_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxonomic_order_taxonomic_order_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxonomic_order_taxonomic_order_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxonomic_order_taxonomic_order_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxonomic_order_taxonomic_order_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxonomic_order_taxonomic_order_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxonomic_order_taxonomic_order_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_taxonomy_notes_taxonomy_notes_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_taxonomy_notes_taxonomy_notes_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_taxonomy_notes_taxonomy_notes_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxonomy_notes_taxonomy_notes_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_taxonomy_notes_taxonomy_notes_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxonomy_notes_taxonomy_notes_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxonomy_notes_taxonomy_notes_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxonomy_notes_taxonomy_notes_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_taxonomy_notes_taxonomy_notes_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_tephra_dates_tephra_date_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_tephra_dates_tephra_date_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_tephra_dates_tephra_date_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_tephra_dates_tephra_date_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_tephra_dates_tephra_date_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_tephra_dates_tephra_date_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_tephra_dates_tephra_date_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_tephra_dates_tephra_date_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_tephra_dates_tephra_date_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_tephra_refs_tephra_ref_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_tephra_refs_tephra_ref_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_tephra_refs_tephra_ref_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_tephra_refs_tephra_ref_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_tephra_refs_tephra_ref_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_tephra_refs_tephra_ref_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_tephra_refs_tephra_ref_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_tephra_refs_tephra_ref_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_tephra_refs_tephra_ref_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_tephras_tephra_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_tephras_tephra_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_tephras_tephra_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_tephras_tephra_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_tephras_tephra_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_tephras_tephra_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_tephras_tephra_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_tephras_tephra_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_tephras_tephra_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_text_biology_biology_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_text_biology_biology_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_text_biology_biology_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_text_biology_biology_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_text_biology_biology_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_text_biology_biology_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_text_biology_biology_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_text_biology_biology_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_text_biology_biology_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_text_distribution_distribution_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_text_distribution_distribution_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_text_distribution_distribution_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_text_distribution_distribution_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_text_distribution_distribution_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_text_distribution_distribution_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_text_distribution_distribution_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_text_distribution_distribution_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_text_distribution_distribution_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_text_identification_keys_key_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_text_identification_keys_key_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_text_identification_keys_key_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_text_identification_keys_key_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_text_identification_keys_key_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_text_identification_keys_key_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_text_identification_keys_key_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_text_identification_keys_key_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_text_identification_keys_key_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_units_unit_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_units_unit_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_units_unit_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_units_unit_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_units_unit_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_units_unit_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_units_unit_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_units_unit_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_units_unit_id_seq TO querysead_worker;


--
-- Name: SEQUENCE tbl_years_types_years_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON SEQUENCE public.tbl_years_types_years_type_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tbl_years_types_years_type_id_seq FROM sead_master;
GRANT ALL ON SEQUENCE public.tbl_years_types_years_type_id_seq TO sead_master;
GRANT ALL ON SEQUENCE public.tbl_years_types_years_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_years_types_years_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_years_types_years_type_id_seq TO humlab_read;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_years_types_years_type_id_seq TO querysead_owner;
GRANT SELECT,USAGE ON SEQUENCE public.tbl_years_types_years_type_id_seq TO querysead_worker;


--
-- Name: TABLE v_json_array; Type: ACL; Schema: public; Owner: clearinghouse_worker
--

REVOKE ALL ON TABLE public.v_json_array FROM PUBLIC;
REVOKE ALL ON TABLE public.v_json_array FROM clearinghouse_worker;
GRANT ALL ON TABLE public.v_json_array TO clearinghouse_worker;
GRANT SELECT ON TABLE public.v_json_array TO querysead_owner;
GRANT SELECT ON TABLE public.v_json_array TO querysead_worker;
GRANT ALL ON TABLE public.v_json_array TO johan;


--
-- Name: TABLE view_taxa_tree; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.view_taxa_tree FROM PUBLIC;
REVOKE ALL ON TABLE public.view_taxa_tree FROM sead_master;
GRANT ALL ON TABLE public.view_taxa_tree TO sead_master;
GRANT ALL ON TABLE public.view_taxa_tree TO postgres;
GRANT ALL ON TABLE public.view_taxa_tree TO sead_read;
GRANT ALL ON TABLE public.view_taxa_tree TO mattias;
GRANT SELECT ON TABLE public.view_taxa_tree TO humlab_read;
GRANT SELECT ON TABLE public.view_taxa_tree TO querysead_owner;
GRANT SELECT ON TABLE public.view_taxa_tree TO querysead_worker;
GRANT ALL ON TABLE public.view_taxa_tree TO johan;


--
-- Name: TABLE view_taxa_tree_select; Type: ACL; Schema: public; Owner: sead_master
--

REVOKE ALL ON TABLE public.view_taxa_tree_select FROM PUBLIC;
REVOKE ALL ON TABLE public.view_taxa_tree_select FROM sead_master;
GRANT ALL ON TABLE public.view_taxa_tree_select TO sead_master;
GRANT ALL ON TABLE public.view_taxa_tree_select TO postgres;
GRANT ALL ON TABLE public.view_taxa_tree_select TO sead_read;
GRANT ALL ON TABLE public.view_taxa_tree_select TO mattias;
GRANT SELECT ON TABLE public.view_taxa_tree_select TO humlab_read;
GRANT SELECT ON TABLE public.view_taxa_tree_select TO querysead_owner;
GRANT SELECT ON TABLE public.view_taxa_tree_select TO querysead_worker;
GRANT ALL ON TABLE public.view_taxa_tree_select TO johan;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: humlab_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE humlab_admin IN SCHEMA public REVOKE ALL ON TABLES  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE humlab_admin IN SCHEMA public REVOKE ALL ON TABLES  FROM humlab_admin;
ALTER DEFAULT PRIVILEGES FOR ROLE humlab_admin IN SCHEMA public GRANT SELECT,TRIGGER ON TABLES  TO querysead_worker;
ALTER DEFAULT PRIVILEGES FOR ROLE humlab_admin IN SCHEMA public GRANT SELECT,TRIGGER ON TABLES  TO querysead_owner;


--
-- PostgreSQL database dump complete
--

