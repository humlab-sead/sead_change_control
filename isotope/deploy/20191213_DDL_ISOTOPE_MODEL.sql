-- Deploy isotope: 20191213_DDL_ISOTOPE_MODEL

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-12-13
  Description   Creates Isotope data model
  Issue         https://github.com/humlab-sead/sead_change_control/issues/14
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;

do $$
begin
	begin

        if sead_utility.table_exists('public'::text, 'tbl_isotope_standards'::text) = FALSE THEN

            create table if not exists public.tbl_isotope_standards
            (
                isotope_standard_id serial primary key,
                isotope_ration character varying NULL,
                international_scale character varying NULL,
                accepted_ratio_xe6 character varying NULL,
                error_of_ratio character varying NULL,
                reference character varying NULL,
                date_updated timestamp with time zone default now()
            );

        end if;

        if sead_utility.table_exists('public'::text, 'tbl_isotope_types'::text) = FALSE THEN

            create table if not exists public.tbl_isotope_types
            (
                isotope_type_id serial primary key,
                designation character varying NULL,
                abbreviation character varying NULL,
                atomic_number numeric NULL,
                description text NULL,
                alternative_designation character varying NULL,
                date_updated timestamp with time zone default now()
            );
        end if;

        if sead_utility.table_exists('public'::text, 'tbl_isotope_measurements'::text) = FALSE THEN

            create table if not exists public.tbl_isotope_measurements
            (
                isotope_measurement_id serial primary key,
                isotope_standard_id integer NULL,
                method_id integer NULL,
                isotope_type_id integer NULL,
                date_updated timestamp with time zone default now(),

                constraint fk_isotope_measurements_isotope_standard_id foreign key (isotope_standard_id)
                    references public.tbl_isotope_standards (isotope_standard_id) match simple
                    on update no action
                    on delete no action,

                constraint fk_isotope_isotope_type_id foreign key (isotope_type_id)
                    references public.tbl_isotope_types (isotope_type_id) match simple
                    on update no action
                    on delete no action,

                constraint fk_isotope_method_id foreign key (method_id)
                    references public.tbl_methods (method_id) match simple
                    on update no action
                    on delete no action
            );

        end if;

        create table if not exists public.tbl_isotope_value_specifiers
        (
            isotope_value_specifier_id int primary key not null,
            name character varying not null,
            description text not null,
            date_updated timestamp with time zone default now()
        );

        if sead_utility.table_exists('public'::text, 'tbl_isotopes'::text) = FALSE THEN

            create table if not exists public.tbl_isotopes
            (
                isotope_id serial primary key,
                analysis_entity_id integer NOT NULL,
                isotope_measurement_id integer NOT NULL,
                isotope_standard_id integer NULL,
                measurement_value text NULL,
                unit_id int not NULL,
                isotope_value_specifier_id int not NULL,
                date_updated timestamp with time zone default now(),

                constraint fk_isotopes_analysis_entity_id foreign key (analysis_entity_id)
                    references public.tbl_analysis_entities (analysis_entity_id) match simple
                    on update no action
                    on delete no action,

                constraint fk_isotopes_isotope_standard_id foreign key (isotope_standard_id)
                    references public.tbl_isotope_standards (isotope_standard_id) match simple
                    on update no action
                    on delete no action,

                constraint fk_isotopes_isotope_measurement_id foreign key (isotope_measurement_id)
                    references public.tbl_isotope_measurements (isotope_measurement_id) match simple
                    on update no action
                    on delete no action,

                constraint fk_isotopes_unit_id foreign key (unit_id)
                    references public.tbl_units (unit_id) match simple
                    on update no action
                    on delete no action,

                constraint fk_isotopes_isotope_value_specifier_id foreign key (isotope_value_specifier_id)
                    references public.tbl_isotope_value_specifiers (isotope_value_specifier_id) match simple
                    on update no action
                    on delete no action
            );
        end if;

        alter table public.tbl_isotope_standards owner to sead_master;
        alter table public.tbl_isotopes owner to sead_master;
        alter table public.tbl_isotope_types owner to sead_master;
        alter table public.tbl_isotope_measurements owner to sead_master;
        alter table public.tbl_isotope_value_specifiers owner to sead_master;

        grant select on table public.tbl_isotope_standards, public.tbl_isotopes, public.tbl_isotope_types, public.tbl_isotope_measurements
            to humlab_read, clearinghouse_worker, sead_read;

        comment on table tbl_isotope_standards IS 'Type=lookup';
        comment on table tbl_isotope_types IS 'Type=lookup';

    exception when SQLSTATE 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;

commit;
