
\copy (select * from clearing_house_commit.resolve_site(5)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/site.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_feature(5)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/feature.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset(5)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/dataset.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_contact(5)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/dataset_contact.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_submission(5)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/dataset_submission.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_description_type_sampling_context(5)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/sample_group_description_type_sampling_context.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group(5)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/sample_group.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_physical_sample(5)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/physical_sample.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_analysis_entity(5)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/analysis_entity.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_ceramic(5)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/ceramic.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_physical_sample_feature(5)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/physical_sample_feature.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_relative_date(5)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/relative_date.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_alt_ref(5)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/sample_alt_ref.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_description(5)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/sample_description.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_dimension(5)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/sample_dimension.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_description(5)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/sample_group_description.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_dimension(5)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/sample_group_dimension.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site_location(5)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/site_location.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site_reference(5)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_005_COMMIT/site_reference.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
