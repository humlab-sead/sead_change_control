-- Deploy utility: 20190411_DDL_UTILITY_ENABLE_TABLEFUNC
/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-04-11
  Description   Enable tablefunc
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

        create extension if not exists "tablefunc";

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
