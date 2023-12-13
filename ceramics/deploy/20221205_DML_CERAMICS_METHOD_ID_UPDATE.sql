-- Deploy submissions: 20221205_DML_CERAMICS_METHOD_ID_UPDATE

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

        update tbl_ceramics_lookup set method_id = 171 where method_id = 70;
        update tbl_ceramics_lookup set method_id = 172 where method_id = 71;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
