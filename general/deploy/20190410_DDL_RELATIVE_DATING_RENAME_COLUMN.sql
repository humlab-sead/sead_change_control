-- Deploy sead_change_control:CS_RELATIVE_DATING_20190410_RENAME_COLUMN to pg

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

        set client_min_messages to warning;

        if sead_utility.column_exists('public'::text, 'tbl_relative_ages'::text, 'abbreviation'::text) = TRUE then
            raise exception SQLSTATE 'GUARD';
        end if;

        alter table tbl_relative_ages rename column "Abbreviation" to "abbreviation";

        comment on column "public"."tbl_relative_ages"."abbreviation" is 'Standard abbreviated form of name if available';

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
