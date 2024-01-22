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
end $$ language plpgsql;
