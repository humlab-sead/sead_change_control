-- Deploy dendrochronology: 20190408_DML_UPDATE_LOCATION_RECORD

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

    if not exists (select 1 from public.tbl_locations where location_id = 3894) then
        raise exception 'Location 3894 does not exist';
    end if;

    -- FIXME: #165 Updates by serial identity should be prohibited
    Update public.tbl_locations
        Set location_name = 'Västra Ed' -- Was 'Flensburg'
    Where location_id = 3894;

end $$ language plpgsql;
commit;
