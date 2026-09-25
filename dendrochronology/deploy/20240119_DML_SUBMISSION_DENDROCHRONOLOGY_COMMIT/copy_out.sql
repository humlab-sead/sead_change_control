
\copy (select * from clearing_house_commit.resolve_project('20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT')) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/project.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset('20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT')) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/dataset.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_contact('20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT')) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/dataset_contact.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_submission('20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT')) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/dataset_submission.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_abundance('20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT')) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/abundance.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_analysis_entity('20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT')) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/analysis_entity.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dendro('20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT')) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/dendro.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dendro_date_note('20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT')) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/dendro_date_note.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dendro_date('20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT')) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/dendro_date.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_physical_sample('20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT')) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/physical_sample.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_alt_ref('20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT')) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/sample_alt_ref.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_description('20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT')) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/sample_description.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_coordinate('20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT')) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/sample_group_coordinate.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_description('20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT')) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/sample_group_description.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_note('20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT')) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/sample_group_note.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group('20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT')) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/sample_group.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_location('20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT')) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/sample_location.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_note('20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT')) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/sample_note.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site_location('20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT')) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/site_location.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site_reference('20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT')) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/site_reference.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site('20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT')) to program 'gzip -qa9 > ./tmp/20240130_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT/site.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
