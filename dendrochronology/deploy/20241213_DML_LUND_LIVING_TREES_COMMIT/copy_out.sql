
\copy (select submission_type_id, submission_type, description, date_updated from clearing_house_commit.resolve_dataset_submission_type('20241213_DML_LUND_LIVING_TREES_COMMIT')) to program 'gzip -qa9 > ./20241213_DML_LUND_LIVING_TREES_COMMIT/dataset_submission_type.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select sample_location_type_id, location_type, location_type_description, date_updated from clearing_house_commit.resolve_sample_location_type('20241213_DML_LUND_LIVING_TREES_COMMIT')) to program 'gzip -qa9 > ./20241213_DML_LUND_LIVING_TREES_COMMIT/sample_location_type.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select dimension_id, date_updated, dimension_abbrev, dimension_description, dimension_name, unit_id, method_group_id from clearing_house_commit.resolve_dimension('20241213_DML_LUND_LIVING_TREES_COMMIT')) to program 'gzip -qa9 > ./20241213_DML_LUND_LIVING_TREES_COMMIT/dimension.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select project_id, project_type_id, project_stage_id, project_name, project_abbrev_name, description, date_updated from clearing_house_commit.resolve_project('20241213_DML_LUND_LIVING_TREES_COMMIT')) to program 'gzip -qa9 > ./20241213_DML_LUND_LIVING_TREES_COMMIT/project.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select dataset_id, master_set_id, data_type_id, method_id, biblio_id, updated_dataset_id, project_id, dataset_name, date_updated, dataset_uuid from clearing_house_commit.resolve_dataset('20241213_DML_LUND_LIVING_TREES_COMMIT')) to program 'gzip -qa9 > ./20241213_DML_LUND_LIVING_TREES_COMMIT/dataset.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select dataset_contact_id, contact_id, contact_type_id, dataset_id, date_updated from clearing_house_commit.resolve_dataset_contact('20241213_DML_LUND_LIVING_TREES_COMMIT')) to program 'gzip -qa9 > ./20241213_DML_LUND_LIVING_TREES_COMMIT/dataset_contact.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select dataset_submission_id, dataset_id, submission_type_id, contact_id, date_submitted, notes, date_updated from clearing_house_commit.resolve_dataset_submission('20241213_DML_LUND_LIVING_TREES_COMMIT')) to program 'gzip -qa9 > ./20241213_DML_LUND_LIVING_TREES_COMMIT/dataset_submission.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select analysis_entity_id, physical_sample_id, dataset_id, date_updated from clearing_house_commit.resolve_analysis_entity('20241213_DML_LUND_LIVING_TREES_COMMIT')) to program 'gzip -qa9 > ./20241213_DML_LUND_LIVING_TREES_COMMIT/analysis_entity.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select analysis_value_id, value_class_id, analysis_entity_id, analysis_value, boolean_value, is_boolean, is_uncertain, is_undefined, is_not_analyzed, is_indeterminable, is_anomaly from clearing_house_commit.resolve_analysis_value('20241213_DML_LUND_LIVING_TREES_COMMIT')) to program 'gzip -qa9 > ./20241213_DML_LUND_LIVING_TREES_COMMIT/analysis_value.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select physical_sample_id, sample_group_id, alt_ref_type_id, sample_type_id, sample_name, date_updated, date_sampled from clearing_house_commit.resolve_physical_sample('20241213_DML_LUND_LIVING_TREES_COMMIT')) to program 'gzip -qa9 > ./20241213_DML_LUND_LIVING_TREES_COMMIT/physical_sample.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select sample_alt_ref_id, alt_ref, alt_ref_type_id, date_updated, physical_sample_id from clearing_house_commit.resolve_sample_alt_ref('20241213_DML_LUND_LIVING_TREES_COMMIT')) to program 'gzip -qa9 > ./20241213_DML_LUND_LIVING_TREES_COMMIT/sample_alt_ref.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select sample_dimension_id, physical_sample_id, dimension_id, method_id, dimension_value, date_updated, qualifier_id from clearing_house_commit.resolve_sample_dimension('20241213_DML_LUND_LIVING_TREES_COMMIT')) to program 'gzip -qa9 > ./20241213_DML_LUND_LIVING_TREES_COMMIT/sample_dimension.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select sample_group_description_id, group_description, sample_group_description_type_id, date_updated, sample_group_id from clearing_house_commit.resolve_sample_group_description('20241213_DML_LUND_LIVING_TREES_COMMIT')) to program 'gzip -qa9 > ./20241213_DML_LUND_LIVING_TREES_COMMIT/sample_group_description.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select sample_group_id, site_id, sampling_context_id, method_id, sample_group_name, sample_group_description, date_updated, sample_group_uuid from clearing_house_commit.resolve_sample_group('20241213_DML_LUND_LIVING_TREES_COMMIT')) to program 'gzip -qa9 > ./20241213_DML_LUND_LIVING_TREES_COMMIT/sample_group.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select sample_location_id, sample_location_type_id, physical_sample_id, location, date_updated from clearing_house_commit.resolve_sample_location('20241213_DML_LUND_LIVING_TREES_COMMIT')) to program 'gzip -qa9 > ./20241213_DML_LUND_LIVING_TREES_COMMIT/sample_location.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
\copy (select site_location_id, date_updated, location_id, site_id from clearing_house_commit.resolve_site_location('20241213_DML_LUND_LIVING_TREES_COMMIT')) to program 'gzip -qa9 > ./20241213_DML_LUND_LIVING_TREES_COMMIT/site_location.gz' with (format text, delimiter E'\t', encoding 'utf-8');
    
