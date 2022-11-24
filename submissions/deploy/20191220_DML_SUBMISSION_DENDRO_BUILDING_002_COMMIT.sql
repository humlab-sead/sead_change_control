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

\cd /repo/submissions/deploy


/************************************************************************************************************************************
 ** site
 ************************************************************************************************************************************/

\echo 'Deploying site';

drop table if exists clearing_house_commit.temp_tbl_sites;
create table clearing_house_commit.temp_tbl_sites as select * from public.tbl_sites where FALSE;

\copy clearing_house_commit.temp_tbl_sites from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_site.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sites
    where site_id in (select site_id from clearing_house_commit.temp_tbl_sites);

insert into public.tbl_sites
    select *
    from clearing_house_commit.temp_tbl_sites
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_sites', 'site_id');

drop table if exists clearing_house_commit.temp_tbl_sites;



/************************************************************************************************************************************
 ** dataset_submission_type
 ************************************************************************************************************************************/

\echo 'Deploying dataset_submission_type';

drop table if exists clearing_house_commit.temp_tbl_dataset_submission_types;
create table clearing_house_commit.temp_tbl_dataset_submission_types as select * from public.tbl_dataset_submission_types where FALSE;

\copy clearing_house_commit.temp_tbl_dataset_submission_types from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_dataset_submission_type.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_dataset_submission_types
    where submission_type_id in (select submission_type_id from clearing_house_commit.temp_tbl_dataset_submission_types);

insert into public.tbl_dataset_submission_types
    select *
    from clearing_house_commit.temp_tbl_dataset_submission_types
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_dataset_submission_types', 'submission_type_id');

drop table if exists clearing_house_commit.temp_tbl_dataset_submission_types;



/************************************************************************************************************************************
 ** sample_group_description_type
 ************************************************************************************************************************************/

\echo 'Deploying sample_group_description_type';

drop table if exists clearing_house_commit.temp_tbl_sample_group_description_types;
create table clearing_house_commit.temp_tbl_sample_group_description_types as select * from public.tbl_sample_group_description_types where FALSE;

\copy clearing_house_commit.temp_tbl_sample_group_description_types from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_sample_group_description_type.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sample_group_description_types
    where sample_group_description_type_id in (select sample_group_description_type_id from clearing_house_commit.temp_tbl_sample_group_description_types);

insert into public.tbl_sample_group_description_types
    select *
    from clearing_house_commit.temp_tbl_sample_group_description_types
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_sample_group_description_types', 'sample_group_description_type_id');

drop table if exists clearing_house_commit.temp_tbl_sample_group_description_types;



/************************************************************************************************************************************
 ** project
 ************************************************************************************************************************************/

\echo 'Deploying project';

drop table if exists clearing_house_commit.temp_tbl_projects;
create table clearing_house_commit.temp_tbl_projects as select * from public.tbl_projects where FALSE;

\copy clearing_house_commit.temp_tbl_projects from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_project.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_projects
    where project_id in (select project_id from clearing_house_commit.temp_tbl_projects);

insert into public.tbl_projects
    select *
    from clearing_house_commit.temp_tbl_projects
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_projects', 'project_id');

drop table if exists clearing_house_commit.temp_tbl_projects;



/************************************************************************************************************************************
 ** dataset
 ************************************************************************************************************************************/

\echo 'Deploying dataset';

drop table if exists clearing_house_commit.temp_tbl_datasets;
create table clearing_house_commit.temp_tbl_datasets as select * from public.tbl_datasets where FALSE;

\copy clearing_house_commit.temp_tbl_datasets from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_dataset.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_datasets
    where dataset_id in (select dataset_id from clearing_house_commit.temp_tbl_datasets);

insert into public.tbl_datasets
    select *
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

\copy clearing_house_commit.temp_tbl_dataset_contacts from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_dataset_contact.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

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

\copy clearing_house_commit.temp_tbl_dataset_submissions from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_dataset_submission.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_dataset_submissions
    where dataset_submission_id in (select dataset_submission_id from clearing_house_commit.temp_tbl_dataset_submissions);

