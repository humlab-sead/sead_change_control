-- Deploy dendrochronology: 20221121_DML_DENDRO_ADD_ANALYSIS_METHODS
/****************************************************************************************************************
  Author        Roger Mähler
  Date          2022-11-21
  Description   Add analysis methods for dendro humlab-sead/sead_general_database/#4
  Issue         https://github.com/humlab-sead/sead_change_control/issues/141
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
