-- Deploy dendrochronology: 20240119_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT
/***************************************************************************
  Author         Roger Mähler
  Date           
  Description    New building data from Lund Dendrochronology lab
  Issue          https://github.com/humlab-sead/sead_change_control/issues/218
  Prerequisites  
  Reviewer
  Approver
  Idempotent     NO!
  Notes          Use --single-transaction on execute!
***************************************************************************/
set client_encoding = 'UTF8';
set client_min_messages to warning;
\set autocommit off;

do $$
begin
    perform sead_utility.set_fk_is_deferrable('public', true, false);
end $$ language plpgsql;

begin;
set constraints all deferred;
\cd /repo/dendrochronology/deploy


/************************************************************************************************************************************
 ** project
 ************************************************************************************************************************************/


drop table if exists clearing_house_commit.temp_tbl_projects;
create table clearing_house_commit.temp_tbl_projects as select * from public.tbl_projects where FALSE;

\copy clearing_house_commit.temp_tbl_projects from program 'zcat -qac 20240119_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/project.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_projects
    select *
    from clearing_house_commit.temp_tbl_projects
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_projects', 'project_id');
\o

drop table if exists clearing_house_commit.temp_tbl_projects;



/************************************************************************************************************************************
 ** dataset
 ************************************************************************************************************************************/


drop table if exists clearing_house_commit.temp_tbl_datasets;
create table clearing_house_commit.temp_tbl_datasets as select * from public.tbl_datasets where FALSE;

\copy clearing_house_commit.temp_tbl_datasets from program 'zcat -qac 20240119_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/dataset.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


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

\copy clearing_house_commit.temp_tbl_dataset_contacts from program 'zcat -qac 20240119_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/dataset_contact.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


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

\copy clearing_house_commit.temp_tbl_dataset_submissions from program 'zcat -qac 20240119_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/dataset_submission.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_dataset_submissions
    select *
    from clearing_house_commit.temp_tbl_dataset_submissions
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_dataset_submissions', 'dataset_submission_id');
\o

drop table if exists clearing_house_commit.temp_tbl_dataset_submissions;



/************************************************************************************************************************************
 ** abundance
 ************************************************************************************************************************************/


drop table if exists clearing_house_commit.temp_tbl_abundances;
create table clearing_house_commit.temp_tbl_abundances as select * from public.tbl_abundances where FALSE;

\copy clearing_house_commit.temp_tbl_abundances from program 'zcat -qac 20240119_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/abundance.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_abundances
    select *
    from clearing_house_commit.temp_tbl_abundances
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_abundances', 'abundance_id');
\o

drop table if exists clearing_house_commit.temp_tbl_abundances;



/************************************************************************************************************************************
 ** analysis_entity
 ************************************************************************************************************************************/


drop table if exists clearing_house_commit.temp_tbl_analysis_entities;
create table clearing_house_commit.temp_tbl_analysis_entities as select * from public.tbl_analysis_entities where FALSE;

\copy clearing_house_commit.temp_tbl_analysis_entities from program 'zcat -qac 20240119_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/analysis_entity.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_analysis_entities
    select *
    from clearing_house_commit.temp_tbl_analysis_entities
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_analysis_entities', 'analysis_entity_id');
\o

drop table if exists clearing_house_commit.temp_tbl_analysis_entities;



/************************************************************************************************************************************
 ** dendro
 ************************************************************************************************************************************/


drop table if exists clearing_house_commit.temp_tbl_dendro;
create table clearing_house_commit.temp_tbl_dendro as select * from public.tbl_dendro where FALSE;

\copy clearing_house_commit.temp_tbl_dendro from program 'zcat -qac 20240119_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/dendro.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_dendro
    select *
    from clearing_house_commit.temp_tbl_dendro
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_dendro', 'dendro_id');
\o

drop table if exists clearing_house_commit.temp_tbl_dendro;



/************************************************************************************************************************************
 ** dendro_date_note
 ************************************************************************************************************************************/


drop table if exists clearing_house_commit.temp_tbl_dendro_date_notes;
create table clearing_house_commit.temp_tbl_dendro_date_notes as select * from public.tbl_dendro_date_notes where FALSE;

