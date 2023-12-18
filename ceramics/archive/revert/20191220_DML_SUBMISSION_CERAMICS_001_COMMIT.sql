-- Revert ceramics: 20191220_DML_SUBMISSION_CERAMICS_001_COMMIT

BEGIN;

		delete from public.tbl_site_references
		where site_reference_id in (
			select transport_id
			from clearing_house.tbl_site_references
			where submission_id = 1
			  and transport_id is not null
		);

		delete from public.tbl_site_locations
		where site_location_id in (
			select transport_id
			from clearing_house.tbl_site_locations
			where submission_id = 1
			  and transport_id is not null
		);

		delete from public.tbl_sample_group_dimensions
		where sample_group_dimension_id in (
			select transport_id
			from clearing_house.tbl_sample_group_dimensions
			where submission_id = 1
			  and transport_id is not null
		);

		delete from public.tbl_sample_dimensions
		where sample_dimension_id in (
			select transport_id
			from clearing_house.tbl_sample_dimensions
			where submission_id = 1
			  and transport_id is not null
		);

		delete from public.tbl_sample_descriptions
		where sample_description_id in (
			select transport_id
			from clearing_house.tbl_sample_descriptions
			where submission_id = 1
			  and transport_id is not null
		);

		delete from public.tbl_sample_alt_refs
		where sample_alt_ref_id in (
			select transport_id
			from clearing_house.tbl_sample_alt_refs
			where submission_id = 1
			  and transport_id is not null
		);

		delete from public.tbl_relative_dates
		where relative_date_id in (
			select transport_id
			from clearing_house.tbl_relative_dates
			where submission_id = 1
			  and transport_id is not null
		);

		delete from public.tbl_physical_sample_features
		where physical_sample_feature_id in (
			select transport_id
			from clearing_house.tbl_physical_sample_features
			where submission_id = 1
			  and transport_id is not null
		);

		delete from public.tbl_ceramics
		where ceramics_id in (
			select transport_id
			from clearing_house.tbl_ceramics
			where submission_id = 1
			  and transport_id is not null
		);

		delete from public.tbl_analysis_entities
		where analysis_entity_id in (
			select transport_id
			from clearing_house.tbl_analysis_entities
			where submission_id = 1
			  and transport_id is not null
		);

		delete from public.tbl_physical_samples
		where physical_sample_id in (
			select transport_id
			from clearing_house.tbl_physical_samples
			where submission_id = 1
			  and transport_id is not null
		);

		delete from public.tbl_sample_groups
		where sample_group_id in (
			select transport_id
			from clearing_house.tbl_sample_groups
			where submission_id = 1
			  and transport_id is not null
		);

		delete from public.tbl_sample_group_description_type_sampling_contexts
		where sample_group_description_type_sampling_context_id in (
			select transport_id
			from clearing_house.tbl_sample_group_description_type_sampling_contexts
			where submission_id = 1
			  and transport_id is not null
		);

		delete from public.tbl_dataset_submissions
		where dataset_submission_id in (
			select transport_id
			from clearing_house.tbl_dataset_submissions
			where submission_id = 1
			  and transport_id is not null
		);

		delete from public.tbl_dataset_contacts
		where dataset_contact_id in (
			select transport_id
			from clearing_house.tbl_dataset_contacts
			where submission_id = 1
			  and transport_id is not null
		);

		delete from public.tbl_datasets
		where dataset_id in (
			select transport_id
			from clearing_house.tbl_datasets
			where submission_id = 1
			  and transport_id is not null
		);

		delete from public.tbl_features
		where feature_id in (
			select transport_id
			from clearing_house.tbl_features
			where submission_id = 1
			  and transport_id is not null
		);

		delete from public.tbl_sites
		where site_id in (
			select transport_id
			from clearing_house.tbl_sites
			where submission_id = 1
			  and transport_id is not null
		);


COMMIT;
