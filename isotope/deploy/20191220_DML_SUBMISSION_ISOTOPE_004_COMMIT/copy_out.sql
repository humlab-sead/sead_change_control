
\copy (select * from clearing_house_commit.resolve_method_group(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_method_group.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_site.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_unit(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_unit.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_type(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_sample_type.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_feature(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_feature.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_method(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_method.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_isotope_measurement(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_isotope_measurement.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_dataset.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_contact(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_dataset_contact.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_dataset_submission(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_dataset_submission.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_relative_age(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_relative_age.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_relative_age_ref(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_relative_age_ref.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_sample_group.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_physical_sample(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_physical_sample.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_analysis_entity(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_analysis_entity.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_analysis_entity_prep_method(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_analysis_entity_prep_method.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_isotope(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_isotope.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_physical_sample_feature(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_physical_sample_feature.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_relative_date(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_relative_date.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_alt_ref(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_sample_alt_ref.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_description(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_sample_description.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_group_description(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_sample_group_description.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_location(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_sample_location.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_sample_note(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_sample_note.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site_location(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_site_location.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select * from clearing_house_commit.resolve_site_reference(4)) to program 'gzip -qa9 > 20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT/submission_4_site_reference.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
