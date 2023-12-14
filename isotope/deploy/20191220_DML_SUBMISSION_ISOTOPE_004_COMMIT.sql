-- Deploy isotope: 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT
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
set client_min_messages to warning;
\set autocommit off;

begin;

set constraints all deferred;

\cd /repo/isotope/deploy

/************************************************************************************************************************************
 ** method_group
 ************************************************************************************************************************************/

\echo 'Deploying method_group';

drop table if exists clearing_house_commit.temp_tbl_method_groups;
create table clearing_house_commit.temp_tbl_method_groups as select * from public.tbl_method_groups where FALSE;

\copy clearing_house_commit.temp_tbl_method_groups from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_method_group.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_method_groups
    where method_group_id in (select method_group_id from clearing_house_commit.temp_tbl_method_groups);

insert into public.tbl_method_groups
    select *
    from clearing_house_commit.temp_tbl_method_groups
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_method_groups', 'method_group_id');

drop table if exists clearing_house_commit.temp_tbl_method_groups;



/************************************************************************************************************************************
 ** site
 ************************************************************************************************************************************/

\echo 'Deploying site';

drop table if exists clearing_house_commit.temp_tbl_sites;
create table clearing_house_commit.temp_tbl_sites as select * from public.tbl_sites where FALSE;

\copy clearing_house_commit.temp_tbl_sites from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_site.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sites
    where site_id in (select site_id from clearing_house_commit.temp_tbl_sites);

insert into public.tbl_sites
    select *
    from clearing_house_commit.temp_tbl_sites
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_sites', 'site_id');

drop table if exists clearing_house_commit.temp_tbl_sites;



/************************************************************************************************************************************
 ** unit
 ************************************************************************************************************************************/

\echo 'Deploying unit';

drop table if exists clearing_house_commit.temp_tbl_units;
create table clearing_house_commit.temp_tbl_units as select * from public.tbl_units where FALSE;

\copy clearing_house_commit.temp_tbl_units from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_unit.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_units
    where unit_id in (select unit_id from clearing_house_commit.temp_tbl_units);

insert into public.tbl_units
    select *
    from clearing_house_commit.temp_tbl_units
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_units', 'unit_id');

drop table if exists clearing_house_commit.temp_tbl_units;



/************************************************************************************************************************************
 ** sample_type
 ************************************************************************************************************************************/

\echo 'Deploying sample_type';

drop table if exists clearing_house_commit.temp_tbl_sample_types;
create table clearing_house_commit.temp_tbl_sample_types as select * from public.tbl_sample_types where FALSE;

\copy clearing_house_commit.temp_tbl_sample_types from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_sample_type.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sample_types
    where sample_type_id in (select sample_type_id from clearing_house_commit.temp_tbl_sample_types);

insert into public.tbl_sample_types
    select *
    from clearing_house_commit.temp_tbl_sample_types
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_sample_types', 'sample_type_id');

drop table if exists clearing_house_commit.temp_tbl_sample_types;



/************************************************************************************************************************************
 ** feature
 ************************************************************************************************************************************/

\echo 'Deploying feature';

drop table if exists clearing_house_commit.temp_tbl_features;
create table clearing_house_commit.temp_tbl_features as select * from public.tbl_features where FALSE;

\copy clearing_house_commit.temp_tbl_features from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_feature.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_features
    where feature_id in (select feature_id from clearing_house_commit.temp_tbl_features);

insert into public.tbl_features
    select *
    from clearing_house_commit.temp_tbl_features
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_features', 'feature_id');

drop table if exists clearing_house_commit.temp_tbl_features;



/************************************************************************************************************************************
 ** method
 ************************************************************************************************************************************/

\echo 'Deploying method';

drop table if exists clearing_house_commit.temp_tbl_methods;
create table clearing_house_commit.temp_tbl_methods as select * from public.tbl_methods where FALSE;

\copy clearing_house_commit.temp_tbl_methods from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_method.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_methods
    where method_id in (select method_id from clearing_house_commit.temp_tbl_methods);

insert into public.tbl_methods
    select *
    from clearing_house_commit.temp_tbl_methods
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_methods', 'method_id');

