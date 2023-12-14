-- Deploy submissions: 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT
/***************************************************************************
Author         roger
Date
Description
Prerequisites
Reviewer
Approver
Idempotent     NO
Notes          Use --single-transaction on execute!
***************************************************************************/
\echo 'This submission is DEPRECATED (replaced by 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT)';

-- -- set constraints all deferred;
-- set client_min_messages to warning;
-- \set autocommit off;
-- begin;
-- \cd /repo/ceramics/deploy


-- /************************************************************************************************************************************
--  ** site
--  ************************************************************************************************************************************/

-- \echo 'Deploying site';

-- drop table if exists clearing_house_commit.temp_tbl_sites;
-- create table clearing_house_commit.temp_tbl_sites as select * from public.tbl_sites where FALSE;

-- \copy clearing_house_commit.temp_tbl_sites from program 'zcat -qac 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_site.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

-- delete from public.tbl_sites
--     where site_id in (select site_id from clearing_house_commit.temp_tbl_sites);

-- insert into public.tbl_sites
--     select *
--     from clearing_house_commit.temp_tbl_sites
--     /* on conflict (v_pk_name) update set list-of-all-fields */;

-- select clearing_house_commit.reset_serial_id('public', 'tbl_sites', 'site_id');

-- drop table if exists clearing_house_commit.temp_tbl_sites;



-- /************************************************************************************************************************************
--  ** feature
--  ************************************************************************************************************************************/

-- \echo 'Deploying feature';

-- drop table if exists clearing_house_commit.temp_tbl_features;
-- create table clearing_house_commit.temp_tbl_features as select * from public.tbl_features where FALSE;

-- \copy clearing_house_commit.temp_tbl_features from program 'zcat -qac 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_feature.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

-- delete from public.tbl_features
--     where feature_id in (select feature_id from clearing_house_commit.temp_tbl_features);

-- insert into public.tbl_features
--     select *
--     from clearing_house_commit.temp_tbl_features
--     /* on conflict (v_pk_name) update set list-of-all-fields */;

-- select clearing_house_commit.reset_serial_id('public', 'tbl_features', 'feature_id');

-- drop table if exists clearing_house_commit.temp_tbl_features;



-- /************************************************************************************************************************************
--  ** dataset
--  ************************************************************************************************************************************/

-- \echo 'Deploying dataset';

-- drop table if exists clearing_house_commit.temp_tbl_datasets;
-- create table clearing_house_commit.temp_tbl_datasets as select * from public.tbl_datasets where FALSE;

-- \copy clearing_house_commit.temp_tbl_datasets from program 'zcat -qac 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_dataset.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

-- delete from public.tbl_datasets
--     where dataset_id in (select dataset_id from clearing_house_commit.temp_tbl_datasets);

-- insert into public.tbl_datasets
--     select *
--     from clearing_house_commit.temp_tbl_datasets
--     /* on conflict (v_pk_name) update set list-of-all-fields */;

-- select clearing_house_commit.reset_serial_id('public', 'tbl_datasets', 'dataset_id');

-- drop table if exists clearing_house_commit.temp_tbl_datasets;



-- /************************************************************************************************************************************
--  ** dataset_contact
--  ************************************************************************************************************************************/

-- \echo 'Deploying dataset_contact';

-- drop table if exists clearing_house_commit.temp_tbl_dataset_contacts;
-- create table clearing_house_commit.temp_tbl_dataset_contacts as select * from public.tbl_dataset_contacts where FALSE;

-- \copy clearing_house_commit.temp_tbl_dataset_contacts from program 'zcat -qac 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_dataset_contact.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

-- delete from public.tbl_dataset_contacts
--     where dataset_contact_id in (select dataset_contact_id from clearing_house_commit.temp_tbl_dataset_contacts);

-- insert into public.tbl_dataset_contacts
--     select *
--     from clearing_house_commit.temp_tbl_dataset_contacts
--     /* on conflict (v_pk_name) update set list-of-all-fields */;

-- select clearing_house_commit.reset_serial_id('public', 'tbl_dataset_contacts', 'dataset_contact_id');

-- drop table if exists clearing_house_commit.temp_tbl_dataset_contacts;



-- /************************************************************************************************************************************
--  ** dataset_submission
--  ************************************************************************************************************************************/

-- \echo 'Deploying dataset_submission';

-- drop table if exists clearing_house_commit.temp_tbl_dataset_submissions;
-- create table clearing_house_commit.temp_tbl_dataset_submissions as select * from public.tbl_dataset_submissions where FALSE;

