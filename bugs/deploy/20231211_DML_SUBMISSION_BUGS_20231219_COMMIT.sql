-- Deploy bugs: 20231211_DML_SUBMISSION_BUGS_20231219_COMMIT
/****************************************************************************************************************
  Author        Roger Mähler
  Date          2023-12-11
  Description   Full (inital) non-incremental import of BugsCEP data version 20230705.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/162
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

set client_encoding = 'UTF8';
set client_min_messages to warning;
\set autocommit off;

set search_path TO public;

do $$ begin
    perform sead_utility.sync_sequences('bugs_import');
    perform sead_utility.set_fk_is_deferrable('public', true, false);
end $$ language plpgsql;

begin;

set constraints all deferred;

\ir 20231211_DML_SUBMISSION_BUGS_20231219_COMMIT/public.sql
\ir 20231211_DML_SUBMISSION_BUGS_20231219_COMMIT/bugs_import.sql

commit;

do $$ begin
    perform bugs_import.post_import_updates();
    perform sead_utility.set_fk_is_deferrable('public', false, false);
    perform sead_utility.sync_sequences('public');
    perform sead_utility.sync_sequences('bugs_import');


  -- This patch resolve  is a temporary fix for the Bugs import issue in tbl_relative_dates [https://github.com/humlab-sead/sead_change_control/issues/374](#374)

  with dup as (
    select ra.relative_age_id, min(ra.relative_age_id) over (partition by ra.relative_age_name) as canonical_id
    from tbl_relative_ages ra
  )
    update tbl_relative_dates
      set relative_age_id = dup.canonical_id
    from dup, tbl_analysis_entities ae
    join tbl_datasets ds
      on ds.dataset_id = ae.dataset_id
    join tbl_dataset_masters m
      on m.master_set_id = ds.master_set_id
    where tbl_relative_dates.relative_age_id = dup.relative_age_id
      and tbl_relative_dates.analysis_entity_id = ae.analysis_entity_id
      and dup.relative_age_id <> dup.canonical_id
      and m.master_set_id = 1;


end $$ language plpgsql;
