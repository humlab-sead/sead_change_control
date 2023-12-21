-- Deploy general: 20190410_DDL_RELATIVE_DATING_RENAME_COLUMN

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-04-10
  Description   Rename column from abbreviation
  Issue         https://github.com/humlab-sead/sead_change_control/issues/176
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin
    set client_min_messages to warning;

    if sead_utility.column_exists('public'::text, 'tbl_relative_ages'::text, 'Abbreviation'::text) = TRUE then
        alter table tbl_relative_ages rename column "Abbreviation" to "abbreviation";
        comment on column "public"."tbl_relative_ages"."abbreviation" is 'Standard abbreviated form of name if available';
    end if;

end $$;
commit;
