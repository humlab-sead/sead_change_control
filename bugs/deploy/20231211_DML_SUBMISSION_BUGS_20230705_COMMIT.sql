-- Deploy bugs: 20231211_DML_SUBMISSION_BUGS_20230705_COMMIT

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2023-12-11
  Description   Full (inital) non-incremental import of BugsCEP data version 20230705.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/162
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
