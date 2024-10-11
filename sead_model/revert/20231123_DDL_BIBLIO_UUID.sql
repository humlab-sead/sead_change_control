-- Revert general: 20231123_DDL_BIBLIO_UUID

begin;

    drop view if exists view_bibliography_references;
    drop table if exists bibliography_references;

    alter table tbl_aggregate_datasets
        drop column if exists aggregate_dataset_uuid;

    alter table tbl_dataset_masters
        drop column if exists master_set_uuid;

    alter table tbl_datasets
        drop column if exists dataset_uuid;

    alter table tbl_ecocode_systems
        drop column if exists ecocode_system_uuid;

    alter table tbl_methods
        drop column if exists method_uuid;

    alter table tbl_rdb_systems
        drop column if exists rdb_system_uuid;

    alter table tbl_taxonomy_notes
        drop column if exists taxonomy_notes_uuid;

    alter table tbl_text_biology
        drop column if exists biology_uuid;

    alter table tbl_text_distribution
        drop column if exists distribution_uuid;

    alter table tbl_text_identification_keys
        drop column if exists key_uuid;

    alter table tbl_relative_ages
        drop column if exists relative_age_uuid;

    alter table tbl_sites
        drop column if exists site_uuid;

    alter table tbl_sample_groups
        drop column if exists sample_group_uuid;

    alter table tbl_geochronology
        drop column if exists geochron_uuid;

    alter table tbl_taxonomic_order_systems
        drop column if exists taxonomic_order_system_uuid;

    alter table tbl_tephras
        drop column if exists tephra_uuid;

    alter table tbl_site_other_records
        drop column if exists site_other_records_uuid;

    alter table tbl_species_associations
        drop column if exists species_association_uuid;

    alter table tbl_taxa_synonyms
        drop column if exists synonym_uuid;

    alter table tbl_biblio
        drop column if exists biblio_uuid;

commit;
