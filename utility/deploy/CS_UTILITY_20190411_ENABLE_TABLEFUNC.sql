-- Deploy utility:CS_UTILITY_20190411_ENABLE_TABLEFUNC to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-04-11
  Description   Enables crosstabs etc.
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
    
        create extension if not exists "table_func";
        
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
