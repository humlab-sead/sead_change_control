
create index idx_biblio_id on public.tbl_sample_group_references(biblio_id);

create index idx_ecocode_groups_ecocode_system_id on public.tbl_ecocode_groups(ecocode_system_id);
create index idx_ecocode_groups_name on public.tbl_ecocode_groups("name");
create index idx_ecocode_systems_biblio_id on public.tbl_ecocode_systems(biblio_id);
create index idx_ecocode_systems_ecocode_group_id on public.tbl_ecocode_systems("name");

create index idx_languages_language_id on public.tbl_languages(language_id);

create index idx_sample_group_id on public.tbl_sample_group_references(sample_group_id);

create index idx_taxa_tree_authors_name on public.tbl_taxa_tree_authors(author_name);
create index idx_taxa_tree_families_name on public.tbl_taxa_tree_families(family_name);
create index idx_taxa_tree_families_order_id on public.tbl_taxa_tree_families(order_id);
create index idx_taxa_tree_genera_family_id on public.tbl_taxa_tree_genera(family_id);
create index idx_taxa_tree_genera_name on public.tbl_taxa_tree_genera(genus_name);
create index idx_taxa_tree_orders_order_id on public.tbl_taxa_tree_orders(order_id);

create index idx_taxonomic_order_biblio_biblio_id on public.tbl_taxonomic_order_biblio(biblio_id);
create index idx_taxonomic_order_biblio_taxonomic_order_biblio_id on public.tbl_taxonomic_order_biblio(taxonomic_order_biblio_id);
create index idx_taxonomic_order_biblio_taxonomic_order_system_id on public.tbl_taxonomic_order_biblio(taxonomic_order_system_id);
create index idx_taxonomic_order_systems_taxonomic_system_id on public.tbl_taxonomic_order_systems(taxonomic_order_system_id);
create index idx_taxonomic_order_taxon_id on public.tbl_taxonomic_order(taxon_id);
create index idx_taxonomic_order_taxonomic_code on public.tbl_taxonomic_order(taxonomic_code);
create index idx_taxonomic_order_taxonomic_order_id on public.tbl_taxonomic_order(taxonomic_order_id);
create index idx_taxonomic_order_taxonomic_system_id on public.tbl_taxonomic_order(taxonomic_order_system_id);

