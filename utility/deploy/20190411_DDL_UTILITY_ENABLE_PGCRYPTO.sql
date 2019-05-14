-- Deploy utility:CS_UTILITY_20190411_ENABLE_PGCRYPTO to pg

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
    
        create extension if not exists "pgcrypto";
        
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
