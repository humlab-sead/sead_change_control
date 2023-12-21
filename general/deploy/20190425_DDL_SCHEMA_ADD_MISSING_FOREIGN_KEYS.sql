-- Deploy general: 20190425_DDL_SCHEMA_ADD_MISSING_FOREIGN_KEYS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-04-25
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

        raise notice 'NOT IMPLEMENTED';

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