-- \copy clearing_house_commit.temp_tbl_dataset_submissions from program 'zcat -qac 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_dataset_submission.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

-- delete from public.tbl_dataset_submissions
--     where dataset_submission_id in (select dataset_submission_id from clearing_house_commit.temp_tbl_dataset_submissions);

-- insert into public.tbl_dataset_submissions
--     select *
--     from clearing_house_commit.temp_tbl_dataset_submissions
--     /* on conflict (v_pk_name) update set list-of-all-fields */;

-- select clearing_house_commit.reset_serial_id('public', 'tbl_dataset_submissions', 'dataset_submission_id');

-- drop table if exists clearing_house_commit.temp_tbl_dataset_submissions;



-- /************************************************************************************************************************************
--  ** sample_group_description_type_sampling_context
--  ************************************************************************************************************************************/

-- \echo 'Deploying sample_group_description_type_sampling_context';

-- drop table if exists clearing_house_commit.temp_tbl_sample_group_description_type_sampling_contexts;
-- create table clearing_house_commit.temp_tbl_sample_group_description_type_sampling_contexts as select * from public.tbl_sample_group_description_type_sampling_contexts where FALSE;

-- \copy clearing_house_commit.temp_tbl_sample_group_description_type_sampling_contexts from program 'zcat -qac 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_sample_group_description_type_sampling_context.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

-- delete from public.tbl_sample_group_description_type_sampling_contexts
--     where sample_group_description_type_sampling_context_id in (select sample_group_description_type_sampling_context_id from clearing_house_commit.temp_tbl_sample_group_description_type_sampling_contexts);

-- insert into public.tbl_sample_group_description_type_sampling_contexts
--     select *
--     from clearing_house_commit.temp_tbl_sample_group_description_type_sampling_contexts
--     /* on conflict (v_pk_name) update set list-of-all-fields */;

-- select clearing_house_commit.reset_serial_id('public', 'tbl_sample_group_description_type_sampling_contexts', 'sample_group_description_type_sampling_context_id');

-- drop table if exists clearing_house_commit.temp_tbl_sample_group_description_type_sampling_contexts;



-- /************************************************************************************************************************************
--  ** sample_group
--  ************************************************************************************************************************************/

-- \echo 'Deploying sample_group';

-- drop table if exists clearing_house_commit.temp_tbl_sample_groups;
-- create table clearing_house_commit.temp_tbl_sample_groups as select * from public.tbl_sample_groups where FALSE;

-- \copy clearing_house_commit.temp_tbl_sample_groups from program 'zcat -qac 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_sample_group.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

-- delete from public.tbl_sample_groups
--     where sample_group_id in (select sample_group_id from clearing_house_commit.temp_tbl_sample_groups);

-- insert into public.tbl_sample_groups
--     select *
--     from clearing_house_commit.temp_tbl_sample_groups
--     /* on conflict (v_pk_name) update set list-of-all-fields */;

-- select clearing_house_commit.reset_serial_id('public', 'tbl_sample_groups', 'sample_group_id');

-- drop table if exists clearing_house_commit.temp_tbl_sample_groups;



-- /************************************************************************************************************************************
--  ** physical_sample
--  ************************************************************************************************************************************/

-- \echo 'Deploying physical_sample';

-- drop table if exists clearing_house_commit.temp_tbl_physical_samples;
-- create table clearing_house_commit.temp_tbl_physical_samples as select * from public.tbl_physical_samples where FALSE;

-- \copy clearing_house_commit.temp_tbl_physical_samples from program 'zcat -qac 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_physical_sample.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

-- delete from public.tbl_physical_samples
--     where physical_sample_id in (select physical_sample_id from clearing_house_commit.temp_tbl_physical_samples);

-- insert into public.tbl_physical_samples
--     select *
--     from clearing_house_commit.temp_tbl_physical_samples
--     /* on conflict (v_pk_name) update set list-of-all-fields */;

-- select clearing_house_commit.reset_serial_id('public', 'tbl_physical_samples', 'physical_sample_id');

-- drop table if exists clearing_house_commit.temp_tbl_physical_samples;



-- /************************************************************************************************************************************
--  ** analysis_entity
--  ************************************************************************************************************************************/

-- \echo 'Deploying analysis_entity';

-- drop table if exists clearing_house_commit.temp_tbl_analysis_entities;
-- create table clearing_house_commit.temp_tbl_analysis_entities as select * from public.tbl_analysis_entities where FALSE;

