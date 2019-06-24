-- Deploy sead_db_change_control:CSR_20190408_CREATE_TABLE_CERAMICS_LOOKUP to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description
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

        if sead_utility.table_exists('public'::text, 'tbl_ceramics_lookup'::text) = FALSE THEN

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
            grant select on table tbl_ceramics_lookup to humlab_read, clearinghouse_worker, mattias;

            comment on table tbl_ceramics_lookup IS 'Type=lookup';

        end if;

        if sead_utility.column_exists('public'::text, 'tbl_ceramics'::text, 'ceramics_lookup_id'::text) = FALSE THEN

            alter table tbl_ceramics
                drop constraint if exists "fk_ceramics_ceramics_measurement_id",
                add column "ceramics_lookup_id" int4 not null,
                drop column if exists  "ceramics_measurement_id",
                add constraint "fk_ceramics_ceramics_lookup_id" foreign key ("ceramics_lookup_id")
                    references tbl_ceramics_lookup (ceramics_lookup_id)
                    on delete no action on update no action;

            drop table if exists "public"."tbl_ceramics_measurement_lookup";

        end if;

    exception when SQLSTATE 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;

commit;
