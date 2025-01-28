
\copy (select * from clearing_house_commit.resolve_biblio(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_biblio.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_contact(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_contact.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_taxonomic_order_system(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_taxonomic_order_system.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_alt_ref_type(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_alt_ref_type.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_record_type(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_record_type.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_master(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_dataset_master.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_location(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_location.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_method(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_method.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_project(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_project.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_dataset.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_contact(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_dataset_contact.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_submission(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_dataset_submission.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_taxa_tree_order(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_taxa_tree_order.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_taxa_tree_family(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_taxa_tree_family.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_taxa_tree_genera(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_taxa_tree_genera.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_taxa_tree_master(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_taxa_tree_master.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_taxonomic_order(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_taxonomic_order.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_value_type(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_value_type.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_value_classe(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_value_classe.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_value_type_item(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_value_type_item.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_abundance(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_abundance.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_analysis_entity(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_analysis_entity.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_analysis_value(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_analysis_value.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_physical_sample(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_physical_sample.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_relative_date(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_relative_date.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_alt_ref(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_sample_alt_ref.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_sample_group.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site_location(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_site_location.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site_reference(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_site_reference.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site(1)) to program 'gzip -qa9 > ./tmp/20250108_DML_SUBMISSION_ADNA_001_COMMIT/submission_1_site.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
