
do $$
declare
    v_submission_id integer;
begin
    v_submission_id := (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);
    if v_submission_id is not null then
        perform clearing_house.fn_delete_submission(v_submission_id, TRUE, TRUE);
    end if;
end $$
language plpgsql;

/*************************************************************************************************************************
 ** Table clearing_house.tbl_clearinghouse_submissions
 *************************************************************************************************************************/

create temp table staging_submissions (like clearing_house.tbl_clearinghouse_submissions including defaults);

\copy staging_submissions (submission_id, submission_name, source_name, submission_state_id, data_types, upload_user_id, upload_date, status_text, claim_user_id, claim_date_time, submission_uuid) from program 'zcat -qac tbl_clearinghouse_submissions.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

insert into clearing_house.tbl_clearinghouse_submissions (submission_name, source_name, submission_state_id, data_types, upload_user_id, upload_date, status_text, claim_user_id, claim_date_time, submission_uuid)
    select submission_name, source_name, submission_state_id, data_types, upload_user_id, upload_date, status_text, claim_user_id, claim_date_time, submission_uuid
    from staging_submissions;
drop table staging_submissions;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_abundances
 *************************************************************************************************************************/

create temp table staging_tbl_abundances (like clearing_house.tbl_abundances including defaults);

\copy staging_tbl_abundances (submission_id, abundance_id, taxon_id, analysis_entity_id, abundance_element_id, abundance, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_abundances.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_abundances
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_abundances (submission_id, abundance_id, taxon_id, analysis_entity_id, abundance_element_id, abundance, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, abundance_id, taxon_id, analysis_entity_id, abundance_element_id, abundance, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_abundances;

drop table staging_tbl_abundances;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_alt_ref_types
 *************************************************************************************************************************/

create temp table staging_tbl_alt_ref_types (like clearing_house.tbl_alt_ref_types including defaults);

\copy staging_tbl_alt_ref_types (submission_id, alt_ref_type_id, alt_ref_type, date_updated, description, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_alt_ref_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_alt_ref_types
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_alt_ref_types (submission_id, alt_ref_type_id, alt_ref_type, date_updated, description, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, alt_ref_type_id, alt_ref_type, date_updated, description, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_alt_ref_types;

drop table staging_tbl_alt_ref_types;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_analysis_entities
 *************************************************************************************************************************/

create temp table staging_tbl_analysis_entities (like clearing_house.tbl_analysis_entities including defaults);

\copy staging_tbl_analysis_entities (submission_id, analysis_entity_id, physical_sample_id, dataset_id, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_analysis_entities.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_analysis_entities
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_analysis_entities (submission_id, analysis_entity_id, physical_sample_id, dataset_id, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, analysis_entity_id, physical_sample_id, dataset_id, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_analysis_entities;

drop table staging_tbl_analysis_entities;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_analysis_values
 *************************************************************************************************************************/

create temp table staging_tbl_analysis_values (like clearing_house.tbl_analysis_values including defaults);

\copy staging_tbl_analysis_values (submission_id, analysis_value_id, value_class_id, analysis_entity_id, analysis_value, boolean_value, is_boolean, is_uncertain, is_undefined, is_not_analyzed, is_indeterminable, is_anomaly, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_analysis_values.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_analysis_values
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_analysis_values (submission_id, analysis_value_id, value_class_id, analysis_entity_id, analysis_value, boolean_value, is_boolean, is_uncertain, is_undefined, is_not_analyzed, is_indeterminable, is_anomaly, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, analysis_value_id, value_class_id, analysis_entity_id, analysis_value, boolean_value, is_boolean, is_uncertain, is_undefined, is_not_analyzed, is_indeterminable, is_anomaly, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_analysis_values;

drop table staging_tbl_analysis_values;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_biblio
 *************************************************************************************************************************/

create temp table staging_tbl_biblio (like clearing_house.tbl_biblio including defaults);

\copy staging_tbl_biblio (submission_id, biblio_id, bugs_reference, date_updated, doi, isbn, notes, title, year, authors, full_reference, url, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_biblio.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_biblio
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_biblio (submission_id, biblio_id, bugs_reference, date_updated, doi, isbn, notes, title, year, authors, full_reference, url, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, biblio_id, bugs_reference, date_updated, doi, isbn, notes, title, year, authors, full_reference, url, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_biblio;

drop table staging_tbl_biblio;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_contacts
 *************************************************************************************************************************/

create temp table staging_tbl_contacts (like clearing_house.tbl_contacts including defaults);

\copy staging_tbl_contacts (submission_id, contact_id, address_1, address_2, location_id, email, first_name, last_name, phone_number, url, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_contacts.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_contacts
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_contacts (submission_id, contact_id, address_1, address_2, location_id, email, first_name, last_name, phone_number, url, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, contact_id, address_1, address_2, location_id, email, first_name, last_name, phone_number, url, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_contacts;

drop table staging_tbl_contacts;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_dataset_contacts
 *************************************************************************************************************************/

create temp table staging_tbl_dataset_contacts (like clearing_house.tbl_dataset_contacts including defaults);

\copy staging_tbl_dataset_contacts (submission_id, dataset_contact_id, contact_id, contact_type_id, dataset_id, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_dataset_contacts.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_dataset_contacts
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_dataset_contacts (submission_id, dataset_contact_id, contact_id, contact_type_id, dataset_id, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, dataset_contact_id, contact_id, contact_type_id, dataset_id, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_dataset_contacts;

drop table staging_tbl_dataset_contacts;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_dataset_masters
 *************************************************************************************************************************/

create temp table staging_tbl_dataset_masters (like clearing_house.tbl_dataset_masters including defaults);

\copy staging_tbl_dataset_masters (submission_id, master_set_id, contact_id, biblio_id, master_name, master_notes, url, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_dataset_masters.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_dataset_masters
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_dataset_masters (submission_id, master_set_id, contact_id, biblio_id, master_name, master_notes, url, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, master_set_id, contact_id, biblio_id, master_name, master_notes, url, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_dataset_masters;

drop table staging_tbl_dataset_masters;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_dataset_submissions
 *************************************************************************************************************************/

create temp table staging_tbl_dataset_submissions (like clearing_house.tbl_dataset_submissions including defaults);

\copy staging_tbl_dataset_submissions (submission_id, dataset_submission_id, dataset_id, submission_type_id, contact_id, date_submitted, notes, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_dataset_submissions.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_dataset_submissions
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_dataset_submissions (submission_id, dataset_submission_id, dataset_id, submission_type_id, contact_id, date_submitted, notes, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, dataset_submission_id, dataset_id, submission_type_id, contact_id, date_submitted, notes, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_dataset_submissions;

drop table staging_tbl_dataset_submissions;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_datasets
 *************************************************************************************************************************/

create temp table staging_tbl_datasets (like clearing_house.tbl_datasets including defaults);

\copy staging_tbl_datasets (submission_id, dataset_id, master_set_id, data_type_id, method_id, biblio_id, updated_dataset_id, project_id, dataset_name, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_datasets.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_datasets
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_datasets (submission_id, dataset_id, master_set_id, data_type_id, method_id, biblio_id, updated_dataset_id, project_id, dataset_name, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, dataset_id, master_set_id, data_type_id, method_id, biblio_id, updated_dataset_id, project_id, dataset_name, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_datasets;

drop table staging_tbl_datasets;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_locations
 *************************************************************************************************************************/

create temp table staging_tbl_locations (like clearing_house.tbl_locations including defaults);

\copy staging_tbl_locations (submission_id, location_id, location_name, location_type_id, default_lat_dd, default_long_dd, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_locations.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_locations
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_locations (submission_id, location_id, location_name, location_type_id, default_lat_dd, default_long_dd, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, location_id, location_name, location_type_id, default_lat_dd, default_long_dd, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_locations;

drop table staging_tbl_locations;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_methods
 *************************************************************************************************************************/

create temp table staging_tbl_methods (like clearing_house.tbl_methods including defaults);

\copy staging_tbl_methods (submission_id, method_id, biblio_id, date_updated, description, method_abbrev_or_alt_name, method_group_id, method_name, record_type_id, unit_id, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_methods.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_methods
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_methods (submission_id, method_id, biblio_id, date_updated, description, method_abbrev_or_alt_name, method_group_id, method_name, record_type_id, unit_id, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, method_id, biblio_id, date_updated, description, method_abbrev_or_alt_name, method_group_id, method_name, record_type_id, unit_id, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_methods;

drop table staging_tbl_methods;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_physical_samples
 *************************************************************************************************************************/

create temp table staging_tbl_physical_samples (like clearing_house.tbl_physical_samples including defaults);

\copy staging_tbl_physical_samples (submission_id, physical_sample_id, sample_group_id, alt_ref_type_id, sample_type_id, sample_name, date_updated, date_sampled, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_physical_samples.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_physical_samples
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_physical_samples (submission_id, physical_sample_id, sample_group_id, alt_ref_type_id, sample_type_id, sample_name, date_updated, date_sampled, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, physical_sample_id, sample_group_id, alt_ref_type_id, sample_type_id, sample_name, date_updated, date_sampled, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_physical_samples;

drop table staging_tbl_physical_samples;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_projects
 *************************************************************************************************************************/

create temp table staging_tbl_projects (like clearing_house.tbl_projects including defaults);

\copy staging_tbl_projects (submission_id, project_id, project_type_id, project_stage_id, project_name, project_abbrev_name, description, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_projects.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_projects
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_projects (submission_id, project_id, project_type_id, project_stage_id, project_name, project_abbrev_name, description, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, project_id, project_type_id, project_stage_id, project_name, project_abbrev_name, description, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_projects;

drop table staging_tbl_projects;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_record_types
 *************************************************************************************************************************/

create temp table staging_tbl_record_types (like clearing_house.tbl_record_types including defaults);

\copy staging_tbl_record_types (submission_id, record_type_id, record_type_name, record_type_description, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_record_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_record_types
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_record_types (submission_id, record_type_id, record_type_name, record_type_description, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, record_type_id, record_type_name, record_type_description, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_record_types;

drop table staging_tbl_record_types;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_relative_dates
 *************************************************************************************************************************/

create temp table staging_tbl_relative_dates (like clearing_house.tbl_relative_dates including defaults);

\copy staging_tbl_relative_dates (submission_id, relative_date_id, relative_age_id, method_id, notes, date_updated, dating_uncertainty_id, analysis_entity_id, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_relative_dates.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_relative_dates
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_relative_dates (submission_id, relative_date_id, relative_age_id, method_id, notes, date_updated, dating_uncertainty_id, analysis_entity_id, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, relative_date_id, relative_age_id, method_id, notes, date_updated, dating_uncertainty_id, analysis_entity_id, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_relative_dates;

drop table staging_tbl_relative_dates;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_sample_alt_refs
 *************************************************************************************************************************/

create temp table staging_tbl_sample_alt_refs (like clearing_house.tbl_sample_alt_refs including defaults);

\copy staging_tbl_sample_alt_refs (submission_id, sample_alt_ref_id, alt_ref, alt_ref_type_id, date_updated, physical_sample_id, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_sample_alt_refs.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_sample_alt_refs
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_sample_alt_refs (submission_id, sample_alt_ref_id, alt_ref, alt_ref_type_id, date_updated, physical_sample_id, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, sample_alt_ref_id, alt_ref, alt_ref_type_id, date_updated, physical_sample_id, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_sample_alt_refs;

drop table staging_tbl_sample_alt_refs;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_sample_groups
 *************************************************************************************************************************/

create temp table staging_tbl_sample_groups (like clearing_house.tbl_sample_groups including defaults);

\copy staging_tbl_sample_groups (submission_id, sample_group_id, site_id, sampling_context_id, method_id, sample_group_name, sample_group_description, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_sample_groups.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_sample_groups
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_sample_groups (submission_id, sample_group_id, site_id, sampling_context_id, method_id, sample_group_name, sample_group_description, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, sample_group_id, site_id, sampling_context_id, method_id, sample_group_name, sample_group_description, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_sample_groups;

drop table staging_tbl_sample_groups;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_site_locations
 *************************************************************************************************************************/

create temp table staging_tbl_site_locations (like clearing_house.tbl_site_locations including defaults);

\copy staging_tbl_site_locations (submission_id, site_location_id, date_updated, location_id, site_id, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_site_locations.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_site_locations
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_site_locations (submission_id, site_location_id, date_updated, location_id, site_id, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, site_location_id, date_updated, location_id, site_id, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_site_locations;

drop table staging_tbl_site_locations;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_site_references
 *************************************************************************************************************************/

create temp table staging_tbl_site_references (like clearing_house.tbl_site_references including defaults);

\copy staging_tbl_site_references (submission_id, site_reference_id, site_id, biblio_id, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_site_references.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_site_references
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_site_references (submission_id, site_reference_id, site_id, biblio_id, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, site_reference_id, site_id, biblio_id, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_site_references;

drop table staging_tbl_site_references;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_sites
 *************************************************************************************************************************/

create temp table staging_tbl_sites (like clearing_house.tbl_sites including defaults);

\copy staging_tbl_sites (submission_id, site_id, altitude, latitude_dd, longitude_dd, national_site_identifier, site_description, site_name, site_preservation_status_id, site_location_accuracy, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_sites.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_sites
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_sites (submission_id, site_id, altitude, latitude_dd, longitude_dd, national_site_identifier, site_description, site_name, site_preservation_status_id, site_location_accuracy, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, site_id, altitude, latitude_dd, longitude_dd, national_site_identifier, site_description, site_name, site_preservation_status_id, site_location_accuracy, date_updated, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_sites;

drop table staging_tbl_sites;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_taxa_tree_families
 *************************************************************************************************************************/

create temp table staging_tbl_taxa_tree_families (like clearing_house.tbl_taxa_tree_families including defaults);

\copy staging_tbl_taxa_tree_families (submission_id, family_id, date_updated, family_name, order_id, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_taxa_tree_families.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_taxa_tree_families
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_taxa_tree_families (submission_id, family_id, date_updated, family_name, order_id, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, family_id, date_updated, family_name, order_id, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_taxa_tree_families;

drop table staging_tbl_taxa_tree_families;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_taxa_tree_genera
 *************************************************************************************************************************/

create temp table staging_tbl_taxa_tree_genera (like clearing_house.tbl_taxa_tree_genera including defaults);

\copy staging_tbl_taxa_tree_genera (submission_id, genus_id, date_updated, family_id, genus_name, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_taxa_tree_genera.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_taxa_tree_genera
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_taxa_tree_genera (submission_id, genus_id, date_updated, family_id, genus_name, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, genus_id, date_updated, family_id, genus_name, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_taxa_tree_genera;

drop table staging_tbl_taxa_tree_genera;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_taxa_tree_master
 *************************************************************************************************************************/

create temp table staging_tbl_taxa_tree_master (like clearing_house.tbl_taxa_tree_master including defaults);

\copy staging_tbl_taxa_tree_master (submission_id, taxon_id, author_id, date_updated, genus_id, species, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_taxa_tree_master.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_taxa_tree_master
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_taxa_tree_master (submission_id, taxon_id, author_id, date_updated, genus_id, species, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, taxon_id, author_id, date_updated, genus_id, species, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_taxa_tree_master;

drop table staging_tbl_taxa_tree_master;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_taxa_tree_orders
 *************************************************************************************************************************/

create temp table staging_tbl_taxa_tree_orders (like clearing_house.tbl_taxa_tree_orders including defaults);

\copy staging_tbl_taxa_tree_orders (submission_id, order_id, date_updated, order_name, record_type_id, sort_order, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_taxa_tree_orders.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_taxa_tree_orders
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_taxa_tree_orders (submission_id, order_id, date_updated, order_name, record_type_id, sort_order, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, order_id, date_updated, order_name, record_type_id, sort_order, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_taxa_tree_orders;

drop table staging_tbl_taxa_tree_orders;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_taxonomic_order
 *************************************************************************************************************************/

create temp table staging_tbl_taxonomic_order (like clearing_house.tbl_taxonomic_order including defaults);

\copy staging_tbl_taxonomic_order (submission_id, taxonomic_order_id, date_updated, taxon_id, taxonomic_code, taxonomic_order_system_id, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_taxonomic_order.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_taxonomic_order
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_taxonomic_order (submission_id, taxonomic_order_id, date_updated, taxon_id, taxonomic_code, taxonomic_order_system_id, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, taxonomic_order_id, date_updated, taxon_id, taxonomic_code, taxonomic_order_system_id, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_taxonomic_order;

drop table staging_tbl_taxonomic_order;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_taxonomic_order_systems
 *************************************************************************************************************************/

create temp table staging_tbl_taxonomic_order_systems (like clearing_house.tbl_taxonomic_order_systems including defaults);

\copy staging_tbl_taxonomic_order_systems (submission_id, taxonomic_order_system_id, date_updated, system_description, system_name, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_taxonomic_order_systems.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_taxonomic_order_systems
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_taxonomic_order_systems (submission_id, taxonomic_order_system_id, date_updated, system_description, system_name, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, taxonomic_order_system_id, date_updated, system_description, system_name, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_taxonomic_order_systems;

drop table staging_tbl_taxonomic_order_systems;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_value_classes
 *************************************************************************************************************************/

create temp table staging_tbl_value_classes (like clearing_house.tbl_value_classes including defaults);

\copy staging_tbl_value_classes (submission_id, value_class_id, value_type_id, method_id, parent_id, name, description, value_class_uuid, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_value_classes.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_value_classes
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_value_classes (submission_id, value_class_id, value_type_id, method_id, parent_id, name, description, value_class_uuid, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, value_class_id, value_type_id, method_id, parent_id, name, description, value_class_uuid, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_value_classes;

drop table staging_tbl_value_classes;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_value_type_items
 *************************************************************************************************************************/

create temp table staging_tbl_value_type_items (like clearing_house.tbl_value_type_items including defaults);

\copy staging_tbl_value_type_items (submission_id, value_type_item_id, value_type_id, name, description, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_value_type_items.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_value_type_items
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_value_type_items (submission_id, value_type_item_id, value_type_id, name, description, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, value_type_item_id, value_type_id, name, description, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_value_type_items;

drop table staging_tbl_value_type_items;


/*************************************************************************************************************************
 ** Table clearing_house.tbl_value_types
 *************************************************************************************************************************/

create temp table staging_tbl_value_types (like clearing_house.tbl_value_types including defaults);

\copy staging_tbl_value_types (submission_id, value_type_id, unit_id, data_type_id, name, base_type, precision, description, value_type_uuid, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id) from program 'zcat -qac tbl_value_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');

update staging_tbl_value_types
    set submission_id = (select submission_id from clearing_house.tbl_clearinghouse_submissions where submission_name = '20250108_DML_SUBMISSION_ADNA_001_COMMIT' limit 1);

insert into clearing_house.tbl_value_types (submission_id, value_type_id, unit_id, data_type_id, name, base_type, precision, description, value_type_uuid, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id)
    select submission_id, value_type_id, unit_id, data_type_id, name, base_type, precision, description, value_type_uuid, source_id, local_db_id, public_db_id, transport_type, transport_date, transport_id
    from staging_tbl_value_types;

drop table staging_tbl_value_types;

