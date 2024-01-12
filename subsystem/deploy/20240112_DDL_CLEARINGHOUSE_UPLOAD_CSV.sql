-- Deploy subsystem: 202401012_DDL_CLEARINGHOUSE_UPLOAD_CSV

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-01-01
  Description   Added alternative upload of XML using CSV. Related to https://github.com/humlab-sead/sead_clearinghouse_import/issues/27
  Issue         https://github.com/humlab-sead/sead_change_control/issues/230
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
