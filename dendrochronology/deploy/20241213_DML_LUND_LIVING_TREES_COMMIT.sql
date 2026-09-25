-- Deploy dendrochronology: 20241213_DML_LUND_LIVING_TREES_COMMIT
/***************************************************************************
  Author         Roger Mähler
  Date           
  Description    
  Issue          https://github.com/humlab-sead/sead_change_control/issues/332
  Prerequisites  
  Reviewer
  Approver
  Idempotent     NO
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

call clearing_house_commit.reset_public_sequence_ids();

/************************************************************************************************************************************
 ** dataset_submission_type
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_dataset_submission_types;
create table clearing_house_commit.temp_tbl_dataset_submission_types as select submission_type_id, submission_type, description, date_updated from public.tbl_dataset_submission_types where FALSE;

\copy clearing_house_commit.temp_tbl_dataset_submission_types (submission_type_id, submission_type, description, date_updated) from program 'zcat -qac 20241213_DML_LUND_LIVING_TREES_COMMIT/dataset_submission_type.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_dataset_submission_types (submission_type_id, submission_type, description, date_updated)
    select submission_type_id, submission_type, description, date_updated
    from clearing_house_commit.temp_tbl_dataset_submission_types ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_dataset_submission_types;



/************************************************************************************************************************************
 ** sample_location_type
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sample_location_types;
create table clearing_house_commit.temp_tbl_sample_location_types as select sample_location_type_id, location_type, location_type_description, date_updated from public.tbl_sample_location_types where FALSE;

\copy clearing_house_commit.temp_tbl_sample_location_types (sample_location_type_id, location_type, location_type_description, date_updated) from program 'zcat -qac 20241213_DML_LUND_LIVING_TREES_COMMIT/sample_location_type.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_sample_location_types (sample_location_type_id, location_type, location_type_description, date_updated)
    select sample_location_type_id, location_type, location_type_description, date_updated
    from clearing_house_commit.temp_tbl_sample_location_types ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_sample_location_types;



/************************************************************************************************************************************
 ** dimension
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_dimensions;
create table clearing_house_commit.temp_tbl_dimensions as select dimension_id, date_updated, dimension_abbrev, dimension_description, dimension_name, unit_id, method_group_id from public.tbl_dimensions where FALSE;

\copy clearing_house_commit.temp_tbl_dimensions (dimension_id, date_updated, dimension_abbrev, dimension_description, dimension_name, unit_id, method_group_id) from program 'zcat -qac 20241213_DML_LUND_LIVING_TREES_COMMIT/dimension.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_dimensions (dimension_id, date_updated, dimension_abbrev, dimension_description, dimension_name, unit_id, method_group_id)
    select dimension_id, date_updated, dimension_abbrev, dimension_description, dimension_name, unit_id, method_group_id
    from clearing_house_commit.temp_tbl_dimensions ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_dimensions;



/************************************************************************************************************************************
 ** project
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_projects;
create table clearing_house_commit.temp_tbl_projects as select project_id, project_type_id, project_stage_id, project_name, project_abbrev_name, description, date_updated from public.tbl_projects where FALSE;

\copy clearing_house_commit.temp_tbl_projects (project_id, project_type_id, project_stage_id, project_name, project_abbrev_name, description, date_updated) from program 'zcat -qac 20241213_DML_LUND_LIVING_TREES_COMMIT/project.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_projects (project_id, project_type_id, project_stage_id, project_name, project_abbrev_name, description, date_updated)
    select project_id, project_type_id, project_stage_id, project_name, project_abbrev_name, description, date_updated
    from clearing_house_commit.temp_tbl_projects ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_projects;



/************************************************************************************************************************************
 ** dataset
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_datasets;
create table clearing_house_commit.temp_tbl_datasets as select dataset_id, master_set_id, data_type_id, method_id, biblio_id, updated_dataset_id, project_id, dataset_name, date_updated, dataset_uuid from public.tbl_datasets where FALSE;

\copy clearing_house_commit.temp_tbl_datasets (dataset_id, master_set_id, data_type_id, method_id, biblio_id, updated_dataset_id, project_id, dataset_name, date_updated, dataset_uuid) from program 'zcat -qac 20241213_DML_LUND_LIVING_TREES_COMMIT/dataset.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_datasets (dataset_id, master_set_id, data_type_id, method_id, biblio_id, updated_dataset_id, project_id, dataset_name, date_updated, dataset_uuid)
    select dataset_id, master_set_id, data_type_id, method_id, biblio_id, updated_dataset_id, project_id, dataset_name, date_updated, dataset_uuid
    from clearing_house_commit.temp_tbl_datasets ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_datasets;



/************************************************************************************************************************************
 ** dataset_contact
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_dataset_contacts;
create table clearing_house_commit.temp_tbl_dataset_contacts as select dataset_contact_id, contact_id, contact_type_id, dataset_id, date_updated from public.tbl_dataset_contacts where FALSE;

\copy clearing_house_commit.temp_tbl_dataset_contacts (dataset_contact_id, contact_id, contact_type_id, dataset_id, date_updated) from program 'zcat -qac 20241213_DML_LUND_LIVING_TREES_COMMIT/dataset_contact.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


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

\copy clearing_house_commit.temp_tbl_dataset_submissions (dataset_submission_id, dataset_id, submission_type_id, contact_id, date_submitted, notes, date_updated) from program 'zcat -qac 20241213_DML_LUND_LIVING_TREES_COMMIT/dataset_submission.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8'); 


insert into public.tbl_dataset_submissions (dataset_submission_id, dataset_id, submission_type_id, contact_id, date_submitted, notes, date_updated)
    select dataset_submission_id, dataset_id, submission_type_id, contact_id, date_submitted, notes, date_updated
    from clearing_house_commit.temp_tbl_dataset_submissions ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_dataset_submissions;



/************************************************************************************************************************************
 ** analysis_entity
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_analysis_entities;
create table clearing_house_commit.temp_tbl_analysis_entities as select analysis_entity_id, physical_sample_id, dataset_id, date_updated from public.tbl_analysis_entities where FALSE;

\copy clearing_house_commit.temp_tbl_analysis_entities (analysis_entity_id, physical_sample_id, dataset_id, date_updated) from program 'zcat -qac 20241213_DML_LUND_LIVING_TREES_COMMIT/analysis_entity.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_analysis_entities (analysis_entity_id, physical_sample_id, dataset_id, date_updated)
    select analysis_entity_id, physical_sample_id, dataset_id, date_updated
    from clearing_house_commit.temp_tbl_analysis_entities ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_analysis_entities;



/************************************************************************************************************************************
 ** analysis_value
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_analysis_values;
create table clearing_house_commit.temp_tbl_analysis_values as select analysis_value_id, value_class_id, analysis_entity_id, analysis_value, boolean_value, is_boolean, is_uncertain, is_undefined, is_not_analyzed, is_indeterminable, is_anomaly from public.tbl_analysis_values where FALSE;

\copy clearing_house_commit.temp_tbl_analysis_values (analysis_value_id, value_class_id, analysis_entity_id, analysis_value, boolean_value, is_boolean, is_uncertain, is_undefined, is_not_analyzed, is_indeterminable, is_anomaly) from program 'zcat -qac 20241213_DML_LUND_LIVING_TREES_COMMIT/analysis_value.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_analysis_values (analysis_value_id, value_class_id, analysis_entity_id, analysis_value, boolean_value, is_boolean, is_uncertain, is_undefined, is_not_analyzed, is_indeterminable, is_anomaly)
    select analysis_value_id, value_class_id, analysis_entity_id, analysis_value, boolean_value, is_boolean, is_uncertain, is_undefined, is_not_analyzed, is_indeterminable, is_anomaly
    from clearing_house_commit.temp_tbl_analysis_values ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_analysis_values;



/************************************************************************************************************************************
 ** physical_sample
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_physical_samples;
create table clearing_house_commit.temp_tbl_physical_samples as select physical_sample_id, sample_group_id, alt_ref_type_id, sample_type_id, sample_name, date_updated, date_sampled from public.tbl_physical_samples where FALSE;

\copy clearing_house_commit.temp_tbl_physical_samples (physical_sample_id, sample_group_id, alt_ref_type_id, sample_type_id, sample_name, date_updated, date_sampled) from program 'zcat -qac 20241213_DML_LUND_LIVING_TREES_COMMIT/physical_sample.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_physical_samples (physical_sample_id, sample_group_id, alt_ref_type_id, sample_type_id, sample_name, date_updated, date_sampled)
    select physical_sample_id, sample_group_id, alt_ref_type_id, sample_type_id, sample_name, date_updated, date_sampled
    from clearing_house_commit.temp_tbl_physical_samples ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_physical_samples;



/************************************************************************************************************************************
 ** sample_alt_ref
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sample_alt_refs;
create table clearing_house_commit.temp_tbl_sample_alt_refs as select sample_alt_ref_id, alt_ref, alt_ref_type_id, date_updated, physical_sample_id from public.tbl_sample_alt_refs where FALSE;

\copy clearing_house_commit.temp_tbl_sample_alt_refs (sample_alt_ref_id, alt_ref, alt_ref_type_id, date_updated, physical_sample_id) from program 'zcat -qac 20241213_DML_LUND_LIVING_TREES_COMMIT/sample_alt_ref.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_sample_alt_refs (sample_alt_ref_id, alt_ref, alt_ref_type_id, date_updated, physical_sample_id)
    select sample_alt_ref_id, alt_ref, alt_ref_type_id, date_updated, physical_sample_id
    from clearing_house_commit.temp_tbl_sample_alt_refs ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_sample_alt_refs;



/************************************************************************************************************************************
 ** sample_dimension
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sample_dimensions;
create table clearing_house_commit.temp_tbl_sample_dimensions as select sample_dimension_id, physical_sample_id, dimension_id, method_id, dimension_value, date_updated, qualifier_id from public.tbl_sample_dimensions where FALSE;

\copy clearing_house_commit.temp_tbl_sample_dimensions (sample_dimension_id, physical_sample_id, dimension_id, method_id, dimension_value, date_updated, qualifier_id) from program 'zcat -qac 20241213_DML_LUND_LIVING_TREES_COMMIT/sample_dimension.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_sample_dimensions (sample_dimension_id, physical_sample_id, dimension_id, method_id, dimension_value, date_updated, qualifier_id)
    select sample_dimension_id, physical_sample_id, dimension_id, method_id, dimension_value, date_updated, qualifier_id
    from clearing_house_commit.temp_tbl_sample_dimensions ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_sample_dimensions;



/************************************************************************************************************************************
 ** sample_group_description
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sample_group_descriptions;
create table clearing_house_commit.temp_tbl_sample_group_descriptions as select sample_group_description_id, group_description, sample_group_description_type_id, date_updated, sample_group_id from public.tbl_sample_group_descriptions where FALSE;

\copy clearing_house_commit.temp_tbl_sample_group_descriptions (sample_group_description_id, group_description, sample_group_description_type_id, date_updated, sample_group_id) from program 'zcat -qac 20241213_DML_LUND_LIVING_TREES_COMMIT/sample_group_description.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_sample_group_descriptions (sample_group_description_id, group_description, sample_group_description_type_id, date_updated, sample_group_id)
    select sample_group_description_id, group_description, sample_group_description_type_id, date_updated, sample_group_id
    from clearing_house_commit.temp_tbl_sample_group_descriptions ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_sample_group_descriptions;



/************************************************************************************************************************************
 ** sample_group
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sample_groups;
create table clearing_house_commit.temp_tbl_sample_groups as select sample_group_id, site_id, sampling_context_id, method_id, sample_group_name, sample_group_description, date_updated, sample_group_uuid from public.tbl_sample_groups where FALSE;

\copy clearing_house_commit.temp_tbl_sample_groups (sample_group_id, site_id, sampling_context_id, method_id, sample_group_name, sample_group_description, date_updated, sample_group_uuid) from program 'zcat -qac 20241213_DML_LUND_LIVING_TREES_COMMIT/sample_group.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_sample_groups (sample_group_id, site_id, sampling_context_id, method_id, sample_group_name, sample_group_description, date_updated, sample_group_uuid)
    select sample_group_id, site_id, sampling_context_id, method_id, sample_group_name, sample_group_description, date_updated, sample_group_uuid
    from clearing_house_commit.temp_tbl_sample_groups ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_sample_groups;



/************************************************************************************************************************************
 ** sample_location
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sample_locations;
create table clearing_house_commit.temp_tbl_sample_locations as select sample_location_id, sample_location_type_id, physical_sample_id, location, date_updated from public.tbl_sample_locations where FALSE;

\copy clearing_house_commit.temp_tbl_sample_locations (sample_location_id, sample_location_type_id, physical_sample_id, location, date_updated) from program 'zcat -qac 20241213_DML_LUND_LIVING_TREES_COMMIT/sample_location.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_sample_locations (sample_location_id, sample_location_type_id, physical_sample_id, location, date_updated)
    select sample_location_id, sample_location_type_id, physical_sample_id, location, date_updated
    from clearing_house_commit.temp_tbl_sample_locations ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_sample_locations;



/************************************************************************************************************************************
 ** site_location
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_site_locations;
create table clearing_house_commit.temp_tbl_site_locations as select site_location_id, date_updated, location_id, site_id from public.tbl_site_locations where FALSE;

\copy clearing_house_commit.temp_tbl_site_locations (site_location_id, date_updated, location_id, site_id) from program 'zcat -qac 20241213_DML_LUND_LIVING_TREES_COMMIT/site_location.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_site_locations (site_location_id, date_updated, location_id, site_id)
    select site_location_id, date_updated, location_id, site_id
    from clearing_house_commit.temp_tbl_site_locations ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_site_locations;


\o /dev/null
call clearing_house_commit.reset_public_sequence_ids();
select clearing_house_commit.commit_submission('20241213_DML_LUND_LIVING_TREES_COMMIT');
\o
commit;

do $$
begin
    perform sead_utility.set_fk_is_deferrable('public', false, false);
end $$ language plpgsql;

