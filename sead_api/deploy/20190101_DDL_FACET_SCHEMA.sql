-- Deploy sead_api:20190101_DDL_FACET_SCHEMA to pg
-- rollback
/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description
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

        create table if not exists facet.facet_group (
            facet_group_id integer not null primary key,
            facet_group_key character varying(80) not null,
            display_title character varying(80) not null,
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
            facet_code character varying(80) not null,
            display_title character varying(80) not null,
            facet_group_id integer not null references facet_group(facet_group_id),
            facet_type_id integer not null references facet_type(facet_type_id),
            category_id_expr character varying(256) not null,
            category_name_expr character varying(256) not null,
            icon_id_expr character varying(256) not null,
            sort_expr character varying(256) not null,
            is_applicable boolean not null,
            is_default boolean not null,
            aggregate_type character varying(256) not null,
            aggregate_title character varying(256) not null,
            aggregate_facet_id integer not null
        );

        create table if not exists facet.facet_clause (
            facet_clause_id serial primary key,
            facet_id integer not null references facet(facet_id),
            clause character varying(512)
        );

        create table if not exists facet.facet_table (
            facet_table_id serial primary key,
            facet_id integer not null references facet(facet_id),
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

        create index idx_table_relation_fk1 on table_relation using btree (source_table_id);
        create index idx_table_relation_fk2 on table_relation using btree (target_table_id);

        grant select        on all tables    in schema facet to querysead_worker;
        grant select, usage on all sequences in schema facet to querysead_worker;
        grant execute       on all functions in schema facet to querysead_worker;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;

set search_path = public, pg_catalog;

create or replace function facet.method_measured_values(p_dataset_method_id int, p_prep_method_id int)
returns table (
    physical_sample_id int,
    -- analysis_entity_id int,
    measured_value numeric(20,10)
) as $$
begin

    return query
        select distinct ae.physical_sample_id, /* mv.analysis_entity_id, */ mv.measured_value
        from tbl_measured_values mv
        join tbl_analysis_entities ae using (analysis_entity_id)
        join tbl_datasets ds using (dataset_id)
        left join tbl_analysis_entity_prep_methods pm using (analysis_entity_id)
        where ds.method_id = p_dataset_method_id
          and coalesce(pm.method_id, 0) = p_prep_method_id;

end $$ language plpgsql;

create or replace view facet.view_abundance
 as
 select tbl_abundances.analysis_entity_id,
    tbl_abundances.taxon_id,
    tbl_methods.method_name::text || coalesce(' '::text || tbl_modification_types.modification_type_name::text, ''::text) as elements_part_mod,
    tbl_abundances.abundance
   from tbl_abundances
     join (tbl_analysis_entities
     join tbl_datasets on tbl_datasets.dataset_id = tbl_analysis_entities.dataset_id
     join tbl_methods on tbl_methods.method_id = tbl_datasets.method_id) on tbl_abundances.analysis_entity_id = tbl_analysis_entities.analysis_entity_id
     left join tbl_abundance_modifications on tbl_abundances.abundance_id = tbl_abundance_modifications.abundance_id
     left join tbl_modification_types on tbl_modification_types.modification_type_id = tbl_abundance_modifications.modification_type_id
     left join tbl_abundance_elements on tbl_abundances.abundance_element_id = tbl_abundance_elements.abundance_element_id
  order by (tbl_methods.method_name::text || coalesce(' '::text || tbl_modification_types.modification_type_name::text, ''::text));

create or replace view facet.view_abundances_by_taxon_analysis_entity
 as
 select distinct tbl_abundances.taxon_id,
    tbl_abundances.analysis_entity_id,
    m3.abundance_m3,
    m8.abundance_m8,
    m111.abundance_m111
   from tbl_abundances
     left join (
		select a.taxon_id, a.analysis_entity_id, a.abundance as abundance_m3
		from tbl_abundances a
		left join tbl_analysis_entities on tbl_analysis_entities.analysis_entity_id = a.analysis_entity_id
		join tbl_datasets on tbl_analysis_entities.dataset_id = tbl_datasets.dataset_id
		where tbl_datasets.method_id = 3
	) m3
	  on m3.taxon_id = tbl_abundances.taxon_id and m3.analysis_entity_id = tbl_abundances.analysis_entity_id
    left join (
		select a.taxon_id, a.analysis_entity_id, a.abundance as abundance_m8
		from tbl_abundances a
		left join tbl_analysis_entities on tbl_analysis_entities.analysis_entity_id = a.analysis_entity_id
		join tbl_datasets on tbl_analysis_entities.dataset_id = tbl_datasets.dataset_id
		where tbl_datasets.method_id = 8
	) m8
	  on m8.taxon_id = tbl_abundances.taxon_id and m8.analysis_entity_id = tbl_abundances.analysis_entity_id
    left join (
		select a.taxon_id, a.analysis_entity_id, a.abundance as abundance_m111
		from tbl_abundances a
		left join tbl_analysis_entities on tbl_analysis_entities.analysis_entity_id = a.analysis_entity_id
		join tbl_datasets on tbl_analysis_entities.dataset_id = tbl_datasets.dataset_id
		where tbl_datasets.method_id = 111
	) m111
	  on m111.taxon_id = tbl_abundances.taxon_id and m111.analysis_entity_id = tbl_abundances.analysis_entity_id;

create or replace view facet.view_sample_group_references
 as
 select tbl_sample_group_references.sample_group_id,
    tbl_sample_group_references.biblio_id,
    tbl_sample_group_references.date_updated,
    'sample_group'::text as biblio_link
   from tbl_sample_group_references
union
 select tbl_sample_groups.sample_group_id,
    tbl_site_references.biblio_id,
    tbl_site_references.date_updated,
    'indirect_via_site'::text as biblio_link
   from tbl_site_references
     join tbl_sites on tbl_site_references.site_id = tbl_sites.site_id
     join tbl_sample_groups on tbl_sample_groups.site_id = tbl_sites.site_id
  order by 1;

 create or replace view facet.view_site_references
 as
 select tbl_site_references.site_id,
    tbl_site_references.biblio_id,
    tbl_site_references.date_updated,
    'site_direct'::text as biblio_link
   from tbl_site_references
union
 select tbl_sites.site_id,
    tbl_sample_group_references.biblio_id,
    tbl_sample_group_references.date_updated,
    'via_sample_group'::text as biblio_link
   from tbl_sample_group_references
     join tbl_sample_groups on tbl_sample_groups.sample_group_id = tbl_sample_group_references.sample_group_id
     join tbl_sites on tbl_sample_groups.site_id = tbl_sites.site_id
  order by 1;

create or replace view facet.view_taxa_biblio
 as
 select tbl_text_distribution.biblio_id,
    tbl_text_distribution.taxon_id
   from tbl_text_distribution
union
 select tbl_text_biology.biblio_id,
    tbl_text_biology.taxon_id
   from tbl_text_biology
union
 select tbl_taxonomy_notes.biblio_id,
    tbl_taxonomy_notes.taxon_id
   from tbl_taxonomy_notes;