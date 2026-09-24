-- Revert sead_model: 20260830_DDL_SUBMISSION_MODEL_REFACTOR

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2026-09-01
  Description   Reverts the improved design of the SEAD schema for handling data submissions and related data
  Issue         https://github.com/humlab-sead/sead_change_control/issues/440
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes         Drops the submission model tables, indexes, and added columns introduced by the forward change.
                Legacy tables (tbl_dataset_masters, tbl_dataset_submissions, tbl_dataset_submission_types) are
                untouched and remain the source of truth after the revert.
*****************************************************************************************************************/

-- set client_encoding = 'UTF8';
-- set client_min_messages = warning;

-- begin;
-- do $$
-- begin

--     begin

--         if not sead_utility.table_exists('public', 'tbl_submissions') then
--             raise exception SQLSTATE 'GUARD';
--         end if;

--         -- Drop indexes before the tables they belong to.
--         drop index if exists idx_datasets_submission_id;
--         drop index if exists idx_submission_tasks_biblio_id;
--         drop index if exists idx_submission_tasks_submission_id;
--         drop index if exists idx_submission_tasks_contact_id;
--         drop index if exists idx_submission_tasks_submission_task_type_id;
--         drop index if exists idx_submissions_data_provider_id;
--         drop index if exists idx_submissions_biblio_id;
--         drop index if exists idx_submissions_submission_state_id;

--         -- Remove the foreign key from tbl_datasets before dropping the column it uses.
--         alter table tbl_datasets
--             drop constraint if exists fk_datasets_submission_id;

--         -- Drop the columns added to existing tables.
--         alter table tbl_datasets drop column if exists submission_id;
--         alter table tbl_dataset_contacts drop column if exists event_date;

--         -- Drop the new tables in reverse dependency order.
--         drop table if exists tbl_submission_tasks;
--         drop table if exists tbl_submission_task_types;
--         drop table if exists tbl_submissions;
--         drop table if exists tbl_data_providers;
--         drop table if exists tbl_submission_states;

--         -- Restore the comments that existed before the deploy change.
--         comment on table tbl_dataset_masters is
--             'Represents a major grouping identifier for datasets, typically indicating a contributing database, project, user, or '
--             'laboratory (e.g., BugsCEP, MAL, Lund Dendro Lab).';
--         comment on table tbl_dataset_submissions is
--             'Contains records of various submission events related to a dataset, such as initial recording, database entries, and '
--             'integrations with SEAD.';
--         comment on table tbl_dataset_submission_types is
--             'Serves as a lookup for different types of dataset submissions, such as original submissions or data ingested from '
--             'external databases.';

--     exception when sqlstate 'GUARD' then
--         raise notice 'ALREADY REVERTED';
--     end;

-- end $$;
-- commit;
