-- Deploy bugs: 20191221_DML_SUBMISSION_BUGS_20190303_COMMIT
set client_min_messages to warning;
\set autocommit off;
\t

set search_path TO public;

-- alter table public.tbl_abundances alter constraint fk_abundances_analysis_entity_id deferrable;
-- alter table public.tbl_abundances alter constraint fk_abundances_taxon_id deferrable;
-- alter table public.tbl_analysis_entities alter constraint fk_analysis_entities_dataset_id deferrable;
-- alter table public.tbl_analysis_entities alter constraint fk_analysis_entities_physical_sample_id deferrable;
-- alter table public.tbl_dataset_contacts alter constraint fk_dataset_contacts_dataset_id deferrable;
-- alter table public.tbl_ecocode_definitions alter constraint fk_ecocode_definitions_ecocode_group_id deferrable;
-- alter table public.tbl_ecocodes alter constraint fk_ecocodes_taxon_id deferrable;
-- alter table public.tbl_physical_samples alter constraint fk_samples_sample_group_id deferrable;
-- alter table public.tbl_rdb alter constraint fk_rdb_rdb_code_id deferrable;
-- alter table public.tbl_rdb alter constraint fk_rdb_taxon_id deferrable;
-- alter table public.tbl_rdb_codes alter constraint fk_rdb_codes_rdb_system_id deferrable;
-- alter table public.tbl_sample_groups alter constraint fk_sample_groups_site_id deferrable;
-- alter table public.tbl_site_locations alter constraint fk_locations_site_id deferrable;
-- alter table public.tbl_site_other_records alter constraint fk_site_other_records_site_id deferrable;
-- alter table public.tbl_site_references alter constraint fk_site_references_site_id deferrable;
-- alter table public.tbl_species_associations alter constraint fk_species_associations_associated_taxon_id deferrable;
-- alter table public.tbl_species_associations alter constraint fk_species_associations_taxon_id deferrable;
-- alter table public.tbl_taxa_measured_attributes alter constraint fk_taxa_measured_attributes_taxon_id deferrable;
-- alter table public.tbl_taxa_seasonality alter constraint fk_taxa_seasonality_taxon_id deferrable;

do $$
begin
    perform sead_utility.set_fk_is_deferrable('public', true, false);
end $$ language plpgsql;

begin;

set constraints fk_abundances_analysis_entity_id deferred;
set constraints fk_abundances_taxon_id deferred;
set constraints fk_analysis_entities_dataset_id deferred;
set constraints fk_analysis_entities_physical_sample_id deferred;
set constraints fk_dataset_contacts_dataset_id deferred;
set constraints fk_ecocode_definitions_ecocode_group_id deferred;
set constraints fk_ecocodes_taxon_id deferred;
set constraints fk_samples_sample_group_id deferred;
set constraints fk_rdb_rdb_code_id deferred;
set constraints fk_rdb_taxon_id deferred;
set constraints fk_rdb_codes_rdb_system_id deferred;
set constraints fk_sample_groups_site_id deferred;
set constraints fk_locations_site_id deferred;
set constraints fk_site_other_records_site_id deferred;
set constraints fk_site_references_site_id deferred;
set constraints fk_species_associations_associated_taxon_id deferred;
set constraints fk_species_associations_taxon_id deferred;
set constraints fk_taxa_measured_attributes_taxon_id deferred;
set constraints fk_taxa_seasonality_taxon_id deferred;


\ir 20191221_DML_SUBMISSION_BUGS_20190303_COMMIT/bugs_import_schema.sql
\ir 20191221_DML_SUBMISSION_BUGS_20190303_COMMIT/public_data_diff.sql


commit;

do $$
begin
    perform sead_utility.set_fk_is_deferrable('public', false, false);
end $$ language plpgsql;


-- alter table public.tbl_abundances alter constraint fk_abundances_analysis_entity_id not deferrable;
-- alter table public.tbl_abundances alter constraint fk_abundances_taxon_id not deferrable;
-- alter table public.tbl_analysis_entities alter constraint fk_analysis_entities_dataset_id not deferrable;
-- alter table public.tbl_analysis_entities alter constraint fk_analysis_entities_physical_sample_id not deferrable;
-- alter table public.tbl_dataset_contacts alter constraint fk_dataset_contacts_dataset_id not deferrable;
-- alter table public.tbl_ecocode_definitions alter constraint fk_ecocode_definitions_ecocode_group_id not deferrable;
-- alter table public.tbl_ecocodes alter constraint fk_ecocodes_taxon_id not deferrable;
-- alter table public.tbl_physical_samples alter constraint fk_samples_sample_group_id not deferrable;
-- alter table public.tbl_rdb alter constraint fk_rdb_rdb_code_id not deferrable;
-- alter table public.tbl_rdb alter constraint fk_rdb_taxon_id not deferrable;
-- alter table public.tbl_rdb_codes alter constraint fk_rdb_codes_rdb_system_id not deferrable;
-- alter table public.tbl_sample_groups alter constraint fk_sample_groups_site_id not deferrable;
-- alter table public.tbl_site_locations alter constraint fk_locations_site_id not deferrable;
-- alter table public.tbl_site_other_records alter constraint fk_site_other_records_site_id not deferrable;
-- alter table public.tbl_site_references alter constraint fk_site_references_site_id not deferrable;
-- alter table public.tbl_species_associations alter constraint fk_species_associations_associated_taxon_id not deferrable;
-- alter table public.tbl_species_associations alter constraint fk_species_associations_taxon_id not deferrable;
-- alter table public.tbl_taxa_measured_attributes alter constraint fk_taxa_measured_attributes_taxon_id not deferrable;
-- alter table public.tbl_taxa_seasonality alter constraint fk_taxa_seasonality_taxon_id not deferrable;

