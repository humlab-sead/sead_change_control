-- Deploy sead_change_control:20191221_DDL_UDF_BUGS_IMPORT_POST_APPLY to pg

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


    update tbl_ecocode_groups
        set ecocode_system_id = 3
            where abbreviation in ('Eco', 'FCo', 'FDe', 'FNo', 'HRa', 'HTy')
              and ecocode_system_id is null;

    update tbl_ecocode_definitions
        set ecocode_group_id = 2
            where ecocode_group_id is null;

    /* Make sure that each dataset has a submission type */
    insert into tbl_dataset_submissions (dataset_id, submission_type_id, contact_id, date_submitted, notes)
    	select d.dataset_id, 5, 1, d.date_updated, 'Single dataset from another database submission into SEAD'
    	from tbl_datasets d
    	left join tbl_dataset_submissions s using (dataset_id)
    	where TRUE
    	  and s.dataset_submission_id is null
    	  and d.master_set_id = 1;

    /* Add alt. refs. bot imported by the Bugs import system */
    insert into tbl_sample_alt_refs (alt_ref, physical_sample_id, alt_ref_type_id, date_updated)
        select bugs_identifier, sead_reference_id, 12, '2019-12-22 13:15:56.363305+00'
        from bugs_import.bugs_trace b
        left join tbl_sample_alt_refs x
          on x.alt_ref = bugs_identifier
         and x.physical_sample_id = physical_sample_id
        where TRUE
         and b.bugs_table = 'TSample'
         and x.alt_ref is null;

end;
$$;

commit;
