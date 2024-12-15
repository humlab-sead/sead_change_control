-- Deploy subsystem: 20241127_DDL_CLEARINGHOUSE_IMPORT_TABLES

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-11-27
  Description   Helper view for Excel import
  Issue         https://github.com/humlab-sead/sead_change_control/issues/331
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin

	drop view if exists clearing_house.clearinghouse_import_columns;
	drop view if exists clearing_house.clearinghouse_import_tables;
	
    create or replace view clearing_house.clearinghouse_import_tables as
        with table_alias(table_name, excel_sheet) as(values 
                ('tbl_analysis_entity_prep_methods', 'tbl_a_e_prep_method'),
                ('tbl_sample_group_description_types', 'tbl_s_g_description_types'),
                ('tbl_sample_group_description_type_sampling_contexts', 'tbl_s_g_d_t_sampling_contexts'),
                ('tbl_sample_group_sampling_contexts', 'tbl_s_g_sampling_contexts'),
                ('tbl_sample_location_type_sampling_contexts', 'tbl_s_l_t_sampling_contexts')
            ), 
            deprecated_tables(table_name) as (values
                ('tbl_ceramics_measurements'),
                ('tbl_chron_control_types'),
                ('tbl_chron_controls'),
                ('tbl_dendro_measurements'),
                ('tbl_error_uncertainties'),
                ('tbl_season_or_qualifier'),
                ('tbl_tephra_dates'),
                ('tbl_tephra_refs'),
                ('tbl_tephras')
            ),
            ignored_tables(table_name) as (values
                ('bibliography_references'), -- has a compound key
                ('tbl_updates_log'),
                ('spatial_ref_sys')
            ),
            lookup_tables(table_name, table_type) as (values
                ('tbl_value_classes', 'lookup'),
                ('tbl_value_qualifier_symbols', 'metadata'),
                ('tbl_value_qualifiers', 'metadata'),
                ('tbl_value_type_items', 'lookup'),
                ('tbl_value_types', 'lookup'),
                ('tbl_abundance_elements', 'lookup'),
                ('tbl_activity_types', 'lookup'),
                ('tbl_age_types', 'lookup'),
                ('tbl_aggregate_datasets', 'unknown'),
                ('tbl_aggregate_order_types', 'lookup'),
                ('tbl_aggregate_sample_ages', 'unknown'),
                ('tbl_alt_ref_types', 'lookup'),
                ('tbl_biblio', 'metadata'),
                ('tbl_ceramics_lookup', 'lookup'),
                ('tbl_colours', 'lookup'),
                ('tbl_contact_types', 'lookup'),
                ('tbl_contacts', 'metadata'),
                ('tbl_coordinate_method_dimensions', 'metadata'),
                ('tbl_data_type_groups', 'lookup'),
                ('tbl_data_types', 'lookup'),
                ('tbl_dataset_submission_types', 'lookup'),
                ('tbl_dating_labs', 'metadata'),
                ('tbl_dating_uncertainty', 'lookup'),
                ('tbl_dendro_lookup', 'lookup'),
                ('tbl_dimensions', 'lookup'),
                ('tbl_feature_types', 'lookup'),
                ('tbl_horizons', 'lookup'),
                ('tbl_identification_levels', 'lookup'),
                ('tbl_image_types', 'lookup'),
                ('tbl_imported_taxa_replacements', 'unknown'),
                ('tbl_isotope_standards', 'lookup'),
                ('tbl_isotope_types', 'lookup'),
                ('tbl_isotope_value_specifiers', 'lookup'),
                ('tbl_languages', 'lookup'),
                ('tbl_lithology', 'lookup'),
                ('tbl_location_types', 'lookup'),
                ('tbl_locations', 'metadata'),
                ('tbl_method_groups', 'metadata'),
                ('tbl_methods', 'metadata'),
                ('tbl_modification_types', 'lookup'),
                ('tbl_project_stages', 'metadata'),
                ('tbl_project_types', 'lookup'),
                ('tbl_rdb_codes', 'metadata'),
                ('tbl_rdb_systems', 'metadata'),
                ('tbl_rdb', 'metadata'),
                ('tbl_record_types', 'lookup'),
                ('tbl_relative_age_refs', 'metadata'),
                ('tbl_relative_age_types', 'lookup'),
                ('tbl_relative_ages', 'lookup'),
                ('tbl_sample_description_sample_group_contexts', 'unknown'),
                ('tbl_sample_description_types', 'lookup'),
                ('tbl_sample_group_description_type_sampling_contexts', 'unknown'),
                ('tbl_sample_group_description_types', 'lookup'),
                ('tbl_sample_group_sampling_contexts', 'unknown'),
                ('tbl_sample_location_type_sampling_contexts', 'unknown'),
                ('tbl_sample_location_types', 'lookup'),
                ('tbl_sample_types', 'lookup'),
                ('tbl_season_types', 'lookup'),
                ('tbl_seasons', 'lookup'),
                ('tbl_site_preservation_status', 'lookup'),
                ('tbl_species_association_types', 'lookup'),
                ('tbl_species_associations', 'metadata'),
                ('tbl_taxa_common_names', 'metadata'),
                ('tbl_taxa_images', 'metadata'),
                ('tbl_taxa_measured_attributes', 'metadata'),
                ('tbl_taxa_reference_specimens', 'metadata'),
                ('tbl_taxa_seasonality', 'metadata'),
                ('tbl_taxa_synonyms', 'metadata'),
                ('tbl_taxa_tree_authors', 'metadata'),
                ('tbl_taxa_tree_families', 'metadata'),
                ('tbl_taxa_tree_genera', 'metadata'),
                ('tbl_taxa_tree_master', 'metadata'),
                ('tbl_taxa_tree_orders', 'metadata'),
                ('tbl_taxonomic_order_biblio', 'metadata'),
                ('tbl_taxonomic_order_systems', 'metadata'),
                ('tbl_taxonomic_order', 'metadata'),
                ('tbl_taxonomy_notes', 'metadata'),
                ('tbl_temperatures', 'metadata'),
                ('tbl_text_biology', 'metadata'),
                ('tbl_text_distribution', 'metadata'),
                ('tbl_text_identification_keys', 'metadata'),
                ('tbl_units', 'lookup'),
                ('tbl_years_types', 'lookup')
            ), data_tables(table_name, table_type) as (values
                ('tbl_analysis_boolean_values', 'data'),
                ('tbl_analysis_categorical_values', 'data'),
                ('tbl_analysis_dating_ranges', 'data'),
                ('tbl_analysis_integer_ranges', 'data'),
                ('tbl_analysis_integer_values', 'data'),
                ('tbl_analysis_numerical_ranges', 'data'),
                ('tbl_analysis_numerical_values', 'data'),
                ('tbl_analysis_value_dimensions', 'data'),
                ('tbl_analysis_value_taxon_counts', 'data'),
                ('tbl_analysis_values', 'data'),
                ('tbl_abundance_ident_levels', 'data'),
                ('tbl_abundance_modifications', 'data'),
                ('tbl_abundances', 'data'),
                ('tbl_aggregate_samples', 'data'),
                ('tbl_analysis_entities', 'data'),
                ('tbl_analysis_entity_ages', 'data'),
                ('tbl_analysis_entity_dimensions', 'data'),
                ('tbl_analysis_entity_prep_methods', 'data'), 
                ('tbl_ceramics', 'data'),
                ('tbl_chronologies', 'data'),
                ('tbl_dataset_contacts', 'data'),
                ('tbl_dataset_masters', 'data'),
                ('tbl_dataset_methods', 'data'),
                ('tbl_dataset_submissions', 'data'),
                ('tbl_datasets', 'data'),
                ('tbl_dating_material', 'data'),
                ('tbl_dendro_date_notes', 'data'),
                ('tbl_dendro_dates', 'data'),
                ('tbl_dendro', 'data'),
                ('tbl_ecocode_definitions', 'data'),
                ('tbl_ecocode_groups', 'data'),
                ('tbl_ecocode_systems', 'data'),
                ('tbl_ecocodes', 'data'),
                ('tbl_features', 'data'),
                ('tbl_geochron_refs', 'data'),
                ('tbl_geochronology', 'data'),
                ('tbl_isotope_measurements', 'data'),
                ('tbl_isotopes', 'data'),
                ('tbl_mcr_names', 'data'),
                ('tbl_mcr_summary_data', 'data'),
                ('tbl_mcrdata_birmbeetledat', 'data'),
                ('tbl_measured_value_dimensions', 'data'),
                ('tbl_measured_values', 'data'),
                ('tbl_physical_sample_features', 'data'),
                ('tbl_physical_samples', 'data'),
                ('tbl_projects', 'data'),
                ('tbl_relative_dates', 'data'),
                ('tbl_sample_alt_refs', 'data'),
                ('tbl_sample_colours', 'data'),
                ('tbl_sample_coordinates', 'data'),
                ('tbl_sample_descriptions', 'data'),
                ('tbl_sample_dimensions', 'data'),
                ('tbl_sample_group_coordinates', 'data'),
                ('tbl_sample_group_descriptions', 'data'),
                ('tbl_sample_group_dimensions', 'data'),
                ('tbl_sample_group_images', 'data'),
                ('tbl_sample_group_notes', 'data'),
                ('tbl_sample_group_references', 'data'),
                ('tbl_sample_groups', 'data'),
                ('tbl_sample_horizons', 'data'),
                ('tbl_sample_images', 'data'),
                ('tbl_sample_locations', 'data'),
                ('tbl_sample_notes', 'data'),
                ('tbl_site_images', 'data'),
                ('tbl_site_locations', 'data'),
                ('tbl_site_natgridrefs', 'data'),
                ('tbl_site_other_records', 'data'),
                ('tbl_site_references', 'data'),
                ('tbl_sites', 'data')
            ),
            import_tables as (
                select 
                    t.table_name,
                    t.column_name as pk_name,
                    replace(initcap(table_name), '_', '') as java_class,
                    coalesce(table_alias.excel_sheet, t.table_name) as excel_sheet,
                    case
                        when lookup_tables.table_name is not null
                            then true else false
                    end as is_lookup,
                    data_tables.table_name is null and lookup_tables.table_name is null as is_unknown
                from sead_utility.table_columns t
                left join deprecated_tables using (table_name)
                left join ignored_tables using (table_name)
                left join table_alias using (table_name)
                left join lookup_tables using (table_name)
                left join data_tables using (table_name)
                where t.table_schema = 'public'
                  and ignored_tables.table_name is null
                  and deprecated_tables.table_name is null
                  and is_pk = 'YES'
        )  select * -- format('(''%s'', ''XXX''),', table_name)
        from import_tables;

    create or replace view clearing_house.clearinghouse_import_columns as
        select
            table_name,
            column_name,
            sead_utility.underscore_to_pascal_case(column_name, TRUE) as xml_column_name,
            ordinal_position as position,
            data_type,
            coalesce(numeric_precision, 0) as numeric_precision,
            coalesce(numeric_scale, 0) as numeric_scale,
            coalesce(character_maximum_length, 0) as character_maximum_length,
            case when is_nullable = 'YES' then true else false end as is_nullable,
            case when is_pk = 'YES' then true else false end as is_pk,
            case when is_fk = 'YES' then true else false end as is_fk,
            coalesce(t.fk_table_name, '') as fk_table_name,
            coalesce(t.fk_column_name, '') as fk_column_name,
            case
                when is_fk = 'YES' then sead_utility.underscore_to_pascal_case(t.fk_table_name)
                else clearing_house.fn_postgresql_java_type(data_type)
            end as class_name
        from sead_utility.table_columns t
        join clearing_house.clearinghouse_import_tables using (table_name)
        where t.table_schema = 'public'
          and data_type not in ('numrange', 'int4range');
    
end $$;
commit;
