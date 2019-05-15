-- Deploy sead_db_change_control:CSR_20180521_ADD_DENDROCHRONOLOGY_DATING to pg


begin;

do $$
begin
	begin
    
        if sead_utility.table_exists('public'::text, 'tbl_age_types'::text) = TRUE THEN
            RAISE EXCEPTION SQLSTATE 'GUARD';
        end if;
        
        drop view if exists postgrest_default_api.dendro_date;
        drop view if exists clearing_house.view_dendro_dates;

        create table if not exists public.tbl_age_types (
            age_type_id serial primary key,
            age_type character varying(150) not null,
            description text,
            date_updated timestamp with time zone default now()
        );

        create table if not exists public.tbl_error_uncertainties (
            error_uncertainty_id serial primary key,
            error_uncertainty_type character varying(150) not null,
            description text,
            date_updated timestamp with time zone default now()
        );

        create table if not exists public.tbl_season_or_qualifier (
            season_or_qualifier_id serial primary key,
            season_or_qualifier_type character varying(150) not null,
            description text,
            date_updated timestamp with time zone default now()
        );
        
        if (select count(*) from public.tbl_dendro_dates) > 0 then
            raise exception 'Cannot delete tbl_dendro_dates since it''s not empty';
        end if;
        
        drop table if exists public.tbl_dendro_date_notes;
        drop table if exists public.tbl_dendro_dates;
        
        create table if not exists public.tbl_dendro_dates
        (
            dendro_date_id serial primary key,
            analysis_entity_id integer not null,
            age_older integer,
            age_younger integer,
            dating_uncertainty_id integer,
            season_or_qualifier_id integer,
            date_updated timestamp with time zone default now(),
            error_plus integer,
            error_minus integer,
            dendro_lookup_id integer not null,
            error_uncertainty_id integer,
            age_type_id integer not null,
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
                on delete no action,
            constraint fk_tbl_error_uncertainties_error_uncertainty_id foreign key (error_uncertainty_id)
                references public.tbl_error_uncertainties (error_uncertainty_id) match simple
                on update no action
                on delete no action
        );

        create table public.tbl_dendro_date_notes
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

        comment on table public.tbl_dendro_dates
            IS '20130722PIB: Added field dating_uncertainty_id to cater for >< etc.
        20130722pib: prefixed fieldnames age_younger and age_older with "cal_" to conform with equivalent names in other tables';

        alter table public.tbl_dendro_dates owner to sead_master;
        alter table public.tbl_dendro_date_notes owner to sead_master;
        alter table public.tbl_age_types owner to sead_master;
        alter table public.tbl_error_uncertainties owner to sead_master;
        alter table public.tbl_season_or_qualifier owner to sead_master;

        grant all on table public.tbl_dendro_dates to sead_read, mattias, postgres;
        grant select on table public.tbl_dendro_dates to humlab_read, johan;
        
        grant select on table public.tbl_dendro_date_notes to humlab_read, johan;
        grant all on table public.tbl_dendro_date_notes to mattias, postgres, sead_master, sead_read;

        grant all on table public.tbl_age_types, public.tbl_error_uncertainties, public.tbl_season_or_qualifier
            to sead_read, humlab_admin, mattias, postgres;

        grant select on table public.tbl_age_types, public.tbl_error_uncertainties, public.tbl_season_or_qualifier to humlab_read;

        RAISE NOTICE 'Please re-create: postgrest_default_api.dendro_date';
        RAISE NOTICE 'Please re-create: clearing_house.view_dendro_dates;';
        
    EXCEPTION WHEN SQLSTATE 'GUARD' THEN
        RAISE NOTICE 'ALREADY EXECUTED';
    END;
    
end $$;

commit;

