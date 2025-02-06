-- Deploy subsystem: 20231219_DML_CLEARINGHOUSE_STARTINGPOINT
/****************************************************************************************************************
  Author        Roger Mähler
  Date          2023-12-19
  Description   Setup ClearingHouse with only ceramics and isotope data
  Issue         https://github.com/humlab-sead/sead_change_control/issues/214
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
*****************************************************************************************************************/

do $$
begin
    perform sead_utility.set_fk_is_deferrable('clearing_house', true, false);
end $$ language plpgsql;

set client_min_messages to warning;
\set autocommit off;

set search_path TO clearing_house;

begin;

set constraints fk_tbl_clearinghouse_submission_reject_entities deferred;
set constraints fk_tbl_clearinghouse_submission_rejects_submission_id deferred;
set constraints fk_tbl_clearinghouse_submission_xml_content_tables deferred;
set constraints fk_tbl_clearinghouse_submission_xml_content_tables_sid deferred;
set constraints fk_tbl_data_provider_grades_grade_id deferred;
set constraints fk_tbl_submissions_state_id_state_id deferred;
set constraints fk_tbl_submissions_user_id_user_id deferred;
set constraints fk_tbl_submission_xml_content_columns_table_id deferred;
set constraints fk_tbl_submission_xml_content_meta_record_values_table_id deferred;
set constraints fk_tbl_submission_xml_content_records_table_id deferred;
set constraints fk_tbl_user_roles_role_id deferred;
-- set constraints all deferred;

\cd /repo/subsystem/deploy



select sead_utility.sync_sequences('clearing_house');

commit;