drop table if exists clearing_house_commit.temp_tbl_methods;



/************************************************************************************************************************************
 ** isotope_measurement
 ************************************************************************************************************************************/

\echo 'Deploying isotope_measurement';

drop table if exists clearing_house_commit.temp_tbl_isotope_measurements;
create table clearing_house_commit.temp_tbl_isotope_measurements as select * from public.tbl_isotope_measurements where FALSE;

\copy clearing_house_commit.temp_tbl_isotope_measurements from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_isotope_measurement.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_isotope_measurements
    where isotope_measurement_id in (select isotope_measurement_id from clearing_house_commit.temp_tbl_isotope_measurements);

insert into public.tbl_isotope_measurements
    select *
    from clearing_house_commit.temp_tbl_isotope_measurements
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_isotope_measurements', 'isotope_measurement_id');

drop table if exists clearing_house_commit.temp_tbl_isotope_measurements;



/************************************************************************************************************************************
 ** dataset
 ************************************************************************************************************************************/

\echo 'Deploying dataset';

drop table if exists clearing_house_commit.temp_tbl_datasets;
create table clearing_house_commit.temp_tbl_datasets as select * from public.tbl_datasets where FALSE;

\copy clearing_house_commit.temp_tbl_datasets from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_dataset.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_datasets
    where dataset_id in (select dataset_id from clearing_house_commit.temp_tbl_datasets);

insert into public.tbl_datasets(dataset_id, master_set_id, data_type_id, method_id, biblio_id, updated_dataset_id, project_id, dataset_name, date_updated)
    select dataset_id, master_set_id, data_type_id, method_id, biblio_id, updated_dataset_id, 0, dataset_name, date_updated
    from clearing_house_commit.temp_tbl_datasets
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_datasets', 'dataset_id');

drop table if exists clearing_house_commit.temp_tbl_datasets;



/************************************************************************************************************************************
 ** dataset_contact
 ************************************************************************************************************************************/

\echo 'Deploying dataset_contact';

drop table if exists clearing_house_commit.temp_tbl_dataset_contacts;
create table clearing_house_commit.temp_tbl_dataset_contacts as select * from public.tbl_dataset_contacts where FALSE;

\copy clearing_house_commit.temp_tbl_dataset_contacts from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_dataset_contact.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_dataset_contacts
    where dataset_contact_id in (select dataset_contact_id from clearing_house_commit.temp_tbl_dataset_contacts);

insert into public.tbl_dataset_contacts
    select *
    from clearing_house_commit.temp_tbl_dataset_contacts
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_dataset_contacts', 'dataset_contact_id');

drop table if exists clearing_house_commit.temp_tbl_dataset_contacts;



/************************************************************************************************************************************
 ** dataset_submission
 ************************************************************************************************************************************/

\echo 'Deploying dataset_submission';

drop table if exists clearing_house_commit.temp_tbl_dataset_submissions;
create table clearing_house_commit.temp_tbl_dataset_submissions as select * from public.tbl_dataset_submissions where FALSE;

\copy clearing_house_commit.temp_tbl_dataset_submissions from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_dataset_submission.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_dataset_submissions
    where dataset_submission_id in (select dataset_submission_id from clearing_house_commit.temp_tbl_dataset_submissions);

insert into public.tbl_dataset_submissions
    select *
    from clearing_house_commit.temp_tbl_dataset_submissions
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_dataset_submissions', 'dataset_submission_id');

drop table if exists clearing_house_commit.temp_tbl_dataset_submissions;



/************************************************************************************************************************************
 ** relative_age
 ************************************************************************************************************************************/

\echo 'Deploying relative_age';

drop table if exists clearing_house_commit.temp_tbl_relative_ages;
create table clearing_house_commit.temp_tbl_relative_ages as select * from public.tbl_relative_ages where FALSE;

\copy clearing_house_commit.temp_tbl_relative_ages from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_relative_age.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_relative_ages
    where relative_age_id in (select relative_age_id from clearing_house_commit.temp_tbl_relative_ages);

