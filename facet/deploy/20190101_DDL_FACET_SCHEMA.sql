-- Deploy sead_api: 20190101_DDL_FACET_SCHEMA
-- rollback
/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description   SEAD Query API schema DDL.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/160
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

--grant querysead_owner to humlab_admin;  -- required by set role statement

-- do $$
-- begin
--   execute format('grant create, connect on database %I to %I, %I', current_database(), 'querysead_owner', 'querysead_worker');
-- end; $$;

begin;
do $$
begin

    begin


        if current_database() not like 'sead_staging%' then
            raise exception 'this script must be run in sead_staging!';
        end if;

        --if current_role != 'querysead_owner' then
        --    raise exception 'this script must be run as querysead_owner!';
        --end if;

        set default_with_oids = false;

        drop schema if exists facet cascade;

        create schema if not exists facet authorization querysead_owner;

        alter default privileges in schema facet grant select        on tables    to public, querysead_worker, sead_read, sead_write;
        alter default privileges in schema facet grant select, usage on sequences to public, querysead_worker, sead_read, sead_write;
        alter default privileges in schema facet grant execute       on functions to public, querysead_worker, sead_read, sead_write;

        grant usage on schema facet to querysead_owner, querysead_worker, sead_read, sead_write;

        grant select        on all tables    in schema facet to public;
        grant select, usage on all sequences in schema facet to public;
        grant execute       on all functions in schema facet to public;

        grant select        on all tables    in schema facet, public to querysead_worker;
        grant select, usage on all sequences in schema facet, public to querysead_worker;
        grant execute       on all functions in schema facet, public to querysead_worker;

        set search_path = facet, pg_catalog;

        set role querysead_owner;

        /* create tables */

        create table if not exists facet.table (
            table_id int primary key,
            schema_name information_schema.sql_identifier not null default (''),
            table_or_udf_name information_schema.sql_identifier unique not null,
            primary_key_name information_schema.sql_identifier not null default (''),
			is_udf boolean not null default(false)
        );

        create table if not exists facet.table_relation (
            table_relation_id serial primary key,
            source_table_id integer not null references facet.table(table_id),
            target_table_id integer not null references facet.table(table_id),
            weight integer default 0 not null,
            source_column_name information_schema.sql_identifier not null,
            target_column_name information_schema.sql_identifier not null
        );

        -- create table if not exists facet.facet_domain (
        --     facet_domain_id serial primary key,
        --     display_title character varying(80) not null,
        --     description character varying(256) not null default('')
        --  );

        create table if not exists facet.facet_group (
            facet_group_id integer not null primary key,
            -- facet_domain_id integer not null default(0) references facet.facet_domain(table_id),
            facet_group_key character varying(80) unique not null,
            display_title character varying(80) not null,
            description character varying(256) not null default(''),
            is_applicable boolean not null,
            is_default boolean not null
        );

        create table if not exists facet.facet_type (
            facet_type_id integer not null primary key,
            facet_type_name character varying(80) not null,
            reload_as_target boolean default false not null
        );

        create table if not exists facet.facet (
            facet_id integer not null primary key,
            facet_code character varying(80) unique not null,
            display_title character varying(80) not null,
            description character varying(256) not null default(''),
            facet_group_id integer not null references facet_group(facet_group_id),
            facet_type_id integer not null references facet_type(facet_type_id),
            category_id_expr character varying(256) not null,
            category_id_type character varying(80) not null default('integer'),
            category_id_operator character varying(80) not null default('='),
            category_name_expr character varying(256) not null,
            sort_expr character varying(256) not null,
            is_applicable boolean not null,
            is_default boolean not null,
            aggregate_type character varying(256) not null,
            aggregate_title character varying(256) not null,
            aggregate_facet_id integer not null /* references facet.facet(facet_id) */
        );

        create table if not exists facet.facet_dependency (
            facet_dependency_id serial primary key,
            facet_id integer not null references facet(facet_id) on delete cascade,
            dependency_facet_id integer not null references facet(facet_id)
        );

        create table if not exists facet.facet_clause (
            facet_clause_id serial primary key,
            facet_id integer not null references facet(facet_id) on delete cascade,
            clause character varying(512)
        );

        create table if not exists facet.facet_table (
            facet_table_id serial primary key,
            facet_id integer not null references facet(facet_id) on delete cascade,
            sequence_id integer not null,
            table_id integer not null references facet.table(table_id),
			udf_call_arguments character varying(80) null,
            alias character varying(80) unique null
        );

        create table if not exists facet.result_aggregate (
            aggregate_id integer not null primary key,
            aggregate_key character varying(40) not null,
            display_text character varying(80) not null,
            is_applicable boolean default false not null,
            is_activated boolean default true not null,
            input_type character varying(40) default 'checkboxes'::character varying not null,
            has_selector boolean default true not null
        );

        create table if not exists facet.result_field_type (
            field_type_id character varying(40) primary key,
            is_result_value boolean default true not null,
            sql_field_compiler character varying(40) default ''::character varying not null,
            is_aggregate_field boolean default false not null,
            is_sort_field boolean default false not null,
            is_item_field boolean default false not null,
            sql_template character varying(256) default '{0}'::character varying not null
        );

        create table if not exists facet.result_field (
            result_field_id serial primary key,
            result_field_key character varying(40) not null,
            table_name character varying(80) references facet.table(table_or_udf_name),	-- TODO: should reference PK facet.table.table_id instead
            column_name character varying(80) not null,
            display_text character varying(80) not null,
            field_type_id character varying(20) not null references result_field_type(field_type_id),
            activated boolean not null,
            link_url character varying(256),
            link_label character varying(256)
        );

        create table if not exists facet.result_aggregate_field (
            aggregate_field_id serial primary key,
            aggregate_id integer not null references result_aggregate(aggregate_id),
            result_field_id integer not null references result_field(result_field_id),
            field_type_id character varying(40) default 'single_item'::character varying not null references result_field_type(field_type_id),
            sequence_id integer default 0 not null
        );

        create table if not exists facet.result_view_type (
            view_type_id character varying(40) not null primary key,
            view_name character varying(40) not null,
            is_cachable boolean default true not null
        );

        create table if not exists facet.view_state (
            view_state_key character varying(80) not null primary key,
            view_state_data text not null,
            create_time timestamp with time zone default clock_timestamp()
        );

        create view report_site as
            select tbl_sites.site_id as id,
                tbl_sites.site_id,
                tbl_sites.site_name as "Site name",
                tbl_sites.site_description as "Site description",
                tbl_site_natgridrefs.natgridref as "National grid ref",
                array_to_string(array_agg(tbl_locations.location_name order by tbl_locations.location_type_id desc), ','::text) as places,
                tbl_site_preservation_status.preservation_status_or_threat as "Preservation status or threat",
                tbl_sites.latitude_dd as site_lat,
                tbl_sites.longitude_dd as site_lng
            from ((((public.tbl_sites
            left join public.tbl_site_locations on ((tbl_site_locations.site_id = tbl_sites.site_id)))
            left join public.tbl_site_natgridrefs on ((tbl_site_natgridrefs.site_id = tbl_sites.site_id)))
            left join public.tbl_site_preservation_status on ((tbl_site_preservation_status.site_preservation_status_id = tbl_sites.site_preservation_status_id)))
            left join public.tbl_locations on ((tbl_locations.location_id = tbl_site_locations.location_id)))
            group by tbl_sites.site_id, tbl_sites.site_name, tbl_sites.site_description, tbl_site_natgridrefs.natgridref, tbl_sites.latitude_dd, tbl_sites.longitude_dd, tbl_site_preservation_status.preservation_status_or_threat;

		-- FIXME Deprecate in favor of facet.abundance_taxon
		create or replace view facet.view_abundance
		 as
		 select tbl_abundances.analysis_entity_id,
		    tbl_abundances.taxon_id,
		    tbl_methods.method_name::text || coalesce(' '::text || tbl_modification_types.modification_type_name::text, ''::text) as elements_part_mod,
		    tbl_abundances.abundance
		   from public.tbl_abundances
		     join (public.tbl_analysis_entities
		     join public.tbl_datasets on tbl_datasets.dataset_id = tbl_analysis_entities.dataset_id
		     join public.tbl_methods on tbl_methods.method_id = tbl_datasets.method_id) on tbl_abundances.analysis_entity_id = tbl_analysis_entities.analysis_entity_id
		     left join public.tbl_abundance_modifications on tbl_abundances.abundance_id = tbl_abundance_modifications.abundance_id
		     left join public.tbl_modification_types on tbl_modification_types.modification_type_id = tbl_abundance_modifications.modification_type_id
		     left join public.tbl_abundance_elements on tbl_abundances.abundance_element_id = tbl_abundance_elements.abundance_element_id
		  order by (tbl_methods.method_name::text || coalesce(' '::text || tbl_modification_types.modification_type_name::text, ''::text));

		/* to be replaced my UDF method_abundance */
		create or replace view facet.view_abundances_by_taxon_analysis_entity
		 as
		 with method_abundance as (
			select ds.method_id, a.taxon_id, a.analysis_entity_id, a.abundance
			from public.tbl_abundances a
			left join public.tbl_analysis_entities ae
			  on ae.analysis_entity_id = a.analysis_entity_id
			join public.tbl_datasets ds
			  on ae.dataset_id = ds.dataset_id
		 )
			select distinct a.taxon_id,
							a.analysis_entity_id,
							m3.abundance as abundance_m3,
							m8.abundance as abundance_m8,
							m111.abundance as abundance_m111
			from public.tbl_abundances a
			left join method_abundance m3
			  on m3.method_id = 3
			 and m3.taxon_id = a.taxon_id
			 and m3.analysis_entity_id = a.analysis_entity_id
			left join method_abundance m8
			  on m8.method_id = 8
			 and m8.taxon_id = a.taxon_id
			 and m8.analysis_entity_id = a.analysis_entity_id
			left join method_abundance m111
			  on m111.method_id = 111
			 and m111.taxon_id = a.taxon_id
			 and m111.analysis_entity_id = a.analysis_entity_id;

		create or replace view facet.view_sample_group_references
		 as
		 select tbl_sample_group_references.sample_group_id,
		    tbl_sample_group_references.biblio_id,
		    tbl_sample_group_references.date_updated,
		    'sample_group'::text as biblio_link
		   from public.tbl_sample_group_references
		union
		 select tbl_sample_groups.sample_group_id,
		    tbl_site_references.biblio_id,
		    tbl_site_references.date_updated,
		    'indirect_via_site'::text as biblio_link
		   from public.tbl_site_references
		     join public.tbl_sites on tbl_site_references.site_id = tbl_sites.site_id
		     join public.tbl_sample_groups on tbl_sample_groups.site_id = tbl_sites.site_id
		  order by 1;

		 create or replace view facet.view_site_references
		 as
		 	select site_id, biblio_id,	date_updated, 'site_direct'::text as biblio_link
			from public.tbl_site_references
			union
			select s.site_id, sgr.biblio_id, sgr.date_updated, 'via_sample_group'::text as biblio_link
			from public.tbl_sample_group_references sgr
			join public.tbl_sample_groups sg
			  on sg.sample_group_id = sgr.sample_group_id
			join public.tbl_sites s on sg.site_id = s.site_id
			order by 1;

		create or replace view facet.view_taxa_biblio as
		 	select biblio_id, taxon_id
		   	from public.tbl_text_distribution
			union
		 	select biblio_id, taxon_id
		   	from public.tbl_text_biology
			union
		 	select biblio_id, taxon_id
		   	from public.tbl_taxonomy_notes;

        create index idx_table_relation_fk1 on facet.table_relation using btree (source_table_id);
        create index idx_table_relation_fk2 on facet.table_relation using btree (target_table_id);

		create or replace view facet.relation_weight as
			select table_relation_id, r.source_table_id, s.table_or_udf_name as source_table, r.target_table_id, t.table_or_udf_name as target_table, r.weight
			from facet.table_relation r
			join facet.table s on s.table_id = r.source_table_id
			join facet.table t on t.table_id = r.target_table_id;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;

