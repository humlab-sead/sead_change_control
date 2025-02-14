-- Deploy utility: 20190407_DDL_UTILITY_ADD_UUID_SUPPORT
/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-04-07
  Description   Add UUID extension
  Issue        
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
*****************************************************************************************************************/
begin;

-- https://stackoverflow.com/questions/31247735/how-to-create-guid-in-postgresql

create extension if not exists "uuid-ossp" schema public;

commit;