insert into public.tbl_dataset_submissions
    select *
    from clearing_house_commit.temp_tbl_dataset_submissions
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_dataset_submissions', 'dataset_submission_id');

drop table if exists clearing_house_commit.temp_tbl_dataset_submissions;



/************************************************************************************************************************************
 ** sample_group_description_type_sampling_context
 ************************************************************************************************************************************/

\echo 'Deploying sample_group_description_type_sampling_context';

drop table if exists clearing_house_commit.temp_tbl_sample_group_description_type_sampling_contexts;
create table clearing_house_commit.temp_tbl_sample_group_description_type_sampling_contexts as select * from public.tbl_sample_group_description_type_sampling_contexts where FALSE;

\copy clearing_house_commit.temp_tbl_sample_group_description_type_sampling_contexts from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_sample_group_description_type_sampling_context.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sample_group_description_type_sampling_contexts
    where sample_group_description_type_sampling_context_id in (select sample_group_description_type_sampling_context_id from clearing_house_commit.temp_tbl_sample_group_description_type_sampling_contexts);

insert into public.tbl_sample_group_description_type_sampling_contexts
    select *
    from clearing_house_commit.temp_tbl_sample_group_description_type_sampling_contexts
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_sample_group_description_type_sampling_contexts', 'sample_group_description_type_sampling_context_id');

drop table if exists clearing_house_commit.temp_tbl_sample_group_description_type_sampling_contexts;



/************************************************************************************************************************************
 ** sample_group
 ************************************************************************************************************************************/

\echo 'Deploying sample_group';

drop table if exists clearing_house_commit.temp_tbl_sample_groups;
create table clearing_house_commit.temp_tbl_sample_groups as select * from public.tbl_sample_groups where FALSE;

\copy clearing_house_commit.temp_tbl_sample_groups from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_sample_group.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

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

\copy clearing_house_commit.temp_tbl_physical_samples from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_physical_sample.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

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

\copy clearing_house_commit.temp_tbl_analysis_entities from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_analysis_entity.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_analysis_entities
    where analysis_entity_id in (select analysis_entity_id from clearing_house_commit.temp_tbl_analysis_entities);

insert into public.tbl_analysis_entities
    select *
    from clearing_house_commit.temp_tbl_analysis_entities
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_analysis_entities', 'analysis_entity_id');

drop table if exists clearing_house_commit.temp_tbl_analysis_entities;



/************************************************************************************************************************************
 ** dendro
 ************************************************************************************************************************************/

\echo 'Deploying dendro';

drop table if exists clearing_house_commit.temp_tbl_dendro;
create table clearing_house_commit.temp_tbl_dendro as select * from public.tbl_dendro where FALSE;

\copy clearing_house_commit.temp_tbl_dendro from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_dendro.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_dendro
    where dendro_id in (select dendro_id from clearing_house_commit.temp_tbl_dendro);

insert into public.tbl_dendro
    select *
    from clearing_house_commit.temp_tbl_dendro
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_dendro', 'dendro_id');

drop table if exists clearing_house_commit.temp_tbl_dendro;



/************************************************************************************************************************************
 ** dendro_date
 ************************************************************************************************************************************/

\echo 'Deploying dendro_date';

drop table if exists clearing_house_commit.temp_tbl_dendro_dates;
create table clearing_house_commit.temp_tbl_dendro_dates as select * from public.tbl_dendro_dates where FALSE;

\copy clearing_house_commit.temp_tbl_dendro_dates from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_dendro_date.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_dendro_dates
    where dendro_date_id in (select dendro_date_id from clearing_house_commit.temp_tbl_dendro_dates);

insert into public.tbl_dendro_dates
    select *
    from clearing_house_commit.temp_tbl_dendro_dates
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_dendro_dates', 'dendro_date_id');

drop table if exists clearing_house_commit.temp_tbl_dendro_dates;



/************************************************************************************************************************************
 ** dendro_date_note
 ************************************************************************************************************************************/

