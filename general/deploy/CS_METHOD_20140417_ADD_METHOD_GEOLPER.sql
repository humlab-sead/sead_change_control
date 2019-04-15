-- Deploy sead_change_control:CS_METHOD_20140417_ADD_METHOD_GEOLPER to pg

/****************************************************************************************************************
  Author        
  Date          2019-05-02
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
    
        if (select count(*) from "public"."tbl_methods" where method_id = 156) > 0 then
            raise exception SQLSTATE 'GUARD';
        end if;
        
        insert into "public"."tbl_methods"("method_id", "biblio_id", "date_updated", "description", "method_abbrev_or_alt_name", "method_group_id", "method_name", "record_type_id", "unit_id")
            values (156, NULL, '2018-05-02 14:13:47.999285+02', 'Age determined to geological period using undefined (or possibly multiple) method(s).', 'GeolPer', 19, 'Geological period (unspecified)', NULL, NULL);
        
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
