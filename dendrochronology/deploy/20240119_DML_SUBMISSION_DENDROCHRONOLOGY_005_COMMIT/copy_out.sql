
\copy (select * from clearing_house_commit.resolve_project(5)) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/submission_5_project.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset(5)) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/submission_5_dataset.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_contact(5)) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/submission_5_dataset_contact.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_submission(5)) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/submission_5_dataset_submission.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_abundance(5)) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/submission_5_abundance.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_analysis_entity(5)) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/submission_5_analysis_entity.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dendro(5)) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/submission_5_dendro.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dendro_date_note(5)) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/submission_5_dendro_date_note.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dendro_date(5)) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/submission_5_dendro_date.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_physical_sample(5)) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/submission_5_physical_sample.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_alt_ref(5)) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/submission_5_sample_alt_ref.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_description(5)) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/submission_5_sample_description.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_coordinate(5)) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/submission_5_sample_group_coordinate.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_description(5)) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/submission_5_sample_group_description.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_note(5)) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/submission_5_sample_group_note.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group(5)) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/submission_5_sample_group.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_location(5)) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/submission_5_sample_location.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_note(5)) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/submission_5_sample_note.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site_location(5)) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/submission_5_site_location.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site_reference(5)) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/submission_5_site_reference.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site(5)) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_005_COMMIT/submission_5_site.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
