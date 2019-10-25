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

        set search_path = facet, pg_catalog;

        set role querysead_owner;

        /* create tables */

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
            facet_source_table_id serial primary key,
            facet_id integer not null references facet(facet_id),
            clause character varying(512)
        );

        create table if not exists facet.facet_table (
            facet_table_id serial primary key,
            facet_id integer not null references facet(facet_id),
            sequence_id integer not null,
            schema_name character varying(80),
            table_name character varying(80),
            alias character varying(80)
        );

        create table if not exists facet.graph_table (
            table_id serial primary key,
            table_name information_schema.sql_identifier not null
        );

        create table if not exists facet.graph_table_relation (
            relation_id serial primary key,
            source_table_id integer not null references graph_table(table_id),
            target_table_id integer not null references graph_table(table_id),
            weight integer default 0 not null,
            source_column_name information_schema.sql_identifier not null,
            target_column_name information_schema.sql_identifier not null
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
            table_name character varying(80),
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

        create index idx_graph_table_relation_fk1 on graph_table_relation using btree (source_table_id);
        create index idx_graph_table_relation_fk2 on graph_table_relation using btree (target_table_id);

        grant usage on schema facet to querysead_owner, querysead_worker, sead_read, sead_write;

        grant select        on all tables    in schema facet, public to public, querysead_worker, sead_read, sead_write;
        grant select, usage on all sequences in schema facet, public to public, querysead_worker, sead_read, sead_write;
        grant execute       on all functions in schema facet, public to public, querysead_worker, sead_read, sead_write;

        alter default privileges in schema facet grant select        on tables    to public, querysead_worker, sead_read, sead_write;
        alter default privileges in schema facet grant select, usage on sequences to public, querysead_worker, sead_read, sead_write;
        alter default privileges in schema facet grant execute       on functions to public, querysead_worker, sead_read, sead_write;


    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;

