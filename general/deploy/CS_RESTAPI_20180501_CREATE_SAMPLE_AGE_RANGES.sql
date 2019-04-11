-- Deploy sead_db_change_control:CSA_20180501_GENERATE_REST_API_SAMPLE_AGE_RANGES to pg

BEGIN;

/****************************************************************************************************************
  Change author
    Roger Mähler, 2018-0-
  Change description
    New schema used for POSTGREST REST API publication of SEAD base table
  Risk assessment
  Planning
    Low risk
  Change execution and rollback
    Apply this script.
    Steps to verify change: N/A
    Steps to rollback change: N/A
  Change prerequisites (e.g. tests)
  Change reviewer
  Change Approver Signoff
  Notes:
  Impact on dependent modules
*****************************************************************************************************************/

create or replace view postgrest_default_api.site_sample_taxon_abundance as
	select
	  tbl_sites.site_id									as locale_id,
	  tbl_sites.site_name								as locale_name,
	  tbl_sites.latitude_dd								as lat,
	  tbl_sites.longitude_dd							as lon,
	  tbl_physical_samples.physical_sample_id			as sample_id,
	  tbl_physical_samples.sample_name					as sample_name,
	  tbl_taxa_tree_orders.order_name					as order_name,
	  tbl_taxa_tree_families.family_name				as family_name,
	  tbl_taxa_tree_genera.genus_name					as genus_name,
	  tbl_taxa_tree_master.species						as species,
	  concat_ws(' ', family_name, genus_name, species)	as taxon,
	  tbl_taxa_tree_master.taxon_id						as taxon_id,
	  tbl_analysis_entities.analysis_entity_id			as analysis_entity_id,
	  tbl_abundances.abundance_id						as occ_id,
	  tbl_abundances.abundance							as abundance,
	  tbl_datasets.dataset_id			 				as dataset_id,
	  'sead'::text										as source
	from tbl_analysis_entities
	left join tbl_datasets
	  on tbl_analysis_entities."dataset_id" = tbl_datasets."dataset_id"
	--left join tbl_methods
	--  on tbl_datasets."method_id" = tbl_methods."method_id"
	left join tbl_physical_samples
	  on tbl_analysis_entities."physical_sample_id" = tbl_physical_samples."physical_sample_id"
	left join tbl_sample_groups
	  on tbl_physical_samples."sample_group_id" = tbl_sample_groups."sample_group_id"
	left join tbl_sites
	  on tbl_sample_groups."site_id" = tbl_sites."site_id"
	left join tbl_abundances
	  on tbl_abundances.analysis_entity_id =  tbl_analysis_entities."analysis_entity_id"
	left join tbl_taxa_tree_master
	  on tbl_taxa_tree_master.taxon_id =  tbl_abundances."taxon_id"
	left join tbl_taxa_tree_genera
	  on tbl_taxa_tree_genera.genus_id =  tbl_taxa_tree_master."genus_id"
	left join tbl_taxa_tree_families
	  on tbl_taxa_tree_families.family_id =  tbl_taxa_tree_genera."family_id"
	left join tbl_taxa_tree_orders
	  on tbl_taxa_tree_orders.order_id =  tbl_taxa_tree_families."order_id"
	where
	  abundance>0
	order by taxon;

create or replace view postgrest_default_api.sample_age_ranges as
	select
	  tbl_sites.site_id                                 as site_id,
	  tbl_sites.site_name                               as site_name,
	  tbl_sites.altitude                                as elevation,
	  tbl_sites.latitude_dd                             as lat,
	  tbl_sites.longitude_dd                            as lon,
	  tbl_physical_samples.physical_sample_id			as sample_id,
	  tbl_physical_samples.sample_name					as sample_name,
	  tbl_analysis_entities.analysis_entity_id          as analysis_entity_id,
	  tbl_analysis_entity_ages.age_older				as max_age,
	  tbl_analysis_entity_ages.age_younger				as min_age,
	  numrange(
		tbl_analysis_entity_ages.age_older,
	  	tbl_analysis_entity_ages.age_younger
	  )													as age_range,
	  'sead'::text 										as source
	from tbl_analysis_entities
	left join tbl_physical_samples
	  on tbl_analysis_entities."physical_sample_id" = tbl_physical_samples."physical_sample_id"
	left join tbl_sample_groups
	  on tbl_physical_samples."sample_group_id" = tbl_sample_groups."sample_group_id"
	left join tbl_sites
	  on tbl_sample_groups."site_id" = tbl_sites."site_id"
	left join tbl_analysis_entity_ages
      on tbl_analysis_entities."analysis_entity_id"=tbl_analysis_entity_ages."analysis_entity_id"
	order by max_age;

Grant Select On all tables in Schema postgrest_default_api, public To humlab_read, humlab_admin, anonymous_rest_user;

COMMIT;
