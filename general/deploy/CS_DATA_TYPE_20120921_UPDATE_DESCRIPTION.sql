-- Deploy sead_change_control:CS_DATA_TYPE_20120921_UPDATE_DESCRIPTION to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-04-15
  Description   
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Revertable    No
  Notes
*****************************************************************************************************************/

begin;
do $$
begin

    begin
    
        update "public"."tbl_data_types"
            set "definition" = 'The element/fossil is present in the sample, but not quantified (numerical classification where 1 = presence)'
        where "data_type_id" = 6;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