\copy clearing_house_commit.temp_tbl_dendro_date_notes from program 'zcat -qac 20240119_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/dendro_date_note.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_dendro_date_notes
    select *
    from clearing_house_commit.temp_tbl_dendro_date_notes
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_dendro_date_notes', 'dendro_date_note_id');
\o

drop table if exists clearing_house_commit.temp_tbl_dendro_date_notes;



/************************************************************************************************************************************
 ** dendro_date
 ************************************************************************************************************************************/



drop table if exists clearing_house_commit.temp_tbl_dendro_dates;
create table clearing_house_commit.temp_tbl_dendro_dates as
    select dendro_date_id, season_id, dating_uncertainty_id, dendro_lookup_id, age_type_id, analysis_entity_id, age_older, age_younger, date_updated
    from public.tbl_dendro_dates where FALSE;

\copy clearing_house_commit.temp_tbl_dendro_dates from program 'zcat -qac 20240119_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/dendro_date.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_dendro_dates
    select *
    from clearing_house_commit.temp_tbl_dendro_dates
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_dendro_dates', 'dendro_date_id');
\o

drop table if exists clearing_house_commit.temp_tbl_dendro_dates;



/************************************************************************************************************************************
 ** physical_sample
 ************************************************************************************************************************************/


drop table if exists clearing_house_commit.temp_tbl_physical_samples;
create table clearing_house_commit.temp_tbl_physical_samples as select * from public.tbl_physical_samples where FALSE;

\copy clearing_house_commit.temp_tbl_physical_samples from program 'zcat -qac 20240119_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/physical_sample.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_physical_samples
    select *
    from clearing_house_commit.temp_tbl_physical_samples
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_physical_samples', 'physical_sample_id');
\o

drop table if exists clearing_house_commit.temp_tbl_physical_samples;



/************************************************************************************************************************************
 ** sample_alt_ref
 ************************************************************************************************************************************/


drop table if exists clearing_house_commit.temp_tbl_sample_alt_refs;
create table clearing_house_commit.temp_tbl_sample_alt_refs as select * from public.tbl_sample_alt_refs where FALSE;

\copy clearing_house_commit.temp_tbl_sample_alt_refs from program 'zcat -qac 20240119_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/sample_alt_ref.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


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

\copy clearing_house_commit.temp_tbl_sample_descriptions from program 'zcat -qac 20240119_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/sample_description.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_sample_descriptions
    select *
    from clearing_house_commit.temp_tbl_sample_descriptions
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_sample_descriptions', 'sample_description_id');
\o

drop table if exists clearing_house_commit.temp_tbl_sample_descriptions;



/************************************************************************************************************************************
 ** sample_group_coordinate
 ************************************************************************************************************************************/


drop table if exists clearing_house_commit.temp_tbl_sample_group_coordinates;
create table clearing_house_commit.temp_tbl_sample_group_coordinates as select * from public.tbl_sample_group_coordinates where FALSE;

\copy clearing_house_commit.temp_tbl_sample_group_coordinates from program 'zcat -qac 20240119_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/sample_group_coordinate.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_sample_group_coordinates
    select *
    from clearing_house_commit.temp_tbl_sample_group_coordinates
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_sample_group_coordinates', 'sample_group_position_id');
\o

drop table if exists clearing_house_commit.temp_tbl_sample_group_coordinates;



/************************************************************************************************************************************
 ** sample_group_description
 ************************************************************************************************************************************/


drop table if exists clearing_house_commit.temp_tbl_sample_group_descriptions;
create table clearing_house_commit.temp_tbl_sample_group_descriptions as select * from public.tbl_sample_group_descriptions where FALSE;

\copy clearing_house_commit.temp_tbl_sample_group_descriptions from program 'zcat -qac 20240119_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/sample_group_description.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_sample_group_descriptions
    select *
    from clearing_house_commit.temp_tbl_sample_group_descriptions
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_sample_group_descriptions', 'sample_group_description_id');
\o

drop table if exists clearing_house_commit.temp_tbl_sample_group_descriptions;



