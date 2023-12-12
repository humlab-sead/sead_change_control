-- Deploy sead_api: 20190101_DML_FACET_SCHEMA

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description
  Reviewer
  Approver rollback
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin

    begin

        set search_path = facet, pg_catalog;
        set default_with_oids = false;

        --if current_role != 'querysead_owner' then
        --    raise exception 'This script must be run as querysead_worker!';
        --end if;

        if current_database() not like 'sead_staging%' then
            raise exception 'This script must be run in sead_staging!';
        end if;


        set statement_timeout = 0;
        set lock_timeout = 0;
        set client_encoding = 'UTF8';
        set standard_conforming_strings = on;
        set check_function_bodies = false;
        set client_min_messages = warning;

        set search_path = facet, pg_catalog;

        --set role querysead_owner;
        insert into facet.table (table_or_udf_name, primary_key_name, table_id, is_udf) (values

			-- SELECT '(''' || s.table_name || ''', ''' || s.column_name || ''', ' || coalesce(f.table_id::text, '9999') || ', FALSE),'
			-- FROM clearing_house.fn_dba_get_sead_public_db_schema('public', 'sead_master') s
			-- LEFT OUTER JOIN facet.table f
			--   ON f.table_or_udf_name = s.table_name
			-- WHERE coalesce(is_pk,'YES') = 'YES'
			--  -- AND coalesce(f.table_or_udf_name,'X') <> coalesce(s.table_name, 'Y')
			-- ORDER BY s.table_name

			('tbl_abundance_elements', 'abundance_element_id', 38, FALSE),
			('tbl_abundance_ident_levels', 'abundance_ident_level_id', 50, FALSE),
			('tbl_abundance_modifications', 'abundance_modification_id', 44, FALSE),
			('tbl_abundances', 'abundance_id', 88, FALSE),
			('tbl_activity_types', 'activity_type_id', 11, FALSE),
			('tbl_age_types', 'age_type_id', 160, FALSE),
			('tbl_aggregate_datasets', 'aggregate_dataset_id', 145, FALSE),
			('tbl_aggregate_order_types', 'aggregate_order_type_id', 47, FALSE),
			('tbl_aggregate_sample_ages', 'aggregate_sample_age_id', 115, FALSE),
			('tbl_aggregate_samples', 'aggregate_sample_id', 2, FALSE),
			('tbl_alt_ref_types', 'alt_ref_type_id', 136, FALSE),
			('tbl_analysis_entities', 'analysis_entity_id', 4, FALSE),
			('tbl_analysis_entity_ages', 'analysis_entity_age_id', 96, FALSE),
			('tbl_analysis_entity_dimensions', 'analysis_entity_dimension_id', 93, FALSE),
			('tbl_analysis_entity_prep_methods', 'analysis_entity_prep_method_id', 3, FALSE),
			('tbl_biblio', 'biblio_id', 84, FALSE),
			('tbl_ceramics', 'ceramics_id', 139, FALSE),
			('tbl_ceramics_lookup', 'ceramics_lookup_id', 161, FALSE),
			('tbl_ceramics_measurements', 'ceramics_measurement_id', 97, FALSE),
			('tbl_chron_controls', 'chron_control_id', 59, FALSE),
			('tbl_chron_control_types', 'chron_control_type_id', 147, FALSE),
			('tbl_chronologies', 'chronology_id', 117, FALSE),
			('tbl_colours', 'colour_id', 14, FALSE),
			('tbl_contacts', 'contact_id', 29, FALSE),
			('tbl_contact_types', 'contact_type_id', 123, FALSE),
			('tbl_coordinate_method_dimensions', 'coordinate_method_dimension_id', 106, FALSE),
			('tbl_dataset_contacts', 'dataset_contact_id', 83, FALSE),
			('tbl_dataset_masters', 'master_set_id', 76, FALSE),
			('tbl_dataset_methods', 'dataset_method_id', 162, FALSE),
			('tbl_datasets', 'dataset_id', 86, FALSE),
			('tbl_dataset_submissions', 'dataset_submission_id', 133, FALSE),
			('tbl_dataset_submission_types', 'submission_type_id', 140, FALSE),
			('tbl_data_type_groups', 'data_type_group_id', 104, FALSE),
			('tbl_data_types', 'data_type_id', 135, FALSE),
			('tbl_dating_labs', 'dating_lab_id', 85, FALSE),
			('tbl_dating_material', 'dating_material_id', 134, FALSE),
			('tbl_dating_uncertainty', 'dating_uncertainty_id', 5, FALSE),
			('tbl_dendro', 'dendro_id', 69, FALSE),
			('tbl_dendro_date_notes', 'dendro_date_note_id', 127, FALSE),
			('tbl_dendro_dates', 'dendro_date_id', 138, FALSE),
			('tbl_dendro_lookup', 'dendro_lookup_id', 163, FALSE),
			('tbl_dendro_measurements', 'dendro_measurement_id', 100, FALSE),
			('tbl_dimensions', 'dimension_id', 98, FALSE),
			('tbl_ecocode_definitions', 'ecocode_definition_id', 62, FALSE),
			('tbl_ecocode_groups', 'ecocode_group_id', 51, FALSE),
			('tbl_ecocodes', 'ecocode_id', 101, FALSE),
			('tbl_ecocode_systems', 'ecocode_system_id', 128, FALSE),
			('tbl_error_uncertainties', 'error_uncertainty_id', 164, FALSE),
			('tbl_features', 'feature_id', 75, FALSE),
			('tbl_feature_types', 'feature_type_id', 6, FALSE),
			('tbl_geochronology', 'geochron_id', 60, FALSE),
			('tbl_geochron_refs', 'geochron_ref_id', 87, FALSE),
			('tbl_horizons', 'horizon_id', 1, FALSE),
			('tbl_identification_levels', 'identification_level_id', 146, FALSE),
			('tbl_image_types', 'image_type_id', 16, FALSE),
			('tbl_imported_taxa_replacements', 'imported_taxa_replacement_id', 22, FALSE),
			('tbl_isotope_measurements', 'isotope_measurement_id', 165, FALSE),
			('tbl_isotopes', 'isotope_id', 166, FALSE),
			('tbl_isotope_standards', 'isotope_standard_id', 167, FALSE),
			('tbl_isotope_types', 'isotope_type_id', 168, FALSE),
			('tbl_languages', 'language_id', 79, FALSE),
			('tbl_lithology', 'lithology_id', 80, FALSE),
			('tbl_locations', 'location_id', 35, FALSE),
			('tbl_location_types', 'location_type_id', 92, FALSE),
			('tbl_mcrdata_birmbeetledat', 'mcrdata_birmbeetledat_id', 70, FALSE),
			('tbl_mcr_names', 'taxon_id', 18, FALSE),
			('tbl_mcr_summary_data', 'mcr_summary_data_id', 19, FALSE),
			('tbl_measured_value_dimensions', 'measured_value_dimension_id', 12, FALSE),
			('tbl_measured_values', 'measured_value_id', 121, FALSE),
			('tbl_method_groups', 'method_group_id', 33, FALSE),
			('tbl_methods', 'method_id', 89, FALSE),
			('tbl_modification_types', 'modification_type_id', 142, FALSE),
			('tbl_physical_sample_features', 'physical_sample_feature_id', 132, FALSE),
			('tbl_physical_samples', 'physical_sample_id', 102, FALSE),
			('tbl_projects', 'project_id', 58, FALSE),
			('tbl_project_stages', 'project_stage_id', 9, FALSE),
			('tbl_project_types', 'project_type_id', 17, FALSE),
			('tbl_rdb', 'rdb_id', 48, FALSE),
			('tbl_rdb_codes', 'rdb_code_id', 24, FALSE),
			('tbl_rdb_systems', 'rdb_system_id', 143, FALSE),
			('tbl_record_types', 'record_type_id', 110, FALSE),
			('tbl_relative_age_refs', 'relative_age_ref_id', 68, FALSE),
			('tbl_relative_ages', 'relative_age_id', 71, FALSE),
			('tbl_relative_age_types', 'relative_age_type_id', 37, FALSE),
			('tbl_relative_dates', 'relative_date_id', 55, FALSE),
			('tbl_sample_alt_refs', 'sample_alt_ref_id', 10, FALSE),
			('tbl_sample_colours', 'sample_colour_id', 32, FALSE),
			('tbl_sample_coordinates', 'sample_coordinate_id', 8, FALSE),
			('tbl_sample_descriptions', 'sample_description_id', 111, FALSE),
			('tbl_sample_description_sample_group_contexts', 'sample_description_sample_group_context_id', 56, FALSE),
			('tbl_sample_description_types', 'sample_description_type_id', 73, FALSE),
			('tbl_sample_dimensions', 'sample_dimension_id', 116, FALSE),
			('tbl_sample_group_coordinates', 'sample_group_position_id', 30, FALSE),
			('tbl_sample_group_descriptions', 'sample_group_description_id', 130, FALSE),
			('tbl_sample_group_description_types', 'sample_group_description_type_id', 54, FALSE),
			('tbl_sample_group_description_type_sampling_contexts', 'sample_group_description_type_sampling_context_id', 28, FALSE),
			('tbl_sample_group_dimensions', 'sample_group_dimension_id', 112, FALSE),
			('tbl_sample_group_images', 'sample_group_image_id', 124, FALSE),
			('tbl_sample_group_notes', 'sample_group_note_id', 52, FALSE),
			('tbl_sample_group_references', 'sample_group_reference_id', 42, FALSE),
			('tbl_sample_groups', 'sample_group_id', 91, FALSE),
			('tbl_sample_group_sampling_contexts', 'sampling_context_id', 40, FALSE),
			('tbl_sample_horizons', 'sample_horizon_id', 41, FALSE),
			('tbl_sample_images', 'sample_image_id', 61, FALSE),
			('tbl_sample_locations', 'sample_location_id', 49, FALSE),
			('tbl_sample_location_types', 'sample_location_type_id', 144, FALSE),
			('tbl_sample_location_type_sampling_contexts', 'sample_location_type_sampling_context_id', 65, FALSE),
			('tbl_sample_notes', 'sample_note_id', 94, FALSE),
			('tbl_sample_types', 'sample_type_id', 105, FALSE),
			('tbl_season_or_qualifier', 'season_or_qualifier_id', 169, FALSE),
			('tbl_seasons', 'season_id', 82, FALSE),
			('tbl_season_types', 'season_type_id', 108, FALSE),
			('tbl_site_images', 'site_image_id', 64, FALSE),
			('tbl_site_locations', 'site_location_id', 113, FALSE),
			('tbl_site_natgridrefs', 'site_natgridref_id', 78, FALSE),
			('tbl_site_other_records', 'site_other_records_id', 77, FALSE),
			('tbl_site_preservation_status', 'site_preservation_status_id', 95, FALSE),
			('tbl_site_references', 'site_reference_id', 15, FALSE),
			('tbl_sites', 'site_id', 119, FALSE),
			('tbl_species_associations', 'species_association_id', 131, FALSE),
			('tbl_species_association_types', 'association_type_id', 118, FALSE),
			('tbl_taxa_common_names', 'taxon_common_name_id', 103, FALSE),
			('tbl_taxa_images', 'taxa_images_id', 20, FALSE),
			('tbl_taxa_measured_attributes', 'measured_attribute_id', 126, FALSE),
			('tbl_taxa_reference_specimens', 'taxa_reference_specimen_id', 141, FALSE),
			('tbl_taxa_seasonality', 'seasonality_id', 27, FALSE),
			('tbl_taxa_synonyms', 'synonym_id', 13, FALSE),
			('tbl_taxa_tree_authors', 'author_id', 39, FALSE),
			('tbl_taxa_tree_families', 'family_id', 36, FALSE),
			('tbl_taxa_tree_genera', 'genus_id', 148, FALSE),
			('tbl_taxa_tree_master', 'taxon_id', 109, FALSE),
			('tbl_taxa_tree_orders', 'order_id', 45, FALSE),
			('tbl_taxonomic_order', 'taxonomic_order_id', 21, FALSE),
			('tbl_taxonomic_order_biblio', 'taxonomic_order_biblio_id', 63, FALSE),
			('tbl_taxonomic_order_systems', 'taxonomic_order_system_id', 43, FALSE),
			('tbl_taxonomy_notes', 'taxonomy_notes_id', 53, FALSE),
			('tbl_tephra_dates', 'tephra_date_id', 107, FALSE),
			('tbl_tephra_refs', 'tephra_ref_id', 129, FALSE),
			('tbl_tephras', 'tephra_id', 31, FALSE),
			('tbl_text_biology', 'biology_id', 122, FALSE),
			('tbl_text_distribution', 'distribution_id', 90, FALSE),
			('tbl_text_identification_keys', 'key_id', 67, FALSE),
			('tbl_units', 'unit_id', 72, FALSE),
			('tbl_updates_log', 'updates_log_id', 170, FALSE),
			('tbl_years_types', 'years_type_id', 74, FALSE),

            ('facet.method_measured_values(33,0)', 'analysis_entity_id', 150, TRUE),
            ('facet.method_measured_values(33,82)', 'analysis_entity_id', 151, TRUE),
            ('facet.method_measured_values(32,0)', 'analysis_entity_id', 152, TRUE),
            ('facet.method_measured_values(37,0)', 'analysis_entity_id', 153, TRUE),

            ('facet.view_abundances_by_taxon_analysis_entity', 'xxxx', 25, FALSE),
            ('facet.view_site_references', 'xxxx', 26, FALSE),
            ('facet.view_abundance', 'xxxx', 57, FALSE),
            ('facet.view_taxa_biblio', 'xxxx', 99, FALSE),
            ('facet.view_sample_group_references', 'xxxx', 114, FALSE),

            ('facet.method_abundance(3)',   'xxxx', 154, TRUE),
            ('facet.method_abundance(8)',   'xxxx', 155, TRUE),
            ('facet.method_abundance(111)', 'xxxx', 156, TRUE),

            ('countries', 'location_id', 46, FALSE)

        ) on conflict (table_id) do update
            set table_or_udf_name = excluded.table_or_udf_name;

		with new_table_relation(source_table_name, source_column_name, target_table_name, target_column_name, weight) as (values
			('tbl_abundance_elements', 'record_type_id', 'tbl_record_types', 'record_type_id', 20),
			('tbl_abundance_ident_levels', 'abundance_id', 'tbl_abundances', 'abundance_id', 20),
			('tbl_abundance_ident_levels', 'identification_level_id', 'tbl_identification_levels', 'identification_level_id', 20),
			('tbl_abundance_modifications', 'abundance_id', 'tbl_abundances', 'abundance_id', 20),
			('tbl_abundance_modifications', 'modification_type_id', 'tbl_modification_types', 'modification_type_id', 20),
			('tbl_abundances', 'abundance_element_id', 'tbl_abundance_elements', 'abundance_element_id', 20),
			('tbl_abundances', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 20),
			('tbl_aggregate_datasets', 'aggregate_order_type_id', 'tbl_aggregate_order_types', 'aggregate_order_type_id', 20),
			('tbl_aggregate_sample_ages', 'aggregate_dataset_id', 'tbl_aggregate_datasets', 'aggregate_dataset_id', 20),
			('tbl_aggregate_sample_ages', 'analysis_entity_age_id', 'tbl_analysis_entity_ages', 'analysis_entity_age_id', 20),
			('tbl_aggregate_samples', 'aggregate_dataset_id', 'tbl_aggregate_datasets', 'aggregate_dataset_id', 20),
			('tbl_aggregate_samples', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 20),
			('tbl_analysis_entity_ages', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 20),
			('tbl_analysis_entity_ages', 'chronology_id', 'tbl_chronologies', 'chronology_id', 20),
			('tbl_analysis_entity_dimensions', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 20),
			('tbl_analysis_entity_dimensions', 'dimension_id', 'tbl_dimensions', 'dimension_id', 20),
			('tbl_analysis_entity_prep_methods', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 20),
			('tbl_analysis_entity_prep_methods', 'method_id', 'tbl_methods', 'method_id', 20),
			('tbl_ceramics', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 20),
			('tbl_ceramics', 'ceramics_measurement_id', 'tbl_ceramics_measurements', 'ceramics_measurement_id', 20),
			('tbl_ceramics_measurements', 'method_id', 'tbl_methods', 'method_id', 20),
			('tbl_chron_controls', 'chron_control_type_id', 'tbl_chron_control_types', 'chron_control_type_id', 20),
			('tbl_chron_controls', 'chronology_id', 'tbl_chronologies', 'chronology_id', 20),
			('tbl_chronologies', 'contact_id', 'tbl_contacts', 'contact_id', 20),
			('tbl_chronologies', 'sample_group_id', 'tbl_sample_groups', 'sample_group_id', 20),
			('tbl_colours', 'method_id', 'tbl_methods', 'method_id', 20),
			('tbl_coordinate_method_dimensions', 'dimension_id', 'tbl_dimensions', 'dimension_id', 20),
			('tbl_coordinate_method_dimensions', 'method_id', 'tbl_methods', 'method_id', 20),
			('tbl_dataset_contacts', 'contact_id', 'tbl_contacts', 'contact_id', 20),
			('tbl_dataset_contacts', 'contact_type_id', 'tbl_contact_types', 'contact_type_id', 20),
			('tbl_dataset_contacts', 'dataset_id', 'tbl_datasets', 'dataset_id', 20),
			('tbl_dataset_masters', 'contact_id', 'tbl_contacts', 'contact_id', 20),
			('tbl_datasets', 'data_type_id', 'tbl_data_types', 'data_type_id', 20),
			('tbl_datasets', 'master_set_id', 'tbl_dataset_masters', 'master_set_id', 20),
			('tbl_datasets', 'project_id', 'tbl_projects', 'project_id', 20),
			('tbl_datasets', 'updated_dataset_id', 'tbl_datasets', 'dataset_id', 20),
			('tbl_dataset_submissions', 'contact_id', 'tbl_contacts', 'contact_id', 20),
			('tbl_dataset_submissions', 'dataset_id', 'tbl_datasets', 'dataset_id', 20),
			('tbl_dataset_submissions', 'submission_type_id', 'tbl_dataset_submission_types', 'submission_type_id', 20),
			('tbl_data_types', 'data_type_group_id', 'tbl_data_type_groups', 'data_type_group_id', 20),
			('tbl_dating_labs', 'contact_id', 'tbl_contacts', 'contact_id', 20),
			('tbl_dating_material', 'abundance_element_id', 'tbl_abundance_elements', 'abundance_element_id', 20),
			('tbl_dating_material', 'geochron_id', 'tbl_geochronology', 'geochron_id', 20),
			('tbl_dating_material', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 20),
			('tbl_dendro', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 20),
			('tbl_dendro', 'dendro_measurement_id', 'tbl_dendro_measurements', 'dendro_measurement_id', 20),
			('tbl_dendro_date_notes', 'dendro_date_id', 'tbl_dendro_dates', 'dendro_date_id', 20),
			('tbl_dendro_dates', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 20),
			('tbl_dendro_dates', 'dating_uncertainty_id', 'tbl_dating_uncertainty', 'dating_uncertainty_id', 20),
			('tbl_dendro_dates', 'years_type_id', 'tbl_years_types', 'years_type_id', 20),
			('tbl_dendro_measurements', 'method_id', 'tbl_methods', 'method_id', 20),
			('tbl_dimensions', 'method_group_id', 'tbl_method_groups', 'method_group_id', 20),
			('tbl_dimensions', 'unit_id', 'tbl_units', 'unit_id', 20),
			('tbl_ecocode_definitions', 'ecocode_group_id', 'tbl_ecocode_groups', 'ecocode_group_id', 20),
			('tbl_ecocode_groups', 'ecocode_system_id', 'tbl_ecocode_systems', 'ecocode_system_id', 20),
			('tbl_ecocodes', 'ecocode_definition_id', 'tbl_ecocode_definitions', 'ecocode_definition_id', 20),
			('tbl_ecocodes', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 20),
			('tbl_features', 'feature_type_id', 'tbl_feature_types', 'feature_type_id', 20),
			('tbl_geochronology', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 20),
			('tbl_geochronology', 'dating_lab_id', 'tbl_dating_labs', 'dating_lab_id', 20),
			('tbl_geochronology', 'dating_uncertainty_id', 'tbl_dating_uncertainty', 'dating_uncertainty_id', 20),
			('tbl_geochron_refs', 'geochron_id', 'tbl_geochronology', 'geochron_id', 20),
			('tbl_imported_taxa_replacements', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 20),
			('tbl_lithology', 'sample_group_id', 'tbl_sample_groups', 'sample_group_id', 20),
			('tbl_aggregate_datasets', 'biblio_id', 'tbl_biblio', 'biblio_id', 150),
			('tbl_analysis_entities', 'dataset_id', 'tbl_datasets', 'dataset_id', 1),
			('tbl_analysis_entities', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 1),
			('tbl_datasets', 'method_id', 'tbl_methods', 'method_id', 1),
			('tbl_datasets', 'biblio_id', 'tbl_biblio', 'biblio_id', 150),
			('tbl_ecocode_systems', 'biblio_id', 'tbl_biblio', 'biblio_id', 150),
			('tbl_geochron_refs', 'biblio_id', 'tbl_biblio', 'biblio_id', 150),
			('tbl_horizons', 'method_id', 'tbl_methods', 'method_id', 70),
			('tbl_dataset_masters', 'biblio_id', 'tbl_biblio', 'biblio_id', 200),
			('tbl_locations', 'location_type_id', 'tbl_location_types', 'location_type_id', 20),
			('tbl_mcrdata_birmbeetledat', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 20),
			('tbl_mcr_names', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 20),
			('tbl_mcr_summary_data', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 20),
			('tbl_measured_value_dimensions', 'dimension_id', 'tbl_dimensions', 'dimension_id', 20),
			('tbl_measured_value_dimensions', 'measured_value_id', 'tbl_measured_values', 'measured_value_id', 20),
			('tbl_measured_values', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 20),
			('tbl_methods', 'method_group_id', 'tbl_method_groups', 'method_group_id', 20),
			('tbl_methods', 'record_type_id', 'tbl_record_types', 'record_type_id', 20),
			('tbl_physical_sample_features', 'feature_id', 'tbl_features', 'feature_id', 20),
			('tbl_physical_sample_features', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 20),
			('tbl_physical_samples', 'alt_ref_type_id', 'tbl_alt_ref_types', 'alt_ref_type_id', 20),
			('tbl_physical_samples', 'sample_type_id', 'tbl_sample_types', 'sample_type_id', 20),
			('tbl_projects', 'project_stage_id', 'tbl_project_stages', 'project_stage_id', 20),
			('tbl_projects', 'project_type_id', 'tbl_project_types', 'project_type_id', 20),
			('tbl_rdb', 'rdb_code_id', 'tbl_rdb_codes', 'rdb_code_id', 20),
			('tbl_rdb', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 20),
			('tbl_rdb_codes', 'rdb_system_id', 'tbl_rdb_systems', 'rdb_system_id', 20),
			('tbl_relative_age_refs', 'relative_age_id', 'tbl_relative_ages', 'relative_age_id', 20),
			('tbl_relative_ages', 'relative_age_type_id', 'tbl_relative_age_types', 'relative_age_type_id', 20),
			('tbl_relative_dates', 'dating_uncertainty_id', 'tbl_dating_uncertainty', 'dating_uncertainty_id', 20),
			('tbl_relative_dates', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 20),
			('tbl_relative_dates', 'relative_age_id', 'tbl_relative_ages', 'relative_age_id', 20),
			('tbl_sample_alt_refs', 'alt_ref_type_id', 'tbl_alt_ref_types', 'alt_ref_type_id', 20),
			('tbl_sample_alt_refs', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 20),
			('tbl_sample_colours', 'colour_id', 'tbl_colours', 'colour_id', 20),
			('tbl_sample_colours', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 20),
			('tbl_sample_coordinates', 'coordinate_method_dimension_id', 'tbl_coordinate_method_dimensions', 'coordinate_method_dimension_id', 20),
			('tbl_sample_coordinates', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 20),
			('tbl_sample_descriptions', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 20),
			('tbl_sample_descriptions', 'sample_description_type_id', 'tbl_sample_description_types', 'sample_description_type_id', 20),
			('tbl_sample_description_sample_group_contexts', 'sample_description_type_id', 'tbl_sample_description_types', 'sample_description_type_id', 20),
			('tbl_sample_description_sample_group_contexts', 'sampling_context_id', 'tbl_sample_group_sampling_contexts', 'sampling_context_id', 20),
			('tbl_sample_dimensions', 'dimension_id', 'tbl_dimensions', 'dimension_id', 20),
			('tbl_sample_dimensions', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 20),
			('tbl_sample_group_coordinates', 'coordinate_method_dimension_id', 'tbl_coordinate_method_dimensions', 'coordinate_method_dimension_id', 20),
			('tbl_sample_group_coordinates', 'sample_group_id', 'tbl_sample_groups', 'sample_group_id', 20),
			('tbl_sample_group_descriptions', 'sample_group_description_type_id', 'tbl_sample_group_description_types', 'sample_group_description_type_id', 20),
			('tbl_sample_group_descriptions', 'sample_group_id', 'tbl_sample_groups', 'sample_group_id', 20),
			('tbl_sample_group_description_type_sampling_contexts', 'sample_group_description_type_id', 'tbl_sample_group_description_types', 'sample_group_description_type_id', 20),
			('tbl_sample_group_description_type_sampling_contexts', 'sampling_context_id', 'tbl_sample_group_sampling_contexts', 'sampling_context_id', 20),
			('tbl_sample_group_dimensions', 'dimension_id', 'tbl_dimensions', 'dimension_id', 20),
			('tbl_sample_group_dimensions', 'sample_group_id', 'tbl_sample_groups', 'sample_group_id', 20),
			('tbl_sample_group_images', 'image_type_id', 'tbl_image_types', 'image_type_id', 20),
			('tbl_sample_group_images', 'sample_group_id', 'tbl_sample_groups', 'sample_group_id', 20),
			('tbl_sample_group_notes', 'sample_group_id', 'tbl_sample_groups', 'sample_group_id', 20),
			('tbl_sample_group_references', 'sample_group_id', 'tbl_sample_groups', 'sample_group_id', 20),
			('tbl_sample_groups', 'sampling_context_id', 'tbl_sample_group_sampling_contexts', 'sampling_context_id', 20),
			('tbl_sample_horizons', 'horizon_id', 'tbl_horizons', 'horizon_id', 20),
			('tbl_sample_horizons', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 20),
			('tbl_sample_images', 'image_type_id', 'tbl_image_types', 'image_type_id', 20),
			('tbl_sample_images', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 20),
			('tbl_sample_locations', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 20),
			('tbl_sample_locations', 'sample_location_type_id', 'tbl_sample_location_types', 'sample_location_type_id', 20),
			('tbl_sample_location_type_sampling_contexts', 'sample_location_type_id', 'tbl_sample_location_types', 'sample_location_type_id', 20),
			('tbl_sample_location_type_sampling_contexts', 'sampling_context_id', 'tbl_sample_group_sampling_contexts', 'sampling_context_id', 20),
			('tbl_sample_notes', 'physical_sample_id', 'tbl_physical_samples', 'physical_sample_id', 20),
			('tbl_seasons', 'season_type_id', 'tbl_season_types', 'season_type_id', 20),
			('tbl_site_images', 'contact_id', 'tbl_contacts', 'contact_id', 20),
			('tbl_site_images', 'image_type_id', 'tbl_image_types', 'image_type_id', 20),
			('tbl_site_images', 'site_id', 'tbl_sites', 'site_id', 20),
			('tbl_site_locations', 'site_id', 'tbl_sites', 'site_id', 20),
			('tbl_methods', 'biblio_id', 'tbl_biblio', 'biblio_id', 150),
			('tbl_physical_samples', 'sample_group_id', 'tbl_sample_groups', 'sample_group_id', 1),
			('tbl_rdb', 'location_id', 'tbl_locations', 'location_id', 150),
			('tbl_rdb_systems', 'biblio_id', 'tbl_biblio', 'biblio_id', 150),
			('tbl_rdb_systems', 'location_id', 'tbl_locations', 'location_id', 150),
			('tbl_relative_age_refs', 'biblio_id', 'tbl_biblio', 'biblio_id', 150),
			('tbl_relative_dates', 'method_id', 'tbl_methods', 'method_id', 70),
			('tbl_sample_dimensions', 'method_id', 'tbl_methods', 'method_id', 150),
			('tbl_sample_groups', 'method_id', 'tbl_methods', 'method_id', 150),
			('tbl_sample_groups', 'site_id', 'tbl_sites', 'site_id', 1),
			('tbl_site_locations', 'location_id', 'tbl_locations', 'location_id', 5),
			('tbl_sample_group_references', 'biblio_id', 'tbl_biblio', 'biblio_id', 90),
			('tbl_site_natgridrefs', 'method_id', 'tbl_methods', 'method_id', 20),
			('tbl_site_natgridrefs', 'site_id', 'tbl_sites', 'site_id', 20),
			('tbl_site_preservation_status', 'site_id', 'tbl_sites', 'site_id', 20),
			('tbl_site_references', 'site_id', 'tbl_sites', 'site_id', 20),
			('tbl_species_associations', 'association_type_id', 'tbl_species_association_types', 'association_type_id', 20),
			('tbl_species_associations', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 20),
			('tbl_taxa_common_names', 'language_id', 'tbl_languages', 'language_id', 20),
			('tbl_taxa_common_names', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 20),
			('tbl_taxa_images', 'image_type_id', 'tbl_image_types', 'image_type_id', 20),
			('tbl_taxa_images', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 20),
			('tbl_taxa_measured_attributes', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 20),
			('tbl_taxa_reference_specimens', 'contact_id', 'tbl_contacts', 'contact_id', 20),
			('tbl_taxa_reference_specimens', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 20),
			('tbl_taxa_seasonality', 'activity_type_id', 'tbl_activity_types', 'activity_type_id', 20),
			('tbl_taxa_seasonality', 'season_id', 'tbl_seasons', 'season_id', 20),
			('tbl_taxa_seasonality', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 20),
			('tbl_taxa_tree_master', 'author_id', 'tbl_taxa_tree_authors', 'author_id', 20),
			('tbl_taxonomic_order', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 20),
			('tbl_taxonomic_order', 'taxonomic_order_system_id', 'tbl_taxonomic_order_systems', 'taxonomic_order_system_id', 20),
			('tbl_taxonomic_order_biblio', 'taxonomic_order_system_id', 'tbl_taxonomic_order_systems', 'taxonomic_order_system_id', 20),
			('tbl_taxonomy_notes', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 20),
			('tbl_tephra_dates', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 20),
			('tbl_tephra_dates', 'dating_uncertainty_id', 'tbl_dating_uncertainty', 'dating_uncertainty_id', 20),
			('tbl_tephra_dates', 'tephra_id', 'tbl_tephras', 'tephra_id', 20),
			('tbl_tephra_refs', 'tephra_id', 'tbl_tephras', 'tephra_id', 20),
			('tbl_text_biology', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 20),
			('tbl_text_distribution', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 20),
			('tbl_text_identification_keys', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 20),
			('tbl_abundances', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 1),
			('tbl_methods', 'unit_id', 'tbl_units', 'unit_id', 150),
			('tbl_relative_ages', 'location_id', 'tbl_locations', 'location_id', 70),
			('tbl_site_other_records', 'biblio_id', 'tbl_biblio', 'biblio_id', 150),
			('tbl_site_other_records', 'site_id', 'tbl_sites', 'site_id', 150),
			('tbl_site_other_records', 'record_type_id', 'tbl_record_types', 'record_type_id', 150),
			('tbl_species_associations', 'biblio_id', 'tbl_biblio', 'biblio_id', 150),
			('tbl_taxa_seasonality', 'location_id', 'tbl_locations', 'location_id', 60),
			('tbl_taxa_synonyms', 'author_id', 'tbl_taxa_tree_authors', 'author_id', 150),
			('tbl_taxa_synonyms', 'biblio_id', 'tbl_biblio', 'biblio_id', 150),
			('tbl_text_biology', 'biblio_id', 'tbl_biblio', 'biblio_id', 150),
			('tbl_taxa_synonyms', 'family_id', 'tbl_taxa_tree_families', 'family_id', 150),
			('tbl_taxa_synonyms', 'genus_id', 'tbl_taxa_tree_genera', 'genus_id', 150),
			('tbl_taxa_synonyms', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 150),
			('tbl_taxa_tree_families', 'order_id', 'tbl_taxa_tree_orders', 'order_id', 1),
			('tbl_taxa_tree_genera', 'family_id', 'tbl_taxa_tree_families', 'family_id', 1),
			('tbl_taxa_tree_master', 'genus_id', 'tbl_taxa_tree_genera', 'genus_id', 1),
			('tbl_taxa_tree_orders', 'record_type_id', 'tbl_record_types', 'record_type_id', 1),
			('tbl_taxonomic_order_biblio', 'biblio_id', 'tbl_biblio', 'biblio_id', 150),
			('tbl_taxonomy_notes', 'biblio_id', 'tbl_biblio', 'biblio_id', 150),
			('tbl_text_distribution', 'biblio_id', 'tbl_biblio', 'biblio_id', 150),
			('tbl_text_identification_keys',           'biblio_id', 'tbl_biblio', 'biblio_id', 150),
			('tbl_tephra_refs',                     'biblio_id',            'tbl_biblio',            'biblio_id', 150),
			('tbl_site_references',                 'biblio_id',            'tbl_biblio',            'biblio_id', 90),
			('facet.view_abundance',                'analysis_entity_id',   'tbl_analysis_entities', 'analysis_entity_id', 2),
			('facet.view_abundance',                'taxon_id',             'tbl_taxa_tree_master',  'taxon_id', 20),
			('facet.view_sample_group_references',  'biblio_id',            'tbl_biblio',            'biblio_id', 80),
			('facet.view_sample_group_references',  'sample_group_id',      'tbl_sample_groups',     'sample_group_id', 15),
			('facet.view_site_references',          'biblio_id',            'tbl_biblio',            'biblio_id', 80),
			('facet.view_site_references',          'site_id',              'tbl_sites',             'site_id', 15),
			('facet.view_taxa_biblio',              'biblio_id',            'tbl_biblio',            'biblio_id', 10),
			('facet.view_taxa_biblio',              'taxon_id',             'tbl_taxa_tree_master',  'taxon_id', 2),
			('facet.method_measured_values',        'analysis_entity_id',   'tbl_analysis_entities', 'analysis_entity_id', 20),
			('facet.method_measured_values(33,0)',  'analysis_entity_id',   'tbl_analysis_entities', 'analysis_entity_id', 20),
			('facet.method_measured_values(33,82)', 'analysis_entity_id',   'tbl_analysis_entities', 'analysis_entity_id', 20),
			('facet.method_measured_values(32,0)',  'analysis_entity_id',   'tbl_analysis_entities', 'analysis_entity_id', 20),
			('facet.method_measured_values(37,0)',  'analysis_entity_id',   'tbl_analysis_entities', 'analysis_entity_id', 20),
			('facet.view_abundances_by_taxon_analysis_entity', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 20),
			('facet.view_abundances_by_taxon_analysis_entity', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 20),
			('facet.method_abundance(3)', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 20),
			('facet.method_abundance(3)', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 20),
			('facet.method_abundance(8)', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 20),
			('facet.method_abundance(8)', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 20),
			('facet.method_abundance(111)', 'taxon_id', 'tbl_taxa_tree_master', 'taxon_id', 20),
			('facet.method_abundance(111)', 'analysis_entity_id', 'tbl_analysis_entities', 'analysis_entity_id', 20)
		)
			insert into facet.table_relation (source_table_id, source_column_name, target_table_id, target_column_name, weight)
				select s.table_id, r.source_column_name, t.table_id, r.target_column_name, r.weight
				from new_table_relation r
				join facet.table s
				  on s.table_or_udf_name = r.source_table_name
				join facet.table t
				  on t.table_or_udf_name = r.target_table_name
		    on conflict (table_relation_id) do update
            set source_table_id = excluded.source_table_id,
                target_table_id = excluded.target_table_id,
                weight = excluded.weight,
                source_column_name = excluded.source_column_name,
                target_column_name = excluded.target_column_name;

        insert into facet_group (facet_group_id, facet_group_key, display_title, description, is_applicable, is_default) (values
            (99, 'ROOT', 'ROOT', 'ROOT', false, false),
            (1, 'others', 'Others', 'Others', true, false),
            (2, 'space_time', 'Space/Time', 'Space/Time', true, false),
            (3, 'time', 'Time', 'Time', true, false),
            (4, 'ecology', 'Ecology', 'Ecology', true, false),
            (5, 'measured_values', 'Measured values', 'Measured values', true, false),
            (6, 'taxonomy', 'Taxonomy', 'Taxonomy', true, false)
        ) on conflict (facet_group_id) do update
            set facet_group_key = excluded.facet_group_key,
                display_title = excluded.display_title,
                description = excluded.description,
                is_applicable = excluded.is_applicable,
                is_default = excluded.is_default;

       insert into facet_type (facet_type_id, facet_type_name, reload_as_target) (values
            (9, 'undefined', false),
            (1, 'discrete', false),
            (2, 'range', true),
            (3, 'geo', true)
        ) on conflict (facet_type_id) do update
            set facet_type_name = excluded.facet_type_name,
                reload_as_target = excluded.reload_as_target;

        insert into facet.result_aggregate (aggregate_id, aggregate_key, display_text, is_applicable, is_activated, input_type, has_selector) (values
            (1, 'site_level', 'Site level', false, true, 'checkboxes', true),
            (2, 'aggregate_all', 'Aggregate all', false, true, 'checkboxes', true),
            (3, 'sample_group_level', 'Sample group level', false, true, 'checkboxes', true),
            (4, 'map_result', 'Map result', false, false, 'checkboxes', false)
        ) on conflict (aggregate_id) do update
            set aggregate_key = excluded.aggregate_key,
                display_text = excluded.display_text,
                is_applicable = excluded.is_applicable,
                is_activated = excluded.is_activated,
                input_type = excluded.input_type,
                has_selector = excluded.has_selector;

       insert into facet.result_field_type (field_type_id, is_result_value, sql_field_compiler, is_aggregate_field, is_sort_field, is_item_field, sql_template) (values
            ('sum_item', true, 'TemplateFieldCompiler', true, false, false, 'SUM({0}::double precision) AS sum_of_{0}'),
            ('count_item', true, 'TemplateFieldCompiler', true, false, false, 'COUNT({0}) AS count_of_{0}'),
            ('avg_item', true, 'TemplateFieldCompiler', true, false, false, 'AVG({0}) AS avg_of_{0}'),
            ('text_agg_item', true, 'TemplateFieldCompiler', true, false, false, 'ARRAY_TO_STRING(ARRAY_AGG(DISTINCT {0}),'','') AS text_agg_of_{0}'),
            ('single_item', true, 'TemplateFieldCompiler', false, false, true, '{0}'),
            ('link_item', true, 'TemplateFieldCompiler', false, false, true, '{0}'),
            ('link_item_filtered', true, 'TemplateFieldCompiler', false, false, true, '{0}'),
            ('sort_item', false, 'TemplateFieldCompiler', false, true, false, '{0}')
        ) on conflict (field_type_id) do update
            set is_result_value = excluded.is_result_value,
                sql_field_compiler = excluded.sql_field_compiler,
                is_aggregate_field = excluded.is_aggregate_field,
                is_sort_field = excluded.is_sort_field,
                is_item_field = excluded.is_item_field,
                sql_template = excluded.sql_template;

       insert into facet.result_field (result_field_id, result_field_key, table_name, column_name, display_text, field_type_id, activated, link_url, link_label) (values
            (1, 'sitename', 'tbl_sites', 'tbl_sites.site_name', 'Site name', 'single_item', true, NULL, NULL),
            (2, 'record_type', 'tbl_record_types', 'tbl_record_types.record_type_name', 'Record type(s)', 'text_agg_item', true, NULL, NULL),
            (3, 'analysis_entities', 'tbl_analysis_entities', 'tbl_analysis_entities.analysis_entity_id', 'Filtered records', 'single_item', true, NULL, NULL),
            (4, 'site_link', 'tbl_sites', 'tbl_sites.site_id', 'Full report', 'link_item', true, 'api/report/show_site_details.php?site_id', 'Show site report'),
            (5, 'site_link_filtered', 'tbl_sites', 'tbl_sites.site_id', 'Filtered report', 'link_item', true, 'api/report/show_site_details.php?site_id', 'Show filtered report'),
            (6, 'aggregate_all_filtered', 'tbl_aggregate_samples', '''Aggregated''::text', 'Filtered report', 'link_item_filtered', true, 'api/report/show_details_all_levels.php?level', NULL),
            (7, 'sample_group_link', 'tbl_sample_groups', 'tbl_sample_groups.sample_group_id', 'Full report', 'link_item', true, 'api/report/show_sample_group_details.php?sample_group_id', NULL),
            (8, 'sample_group_link_filtered', 'tbl_sample_groups', 'tbl_sample_groups.sample_group_id', 'Filtered report', 'link_item', true, 'api/report/show_sample_group_details.php?sample_group_id', NULL),
            (9, 'abundance', 'tbl_abundances', 'tbl_abundances.abundance', 'number of taxon_id', 'single_item', true, NULL, NULL),
            (10, 'taxon_id', 'tbl_abundances', 'tbl_abundances.taxon_id', 'Taxon id  (specie)', 'single_item', true, NULL, NULL),
            (11, 'dataset', 'tbl_datasets', 'tbl_datasets.dataset_name', 'Dataset', 'single_item', true, NULL, NULL),
            (12, 'dataset_link', 'tbl_datasets', 'tbl_datasets.dataset_id', 'Dataset details', 'single_item', true, 'client/show_dataset_details.php?dataset_id', NULL),
            (13, 'dataset_link_filtered', 'tbl_datasets', 'tbl_datasets.dataset_id', 'Filtered report', 'single_item', true, 'client/show_dataset_details.php?dataset_id', NULL),
            (14, 'sample_group', 'tbl_sample_groups', 'tbl_sample_groups.sample_group_name', 'Sample group', 'single_item', true, NULL, NULL),
            (15, 'methods', 'tbl_methods', 'tbl_methods.method_name', 'Method', 'single_item', true, NULL, NULL),
            (18, 'category_id', NULL, 'category_id', 'Site ID', 'single_item', true, NULL, NULL),
            (19, 'category_name', NULL, 'category_name', 'Site Name', 'single_item', true, NULL, NULL),
            (20, 'latitude_dd', NULL, 'latitude_dd', 'Latitude (dd)', 'single_item', true, NULL, NULL),
            (21, 'longitude_dd', NULL, 'longitude_dd', 'Longitude (dd)', 'single_item', true, NULL, NULL)
        ) on conflict (result_field_id) do update
            set result_field_key = excluded.result_field_key,
                table_name = excluded.table_name,
                column_name = excluded.column_name,
                display_text = excluded.display_text,
                field_type_id = excluded.field_type_id,
                activated = excluded.activated,
                link_url = excluded.link_url,
                link_label = excluded.link_label;

       insert into facet.result_aggregate_field (aggregate_field_id, aggregate_id, result_field_id, field_type_id, sequence_id) (values
            (4, 1, 1, 'single_item', 1),
            (5, 1, 2, 'text_agg_item', 2),
            (8, 1, 3, 'count_item', 3),
            (10, 1, 4, 'link_item', 4),
            (16, 1, 5, 'link_item_filtered', 5),
            (13, 1, 1, 'sort_item', 99),
            (15, 2, 6, 'link_item_filtered', 1),
            (7, 2, 3, 'count_item', 2),
            (1, 3, 1, 'single_item', 1),
            (2, 3, 14, 'single_item', 2),
            (3, 3, 2, 'single_item', 3),
            (6, 3, 3, 'count_item', 4),
            (9, 3, 7, 'link_item', 5),
            (14, 3, 8, 'link_item_filtered', 6),
            (11, 3, 1, 'sort_item', 99),
            (12, 3, 14, 'sort_item', 99),
            (23, 4, 18, 'single_item', 1),
            (24, 4, 19, 'single_item', 2),
            (21, 4, 20, 'single_item', 3),
            (22, 4, 21, 'single_item', 4)
        ) on conflict (aggregate_field_id) do update
            set aggregate_id = excluded.aggregate_id,
                result_field_id = excluded.result_field_id,
                field_type_id = excluded.field_type_id,
                sequence_id = excluded.sequence_id;

       insert into facet.result_view_type (view_type_id, view_name, is_cachable) (values
            ('tabular', 'Tabular', true),
            ('map', 'Map', false)
        ) on conflict (view_type_id) do update
            set view_name = excluded.view_name,
                is_cachable = excluded.is_cachable;

        insert into facet.view_state (view_state_key, view_state_data, create_time) (values
            ('roger', 'mähler', '2018-04-24 16:08:45.620597+02'),
            ('humlab', 'roger mähler', '2018-04-24 16:13:07.975984+02')
        ) on conflict do nothing;

   exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;



