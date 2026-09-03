-- Deploy dendrochronology: 20260101_DML_GBG_STH_LIVING_TREES_COMMIT

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2026-01-01
  Description   This data submission holds the dendrochronological data from living trees at the Gothenburg and Stockholm labs.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/339
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
    
        if sead_utility.column_exists('public'::text, 'table_name'::text, 'column_name'::text) = TRUE then
            raise exception SQLSTATE 'GUARD';
        end if;
        
        -- insert your DDL code here
        
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
