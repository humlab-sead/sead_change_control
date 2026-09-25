
\copy (select * from clearing_house_commit.resolve_site('20200109_DML_SUBMISSION_CERAMICS_COMMIT')) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/site.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_feature('20200109_DML_SUBMISSION_CERAMICS_COMMIT')) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/feature.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset('20200109_DML_SUBMISSION_CERAMICS_COMMIT')) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/dataset.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_contact('20200109_DML_SUBMISSION_CERAMICS_COMMIT')) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/dataset_contact.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_submission('20200109_DML_SUBMISSION_CERAMICS_COMMIT')) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/dataset_submission.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_description_type_sampling_context('20200109_DML_SUBMISSION_CERAMICS_COMMIT')) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/sample_group_description_type_sampling_context.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group('20200109_DML_SUBMISSION_CERAMICS_COMMIT')) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/sample_group.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_physical_sample('20200109_DML_SUBMISSION_CERAMICS_COMMIT')) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/physical_sample.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_analysis_entity('20200109_DML_SUBMISSION_CERAMICS_COMMIT')) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/analysis_entity.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_ceramic('20200109_DML_SUBMISSION_CERAMICS_COMMIT')) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/ceramic.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_physical_sample_feature('20200109_DML_SUBMISSION_CERAMICS_COMMIT')) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/physical_sample_feature.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_relative_date('20200109_DML_SUBMISSION_CERAMICS_COMMIT')) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/relative_date.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_alt_ref('20200109_DML_SUBMISSION_CERAMICS_COMMIT')) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/sample_alt_ref.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_description('20200109_DML_SUBMISSION_CERAMICS_COMMIT')) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/sample_description.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_dimension('20200109_DML_SUBMISSION_CERAMICS_COMMIT')) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/sample_dimension.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_description('20200109_DML_SUBMISSION_CERAMICS_COMMIT')) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/sample_group_description.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_dimension('20200109_DML_SUBMISSION_CERAMICS_COMMIT')) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/sample_group_dimension.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site_location('20200109_DML_SUBMISSION_CERAMICS_COMMIT')) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/site_location.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site_reference('20200109_DML_SUBMISSION_CERAMICS_COMMIT')) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/site_reference.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
