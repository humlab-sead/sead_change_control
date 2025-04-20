-- Deploy adna: 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT
/***************************************************************************
  Author         Roger Mähler
  Date           
  Description    
  Issue          
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
\cd /repo/adna/deploy

\o /dev/null
call clearing_house_commit.reset_public_sequence_ids();
\o


/************************************************************************************************************************************
 ** biblio
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_biblio;
create table clearing_house_commit.temp_tbl_biblio as select biblio_id, bugs_reference, date_updated, doi, isbn, notes, title, year, authors, full_reference, url from public.tbl_biblio where FALSE;

\copy clearing_house_commit.temp_tbl_biblio from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/biblio.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_biblio (biblio_id, bugs_reference, date_updated, doi, isbn, notes, title, year, authors, full_reference, url)
    select biblio_id, bugs_reference, date_updated, doi, isbn, notes, title, year, authors, full_reference, url
    from clearing_house_commit.temp_tbl_biblio ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_biblio;



/************************************************************************************************************************************
 ** contact
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_contacts;
create table clearing_house_commit.temp_tbl_contacts as select contact_id, address_1, address_2, location_id, email, first_name, last_name, phone_number, url, date_updated from public.tbl_contacts where FALSE;

\copy clearing_house_commit.temp_tbl_contacts from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/contact.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_contacts (contact_id, address_1, address_2, location_id, email, first_name, last_name, phone_number, url, date_updated)
    select contact_id, address_1, address_2, location_id, email, first_name, last_name, phone_number, url, date_updated
    from clearing_house_commit.temp_tbl_contacts ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_contacts;



/************************************************************************************************************************************
 ** taxonomic_order_system
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_taxonomic_order_systems;
create table clearing_house_commit.temp_tbl_taxonomic_order_systems as select taxonomic_order_system_id, date_updated, system_description, system_name from public.tbl_taxonomic_order_systems where FALSE;

\copy clearing_house_commit.temp_tbl_taxonomic_order_systems from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/taxonomic_order_system.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_taxonomic_order_systems (taxonomic_order_system_id, date_updated, system_description, system_name)
    select taxonomic_order_system_id, date_updated, system_description, system_name
    from clearing_house_commit.temp_tbl_taxonomic_order_systems ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_taxonomic_order_systems;



/************************************************************************************************************************************
 ** alt_ref_type
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_alt_ref_types;
create table clearing_house_commit.temp_tbl_alt_ref_types as select alt_ref_type_id, alt_ref_type, date_updated, description from public.tbl_alt_ref_types where FALSE;

\copy clearing_house_commit.temp_tbl_alt_ref_types from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/alt_ref_type.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_alt_ref_types (alt_ref_type_id, alt_ref_type, date_updated, description)
    select alt_ref_type_id, alt_ref_type, date_updated, description
    from clearing_house_commit.temp_tbl_alt_ref_types ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_alt_ref_types;



/************************************************************************************************************************************
 ** record_type
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_record_types;
create table clearing_house_commit.temp_tbl_record_types as select record_type_id, record_type_name, record_type_description, date_updated from public.tbl_record_types where FALSE;

\copy clearing_house_commit.temp_tbl_record_types from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/record_type.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_record_types (record_type_id, record_type_name, record_type_description, date_updated)
    select record_type_id, record_type_name, record_type_description, date_updated
    from clearing_house_commit.temp_tbl_record_types ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_record_types;



/************************************************************************************************************************************
 ** dataset_master
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_dataset_masters;
create table clearing_house_commit.temp_tbl_dataset_masters as select master_set_id, contact_id, biblio_id, master_name, master_notes, url, date_updated from public.tbl_dataset_masters where FALSE;

\copy clearing_house_commit.temp_tbl_dataset_masters from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/dataset_master.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_dataset_masters (master_set_id, contact_id, biblio_id, master_name, master_notes, url, date_updated)
    select master_set_id, contact_id, biblio_id, master_name, master_notes, url, date_updated
    from clearing_house_commit.temp_tbl_dataset_masters ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_dataset_masters;



/************************************************************************************************************************************
 ** location
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_locations;
create table clearing_house_commit.temp_tbl_locations as select location_id, location_name, location_type_id, default_lat_dd, default_long_dd, date_updated from public.tbl_locations where FALSE;

\copy clearing_house_commit.temp_tbl_locations from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/location.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_locations (location_id, location_name, location_type_id, default_lat_dd, default_long_dd, date_updated)
    select location_id, location_name, location_type_id, default_lat_dd, default_long_dd, date_updated
    from clearing_house_commit.temp_tbl_locations ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_locations;



/************************************************************************************************************************************
 ** method
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_methods;
create table clearing_house_commit.temp_tbl_methods as select method_id, biblio_id, date_updated, description, method_abbrev_or_alt_name, method_group_id, method_name, record_type_id, unit_id from public.tbl_methods where FALSE;

\copy clearing_house_commit.temp_tbl_methods from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/method.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_methods (method_id, biblio_id, date_updated, description, method_abbrev_or_alt_name, method_group_id, method_name, record_type_id, unit_id)
    select method_id, biblio_id, date_updated, description, method_abbrev_or_alt_name, method_group_id, method_name, record_type_id, unit_id
    from clearing_house_commit.temp_tbl_methods ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_methods;



/************************************************************************************************************************************
 ** project
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_projects;
create table clearing_house_commit.temp_tbl_projects as select project_id, project_type_id, project_stage_id, project_name, project_abbrev_name, description, date_updated from public.tbl_projects where FALSE;

\copy clearing_house_commit.temp_tbl_projects from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/project.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_projects (project_id, project_type_id, project_stage_id, project_name, project_abbrev_name, description, date_updated)
    select project_id, project_type_id, project_stage_id, project_name, project_abbrev_name, description, date_updated
    from clearing_house_commit.temp_tbl_projects ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_projects;



/************************************************************************************************************************************
 ** dataset
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_datasets;
create table clearing_house_commit.temp_tbl_datasets as select dataset_id, master_set_id, data_type_id, method_id, biblio_id, updated_dataset_id, project_id, dataset_name, date_updated from public.tbl_datasets where FALSE;

\copy clearing_house_commit.temp_tbl_datasets from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/dataset.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_datasets (dataset_id, master_set_id, data_type_id, method_id, biblio_id, updated_dataset_id, project_id, dataset_name, date_updated)
    select dataset_id, master_set_id, data_type_id, method_id, biblio_id, updated_dataset_id, project_id, dataset_name, date_updated
    from clearing_house_commit.temp_tbl_datasets ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_datasets;



/************************************************************************************************************************************
 ** dataset_contact
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_dataset_contacts;
create table clearing_house_commit.temp_tbl_dataset_contacts as select dataset_contact_id, contact_id, contact_type_id, dataset_id, date_updated from public.tbl_dataset_contacts where FALSE;

\copy clearing_house_commit.temp_tbl_dataset_contacts from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/dataset_contact.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


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

\copy clearing_house_commit.temp_tbl_dataset_submissions from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/dataset_submission.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_dataset_submissions (dataset_submission_id, dataset_id, submission_type_id, contact_id, date_submitted, notes, date_updated)
    select dataset_submission_id, dataset_id, submission_type_id, contact_id, date_submitted, notes, date_updated
    from clearing_house_commit.temp_tbl_dataset_submissions ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_dataset_submissions;



/************************************************************************************************************************************
 ** taxa_tree_order
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_taxa_tree_orders;
create table clearing_house_commit.temp_tbl_taxa_tree_orders as select order_id, date_updated, order_name, record_type_id, sort_order from public.tbl_taxa_tree_orders where FALSE;

\copy clearing_house_commit.temp_tbl_taxa_tree_orders from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/taxa_tree_order.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_taxa_tree_orders (order_id, date_updated, order_name, record_type_id, sort_order)
    select order_id, date_updated, order_name, record_type_id, sort_order
    from clearing_house_commit.temp_tbl_taxa_tree_orders ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_taxa_tree_orders;



/************************************************************************************************************************************
 ** taxa_tree_family
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_taxa_tree_families;
create table clearing_house_commit.temp_tbl_taxa_tree_families as select family_id, date_updated, family_name, order_id from public.tbl_taxa_tree_families where FALSE;

\copy clearing_house_commit.temp_tbl_taxa_tree_families from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/taxa_tree_family.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_taxa_tree_families (family_id, date_updated, family_name, order_id)
    select family_id, date_updated, family_name, order_id
    from clearing_house_commit.temp_tbl_taxa_tree_families ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_taxa_tree_families;



/************************************************************************************************************************************
 ** taxa_tree_genera
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_taxa_tree_genera;
create table clearing_house_commit.temp_tbl_taxa_tree_genera as select genus_id, date_updated, family_id, genus_name from public.tbl_taxa_tree_genera where FALSE;

\copy clearing_house_commit.temp_tbl_taxa_tree_genera from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/taxa_tree_genera.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_taxa_tree_genera (genus_id, date_updated, family_id, genus_name)
    select genus_id, date_updated, family_id, genus_name
    from clearing_house_commit.temp_tbl_taxa_tree_genera ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_taxa_tree_genera;



/************************************************************************************************************************************
 ** taxa_tree_master
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_taxa_tree_master;
create table clearing_house_commit.temp_tbl_taxa_tree_master as select taxon_id, author_id, date_updated, genus_id, species from public.tbl_taxa_tree_master where FALSE;

\copy clearing_house_commit.temp_tbl_taxa_tree_master from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/taxa_tree_master.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_taxa_tree_master (taxon_id, author_id, date_updated, genus_id, species)
    select taxon_id, author_id, date_updated, genus_id, species
    from clearing_house_commit.temp_tbl_taxa_tree_master ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_taxa_tree_master;



/************************************************************************************************************************************
 ** taxonomic_order
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_taxonomic_order;
create table clearing_house_commit.temp_tbl_taxonomic_order as select taxonomic_order_id, date_updated, taxon_id, taxonomic_code, taxonomic_order_system_id from public.tbl_taxonomic_order where FALSE;

\copy clearing_house_commit.temp_tbl_taxonomic_order from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/taxonomic_order.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_taxonomic_order (taxonomic_order_id, date_updated, taxon_id, taxonomic_code, taxonomic_order_system_id)
    select taxonomic_order_id, date_updated, taxon_id, taxonomic_code, taxonomic_order_system_id
    from clearing_house_commit.temp_tbl_taxonomic_order ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_taxonomic_order;



/************************************************************************************************************************************
 ** value_type
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_value_types;
create table clearing_house_commit.temp_tbl_value_types as select value_type_id, unit_id, data_type_id, name, base_type, precision, description, value_type_uuid from public.tbl_value_types where FALSE;

\copy clearing_house_commit.temp_tbl_value_types from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/value_type.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_value_types (value_type_id, unit_id, data_type_id, name, base_type, precision, description, value_type_uuid)
    select value_type_id, unit_id, data_type_id, name, base_type, precision, description, value_type_uuid
    from clearing_house_commit.temp_tbl_value_types ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_value_types;



/************************************************************************************************************************************
 ** value_classe
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_value_classes;
create table clearing_house_commit.temp_tbl_value_classes as select value_class_id, value_type_id, method_id, parent_id, name, description, value_class_uuid from public.tbl_value_classes where FALSE;

\copy clearing_house_commit.temp_tbl_value_classes from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/value_classe.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_value_classes (value_class_id, value_type_id, method_id, parent_id, name, description, value_class_uuid)
    select value_class_id, value_type_id, method_id, parent_id, name, description, value_class_uuid
    from clearing_house_commit.temp_tbl_value_classes ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_value_classes;



/************************************************************************************************************************************
 ** value_type_item
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_value_type_items;
create table clearing_house_commit.temp_tbl_value_type_items as select value_type_item_id, value_type_id, name, description from public.tbl_value_type_items where FALSE;

\copy clearing_house_commit.temp_tbl_value_type_items from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/value_type_item.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_value_type_items (value_type_item_id, value_type_id, name, description)
    select value_type_item_id, value_type_id, name, description
    from clearing_house_commit.temp_tbl_value_type_items ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_value_type_items;



/************************************************************************************************************************************
 ** abundance
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_abundances;
create table clearing_house_commit.temp_tbl_abundances as select abundance_id, taxon_id, analysis_entity_id, abundance_element_id, abundance, date_updated from public.tbl_abundances where FALSE;

\copy clearing_house_commit.temp_tbl_abundances from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/abundance.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_abundances (abundance_id, taxon_id, analysis_entity_id, abundance_element_id, abundance, date_updated)
    select abundance_id, taxon_id, analysis_entity_id, abundance_element_id, abundance, date_updated
    from clearing_house_commit.temp_tbl_abundances ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_abundances;



/************************************************************************************************************************************
 ** analysis_entity
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_analysis_entities;
create table clearing_house_commit.temp_tbl_analysis_entities as select analysis_entity_id, physical_sample_id, dataset_id, date_updated from public.tbl_analysis_entities where FALSE;

\copy clearing_house_commit.temp_tbl_analysis_entities from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/analysis_entity.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


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

\copy clearing_house_commit.temp_tbl_analysis_values from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/analysis_value.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


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

\copy clearing_house_commit.temp_tbl_physical_samples from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/physical_sample.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_physical_samples (physical_sample_id, sample_group_id, alt_ref_type_id, sample_type_id, sample_name, date_updated, date_sampled)
    select physical_sample_id, sample_group_id, alt_ref_type_id, sample_type_id, sample_name, date_updated, date_sampled
    from clearing_house_commit.temp_tbl_physical_samples ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_physical_samples;



/************************************************************************************************************************************
 ** relative_date
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_relative_dates;
create table clearing_house_commit.temp_tbl_relative_dates as select relative_date_id, relative_age_id, method_id, notes, date_updated, dating_uncertainty_id, analysis_entity_id from public.tbl_relative_dates where FALSE;

\copy clearing_house_commit.temp_tbl_relative_dates from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/relative_date.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


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

\copy clearing_house_commit.temp_tbl_sample_alt_refs from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/sample_alt_ref.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_sample_alt_refs (sample_alt_ref_id, alt_ref, alt_ref_type_id, date_updated, physical_sample_id)
    select sample_alt_ref_id, alt_ref, alt_ref_type_id, date_updated, physical_sample_id
    from clearing_house_commit.temp_tbl_sample_alt_refs ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_sample_alt_refs;



/************************************************************************************************************************************
 ** sample_group
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sample_groups;
create table clearing_house_commit.temp_tbl_sample_groups as select sample_group_id, site_id, sampling_context_id, method_id, sample_group_name, sample_group_description, date_updated from public.tbl_sample_groups where FALSE;

\copy clearing_house_commit.temp_tbl_sample_groups from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/sample_group.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_sample_groups (sample_group_id, site_id, sampling_context_id, method_id, sample_group_name, sample_group_description, date_updated)
    select sample_group_id, site_id, sampling_context_id, method_id, sample_group_name, sample_group_description, date_updated
    from clearing_house_commit.temp_tbl_sample_groups ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_sample_groups;



/************************************************************************************************************************************
 ** site_location
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_site_locations;
create table clearing_house_commit.temp_tbl_site_locations as select site_location_id, date_updated, location_id, site_id from public.tbl_site_locations where FALSE;

\copy clearing_house_commit.temp_tbl_site_locations from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/site_location.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


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

\copy clearing_house_commit.temp_tbl_site_references from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/site_reference.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_site_references (site_reference_id, site_id, biblio_id, date_updated)
    select site_reference_id, site_id, biblio_id, date_updated
    from clearing_house_commit.temp_tbl_site_references ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_site_references;



/************************************************************************************************************************************
 ** site
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sites;
create table clearing_house_commit.temp_tbl_sites as select site_id, altitude, latitude_dd, longitude_dd, national_site_identifier, site_description, site_name, site_preservation_status_id, site_location_accuracy, date_updated from public.tbl_sites where FALSE;

\copy clearing_house_commit.temp_tbl_sites from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT/site.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_sites (site_id, altitude, latitude_dd, longitude_dd, national_site_identifier, site_description, site_name, site_preservation_status_id, site_location_accuracy, date_updated)
    select site_id, altitude, latitude_dd, longitude_dd, national_site_identifier, site_description, site_name, site_preservation_status_id, site_location_accuracy, date_updated
    from clearing_house_commit.temp_tbl_sites ;

\o /dev/null

drop table if exists clearing_house_commit.temp_tbl_sites;


\o /dev/null
call clearing_house_commit.reset_public_sequence_ids();
select clearing_house_commit.commit_submission('20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT');
\o
commit;

do $$
begin
    perform sead_utility.set_fk_is_deferrable('public', false, false);
end $$ language plpgsql;