\echo 'Deploying dendro_date_note';

drop table if exists clearing_house_commit.temp_tbl_dendro_date_notes;
create table clearing_house_commit.temp_tbl_dendro_date_notes as select * from public.tbl_dendro_date_notes where FALSE;

\copy clearing_house_commit.temp_tbl_dendro_date_notes from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_dendro_date_note.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_dendro_date_notes
    where dendro_date_note_id in (select dendro_date_note_id from clearing_house_commit.temp_tbl_dendro_date_notes);

insert into public.tbl_dendro_date_notes
    select *
    from clearing_house_commit.temp_tbl_dendro_date_notes
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_dendro_date_notes', 'dendro_date_note_id');

drop table if exists clearing_house_commit.temp_tbl_dendro_date_notes;



/************************************************************************************************************************************
 ** sample_alt_ref
 ************************************************************************************************************************************/

\echo 'Deploying sample_alt_ref';

drop table if exists clearing_house_commit.temp_tbl_sample_alt_refs;
create table clearing_house_commit.temp_tbl_sample_alt_refs as select * from public.tbl_sample_alt_refs where FALSE;

\copy clearing_house_commit.temp_tbl_sample_alt_refs from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_sample_alt_ref.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

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

\copy clearing_house_commit.temp_tbl_sample_descriptions from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_sample_description.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sample_descriptions
    where sample_description_id in (select sample_description_id from clearing_house_commit.temp_tbl_sample_descriptions);

insert into public.tbl_sample_descriptions
    select *
    from clearing_house_commit.temp_tbl_sample_descriptions
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_sample_descriptions', 'sample_description_id');

drop table if exists clearing_house_commit.temp_tbl_sample_descriptions;



/************************************************************************************************************************************
 ** sample_group_coordinate
 ************************************************************************************************************************************/

\echo 'Deploying sample_group_coordinate';

drop table if exists clearing_house_commit.temp_tbl_sample_group_coordinates;
create table clearing_house_commit.temp_tbl_sample_group_coordinates as select * from public.tbl_sample_group_coordinates where FALSE;

\copy clearing_house_commit.temp_tbl_sample_group_coordinates from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_sample_group_coordinate.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sample_group_coordinates
    where sample_group_position_id in (select sample_group_position_id from clearing_house_commit.temp_tbl_sample_group_coordinates);

insert into public.tbl_sample_group_coordinates
    select *
    from clearing_house_commit.temp_tbl_sample_group_coordinates
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_sample_group_coordinates', 'sample_group_position_id');

drop table if exists clearing_house_commit.temp_tbl_sample_group_coordinates;



/************************************************************************************************************************************
 ** sample_group_description
 ************************************************************************************************************************************/

\echo 'Deploying sample_group_description';

drop table if exists clearing_house_commit.temp_tbl_sample_group_descriptions;
create table clearing_house_commit.temp_tbl_sample_group_descriptions as select * from public.tbl_sample_group_descriptions where FALSE;

\copy clearing_house_commit.temp_tbl_sample_group_descriptions from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_sample_group_description.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sample_group_descriptions
    where sample_group_description_id in (select sample_group_description_id from clearing_house_commit.temp_tbl_sample_group_descriptions);

insert into public.tbl_sample_group_descriptions
    select *
    from clearing_house_commit.temp_tbl_sample_group_descriptions
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_sample_group_descriptions', 'sample_group_description_id');

drop table if exists clearing_house_commit.temp_tbl_sample_group_descriptions;



/************************************************************************************************************************************
 ** sample_group_note
 ************************************************************************************************************************************/

\echo 'Deploying sample_group_note';

drop table if exists clearing_house_commit.temp_tbl_sample_group_notes;
create table clearing_house_commit.temp_tbl_sample_group_notes as select * from public.tbl_sample_group_notes where FALSE;

\copy clearing_house_commit.temp_tbl_sample_group_notes from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_sample_group_note.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sample_group_notes
    where sample_group_note_id in (select sample_group_note_id from clearing_house_commit.temp_tbl_sample_group_notes);

