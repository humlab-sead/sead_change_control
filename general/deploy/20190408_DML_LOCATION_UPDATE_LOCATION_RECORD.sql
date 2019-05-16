-- Deploy sead_db_change_control:CSD_20190408_UPDATE_LOCATION_3804 to pg

begin;

    Update public.tbl_locations
        Set location_name = 'Västra Ed' -- Was 'Flensburg'
    Where location_id = 3894;

commit;
