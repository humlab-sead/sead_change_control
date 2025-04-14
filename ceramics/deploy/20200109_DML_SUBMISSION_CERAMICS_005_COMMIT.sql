-- Deploy ceramics: 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT
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


/************************************************************************************************************************************
 ** site
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sites;
create table clearing_house_commit.temp_tbl_sites as select * from public.tbl_sites where FALSE;

\copy clearing_house_commit.temp_tbl_sites  ("site_id", "altitude", "latitude_dd", "longitude_dd", "national_site_identifier", "site_description", "site_name", "site_preservation_status_id", "date_updated", "site_location_accuracy") from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/submission_5_site.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sites
    where site_id in (select site_id from clearing_house_commit.temp_tbl_sites);

insert into public.tbl_sites
    select *
    from clearing_house_commit.temp_tbl_sites
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_sites', 'site_id');
\o

drop table if exists clearing_house_commit.temp_tbl_sites;



/************************************************************************************************************************************
 ** feature
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_features;
create table clearing_house_commit.temp_tbl_features as select * from public.tbl_features where FALSE;

\copy clearing_house_commit.temp_tbl_features from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/submission_5_feature.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_features
    where feature_id in (select feature_id from clearing_house_commit.temp_tbl_features);

insert into public.tbl_features
    select *
    from clearing_house_commit.temp_tbl_features
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_features', 'feature_id');
\o

drop table if exists clearing_house_commit.temp_tbl_features;



/************************************************************************************************************************************
 ** dataset
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_datasets;
create table clearing_house_commit.temp_tbl_datasets as select * from public.tbl_datasets where FALSE;

\copy clearing_house_commit.temp_tbl_datasets from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/submission_5_dataset.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_datasets
    where dataset_id in (select dataset_id from clearing_house_commit.temp_tbl_datasets);

insert into public.tbl_datasets
    select *
    from clearing_house_commit.temp_tbl_datasets
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_datasets', 'dataset_id');
\o

drop table if exists clearing_house_commit.temp_tbl_datasets;



/************************************************************************************************************************************
 ** dataset_contact
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_dataset_contacts;
create table clearing_house_commit.temp_tbl_dataset_contacts as select * from public.tbl_dataset_contacts where FALSE;

\copy clearing_house_commit.temp_tbl_dataset_contacts from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/submission_5_dataset_contact.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_dataset_contacts
    where dataset_contact_id in (select dataset_contact_id from clearing_house_commit.temp_tbl_dataset_contacts);

insert into public.tbl_dataset_contacts
    select *
    from clearing_house_commit.temp_tbl_dataset_contacts
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_dataset_contacts', 'dataset_contact_id');
\o

drop table if exists clearing_house_commit.temp_tbl_dataset_contacts;



/************************************************************************************************************************************
 ** dataset_submission
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_dataset_submissions;
create table clearing_house_commit.temp_tbl_dataset_submissions as select * from public.tbl_dataset_submissions where FALSE;

\copy clearing_house_commit.temp_tbl_dataset_submissions from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/submission_5_dataset_submission.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_dataset_submissions
    where dataset_submission_id in (select dataset_submission_id from clearing_house_commit.temp_tbl_dataset_submissions);

insert into public.tbl_dataset_submissions
    select *
    from clearing_house_commit.temp_tbl_dataset_submissions
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_dataset_submissions', 'dataset_submission_id');
\o

drop table if exists clearing_house_commit.temp_tbl_dataset_submissions;



/************************************************************************************************************************************
 ** sample_group_description_type_sampling_context
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sample_group_description_type_sampling_contexts;
create table clearing_house_commit.temp_tbl_sample_group_description_type_sampling_contexts as select * from public.tbl_sample_group_description_type_sampling_contexts where FALSE;

\copy clearing_house_commit.temp_tbl_sample_group_description_type_sampling_contexts from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/submission_5_sample_group_description_type_sampling_context.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sample_group_description_type_sampling_contexts
    where sample_group_description_type_sampling_context_id in (select sample_group_description_type_sampling_context_id from clearing_house_commit.temp_tbl_sample_group_description_type_sampling_contexts);

insert into public.tbl_sample_group_description_type_sampling_contexts
    select *
    from clearing_house_commit.temp_tbl_sample_group_description_type_sampling_contexts
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_sample_group_description_type_sampling_contexts', 'sample_group_description_type_sampling_context_id');
\o

drop table if exists clearing_house_commit.temp_tbl_sample_group_description_type_sampling_contexts;



/************************************************************************************************************************************
 ** sample_group
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sample_groups;
create table clearing_house_commit.temp_tbl_sample_groups as select * from public.tbl_sample_groups where FALSE;

\copy clearing_house_commit.temp_tbl_sample_groups from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/submission_5_sample_group.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sample_groups
    where sample_group_id in (select sample_group_id from clearing_house_commit.temp_tbl_sample_groups);

insert into public.tbl_sample_groups
    select *
    from clearing_house_commit.temp_tbl_sample_groups
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_sample_groups', 'sample_group_id');
\o

drop table if exists clearing_house_commit.temp_tbl_sample_groups;



/************************************************************************************************************************************
 ** physical_sample
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_physical_samples;
create table clearing_house_commit.temp_tbl_physical_samples as select * from public.tbl_physical_samples where FALSE;

\copy clearing_house_commit.temp_tbl_physical_samples from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/submission_5_physical_sample.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_physical_samples
    where physical_sample_id in (select physical_sample_id from clearing_house_commit.temp_tbl_physical_samples);

insert into public.tbl_physical_samples
    select *
    from clearing_house_commit.temp_tbl_physical_samples
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_physical_samples', 'physical_sample_id');
\o

drop table if exists clearing_house_commit.temp_tbl_physical_samples;



/************************************************************************************************************************************
 ** analysis_entity
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_analysis_entities;
create table clearing_house_commit.temp_tbl_analysis_entities as select * from public.tbl_analysis_entities where FALSE;

\copy clearing_house_commit.temp_tbl_analysis_entities from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/submission_5_analysis_entity.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_analysis_entities
    where analysis_entity_id in (select analysis_entity_id from clearing_house_commit.temp_tbl_analysis_entities);

insert into public.tbl_analysis_entities
    select *
    from clearing_house_commit.temp_tbl_analysis_entities
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_analysis_entities', 'analysis_entity_id');
\o

drop table if exists clearing_house_commit.temp_tbl_analysis_entities;



/************************************************************************************************************************************
 ** ceramic
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_ceramics;
create table clearing_house_commit.temp_tbl_ceramics as select * from public.tbl_ceramics where FALSE;

\copy clearing_house_commit.temp_tbl_ceramics from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/submission_5_ceramic.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_ceramics
    where ceramics_id in (select ceramics_id from clearing_house_commit.temp_tbl_ceramics);

insert into public.tbl_ceramics
    select *
    from clearing_house_commit.temp_tbl_ceramics
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_ceramics', 'ceramics_id');
\o

drop table if exists clearing_house_commit.temp_tbl_ceramics;



/************************************************************************************************************************************
 ** physical_sample_feature
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_physical_sample_features;
create table clearing_house_commit.temp_tbl_physical_sample_features as select * from public.tbl_physical_sample_features where FALSE;

\copy clearing_house_commit.temp_tbl_physical_sample_features from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/submission_5_physical_sample_feature.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_physical_sample_features
    where physical_sample_feature_id in (select physical_sample_feature_id from clearing_house_commit.temp_tbl_physical_sample_features);

insert into public.tbl_physical_sample_features
    select *
    from clearing_house_commit.temp_tbl_physical_sample_features
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_physical_sample_features', 'physical_sample_feature_id');
\o

drop table if exists clearing_house_commit.temp_tbl_physical_sample_features;



/************************************************************************************************************************************
 ** relative_date
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_relative_dates;
create table clearing_house_commit.temp_tbl_relative_dates as select * from public.tbl_relative_dates where FALSE;

\copy clearing_house_commit.temp_tbl_relative_dates from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/submission_5_relative_date.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_relative_dates
    where relative_date_id in (select relative_date_id from clearing_house_commit.temp_tbl_relative_dates);

insert into public.tbl_relative_dates
    select *
    from clearing_house_commit.temp_tbl_relative_dates
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_relative_dates', 'relative_date_id');
\o

drop table if exists clearing_house_commit.temp_tbl_relative_dates;



/************************************************************************************************************************************
 ** sample_alt_ref
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sample_alt_refs;
create table clearing_house_commit.temp_tbl_sample_alt_refs as select * from public.tbl_sample_alt_refs where FALSE;

\copy clearing_house_commit.temp_tbl_sample_alt_refs from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/submission_5_sample_alt_ref.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sample_alt_refs
    where sample_alt_ref_id in (select sample_alt_ref_id from clearing_house_commit.temp_tbl_sample_alt_refs);

insert into public.tbl_sample_alt_refs
    select *
    from clearing_house_commit.temp_tbl_sample_alt_refs
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_sample_alt_refs', 'sample_alt_ref_id');
\o

drop table if exists clearing_house_commit.temp_tbl_sample_alt_refs;



/************************************************************************************************************************************
 ** sample_description
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sample_descriptions;
create table clearing_house_commit.temp_tbl_sample_descriptions as select * from public.tbl_sample_descriptions where FALSE;

\copy clearing_house_commit.temp_tbl_sample_descriptions from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/submission_5_sample_description.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sample_descriptions
    where sample_description_id in (select sample_description_id from clearing_house_commit.temp_tbl_sample_descriptions);

insert into public.tbl_sample_descriptions
    select *
    from clearing_house_commit.temp_tbl_sample_descriptions
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_sample_descriptions', 'sample_description_id');
\o

drop table if exists clearing_house_commit.temp_tbl_sample_descriptions;



/************************************************************************************************************************************
 ** sample_dimension
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sample_dimensions;
create table clearing_house_commit.temp_tbl_sample_dimensions as select * from public.tbl_sample_dimensions where FALSE;

\copy clearing_house_commit.temp_tbl_sample_dimensions from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/submission_5_sample_dimension.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sample_dimensions
    where sample_dimension_id in (select sample_dimension_id from clearing_house_commit.temp_tbl_sample_dimensions);

insert into public.tbl_sample_dimensions
    select *
    from clearing_house_commit.temp_tbl_sample_dimensions
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_sample_dimensions', 'sample_dimension_id');
\o

drop table if exists clearing_house_commit.temp_tbl_sample_dimensions;



/************************************************************************************************************************************
 ** sample_group_description
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sample_group_descriptions;
create table clearing_house_commit.temp_tbl_sample_group_descriptions as select * from public.tbl_sample_group_descriptions where FALSE;

\copy clearing_house_commit.temp_tbl_sample_group_descriptions from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/submission_5_sample_group_description.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sample_group_descriptions
    where sample_group_description_id in (select sample_group_description_id from clearing_house_commit.temp_tbl_sample_group_descriptions);

insert into public.tbl_sample_group_descriptions
    select *
    from clearing_house_commit.temp_tbl_sample_group_descriptions
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_sample_group_descriptions', 'sample_group_description_id');
\o

drop table if exists clearing_house_commit.temp_tbl_sample_group_descriptions;



/************************************************************************************************************************************
 ** sample_group_dimension
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sample_group_dimensions;
create table clearing_house_commit.temp_tbl_sample_group_dimensions as select * from public.tbl_sample_group_dimensions where FALSE;

\copy clearing_house_commit.temp_tbl_sample_group_dimensions from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/submission_5_sample_group_dimension.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sample_group_dimensions
    where sample_group_dimension_id in (select sample_group_dimension_id from clearing_house_commit.temp_tbl_sample_group_dimensions);

insert into public.tbl_sample_group_dimensions
    select *
    from clearing_house_commit.temp_tbl_sample_group_dimensions
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_sample_group_dimensions', 'sample_group_dimension_id');
\o

drop table if exists clearing_house_commit.temp_tbl_sample_group_dimensions;



/************************************************************************************************************************************
 ** site_location
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_site_locations;
create table clearing_house_commit.temp_tbl_site_locations as select * from public.tbl_site_locations where FALSE;

\copy clearing_house_commit.temp_tbl_site_locations from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/submission_5_site_location.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_site_locations
    where site_location_id in (select site_location_id from clearing_house_commit.temp_tbl_site_locations);

insert into public.tbl_site_locations
    select *
    from clearing_house_commit.temp_tbl_site_locations
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_site_locations', 'site_location_id');
\o

drop table if exists clearing_house_commit.temp_tbl_site_locations;



/************************************************************************************************************************************
 ** site_reference
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_site_references;
create table clearing_house_commit.temp_tbl_site_references as select * from public.tbl_site_references where FALSE;

\copy clearing_house_commit.temp_tbl_site_references from program 'zcat -qac 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/submission_5_site_reference.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_site_references
    where site_reference_id in (select site_reference_id from clearing_house_commit.temp_tbl_site_references);

insert into public.tbl_site_references
    select *
    from clearing_house_commit.temp_tbl_site_references
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_site_references', 'site_reference_id');
\o

drop table if exists clearing_house_commit.temp_tbl_site_references;


select clearing_house_commit.allocate_sequence_ids();
select clearing_house_commit.commit_submission('20200109_DML_SUBMISSION_CERAMICS_005_COMMIT');
commit;
