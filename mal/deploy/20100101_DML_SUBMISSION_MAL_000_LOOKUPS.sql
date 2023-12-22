-- Deploy mal: 20100101_DML_SUBMISSION_MAL_000_LOOKUPS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2010-01-01
  Description   Initial MAL lookup data (equivalent to sead_master_9)
  Issue         https://github.com/humlab-sead/sead_change_control/issues/222
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

set client_min_messages to warning;

\set autocommit off;

begin;

set constraints all deferred;
\cd /repo/mal/deploy

\copy public.tbl_biblio from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_biblio.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_contacts from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_contacts.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_dataset_masters from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_dataset_masters.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_dating_labs from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_dating_labs.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_sample_group_sampling_contexts from program 'zcat -qac 20100101_DML_SUBMISSION_MAL_000_LOOKUPS/tbl_sample_group_sampling_contexts.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

commit;