create index idx_analysis_entities_physical_sample_id on public.tbl_analysis_entities (physical_sample_id); -- 94507
create index idx_analysis_entities_dataset_id on public.tbl_analysis_entities (dataset_id); -- 94507
create index idx_measured_values_analysis_entity_id on public.tbl_measured_values (analysis_entity_id); -- 91617
create index idx_sample_coordinates_coordinate_method_dimension_id on public.tbl_sample_coordinates (coordinate_method_dimension_id); -- 56928
create index idx_sample_coordinates_physical_sample_id on public.tbl_sample_coordinates (physical_sample_id); -- 56928
create index idx_analysis_entity_prep_methods_analysis_entity_id on public.tbl_analysis_entity_prep_methods (analysis_entity_id); -- 34477
create index idx_analysis_entity_prep_methods_method_id on public.tbl_analysis_entity_prep_methods (method_id); -- 34477
create index idx_physical_samples_sample_group_id on public.tbl_physical_samples (sample_group_id); -- 25450
create index idx_physical_samples_alt_ref_type_id on public.tbl_physical_samples (alt_ref_type_id); -- 25450
create index idx_physical_samples_sample_type_id on public.tbl_physical_samples (sample_type_id); -- 25450
create index idx_taxa_tree_master_genus_id on public.tbl_taxa_tree_master (genus_id); -- 16664
create index idx_taxa_tree_master_author_id on public.tbl_taxa_tree_master (author_id); -- 16664
create index idx_ecocodes_taxon_id on public.tbl_ecocodes (taxon_id); -- 14362
create index idx_ecocodes_ecocode_definition_id on public.tbl_ecocodes (ecocode_definition_id); -- 14362
create index idx_sample_alt_refs_alt_ref_type_id on public.tbl_sample_alt_refs (alt_ref_type_id); -- 9787
create index idx_sample_alt_refs_physical_sample_id on public.tbl_sample_alt_refs (physical_sample_id); -- 9787
create index idx_abundances_taxon_id on public.tbl_abundances (taxon_id); -- 8403
create index idx_abundances_abundance_element_id on public.tbl_abundances (abundance_element_id); -- 8403
create index idx_abundances_analysis_entity_id on public.tbl_abundances (analysis_entity_id); -- 8403
create index idx_sample_horizons_physical_sample_id on public.tbl_sample_horizons (physical_sample_id); -- 7857
create index idx_sample_horizons_horizon_id on public.tbl_sample_horizons (horizon_id); -- 7857
create index idx_abundance_modifications_abundance_id on public.tbl_abundance_modifications (abundance_id); -- 7594
create index idx_abundance_modifications_modification_type_id on public.tbl_abundance_modifications (modification_type_id); -- 7594
create index idx_biblio_publication_type_id on public.tbl_biblio (publication_type_id); -- 5554
create index idx_biblio_collection_or_journal_id on public.tbl_biblio (collection_or_journal_id); -- 5554
create index idx_biblio_publisher_id on public.tbl_biblio (publisher_id); -- 5554
create index idx_sample_notes_physical_sample_id on public.tbl_sample_notes (physical_sample_id); -- 5357
create index idx_physical_sample_features_feature_id on public.tbl_physical_sample_features (feature_id); -- 4688
create index idx_physical_sample_features_physical_sample_id on public.tbl_physical_sample_features (physical_sample_id); -- 4688
create index idx_taxa_common_names_language_id on public.tbl_taxa_common_names (language_id); -- 4272
create index idx_taxa_common_names_taxon_id on public.tbl_taxa_common_names (taxon_id); -- 4272
create index idx_datasets_project_id on public.tbl_datasets (project_id); -- 2967
create index idx_datasets_method_id on public.tbl_datasets (method_id); -- 2967
create index idx_datasets_updated_dataset_id on public.tbl_datasets (updated_dataset_id); -- 2967
create index idx_datasets_master_set_id on public.tbl_datasets (master_set_id); -- 2967
create index idx_datasets_data_type_id on public.tbl_datasets (data_type_id); -- 2967
create index idx_datasets_biblio_id on public.tbl_datasets (biblio_id); -- 2967
create index idx_collections_or_journals_publisher_id on public.tbl_collections_or_journals (publisher_id); -- 2219
create index idx_site_locations_site_id on public.tbl_site_locations (site_id); -- 2114
create index idx_site_locations_location_id on public.tbl_site_locations (location_id); -- 2114
create index idx_features_feature_type_id on public.tbl_features (feature_type_id); -- 1742
create index idx_locations_location_type_id on public.tbl_locations (location_type_id); -- 1191

