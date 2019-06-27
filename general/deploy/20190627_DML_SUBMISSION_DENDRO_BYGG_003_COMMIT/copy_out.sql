
\copy (select * from clearing_house_commit.resolve_site(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_site.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_submission_type(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_dataset_submission_type.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_description_type(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_sample_group_description_type.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_project(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_project.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_dataset.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_contact(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_dataset_contact.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_submission(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_dataset_submission.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_description_type_sampling_context(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_sample_group_description_type_sampling_context.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_sample_group.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_physical_sample(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_physical_sample.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_analysis_entity(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_analysis_entity.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dendro(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_dendro.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dendro_date(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_dendro_date.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dendro_date_note(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_dendro_date_note.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_alt_ref(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_sample_alt_ref.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_description(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_sample_description.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_coordinate(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_sample_group_coordinate.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_description(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_sample_group_description.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_note(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_sample_group_note.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_location(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_sample_location.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_location_type_sampling_context(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_sample_location_type_sampling_context.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_note(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_sample_note.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site_location(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_site_location.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site_reference(3)) to program 'gzip -qa9 > 20190627_DML_SUBMISSION_DENDRO_BYGG_003_COMMIT/submission_3_site_reference.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
