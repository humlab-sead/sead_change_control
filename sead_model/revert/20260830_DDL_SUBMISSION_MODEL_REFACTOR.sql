-- Revert sead_model: 20260830_DDL_SUBMISSION_MODEL_REFACTOR

/****************************************************************************************************************
  Author        Roger Mähler
	Date          2026-08-30
  Description   Reverts the submission model schema refactor
  Issue         https://github.com/humlab-sead/sead_change_control/issues/440
  Prerequisites
  Reviewer
  Approver
  Idempotent    No
  Notes         Drops submission model data and values in the added dataset/contact columns. Does not use CASCADE.
*****************************************************************************************************************/

begin;

drop index if exists idx_datasets_submission_id;
drop index if exists idx_submission_tasks_biblio_id;
drop index if exists idx_submission_tasks_submission_id;
drop index if exists idx_submission_tasks_contact_id;
drop index if exists idx_submission_tasks_submission_task_type_id;
drop index if exists idx_submissions_data_provider_id;
drop index if exists idx_submissions_biblio_id;
drop index if exists idx_submissions_submission_state_id;

alter table tbl_datasets drop column if exists submission_id;
alter table tbl_dataset_contacts drop column if exists event_date;

drop table if exists tbl_submission_tasks;
drop table if exists tbl_submissions;
drop table if exists tbl_submission_task_types;
drop table if exists tbl_data_providers;
drop table if exists tbl_submission_states;

comment on table tbl_dataset_masters is
	'Represents a major grouping identifier for datasets, typically indicating a contributing database, project, user, or '
	'laboratory (e.g., BugsCEP, MAL, Lund Dendro Lab).';
comment on table tbl_dataset_submissions is
	'Contains records of various submission events related to a dataset, such as initial recording, database entries, and '
	'integrations with SEAD.';
comment on table tbl_dataset_submission_types is
	'Serves as a lookup for different types of dataset submissions, such as original submissions or data ingested from '
	'external databases.';

commit;