begin;
do $$
declare s_facets text;
declare j_facets jsonb;
begin

    begin

        set search_path = facet, pg_catalog;
        set default_with_oids = false;
        set statement_timeout = 0;
        set lock_timeout = 0;
        set client_encoding = 'UTF8';
        set standard_conforming_strings = on;
        set check_function_bodies = false;
        set client_min_messages = warning;

        if current_database() not like 'sead_staging%' then
            raise exception 'This script must be run in sead_staging!';
        end if;

		s_facets = $facets$

[{
	"facet_id": 1,
	"facet_code": "result_facet",
	"display_title": "Analysis entities",
	"description": "Analysis entities",
	"facet_group_id":"99",
	"facet_type_id": 1,
	"category_id_expr": "tbl_analysis_entities.analysis_entity_id",
	"category_name_expr": "tbl_physical_samples.sample_name||' '||tbl_datasets.dataset_name",
	"sort_expr": "tbl_datasets.dataset_name",
	"is_applicable": false,
	"is_default": false,
	"aggregate_type": "count",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": null,
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "tbl_analysis_entities",
		"udf_call_arguments": null,
		"alias":  null
	},
	{
		"sequence_id": 2,
		"table_name": "tbl_physical_samples",
		"udf_call_arguments": null,
		"alias":  null
	},
	{
		"sequence_id": 3,
		"table_name": "tbl_datasets",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [  ]
}, {
	"facet_id": 9,
	"facet_code": "map_result",
	"display_title": "Site",
	"description": "Site",
	"facet_group_id":"99",
	"facet_type_id": 1,
	"category_id_expr": "tbl_sites.site_id",
	"category_name_expr": "tbl_sites.site_name",
	"sort_expr": "tbl_sites.site_name",
	"is_applicable": false,
	"is_default": false,
	"aggregate_type": "count",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "tbl_sites",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [  ]
}, {
	"facet_id": 40,
	"facet_code": "result_facet_dataset",
	"display_title": "Datasets",
	"description": "Datasets",
	"facet_group_id":"99",
	"facet_type_id": 1,
	"category_id_expr": "tbl_datasets.dataset_id",
	"category_name_expr": "tbl_datasets.dataset_name",
	"sort_expr": "tbl_datasets.dataset_name",
	"is_applicable": false,
	"is_default": false,
	"aggregate_type": "count",
	"aggregate_title": "Number of datasets",
	"aggregate_facet_code": null,
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "tbl_datasets",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [  ]
}, {
    "facet_id": 19,
	"facet_code": "sites_helper",
	"display_title": "Site",
	"description": "Report helper",
	"facet_group_id":"2",
	"facet_type_id": 1,
	"category_id_expr": "tbl_sites.site_id",
	"category_name_expr": "tbl_sites.site_name",
	"sort_expr": "tbl_sites.site_name",
	"is_applicable": false,
	"is_default": true,
	"aggregate_type": "count",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "tbl_sites",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [  ]
}, {
	"facet_id": 32,
	"facet_code": "abundances_all_helper",
	"display_title": "Abundances",
	"description": "Abundances",
	"facet_group_id":"4",
	"facet_type_id": 2,
	"category_id_expr": "facet.view_abundance.abundance",
	"category_name_expr": "facet.view_abundance.abundance",
	"sort_expr": "facet.view_abundance.abundance",
	"is_applicable": false,
	"is_default": false,
	"aggregate_type": "",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "facet.view_abundance",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [
	{
		"clause": "facet.view_abundance.abundance is not null"
	} ]
}, {
	"facet_id": 3,
	"facet_code": "tbl_denormalized_measured_values_33_0",
	"display_title": "MS ",
	"description": "MS ",
	"facet_group_id":"5",
	"facet_type_id": 2,
	"category_id_expr": "method_values_33.measured_value",
	"category_name_expr": "method_values_33.measured_value",
	"sort_expr": "method_values_33.measured_value",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "facet.method_measured_values(33,0)",
		"udf_call_arguments": null,
		"alias":  "method_values_33"
	} ],
	"clauses": [  ]
}, {
	"facet_id": 4,
	"facet_code": "tbl_denormalized_measured_values_33_82",
	"display_title": "MS Heating 550",
	"description": "MS Heating 550",
	"facet_group_id":"5",
	"facet_type_id": 2,
	"category_id_expr": "method_values_33_82.measured_value",
	"category_name_expr": "method_values_33_82.measured_value",
	"sort_expr": "method_values_33_82.measured_value",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "facet.method_measured_values(33,82)",
		"udf_call_arguments": null,
		"alias":  "method_values_33_82"
	} ],
	"clauses": [  ]
}, {
	"facet_id": 5,
	"facet_code": "tbl_denormalized_measured_values_32",
	"display_title": "LOI",
	"description": "Loss of ignition",
	"facet_group_id":"5",
	"facet_type_id": 2,
	"category_id_expr": "method_values_32.measured_value",
	"category_name_expr": "method_values_32.measured_value",
	"sort_expr": "method_values_32.measured_value",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "facet.method_measured_values(32,0)",
		"udf_call_arguments": null,
		"alias":  "method_values_32"
	} ],
	"clauses": [  ]
}, {
	"facet_id": 6,
	"facet_code": "tbl_denormalized_measured_values_37",
	"display_title": "P° ",
	"description": "P°",
	"facet_group_id":"5",
	"facet_type_id": 2,
	"category_id_expr": "method_values_37.measured_value",
	"category_name_expr": "method_values_37.measured_value",
	"sort_expr": "method_values_37.measured_value",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "facet.method_measured_values(37,0)",
		"udf_call_arguments": null,
		"alias":  "method_values_37"
	} ],
	"clauses": [  ]
}, {
	"facet_id": 10,
	"facet_code": "geochronology",
	"display_title": "Geochronology",
	"description": "Sample ages as retrieved through absolute methods such as radiocarbon dating or other radiometric methods (in method based years before present - e.g. 14C years)",
	"facet_group_id":"2",
	"facet_type_id": 2,
	"category_id_expr": "tbl_geochronology.age",
	"category_name_expr": "tbl_geochronology.age",
	"sort_expr": "tbl_geochronology.age",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "tbl_geochronology",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [  ]
}, {
	"facet_id": 11,
	"facet_code": "relative_age_name",
	"display_title": "Time periods",
	"description": "Age of sample as defined by association with a (often regionally specific) cultural or geological period (in years before present)",
	"facet_group_id":"2",
	"facet_type_id": 1,
	"category_id_expr": "tbl_relative_ages.relative_age_id",
	"category_name_expr": "tbl_relative_ages.relative_age_name",
	"sort_expr": "tbl_relative_ages.relative_age_name",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "count",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "tbl_relative_ages",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [  ]
}, {
	"facet_id": 12,
	"facet_code": "record_types",
	"display_title": "Proxy types",
	"description": "Proxy types",
	"facet_group_id":"1",
	"facet_type_id": 1,
	"category_id_expr": "tbl_record_types.record_type_id",
	"category_name_expr": "tbl_record_types.record_type_name",
	"sort_expr": "tbl_record_types.record_type_name",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "count",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "tbl_record_types",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [  ]
}, {
	"facet_id": 13,
	"facet_code": "sample_groups",
	"display_title": "Sample group",
	"description": "A collection of samples, usually defined by the excavator or collector",
	"facet_group_id":"2",
	"facet_type_id": 1,
	"category_id_expr": "tbl_sample_groups.sample_group_id",
	"category_name_expr": "tbl_sample_groups.sample_group_name",
	"sort_expr": "tbl_sample_groups.sample_group_name",
	"is_applicable": true,
	"is_default": true,
	"aggregate_type": "count",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "tbl_sample_groups",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [  ]
}, {
	"facet_id": 18,
	"facet_code": "sites",
	"display_title": "Site",
	"description": "General name for the excavation or sampling location",
	"facet_group_id":"2",
	"facet_type_id": 1,
	"category_id_expr": "tbl_sites.site_id",
	"category_name_expr": "tbl_sites.site_name",
	"sort_expr": "tbl_sites.site_name",
	"is_applicable": true,
	"is_default": true,
	"aggregate_type": "count",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "tbl_sites",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [  ]
}, {
	"facet_id": 21,
	"facet_code": "country",
	"display_title": "Country",
	"description": "The name of the country, at the time of collection, in which the samples were collected",
	"facet_group_id":"2",
	"facet_type_id": 1,
	"category_id_expr": "countries.location_id",
	"category_name_expr": "countries.location_name ",
	"sort_expr": "countries.location_name",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "count",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "tbl_locations",
		"udf_call_arguments": null,
		"alias":  "countries"
	},
	{
		"sequence_id": 2,
		"table_name": "tbl_site_locations",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [
	{
		"clause": "countries.location_type_id=1"
	} ]
}, {
	"facet_id": 22,
	"facet_code": "ecocode",
	"display_title": "Eco code",
	"description": "Ecological category (trait) or cultural relevance of organisms based on a classification system",
	"facet_group_id":"4",
	"facet_type_id": 1,
	"category_id_expr": "tbl_ecocode_definitions.ecocode_definition_id",
	"category_name_expr": "tbl_ecocode_definitions.name",
	"sort_expr": "tbl_ecocode_definitions.name",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "count",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "tbl_ecocode_definitions",
		"udf_call_arguments": null,
		"alias":  null
	},
	{
		"sequence_id": 2,
		"table_name": "tbl_ecocode_definitions",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [  ]
}, {
	"facet_id": 23,
	"facet_code": "family",
	"display_title": "Family",
	"description": "Taxonomic family",
	"facet_group_id":"6",
	"facet_type_id": 1,
	"category_id_expr": "tbl_taxa_tree_families.family_id",
	"category_name_expr": "tbl_taxa_tree_families.family_name ",
	"sort_expr": "tbl_taxa_tree_families.family_name ",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "count",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "tbl_taxa_tree_families",
		"udf_call_arguments": null,
		"alias":  null
	},
	{
		"sequence_id": 2,
		"table_name": "tbl_taxa_tree_families",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [  ]
}, {
	"facet_id": 24,
	"facet_code": "genus",
	"display_title": "Genus",
	"description": "Taxonomic genus (under family)",
	"facet_group_id":"6",
	"facet_type_id": 1,
	"category_id_expr": "tbl_taxa_tree_genera.genus_id",
	"category_name_expr": "tbl_taxa_tree_genera.genus_name",
	"sort_expr": "tbl_taxa_tree_genera.genus_name",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "count",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "tbl_taxa_tree_genera",
		"udf_call_arguments": null,
		"alias":  null
	},
	{
		"sequence_id": 2,
		"table_name": "tbl_taxa_tree_genera",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [  ]
}, {
	"facet_id": 25,
	"facet_code": "species",
	"display_title": "Taxa",
	"description": "Taxonomic species (under genus)",
	"facet_group_id":"6",
	"facet_type_id": 1,
	"category_id_expr": "tbl_taxa_tree_master.taxon_id",
	"category_name_expr": "concat_ws(' ', tbl_taxa_tree_genera.genus_name, tbl_taxa_tree_master.species, tbl_taxa_tree_authors.author_name)",
	"sort_expr": "tbl_taxa_tree_genera.genus_name||' '||tbl_taxa_tree_master.species",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "sum",
	"aggregate_title": "sum of Abundance",
	"aggregate_facet_code": "abundances_all_helper",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "tbl_taxa_tree_master",
		"udf_call_arguments": null,
		"alias":  null
	},
	{
		"sequence_id": 2,
		"table_name": "tbl_taxa_tree_genera",
		"udf_call_arguments": null,
		"alias":  null
	},
	{
		"sequence_id": 3,
		"table_name": "tbl_taxa_tree_authors",
		"udf_call_arguments": null,
		"alias":  null
	},
	{
		"sequence_id": 4,
		"table_name": "tbl_sites",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [
	{
		"clause": "tbl_sites.site_id is not null"
	} ]
}, {
	"facet_id": 28,
	"facet_code": "species_author",
	"display_title": "Author",
	"description": "Authority of the taxonomic name (not used for all species)",
	"facet_group_id":"6",
	"facet_type_id": 1,
	"category_id_expr": "tbl_taxa_tree_authors.author_id ",
	"category_name_expr": "tbl_taxa_tree_authors.author_name ",
	"sort_expr": "tbl_taxa_tree_authors.author_name ",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "count",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "tbl_taxa_tree_authors",
		"udf_call_arguments": null,
		"alias":  null
	},
	{
		"sequence_id": 2,
		"table_name": "tbl_taxa_tree_authors",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [  ]
}, {
	"facet_id": 29,
	"facet_code": "feature_type",
	"display_title": "Feature type",
	"description": "Feature type",
	"facet_group_id":"1",
	"facet_type_id": 1,
	"category_id_expr": "tbl_feature_types.feature_type_id ",
	"category_name_expr": "tbl_feature_types.feature_type_name",
	"sort_expr": "tbl_feature_types.feature_type_name",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "count",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "tbl_feature_types",
		"udf_call_arguments": null,
		"alias":  null
	},
	{
		"sequence_id": 2,
		"table_name": "tbl_physical_sample_features",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [  ]
}, {
	"facet_id": 30,
	"facet_code": "ecocode_system",
	"display_title": "Eco code system",
	"description": "Ecological or cultural organism classification system (which groups items in the ecological/cultural category filter)",
	"facet_group_id":"4",
	"facet_type_id": 1,
	"category_id_expr": "tbl_ecocode_systems.ecocode_system_id ",
	"category_name_expr": "tbl_ecocode_systems.name",
	"sort_expr": "tbl_ecocode_systems.definition",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "count",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "tbl_ecocode_systems",
		"udf_call_arguments": null,
		"alias":  null
	},
	{
		"sequence_id": 2,
		"table_name": "tbl_ecocode_systems",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [  ]
}, {
	"facet_id": 31,
	"facet_code": "abundance_classification",
	"display_title": "abundance classification",
	"description": "abundance classification",
	"facet_group_id":"4",
	"facet_type_id": 1,
	"category_id_expr": "facet.view_abundance.elements_part_mod ",
	"category_name_expr": "facet.view_abundance.elements_part_mod ",
	"sort_expr": "facet.view_abundance.elements_part_mod ",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "count",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "facet.view_abundance",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [  ]
}, {
	"facet_id": 33,
	"facet_code": "abundances_all",
	"display_title": "Abundances",
	"description": "Abundances",
	"facet_group_id":"4",
	"facet_type_id": 2,
	"category_id_expr": "facet.view_abundance.abundance",
	"category_name_expr": "facet.view_abundance.abundance",
	"sort_expr": "facet.view_abundance.abundance",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "facet.view_abundance",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [
	{
		"clause": "facet.view_abundance.abundance is not null"
	} ]
}, {
	"facet_id": 34,
	"facet_code": "activeseason",
	"display_title": "Seasons",
	"description": "Seasons",
	"facet_group_id":"2",
	"facet_type_id": 1,
	"category_id_expr": "tbl_seasons.season_id",
	"category_name_expr": "tbl_seasons.season_name",
	"sort_expr": "tbl_seasons.season_type ",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "count",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "tbl_seasons",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [  ]
}, {
	"facet_id": 35,
	"facet_code": "tbl_biblio_modern",
	"display_title": "Bibligraphy modern",
	"description": "Bibligraphy modern",
	"facet_group_id":"1",
	"facet_type_id": 1,
	"category_id_expr": "facet.view_taxa_biblio.biblio_id",
	"category_name_expr": "tbl_biblio.title||'  '||tbl_biblio.authors ",
	"sort_expr": "tbl_biblio.authors",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "count",
	"aggregate_title": "count of species",
	"aggregate_facet_code": "sites_helper",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "facet.view_taxa_biblio",
		"udf_call_arguments": null,
		"alias":  null
	},
	{
		"sequence_id": 2,
		"table_name": "tbl_biblio",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [  ]
}, {
	"facet_id": 36,
	"facet_code": "tbl_biblio_sample_groups",
	"display_title": "Bibligraphy sites/Samplegroups",
	"description": "Bibligraphy sites/Samplegroups",
	"facet_group_id":"1",
	"facet_type_id": 1,
	"category_id_expr": "tbl_biblio.biblio_id",
	"category_name_expr": "tbl_biblio.title||'  '||tbl_biblio.authors",
	"sort_expr": "tbl_biblio.authors",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "count",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "tbl_biblio",
		"udf_call_arguments": null,
		"alias":  null
	},
	{
		"sequence_id": 2,
		"table_name": "facet.view_sample_group_references",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [
	{
		"clause": "facet.view_sample_group_references.biblio_id is not null"
	} ]
}, {
	"facet_id": 37,
	"facet_code": "tbl_biblio_sites",
	"display_title": "Bibligraphy sites",
	"description": "Bibligraphy sites",
	"facet_group_id":"1",
	"facet_type_id": 1,
	"category_id_expr": "tbl_biblio.biblio_id",
	"category_name_expr": "tbl_biblio.title||'  '||tbl_biblio.authors",
	"sort_expr": "tbl_biblio.authors",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "count",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
	{
		"sequence_id": 1,
		"table_name": "tbl_biblio",
		"udf_call_arguments": null,
		"alias":  null
	},
	{
		"sequence_id": 2,
		"table_name": "facet.view_site_references",
		"udf_call_arguments": null,
		"alias":  null
	} ],
	"clauses": [
	{
		"clause": "facet.view_site_references.biblio_id is not null"
	} ]
}, {
	"facet_id": 38,
	"facet_code": "dataset_master",
	"display_title": "Master datasets",
	"description": "Master datasets",
	"facet_group_id": "2",
	"facet_type_id": 1,
	"category_id_expr": "tbl_dataset_masters.master_set_id ",
	"category_name_expr": "tbl_dataset_masters.master_name",
	"sort_expr": "tbl_dataset_masters.master_name",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "count",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
    	{
    		"sequence_id": 1,
    		"table_name": "tbl_dataset_masters",
    		"udf_call_arguments": null,
    		"alias":  null
    	}
    ],
	"clauses": [  ]
}, {
	"facet_id": 39,
	"facet_code": "dataset_methods",
	"display_title": "Dataset methods",
	"description": "Dataset methods",
	"facet_group_id": "2",
	"facet_type_id": 1,
	"category_id_expr": "tbl_methods.method_id ",
	"category_name_expr": "tbl_methods.method_name",
	"sort_expr": "tbl_methods.method_name",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "count",
	"aggregate_title": "Number of datasets",
	"aggregate_facet_code": "result_facet_dataset",
	"tables": [
    	{
    		"sequence_id": 1,
    		"table_name": "tbl_dataset_masters",
    		"udf_call_arguments": null,
    		"alias":  null
    	},
    	{
    		"sequence_id": 2,
    		"table_name": "tbl_datasets",
    		"udf_call_arguments": null,
    		"alias":  null
    	}
    ],
	"clauses": [  ]
}, {
	"facet_id": 41,
	"facet_code": "region",
	"display_title": "Region",
	"description": "Region",
	"facet_group_id": "2",
	"facet_type_id": 1,
	"category_id_expr": "tbl_locations.location_id ",
	"category_name_expr": "tbl_locations.location_name || '  ' || tbl_sites.site_name",
	"sort_expr": "tbl_locations.location_name",
	"is_applicable": true,
	"is_default": false,
	"aggregate_type": "count",
	"aggregate_title": "Number of samples",
	"aggregate_facet_code": "result_facet",
	"tables": [
    	{
    		"sequence_id": 1,
    		"table_name": "tbl_locations",
    		"udf_call_arguments": null,
    		"alias":  "null"
    	},
    	{
    		"sequence_id": 2,
    		"table_name": "tbl_site_locations",
    		"udf_call_arguments": null,
    		"alias":  null
    	},
    	{
    		"sequence_id": 3,
    		"table_name": "tbl_sites",
    		"udf_call_arguments": null,
    		"alias":  null
    	}
    ],
	"clauses": [ {
		"clause": "tbl_locations.location_type_id in (2, 7, 14, 16, 18)"
	} ]
}
]

$facets$;

	j_facets = s_facets::jsonb;

	PERFORM facet.create_or_update_facet(v.facet::jsonb)
	from jsonb_array_elements(j_facets) as v(facet);

   exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