set search_path = public, pg_catalog;

-- drop function facet.method_measured_values(p_dataset_method_id int, p_prep_method_id int);
create or replace function facet.method_measured_values(p_dataset_method_id int, p_prep_method_id int)
returns table (
    analysis_entity_id int,
    measured_value numeric(20,10)
) as $$
begin

    return query
        select mv.analysis_entity_id::int, mv.measured_value
        from tbl_measured_values mv
        join tbl_analysis_entities ae using (analysis_entity_id)
        join tbl_datasets ds using (dataset_id)
        left join tbl_analysis_entity_prep_methods pm using (analysis_entity_id)
        where ds.method_id = p_dataset_method_id
          and coalesce(pm.method_id, 0) = p_prep_method_id;

end $$ language plpgsql;

create or replace function facet.method_abundance(p_dataset_method_id int)
returns table (
    taxon_id int,
    analysis_entity_id int,
    abundance numeric(20,10)
) as $$
begin

	 return query
		select a.taxon_id, a.analysis_entity_id, a.abundance
		from tbl_abundances a
		join tbl_analysis_entities ae
		  on ae.analysis_entity_id = a.analysis_entity_id
		join tbl_datasets ds
		  on ds.method_id = p_dataset_method_id;

end $$ language plpgsql;
drop function if exists facet.create_or_update_facet(jsonb);


