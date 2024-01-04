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

set client_min_messages to warning;
\set autocommit off;
\t

set search_path TO public;

do $$ begin
    perform sead_utility.sync_sequences('bugs_import');
    perform sead_utility.set_fk_is_deferrable('public', true, false);
end $$ language plpgsql;

\ir 20231211_DML_SUBMISSION_BUGS_20231219_COMMIT/sead_staging_202212_vs_sead_staging_bugs_DEPLOY_public_202401031734.sql
\ir 20231211_DML_SUBMISSION_BUGS_20231219_COMMIT/sead_staging_202212_vs_sead_staging_bugs_DEPLOY_bugs_import_202401031724.sql

commit;

do $$ begin
    perform sead_utility.set_fk_is_deferrable('public', false, false);
    perform sead_utility.sync_sequences('public');
    perform sead_utility.sync_sequences('bugs_import');
end $$ language plpgsql;
