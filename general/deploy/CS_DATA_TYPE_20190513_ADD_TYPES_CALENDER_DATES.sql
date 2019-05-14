-- Deploy sead_change_control:CS_DATA_TYPE_20190513_ADD_TYPES_CALENDER_DATES to pg

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
    
        -- insert your DDL code here
        WITH new_data_types (data_type_id, data_type_group_id, data_type_name, definition) AS (VALUES
            (16, 8, 'Calendar dates', 'Sample ages calibrated to calendar dates')
        ) INSERT INTO tbl_data_types (data_type_id, data_type_group_id, data_type_name, definition)
          SELECT a.data_type_id, a.data_type_group_id, a.data_type_name, a.definition
          FROM new_data_types a
          LEFT JOIN tbl_data_types b
            ON a.data_type_id = b.data_type_id
          WHERE b.data_type_id IS NULL;
  
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