-- \copy clearing_house_commit.temp_tbl_analysis_entities from program 'zcat -qac 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_analysis_entity.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

-- delete from public.tbl_analysis_entities
--     where analysis_entity_id in (select analysis_entity_id from clearing_house_commit.temp_tbl_analysis_entities);

-- insert into public.tbl_analysis_entities
--     select *
--     from clearing_house_commit.temp_tbl_analysis_entities
--     /* on conflict (v_pk_name) update set list-of-all-fields */;

-- select clearing_house_commit.reset_serial_id('public', 'tbl_analysis_entities', 'analysis_entity_id');

-- drop table if exists clearing_house_commit.temp_tbl_analysis_entities;



-- /************************************************************************************************************************************
--  ** ceramic
--  ************************************************************************************************************************************/

-- \echo 'Deploying ceramic';

-- drop table if exists clearing_house_commit.temp_tbl_ceramics;
-- create table clearing_house_commit.temp_tbl_ceramics as select * from public.tbl_ceramics where FALSE;

-- \copy clearing_house_commit.temp_tbl_ceramics from program 'zcat -qac 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_ceramic.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

-- delete from public.tbl_ceramics
--     where ceramics_id in (select ceramics_id from clearing_house_commit.temp_tbl_ceramics);

-- insert into public.tbl_ceramics
--     select *
--     from clearing_house_commit.temp_tbl_ceramics
--     /* on conflict (v_pk_name) update set list-of-all-fields */;

-- select clearing_house_commit.reset_serial_id('public', 'tbl_ceramics', 'ceramics_id');

-- drop table if exists clearing_house_commit.temp_tbl_ceramics;



-- /************************************************************************************************************************************
--  ** physical_sample_feature
--  ************************************************************************************************************************************/

-- \echo 'Deploying physical_sample_feature';

-- drop table if exists clearing_house_commit.temp_tbl_physical_sample_features;
-- create table clearing_house_commit.temp_tbl_physical_sample_features as select * from public.tbl_physical_sample_features where FALSE;

-- \copy clearing_house_commit.temp_tbl_physical_sample_features from program 'zcat -qac 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_physical_sample_feature.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

-- delete from public.tbl_physical_sample_features
--     where physical_sample_feature_id in (select physical_sample_feature_id from clearing_house_commit.temp_tbl_physical_sample_features);

-- insert into public.tbl_physical_sample_features
--     select *
--     from clearing_house_commit.temp_tbl_physical_sample_features
--     /* on conflict (v_pk_name) update set list-of-all-fields */;

-- select clearing_house_commit.reset_serial_id('public', 'tbl_physical_sample_features', 'physical_sample_feature_id');

-- drop table if exists clearing_house_commit.temp_tbl_physical_sample_features;



-- /************************************************************************************************************************************
--  ** relative_date
--  ************************************************************************************************************************************/

-- \echo 'Deploying relative_date';

-- drop table if exists clearing_house_commit.temp_tbl_relative_dates;
-- create table clearing_house_commit.temp_tbl_relative_dates as select * from public.tbl_relative_dates where FALSE;

-- \copy clearing_house_commit.temp_tbl_relative_dates from program 'zcat -qac 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_relative_date.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

-- delete from public.tbl_relative_dates
--     where relative_date_id in (select relative_date_id from clearing_house_commit.temp_tbl_relative_dates);

-- insert into public.tbl_relative_dates
--     select *
--     from clearing_house_commit.temp_tbl_relative_dates
--     /* on conflict (v_pk_name) update set list-of-all-fields */;

-- select clearing_house_commit.reset_serial_id('public', 'tbl_relative_dates', 'relative_date_id');

-- drop table if exists clearing_house_commit.temp_tbl_relative_dates;



-- /************************************************************************************************************************************
--  ** sample_alt_ref
--  ************************************************************************************************************************************/

-- \echo 'Deploying sample_alt_ref';

-- drop table if exists clearing_house_commit.temp_tbl_sample_alt_refs;
-- create table clearing_house_commit.temp_tbl_sample_alt_refs as select * from public.tbl_sample_alt_refs where FALSE;

-- \copy clearing_house_commit.temp_tbl_sample_alt_refs from program 'zcat -qac 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_sample_alt_ref.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

-- delete from public.tbl_sample_alt_refs
--     where sample_alt_ref_id in (select sample_alt_ref_id from clearing_house_commit.temp_tbl_sample_alt_refs);

