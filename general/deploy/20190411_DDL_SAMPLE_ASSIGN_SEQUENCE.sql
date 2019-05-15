-- Deploy sead_change_control:CS_SAMPLE__20190411_ASSIGN_SEQUENCE to pg

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

    perform sead_utility.set_as_serial('tbl_sample_location_type_sampling_contexts', 'sample_location_type_sampling_context_id');
    
end $$;
