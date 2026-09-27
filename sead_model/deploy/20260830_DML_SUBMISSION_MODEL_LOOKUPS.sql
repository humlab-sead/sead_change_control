-- Deploy sead_model: 20260830_DML_SUBMISSION_MODEL_LOOKUPS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2026-08-30
  Description   Improved design of SEAD schema for handling data submissions and related data
  Issue         https://github.com/humlab-sead/sead_change_control/issues/440
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes         Add lookup data for submission model.
*****************************************************************************************************************/

set client_encoding = 'UTF8';
set client_min_messages = warning;

begin;
do $$
begin

    begin

        if (select count(*) from tbl_submission_states) > 0 then
            raise exception SQLSTATE 'GUARD';
        end if;

        if not exists (select 1 from tbl_contact_types where contact_type_id = 2)
           or not exists (select 1 from tbl_contact_types where contact_type_id = 4) then
            raise exception 'Contact types 2 (Analysed by) and 4 (Samples taken by) are required';
        end if;


        insert into tbl_submission_states (submission_state_id, submission_state, note)
        values
            (1, 'Pending', 'Submission is pending review'),
            (2, 'Approved', 'Submission has been approved'),
            (3, 'Rejected', 'Submission has been rejected'),
            (4, 'Pulled', 'Submission has been pulled'),
            (5, 'Future', 'Submission is scheduled for future upload');

        insert into tbl_submission_task_types (
            submission_task_type_id,
            action_task_name,
            description
        )
        select
            submission_type_id,
            submission_type,
            description
        from tbl_dataset_submission_types
        where submission_type_id not in (10, 11);

        /* Insert data providers based on existing dataset masters, preserving legacy IDs */

        insert into tbl_data_providers (
            data_provider_id,
            data_provider_uuid,
            data_provider_name,
            notes,
            contact_id,
            biblio_id,
            url
        )
        select
            master_set_id,
            master_set_uuid,
            master_name,
            master_notes,
            contact_id,
            biblio_id,
            url
        from tbl_dataset_masters;

        
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
