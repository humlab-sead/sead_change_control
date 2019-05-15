-- Deploy sead_db_change_control:CSR_20190408_REFACTOR_SAMPLE_COORDINATES to pg

do $$
begin

    perform sead_utility.set_as_serial('tbl_sample_coordinates', 'sample_coordinate_id');
    
end $$ language plpgsql;
