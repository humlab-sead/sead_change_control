-- Deploy isotope: 20260101_DML_GLYKOU_CARBON_COMMIT

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2026-01-01
  Description   Glykou et.al 2021 Carbon dataset
  Issue         https://github.com/humlab-sead/sead_change_control/issues/442
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
