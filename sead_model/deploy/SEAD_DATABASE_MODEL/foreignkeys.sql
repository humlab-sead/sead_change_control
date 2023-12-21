-- begin;
-- do $$
-- declare _t record;
-- declare _sql text;
-- begin
--     for _t in (
-- 		with foreign_key_columns (table_name, constraint_name, foreign_key, referenced_table_name, reference_column_name, on_delete, on_update) as ( values
-- 			('tbl_abundance_elements', 'fk_abundance_elements_record_type_id', 'record_type_id', 'tbl_record_types', 'record_type_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_abundance_ident_levels', 'fk_abundance_ident_levels_abundance_id', 'abundance_id', 'tbl_abundances', 'abundance_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_abundance_ident_levels', 'fk_abundance_ident_levels_identification_level_id', 'identification_level_id', 'tbl_identification_levels', 'identification_level_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_abundance_modifications', 'fk_abundance_modifications_abundance_id', 'abundance_id', 'tbl_abundances', 'abundance_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_abundance_modifications', 'fk_abundance_modifications_modification_type_id', 'modification_type_id', 'tbl_modification_types', 'modification_type_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_abundances', 'fk_abundances_abundance_elements_id', 'abundance_element_id', 'tbl_abundance_elements', 'abundance_element_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_abundances', 'fk_abundances_analysis_entity_id', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_abundances', 'fk_abundances_taxon_id', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 'CASCADE', 'CASCADE'), 
-- 			('tbl_aggregate_datasets', 'fk_aggregate_datasets_aggregate_order_type_id', 'aggregate_order_type_id', 'tbl_aggregate_order_types', 'aggregate_order_type_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_aggregate_datasets', 'fk_aggregate_datasets_biblio_id', 'biblio_id', 'tbl_biblio', 'biblio_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_aggregate_sample_ages', 'fk_aggregate_sample_ages_aggregate_dataset_id', 'aggregate_dataset_id', 'tbl_aggregate_datasets', 'aggregate_dataset_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_aggregate_sample_ages', 'fk_aggregate_sample_ages_analysis_entity_age_id', 'analysis_entity_age_id', 'tbl_analysis_entity_ages', 'analysis_entity_age_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_aggregate_samples', 'fk_aggragate_samples_analysis_entity_id', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_aggregate_samples', 'fk_aggregate_samples_aggregate_dataset_id', 'aggregate_dataset_id', 'tbl_aggregate_datasets', 'aggregate_dataset_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_analysis_entities', 'fk_analysis_entities_dataset_id', 'dataset_id', 'tbl_datasets', 'dataset_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_analysis_entities', 'fk_analysis_entities_physical_sample_id', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_analysis_entity_ages', 'fk_analysis_entity_ages_analysis_entity_id', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_analysis_entity_ages', 'fk_analysis_entity_ages_chronology_id', 'chronology_id', 'tbl_chronologies', 'chronology_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_analysis_entity_dimensions', 'fk_analysis_entity_dimensions_analysis_entity_id', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 'CASCADE', 'CASCADE'), 
-- 			('tbl_analysis_entity_dimensions', 'fk_analysis_entity_dimensions_dimension_id', 'dimension_id', 'tbl_dimensions', 'dimension_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_analysis_entity_prep_methods', 'fk_analysis_entity_prep_methods_analysis_entity_id', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_analysis_entity_prep_methods', 'fk_analysis_entity_prep_methods_method_id', 'method_id', 'tbl_methods', 'method_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_biblio', 'fk_biblio_collections_or_journals_id', 'collection_or_journal_id', 'tbl_collections_or_journals', 'collection_or_journal_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_biblio', 'fk_biblio_publication_type_id', 'publication_type_id', 'tbl_publication_types', 'publication_type_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_biblio', 'fk_biblio_publisher_id', 'publisher_id', 'tbl_publishers', 'publisher_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_biblio_keywords', 'fk_biblio_keywords_biblio_id', 'biblio_id', 'tbl_biblio', 'biblio_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_biblio_keywords', 'fk_biblio_keywords_keyword_id', 'keyword_id', 'tbl_keywords', 'keyword_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_ceramics', 'fk_ceramics_analysis_entity_id', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_ceramics', 'fk_ceramics_ceramics_measurement_id', 'ceramics_measurement_id', 'tbl_ceramics_measurements', 'ceramics_measurement_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_ceramics_measurement_lookup', 'fk_ceramics_measurement_lookup_ceramics_measurements_id', 'ceramics_measurement_id', 'tbl_ceramics_measurements', 'ceramics_measurement_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_ceramics_measurements', 'fk_ceramics_measurements_method_id', 'method_id', 'tbl_methods', 'method_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_chron_controls', 'fk_chron_controls_chron_control_type_id', 'chron_control_type_id', 'tbl_chron_control_types', 'chron_control_type_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_chron_controls', 'fk_chron_controls_chronology_id', 'chronology_id', 'tbl_chronologies', 'chronology_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_chronologies', 'fk_chronologies_contact_id', 'contact_id', 'tbl_contacts', 'contact_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_chronologies', 'fk_chronologies_sample_group_id', 'sample_group_id', 'tbl_sample_groups', 'sample_group_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_collections_or_journals', 'fk_collections_or_journals_publisher_id', 'publisher_id', 'tbl_publishers', 'publisher_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_colours', 'fk_colours_method_id', 'method_id', 'tbl_methods', 'method_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_coordinate_method_dimensions', 'fk_coordinate_method_dimensions_dimensions_id', 'dimension_id', 'tbl_dimensions', 'dimension_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_coordinate_method_dimensions', 'fk_coordinate_method_dimensions_method_id', 'method_id', 'tbl_methods', 'method_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_data_types', 'fk_data_types_data_type_group_id', 'data_type_group_id', 'tbl_data_type_groups', 'data_type_group_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_dataset_contacts', 'fk_dataset_contacts_contact_id', 'contact_id', 'tbl_contacts', 'contact_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_dataset_contacts', 'fk_dataset_contacts_contact_type_id', 'contact_type_id', 'tbl_contact_types', 'contact_type_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_dataset_contacts', 'fk_dataset_contacts_dataset_id', 'dataset_id', 'tbl_datasets', 'dataset_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_dataset_masters', 'fk_dataset_masters_biblio_id', 'biblio_id', 'tbl_biblio', 'biblio_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_dataset_masters', 'fk_dataset_masters_contact_id', 'contact_id', 'tbl_contacts', 'contact_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_dataset_submissions', 'fk_dataset_submission_submission_type_id', 'submission_type_id', 'tbl_dataset_submission_types', 'submission_type_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_dataset_submissions', 'fk_dataset_submissions_contact_id', 'contact_id', 'tbl_contacts', 'contact_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_dataset_submissions', 'fk_dataset_submissions_dataset_id', 'dataset_id', 'tbl_datasets', 'dataset_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_datasets', 'fk_datasets_biblio_id', 'biblio_id', 'tbl_biblio', 'biblio_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_datasets', 'fk_datasets_data_type_id', 'data_type_id', 'tbl_data_types', 'data_type_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_datasets', 'fk_datasets_master_set_id', 'master_set_id', 'tbl_dataset_masters', 'master_set_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_datasets', 'fk_datasets_method_id', 'method_id', 'tbl_methods', 'method_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_datasets', 'fk_datasets_project_id', 'project_id', 'tbl_projects', 'project_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_datasets', 'fk_datasets_updated_dataset_id', 'updated_dataset_id', 'tbl_datasets', 'dataset_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_dating_labs', 'fk_dating_labs_contact_id', 'contact_id', 'tbl_contacts', 'contact_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_dating_material', 'fk_dating_material_abundance_elements_id', 'abundance_element_id', 'tbl_abundance_elements', 'abundance_element_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_dating_material', 'fk_dating_material_geochronology_geochron_id', 'geochron_id', 'tbl_geochronology', 'geochron_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_dating_material', 'fk_dating_material_taxa_tree_master_taxon_id', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_dendro', 'fk_dendro_analysis_entity_id', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_dendro', 'fk_dendro_dendro_measurement_id', 'dendro_measurement_id', 'tbl_dendro_measurements', 'dendro_measurement_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_dendro_date_notes', 'fk_dendro_date_notes_dendro_date_id', 'dendro_date_id', 'tbl_dendro_dates', 'dendro_date_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_dendro_dates', 'fk_dendro_dates_analysis_entity_id', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_dendro_dates', 'fk_dendro_dates_dating_uncertainty_id', 'dating_uncertainty_id', 'tbl_dating_uncertainty', 'dating_uncertainty_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_dendro_dates', 'fk_dendro_dates_years_type_id', 'years_type_id', 'tbl_years_types', 'years_type_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_dendro_measurement_lookup', 'fk_dendro_measurement_lookup_dendro_measurement_id', 'dendro_measurement_id', 'tbl_dendro_measurements', 'dendro_measurement_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_dendro_measurements', 'fk_dendro_measurements_method_id', 'method_id', 'tbl_methods', 'method_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_dimensions', 'fk_dimensions_method_group_id', 'method_group_id', 'tbl_method_groups', 'method_group_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_dimensions', 'fk_dimensions_unit_id', 'unit_id', 'tbl_units', 'unit_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_ecocode_definitions', 'fk_ecocode_definitions_ecocode_group_id', 'ecocode_group_id', 'tbl_ecocode_groups', 'ecocode_group_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_ecocode_groups', 'fk_ecocode_groups_ecocode_system_id', 'ecocode_system_id', 'tbl_ecocode_systems', 'ecocode_system_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_ecocode_systems', 'fk_ecocode_systems_biblio_id', 'biblio_id', 'tbl_biblio', 'biblio_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_ecocodes', 'fk_ecocodes_ecocodedef_id', 'ecocode_definition_id', 'tbl_ecocode_definitions', 'ecocode_definition_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_ecocodes', 'fk_ecocodes_taxon_id', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_features', 'fk_feature_type_id_feature_type_id', 'feature_type_id', 'tbl_feature_types', 'feature_type_id', 'CASCADE', 'CASCADE'), 
-- 			('tbl_geochron_refs', 'fk_geochron_refs_biblio_id', 'biblio_id', 'tbl_biblio', 'biblio_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_geochron_refs', 'fk_geochron_refs_geochron_id', 'geochron_id', 'tbl_geochronology', 'geochron_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_geochronology', 'fk_geochronology_analysis_entity_id', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_geochronology', 'fk_geochronology_dating_labs_id', 'dating_lab_id', 'tbl_dating_labs', 'dating_lab_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_geochronology', 'fk_geochronology_dating_uncertainty_id', 'dating_uncertainty_id', 'tbl_dating_uncertainty', 'dating_uncertainty_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_horizons', 'fk_horizons_method_id', 'method_id', 'tbl_methods', 'method_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_imported_taxa_replacements', 'fk_imported_taxa_replacements_taxon_id', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 'CASCADE', 'CASCADE'), 
-- 			('tbl_lithology', 'fk_lithology_sample_group_id', 'sample_group_id', 'tbl_sample_groups', 'sample_group_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_locations', 'fk_locations_location_type_id', 'location_type_id', 'tbl_location_types', 'location_type_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_mcr_names', 'fk_mcr_names_taxon_id', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_mcr_summary_data', 'fk_mcr_summary_data_taxon_id', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_mcrdata_birmbeetledat', 'fk_mcrdata_birmbeetledat_taxon_id', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_measured_value_dimensions', 'fk_measured_value_dimensions_dimension_id', 'dimension_id', 'tbl_dimensions', 'dimension_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_measured_value_dimensions', 'fk_measured_weights_value_id', 'measured_value_id', 'tbl_measured_values', 'measured_value_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_measured_values', 'fk_measured_values_analysis_entity_id', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_methods', 'fk_methods_biblio_id', 'biblio_id', 'tbl_biblio', 'biblio_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_methods', 'fk_methods_method_group_id', 'method_group_id', 'tbl_method_groups', 'method_group_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_methods', 'fk_methods_record_type_id', 'record_type_id', 'tbl_record_types', 'record_type_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_methods', 'fk_methods_unit_id', 'unit_id', 'tbl_units', 'unit_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_physical_sample_features', 'fk_physical_sample_features_feature_id', 'feature_id', 'tbl_features', 'feature_id', 'CASCADE', 'CASCADE'), 
-- 			('tbl_physical_sample_features', 'fk_physical_sample_features_physical_sample_id', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 'CASCADE', 'CASCADE'), 
-- 			('tbl_physical_samples', 'fk_physical_samples_sample_name_type_id', 'alt_ref_type_id', 'tbl_alt_ref_types', 'alt_ref_type_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_physical_samples', 'fk_physical_samples_sample_type_id', 'sample_type_id', 'tbl_sample_types', 'sample_type_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_physical_samples', 'fk_samples_sample_group_id', 'sample_group_id', 'tbl_sample_groups', 'sample_group_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_projects', 'fk_projects_project_stage_id', 'project_stage_id', 'tbl_project_stages', 'project_stage_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_projects', 'fk_projects_project_type_id', 'project_type_id', 'tbl_project_types', 'project_type_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_rdb', 'fk_rdb_rdb_code_id', 'rdb_code_id', 'tbl_rdb_codes', 'rdb_code_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_rdb', 'fk_rdb_taxon_id', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 'CASCADE', 'CASCADE'), 
-- 			('tbl_rdb', 'fk_tbl_rdb_tbl_location_id', 'location_id', 'tbl_locations', 'location_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_rdb_codes', 'fk_rdb_codes_rdb_system_id', 'rdb_system_id', 'tbl_rdb_systems', 'rdb_system_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_rdb_systems', 'fk_rdb_systems_biblio_id', 'biblio_id', 'tbl_biblio', 'biblio_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_rdb_systems', 'fk_rdb_systems_location_id', 'location_id', 'tbl_locations', 'location_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_relative_age_refs', 'fk_relative_age_refs_biblio_id', 'biblio_id', 'tbl_biblio', 'biblio_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_relative_age_refs', 'fk_relative_age_refs_relative_age_id', 'relative_age_id', 'tbl_relative_ages', 'relative_age_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_relative_ages', 'fk_relative_ages_location_id', 'location_id', 'tbl_locations', 'location_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_relative_ages', 'fk_relative_ages_relative_age_type_id', 'relative_age_type_id', 'tbl_relative_age_types', 'relative_age_type_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_relative_dates', 'fk_relative_dates_dating_uncertainty_id', 'dating_uncertainty_id', 'tbl_dating_uncertainty', 'dating_uncertainty_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_relative_dates', 'fk_relative_dates_method_id', 'method_id', 'tbl_methods', 'method_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_relative_dates', 'fk_relative_dates_physical_sample_id', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_relative_dates', 'fk_relative_dates_relative_age_id', 'relative_age_id', 'tbl_relative_ages', 'relative_age_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_alt_refs', 'fk_sample_alt_refs_alt_ref_type_id', 'alt_ref_type_id', 'tbl_alt_ref_types', 'alt_ref_type_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_alt_refs', 'fk_sample_alt_refs_physical_sample_id', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_colours', 'fk_sample_colours_colour_id', 'colour_id', 'tbl_colours', 'colour_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_colours', 'fk_sample_colours_physical_sample_id', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_coordinates', 'fk_sample_coordinates_coordinate_method_dimension_id', 'coordinate_method_dimension_id', 'tbl_coordinate_method_dimensions', 'coordinate_method_dimension_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_coordinates', 'fk_sample_coordinates_physical_sample_id', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_sample_description_sample_group_contexts', 'fk_sample_description_sample_group_contexts_sampling_context_id', 'sampling_context_id', 'tbl_sample_group_sampling_contexts', 'sampling_context_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_sample_description_sample_group_contexts', 'fk_sample_description_types_sample_group_context_id', 'sample_description_type_id', 'tbl_sample_description_types', 'sample_description_type_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_sample_descriptions', 'fk_sample_descriptions_physical_sample_id', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_sample_descriptions', 'fk_sample_descriptions_sample_description_type_id', 'sample_description_type_id', 'tbl_sample_description_types', 'sample_description_type_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_sample_dimensions', 'fk_sample_dimensions_dimension_id', 'dimension_id', 'tbl_dimensions', 'dimension_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_dimensions', 'fk_sample_dimensions_measurement_method_id', 'method_id', 'tbl_methods', 'method_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_dimensions', 'fk_sample_dimensions_physical_sample_id', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_group_coordinates', 'fk_sample_group_positions_coordinate_method_dimension_id', 'coordinate_method_dimension_id', 'tbl_coordinate_method_dimensions', 'coordinate_method_dimension_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_group_coordinates', 'fk_sample_group_positions_sample_group_id', 'sample_group_id', 'tbl_sample_groups', 'sample_group_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_sample_group_description_type_sampling_contexts', 'fk_sample_group_description_type_sampling_context_id', 'sample_group_description_type_id', 'tbl_sample_group_description_types', 'sample_group_description_type_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_sample_group_description_type_sampling_contexts', 'fk_sample_group_sampling_context_id0', 'sampling_context_id', 'tbl_sample_group_sampling_contexts', 'sampling_context_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_sample_group_descriptions', 'fk_sample_group_descriptions_sample_group_description_type_id', 'sample_group_description_type_id', 'tbl_sample_group_description_types', 'sample_group_description_type_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_group_descriptions', 'fk_sample_groups_sample_group_descriptions_id', 'sample_group_id', 'tbl_sample_groups', 'sample_group_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_group_dimensions', 'fk_sample_group_dimensions_dimension_id', 'dimension_id', 'tbl_dimensions', 'dimension_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_group_dimensions', 'fk_sample_group_dimensions_sample_group_id', 'sample_group_id', 'tbl_sample_groups', 'sample_group_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_group_images', 'fk_sample_group_images_image_type_id', 'image_type_id', 'tbl_image_types', 'image_type_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_group_images', 'fk_sample_group_images_sample_group_id', 'sample_group_id', 'tbl_sample_groups', 'sample_group_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_sample_group_notes', 'fk_tbl_sample_group_notes_sample_groups', 'sample_group_id', 'tbl_sample_groups', 'sample_group_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_group_references', 'fk_sample_group_references_biblio_id', 'biblio_id', 'tbl_biblio', 'biblio_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_group_references', 'fk_sample_group_references_sample_group_id', 'sample_group_id', 'tbl_sample_groups', 'sample_group_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_groups', 'fk_sample_group_sampling_context_id', 'sampling_context_id', 'tbl_sample_group_sampling_contexts', 'sampling_context_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_groups', 'fk_sample_groups_method_id', 'method_id', 'tbl_methods', 'method_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_groups', 'fk_sample_groups_site_id', 'site_id', 'tbl_sites', 'site_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_horizons', 'fk_sample_horizons_horizon_id', 'horizon_id', 'tbl_horizons', 'horizon_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_horizons', 'fk_sample_horizons_physical_sample_id', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_images', 'fk_sample_images_image_type_id', 'image_type_id', 'tbl_image_types', 'image_type_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_images', 'fk_sample_images_physical_sample_id', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_sample_location_type_sampling_contexts', 'fk_sample_location_sampling_contexts_sampling_context_id', 'sample_location_type_id', 'tbl_sample_location_types', 'sample_location_type_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_sample_location_type_sampling_contexts', 'fk_sample_location_type_sampling_context_id', 'sampling_context_id', 'tbl_sample_group_sampling_contexts', 'sampling_context_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_sample_locations', 'fk_sample_locations_physical_sample_id', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_sample_locations', 'fk_sample_locations_sample_location_type_id', 'sample_location_type_id', 'tbl_sample_location_types', 'sample_location_type_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_sample_notes', 'fk_sample_notes_physical_sample_id', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_seasons', 'fk_seasons_season_type_id', 'season_type_id', 'tbl_season_types', 'season_type_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_site_images', 'fk_site_images_contact_id', 'contact_id', 'tbl_contacts', 'contact_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_site_images', 'fk_site_images_image_type_id', 'image_type_id', 'tbl_image_types', 'image_type_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_site_images', 'fk_site_images_site_id', 'site_id', 'tbl_sites', 'site_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_site_locations', 'fk_locations_location_id', 'location_id', 'tbl_locations', 'location_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_site_locations', 'fk_locations_site_id', 'site_id', 'tbl_sites', 'site_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_site_natgridrefs', 'fk_site_natgridrefs_method_id', 'method_id', 'tbl_methods', 'method_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_site_natgridrefs', 'fk_site_natgridrefs_sites_id', 'site_id', 'tbl_sites', 'site_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_site_other_records', 'fk_site_other_records_biblio_id', 'biblio_id', 'tbl_biblio', 'biblio_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_site_other_records', 'fk_site_other_records_record_type_id', 'record_type_id', 'tbl_record_types', 'record_type_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_site_other_records', 'fk_site_other_records_site_id', 'site_id', 'tbl_sites', 'site_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_site_preservation_status', 'fk_site_preservation_status_site_id ', 'site_id', 'tbl_sites', 'site_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_site_references', 'fk_site_references_biblio_id', 'biblio_id', 'tbl_biblio', 'biblio_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_site_references', 'fk_site_references_site_id', 'site_id', 'tbl_sites', 'site_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_species_associations', 'fk_species_associations_associated_taxon_id', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_species_associations', 'fk_species_associations_association_type_id', 'association_type_id', 'tbl_species_association_types', 'association_type_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_species_associations', 'fk_species_associations_biblio_id', 'biblio_id', 'tbl_biblio', 'biblio_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_species_associations', 'fk_species_associations_taxon_id', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_taxa_common_names', 'fk_taxa_common_names_language_id', 'language_id', 'tbl_languages', 'language_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_taxa_common_names', 'fk_taxa_common_names_taxon_id', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_taxa_images', 'fk_taxa_images_image_type_id', 'image_type_id', 'tbl_image_types', 'image_type_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_taxa_images', 'fk_taxa_images_taxa_tree_master_id', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_taxa_measured_attributes', 'fk_taxa_measured_attributes_taxon_id', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 'CASCADE', 'CASCADE'), 
-- 			('tbl_taxa_reference_specimens', 'fk_taxa_reference_specimens_contact_id', 'contact_id', 'tbl_contacts', 'contact_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_taxa_reference_specimens', 'fk_taxa_reference_specimens_taxon_id', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_taxa_seasonality', 'fk_taxa_seasonality_activity_type_id', 'activity_type_id', 'tbl_activity_types', 'activity_type_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_taxa_seasonality', 'fk_taxa_seasonality_location_id', 'location_id', 'tbl_locations', 'location_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_taxa_seasonality', 'fk_taxa_seasonality_season_id', 'season_id', 'tbl_seasons', 'season_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_taxa_seasonality', 'fk_taxa_seasonality_taxon_id', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 'CASCADE', 'CASCADE'), 
-- 			('tbl_taxa_synonyms', 'fk_taxa_synonyms_biblio_id', 'biblio_id', 'tbl_biblio', 'biblio_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_taxa_synonyms', 'fk_taxa_synonyms_family_id', 'family_id', 'tbl_taxa_tree_families', 'family_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_taxa_synonyms', 'fk_taxa_synonyms_genus_id', 'genus_id', 'tbl_taxa_tree_genera', 'genus_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_taxa_synonyms', 'fk_taxa_synonyms_taxa_tree_author_id', 'author_id', 'tbl_taxa_tree_authors', 'author_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_taxa_synonyms', 'fk_taxa_synonyms_taxon_id', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 'CASCADE', 'CASCADE'), 
-- 			('tbl_taxa_tree_families', 'fk_taxa_tree_families_order_id', 'order_id', 'tbl_taxa_tree_orders', 'order_id', 'CASCADE', 'CASCADE'), 
-- 			('tbl_taxa_tree_genera', 'fk_taxa_tree_genera_family_id', 'family_id', 'tbl_taxa_tree_families', 'family_id', 'CASCADE', 'CASCADE'), 
-- 			('tbl_taxa_tree_master', 'fk_taxa_tree_master_author_id', 'author_id', 'tbl_taxa_tree_authors', 'author_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_taxa_tree_master', 'fk_taxa_tree_master_genus_id', 'genus_id', 'tbl_taxa_tree_genera', 'genus_id', 'CASCADE', 'CASCADE'), 
-- 			('tbl_taxa_tree_orders', 'fk_taxa_tree_orders_record_type_id', 'record_type_id', 'tbl_record_types', 'record_type_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_taxonomic_order', 'fk_taxonomic_order_taxon_id', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 'CASCADE', 'CASCADE'), 
-- 			('tbl_taxonomic_order', 'fk_taxonomic_order_taxonomic_order_system_id', 'taxonomic_order_system_id', 'tbl_taxonomic_order_systems', 'taxonomic_order_system_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_taxonomic_order_biblio', 'fk_taxonomic_order_biblio_biblio_id', 'biblio_id', 'tbl_biblio', 'biblio_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_taxonomic_order_biblio', 'fk_taxonomic_order_biblio_taxonomic_order_system_id', 'taxonomic_order_system_id', 'tbl_taxonomic_order_systems', 'taxonomic_order_system_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_taxonomy_notes', 'fk_taxonomy_notes_biblio_id', 'biblio_id', 'tbl_biblio', 'biblio_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_taxonomy_notes', 'fk_taxonomy_notes_taxon_id', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 'CASCADE', 'CASCADE'), 
-- 			('tbl_tephra_dates', 'fk_tephra_dates_analysis_entity_id', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_tephra_dates', 'fk_tephra_dates_dating_uncertainty_id', 'dating_uncertainty_id', 'tbl_dating_uncertainty', 'dating_uncertainty_id', 'NO ACTION', 'NO ACTION'), 
-- 			('tbl_tephra_dates', 'fk_tephra_dates_tephra_id', 'tephra_id', 'tbl_tephras', 'tephra_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_tephra_refs', 'fk_tephra_refs_biblio_id', 'biblio_id', 'tbl_biblio', 'biblio_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_tephra_refs', 'fk_tephra_refs_tephra_id', 'tephra_id', 'tbl_tephras', 'tephra_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_text_biology', 'fk_text_biology_biblio_id', 'biblio_id', 'tbl_biblio', 'biblio_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_text_biology', 'fk_text_biology_taxon_id', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 'CASCADE', 'CASCADE'), 
-- 			('tbl_text_distribution', 'fk_text_distribution_biblio_id', 'biblio_id', 'tbl_biblio', 'biblio_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_text_distribution', 'fk_text_distribution_taxon_id', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 'CASCADE', 'CASCADE'), 
-- 			('tbl_text_identification_keys', 'fk_text_identification_keys_biblio_id', 'biblio_id', 'tbl_biblio', 'biblio_id', 'NO ACTION', 'CASCADE'), 
-- 			('tbl_text_identification_keys', 'fk_text_identification_keys_taxon_id', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 'CASCADE', 'CASCADE')
-- 	) select *
-- 	  from foreign_key_columns
-- 	) loop
-- 		_sql = format(
-- 			'ALTER TABLE public.%s ADD CONSTRAINT %s FOREIGN KEY (%s) REFERENCES public.%s (%s) ON DELETE %s ON UPDATE %s;',
-- 			_t.table_name, _t.constraint_name, _t.foreign_key, _t.referenced_table_name, _t.reference_column_name, _t.on_delete, _t.on_update
-- 		);
-- 		if _t.constraint_name <> format('fk_%s_%s', replace(_t.table_name, 'tbl_', ''), _t.foreign_key) then
-- 			raise info 'warning: default naming mismatch %.% => %', _t.table_name, _t.foreign_key, _t.constraint_name;
-- 		end if;
		
-- 		-- execute _sql;
-- 		-- raise info '%', _sql;
-- 	end loop;
-- end $$;
-- commit;


ALTER TABLE "public"."tbl_abundance_elements" ADD CONSTRAINT "fk_abundance_elements_record_type_id" FOREIGN KEY ("record_type_id") REFERENCES "public"."tbl_record_types" ("record_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_abundance_ident_levels" ADD CONSTRAINT "fk_abundance_ident_levels_abundance_id" FOREIGN KEY ("abundance_id") REFERENCES "public"."tbl_abundances" ("abundance_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_abundance_ident_levels" ADD CONSTRAINT "fk_abundance_ident_levels_identification_level_id" FOREIGN KEY ("identification_level_id") REFERENCES "public"."tbl_identification_levels" ("identification_level_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_abundance_modifications" ADD CONSTRAINT "fk_abundance_modifications_abundance_id" FOREIGN KEY ("abundance_id") REFERENCES "public"."tbl_abundances" ("abundance_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_abundance_modifications" ADD CONSTRAINT "fk_abundance_modifications_modification_type_id" FOREIGN KEY ("modification_type_id") REFERENCES "public"."tbl_modification_types" ("modification_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_abundances" ADD CONSTRAINT "fk_abundances_abundance_elements_id" FOREIGN KEY ("abundance_element_id") REFERENCES "public"."tbl_abundance_elements" ("abundance_element_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_abundances" ADD CONSTRAINT "fk_abundances_analysis_entity_id" FOREIGN KEY ("analysis_entity_id") REFERENCES "public"."tbl_analysis_entities" ("analysis_entity_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_abundances" ADD CONSTRAINT "fk_abundances_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_aggregate_datasets" ADD CONSTRAINT "fk_aggregate_datasets_aggregate_order_type_id" FOREIGN KEY ("aggregate_order_type_id") REFERENCES "public"."tbl_aggregate_order_types" ("aggregate_order_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_aggregate_datasets" ADD CONSTRAINT "fk_aggregate_datasets_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_aggregate_sample_ages" ADD CONSTRAINT "fk_aggregate_sample_ages_aggregate_dataset_id" FOREIGN KEY ("aggregate_dataset_id") REFERENCES "public"."tbl_aggregate_datasets" ("aggregate_dataset_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_aggregate_sample_ages" ADD CONSTRAINT "fk_aggregate_sample_ages_analysis_entity_age_id" FOREIGN KEY ("analysis_entity_age_id") REFERENCES "public"."tbl_analysis_entity_ages" ("analysis_entity_age_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_aggregate_samples" ADD CONSTRAINT "fk_aggragate_samples_analysis_entity_id" FOREIGN KEY ("analysis_entity_id") REFERENCES "public"."tbl_analysis_entities" ("analysis_entity_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_aggregate_samples" ADD CONSTRAINT "fk_aggregate_samples_aggregate_dataset_id" FOREIGN KEY ("aggregate_dataset_id") REFERENCES "public"."tbl_aggregate_datasets" ("aggregate_dataset_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_analysis_entities" ADD CONSTRAINT "fk_analysis_entities_dataset_id" FOREIGN KEY ("dataset_id") REFERENCES "public"."tbl_datasets" ("dataset_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_analysis_entities" ADD CONSTRAINT "fk_analysis_entities_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_analysis_entity_ages" ADD CONSTRAINT "fk_analysis_entity_ages_analysis_entity_id" FOREIGN KEY ("analysis_entity_id") REFERENCES "public"."tbl_analysis_entities" ("analysis_entity_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_analysis_entity_ages" ADD CONSTRAINT "fk_analysis_entity_ages_chronology_id" FOREIGN KEY ("chronology_id") REFERENCES "public"."tbl_chronologies" ("chronology_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_analysis_entity_dimensions" ADD CONSTRAINT "fk_analysis_entity_dimensions_analysis_entity_id" FOREIGN KEY ("analysis_entity_id") REFERENCES "public"."tbl_analysis_entities" ("analysis_entity_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_analysis_entity_dimensions" ADD CONSTRAINT "fk_analysis_entity_dimensions_dimension_id" FOREIGN KEY ("dimension_id") REFERENCES "public"."tbl_dimensions" ("dimension_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_analysis_entity_prep_methods" ADD CONSTRAINT "fk_analysis_entity_prep_methods_analysis_entity_id" FOREIGN KEY ("analysis_entity_id") REFERENCES "public"."tbl_analysis_entities" ("analysis_entity_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_analysis_entity_prep_methods" ADD CONSTRAINT "fk_analysis_entity_prep_methods_method_id" FOREIGN KEY ("method_id") REFERENCES "public"."tbl_methods" ("method_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_biblio" ADD CONSTRAINT "fk_biblio_collections_or_journals_id" FOREIGN KEY ("collection_or_journal_id") REFERENCES "public"."tbl_collections_or_journals" ("collection_or_journal_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_biblio" ADD CONSTRAINT "fk_biblio_publication_type_id" FOREIGN KEY ("publication_type_id") REFERENCES "public"."tbl_publication_types" ("publication_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_biblio" ADD CONSTRAINT "fk_biblio_publisher_id" FOREIGN KEY ("publisher_id") REFERENCES "public"."tbl_publishers" ("publisher_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_biblio_keywords" ADD CONSTRAINT "fk_biblio_keywords_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_biblio_keywords" ADD CONSTRAINT "fk_biblio_keywords_keyword_id" FOREIGN KEY ("keyword_id") REFERENCES "public"."tbl_keywords" ("keyword_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_ceramics" ADD CONSTRAINT "fk_ceramics_analysis_entity_id" FOREIGN KEY ("analysis_entity_id") REFERENCES "public"."tbl_analysis_entities" ("analysis_entity_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_ceramics" ADD CONSTRAINT "fk_ceramics_ceramics_measurement_id" FOREIGN KEY ("ceramics_measurement_id") REFERENCES "public"."tbl_ceramics_measurements" ("ceramics_measurement_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_ceramics_measurement_lookup" ADD CONSTRAINT "fk_ceramics_measurement_lookup_ceramics_measurements_id" FOREIGN KEY ("ceramics_measurement_id") REFERENCES "public"."tbl_ceramics_measurements" ("ceramics_measurement_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_ceramics_measurements" ADD CONSTRAINT "fk_ceramics_measurements_method_id" FOREIGN KEY ("method_id") REFERENCES "public"."tbl_methods" ("method_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_chron_controls" ADD CONSTRAINT "fk_chron_controls_chron_control_type_id" FOREIGN KEY ("chron_control_type_id") REFERENCES "public"."tbl_chron_control_types" ("chron_control_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_chron_controls" ADD CONSTRAINT "fk_chron_controls_chronology_id" FOREIGN KEY ("chronology_id") REFERENCES "public"."tbl_chronologies" ("chronology_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_chronologies" ADD CONSTRAINT "fk_chronologies_contact_id" FOREIGN KEY ("contact_id") REFERENCES "public"."tbl_contacts" ("contact_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_chronologies" ADD CONSTRAINT "fk_chronologies_sample_group_id" FOREIGN KEY ("sample_group_id") REFERENCES "public"."tbl_sample_groups" ("sample_group_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_collections_or_journals" ADD CONSTRAINT "fk_collections_or_journals_publisher_id" FOREIGN KEY ("publisher_id") REFERENCES "public"."tbl_publishers" ("publisher_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_colours" ADD CONSTRAINT "fk_colours_method_id" FOREIGN KEY ("method_id") REFERENCES "public"."tbl_methods" ("method_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_coordinate_method_dimensions" ADD CONSTRAINT "fk_coordinate_method_dimensions_dimensions_id" FOREIGN KEY ("dimension_id") REFERENCES "public"."tbl_dimensions" ("dimension_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_coordinate_method_dimensions" ADD CONSTRAINT "fk_coordinate_method_dimensions_method_id" FOREIGN KEY ("method_id") REFERENCES "public"."tbl_methods" ("method_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_data_types" ADD CONSTRAINT "fk_data_types_data_type_group_id" FOREIGN KEY ("data_type_group_id") REFERENCES "public"."tbl_data_type_groups" ("data_type_group_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_dataset_contacts" ADD CONSTRAINT "fk_dataset_contacts_contact_id" FOREIGN KEY ("contact_id") REFERENCES "public"."tbl_contacts" ("contact_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_dataset_contacts" ADD CONSTRAINT "fk_dataset_contacts_contact_type_id" FOREIGN KEY ("contact_type_id") REFERENCES "public"."tbl_contact_types" ("contact_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_dataset_contacts" ADD CONSTRAINT "fk_dataset_contacts_dataset_id" FOREIGN KEY ("dataset_id") REFERENCES "public"."tbl_datasets" ("dataset_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_dataset_masters" ADD CONSTRAINT "fk_dataset_masters_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_dataset_masters" ADD CONSTRAINT "fk_dataset_masters_contact_id" FOREIGN KEY ("contact_id") REFERENCES "public"."tbl_contacts" ("contact_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_dataset_submissions" ADD CONSTRAINT "fk_dataset_submission_submission_type_id" FOREIGN KEY ("submission_type_id") REFERENCES "public"."tbl_dataset_submission_types" ("submission_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_dataset_submissions" ADD CONSTRAINT "fk_dataset_submissions_contact_id" FOREIGN KEY ("contact_id") REFERENCES "public"."tbl_contacts" ("contact_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_dataset_submissions" ADD CONSTRAINT "fk_dataset_submissions_dataset_id" FOREIGN KEY ("dataset_id") REFERENCES "public"."tbl_datasets" ("dataset_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_datasets" ADD CONSTRAINT "fk_datasets_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_datasets" ADD CONSTRAINT "fk_datasets_data_type_id" FOREIGN KEY ("data_type_id") REFERENCES "public"."tbl_data_types" ("data_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_datasets" ADD CONSTRAINT "fk_datasets_master_set_id" FOREIGN KEY ("master_set_id") REFERENCES "public"."tbl_dataset_masters" ("master_set_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_datasets" ADD CONSTRAINT "fk_datasets_method_id" FOREIGN KEY ("method_id") REFERENCES "public"."tbl_methods" ("method_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_datasets" ADD CONSTRAINT "fk_datasets_project_id" FOREIGN KEY ("project_id") REFERENCES "public"."tbl_projects" ("project_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_datasets" ADD CONSTRAINT "fk_datasets_updated_dataset_id" FOREIGN KEY ("updated_dataset_id") REFERENCES "public"."tbl_datasets" ("dataset_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_dating_labs" ADD CONSTRAINT "fk_dating_labs_contact_id" FOREIGN KEY ("contact_id") REFERENCES "public"."tbl_contacts" ("contact_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_dating_material" ADD CONSTRAINT "fk_dating_material_abundance_elements_id" FOREIGN KEY ("abundance_element_id") REFERENCES "public"."tbl_abundance_elements" ("abundance_element_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_dating_material" ADD CONSTRAINT "fk_dating_material_geochronology_geochron_id" FOREIGN KEY ("geochron_id") REFERENCES "public"."tbl_geochronology" ("geochron_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_dating_material" ADD CONSTRAINT "fk_dating_material_taxa_tree_master_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_dendro" ADD CONSTRAINT "fk_dendro_analysis_entity_id" FOREIGN KEY ("analysis_entity_id") REFERENCES "public"."tbl_analysis_entities" ("analysis_entity_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_dendro" ADD CONSTRAINT "fk_dendro_dendro_measurement_id" FOREIGN KEY ("dendro_measurement_id") REFERENCES "public"."tbl_dendro_measurements" ("dendro_measurement_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_dendro_date_notes" ADD CONSTRAINT "fk_dendro_date_notes_dendro_date_id" FOREIGN KEY ("dendro_date_id") REFERENCES "public"."tbl_dendro_dates" ("dendro_date_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_dendro_dates" ADD CONSTRAINT "fk_dendro_dates_analysis_entity_id" FOREIGN KEY ("analysis_entity_id") REFERENCES "public"."tbl_analysis_entities" ("analysis_entity_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_dendro_dates" ADD CONSTRAINT "fk_dendro_dates_dating_uncertainty_id" FOREIGN KEY ("dating_uncertainty_id") REFERENCES "public"."tbl_dating_uncertainty" ("dating_uncertainty_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_dendro_dates" ADD CONSTRAINT "fk_dendro_dates_years_type_id" FOREIGN KEY ("years_type_id") REFERENCES "public"."tbl_years_types" ("years_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_dendro_measurement_lookup" ADD CONSTRAINT "fk_dendro_measurement_lookup_dendro_measurement_id" FOREIGN KEY ("dendro_measurement_id") REFERENCES "public"."tbl_dendro_measurements" ("dendro_measurement_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_dendro_measurements" ADD CONSTRAINT "fk_dendro_measurements_method_id" FOREIGN KEY ("method_id") REFERENCES "public"."tbl_methods" ("method_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_dimensions" ADD CONSTRAINT "fk_dimensions_method_group_id" FOREIGN KEY ("method_group_id") REFERENCES "public"."tbl_method_groups" ("method_group_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_dimensions" ADD CONSTRAINT "fk_dimensions_unit_id" FOREIGN KEY ("unit_id") REFERENCES "public"."tbl_units" ("unit_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_ecocode_definitions" ADD CONSTRAINT "fk_ecocode_definitions_ecocode_group_id" FOREIGN KEY ("ecocode_group_id") REFERENCES "public"."tbl_ecocode_groups" ("ecocode_group_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_ecocode_groups" ADD CONSTRAINT "fk_ecocode_groups_ecocode_system_id" FOREIGN KEY ("ecocode_system_id") REFERENCES "public"."tbl_ecocode_systems" ("ecocode_system_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_ecocode_systems" ADD CONSTRAINT "fk_ecocode_systems_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_ecocodes" ADD CONSTRAINT "fk_ecocodes_ecocodedef_id" FOREIGN KEY ("ecocode_definition_id") REFERENCES "public"."tbl_ecocode_definitions" ("ecocode_definition_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_ecocodes" ADD CONSTRAINT "fk_ecocodes_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_features" ADD CONSTRAINT "fk_feature_type_id_feature_type_id" FOREIGN KEY ("feature_type_id") REFERENCES "public"."tbl_feature_types" ("feature_type_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_geochron_refs" ADD CONSTRAINT "fk_geochron_refs_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_geochron_refs" ADD CONSTRAINT "fk_geochron_refs_geochron_id" FOREIGN KEY ("geochron_id") REFERENCES "public"."tbl_geochronology" ("geochron_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_geochronology" ADD CONSTRAINT "fk_geochronology_analysis_entity_id" FOREIGN KEY ("analysis_entity_id") REFERENCES "public"."tbl_analysis_entities" ("analysis_entity_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_geochronology" ADD CONSTRAINT "fk_geochronology_dating_labs_id" FOREIGN KEY ("dating_lab_id") REFERENCES "public"."tbl_dating_labs" ("dating_lab_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_geochronology" ADD CONSTRAINT "fk_geochronology_dating_uncertainty_id" FOREIGN KEY ("dating_uncertainty_id") REFERENCES "public"."tbl_dating_uncertainty" ("dating_uncertainty_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_horizons" ADD CONSTRAINT "fk_horizons_method_id" FOREIGN KEY ("method_id") REFERENCES "public"."tbl_methods" ("method_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_imported_taxa_replacements" ADD CONSTRAINT "fk_imported_taxa_replacements_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_lithology" ADD CONSTRAINT "fk_lithology_sample_group_id" FOREIGN KEY ("sample_group_id") REFERENCES "public"."tbl_sample_groups" ("sample_group_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_locations" ADD CONSTRAINT "fk_locations_location_type_id" FOREIGN KEY ("location_type_id") REFERENCES "public"."tbl_location_types" ("location_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_mcr_names" ADD CONSTRAINT "fk_mcr_names_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_mcr_summary_data" ADD CONSTRAINT "fk_mcr_summary_data_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_mcrdata_birmbeetledat" ADD CONSTRAINT "fk_mcrdata_birmbeetledat_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_measured_value_dimensions" ADD CONSTRAINT "fk_measured_value_dimensions_dimension_id" FOREIGN KEY ("dimension_id") REFERENCES "public"."tbl_dimensions" ("dimension_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_measured_value_dimensions" ADD CONSTRAINT "fk_measured_weights_value_id" FOREIGN KEY ("measured_value_id") REFERENCES "public"."tbl_measured_values" ("measured_value_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_measured_values" ADD CONSTRAINT "fk_measured_values_analysis_entity_id" FOREIGN KEY ("analysis_entity_id") REFERENCES "public"."tbl_analysis_entities" ("analysis_entity_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_methods" ADD CONSTRAINT "fk_methods_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_methods" ADD CONSTRAINT "fk_methods_method_group_id" FOREIGN KEY ("method_group_id") REFERENCES "public"."tbl_method_groups" ("method_group_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_methods" ADD CONSTRAINT "fk_methods_record_type_id" FOREIGN KEY ("record_type_id") REFERENCES "public"."tbl_record_types" ("record_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_methods" ADD CONSTRAINT "fk_methods_unit_id" FOREIGN KEY ("unit_id") REFERENCES "public"."tbl_units" ("unit_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_physical_sample_features" ADD CONSTRAINT "fk_physical_sample_features_feature_id" FOREIGN KEY ("feature_id") REFERENCES "public"."tbl_features" ("feature_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_physical_sample_features" ADD CONSTRAINT "fk_physical_sample_features_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_physical_samples" ADD CONSTRAINT "fk_physical_samples_sample_name_type_id" FOREIGN KEY ("alt_ref_type_id") REFERENCES "public"."tbl_alt_ref_types" ("alt_ref_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_physical_samples" ADD CONSTRAINT "fk_physical_samples_sample_type_id" FOREIGN KEY ("sample_type_id") REFERENCES "public"."tbl_sample_types" ("sample_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_physical_samples" ADD CONSTRAINT "fk_samples_sample_group_id" FOREIGN KEY ("sample_group_id") REFERENCES "public"."tbl_sample_groups" ("sample_group_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_projects" ADD CONSTRAINT "fk_projects_project_stage_id" FOREIGN KEY ("project_stage_id") REFERENCES "public"."tbl_project_stages" ("project_stage_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_projects" ADD CONSTRAINT "fk_projects_project_type_id" FOREIGN KEY ("project_type_id") REFERENCES "public"."tbl_project_types" ("project_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_rdb" ADD CONSTRAINT "fk_rdb_rdb_code_id" FOREIGN KEY ("rdb_code_id") REFERENCES "public"."tbl_rdb_codes" ("rdb_code_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_rdb" ADD CONSTRAINT "fk_rdb_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_rdb" ADD CONSTRAINT "fk_tbl_rdb_tbl_location_id" FOREIGN KEY ("location_id") REFERENCES "public"."tbl_locations" ("location_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_rdb_codes" ADD CONSTRAINT "fk_rdb_codes_rdb_system_id" FOREIGN KEY ("rdb_system_id") REFERENCES "public"."tbl_rdb_systems" ("rdb_system_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_rdb_systems" ADD CONSTRAINT "fk_rdb_systems_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_rdb_systems" ADD CONSTRAINT "fk_rdb_systems_location_id" FOREIGN KEY ("location_id") REFERENCES "public"."tbl_locations" ("location_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_relative_age_refs" ADD CONSTRAINT "fk_relative_age_refs_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_relative_age_refs" ADD CONSTRAINT "fk_relative_age_refs_relative_age_id" FOREIGN KEY ("relative_age_id") REFERENCES "public"."tbl_relative_ages" ("relative_age_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_relative_ages" ADD CONSTRAINT "fk_relative_ages_location_id" FOREIGN KEY ("location_id") REFERENCES "public"."tbl_locations" ("location_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_relative_ages" ADD CONSTRAINT "fk_relative_ages_relative_age_type_id" FOREIGN KEY ("relative_age_type_id") REFERENCES "public"."tbl_relative_age_types" ("relative_age_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_relative_dates" ADD CONSTRAINT "fk_relative_dates_dating_uncertainty_id" FOREIGN KEY ("dating_uncertainty_id") REFERENCES "public"."tbl_dating_uncertainty" ("dating_uncertainty_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_relative_dates" ADD CONSTRAINT "fk_relative_dates_method_id" FOREIGN KEY ("method_id") REFERENCES "public"."tbl_methods" ("method_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_relative_dates" ADD CONSTRAINT "fk_relative_dates_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_relative_dates" ADD CONSTRAINT "fk_relative_dates_relative_age_id" FOREIGN KEY ("relative_age_id") REFERENCES "public"."tbl_relative_ages" ("relative_age_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_sample_alt_refs" ADD CONSTRAINT "fk_sample_alt_refs_alt_ref_type_id" FOREIGN KEY ("alt_ref_type_id") REFERENCES "public"."tbl_alt_ref_types" ("alt_ref_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_alt_refs" ADD CONSTRAINT "fk_sample_alt_refs_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_sample_colours" ADD CONSTRAINT "fk_sample_colours_colour_id" FOREIGN KEY ("colour_id") REFERENCES "public"."tbl_colours" ("colour_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_colours" ADD CONSTRAINT "fk_sample_colours_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_sample_coordinates" ADD CONSTRAINT "fk_sample_coordinates_coordinate_method_dimension_id" FOREIGN KEY ("coordinate_method_dimension_id") REFERENCES "public"."tbl_coordinate_method_dimensions" ("coordinate_method_dimension_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_coordinates" ADD CONSTRAINT "fk_sample_coordinates_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_sample_description_sample_group_contexts" ADD CONSTRAINT "fk_sample_description_sample_group_contexts_sampling_context_id" FOREIGN KEY ("sampling_context_id") REFERENCES "public"."tbl_sample_group_sampling_contexts" ("sampling_context_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_sample_description_sample_group_contexts" ADD CONSTRAINT "fk_sample_description_types_sample_group_context_id" FOREIGN KEY ("sample_description_type_id") REFERENCES "public"."tbl_sample_description_types" ("sample_description_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_sample_descriptions" ADD CONSTRAINT "fk_sample_descriptions_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_sample_descriptions" ADD CONSTRAINT "fk_sample_descriptions_sample_description_type_id" FOREIGN KEY ("sample_description_type_id") REFERENCES "public"."tbl_sample_description_types" ("sample_description_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_sample_dimensions" ADD CONSTRAINT "fk_sample_dimensions_dimension_id" FOREIGN KEY ("dimension_id") REFERENCES "public"."tbl_dimensions" ("dimension_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_dimensions" ADD CONSTRAINT "fk_sample_dimensions_measurement_method_id" FOREIGN KEY ("method_id") REFERENCES "public"."tbl_methods" ("method_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_dimensions" ADD CONSTRAINT "fk_sample_dimensions_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_sample_group_coordinates" ADD CONSTRAINT "fk_sample_group_positions_coordinate_method_dimension_id" FOREIGN KEY ("coordinate_method_dimension_id") REFERENCES "public"."tbl_coordinate_method_dimensions" ("coordinate_method_dimension_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_group_coordinates" ADD CONSTRAINT "fk_sample_group_positions_sample_group_id" FOREIGN KEY ("sample_group_id") REFERENCES "public"."tbl_sample_groups" ("sample_group_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_sample_group_description_type_sampling_contexts" ADD CONSTRAINT "fk_sample_group_description_type_sampling_context_id" FOREIGN KEY ("sample_group_description_type_id") REFERENCES "public"."tbl_sample_group_description_types" ("sample_group_description_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_sample_group_description_type_sampling_contexts" ADD CONSTRAINT "fk_sample_group_sampling_context_id0" FOREIGN KEY ("sampling_context_id") REFERENCES "public"."tbl_sample_group_sampling_contexts" ("sampling_context_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_sample_group_descriptions" ADD CONSTRAINT "fk_sample_group_descriptions_sample_group_description_type_id" FOREIGN KEY ("sample_group_description_type_id") REFERENCES "public"."tbl_sample_group_description_types" ("sample_group_description_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_group_descriptions" ADD CONSTRAINT "fk_sample_groups_sample_group_descriptions_id" FOREIGN KEY ("sample_group_id") REFERENCES "public"."tbl_sample_groups" ("sample_group_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_sample_group_dimensions" ADD CONSTRAINT "fk_sample_group_dimensions_dimension_id" FOREIGN KEY ("dimension_id") REFERENCES "public"."tbl_dimensions" ("dimension_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_group_dimensions" ADD CONSTRAINT "fk_sample_group_dimensions_sample_group_id" FOREIGN KEY ("sample_group_id") REFERENCES "public"."tbl_sample_groups" ("sample_group_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_sample_group_images" ADD CONSTRAINT "fk_sample_group_images_image_type_id" FOREIGN KEY ("image_type_id") REFERENCES "public"."tbl_image_types" ("image_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_group_images" ADD CONSTRAINT "fk_sample_group_images_sample_group_id" FOREIGN KEY ("sample_group_id") REFERENCES "public"."tbl_sample_groups" ("sample_group_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_sample_group_notes" ADD CONSTRAINT "fk_tbl_sample_group_notes_sample_groups" FOREIGN KEY ("sample_group_id") REFERENCES "public"."tbl_sample_groups" ("sample_group_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_sample_group_references" ADD CONSTRAINT "fk_sample_group_references_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_group_references" ADD CONSTRAINT "fk_sample_group_references_sample_group_id" FOREIGN KEY ("sample_group_id") REFERENCES "public"."tbl_sample_groups" ("sample_group_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_sample_groups" ADD CONSTRAINT "fk_sample_group_sampling_context_id" FOREIGN KEY ("sampling_context_id") REFERENCES "public"."tbl_sample_group_sampling_contexts" ("sampling_context_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_groups" ADD CONSTRAINT "fk_sample_groups_method_id" FOREIGN KEY ("method_id") REFERENCES "public"."tbl_methods" ("method_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_groups" ADD CONSTRAINT "fk_sample_groups_site_id" FOREIGN KEY ("site_id") REFERENCES "public"."tbl_sites" ("site_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_sample_horizons" ADD CONSTRAINT "fk_sample_horizons_horizon_id" FOREIGN KEY ("horizon_id") REFERENCES "public"."tbl_horizons" ("horizon_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_horizons" ADD CONSTRAINT "fk_sample_horizons_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_sample_images" ADD CONSTRAINT "fk_sample_images_image_type_id" FOREIGN KEY ("image_type_id") REFERENCES "public"."tbl_image_types" ("image_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_sample_images" ADD CONSTRAINT "fk_sample_images_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_sample_location_type_sampling_contexts" ADD CONSTRAINT "fk_sample_location_sampling_contexts_sampling_context_id" FOREIGN KEY ("sample_location_type_id") REFERENCES "public"."tbl_sample_location_types" ("sample_location_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_sample_location_type_sampling_contexts" ADD CONSTRAINT "fk_sample_location_type_sampling_context_id" FOREIGN KEY ("sampling_context_id") REFERENCES "public"."tbl_sample_group_sampling_contexts" ("sampling_context_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_sample_locations" ADD CONSTRAINT "fk_sample_locations_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_sample_locations" ADD CONSTRAINT "fk_sample_locations_sample_location_type_id" FOREIGN KEY ("sample_location_type_id") REFERENCES "public"."tbl_sample_location_types" ("sample_location_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_sample_notes" ADD CONSTRAINT "fk_sample_notes_physical_sample_id" FOREIGN KEY ("physical_sample_id") REFERENCES "public"."tbl_physical_samples" ("physical_sample_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_seasons" ADD CONSTRAINT "fk_seasons_season_type_id" FOREIGN KEY ("season_type_id") REFERENCES "public"."tbl_season_types" ("season_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_site_images" ADD CONSTRAINT "fk_site_images_contact_id" FOREIGN KEY ("contact_id") REFERENCES "public"."tbl_contacts" ("contact_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_site_images" ADD CONSTRAINT "fk_site_images_image_type_id" FOREIGN KEY ("image_type_id") REFERENCES "public"."tbl_image_types" ("image_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_site_images" ADD CONSTRAINT "fk_site_images_site_id" FOREIGN KEY ("site_id") REFERENCES "public"."tbl_sites" ("site_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_site_locations" ADD CONSTRAINT "fk_locations_location_id" FOREIGN KEY ("location_id") REFERENCES "public"."tbl_locations" ("location_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_site_locations" ADD CONSTRAINT "fk_locations_site_id" FOREIGN KEY ("site_id") REFERENCES "public"."tbl_sites" ("site_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_site_natgridrefs" ADD CONSTRAINT "fk_site_natgridrefs_method_id" FOREIGN KEY ("method_id") REFERENCES "public"."tbl_methods" ("method_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_site_natgridrefs" ADD CONSTRAINT "fk_site_natgridrefs_sites_id" FOREIGN KEY ("site_id") REFERENCES "public"."tbl_sites" ("site_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_site_other_records" ADD CONSTRAINT "fk_site_other_records_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_site_other_records" ADD CONSTRAINT "fk_site_other_records_record_type_id" FOREIGN KEY ("record_type_id") REFERENCES "public"."tbl_record_types" ("record_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_site_other_records" ADD CONSTRAINT "fk_site_other_records_site_id" FOREIGN KEY ("site_id") REFERENCES "public"."tbl_sites" ("site_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_site_preservation_status" ADD CONSTRAINT "fk_site_preservation_status_site_id " FOREIGN KEY ("site_id") REFERENCES "public"."tbl_sites" ("site_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_site_references" ADD CONSTRAINT "fk_site_references_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_site_references" ADD CONSTRAINT "fk_site_references_site_id" FOREIGN KEY ("site_id") REFERENCES "public"."tbl_sites" ("site_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_species_associations" ADD CONSTRAINT "fk_species_associations_associated_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_species_associations" ADD CONSTRAINT "fk_species_associations_association_type_id" FOREIGN KEY ("association_type_id") REFERENCES "public"."tbl_species_association_types" ("association_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_species_associations" ADD CONSTRAINT "fk_species_associations_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_species_associations" ADD CONSTRAINT "fk_species_associations_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_taxa_common_names" ADD CONSTRAINT "fk_taxa_common_names_language_id" FOREIGN KEY ("language_id") REFERENCES "public"."tbl_languages" ("language_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_taxa_common_names" ADD CONSTRAINT "fk_taxa_common_names_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_taxa_images" ADD CONSTRAINT "fk_taxa_images_image_type_id" FOREIGN KEY ("image_type_id") REFERENCES "public"."tbl_image_types" ("image_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_taxa_images" ADD CONSTRAINT "fk_taxa_images_taxa_tree_master_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_taxa_measured_attributes" ADD CONSTRAINT "fk_taxa_measured_attributes_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_taxa_reference_specimens" ADD CONSTRAINT "fk_taxa_reference_specimens_contact_id" FOREIGN KEY ("contact_id") REFERENCES "public"."tbl_contacts" ("contact_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_taxa_reference_specimens" ADD CONSTRAINT "fk_taxa_reference_specimens_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "public"."tbl_taxa_seasonality" ADD CONSTRAINT "fk_taxa_seasonality_activity_type_id" FOREIGN KEY ("activity_type_id") REFERENCES "public"."tbl_activity_types" ("activity_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_taxa_seasonality" ADD CONSTRAINT "fk_taxa_seasonality_location_id" FOREIGN KEY ("location_id") REFERENCES "public"."tbl_locations" ("location_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_taxa_seasonality" ADD CONSTRAINT "fk_taxa_seasonality_season_id" FOREIGN KEY ("season_id") REFERENCES "public"."tbl_seasons" ("season_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_taxa_seasonality" ADD CONSTRAINT "fk_taxa_seasonality_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_taxa_synonyms" ADD CONSTRAINT "fk_taxa_synonyms_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_taxa_synonyms" ADD CONSTRAINT "fk_taxa_synonyms_family_id" FOREIGN KEY ("family_id") REFERENCES "public"."tbl_taxa_tree_families" ("family_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_taxa_synonyms" ADD CONSTRAINT "fk_taxa_synonyms_genus_id" FOREIGN KEY ("genus_id") REFERENCES "public"."tbl_taxa_tree_genera" ("genus_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_taxa_synonyms" ADD CONSTRAINT "fk_taxa_synonyms_taxa_tree_author_id" FOREIGN KEY ("author_id") REFERENCES "public"."tbl_taxa_tree_authors" ("author_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_taxa_synonyms" ADD CONSTRAINT "fk_taxa_synonyms_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_taxa_tree_families" ADD CONSTRAINT "fk_taxa_tree_families_order_id" FOREIGN KEY ("order_id") REFERENCES "public"."tbl_taxa_tree_orders" ("order_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_taxa_tree_genera" ADD CONSTRAINT "fk_taxa_tree_genera_family_id" FOREIGN KEY ("family_id") REFERENCES "public"."tbl_taxa_tree_families" ("family_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_taxa_tree_master" ADD CONSTRAINT "fk_taxa_tree_master_author_id" FOREIGN KEY ("author_id") REFERENCES "public"."tbl_taxa_tree_authors" ("author_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_taxa_tree_master" ADD CONSTRAINT "fk_taxa_tree_master_genus_id" FOREIGN KEY ("genus_id") REFERENCES "public"."tbl_taxa_tree_genera" ("genus_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_taxa_tree_orders" ADD CONSTRAINT "fk_taxa_tree_orders_record_type_id" FOREIGN KEY ("record_type_id") REFERENCES "public"."tbl_record_types" ("record_type_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_taxonomic_order" ADD CONSTRAINT "fk_taxonomic_order_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_taxonomic_order" ADD CONSTRAINT "fk_taxonomic_order_taxonomic_order_system_id" FOREIGN KEY ("taxonomic_order_system_id") REFERENCES "public"."tbl_taxonomic_order_systems" ("taxonomic_order_system_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_taxonomic_order_biblio" ADD CONSTRAINT "fk_taxonomic_order_biblio_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_taxonomic_order_biblio" ADD CONSTRAINT "fk_taxonomic_order_biblio_taxonomic_order_system_id" FOREIGN KEY ("taxonomic_order_system_id") REFERENCES "public"."tbl_taxonomic_order_systems" ("taxonomic_order_system_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_taxonomy_notes" ADD CONSTRAINT "fk_taxonomy_notes_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_taxonomy_notes" ADD CONSTRAINT "fk_taxonomy_notes_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_tephra_dates" ADD CONSTRAINT "fk_tephra_dates_analysis_entity_id" FOREIGN KEY ("analysis_entity_id") REFERENCES "public"."tbl_analysis_entities" ("analysis_entity_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_tephra_dates" ADD CONSTRAINT "fk_tephra_dates_dating_uncertainty_id" FOREIGN KEY ("dating_uncertainty_id") REFERENCES "public"."tbl_dating_uncertainty" ("dating_uncertainty_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."tbl_tephra_dates" ADD CONSTRAINT "fk_tephra_dates_tephra_id" FOREIGN KEY ("tephra_id") REFERENCES "public"."tbl_tephras" ("tephra_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_tephra_refs" ADD CONSTRAINT "fk_tephra_refs_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_tephra_refs" ADD CONSTRAINT "fk_tephra_refs_tephra_id" FOREIGN KEY ("tephra_id") REFERENCES "public"."tbl_tephras" ("tephra_id") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_text_biology" ADD CONSTRAINT "fk_text_biology_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_text_biology" ADD CONSTRAINT "fk_text_biology_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_text_distribution" ADD CONSTRAINT "fk_text_distribution_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_text_distribution" ADD CONSTRAINT "fk_text_distribution_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "public"."tbl_text_identification_keys" ADD CONSTRAINT "fk_text_identification_keys_biblio_id" FOREIGN KEY ("biblio_id") REFERENCES "public"."tbl_biblio" ("biblio_id") ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE "public"."tbl_text_identification_keys" ADD CONSTRAINT "fk_text_identification_keys_taxon_id" FOREIGN KEY ("taxon_id") REFERENCES "public"."tbl_taxa_tree_master" ("taxon_id") ON DELETE CASCADE ON UPDATE CASCADE;
