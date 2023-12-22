-- Deploy utility: 20190411_DDL_UTILITY_ENABLE_PGCRYPTO
/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-04-11
  Description   Enable pgcrypt
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