-- insert into public.tbl_sample_alt_refs
--     select *
--     from clearing_house_commit.temp_tbl_sample_alt_refs
--     /* on conflict (v_pk_name) update set list-of-all-fields */;

-- select clearing_house_commit.reset_serial_id('public', 'tbl_sample_alt_refs', 'sample_alt_ref_id');

-- drop table if exists clearing_house_commit.temp_tbl_sample_alt_refs;



-- /************************************************************************************************************************************
--  ** sample_description
--  ************************************************************************************************************************************/

-- \echo 'Deploying sample_description';

-- drop table if exists clearing_house_commit.temp_tbl_sample_descriptions;
-- create table clearing_house_commit.temp_tbl_sample_descriptions as select * from public.tbl_sample_descriptions where FALSE;

-- \copy clearing_house_commit.temp_tbl_sample_descriptions from program 'zcat -qac 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_sample_description.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

-- delete from public.tbl_sample_descriptions
--     where sample_description_id in (select sample_description_id from clearing_house_commit.temp_tbl_sample_descriptions);

-- insert into public.tbl_sample_descriptions
--     select *
--     from clearing_house_commit.temp_tbl_sample_descriptions
--     /* on conflict (v_pk_name) update set list-of-all-fields */;

-- select clearing_house_commit.reset_serial_id('public', 'tbl_sample_descriptions', 'sample_description_id');

-- drop table if exists clearing_house_commit.temp_tbl_sample_descriptions;



-- /************************************************************************************************************************************
--  ** sample_group_dimension
--  ************************************************************************************************************************************/

-- \echo 'Deploying sample_group_dimension';

-- drop table if exists clearing_house_commit.temp_tbl_sample_group_dimensions;
-- create table clearing_house_commit.temp_tbl_sample_group_dimensions as select * from public.tbl_sample_group_dimensions where FALSE;

-- \copy clearing_house_commit.temp_tbl_sample_group_dimensions from program 'zcat -qac 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_sample_group_dimension.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

-- delete from public.tbl_sample_group_dimensions
--     where sample_group_dimension_id in (select sample_group_dimension_id from clearing_house_commit.temp_tbl_sample_group_dimensions);

-- insert into public.tbl_sample_group_dimensions
--     select *
--     from clearing_house_commit.temp_tbl_sample_group_dimensions
--     /* on conflict (v_pk_name) update set list-of-all-fields */;

-- select clearing_house_commit.reset_serial_id('public', 'tbl_sample_group_dimensions', 'sample_group_dimension_id');

-- drop table if exists clearing_house_commit.temp_tbl_sample_group_dimensions;



-- /************************************************************************************************************************************
--  ** site_location
--  ************************************************************************************************************************************/

-- \echo 'Deploying site_location';

-- drop table if exists clearing_house_commit.temp_tbl_site_locations;
-- create table clearing_house_commit.temp_tbl_site_locations as select * from public.tbl_site_locations where FALSE;

-- \copy clearing_house_commit.temp_tbl_site_locations from program 'zcat -qac 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_site_location.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

-- delete from public.tbl_site_locations
--     where site_location_id in (select site_location_id from clearing_house_commit.temp_tbl_site_locations);

-- insert into public.tbl_site_locations
--     select *
--     from clearing_house_commit.temp_tbl_site_locations
--     /* on conflict (v_pk_name) update set list-of-all-fields */;

-- select clearing_house_commit.reset_serial_id('public', 'tbl_site_locations', 'site_location_id');

-- drop table if exists clearing_house_commit.temp_tbl_site_locations;



-- /************************************************************************************************************************************
--  ** site_reference
--  ************************************************************************************************************************************/

-- \echo 'Deploying site_reference';

-- drop table if exists clearing_house_commit.temp_tbl_site_references;
-- create table clearing_house_commit.temp_tbl_site_references as select * from public.tbl_site_references where FALSE;

-- \copy clearing_house_commit.temp_tbl_site_references from program 'zcat -qac 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_site_reference.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

-- delete from public.tbl_site_references
--     where site_reference_id in (select site_reference_id from clearing_house_commit.temp_tbl_site_references);

-- insert into public.tbl_site_references
--     select *
--     from clearing_house_commit.temp_tbl_site_references
--     /* on conflict (v_pk_name) update set list-of-all-fields */;

-- select clearing_house_commit.reset_serial_id('public', 'tbl_site_references', 'site_reference_id');

-- drop table if exists clearing_house_commit.temp_tbl_site_references;


-- select clearing_house_commit.allocate_sequence_ids();
-- select clearing_house_commit.commit_submission(1);
-- commit;
