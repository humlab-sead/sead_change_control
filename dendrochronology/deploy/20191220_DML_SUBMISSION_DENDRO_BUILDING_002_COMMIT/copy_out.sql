
\copy (select * from clearing_house_commit.resolve_site(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_site.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_submission_type(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_dataset_submission_type.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_description_type(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_sample_group_description_type.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_project(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_project.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_dataset.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_contact(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_dataset_contact.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_submission(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_dataset_submission.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_description_type_sampling_context(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_sample_group_description_type_sampling_context.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_sample_group.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_physical_sample(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_physical_sample.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_analysis_entity(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_analysis_entity.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dendro(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_dendro.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dendro_date(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_dendro_date.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dendro_date_note(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_dendro_date_note.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_alt_ref(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_sample_alt_ref.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_description(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_sample_description.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_coordinate(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_sample_group_coordinate.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_description(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_sample_group_description.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_note(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_sample_group_note.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_location(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_sample_location.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_location_type_sampling_context(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_sample_location_type_sampling_context.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_note(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_sample_note.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site_location(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_site_location.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site_reference(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_site_reference.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_abundance(2)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT/submission_2_abundance.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
