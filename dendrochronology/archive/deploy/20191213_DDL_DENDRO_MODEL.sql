
do $$
begin
	begin

        raise notice '20191213_DDL_DENDRO_MODEL has been backported to SEAD model and is now idempotent';

        -- if sead_utility.table_exists('public'::text, 'tbl_dendro_lookup'::text) = true then
        --     raise exception sqlstate 'GUARD';
        -- end if;

        -- if (select count(*) from public.tbl_dendro) > 0 then
        --     raise exception 'Cannot delete tbl_dendro since it''s not empty';
        -- end if;

        -- drop table if exists tbl_dendro_date_notes;
        -- drop table if exists tbl_dendro_dates;
        -- drop table if exists tbl_dendro;
        -- drop table if exists tbl_dendro_measurement_lookup;
        -- drop table if exists tbl_dendro_lookup;

        -- create table if not exists tbl_dendro_lookup (
        --     dendro_lookup_id serial primary key,
        --     method_id int4,
        --     name varchar collate "pg_catalog"."default" not null,
        --     description text collate "pg_catalog"."default",
        --     date_updated timestamp with time zone default now(),
        --     constraint "fk_dendro_lookup_method_id"
        --         foreign key ("method_id") references tbl_methods (method_id)
        --             on delete no action on update no action
        -- );

        -- create table if not exists  tbl_dendro (

        --     dendro_id serial primary key,
        --     analysis_entity_id integer not null,
        --     measurement_value character varying collate pg_catalog."default" not null,
        --     date_updated timestamp with time zone default now(),
        --     dendro_lookup_id integer not null,

        --     constraint fk_dendro_analysis_entity_id foreign key (analysis_entity_id)
        --         references public.tbl_analysis_entities (analysis_entity_id) match simple
        --         on update no action
        --         on delete no action,

        --     constraint fk_dendro_dendro_lookup_id foreign key (dendro_lookup_id)
        --         references public.tbl_dendro_lookup (dendro_lookup_id) match simple
        --         on update no action
        --         on delete no action
        -- );

        -- create table if not exists tbl_age_types (
        --     age_type_id serial primary key,
        --     age_type character varying(150) not null,
        --     description text,
        --     date_updated timestamp with time zone default now()
        -- );


        -- create table if not exists tbl_dendro_dates
        -- (
        --     dendro_date_id serial primary key,
        --     season_id integer,
        --     dating_uncertainty_id integer,
        --     dendro_lookup_id integer not null,
        --     age_type_id integer not null,
        --     analysis_entity_id integer not null,
        --     age_older integer,
        --     age_younger integer,
        --     date_updated timestamp with time zone default now(),
        --     constraint fk_dendro_dates_analysis_entity_id foreign key (analysis_entity_id)
        --         references public.tbl_analysis_entities (analysis_entity_id) match simple
        --         on update no action
        --         on delete no action,
        --     constraint fk_dendro_dates_dating_uncertainty_id foreign key (dating_uncertainty_id)
        --         references public.tbl_dating_uncertainty (dating_uncertainty_id) match simple
        --         on update no action
        --         on delete no action,
        --     constraint fk_dendro_lookup_dendro_lookup_id foreign key (dendro_lookup_id)
        --         references public.tbl_dendro_lookup (dendro_lookup_id) match simple
        --         on update no action
        --         on delete no action,
        --     constraint fk_tbl_age_types_age_type_id foreign key (age_type_id)
        --         references public.tbl_age_types (age_type_id) match simple
        --         on update no action
        --         on delete no action
        -- );

        -- create table public.tbl_dendro_date_notes
        -- (
        --     dendro_date_note_id serial primary key,
        --     dendro_date_id integer not null,
        --     note text collate pg_catalog."default",
        --     date_updated timestamp with time zone default now(),
        --     constraint fk_dendro_date_notes_dendro_date_id foreign key (dendro_date_id)
        --         references public.tbl_dendro_dates (dendro_date_id) match simple
        --         on update no action
        --         on delete no action
        -- );

        -- alter table tbl_dendro_lookup owner to "sead_master";
        -- alter table tbl_dendro owner to "sead_master";
        -- alter table tbl_dendro_dates owner to sead_master;
        -- alter table tbl_dendro_date_notes owner to sead_master;
        -- alter table tbl_age_types owner to sead_master;

        -- grant all on table tbl_dendro_dates to sead_read, mattias, postgres;
        -- grant select on table tbl_dendro_dates to humlab_read, johan;

        -- grant select on table tbl_dendro_date_notes to humlab_read, johan;
        -- grant all on table tbl_dendro_date_notes to mattias, postgres, sead_master, sead_read;

        -- grant all on table tbl_age_types
        --     to sead_read, humlab_admin, mattias, postgres;

        -- grant select on table tbl_age_types to humlab_read;

        -- comment on table tbl_dendro_lookup is 'type=lookup';

        -- comment on table public.tbl_dendro_dates
        --     is '20130722PIB: Added field dating_uncertainty_id to cater for >< etc.
        -- 20130722pib: prefixed fieldnames age_younger and age_older with "cal_" to conform with equivalent names in other tables';

    exception when sqlstate 'GUARD' then
        raise notice 'already executed';
    end;

end $$;
