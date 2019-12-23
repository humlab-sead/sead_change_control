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

create or replace function bugs_import.post_import_updates() returns void language plpgsql
as $$
begin

    insert into tbl_sample_alt_refs (alt_ref, physical_sample_id, alt_ref_type_id)
    	select bugs_identifier, sead_reference_id, 12
    	from bugs_import.bugs_trace b
    	where bugs_table = 'TSample'
    	  on conflict (sample_alt_ref_id) do update
    	 	set alt_ref = excluded.alt_ref,
    			physical_sample_id = excluded.physical_sample_id;

    update tbl_ecocode_groups set ecocode_system_id = 3 where abbreviation = 'Eco';
    update tbl_ecocode_groups set ecocode_system_id = 3 where abbreviation = 'FCo';
    update tbl_ecocode_groups set ecocode_system_id = 3 where abbreviation = 'FDe';
    update tbl_ecocode_groups set ecocode_system_id = 3 where abbreviation = 'FNo';
    update tbl_ecocode_groups set ecocode_system_id = 3 where abbreviation = 'HRa';
    update tbl_ecocode_groups set ecocode_system_id = 3 where abbreviation = 'HTy';

end;
$$;

commit;
