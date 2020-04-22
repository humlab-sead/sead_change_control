-- Deploy sead_change_control:20191222_DML_DATASET_SUBMISSION_UPDATE to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
        BugsData:   submission_type: 5  contact_id: Phil submitted_data: (date_updated from dataset)
        MAL_Data:   submission_type: 7 (om Eriks client) contact_id: Phil submitted_data: (date_updated from dataset)

        Iso_Data:   submission_type: 14 contact_id: Phil submitted_data: (date_updated from dataset)
        Dendro:     submission_type: 14 / Compilation into SEAD from another database
        Ceramic:    submission_type: 14 / Compilation into SEAD from another database
        Pollen:     submission_type: 15 / Compilation into SEAD from another database

        -- Ny submission_type: 13, Compilation into SEAD via (articles + Excel) => Excel => XML => CH => SEAD
        -- Ny submission_type: 14, Compilation into SEAD via external DB (excel) => Excel => XML => CH => SEAD
        -- Ny submission_type: 15, Compilation into SEAD via external TILIA => XML => (Excel) => XML => CH => SEAD
*****************************************************************************************************************/
-- Deploy sead_change_control:20191222_DML_DATASET_SUBMISSION_UPDATE to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
        BugsData:   submission_type: 5  contact_id: Phil submitted_data: (date_updated from dataset)
        MAL_Data:   submission_type: 7 (om Eriks client) contact_id: Phil submitted_data: (date_updated from dataset)

        Iso_Data:   submission_type: 14 contact_id: Phil submitted_data: (date_updated from dataset)
        Dendro:     submission_type: 14 / Compilation into SEAD from another database
        Ceramic:    submission_type: 14 / Compilation into SEAD from another database
        Pollen:     submission_type: 15 / Compilation into SEAD from another database

        -- Ny submission_type: 13, Compilation into SEAD via (articles + Excel) => Excel => XML => CH => SEAD
        -- Ny submission_type: 14, Compilation into SEAD via external DB (excel) => Excel => XML => CH => SEAD
        -- Ny submission_type: 15, Compilation into SEAD via external TILIA => XML => (Excel) => XML => CH => SEAD
*****************************************************************************************************************/

begin;
do $$
begin

    begin

        -- if sead_utility.column_exists('public'::text, 'table_name'::text, 'column_name'::text) = TRUE then
        --     raise exception SQLSTATE 'GUARD';
        -- end if;

        insert into public.tbl_dataset_submission_types(submission_type_id, submission_type, description)
	        values
                (13, 'Compilation into sead via (articles + excel)', 'Compilation into sead via (articles + excel) => excel => xml => ch => sead'),
                (14, 'Compilation into sead via (articles + excel)', 'Compilation into SEAD via external DB (excel) => Excel => XML => CH => SEAD'),
                (15, 'Compilation into sead via (articles + excel)', 'Compilation into SEAD via external TILIA => XML => (Excel) => XML => CH => SEAD')
            on conflict (submission_type_id)
                do update
                    set submission_type = excluded.submission_type,
                        description = excluded.description;

        /* Bugs update */
        insert into tbl_dataset_submissions (dataset_id, submission_type_id, contact_id, date_submitted, notes)
        	select d.dataset_id, 5, 1, d.date_updated, 'Single dataset from another database submission into SEAD'
        	from tbl_datasets d
        	left join tbl_dataset_submissions s using (dataset_id)
        	where TRUE
        	  and s.dataset_submission_id is null
        	  and d.master_set_id = 1;

        /* Ceramics, Dendro, Isotope */
        insert into tbl_dataset_submissions (dataset_id, submission_type_id, contact_id, date_submitted, notes)
        	select d.dataset_id, 14, 1, d.date_updated, 'Single dataset from another database submission into SEAD'
        	from tbl_datasets d
        	left join tbl_dataset_submissions s using (dataset_id)
        	where TRUE
        	  and s.dataset_submission_id is null
        	  and d.master_set_id in (3, 10, 11);

        /* MAL, Eriks klient */
        insert into tbl_dataset_submissions (dataset_id, submission_type_id, contact_id, date_submitted, notes)
        	select d.dataset_id, 7, 1, d.date_updated, 'Compilation into SEAD from primary source using Eriks Erikssons software'
        	from tbl_datasets d
        	left join tbl_dataset_submissions s using (dataset_id)
        	where TRUE
        	  and s.dataset_submission_id is null
        	  and d.master_set_id in (2)
              and d.method_id <> 14;

        /* Pollen */
        insert into tbl_dataset_submissions (dataset_id, submission_type_id, contact_id, date_submitted, notes)
        	select d.dataset_id, 15, 1, d.date_updated, 'Single dataset from another database submission into SEAD via Tilia software'
        	from tbl_datasets d
        	left join tbl_dataset_submissions s using (dataset_id)
        	where TRUE
        	  and s.dataset_submission_id is null
        	  and d.master_set_id in (2)
              and d.method_id = 14;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
 