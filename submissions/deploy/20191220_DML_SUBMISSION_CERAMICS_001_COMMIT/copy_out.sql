
\copy (select * from clearing_house_commit.resolve_site(1)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_site.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_feature(1)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_feature.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset(1)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_dataset.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_contact(1)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_dataset_contact.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_submission(1)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_dataset_submission.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_description_type_sampling_context(1)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_sample_group_description_type_sampling_context.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group(1)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_sample_group.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_physical_sample(1)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_physical_sample.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_analysis_entity(1)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_analysis_entity.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_ceramic(1)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_ceramic.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_physical_sample_feature(1)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_physical_sample_feature.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_relative_date(1)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_relative_date.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_alt_ref(1)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_sample_alt_ref.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_description(1)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_sample_description.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_dimension(1)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_sample_group_dimension.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site_location(1)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_site_location.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site_reference(1)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT/submission_1_site_reference.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
