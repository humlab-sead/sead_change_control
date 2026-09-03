-- Deploy dendrochronology: 20250107_DML_LUND_ARCHAELOGICAL_DATA_20200630_COMMIT

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2025-01-07
  Description   This dataset is the 20200630 submission of archaeological data from the Lund dendro lab. The pilot data from the VISEAD project is not part of this import.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/341
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
