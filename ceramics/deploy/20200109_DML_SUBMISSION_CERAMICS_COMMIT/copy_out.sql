\set submission_name '20200109_DML_SUBMISSION_CERAMICS_COMMIT'
\set submission_id null

select submission_id
from clearing_house.tbl_clearinghouse_submissions
where submission_name = :'submission_name' \gset

\copy (select * from clearing_house_commit.resolve_site(:submission_id)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/site.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_feature(:submission_id)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/feature.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset(:submission_id)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/dataset.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_contact(:submission_id)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/dataset_contact.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_submission(:submission_id)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/dataset_submission.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_description_type_sampling_context(:submission_id)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/sample_group_description_type_sampling_context.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group(:submission_id)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/sample_group.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_physical_sample(:submission_id)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/physical_sample.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_analysis_entity(:submission_id)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/analysis_entity.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_ceramic(:submission_id)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/ceramic.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_physical_sample_feature(:submission_id)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/physical_sample_feature.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_relative_date(:submission_id)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/relative_date.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_alt_ref(:submission_id)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/sample_alt_ref.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_description(:submission_id)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/sample_description.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_dimension(:submission_id)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/sample_dimension.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_description(:submission_id)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/sample_group_description.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_dimension(:submission_id)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/sample_group_dimension.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site_location(:submission_id)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/site_location.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site_reference(:submission_id)) to program 'gzip -qa9 > 20200109_DML_SUBMISSION_CERAMICS_COMMIT/site_reference.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
