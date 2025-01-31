-- Deploy dendrochronology: 20231120_DML_DENDRO_MODEL
/****************************************************************************************************************
  Author        Roger Mähler
  Date          2023-11-20
  Issue         https://github.com/humlab-sead/sead_change_control/issues/135
  Description   Update of 20191213_DDL_DENDRO_MODEL
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes         This script assumes that all dendro data has been removed from the database.
                This script is a part of the solution to the issue #135.
                20250131: Backported script to SEAD model and made it idempotent.
*****************************************************************************************************************/


begin;

do $$
begin
	begin
        set role sead_master;

        if sead_utility.table_exists('public'::text, 'tbl_dendro_lookup'::text) = true then
            raise exception sqlstate 'GUARD';
        end if;

        if (select count(*) from public.tbl_dendro) > 0 then
            raise exception 'Cannot delete tbl_dendro since it''s not empty';
        end if;

        drop table if exists tbl_dendro_date_notes;
        drop table if exists tbl_dendro_dates;
        drop table if exists tbl_dendro;
        drop table if exists tbl_dendro_measurement_lookup;
        drop table if exists tbl_dendro_lookup;

        create table if not exists tbl_dendro_lookup (
            dendro_lookup_id serial primary key,
            method_id int4,
            name varchar collate "pg_catalog"."default" not null,
            description text collate "pg_catalog"."default",
            date_updated timestamp with time zone default now(),
            constraint "fk_dendro_lookup_method_id"
                foreign key ("method_id") references tbl_methods (method_id)
                    on delete no action on update no action
        );

        create table if not exists  tbl_dendro (

            dendro_id serial primary key,
            analysis_entity_id integer not null,
            measurement_value character varying collate pg_catalog."default" not null,
            date_updated timestamp with time zone default now(),
            dendro_lookup_id integer not null,

            constraint fk_dendro_analysis_entity_id foreign key (analysis_entity_id)
                references public.tbl_analysis_entities (analysis_entity_id) match simple
                on update no action
                on delete no action,

            constraint fk_dendro_dendro_lookup_id foreign key (dendro_lookup_id)
                references public.tbl_dendro_lookup (dendro_lookup_id) match simple
                on update no action
                on delete no action
        );

        create table if not exists tbl_age_types (
            age_type_id serial primary key,
            age_type character varying(150) not null,
            description text,
            date_updated timestamp with time zone default now()
        );


        create table if not exists tbl_dendro_dates
        (
            dendro_date_id serial primary key,
            season_id integer,
            dating_uncertainty_id integer,
            dendro_lookup_id integer not null,
            age_type_id integer not null,
            analysis_entity_id integer not null,
            age_older integer null,
            age_younger integer null,
            date_updated timestamp with time zone default now(),
            constraint fk_dendro_dates_season_id foreign key (season_id)
                references public.tbl_seasons (season_id) match simple
                on update no action
                on delete no action,
            constraint fk_dendro_dates_analysis_entity_id foreign key (analysis_entity_id)
                references public.tbl_analysis_entities (analysis_entity_id) match simple
                on update no action
                on delete no action,
            constraint fk_dendro_dates_dating_uncertainty_id foreign key (dating_uncertainty_id)
                references public.tbl_dating_uncertainty (dating_uncertainty_id) match simple
                on update no action
                on delete no action,
            constraint fk_dendro_lookup_dendro_lookup_id foreign key (dendro_lookup_id)
                references public.tbl_dendro_lookup (dendro_lookup_id) match simple
                on update no action
                on delete no action,
            constraint fk_tbl_age_types_age_type_id foreign key (age_type_id)
                references public.tbl_age_types (age_type_id) match simple
                on update no action
                on delete no action
        );

        create table if not exists tbl_dendro_date_notes
        (
            dendro_date_note_id serial primary key,
            dendro_date_id integer not null,
            note text collate pg_catalog."default",
            date_updated timestamp with time zone default now(),
            constraint fk_dendro_date_notes_dendro_date_id foreign key (dendro_date_id)
                references public.tbl_dendro_dates (dendro_date_id) match simple
                on update no action
                on delete no action
        );
        
        --call sead_utility.set_schema_privilege('sead_utility', 'sead_read', 'read', 'humlab_admin', 'sead_master');

        grant all on table tbl_dendro_dates to sead_read, postgres;
        grant select on table tbl_dendro_dates to humlab_read;

        grant select on table tbl_dendro_date_notes to humlab_read;
        grant all on table tbl_dendro_date_notes to postgres, sead_read;

        grant all on table tbl_age_types to sead_read, humlab_admin, postgres;

        grant select on table tbl_age_types to humlab_read;

        comment on table tbl_dendro_lookup is 'type=lookup';

        comment on table public.tbl_dendro_dates
            is '20130722PIB: Added field dating_uncertainty_id to cater for >< etc.
        20130722pib: prefixed fieldnames age_younger and age_older with "cal_" to conform with equivalent names in other tables';
        reset role;
        
    exception when sqlstate 'GUARD' then
        raise notice 'already executed';
    end;

end $$;

commit;
