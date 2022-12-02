-- Deploy sead_change_control:20191212_DML_UPDATE_SAMPLE_ALT_REFS to pg

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

    perform bugs_import.post_import_updates();

end $$;
commit;