-- Deploy adna: 20250108_DML_SUBMISSION_ADNA_001_COMMIT
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


/************************************************************************************************************************************
 ** biblio
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_biblio;
create table clearing_house_commit.temp_tbl_biblio as select * from public.tbl_biblio where FALSE;

\copy clearing_house_commit.temp_tbl_biblio from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_biblio.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_biblio
    select *
    from clearing_house_commit.temp_tbl_biblio ;

\echo Deployed biblio, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_biblio', 'biblio_id');
\o

drop table if exists clearing_house_commit.temp_tbl_biblio;



/************************************************************************************************************************************
 ** contact
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_contacts;
create table clearing_house_commit.temp_tbl_contacts as select * from public.tbl_contacts where FALSE;

\copy clearing_house_commit.temp_tbl_contacts from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_contact.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_contacts
    select *
    from clearing_house_commit.temp_tbl_contacts ;

\echo Deployed contact, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_contacts', 'contact_id');
\o

drop table if exists clearing_house_commit.temp_tbl_contacts;



/************************************************************************************************************************************
 ** taxonomic_order_system
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_taxonomic_order_systems;
create table clearing_house_commit.temp_tbl_taxonomic_order_systems as select * from public.tbl_taxonomic_order_systems where FALSE;

\copy clearing_house_commit.temp_tbl_taxonomic_order_systems from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_taxonomic_order_system.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_taxonomic_order_systems
    select *
    from clearing_house_commit.temp_tbl_taxonomic_order_systems ;

\echo Deployed taxonomic_order_system, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_taxonomic_order_systems', 'taxonomic_order_system_id');
\o

drop table if exists clearing_house_commit.temp_tbl_taxonomic_order_systems;



/************************************************************************************************************************************
 ** alt_ref_type
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_alt_ref_types;
create table clearing_house_commit.temp_tbl_alt_ref_types as select * from public.tbl_alt_ref_types where FALSE;

\copy clearing_house_commit.temp_tbl_alt_ref_types from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_alt_ref_type.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_alt_ref_types
    select *
    from clearing_house_commit.temp_tbl_alt_ref_types ;

\echo Deployed alt_ref_type, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_alt_ref_types', 'alt_ref_type_id');
\o

drop table if exists clearing_house_commit.temp_tbl_alt_ref_types;



/************************************************************************************************************************************
 ** record_type
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_record_types;
create table clearing_house_commit.temp_tbl_record_types as select * from public.tbl_record_types where FALSE;

\copy clearing_house_commit.temp_tbl_record_types from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_record_type.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_record_types
    select *
    from clearing_house_commit.temp_tbl_record_types ;

\echo Deployed record_type, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_record_types', 'record_type_id');
\o

drop table if exists clearing_house_commit.temp_tbl_record_types;



/************************************************************************************************************************************
 ** dataset_master
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_dataset_masters;
create table clearing_house_commit.temp_tbl_dataset_masters as select * from public.tbl_dataset_masters where FALSE;

\copy clearing_house_commit.temp_tbl_dataset_masters from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_dataset_master.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_dataset_masters
    select *
    from clearing_house_commit.temp_tbl_dataset_masters ;

\echo Deployed dataset_master, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_dataset_masters', 'master_set_id');
\o

drop table if exists clearing_house_commit.temp_tbl_dataset_masters;



/************************************************************************************************************************************
 ** location
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_locations;
create table clearing_house_commit.temp_tbl_locations as select * from public.tbl_locations where FALSE;

\copy clearing_house_commit.temp_tbl_locations from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_location.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_locations
    select *
    from clearing_house_commit.temp_tbl_locations ;

\echo Deployed location, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_locations', 'location_id');
\o

drop table if exists clearing_house_commit.temp_tbl_locations;



/************************************************************************************************************************************
 ** method
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_methods;
create table clearing_house_commit.temp_tbl_methods as select * from public.tbl_methods where FALSE;

\copy clearing_house_commit.temp_tbl_methods from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_method.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_methods
    select *
    from clearing_house_commit.temp_tbl_methods ;

\echo Deployed method, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_methods', 'method_id');
\o

drop table if exists clearing_house_commit.temp_tbl_methods;



/************************************************************************************************************************************
 ** project
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_projects;
create table clearing_house_commit.temp_tbl_projects as select * from public.tbl_projects where FALSE;

\copy clearing_house_commit.temp_tbl_projects from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_project.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_projects
    select *
    from clearing_house_commit.temp_tbl_projects ;

\echo Deployed project, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_projects', 'project_id');
\o

drop table if exists clearing_house_commit.temp_tbl_projects;



/************************************************************************************************************************************
 ** dataset
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_datasets;
create table clearing_house_commit.temp_tbl_datasets as select * from public.tbl_datasets where FALSE;

\copy clearing_house_commit.temp_tbl_datasets from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_dataset.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_datasets
    select *
    from clearing_house_commit.temp_tbl_datasets ;

\echo Deployed dataset, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_datasets', 'dataset_id');
\o

drop table if exists clearing_house_commit.temp_tbl_datasets;



/************************************************************************************************************************************
 ** dataset_contact
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_dataset_contacts;
create table clearing_house_commit.temp_tbl_dataset_contacts as select * from public.tbl_dataset_contacts where FALSE;

\copy clearing_house_commit.temp_tbl_dataset_contacts from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_dataset_contact.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_dataset_contacts
    select *
    from clearing_house_commit.temp_tbl_dataset_contacts ;

\echo Deployed dataset_contact, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_dataset_contacts', 'dataset_contact_id');
\o

drop table if exists clearing_house_commit.temp_tbl_dataset_contacts;



/************************************************************************************************************************************
 ** dataset_submission
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_dataset_submissions;
create table clearing_house_commit.temp_tbl_dataset_submissions as select * from public.tbl_dataset_submissions where FALSE;

\copy clearing_house_commit.temp_tbl_dataset_submissions from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_dataset_submission.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_dataset_submissions
    select *
    from clearing_house_commit.temp_tbl_dataset_submissions ;

\echo Deployed dataset_submission, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_dataset_submissions', 'dataset_submission_id');
\o

drop table if exists clearing_house_commit.temp_tbl_dataset_submissions;



/************************************************************************************************************************************
 ** taxa_tree_order
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_taxa_tree_orders;
create table clearing_house_commit.temp_tbl_taxa_tree_orders as select * from public.tbl_taxa_tree_orders where FALSE;

\copy clearing_house_commit.temp_tbl_taxa_tree_orders from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_taxa_tree_order.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_taxa_tree_orders
    select *
    from clearing_house_commit.temp_tbl_taxa_tree_orders ;

\echo Deployed taxa_tree_order, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_taxa_tree_orders', 'order_id');
\o

drop table if exists clearing_house_commit.temp_tbl_taxa_tree_orders;



/************************************************************************************************************************************
 ** taxa_tree_family
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_taxa_tree_families;
create table clearing_house_commit.temp_tbl_taxa_tree_families as select * from public.tbl_taxa_tree_families where FALSE;

\copy clearing_house_commit.temp_tbl_taxa_tree_families from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_taxa_tree_family.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_taxa_tree_families
    select *
    from clearing_house_commit.temp_tbl_taxa_tree_families ;

\echo Deployed taxa_tree_family, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_taxa_tree_families', 'family_id');
\o

drop table if exists clearing_house_commit.temp_tbl_taxa_tree_families;



/************************************************************************************************************************************
 ** taxa_tree_genera
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_taxa_tree_genera;
create table clearing_house_commit.temp_tbl_taxa_tree_genera as select * from public.tbl_taxa_tree_genera where FALSE;

\copy clearing_house_commit.temp_tbl_taxa_tree_genera from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_taxa_tree_genera.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_taxa_tree_genera
    select *
    from clearing_house_commit.temp_tbl_taxa_tree_genera ;

\echo Deployed taxa_tree_genera, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_taxa_tree_genera', 'genus_id');
\o

drop table if exists clearing_house_commit.temp_tbl_taxa_tree_genera;



/************************************************************************************************************************************
 ** taxa_tree_master
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_taxa_tree_master;
create table clearing_house_commit.temp_tbl_taxa_tree_master as select * from public.tbl_taxa_tree_master where FALSE;

\copy clearing_house_commit.temp_tbl_taxa_tree_master from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_taxa_tree_master.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_taxa_tree_master
    select *
    from clearing_house_commit.temp_tbl_taxa_tree_master ;

\echo Deployed taxa_tree_master, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_taxa_tree_master', 'taxon_id');
\o

drop table if exists clearing_house_commit.temp_tbl_taxa_tree_master;



/************************************************************************************************************************************
 ** taxonomic_order
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_taxonomic_order;
create table clearing_house_commit.temp_tbl_taxonomic_order as select * from public.tbl_taxonomic_order where FALSE;

\copy clearing_house_commit.temp_tbl_taxonomic_order from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_taxonomic_order.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_taxonomic_order
    select *
    from clearing_house_commit.temp_tbl_taxonomic_order ;

\echo Deployed taxonomic_order, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_taxonomic_order', 'taxonomic_order_id');
\o

drop table if exists clearing_house_commit.temp_tbl_taxonomic_order;



/************************************************************************************************************************************
 ** value_type
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_value_types;
create table clearing_house_commit.temp_tbl_value_types as select * from public.tbl_value_types where FALSE;

\copy clearing_house_commit.temp_tbl_value_types from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_value_type.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_value_types
    select *
    from clearing_house_commit.temp_tbl_value_types ;

\echo Deployed value_type, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_value_types', 'value_type_id');
\o

drop table if exists clearing_house_commit.temp_tbl_value_types;



/************************************************************************************************************************************
 ** value_classe
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_value_classes;
create table clearing_house_commit.temp_tbl_value_classes as select * from public.tbl_value_classes where FALSE;

\copy clearing_house_commit.temp_tbl_value_classes from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_value_classe.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_value_classes
    select *
    from clearing_house_commit.temp_tbl_value_classes ;

\echo Deployed value_classe, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_value_classes', 'value_class_id');
\o

drop table if exists clearing_house_commit.temp_tbl_value_classes;



/************************************************************************************************************************************
 ** value_type_item
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_value_type_items;
create table clearing_house_commit.temp_tbl_value_type_items as select * from public.tbl_value_type_items where FALSE;

\copy clearing_house_commit.temp_tbl_value_type_items from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_value_type_item.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_value_type_items
    select *
    from clearing_house_commit.temp_tbl_value_type_items ;

\echo Deployed value_type_item, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_value_type_items', 'value_type_item_id');
\o

drop table if exists clearing_house_commit.temp_tbl_value_type_items;



/************************************************************************************************************************************
 ** abundance
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_abundances;
create table clearing_house_commit.temp_tbl_abundances as select * from public.tbl_abundances where FALSE;

\copy clearing_house_commit.temp_tbl_abundances from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_abundance.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_abundances
    select *
    from clearing_house_commit.temp_tbl_abundances ;

\echo Deployed abundance, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_abundances', 'abundance_id');
\o

drop table if exists clearing_house_commit.temp_tbl_abundances;



/************************************************************************************************************************************
 ** analysis_entity
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_analysis_entities;
create table clearing_house_commit.temp_tbl_analysis_entities as select * from public.tbl_analysis_entities where FALSE;

\copy clearing_house_commit.temp_tbl_analysis_entities from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_analysis_entity.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_analysis_entities
    select *
    from clearing_house_commit.temp_tbl_analysis_entities ;

\echo Deployed analysis_entity, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_analysis_entities', 'analysis_entity_id');
\o

drop table if exists clearing_house_commit.temp_tbl_analysis_entities;



/************************************************************************************************************************************
 ** analysis_value
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_analysis_values;
create table clearing_house_commit.temp_tbl_analysis_values as select * from public.tbl_analysis_values where FALSE;

\copy clearing_house_commit.temp_tbl_analysis_values from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_analysis_value.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_analysis_values
    select *
    from clearing_house_commit.temp_tbl_analysis_values ;

\echo Deployed analysis_value, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_analysis_values', 'analysis_value_id');
\o

drop table if exists clearing_house_commit.temp_tbl_analysis_values;



/************************************************************************************************************************************
 ** physical_sample
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_physical_samples;
create table clearing_house_commit.temp_tbl_physical_samples as select * from public.tbl_physical_samples where FALSE;

\copy clearing_house_commit.temp_tbl_physical_samples from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_physical_sample.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_physical_samples
    select *
    from clearing_house_commit.temp_tbl_physical_samples ;

\echo Deployed physical_sample, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_physical_samples', 'physical_sample_id');
\o

drop table if exists clearing_house_commit.temp_tbl_physical_samples;



/************************************************************************************************************************************
 ** relative_date
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_relative_dates;
create table clearing_house_commit.temp_tbl_relative_dates as select * from public.tbl_relative_dates where FALSE;

\copy clearing_house_commit.temp_tbl_relative_dates from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_relative_date.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_relative_dates
    select *
    from clearing_house_commit.temp_tbl_relative_dates ;

\echo Deployed relative_date, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_relative_dates', 'relative_date_id');
\o

drop table if exists clearing_house_commit.temp_tbl_relative_dates;



/************************************************************************************************************************************
 ** sample_alt_ref
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sample_alt_refs;
create table clearing_house_commit.temp_tbl_sample_alt_refs as select * from public.tbl_sample_alt_refs where FALSE;

\copy clearing_house_commit.temp_tbl_sample_alt_refs from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_sample_alt_ref.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_sample_alt_refs
    select *
    from clearing_house_commit.temp_tbl_sample_alt_refs ;

\echo Deployed sample_alt_ref, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_sample_alt_refs', 'sample_alt_ref_id');
\o

drop table if exists clearing_house_commit.temp_tbl_sample_alt_refs;



/************************************************************************************************************************************
 ** sample_group
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sample_groups;
create table clearing_house_commit.temp_tbl_sample_groups as select * from public.tbl_sample_groups where FALSE;

\copy clearing_house_commit.temp_tbl_sample_groups from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_sample_group.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_sample_groups
    select *
    from clearing_house_commit.temp_tbl_sample_groups ;

\echo Deployed sample_group, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_sample_groups', 'sample_group_id');
\o

drop table if exists clearing_house_commit.temp_tbl_sample_groups;



/************************************************************************************************************************************
 ** site_location
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_site_locations;
create table clearing_house_commit.temp_tbl_site_locations as select * from public.tbl_site_locations where FALSE;

\copy clearing_house_commit.temp_tbl_site_locations from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_site_location.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_site_locations
    select *
    from clearing_house_commit.temp_tbl_site_locations ;

\echo Deployed site_location, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_site_locations', 'site_location_id');
\o

drop table if exists clearing_house_commit.temp_tbl_site_locations;



/************************************************************************************************************************************
 ** site_reference
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_site_references;
create table clearing_house_commit.temp_tbl_site_references as select * from public.tbl_site_references where FALSE;

\copy clearing_house_commit.temp_tbl_site_references from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_site_reference.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_site_references
    select *
    from clearing_house_commit.temp_tbl_site_references ;

\echo Deployed site_reference, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_site_references', 'site_reference_id');
\o

drop table if exists clearing_house_commit.temp_tbl_site_references;



/************************************************************************************************************************************
 ** site
 ************************************************************************************************************************************/

drop table if exists clearing_house_commit.temp_tbl_sites;
create table clearing_house_commit.temp_tbl_sites as select * from public.tbl_sites where FALSE;

\copy clearing_house_commit.temp_tbl_sites from program 'zcat -qac 20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_site.gz' with (FORMAT text, DELIMITER E'\t', ENCODING 'utf-8');


insert into public.tbl_sites
    select *
    from clearing_house_commit.temp_tbl_sites ;

\echo Deployed site, rows inserted: :ROW_COUNT

\o /dev/null
select clearing_house_commit.reset_serial_id('public', 'tbl_sites', 'site_id');
\o

drop table if exists clearing_house_commit.temp_tbl_sites;


\o /dev/null
select clearing_house_commit.allocate_sequence_ids();
select clearing_house_commit.commit_submission(1);
\o
commit;

do $$
begin
    perform sead_utility.set_fk_is_deferrable('public', false, false);
end $$ language plpgsql;