insert into public.tbl_relative_ages
    select *
    from clearing_house_commit.temp_tbl_relative_ages
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_relative_ages', 'relative_age_id');

drop table if exists clearing_house_commit.temp_tbl_relative_ages;



/************************************************************************************************************************************
 ** relative_age_ref
 ************************************************************************************************************************************/

\echo 'Deploying relative_age_ref';

drop table if exists clearing_house_commit.temp_tbl_relative_age_refs;
create table clearing_house_commit.temp_tbl_relative_age_refs as select * from public.tbl_relative_age_refs where FALSE;

\copy clearing_house_commit.temp_tbl_relative_age_refs from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_relative_age_ref.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_relative_age_refs
    where relative_age_ref_id in (select relative_age_ref_id from clearing_house_commit.temp_tbl_relative_age_refs);

insert into public.tbl_relative_age_refs
    select *
    from clearing_house_commit.temp_tbl_relative_age_refs
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_relative_age_refs', 'relative_age_ref_id');

drop table if exists clearing_house_commit.temp_tbl_relative_age_refs;



/************************************************************************************************************************************
 ** sample_group
 ************************************************************************************************************************************/

\echo 'Deploying sample_group';

drop table if exists clearing_house_commit.temp_tbl_sample_groups;
create table clearing_house_commit.temp_tbl_sample_groups as select * from public.tbl_sample_groups where FALSE;

\copy clearing_house_commit.temp_tbl_sample_groups from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_sample_group.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sample_groups
    where sample_group_id in (select sample_group_id from clearing_house_commit.temp_tbl_sample_groups);

insert into public.tbl_sample_groups
    select *
    from clearing_house_commit.temp_tbl_sample_groups
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_sample_groups', 'sample_group_id');

drop table if exists clearing_house_commit.temp_tbl_sample_groups;



/************************************************************************************************************************************
 ** physical_sample
 ************************************************************************************************************************************/

\echo 'Deploying physical_sample';

drop table if exists clearing_house_commit.temp_tbl_physical_samples;
create table clearing_house_commit.temp_tbl_physical_samples as select * from public.tbl_physical_samples where FALSE;

\copy clearing_house_commit.temp_tbl_physical_samples from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_physical_sample.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_physical_samples
    where physical_sample_id in (select physical_sample_id from clearing_house_commit.temp_tbl_physical_samples);

insert into public.tbl_physical_samples
    select *
    from clearing_house_commit.temp_tbl_physical_samples
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_physical_samples', 'physical_sample_id');

drop table if exists clearing_house_commit.temp_tbl_physical_samples;



/************************************************************************************************************************************
 ** analysis_entity
 ************************************************************************************************************************************/

\echo 'Deploying analysis_entity';

drop table if exists clearing_house_commit.temp_tbl_analysis_entities;
create table clearing_house_commit.temp_tbl_analysis_entities as select * from public.tbl_analysis_entities where FALSE;

\copy clearing_house_commit.temp_tbl_analysis_entities from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_analysis_entity.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_analysis_entities
    where analysis_entity_id in (select analysis_entity_id from clearing_house_commit.temp_tbl_analysis_entities);

insert into public.tbl_analysis_entities
    select *
    from clearing_house_commit.temp_tbl_analysis_entities
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_analysis_entities', 'analysis_entity_id');

drop table if exists clearing_house_commit.temp_tbl_analysis_entities;



/************************************************************************************************************************************
 ** analysis_entity_prep_method
 ************************************************************************************************************************************/

\echo 'Deploying analysis_entity_prep_method';

drop table if exists clearing_house_commit.temp_tbl_analysis_entity_prep_methods;
create table clearing_house_commit.temp_tbl_analysis_entity_prep_methods as select * from public.tbl_analysis_entity_prep_methods where FALSE;

\copy clearing_house_commit.temp_tbl_analysis_entity_prep_methods from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_analysis_entity_prep_method.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_analysis_entity_prep_methods
    where analysis_entity_prep_method_id in (select analysis_entity_prep_method_id from clearing_house_commit.temp_tbl_analysis_entity_prep_methods);

