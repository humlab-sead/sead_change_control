-- Deploy sead_change_control:20191212_DML_UPDATE_SAMPLE_ALT_REFS to pg

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

    begin

        insert into tbl_alt_ref_types (alt_ref_type_id, alt_ref_type, description)
        	values (12, 'Bugs sample code', 'Unique identifier for (physical) samples in the BugsCEP database')
                on conflict do nothing;

        -- insert into tbl_sample_alt_refs (alt_ref, physical_sample_id, alt_ref_type_id)
        -- 	select bugs_identifier, sead_reference_id, 12
        -- 	from bugs_import.bugs_trace b
        -- 	where bugs_table = 'TSample'
        -- 	  on conflict (sample_alt_ref_id) do update
        -- 	 	set alt_ref = excluded.alt_ref,
        -- 			physical_sample_id = excluded.physical_sample_id;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
