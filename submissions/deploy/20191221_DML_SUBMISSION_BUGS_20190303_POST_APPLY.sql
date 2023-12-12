-- Deploy submissions: 20191221_DML_SUBMISSION_BUGS_20190303_POST_APPLY

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
