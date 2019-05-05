-- Deploy bugs:CS_BUGS_20190503_ADD_TRANSLATIONS to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description   Verifies bugs:CS_BUGS_20190503_ADD_TRANSLATIONS
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin
    begin
        -- insert your DDL code here
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
end $$;
commit;
