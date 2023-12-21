-- Deploy general: 20170911_DDL_CHRONOLOGIES_REFACTOR_MODEL

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2017-09-11
  Issue         https://github.com/humlab-sead/sead_change_control/issues/168: https://github.com/humlab-sead/sead_change_control/issues/150
  Description   Allow relation to multiple sample groups
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

            if sead_utility.column_exists('public'::text, 'tbl_chronologies'::text, 'relative_age_type_id'::text) = true then
                raise exception sqlstate 'GUARD';
            end if;

            alter table tbl_chronologies
                alter column "age_model" type varchar(255) collate "pg_catalog"."default",
                alter column "chronology_name" type varchar(255) collate "pg_catalog"."default",
                alter column "sample_group_id" drop not null,
                add column "relative_age_type_id" int4,
                drop column "age_type_id";

            comment on column "public"."tbl_chronologies"."relative_age_type_id" IS 'Constraint removed to obsolete table (tbl_age_types), replaced by non-binding id of relative_age_types - but not fully implemented. Notes should be used to inform on chronology years types and construction.';
            comment on table "public"."tbl_chronologies" IS '20170911PIB: Removed Not Null requirement for sample-group_id to allow for chronologies not tied to a single sample group (e.e. calibrated ages for DataArc or other projects)
Increased length of some fields.
20120504PIB: Note that the dropped age type recorded the type of dates (C14 etc) used in constructing the chronology... but is only one per chonology enough? Can a chronology not be made up of mulitple types of age? (No, years types can only be of one sort - need to calibrate if mixed?)';

        exception when sqlstate 'GUARD' THEN
            raise notice 'already executed';
        end;

    end $$ language plpgsql;

commit;
