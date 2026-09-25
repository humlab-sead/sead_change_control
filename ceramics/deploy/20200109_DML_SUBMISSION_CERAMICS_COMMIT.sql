-- Deploy ceramics: 20200109_DML_SUBMISSION_CERAMICS_COMMIT
/***************************************************************************
  Author        Roger
  Date           
  Description    
  Date          2020-01-09
  Prerequisites  
  Issue         https://github.com/humlab-sead/sead_change_control/issues/205
  Description   Deploy of Clearinghouse submission {5}.
  Reviewer
  Approver
  Idempotent     NO
  Notes          Use --single-transaction on execute!
***************************************************************************/
set client_min_messages to warning;
\set autocommit off;
begin;

set constraints all deferred;

\cd /repo/ceramics/deploy

\o /dev/null
call clearing_house_commit.reset_public_sequence_ids();
\o

/************************************************************************************************************************************
 ** site
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sites;
create table clearing_house_commit.temp_tbl_sites as select site_id, altitude, latitude_dd, longitude_dd, national_site_identifier, site_description, site_name, site_preservation_status_id, site_location_accuracy, date_updated from public.tbl_sites where FALSE;

\copy clearing_house_commit.temp_tbl_sites  (site_id, altitude, latitude_dd, longitude_dd, national_site_identifier, site_description, site_name, site_preservation_status_id, date_updated, site_location_accuracy) from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_COMMIT/site.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

insert into public.tbl_sites (site_id, altitude, latitude_dd, longitude_dd, national_site_identifier, site_description, site_name, site_preservation_status_id, site_location_accuracy, date_updated)
    select site_id, altitude, latitude_dd, longitude_dd, national_site_identifier, site_description, site_name, site_preservation_status_id, site_location_accuracy, date_updated
    from clearing_house_commit.temp_tbl_sites ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_sites;



/************************************************************************************************************************************
 ** feature
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_features;
create table clearing_house_commit.temp_tbl_features as select feature_id, feature_type_id, feature_name, feature_description, date_updated from public.tbl_features where FALSE;

\copy clearing_house_commit.temp_tbl_features (feature_id, feature_type_id, feature_name, feature_description, date_updated) from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_COMMIT/feature.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

insert into public.tbl_features (feature_id, feature_type_id, feature_name, feature_description, date_updated)
    select feature_id, feature_type_id, feature_name, feature_description, date_updated
    from clearing_house_commit.temp_tbl_features ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_features;



/************************************************************************************************************************************
 ** dataset
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_datasets;
create table clearing_house_commit.temp_tbl_datasets as select dataset_id, master_set_id, data_type_id, method_id, biblio_id, updated_dataset_id, project_id, dataset_name, date_updated from public.tbl_datasets where FALSE;

\copy clearing_house_commit.temp_tbl_datasets (dataset_id, master_set_id, data_type_id, method_id, biblio_id, updated_dataset_id, project_id, dataset_name, date_updated) from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_COMMIT/dataset.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

insert into public.tbl_datasets (dataset_id, master_set_id, data_type_id, method_id, biblio_id, updated_dataset_id, project_id, dataset_name, date_updated)
    select dataset_id, master_set_id, data_type_id, method_id, biblio_id, updated_dataset_id, project_id, dataset_name, date_updated
    from clearing_house_commit.temp_tbl_datasets;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_datasets;



/************************************************************************************************************************************
 ** dataset_contact
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_dataset_contacts;
create table clearing_house_commit.temp_tbl_dataset_contacts as select dataset_contact_id, contact_id, contact_type_id, dataset_id, date_updated from public.tbl_dataset_contacts where FALSE;

\copy clearing_house_commit.temp_tbl_dataset_contacts (dataset_contact_id, contact_id, contact_type_id, dataset_id, date_updated) from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_COMMIT/dataset_contact.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

insert into public.tbl_dataset_contacts (dataset_contact_id, contact_id, contact_type_id, dataset_id, date_updated)
    select dataset_contact_id, contact_id, contact_type_id, dataset_id, date_updated
    from clearing_house_commit.temp_tbl_dataset_contacts ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_dataset_contacts;



/************************************************************************************************************************************
 ** dataset_submission
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_dataset_submissions;
create table clearing_house_commit.temp_tbl_dataset_submissions as select dataset_submission_id, dataset_id, submission_type_id, contact_id, date_submitted, notes, date_updated from public.tbl_dataset_submissions where FALSE;

\copy clearing_house_commit.temp_tbl_dataset_submissions (dataset_submission_id, dataset_id, submission_type_id, contact_id, date_submitted, notes, date_updated) from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_COMMIT/dataset_submission.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

insert into public.tbl_dataset_submissions (dataset_submission_id, dataset_id, submission_type_id, contact_id, date_submitted, notes, date_updated)
    select dataset_submission_id, dataset_id, submission_type_id, contact_id, date_submitted, notes, date_updated
    from clearing_house_commit.temp_tbl_dataset_submissions ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_dataset_submissions;



/************************************************************************************************************************************
 ** sample_group_description_type_sampling_context
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sample_group_description_type_sampling_contexts;
create table clearing_house_commit.temp_tbl_sample_group_description_type_sampling_contexts as select sample_group_description_type_sampling_context_id, sampling_context_id, sample_group_description_type_id, date_updated from public.tbl_sample_group_description_type_sampling_contexts where FALSE;

\copy clearing_house_commit.temp_tbl_sample_group_description_type_sampling_contexts (sample_group_description_type_sampling_context_id, sampling_context_id, sample_group_description_type_id, date_updated) from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_COMMIT/sample_group_description_type_sampling_context.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

insert into public.tbl_sample_group_description_type_sampling_contexts (sample_group_description_type_sampling_context_id, sampling_context_id, sample_group_description_type_id, date_updated)
    select sample_group_description_type_sampling_context_id, sampling_context_id, sample_group_description_type_id, date_updated   
    from clearing_house_commit.temp_tbl_sample_group_description_type_sampling_contexts ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_sample_group_description_type_sampling_contexts;



/************************************************************************************************************************************
 ** sample_group
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sample_groups;
create table clearing_house_commit.temp_tbl_sample_groups as select sample_group_id, site_id, sampling_context_id, method_id, sample_group_name, sample_group_description, date_updated from public.tbl_sample_groups where FALSE;

\copy clearing_house_commit.temp_tbl_sample_groups (sample_group_id, site_id, sampling_context_id, method_id, sample_group_name, sample_group_description, date_updated) from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_COMMIT/sample_group.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

insert into public.tbl_sample_groups (sample_group_id, site_id, sampling_context_id, method_id, sample_group_name, sample_group_description, date_updated)
    select sample_group_id, site_id, sampling_context_id, method_id, sample_group_name, sample_group_description, date_updated
    from clearing_house_commit.temp_tbl_sample_groups ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_sample_groups;



/************************************************************************************************************************************
 ** physical_sample
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_physical_samples;
create table clearing_house_commit.temp_tbl_physical_samples as select physical_sample_id, sample_group_id, alt_ref_type_id, sample_type_id, sample_name, date_updated, date_sampled from public.tbl_physical_samples where FALSE;

\copy clearing_house_commit.temp_tbl_physical_samples (physical_sample_id, sample_group_id, alt_ref_type_id, sample_type_id, sample_name, date_updated, date_sampled) from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_COMMIT/physical_sample.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

insert into public.tbl_physical_samples (physical_sample_id, sample_group_id, alt_ref_type_id, sample_type_id, sample_name, date_updated, date_sampled)
    select physical_sample_id, sample_group_id, alt_ref_type_id, sample_type_id, sample_name, date_updated, date_sampled
    from clearing_house_commit.temp_tbl_physical_samples ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_physical_samples;



/************************************************************************************************************************************
 ** analysis_entity
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_analysis_entities;
create table clearing_house_commit.temp_tbl_analysis_entities as select analysis_entity_id, physical_sample_id, dataset_id, date_updated from public.tbl_analysis_entities where FALSE;

\copy clearing_house_commit.temp_tbl_analysis_entities (analysis_entity_id, physical_sample_id, dataset_id, date_updated) from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_COMMIT/analysis_entity.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

insert into public.tbl_analysis_entities (analysis_entity_id, physical_sample_id, dataset_id, date_updated)
    select analysis_entity_id, physical_sample_id, dataset_id, date_updated
    from clearing_house_commit.temp_tbl_analysis_entities ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_analysis_entities;



/************************************************************************************************************************************
 ** ceramic
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_ceramics;
create table clearing_house_commit.temp_tbl_ceramics as select ceramics_id, analysis_entity_id, measurement_value, date_updated, ceramics_lookup_id from public.tbl_ceramics where FALSE;

\copy clearing_house_commit.temp_tbl_ceramics (ceramics_id, analysis_entity_id, measurement_value, date_updated, ceramics_lookup_id) from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_COMMIT/ceramic.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

insert into public.tbl_ceramics (ceramics_id, analysis_entity_id, measurement_value, date_updated, ceramics_lookup_id)
    select ceramics_id, analysis_entity_id, measurement_value, date_updated, ceramics_lookup_id
    from clearing_house_commit.temp_tbl_ceramics ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_ceramics;



/************************************************************************************************************************************
 ** physical_sample_feature
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_physical_sample_features;
create table clearing_house_commit.temp_tbl_physical_sample_features as select physical_sample_feature_id, date_updated, feature_id, physical_sample_id from public.tbl_physical_sample_features where FALSE;

\copy clearing_house_commit.temp_tbl_physical_sample_features (physical_sample_feature_id, date_updated, feature_id, physical_sample_id) from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_COMMIT/physical_sample_feature.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

insert into public.tbl_physical_sample_features (physical_sample_feature_id, date_updated, feature_id, physical_sample_id)
    select physical_sample_feature_id, date_updated, feature_id, physical_sample_id
    from clearing_house_commit.temp_tbl_physical_sample_features ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_physical_sample_features;



/************************************************************************************************************************************
 ** relative_date
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_relative_dates;
create table clearing_house_commit.temp_tbl_relative_dates as select relative_date_id, relative_age_id, method_id, notes, date_updated, dating_uncertainty_id, analysis_entity_id from public.tbl_relative_dates where FALSE;

\copy clearing_house_commit.temp_tbl_relative_dates (relative_date_id, relative_age_id, method_id, notes, date_updated, dating_uncertainty_id, analysis_entity_id) from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_COMMIT/relative_date.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

insert into public.tbl_relative_dates (relative_date_id, relative_age_id, method_id, notes, date_updated, dating_uncertainty_id, analysis_entity_id)
    select relative_date_id, relative_age_id, method_id, notes, date_updated, dating_uncertainty_id, analysis_entity_id
    from clearing_house_commit.temp_tbl_relative_dates ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_relative_dates;



/************************************************************************************************************************************
 ** sample_alt_ref
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sample_alt_refs;
create table clearing_house_commit.temp_tbl_sample_alt_refs as select sample_alt_ref_id, alt_ref, alt_ref_type_id, date_updated, physical_sample_id from public.tbl_sample_alt_refs where FALSE;

\copy clearing_house_commit.temp_tbl_sample_alt_refs (sample_alt_ref_id, alt_ref, alt_ref_type_id, date_updated, physical_sample_id) from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_COMMIT/sample_alt_ref.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

insert into public.tbl_sample_alt_refs (sample_alt_ref_id, alt_ref, alt_ref_type_id, date_updated, physical_sample_id)
    select sample_alt_ref_id, alt_ref, alt_ref_type_id, date_updated, physical_sample_id
    from clearing_house_commit.temp_tbl_sample_alt_refs ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_sample_alt_refs;



/************************************************************************************************************************************
 ** sample_description
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sample_descriptions;
create table clearing_house_commit.temp_tbl_sample_descriptions as select sample_description_id, sample_description_type_id, physical_sample_id, description, date_updated from public.tbl_sample_descriptions where FALSE;

\copy clearing_house_commit.temp_tbl_sample_descriptions (sample_description_id, sample_description_type_id, physical_sample_id, description, date_updated) from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_COMMIT/sample_description.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

insert into public.tbl_sample_descriptions (sample_description_id, sample_description_type_id, physical_sample_id, description, date_updated)
    select sample_description_id, sample_description_type_id, physical_sample_id, description, date_updated
    from clearing_house_commit.temp_tbl_sample_descriptions ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_sample_descriptions;



/************************************************************************************************************************************
 ** sample_dimension
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sample_dimensions;
create table clearing_house_commit.temp_tbl_sample_dimensions as select sample_dimension_id, physical_sample_id, dimension_id, method_id, dimension_value, date_updated from public.tbl_sample_dimensions where FALSE;

\copy clearing_house_commit.temp_tbl_sample_dimensions (sample_dimension_id, physical_sample_id, dimension_id, method_id, dimension_value, date_updated) from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_COMMIT/sample_dimension.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

insert into public.tbl_sample_dimensions (sample_dimension_id, physical_sample_id, dimension_id, method_id, dimension_value, date_updated)
    select sample_dimension_id, physical_sample_id, dimension_id, method_id, dimension_value, date_updated
    from clearing_house_commit.temp_tbl_sample_dimensions ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_sample_dimensions;



/************************************************************************************************************************************
 ** sample_group_description
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sample_group_descriptions;
create table clearing_house_commit.temp_tbl_sample_group_descriptions as select sample_group_description_id, group_description, sample_group_description_type_id, date_updated, sample_group_id from public.tbl_sample_group_descriptions where FALSE;

\copy clearing_house_commit.temp_tbl_sample_group_descriptions (sample_group_description_id, group_description, sample_group_description_type_id, date_updated, sample_group_id) from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_COMMIT/sample_group_description.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

insert into public.tbl_sample_group_descriptions (sample_group_description_id, group_description, sample_group_description_type_id, date_updated, sample_group_id)
    select sample_group_description_id, group_description, sample_group_description_type_id, date_updated, sample_group_id
    from clearing_house_commit.temp_tbl_sample_group_descriptions ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_sample_group_descriptions;



/************************************************************************************************************************************
 ** sample_group_dimension
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sample_group_dimensions;
create table clearing_house_commit.temp_tbl_sample_group_dimensions as select sample_group_dimension_id, date_updated, dimension_id, dimension_value, sample_group_id from public.tbl_sample_group_dimensions where FALSE;

\copy clearing_house_commit.temp_tbl_sample_group_dimensions (sample_group_dimension_id, date_updated, dimension_id, dimension_value, sample_group_id) from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_COMMIT/sample_group_dimension.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

insert into public.tbl_sample_group_dimensions (sample_group_dimension_id, date_updated, dimension_id, dimension_value, sample_group_id)
    select sample_group_dimension_id, date_updated, dimension_id, dimension_value, sample_group_id
    from clearing_house_commit.temp_tbl_sample_group_dimensions ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_sample_group_dimensions;



/************************************************************************************************************************************
 ** site_location
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_site_locations;
create table clearing_house_commit.temp_tbl_site_locations as select site_location_id, date_updated, location_id, site_id from public.tbl_site_locations where FALSE;

\copy clearing_house_commit.temp_tbl_site_locations (site_location_id, date_updated, location_id, site_id) from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_COMMIT/site_location.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

insert into public.tbl_site_locations (site_location_id, date_updated, location_id, site_id)
    select site_location_id, date_updated, location_id, site_id
    from clearing_house_commit.temp_tbl_site_locations ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_site_locations;



/************************************************************************************************************************************
 ** site_reference
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_site_references;
create table clearing_house_commit.temp_tbl_site_references as select site_reference_id, site_id, biblio_id, date_updated from public.tbl_site_references where FALSE;

\copy clearing_house_commit.temp_tbl_site_references (site_reference_id, site_id, biblio_id, date_updated) from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_COMMIT/site_reference.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

insert into public.tbl_site_references (site_reference_id, site_id, biblio_id, date_updated)
    select site_reference_id, site_id, biblio_id, date_updated
    from clearing_house_commit.temp_tbl_site_references ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_site_references;


\o /dev/null
call clearing_house_commit.reset_public_sequence_ids();
select clearing_house_commit.commit_submission('20200109_DML_SUBMISSION_CERAMICS_COMMIT');
\o
commit;