insert into public.tbl_analysis_entity_prep_methods
    select *
    from clearing_house_commit.temp_tbl_analysis_entity_prep_methods
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_analysis_entity_prep_methods', 'analysis_entity_prep_method_id');

drop table if exists clearing_house_commit.temp_tbl_analysis_entity_prep_methods;



/************************************************************************************************************************************
 ** isotope
 ************************************************************************************************************************************/

\echo 'Deploying isotope';

drop table if exists clearing_house_commit.temp_tbl_isotopes;
create table clearing_house_commit.temp_tbl_isotopes as select * from public.tbl_isotopes where FALSE;

\copy clearing_house_commit.temp_tbl_isotopes from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_isotope.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_isotopes
    where isotope_id in (select isotope_id from clearing_house_commit.temp_tbl_isotopes);

insert into public.tbl_isotopes
    select *
    from clearing_house_commit.temp_tbl_isotopes
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_isotopes', 'isotope_id');

drop table if exists clearing_house_commit.temp_tbl_isotopes;



/************************************************************************************************************************************
 ** physical_sample_feature
 ************************************************************************************************************************************/

\echo 'Deploying physical_sample_feature';

drop table if exists clearing_house_commit.temp_tbl_physical_sample_features;
create table clearing_house_commit.temp_tbl_physical_sample_features as select * from public.tbl_physical_sample_features where FALSE;

\copy clearing_house_commit.temp_tbl_physical_sample_features from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_physical_sample_feature.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_physical_sample_features
    where physical_sample_feature_id in (select physical_sample_feature_id from clearing_house_commit.temp_tbl_physical_sample_features);

insert into public.tbl_physical_sample_features
    select *
    from clearing_house_commit.temp_tbl_physical_sample_features
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_physical_sample_features', 'physical_sample_feature_id');

drop table if exists clearing_house_commit.temp_tbl_physical_sample_features;



/************************************************************************************************************************************
 ** relative_date
 ************************************************************************************************************************************/

\echo 'Deploying relative_date';

drop table if exists clearing_house_commit.temp_tbl_relative_dates;
create table clearing_house_commit.temp_tbl_relative_dates as select * from public.tbl_relative_dates where FALSE;

\copy clearing_house_commit.temp_tbl_relative_dates from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_relative_date.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_relative_dates
    where relative_date_id in (select relative_date_id from clearing_house_commit.temp_tbl_relative_dates);

insert into public.tbl_relative_dates
    select *
    from clearing_house_commit.temp_tbl_relative_dates
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_relative_dates', 'relative_date_id');

drop table if exists clearing_house_commit.temp_tbl_relative_dates;



/************************************************************************************************************************************
 ** sample_alt_ref
 ************************************************************************************************************************************/

\echo 'Deploying sample_alt_ref';

drop table if exists clearing_house_commit.temp_tbl_sample_alt_refs;
create table clearing_house_commit.temp_tbl_sample_alt_refs as select * from public.tbl_sample_alt_refs where FALSE;

\copy clearing_house_commit.temp_tbl_sample_alt_refs from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_sample_alt_ref.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sample_alt_refs
    where sample_alt_ref_id in (select sample_alt_ref_id from clearing_house_commit.temp_tbl_sample_alt_refs);

insert into public.tbl_sample_alt_refs
    select *
    from clearing_house_commit.temp_tbl_sample_alt_refs
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_sample_alt_refs', 'sample_alt_ref_id');

drop table if exists clearing_house_commit.temp_tbl_sample_alt_refs;



/************************************************************************************************************************************
 ** sample_description
 ************************************************************************************************************************************/

\echo 'Deploying sample_description';

drop table if exists clearing_house_commit.temp_tbl_sample_descriptions;
create table clearing_house_commit.temp_tbl_sample_descriptions as select * from public.tbl_sample_descriptions where FALSE;

\copy clearing_house_commit.temp_tbl_sample_descriptions from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_sample_description.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sample_descriptions
    where sample_description_id in (select sample_description_id from clearing_house_commit.temp_tbl_sample_descriptions);