insert into public.tbl_sample_group_notes
    select *
    from clearing_house_commit.temp_tbl_sample_group_notes
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_sample_group_notes', 'sample_group_note_id');

drop table if exists clearing_house_commit.temp_tbl_sample_group_notes;



/************************************************************************************************************************************
 ** sample_location
 ************************************************************************************************************************************/

\echo 'Deploying sample_location';

drop table if exists clearing_house_commit.temp_tbl_sample_locations;
create table clearing_house_commit.temp_tbl_sample_locations as select * from public.tbl_sample_locations where FALSE;

\copy clearing_house_commit.temp_tbl_sample_locations from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_sample_location.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sample_locations
    where sample_location_id in (select sample_location_id from clearing_house_commit.temp_tbl_sample_locations);

insert into public.tbl_sample_locations
    select *
    from clearing_house_commit.temp_tbl_sample_locations
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_sample_locations', 'sample_location_id');

drop table if exists clearing_house_commit.temp_tbl_sample_locations;



/************************************************************************************************************************************
 ** sample_location_type_sampling_context
 ************************************************************************************************************************************/

\echo 'Deploying sample_location_type_sampling_context';

drop table if exists clearing_house_commit.temp_tbl_sample_location_type_sampling_contexts;
create table clearing_house_commit.temp_tbl_sample_location_type_sampling_contexts as select * from public.tbl_sample_location_type_sampling_contexts where FALSE;

\copy clearing_house_commit.temp_tbl_sample_location_type_sampling_contexts from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_sample_location_type_sampling_context.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_sample_location_type_sampling_contexts
    where sample_location_type_sampling_context_id in (select sample_location_type_sampling_context_id from clearing_house_commit.temp_tbl_sample_location_type_sampling_contexts);

insert into public.tbl_sample_location_type_sampling_contexts
    select *
    from clearing_house_commit.temp_tbl_sample_location_type_sampling_contexts
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_sample_location_type_sampling_contexts', 'sample_location_type_sampling_context_id');

drop table if exists clearing_house_commit.temp_tbl_sample_location_type_sampling_contexts;



/************************************************************************************************************************************
 ** sample_note
 ************************************************************************************************************************************/

\echo 'Deploying sample_note';

drop table if exists clearing_house_commit.temp_tbl_sample_notes;
create table clearing_house_commit.temp_tbl_sample_notes as select * from public.tbl_sample_notes where FALSE;

\copy clearing_house_commit.temp_tbl_sample_notes from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_sample_note.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

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

\copy clearing_house_commit.temp_tbl_site_locations from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_site_location.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

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

\copy clearing_house_commit.temp_tbl_site_references from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_site_reference.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_site_references
    where site_reference_id in (select site_reference_id from clearing_house_commit.temp_tbl_site_references);

insert into public.tbl_site_references
    select *
    from clearing_house_commit.temp_tbl_site_references
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_site_references', 'site_reference_id');

drop table if exists clearing_house_commit.temp_tbl_site_references;



/************************************************************************************************************************************
 ** abundance
 ************************************************************************************************************************************/

\echo 'Deploying abundance';

drop table if exists clearing_house_commit.temp_tbl_abundances;
create table clearing_house_commit.temp_tbl_abundances as select * from public.tbl_abundances where FALSE;

\copy clearing_house_commit.temp_tbl_abundances from program 'zcat -qac 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_abundance.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');

delete from public.tbl_abundances
    where abundance_id in (select abundance_id from clearing_house_commit.temp_tbl_abundances);

insert into public.tbl_abundances
    select *
    from clearing_house_commit.temp_tbl_abundances
    /* on conflict (v_pk_name) update set list-of-all-fields */;

select clearing_house_commit.reset_serial_id('public', 'tbl_abundances', 'abundance_id');

drop table if exists clearing_house_commit.temp_tbl_abundances;


select clearing_house_commit.allocate_sequence_ids();
select clearing_house_commit.commit_submission(2);
commit;
