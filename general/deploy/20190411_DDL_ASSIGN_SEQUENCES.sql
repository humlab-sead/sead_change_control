-- Deploy general: 20190411_DDL_ASSIGN_SEQUENCES

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-04-11
  Description   Assign sequence as default
  Issue         https://github.com/humlab-sead/sead_change_control/issues/177
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

do $$
begin
    begin

        perform sead_utility.set_as_serial('tbl_species_association_types', 'association_type_id');
        perform sead_utility.set_as_serial('tbl_sample_coordinates', 'sample_coordinate_id');
        perform sead_utility.set_as_serial('tbl_sample_location_type_sampling_contexts', 'sample_location_type_sampling_context_id');
        perform sead_utility.set_as_serial('tbl_project_stages', 'project_stage_id');

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
