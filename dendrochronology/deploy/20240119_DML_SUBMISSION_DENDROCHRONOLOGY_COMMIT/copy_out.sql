\set submission_name '20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT'
\set submission_id null

select submission_id
from clearing_house.tbl_clearinghouse_submissions
where submission_name = :'submission_name' \gset


\copy (select * from clearing_house_commit.resolve_project(:submission_id)) to program 'gzip -qa9 > ./20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/project.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset(:submission_id)) to program 'gzip -qa9 > ./20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/dataset.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_contact(:submission_id)) to program 'gzip -qa9 > ./20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/dataset_contact.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_submission(:submission_id)) to program 'gzip -qa9 > ./20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/dataset_submission.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_abundance(:submission_id)) to program 'gzip -qa9 > ./20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/abundance.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_analysis_entity(:submission_id)) to program 'gzip -qa9 > ./20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/analysis_entity.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dendro(:submission_id)) to program 'gzip -qa9 > ./20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/dendro.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dendro_date_note(:submission_id)) to program 'gzip -qa9 > ./20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/dendro_date_note.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dendro_date(:submission_id)) to program 'gzip -qa9 > ./20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/dendro_date.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_physical_sample(:submission_id)) to program 'gzip -qa9 > ./20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/physical_sample.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_alt_ref(:submission_id)) to program 'gzip -qa9 > ./20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/sample_alt_ref.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_description(:submission_id)) to program 'gzip -qa9 > ./20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/sample_description.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_coordinate(:submission_id)) to program 'gzip -qa9 > ./20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/sample_group_coordinate.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_description(:submission_id)) to program 'gzip -qa9 > ./20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/sample_group_description.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_note(:submission_id)) to program 'gzip -qa9 > ./20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/sample_group_note.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group(:submission_id)) to program 'gzip -qa9 > ./20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/sample_group.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_location(:submission_id)) to program 'gzip -qa9 > ./20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/sample_location.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_note(:submission_id)) to program 'gzip -qa9 > ./20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/sample_note.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site_location(:submission_id)) to program 'gzip -qa9 > ./20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/site_location.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site_reference(:submission_id)) to program 'gzip -qa9 > ./20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/site_reference.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site(:submission_id)) to program 'gzip -qa9 > ./20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/site.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