/************************************************************************************************************************************
 ** sample_group_note
 ************************************************************************************************************************************/


drop table if exists clearing_house_commit.temp_tbl_sample_group_notes;
create table clearing_house_commit.temp_tbl_sample_group_notes as select * from public.tbl_sample_group_notes where FALSE;

\copy clearing_house_commit.temp_tbl_sample_group_notes from program 'zcat -qac 20240119_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/sample_group_note.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_sample_group_notes
    select *
    from clearing_house_commit.temp_tbl_sample_group_notes
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_sample_group_notes', 'sample_group_note_id');
\o

drop table if exists clearing_house_commit.temp_tbl_sample_group_notes;



/************************************************************************************************************************************
 ** sample_group
 ************************************************************************************************************************************/


drop table if exists clearing_house_commit.temp_tbl_sample_groups;
create table clearing_house_commit.temp_tbl_sample_groups as select * from public.tbl_sample_groups where FALSE;

\copy clearing_house_commit.temp_tbl_sample_groups from program 'zcat -qac 20240119_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/sample_group.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_sample_groups
    select *
    from clearing_house_commit.temp_tbl_sample_groups
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_sample_groups', 'sample_group_id');
\o

drop table if exists clearing_house_commit.temp_tbl_sample_groups;



/************************************************************************************************************************************
 ** sample_location
 ************************************************************************************************************************************/


drop table if exists clearing_house_commit.temp_tbl_sample_locations;
create table clearing_house_commit.temp_tbl_sample_locations as select * from public.tbl_sample_locations where FALSE;

\copy clearing_house_commit.temp_tbl_sample_locations from program 'zcat -qac 20240119_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/sample_location.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_sample_locations
    select *
    from clearing_house_commit.temp_tbl_sample_locations
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_sample_locations', 'sample_location_id');
\o

drop table if exists clearing_house_commit.temp_tbl_sample_locations;



/************************************************************************************************************************************
 ** sample_note
 ************************************************************************************************************************************/


drop table if exists clearing_house_commit.temp_tbl_sample_notes;
create table clearing_house_commit.temp_tbl_sample_notes as select * from public.tbl_sample_notes where FALSE;

\copy clearing_house_commit.temp_tbl_sample_notes from program 'zcat -qac 20240119_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/sample_note.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_sample_notes
    select *
    from clearing_house_commit.temp_tbl_sample_notes
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_sample_notes', 'sample_note_id');
\o

drop table if exists clearing_house_commit.temp_tbl_sample_notes;



/************************************************************************************************************************************
 ** site_location
 ************************************************************************************************************************************/


drop table if exists clearing_house_commit.temp_tbl_site_locations;
create table clearing_house_commit.temp_tbl_site_locations as select * from public.tbl_site_locations where FALSE;

\copy clearing_house_commit.temp_tbl_site_locations from program 'zcat -qac 20240119_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/site_location.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


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

\copy clearing_house_commit.temp_tbl_site_references from program 'zcat -qac 20240119_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/site_reference.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_site_references
    select *
    from clearing_house_commit.temp_tbl_site_references
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_site_references', 'site_reference_id');
\o

drop table if exists clearing_house_commit.temp_tbl_site_references;



/************************************************************************************************************************************
 ** site
 ************************************************************************************************************************************/


drop table if exists clearing_house_commit.temp_tbl_sites;
create table clearing_house_commit.temp_tbl_sites as select * from public.tbl_sites where FALSE;

\copy clearing_house_commit.temp_tbl_sites from program 'zcat -qac 20240119_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/site.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_sites
    select *
    from clearing_house_commit.temp_tbl_sites
    /* on conflict (v_pk_name) update set list-of-all-fields */;

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_sites', 'site_id');
\o

drop table if exists clearing_house_commit.temp_tbl_sites;


select clearing_house_commit.allocate_sequence_ids();
select clearing_house_commit.commit_submission('20240119_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT');
commit;

do $$
begin
    perform sead_utility.set_fk_is_deferrable('public', false, false);
    perform sead_utility.sync_sequences('public');
    perform sead_utility.sync_sequences('bugs_import');
    
end $$ language plpgsql;

