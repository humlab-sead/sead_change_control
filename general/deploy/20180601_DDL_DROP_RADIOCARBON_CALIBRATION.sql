-- Deploy sead_db_change_control:CS_DEPRECATE_20180601_DROP_RADIOCARBON_CALIBRATION to pg

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
        if sead_utility.table_exists('public'::text, 'tbl_radiocarbon_calibration'::text) = FALSE THEN
             raise exception SQLSTATE 'GUARD';
        end if;
            
        drop table if exists "public"."tbl_radiocarbon_calibration";
        
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