/*

with missing_keys as (
        with fk_actions (code, action) as ( values 
            ('a', 'error'),
            ('r', 'restrict'),
            ('c', 'cascade'),
            ('n', 'set null'),
            ('d', 'set default')
        ),
        fk_list as (
            select pg_constraint.oid as fkoid,
                conrelid,
                confrelid as parentid,
                conname,
                relname,
                nspname,
                fk_actions_update.action as update_action,
                fk_actions_delete.action as delete_action,
                conkey as key_cols
            from pg_constraint
                join pg_class on conrelid = pg_class.oid
                join pg_namespace on pg_class.relnamespace = pg_namespace.oid
                join fk_actions as fk_actions_update on confupdtype = fk_actions_update.code
                join fk_actions as fk_actions_delete on confdeltype = fk_actions_delete.code
            where contype = 'f'
        ),
        fk_attributes AS (
            select fkoid, conrelid, attname, attnum
            from fk_list
            join pg_attribute on conrelid = attrelid
            and attnum = any(key_cols)
            order by fkoid, attnum
        ),
        fk_cols_list AS (
            select fkoid, array_agg(attname) as cols_list
            from fk_attributes
            group by fkoid
        ),
        index_list AS (
            select indexrelid as indexid,
                pg_class.relname as indexname,
                indrelid,
                indkey,
                indpred is not null as has_predicate,
                pg_get_indexdef(indexrelid) as indexdef
            from pg_index
            join pg_class on indexrelid = pg_class.oid
            where indisvalid
        ),
        fk_index_match AS (
            select fk_list.*,
                indexid,
                indexname,
                indkey::int [] as indexatts,
                has_predicate,
                indexdef,
                array_length(key_cols, 1) as fk_colcount,
                array_length(indkey, 1) as index_colcount,
                round(pg_relation_size(conrelid) /(1024 ^ 2)::numeric) as table_mb,
                cols_list
            from fk_list
            join fk_cols_list using (fkoid)
            left outer join index_list on conrelid = indrelid
            and (indkey::int2 []) [0:(array_length(key_cols,1) -1)] @> key_cols
        ),
        fk_perfect_match AS (
            select fkoid
            from fk_index_match
            where (index_colcount - 1) <= fk_colcount
            and not has_predicate
            and indexdef LIKE '%USING btree%'
        ),
        fk_index_check AS (
            select 'no index' as issue, *, 1 as issue_sort
            from fk_index_match
            where indexid is null
            union all
            select 'questionable index' as issue, *, 2
            from fk_index_match
            where indexid is not null
            and fkoid not in ( select fkoid from fk_perfect_match )
        ),
        parent_table_stats AS (
            select fkoid,
                tabstats.relname as parent_name,
                (
                    n_tup_ins + n_tup_upd + n_tup_del + n_tup_hot_upd
                ) as parent_writes,
                round(pg_relation_size(parentid) /(1024 ^ 2)::numeric) as parent_mb
            from pg_stat_user_tables as tabstats
            join fk_list on relid = parentid
        ),
        fk_table_stats AS (
            select fkoid,
                (
                    n_tup_ins + n_tup_upd + n_tup_del + n_tup_hot_upd
                ) as writes,
                seq_scan as table_scans
            from pg_stat_user_tables as tabstats
            join fk_list on relid = conrelid
        )
        select nspname as schema_name,
            relname as table_name,
            conname as fk_name,
            issue,
            table_mb,
            writes,
            table_scans,
            parent_name,
            parent_mb,
            parent_writes,
            cols_list,
            indexdef
        from fk_index_check
            join parent_table_stats using (fkoid)
            join fk_table_stats using (fkoid)
        where true -- table_mb > 9
            --     and ( writes > 1000
            --         or parent_writes > 1000
            --         or parent_mb > 10 )
        order by issue_sort, table_mb desc, table_name, fk_name
) select format('create index idx_%1$s_%2$s on public.%1$s (%2$s); -- %3$s', missing_keys.table_name, cols_list[1], x.count), x.count
  from missing_keys
  join get_all_table_counts() x
    on x.schema_name = missing_keys.schema_name
   and x.table_name = missing_keys.table_name
   where missing_keys.schema_name = 'public'
   order by 2 desc


*/

