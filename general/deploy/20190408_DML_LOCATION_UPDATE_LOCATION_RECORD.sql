-- Deploy sead_db_change_control:CSD_20190408_UPDATE_LOCATION_3804 to pg

begin;

    if not exists (select 1 from public.tbl_locations where location_id = 3804) then
        raise exception 'Location 3804 does not exist';
    end if;

    -- FIXME: #165 Updates by serial identity should be prohibited
    Update public.tbl_locations
        Set location_name = 'Västra Ed' -- Was 'Flensburg'
    Where location_id = 3894;

commit;
