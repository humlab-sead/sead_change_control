-- Revert sead_db_change_control:CSD_20190408_UPDATE_LOCATION_3804 from pg

BEGIN;

    -- Update public.tbl_locations
    --     Set location_name = 'Flensburg'
    -- Where location_id = 3894;


COMMIT;