-- create index idx_sample_groups_sampling_context_id on public.tbl_sample_groups (sampling_context_id); -- 931
-- create index idx_sample_groups_site_id on public.tbl_sample_groups (site_id); -- 931
-- create index idx_sample_groups_method_id on public.tbl_sample_groups (method_id); -- 931
-- create index idx_species_associations_biblio_id on public.tbl_species_associations (biblio_id); -- 856
-- create index idx_species_associations_association_type_id on public.tbl_species_associations (association_type_id); -- 856
-- create index idx_species_associations_taxon_id on public.tbl_species_associations (taxon_id); -- 856
-- create index idx_species_associations_taxon_id on public.tbl_species_associations (taxon_id); -- 856
-- create index idx_sample_dimensions_physical_sample_id on public.tbl_sample_dimensions (physical_sample_id); -- 681
-- create index idx_sample_dimensions_method_id on public.tbl_sample_dimensions (method_id); -- 681
-- create index idx_sample_dimensions_dimension_id on public.tbl_sample_dimensions (dimension_id); -- 681
-- create index idx_abundance_ident_levels_abundance_id on public.tbl_abundance_ident_levels (abundance_id); -- 480
-- create index idx_abundance_ident_levels_identification_level_id on public.tbl_abundance_ident_levels (identification_level_id); -- 480
-- create index idx_relative_ages_location_id on public.tbl_relative_ages (location_id); -- 275
-- create index idx_relative_ages_relative_age_type_id on public.tbl_relative_ages (relative_age_type_id); -- 275
-- create index idx_dating_labs_contact_id on public.tbl_dating_labs (contact_id); -- 227
-- create index idx_ecocode_definitions_ecocode_group_id on public.tbl_ecocode_definitions (ecocode_group_id); -- 136
-- create index idx_horizons_method_id on public.tbl_horizons (method_id); -- 122
-- create index idx_methods_unit_id on public.tbl_methods (unit_id); -- 114
-- create index idx_methods_biblio_id on public.tbl_methods (biblio_id); -- 114
-- create index idx_methods_method_group_id on public.tbl_methods (method_group_id); -- 114
-- create index idx_methods_record_type_id on public.tbl_methods (record_type_id); -- 114
-- create index idx_site_references_biblio_id on public.tbl_site_references (biblio_id); -- 94
-- create index idx_site_references_site_id on public.tbl_site_references (site_id); -- 94
-- create index idx_taxa_tree_orders_record_type_id on public.tbl_taxa_tree_orders (record_type_id); -- 55
-- create index idx_abundance_elements_record_type_id on public.tbl_abundance_elements (record_type_id); -- 49
-- create index idx_coordinate_method_dimensions_method_id on public.tbl_coordinate_method_dimensions (method_id); -- 32
-- create index idx_dimensions_method_group_id on public.tbl_dimensions (method_group_id); -- 32
-- create index idx_dimensions_unit_id on public.tbl_dimensions (unit_id); -- 32
-- create index idx_coordinate_method_dimensions_dimension_id on public.tbl_coordinate_method_dimensions (dimension_id); -- 32
-- create index idx_seasons_season_type_id on public.tbl_seasons (season_type_id); -- 18
-- create index idx_sample_group_description_type_sampling_contexts_sampling_context_id on public.tbl_sample_group_description_type_sampling_contexts (sampling_context_id); -- 15
-- create index idx_sample_group_description_type_sampling_contexts_sample_group_description_type_id on public.tbl_sample_group_description_type_sampling_contexts (sample_group_description_type_id); -- 15
-- create index idx_data_types_data_type_group_id on public.tbl_data_types (data_type_group_id); -- 12
-- create index idx_sample_description_sample_group_contexts_sampling_context_id on public.tbl_sample_description_sample_group_contexts (sampling_context_id); -- 5
-- create index idx_sample_description_sample_group_contexts_sample_description_type_id on public.tbl_sample_description_sample_group_contexts (sample_description_type_id); -- 5
-- create index idx_sample_group_dimensions_sample_group_id on public.tbl_sample_group_dimensions (sample_group_id); -- 2
-- create index idx_dataset_masters_biblio_id on public.tbl_dataset_masters (biblio_id); -- 2
-- create index idx_dataset_masters_contact_id on public.tbl_dataset_masters (contact_id); -- 2
-- create index idx_sample_group_dimensions_dimension_id on public.tbl_sample_group_dimensions (dimension_id); -- 2
-- create index idx_site_images_site_id on public.tbl_site_images (site_id); -- 0
-- create index idx_site_images_image_type_id on public.tbl_site_images (image_type_id); -- 0
-- create index idx_site_images_contact_id on public.tbl_site_images (contact_id); -- 0
-- create index idx_site_natgridrefs_site_id on public.tbl_site_natgridrefs (site_id); -- 0
-- create index idx_site_natgridrefs_method_id on public.tbl_site_natgridrefs (method_id); -- 0
-- create index idx_site_other_records_site_id on public.tbl_site_other_records (site_id); -- 0
-- create index idx_site_other_records_record_type_id on public.tbl_site_other_records (record_type_id); -- 0
-- create index idx_site_other_records_biblio_id on public.tbl_site_other_records (biblio_id); -- 0
-- create index idx_site_preservation_status_site_id on public.tbl_site_preservation_status (site_id); -- 0
-- create index idx_taxa_images_taxon_id on public.tbl_taxa_images (taxon_id); -- 0
-- create index idx_taxa_images_image_type_id on public.tbl_taxa_images (image_type_id); -- 0
-- create index idx_taxa_measured_attributes_taxon_id on public.tbl_taxa_measured_attributes (taxon_id); -- 0
-- create index idx_taxa_reference_specimens_taxon_id on public.tbl_taxa_reference_specimens (taxon_id); -- 0
-- create index idx_taxa_reference_specimens_contact_id on public.tbl_taxa_reference_specimens (contact_id); -- 0
-- create index idx_taxa_seasonality_taxon_id on public.tbl_taxa_seasonality (taxon_id); -- 0
-- create index idx_taxa_seasonality_season_id on public.tbl_taxa_seasonality (season_id); -- 0
-- create index idx_taxa_seasonality_location_id on public.tbl_taxa_seasonality (location_id); -- 0
-- create index idx_taxa_seasonality_activity_type_id on public.tbl_taxa_seasonality (activity_type_id); -- 0
-- create index idx_taxa_synonyms_taxon_id on public.tbl_taxa_synonyms (taxon_id); -- 0
-- create index idx_taxa_synonyms_author_id on public.tbl_taxa_synonyms (author_id); -- 0
-- create index idx_taxa_synonyms_genus_id on public.tbl_taxa_synonyms (genus_id); -- 0
-- create index idx_taxa_synonyms_family_id on public.tbl_taxa_synonyms (family_id); -- 0
-- create index idx_taxa_synonyms_biblio_id on public.tbl_taxa_synonyms (biblio_id); -- 0
-- create index idx_taxonomy_notes_taxon_id on public.tbl_taxonomy_notes (taxon_id); -- 0
-- create index idx_taxonomy_notes_biblio_id on public.tbl_taxonomy_notes (biblio_id); -- 0
-- create index idx_tephra_dates_tephra_id on public.tbl_tephra_dates (tephra_id); -- 0
-- create index idx_tephra_dates_dating_uncertainty_id on public.tbl_tephra_dates (dating_uncertainty_id); -- 0
-- create index idx_tephra_dates_analysis_entity_id on public.tbl_tephra_dates (analysis_entity_id); -- 0
-- create index idx_tephra_refs_tephra_id on public.tbl_tephra_refs (tephra_id); -- 0
-- create index idx_tephra_refs_biblio_id on public.tbl_tephra_refs (biblio_id); -- 0
-- create index idx_text_biology_taxon_id on public.tbl_text_biology (taxon_id); -- 0
-- create index idx_text_biology_biblio_id on public.tbl_text_biology (biblio_id); -- 0
-- create index idx_text_distribution_taxon_id on public.tbl_text_distribution (taxon_id); -- 0
-- create index idx_text_distribution_biblio_id on public.tbl_text_distribution (biblio_id); -- 0
-- create index idx_text_identification_keys_taxon_id on public.tbl_text_identification_keys (taxon_id); -- 0
-- create index idx_text_identification_keys_biblio_id on public.tbl_text_identification_keys (biblio_id); -- 0
-- create index idx_aggregate_datasets_biblio_id on public.tbl_aggregate_datasets (biblio_id); -- 0
-- create index idx_aggregate_datasets_aggregate_order_type_id on public.tbl_aggregate_datasets (aggregate_order_type_id); -- 0
-- create index idx_aggregate_sample_ages_analysis_entity_age_id on public.tbl_aggregate_sample_ages (analysis_entity_age_id); -- 0
-- create index idx_aggregate_sample_ages_aggregate_dataset_id on public.tbl_aggregate_sample_ages (aggregate_dataset_id); -- 0
-- create index idx_analysis_entity_ages_chronology_id on public.tbl_analysis_entity_ages (chronology_id); -- 0
-- create index idx_analysis_entity_ages_analysis_entity_id on public.tbl_analysis_entity_ages (analysis_entity_id); -- 0
-- create index idx_aggregate_samples_aggregate_dataset_id on public.tbl_aggregate_samples (aggregate_dataset_id); -- 0
-- create index idx_aggregate_samples_analysis_entity_id on public.tbl_aggregate_samples (analysis_entity_id); -- 0
-- create index idx_chronologies_sample_group_id on public.tbl_chronologies (sample_group_id); -- 0
-- create index idx_chronologies_contact_id on public.tbl_chronologies (contact_id); -- 0
-- create index idx_analysis_entity_dimensions_dimension_id on public.tbl_analysis_entity_dimensions (dimension_id); -- 0
-- create index idx_analysis_entity_dimensions_analysis_entity_id on public.tbl_analysis_entity_dimensions (analysis_entity_id); -- 0
-- create index idx_biblio_keywords_keyword_id on public.tbl_biblio_keywords (keyword_id); -- 0
-- create index idx_biblio_keywords_biblio_id on public.tbl_biblio_keywords (biblio_id); -- 0
-- create index idx_ceramics_ceramics_measurement_id on public.tbl_ceramics (ceramics_measurement_id); -- 0
-- create index idx_ceramics_analysis_entity_id on public.tbl_ceramics (analysis_entity_id); -- 0
-- create index idx_ceramics_measurements_method_id on public.tbl_ceramics_measurements (method_id); -- 0
-- create index idx_ceramics_measurement_lookup_ceramics_measurement_id on public.tbl_ceramics_measurement_lookup (ceramics_measurement_id); -- 0
-- create index idx_chron_controls_chronology_id on public.tbl_chron_controls (chronology_id); -- 0
-- create index idx_chron_controls_chron_control_type_id on public.tbl_chron_controls (chron_control_type_id); -- 0
-- create index idx_colours_method_id on public.tbl_colours (method_id); -- 0
-- create index idx_dataset_contacts_dataset_id on public.tbl_dataset_contacts (dataset_id); -- 0
-- create index idx_dataset_contacts_contact_type_id on public.tbl_dataset_contacts (contact_type_id); -- 0
-- create index idx_dataset_contacts_contact_id on public.tbl_dataset_contacts (contact_id); -- 0
-- create index idx_dataset_submissions_dataset_id on public.tbl_dataset_submissions (dataset_id); -- 0
-- create index idx_dataset_submissions_contact_id on public.tbl_dataset_submissions (contact_id); -- 0
-- create index idx_dataset_submissions_submission_type_id on public.tbl_dataset_submissions (submission_type_id); -- 0
-- create index idx_projects_project_type_id on public.tbl_projects (project_type_id); -- 0
-- create index idx_projects_project_stage_id on public.tbl_projects (project_stage_id); -- 0
-- create index idx_dating_material_taxon_id on public.tbl_dating_material (taxon_id); -- 0
-- create index idx_dating_material_geochron_id on public.tbl_dating_material (geochron_id); -- 0
-- create index idx_dating_material_abundance_element_id on public.tbl_dating_material (abundance_element_id); -- 0
-- create index idx_geochronology_dating_uncertainty_id on public.tbl_geochronology (dating_uncertainty_id); -- 0
-- create index idx_geochronology_dating_lab_id on public.tbl_geochronology (dating_lab_id); -- 0
-- create index idx_geochronology_analysis_entity_id on public.tbl_geochronology (analysis_entity_id); -- 0
-- create index idx_dendro_dendro_measurement_id on public.tbl_dendro (dendro_measurement_id); -- 0
-- create index idx_dendro_analysis_entity_id on public.tbl_dendro (analysis_entity_id); -- 0
-- create index idx_dendro_measurements_method_id on public.tbl_dendro_measurements (method_id); -- 0
-- create index idx_dendro_dates_years_type_id on public.tbl_dendro_dates (years_type_id); -- 0
-- create index idx_dendro_dates_dating_uncertainty_id on public.tbl_dendro_dates (dating_uncertainty_id); -- 0
-- create index idx_dendro_dates_analysis_entity_id on public.tbl_dendro_dates (analysis_entity_id); -- 0
-- create index idx_dendro_date_notes_dendro_date_id on public.tbl_dendro_date_notes (dendro_date_id); -- 0
-- create index idx_dendro_measurement_lookup_dendro_measurement_id on public.tbl_dendro_measurement_lookup (dendro_measurement_id); -- 0
-- create index idx_geochron_refs_geochron_id on public.tbl_geochron_refs (geochron_id); -- 0
-- create index idx_geochron_refs_biblio_id on public.tbl_geochron_refs (biblio_id); -- 0
-- create index idx_imported_taxa_replacements_taxon_id on public.tbl_imported_taxa_replacements (taxon_id); -- 0
-- create index idx_lithology_sample_group_id on public.tbl_lithology (sample_group_id); -- 0
-- create index idx_mcr_summary_data_taxon_id on public.tbl_mcr_summary_data (taxon_id); -- 0
-- create index idx_mcrdata_birmbeetledat_taxon_id on public.tbl_mcrdata_birmbeetledat (taxon_id); -- 0
-- create index idx_measured_value_dimensions_measured_value_id on public.tbl_measured_value_dimensions (measured_value_id); -- 0
-- create index idx_measured_value_dimensions_dimension_id on public.tbl_measured_value_dimensions (dimension_id); -- 0
-- create index idx_rdb_codes_rdb_system_id on public.tbl_rdb_codes (rdb_system_id); -- 0
-- create index idx_rdb_location_id on public.tbl_rdb (location_id); -- 0
-- create index idx_rdb_taxon_id on public.tbl_rdb (taxon_id); -- 0
-- create index idx_rdb_rdb_code_id on public.tbl_rdb (rdb_code_id); -- 0
-- create index idx_rdb_systems_location_id on public.tbl_rdb_systems (location_id); -- 0
-- create index idx_rdb_systems_biblio_id on public.tbl_rdb_systems (biblio_id); -- 0
-- create index idx_relative_age_refs_relative_age_id on public.tbl_relative_age_refs (relative_age_id); -- 0
-- create index idx_relative_age_refs_biblio_id on public.tbl_relative_age_refs (biblio_id); -- 0
-- create index idx_relative_dates_relative_age_id on public.tbl_relative_dates (relative_age_id); -- 0
-- create index idx_relative_dates_physical_sample_id on public.tbl_relative_dates (physical_sample_id); -- 0
-- create index idx_relative_dates_method_id on public.tbl_relative_dates (method_id); -- 0
-- create index idx_relative_dates_dating_uncertainty_id on public.tbl_relative_dates (dating_uncertainty_id); -- 0
-- create index idx_sample_colours_physical_sample_id on public.tbl_sample_colours (physical_sample_id); -- 0
-- create index idx_sample_colours_colour_id on public.tbl_sample_colours (colour_id); -- 0
-- create index idx_sample_descriptions_sample_description_type_id on public.tbl_sample_descriptions (sample_description_type_id); -- 0
-- create index idx_sample_descriptions_physical_sample_id on public.tbl_sample_descriptions (physical_sample_id); -- 0
-- create index idx_sample_group_coordinates_sample_group_id on public.tbl_sample_group_coordinates (sample_group_id); -- 0
-- create index idx_sample_group_coordinates_coordinate_method_dimension_id on public.tbl_sample_group_coordinates (coordinate_method_dimension_id); -- 0
-- create index idx_sample_group_descriptions_sample_group_id on public.tbl_sample_group_descriptions (sample_group_id); -- 0
-- create index idx_sample_group_descriptions_sample_group_description_type_id on public.tbl_sample_group_descriptions (sample_group_description_type_id); -- 0
-- create index idx_sample_group_images_sample_group_id on public.tbl_sample_group_images (sample_group_id); -- 0
-- create index idx_sample_group_images_image_type_id on public.tbl_sample_group_images (image_type_id); -- 0
-- create index idx_sample_group_notes_sample_group_id on public.tbl_sample_group_notes (sample_group_id); -- 0
-- create index idx_sample_images_physical_sample_id on public.tbl_sample_images (physical_sample_id); -- 0
-- create index idx_sample_images_image_type_id on public.tbl_sample_images (image_type_id); -- 0
-- create index idx_sample_location_type_sampling_contexts_sampling_context_id on public.tbl_sample_location_type_sampling_contexts (sampling_context_id); -- 0
-- create index idx_sample_location_type_sampling_contexts_sample_location_type_id on public.tbl_sample_location_type_sampling_contexts (sample_location_type_id); -- 0
-- create index idx_sample_locations_sample_location_type_id on public.tbl_sample_locations (sample_location_type_id); -- 0
-- create index idx_sample_locations_physical_sample_id on public.tbl_sample_locations (physical_sample_id); -- 0
