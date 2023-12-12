-- Revert sead_change_control:20231123_DDL_UUID from pg

begin;

    drop table if exists bibliography_references;

    alter table tbl_ecocode_systems drop column if exists uuid;
    alter table tbl_dataset_masters drop column if exists uuid;
    alter table tbl_datasets drop column if exists uuid;
    alter table tbl_aggregate_datasets drop column if exists uuid;
    alter table tbl_taxonomy_notes drop column if exists uuid;
    alter table tbl_methods drop column if exists uuid;
    alter table tbl_rdb_systems drop column if exists uuid;
    alter table tbl_text_biology drop column if exists uuid;
    alter table tbl_text_distribution drop column if exists uuid;
    alter table tbl_text_identification_keys drop column if exists uuid;
    alter table tbl_relative_ages drop column if exists uuid;
    alter table tbl_sites drop column if exists uuid;
    alter table tbl_sample_groups drop column if exists uuid;
    alter table tbl_geochronology drop column if exists uuid;
    alter table tbl_taxonomic_order_systems drop column if exists uuid;
    alter table tbl_tephras drop column if exists uuid;

    alter table tbl_species_associations drop column if exists biblio_uuid;
    alter table tbl_taxa_synonyms drop column if exists biblio_uuid;
    alter table tbl_site_other_records drop column if exists biblio_uuid;

    alter table tbl_biblio drop column if exists uuid;


commit;