insert into public.tbl_sample_descriptions
    select *
    from clearing_house_commit.temp_tbl_sample_descriptions
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_sample_descriptions', 'sample_description_id');

drop table if exists clearing_house_commit.temp_tbl_sample_descriptions;



/************************************************************************************************************************************
 ** sample_group_description
 ************************************************************************************************************************************/

\echo 'Deploying sample_group_description';

drop table if exists clearing_house_commit.temp_tbl_sample_group_descriptions;
create table clearing_house_commit.temp_tbl_sample_group_descriptions as select * from public.tbl_sample_group_descriptions where FALSE;

\copy clearing_house_commit.temp_tbl_sample_group_descriptions from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_sample_group_description.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sample_group_descriptions
    where sample_group_description_id in (select sample_group_description_id from clearing_house_commit.temp_tbl_sample_group_descriptions);

insert into public.tbl_sample_group_descriptions
    select *
    from clearing_house_commit.temp_tbl_sample_group_descriptions
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_sample_group_descriptions', 'sample_group_description_id');

drop table if exists clearing_house_commit.temp_tbl_sample_group_descriptions;



/************************************************************************************************************************************
 ** sample_location
 ************************************************************************************************************************************/

\echo 'Deploying sample_location';

drop table if exists clearing_house_commit.temp_tbl_sample_locations;
create table clearing_house_commit.temp_tbl_sample_locations as select * from public.tbl_sample_locations where FALSE;

\copy clearing_house_commit.temp_tbl_sample_locations from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_sample_location.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sample_locations
    where sample_location_id in (select sample_location_id from clearing_house_commit.temp_tbl_sample_locations);

insert into public.tbl_sample_locations
    select *
    from clearing_house_commit.temp_tbl_sample_locations
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_sample_locations', 'sample_location_id');

drop table if exists clearing_house_commit.temp_tbl_sample_locations;



/************************************************************************************************************************************
 ** sample_note
 ************************************************************************************************************************************/

\echo 'Deploying sample_note';

drop table if exists clearing_house_commit.temp_tbl_sample_notes;
create table clearing_house_commit.temp_tbl_sample_notes as select * from public.tbl_sample_notes where FALSE;

\copy clearing_house_commit.temp_tbl_sample_notes from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_sample_note.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sample_notes
    where sample_note_id in (select sample_note_id from clearing_house_commit.temp_tbl_sample_notes);

insert into public.tbl_sample_notes
    select *
    from clearing_house_commit.temp_tbl_sample_notes
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_sample_notes', 'sample_note_id');

drop table if exists clearing_house_commit.temp_tbl_sample_notes;



/************************************************************************************************************************************
 ** site_location
 ************************************************************************************************************************************/

\echo 'Deploying site_location';

drop table if exists clearing_house_commit.temp_tbl_site_locations;
create table clearing_house_commit.temp_tbl_site_locations as select * from public.tbl_site_locations where FALSE;

\copy clearing_house_commit.temp_tbl_site_locations from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_site_location.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_site_locations
    where site_location_id in (select site_location_id from clearing_house_commit.temp_tbl_site_locations);

insert into public.tbl_site_locations
    select *
    from clearing_house_commit.temp_tbl_site_locations
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_site_locations', 'site_location_id');

drop table if exists clearing_house_commit.temp_tbl_site_locations;



/************************************************************************************************************************************
 ** site_reference
 ************************************************************************************************************************************/

\echo 'Deploying site_reference';

drop table if exists clearing_house_commit.temp_tbl_site_references;
create table clearing_house_commit.temp_tbl_site_references as select * from public.tbl_site_references where FALSE;

\copy clearing_house_commit.temp_tbl_site_references from program 'zcat -qac 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_site_reference.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_site_references
    where site_reference_id in (select site_reference_id from clearing_house_commit.temp_tbl_site_references);

insert into public.tbl_site_references
    select *
    from clearing_house_commit.temp_tbl_site_references
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_site_references', 'site_reference_id');

drop table if exists clearing_house_commit.temp_tbl_site_references;


select clearing_house_commit.allocate_sequence_ids();
select clearing_house_commit.commit_submission(4);
commit;
