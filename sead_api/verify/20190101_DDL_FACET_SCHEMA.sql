-- Verify sead_api: 20190101_DDL_FACET_SCHEMA
-- Deploy sead_api:20190101_DDL_FACET_SCHEMA to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description   Verifies sead_api:20190101_DDL_FACET_SCHEMA
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
