
\copy (select biblio_id, bugs_reference, date_updated, doi, isbn, notes, title, year, authors, full_reference, url from clearing_house_commit.resolve_biblio(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_biblio.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select contact_id, address_1, address_2, location_id, email, first_name, last_name, phone_number, url, date_updated from clearing_house_commit.resolve_contact(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_contact.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select taxonomic_order_system_id, date_updated, system_description, system_name from clearing_house_commit.resolve_taxonomic_order_system(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_taxonomic_order_system.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select alt_ref_type_id, alt_ref_type, date_updated, description from clearing_house_commit.resolve_alt_ref_type(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_alt_ref_type.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select record_type_id, record_type_name, record_type_description, date_updated from clearing_house_commit.resolve_record_type(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_record_type.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select master_set_id, contact_id, biblio_id, master_name, master_notes, url, date_updated from clearing_house_commit.resolve_dataset_master(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_dataset_master.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select location_id, location_name, location_type_id, default_lat_dd, default_long_dd, date_updated from clearing_house_commit.resolve_location(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_location.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select method_id, biblio_id, date_updated, description, method_abbrev_or_alt_name, method_group_id, method_name, record_type_id, unit_id from clearing_house_commit.resolve_method(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_method.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select project_id, project_type_id, project_stage_id, project_name, project_abbrev_name, description, date_updated from clearing_house_commit.resolve_project(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_project.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select dataset_id, master_set_id, data_type_id, method_id, biblio_id, updated_dataset_id, project_id, dataset_name, date_updated from clearing_house_commit.resolve_dataset(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_dataset.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select dataset_contact_id, contact_id, contact_type_id, dataset_id, date_updated from clearing_house_commit.resolve_dataset_contact(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_dataset_contact.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select dataset_submission_id, dataset_id, submission_type_id, contact_id, date_submitted, notes, date_updated from clearing_house_commit.resolve_dataset_submission(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_dataset_submission.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select order_id, date_updated, order_name, record_type_id, sort_order from clearing_house_commit.resolve_taxa_tree_order(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_taxa_tree_order.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select family_id, date_updated, family_name, order_id from clearing_house_commit.resolve_taxa_tree_family(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_taxa_tree_family.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select genus_id, date_updated, family_id, genus_name from clearing_house_commit.resolve_taxa_tree_genera(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_taxa_tree_genera.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select taxon_id, author_id, date_updated, genus_id, species from clearing_house_commit.resolve_taxa_tree_master(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_taxa_tree_master.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select taxonomic_order_id, date_updated, taxon_id, taxonomic_code, taxonomic_order_system_id from clearing_house_commit.resolve_taxonomic_order(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_taxonomic_order.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select value_type_id, unit_id, data_type_id, name, base_type, precision, description, value_type_uuid from clearing_house_commit.resolve_value_type(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_value_type.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select value_class_id, value_type_id, method_id, parent_id, name, description, value_class_uuid from clearing_house_commit.resolve_value_classe(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_value_classe.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select value_type_item_id, value_type_id, name, description from clearing_house_commit.resolve_value_type_item(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_value_type_item.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select abundance_id, taxon_id, analysis_entity_id, abundance_element_id, abundance, date_updated from clearing_house_commit.resolve_abundance(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_abundance.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select analysis_entity_id, physical_sample_id, dataset_id, date_updated from clearing_house_commit.resolve_analysis_entity(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_analysis_entity.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select analysis_value_id, value_class_id, analysis_entity_id, analysis_value, boolean_value, is_boolean, is_uncertain, is_undefined, is_not_analyzed, is_indeterminable, is_anomaly from clearing_house_commit.resolve_analysis_value(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_analysis_value.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select physical_sample_id, sample_group_id, alt_ref_type_id, sample_type_id, sample_name, date_updated, date_sampled from clearing_house_commit.resolve_physical_sample(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_physical_sample.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select relative_date_id, relative_age_id, method_id, notes, date_updated, dating_uncertainty_id, analysis_entity_id from clearing_house_commit.resolve_relative_date(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_relative_date.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select sample_alt_ref_id, alt_ref, alt_ref_type_id, date_updated, physical_sample_id from clearing_house_commit.resolve_sample_alt_ref(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_sample_alt_ref.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select sample_group_id, site_id, sampling_context_id, method_id, sample_group_name, sample_group_description, date_updated from clearing_house_commit.resolve_sample_group(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_sample_group.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select site_location_id, date_updated, location_id, site_id from clearing_house_commit.resolve_site_location(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_site_location.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select site_reference_id, site_id, biblio_id, date_updated from clearing_house_commit.resolve_site_reference(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_site_reference.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select site_id, altitude, latitude_dd, longitude_dd, national_site_identifier, site_description, site_name, site_preservation_status_id, date_updated, site_location_accuracy from clearing_house_commit.resolve_site(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_site.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
