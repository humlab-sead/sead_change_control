
## Initial MAL submission

### Create MAL (startingpoint) database

This database is equivalent to `sead_master_9`.

```bash
./bin/deploy-staging --create-database --on-conflict drop \
        --source-type dump \
        --source ./starting_point/sead_master_9_public.sql.gz \
        --target-db-name sead_staging_mal \
        --deploy-starting-point
```
Generate a script of the database as startingpoint for cr SEAD_DATABASE_MODEL.

```bash
pg_dump -U humlab_admin -h humlabseadserv.srv.its.umu.se \
        -d sead_staging_mal --schema-only --format=p \
        --no-security-labels --no-tablespaces --file=sead_model/public_pg_dump.sql --schema=public --create
```

### Generate dump of MAL data


```bash
./bin/export-database --target-folder mal/data sead_staging_mal public --verbose
```

Dump has also been create using NaviCat 16. See folder `sead_models/deploy/dumps`.

```log
copied: tbl_abundance_elements (49 rows)
copied: tbl_abundance_ident_levels (480 rows)
copied: tbl_abundance_modifications (7594 rows)
copied: tbl_abundances (8403 rows)
copied: tbl_activity_types (10 rows)
copied: tbl_aggregate_order_types (8 rows)
copied: tbl_alt_ref_types (8 rows)
copied: tbl_analysis_entities (94507 rows)
copied: tbl_analysis_entity_prep_methods (34477 rows)
copied: tbl_biblio (5554 rows)
copied: tbl_ceramics_measurements (26 rows)
copied: tbl_collections_or_journals (2219 rows)
copied: tbl_contact_types (8 rows)
copied: tbl_contacts (1 rows)
copied: tbl_coordinate_method_dimensions (32 rows)
copied: tbl_data_type_groups (7 rows)
copied: tbl_data_types (12 rows)
copied: tbl_dataset_masters (2 rows)
copied: tbl_dataset_submission_types (11 rows)
copied: tbl_datasets (2967 rows)
copied: tbl_dating_labs (227 rows)
copied: tbl_dating_uncertainty (8 rows)
copied: tbl_dendro_measurements (12 rows)
copied: tbl_dimensions (32 rows)
copied: tbl_ecocode_definitions (136 rows)
copied: tbl_ecocode_groups (3 rows)
copied: tbl_ecocode_systems (3 rows)
copied: tbl_ecocodes (14362 rows)
copied: tbl_feature_types (41 rows)
copied: tbl_features (1742 rows)
copied: tbl_horizons (122 rows)
copied: tbl_identification_levels (6 rows)
copied: tbl_image_types (8 rows)
copied: tbl_languages (2 rows)
copied: tbl_location_types (14 rows)
copied: tbl_locations (1191 rows)
copied: tbl_measured_values (91617 rows)
copied: tbl_method_groups (15 rows)
copied: tbl_methods (114 rows)
copied: tbl_modification_types (10 rows)
copied: tbl_physical_sample_features (4688 rows)
copied: tbl_physical_samples (25450 rows)
copied: tbl_project_stages (4 rows)
copied: tbl_project_types (3 rows)
copied: tbl_publication_types (26 rows)
copied: tbl_publishers (1907 rows)
copied: tbl_record_types (19 rows)
copied: tbl_relative_age_types (13 rows)
copied: tbl_relative_ages (275 rows)
copied: tbl_sample_alt_refs (9787 rows)
copied: tbl_sample_coordinates (56928 rows)
copied: tbl_sample_description_sample_group_contexts (5 rows)
copied: tbl_sample_description_types (4 rows)
copied: tbl_sample_dimensions (681 rows)
copied: tbl_sample_group_description_type_sampling_contexts (15 rows)
copied: tbl_sample_group_description_types (3 rows)
copied: tbl_sample_group_dimensions (2 rows)
copied: tbl_sample_group_references (967 rows)
copied: tbl_sample_group_sampling_contexts (14 rows)
copied: tbl_sample_groups (931 rows)
copied: tbl_sample_horizons (7857 rows)
copied: tbl_sample_notes (5357 rows)
copied: tbl_sample_types (14 rows)
copied: tbl_season_types (3 rows)
copied: tbl_seasons (18 rows)
copied: tbl_site_locations (2114 rows)
copied: tbl_site_references (94 rows)
copied: tbl_sites (378 rows)
copied: tbl_species_association_types (83 rows)
copied: tbl_species_associations (856 rows)
copied: tbl_taxa_common_names (4272 rows)
copied: tbl_taxa_tree_authors (3101 rows)
copied: tbl_taxa_tree_families (528 rows)
copied: tbl_taxa_tree_genera (3950 rows)
copied: tbl_taxa_tree_master (16664 rows)
copied: tbl_taxa_tree_orders (55 rows)
copied: tbl_taxonomic_order (10622 rows)
copied: tbl_taxonomic_order_systems (1 rows)
copied: tbl_units (14 rows)
skipped: tbl_aggregate_datasets (empty)
skipped: tbl_aggregate_sample_ages (empty)
skipped: tbl_aggregate_samples (empty)
skipped: tbl_analysis_entity_ages (empty)
skipped: tbl_analysis_entity_dimensions (empty)
skipped: tbl_biblio_keywords (empty)
skipped: tbl_ceramics (empty)
skipped: tbl_ceramics_measurement_lookup (empty)
skipped: tbl_chron_control_types (empty)
skipped: tbl_chron_controls (empty)
skipped: tbl_chronologies (empty)
skipped: tbl_colours (empty)
skipped: tbl_dataset_contacts (empty)
skipped: tbl_dataset_submissions (empty)
skipped: tbl_dating_material (empty)
skipped: tbl_dendro (empty)
skipped: tbl_dendro_date_notes (empty)
skipped: tbl_dendro_dates (empty)
skipped: tbl_dendro_measurement_lookup (empty)
skipped: tbl_geochron_refs (empty)
skipped: tbl_geochronology (empty)
skipped: tbl_imported_taxa_replacements (empty)
skipped: tbl_keywords (empty)
skipped: tbl_lithology (empty)
skipped: tbl_mcr_names (empty)
skipped: tbl_mcr_summary_data (empty)
skipped: tbl_mcrdata_birmbeetledat (empty)
skipped: tbl_measured_value_dimensions (empty)
skipped: tbl_projects (empty)
skipped: tbl_radiocarbon_calibration (empty)
skipped: tbl_rdb (empty)
skipped: tbl_rdb_codes (empty)
skipped: tbl_rdb_systems (empty)
skipped: tbl_relative_age_refs (empty)
skipped: tbl_relative_dates (empty)
skipped: tbl_sample_colours (empty)
skipped: tbl_sample_descriptions (empty)
skipped: tbl_sample_group_coordinates (empty)
skipped: tbl_sample_group_descriptions (empty)
skipped: tbl_sample_group_images (empty)
skipped: tbl_sample_group_notes (empty)
skipped: tbl_sample_images (empty)
skipped: tbl_sample_location_type_sampling_contexts (empty)
skipped: tbl_sample_location_types (empty)
skipped: tbl_sample_locations (empty)
skipped: tbl_site_images (empty)
skipped: tbl_site_natgridrefs (empty)
skipped: tbl_site_other_records (empty)
skipped: tbl_site_preservation_status (empty)
skipped: tbl_taxa_images (empty)
skipped: tbl_taxa_measured_attributes (empty)
skipped: tbl_taxa_reference_specimens (empty)
skipped: tbl_taxa_seasonality (empty)
skipped: tbl_taxa_synonyms (empty)
skipped: tbl_taxonomic_order_biblio (empty)
skipped: tbl_taxonomy_notes (empty)
skipped: tbl_tephra_dates (empty)
skipped: tbl_tephra_refs (empty)
skipped: tbl_tephras (empty)
skipped: tbl_text_biology (empty)
skipped: tbl_text_distribution (empty)
skipped: tbl_text_identification_keys (empty)
skipped: tbl_updates_log (empty)
skipped: tbl_years_types (empty)

info: dumped 79 tables to folder "mal/data" (ignored 64 empty tables)

```
*/