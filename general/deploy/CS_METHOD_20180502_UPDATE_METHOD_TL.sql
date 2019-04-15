-- Deploy sead_change_control:CS_METHOD_20140417_ADD_METHOD_GEOLPER to pg

/****************************************************************************************************************
  Author        
  Date          2019-05-02
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
    
        update "public"."tbl_methods"
            set "description" = 'Dating using the release of stored energy properties of (mainly sonte) material previously exposed to the sun.'
        where "method_id" = 150;
        
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
end $$;
commit;
