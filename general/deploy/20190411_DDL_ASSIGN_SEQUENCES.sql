-- Deploy general: 20190411_DDL_ASSIGN_SEQUENCES

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

do $$
begin
    begin

        -- if (select count(*)
        --     from INFORMATION_SCHEMA.COLUMNS
        --     where table_schema = 'public'
        --       and table_name = 'tbl_species_association_types'
        --       and column_name = 'association_type_id'
        --       and column_default like 'nextval%') = 1
        -- then
        --     raise exception sqlstate 'GUARD';
        -- end if;

        perform sead_utility.set_as_serial('tbl_species_association_types', 'association_type_id');
        perform sead_utility.set_as_serial('tbl_sample_coordinates', 'sample_coordinate_id');
        perform sead_utility.set_as_serial('tbl_sample_location_type_sampling_contexts', 'sample_location_type_sampling_context_id');
        perform sead_utility.set_as_serial('tbl_project_stages', 'project_stage_id');

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
