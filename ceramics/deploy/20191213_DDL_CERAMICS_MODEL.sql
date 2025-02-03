-- Deploy ceramics: 20191213_DDL_CERAMICS_MODEL

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-12-13
  Description   Creates ceramic data model
  Issue         https://github.com/humlab-sead/sead_change_control/issues/196
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;

do $$
begin

    if exists (select 1 from pg_catalog.pg_tables where schemaname='public' and tablename = 'tbl_ceramics_lookup') then
        drop table public.tbl_ceramics_lookup;
    end if;

    create table if not exists tbl_ceramics_lookup
    (
        ceramics_lookup_id serial primary key,
        method_id integer NOT NULL,
        description text COLLATE pg_catalog."default",
        name character varying COLLATE pg_catalog."default" NOT NULL,
        date_updated timestamp with time zone default now(),
        constraint fk_ceramics_lookup_method_id foreign key (method_id)
            references tbl_methods (method_id) match simple
            on update no action
            on delete no action
    );

    alter table tbl_ceramics_lookup owner to sead_master;

    grant all    on table tbl_ceramics_lookup to sead_master;
    grant select on table tbl_ceramics_lookup to humlab_read, clearinghouse_worker, mattias, public, anonymous_rest_user;

    comment on table tbl_ceramics_lookup IS 'Type=lookup';


    drop table if exists tbl_ceramics;

    create table tbl_ceramics
    (
        ceramics_id serial primary key,
        analysis_entity_id integer not null,
        measurement_value character varying collate pg_catalog."default" not null,
        date_updated timestamp with time zone default now(),
        ceramics_lookup_id integer not null,

        constraint fk_ceramics_analysis_entity_id foreign key (analysis_entity_id)
            references public.tbl_analysis_entities (analysis_entity_id) match simple
            on update no action
            on delete no action,
        constraint fk_ceramics_ceramics_lookup_id foreign key (ceramics_lookup_id)
            references public.tbl_ceramics_lookup (ceramics_lookup_id) match simple
            on update no action
            on delete no action
    );

    alter table tbl_ceramics owner to sead_master;

    grant all    on table tbl_ceramics to sead_master;
    grant select on table tbl_ceramics to humlab_read, clearinghouse_worker, mattias, public, anonymous_rest_user;

    drop table if exists "public"."tbl_ceramics_measurement_lookup";

end $$;
commit;
