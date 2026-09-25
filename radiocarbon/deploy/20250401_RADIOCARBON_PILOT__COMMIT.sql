-- Deploy radiocarbon: 20250401_RADIOCARBON_PILOT__COMMIT

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2025-04-01
  Description   Radiocarbon pilot data
  Issue         https://github.com/humlab-sead/sead_change_control/issues/370
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