create or replace function facet.create_or_update_facet(j_facet jsonb)
returns json
as $body$
	declare j_tables json;
	declare j_clauses json;
	declare i_facet_id int;
	declare s_aggregate_facet_code text;
	declare i_aggregate_facet_id int = 0;
begin

	j_tables = j_facet -> 'tables';
	j_clauses = j_facet -> 'clauses';
--	j_facet = j_facet - 'tables';
--	j_facet = j_facet - 'clauses';

	i_facet_id = (j_facet ->> 'facet_id')::int;
	if i_facet_id is null then
		i_facet_id = (select coalesce(max(facet_id),0)+1 from facet.facet);
	else
		delete from facet.facet
			where facet_id = i_facet_id;
	end if;

	s_aggregate_facet_code = (j_facet ->> 'aggregate_facet_code')::text;

	if  s_aggregate_facet_code is null then
		i_aggregate_facet_id = 0;
	else
		i_aggregate_facet_id = (select facet_id from facet.facet where facet_code = s_aggregate_facet_code);
		if i_aggregate_facet_id is null then
			raise notice 'aggregate_facet_id not found for % - %', (j_facet ->> 'facet_code')::text, s_aggregate_facet_code;
		end if;
	end if;

	insert into facet.facet (
		facet_id, facet_code, display_title, description, facet_group_id, facet_type_id, category_id_expr, category_id_type, category_id_operator,
		category_name_expr, sort_expr, is_applicable, is_default, aggregate_type, aggregate_title, aggregate_facet_id)
		(values (
			i_facet_id,
			(j_facet ->> 'facet_code')::text,
			(j_facet ->> 'display_title')::text,
			(j_facet ->> 'description')::text,
			(j_facet ->> 'facet_group_id')::int,
			(j_facet ->> 'facet_type_id')::text::int,
			(j_facet ->> 'category_id_expr')::text,
			(j_facet ->> 'category_id_type')::text,
			(j_facet ->> 'category_id_operator')::text,
			(j_facet ->> 'category_name_expr')::text,
			(j_facet ->> 'sort_expr')::text,
			(j_facet ->> 'is_applicable')::boolean,
			(j_facet ->> 'is_default')::boolean,
			(j_facet ->> 'aggregate_type')::text,
			(j_facet ->> 'aggregate_title')::text,
			i_aggregate_facet_id
		));

	insert into facet.facet_table (facet_id, sequence_id, table_id, udf_call_arguments, alias)
		select i_facet_id, sequence_id, table_id, udf_call_arguments, alias
		from (
			select  (v ->> 'sequence_id')::int		   as sequence_id,
					(v ->> 'table_name')::text		   as table_or_udf_name,
					(v ->> 'udf_call_arguments')::text as udf_call_arguments,
					(v ->> 'alias')					   as alias
			from jsonb_array_elements(j_facet -> 'tables') as v
		) as v(sequence_id, table_or_udf_name, udf_call_arguments, alias)
		left join facet.table t using (table_or_udf_name);

	insert into facet.facet_clause (facet_id, clause)
		select i_facet_id, (v ->> 'clause')::text
		from jsonb_array_elements(j_facet -> 'clauses') as v;

	return j_facet;

