\copy public.tbl_abundance_elements from program 'zcat -qac mal/data/tbl_abundance_elements.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_abundance_ident_levels from program 'zcat -qac mal/data/tbl_abundance_ident_levels.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_abundance_modifications from program 'zcat -qac mal/data/tbl_abundance_modifications.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_abundances from program 'zcat -qac mal/data/tbl_abundances.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_activity_types from program 'zcat -qac mal/data/tbl_activity_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_aggregate_order_types from program 'zcat -qac mal/data/tbl_aggregate_order_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_alt_ref_types from program 'zcat -qac mal/data/tbl_alt_ref_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_analysis_entities from program 'zcat -qac mal/data/tbl_analysis_entities.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_analysis_entity_prep_methods from program 'zcat -qac mal/data/tbl_analysis_entity_prep_methods.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_biblio from program 'zcat -qac mal/data/tbl_biblio.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_ceramics_measurements from program 'zcat -qac mal/data/tbl_ceramics_measurements.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_collections_or_journals from program 'zcat -qac mal/data/tbl_collections_or_journals.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_contact_types from program 'zcat -qac mal/data/tbl_contact_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_contacts from program 'zcat -qac mal/data/tbl_contacts.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_coordinate_method_dimensions from program 'zcat -qac mal/data/tbl_coordinate_method_dimensions.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_data_type_groups from program 'zcat -qac mal/data/tbl_data_type_groups.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_data_types from program 'zcat -qac mal/data/tbl_data_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_dataset_masters from program 'zcat -qac mal/data/tbl_dataset_masters.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_dataset_submission_types from program 'zcat -qac mal/data/tbl_dataset_submission_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_datasets from program 'zcat -qac mal/data/tbl_datasets.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_dating_labs from program 'zcat -qac mal/data/tbl_dating_labs.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_dating_uncertainty from program 'zcat -qac mal/data/tbl_dating_uncertainty.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_dendro_measurements from program 'zcat -qac mal/data/tbl_dendro_measurements.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_dimensions from program 'zcat -qac mal/data/tbl_dimensions.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_ecocode_definitions from program 'zcat -qac mal/data/tbl_ecocode_definitions.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_ecocode_groups from program 'zcat -qac mal/data/tbl_ecocode_groups.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_ecocode_systems from program 'zcat -qac mal/data/tbl_ecocode_systems.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_ecocodes from program 'zcat -qac mal/data/tbl_ecocodes.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_feature_types from program 'zcat -qac mal/data/tbl_feature_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_features from program 'zcat -qac mal/data/tbl_features.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_horizons from program 'zcat -qac mal/data/tbl_horizons.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_identification_levels from program 'zcat -qac mal/data/tbl_identification_levels.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_image_types from program 'zcat -qac mal/data/tbl_image_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_languages from program 'zcat -qac mal/data/tbl_languages.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_location_types from program 'zcat -qac mal/data/tbl_location_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_locations from program 'zcat -qac mal/data/tbl_locations.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_measured_values from program 'zcat -qac mal/data/tbl_measured_values.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_method_groups from program 'zcat -qac mal/data/tbl_method_groups.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_methods from program 'zcat -qac mal/data/tbl_methods.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_modification_types from program 'zcat -qac mal/data/tbl_modification_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_physical_sample_features from program 'zcat -qac mal/data/tbl_physical_sample_features.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_physical_samples from program 'zcat -qac mal/data/tbl_physical_samples.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_project_stages from program 'zcat -qac mal/data/tbl_project_stages.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_project_types from program 'zcat -qac mal/data/tbl_project_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_publication_types from program 'zcat -qac mal/data/tbl_publication_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_publishers from program 'zcat -qac mal/data/tbl_publishers.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_record_types from program 'zcat -qac mal/data/tbl_record_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_relative_age_types from program 'zcat -qac mal/data/tbl_relative_age_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_relative_ages from program 'zcat -qac mal/data/tbl_relative_ages.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_sample_alt_refs from program 'zcat -qac mal/data/tbl_sample_alt_refs.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_sample_coordinates from program 'zcat -qac mal/data/tbl_sample_coordinates.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_sample_description_sample_group_contexts from program 'zcat -qac mal/data/tbl_sample_description_sample_group_contexts.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_sample_description_types from program 'zcat -qac mal/data/tbl_sample_description_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_sample_dimensions from program 'zcat -qac mal/data/tbl_sample_dimensions.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_sample_group_description_type_sampling_contexts from program 'zcat -qac mal/data/tbl_sample_group_description_type_sampling_contexts.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_sample_group_description_types from program 'zcat -qac mal/data/tbl_sample_group_description_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_sample_group_dimensions from program 'zcat -qac mal/data/tbl_sample_group_dimensions.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_sample_group_references from program 'zcat -qac mal/data/tbl_sample_group_references.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_sample_group_sampling_contexts from program 'zcat -qac mal/data/tbl_sample_group_sampling_contexts.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_sample_groups from program 'zcat -qac mal/data/tbl_sample_groups.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_sample_horizons from program 'zcat -qac mal/data/tbl_sample_horizons.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_sample_notes from program 'zcat -qac mal/data/tbl_sample_notes.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_sample_types from program 'zcat -qac mal/data/tbl_sample_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_season_types from program 'zcat -qac mal/data/tbl_season_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_seasons from program 'zcat -qac mal/data/tbl_seasons.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_site_locations from program 'zcat -qac mal/data/tbl_site_locations.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_site_references from program 'zcat -qac mal/data/tbl_site_references.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_sites from program 'zcat -qac mal/data/tbl_sites.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_species_association_types from program 'zcat -qac mal/data/tbl_species_association_types.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_species_associations from program 'zcat -qac mal/data/tbl_species_associations.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_taxa_common_names from program 'zcat -qac mal/data/tbl_taxa_common_names.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_taxa_tree_authors from program 'zcat -qac mal/data/tbl_taxa_tree_authors.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_taxa_tree_families from program 'zcat -qac mal/data/tbl_taxa_tree_families.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_taxa_tree_genera from program 'zcat -qac mal/data/tbl_taxa_tree_genera.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_taxa_tree_master from program 'zcat -qac mal/data/tbl_taxa_tree_master.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_taxa_tree_orders from program 'zcat -qac mal/data/tbl_taxa_tree_orders.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_taxonomic_order from program 'zcat -qac mal/data/tbl_taxonomic_order.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_taxonomic_order_systems from program 'zcat -qac mal/data/tbl_taxonomic_order_systems.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');
\copy public.tbl_units from program 'zcat -qac mal/data/tbl_units.sql.gz' with (format text, delimiter E'\t', encoding 'utf-8');