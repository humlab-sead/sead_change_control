-- Deploy bugs: 20191212_DML_UPDATE_SAMPLE_ALT_REFS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-12-12
  Description   Insert 'Bugs sample code' record into tbl_alt_ref_types.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/194
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

        insert into tbl_alt_ref_types (alt_ref_type_id, alt_ref_type, description, date_updated)
        	values (12, 'Bugs sample code', 'Unique identifier for (physical) samples in the BugsCEP database', '2019-12-20 13:45:51.878824+00')
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