end $body$ language plpgsql;


create or replace function facet.export_facets_to_json()
	returns text as $$
	declare json_template text;
	declare json_table_template text;
	declare json_clause_template text;
	declare json_facet text;
	declare json_facets text;
	declare json_table text;
	declare json_clause text;
	declare r_facet record;
	declare r_facet_table record;
	declare r_facet_clause record;
	begin

		json_template = $_${
				"facet_id": %s,
				"facet_code": "%s",
				"display_title": "%s",
				"description": "%s",
				"facet_group_id":"%s",
				"facet_type_id": %s,
				"category_id_expr": "%s",
				"category_id_type": "%s",
				"category_id_operator": "%s",
				"category_name_expr": "%s",
				"sort_expr": "%s",
				"is_applicable": %s,
				"is_default": %s,
				"aggregate_type": "%s",
				"aggregate_title": "%s",
				"aggregate_facet_code": %s,
				"tables": [ %s ],
				"clauses": [ %s ]
		}$_$;

		json_table_template = $_$
				{
					"sequence_id": %s,
					"table_name": "%s",
					"udf_call_arguments": %s,
					"alias":  %s
				}$_$;

		json_clause_template = $_$
				{
					"clause": "%s"
				}$_$;

		json_facets = null;

		FOR r_facet in
			SELECT f.*, af.facet_code as aggregate_facet_code
			FROM facet.facet f
			LEFT JOIN facet.facet af
			  ON af.facet_id = f.aggregate_facet_id
	    LOOP

			SELECT string_agg(
				format(json_table_template,
					   ft.sequence_id,
					   t.table_or_udf_name,
					   coalesce('"' || ft.udf_call_arguments || '"', 'null'),
					   coalesce('"' || ft.alias || '"', 'null')), ','
					ORDER BY sequence_id
			)
				INTO json_table
			FROM facet.facet_table ft
			JOIN facet.table t using (table_id)
			WHERE facet_id = r_facet.facet_id
			GROUP BY facet_id;

			SELECT string_agg(format(json_clause_template, clause), ',')
				INTO json_clause
			FROM facet.facet_clause
			WHERE facet_id = r_facet.facet_id
			GROUP BY facet_id;

			json_facet = format(json_template,
				r_facet.facet_id,
				r_facet.facet_code,
				r_facet.display_title,
				r_facet.description,
				r_facet.facet_group_id,
				r_facet.facet_type_id,
				r_facet.category_id_expr,
				r_facet.category_id_type,
				r_facet.category_id_operator,
				r_facet.category_name_expr,
				r_facet.sort_expr,
				case when r_facet.is_applicable = TRUE then 'true' else 'false' end,
				case when r_facet.is_default = TRUE then 'true' else 'false' end,
				r_facet.aggregate_type,
				r_facet.aggregate_title,
				coalesce('"' || r_facet.aggregate_facet_code || '"', 'null'),
				json_table,
				json_clause
			);

			json_facets = coalesce(json_facets || ', ', '') || json_facet;
	    END LOOP;
		json_facets = '[' || json_facets || ']';
		raise notice '%', json_facets;

	end $$
	language plpgsql;

grant select        on all tables    in schema facet to querysead_worker;
grant select, usage on all sequences in schema facet to querysead_worker;
grant execute       on all functions in schema facet to querysead_worker;

