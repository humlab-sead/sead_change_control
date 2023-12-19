-- Deploy subsystem: 20231219_DML_CLEARINGHOUSE_STARTINGPOINT

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2023-12-19
  Description
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
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


-- These tables are initialized by install script 20191217_DDL_CLEARINGHOUSE_SYSTEM

-- \copy clearing_house.tbl_clearinghouse_submission_states from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_clearinghouse_submission_states.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
-- \copy clearing_house.tbl_clearinghouse_submission_tables from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_clearinghouse_submission_tables.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
-- \copy clearing_house.tbl_clearinghouse_data_provider_grades from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_clearinghouse_data_provider_grades.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
-- \copy clearing_house.tbl_clearinghouse_use_cases from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_clearinghouse_use_cases.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
-- \copy clearing_house.tbl_clearinghouse_user_roles from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_clearinghouse_user_roles.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
-- \copy clearing_house.tbl_clearinghouse_users from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_clearinghouse_users.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
-- \copy clearing_house.tbl_clearinghouse_settings from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_clearinghouse_settings.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
-- \copy clearing_house.tbl_clearinghouse_info_references from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_clearinghouse_info_references.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
-- \copy clearing_house.tbl_clearinghouse_reject_entity_types from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_clearinghouse_reject_entity_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
-- \copy clearing_house.tbl_clearinghouse_reports from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_clearinghouse_reports.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

\copy clearing_house.tbl_analysis_entities from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_analysis_entities.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_analysis_entity_prep_methods from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_analysis_entity_prep_methods.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_ceramics from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_ceramics.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_clearinghouse_sead_create_table_log from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_clearinghouse_sead_create_table_log.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_clearinghouse_sead_create_view_log from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_clearinghouse_sead_create_view_log.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_clearinghouse_submission_xml_content_columns from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_clearinghouse_submission_xml_content_columns.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_clearinghouse_submission_xml_content_records from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_clearinghouse_submission_xml_content_records.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_clearinghouse_submission_xml_content_tables from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_clearinghouse_submission_xml_content_tables.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_clearinghouse_submission_xml_content_values from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_clearinghouse_submission_xml_content_values.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_clearinghouse_submissions from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_clearinghouse_submissions.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_dataset_contacts from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_dataset_contacts.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_dataset_submissions from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_dataset_submissions.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_datasets from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_datasets.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_features from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_features.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_isotope_measurements from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_isotope_measurements.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_isotopes from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_isotopes.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_method_groups from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_method_groups.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_methods from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_methods.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_physical_sample_features from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_physical_sample_features.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_physical_samples from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_physical_samples.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_relative_age_refs from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_relative_age_refs.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_relative_ages from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_relative_ages.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_relative_dates from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_relative_dates.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_sample_alt_refs from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_sample_alt_refs.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_sample_descriptions from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_sample_descriptions.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_sample_group_description_type_sampling_contexts from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_sample_group_description_type_sampling_contexts.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_sample_group_descriptions from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_sample_group_descriptions.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_sample_group_dimensions from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_sample_group_dimensions.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_sample_groups from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_sample_groups.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_sample_locations from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_sample_locations.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_sample_notes from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_sample_notes.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_sample_types from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_sample_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_site_locations from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_site_locations.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_site_references from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_site_references.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_sites from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_sites.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy clearing_house.tbl_units from program 'zcat -qac 20231219_DML_CLEARINGHOUSE_STARTINGPOINT/tbl_units.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');


commit;
