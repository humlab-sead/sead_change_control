-- Deploy sead_change_control:20191012_DML_ISOTOPE_LOOKUP_DATA to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin

    begin

/*
        WITH new_locations(location_id, location_name, location_type_id) AS ( VALUES
            (3736, 'Jönköpings län', 2),

        ) insert into tbl_locations (location_id, location_name, location_type_id)
        select a.location_id, a.location_name, a.location_type_id
        from new_locations a
        left join tbl_locations b
            on a.location_id = b.location_id
        where b.location_id is null;

        --alter table tbl_sample_group_sampling_contexts alter column sampling_context type character varying(80);

        WITH new_sample_group_sampling_contexts (sampling_context_id, sampling_context, description) AS (VALUES
            (17, 'Dendrochronological building investigation', 'Investigation of wood for age determination, sampled in a historic building context'),
        ) insert into tbl_sample_group_sampling_contexts (sampling_context_id, sampling_context, description)
        select a.sampling_context_id, a.sampling_context, a.description
        from new_sample_group_sampling_contexts a
        left join tbl_sample_group_sampling_contexts b
            on a.sampling_context_id = b.sampling_context_id
        where b.sampling_context_id is null;

        WITH new_sample_location_types (sample_location_type_id, location_type, location_type_description) AS (VALUES
            (71, 'Sampled section', 'A description of the sampled area. i.e. what building or what part of the building was sampled, and possibly its function. (e.g. Västtorn, östra ladan, kor, långhus).'),
        ) insert into tbl_sample_location_types (sample_location_type_id, location_type, location_type_description)
        select a.sample_location_type_id, a.location_type, a.location_type_description
        from new_sample_location_types a
        left join tbl_sample_location_types b
            on a.sample_location_type_id = b.sample_location_type_id
        where b.sample_location_type_id is null;

        WITH new_feature_types (feature_type_id, feature_type_name, feature_type_description) AS (VALUES
            (503, 'Barrier', NULL),
        ) insert into tbl_feature_types (feature_type_id, feature_type_name, feature_type_description)
        select a.feature_type_id, a.feature_type_name, a.feature_type_description
        from new_feature_types a
        left join tbl_feature_types b
            on a.feature_type_id = b.feature_type_id
        where b.feature_type_id is null;

        WITH new_data_type_groups (data_type_group_id, data_type_group_name, description) AS (VALUES
            (19, 'Geographical','Geographical data either as a value or as a string.')
        ) insert into tbl_data_type_groups (data_type_group_id, data_type_group_name, description)
        select a.data_type_group_id, a.data_type_group_name, a.description
        from new_data_type_groups a
        left join tbl_data_type_groups b
            on a.data_type_group_id = b.data_type_group_id
        where b.data_type_group_id is null;

        WITH new_data_types (data_type_id, data_type_group_id, data_type_name, definition) AS (VALUES
            (43, 19, 'Estimated Years', 'Dates that are an estimation'),
        ) insert into tbl_data_types (data_type_id, data_type_group_id, data_type_name, definition)
        select a.data_type_id, a.data_type_group_id, a.data_type_name, a.definition
        from new_data_types a
        left join tbl_data_types b
            on a.data_type_id = b.data_type_id
        where b.data_type_id is null;

        WITH new_dataset_masters (master_set_id, master_name, url) AS (VALUES
            (10, 'The Laboratory for Wood Anatomy and Dendrochronology (Lund)','https://www.geology.lu.se/research/laboratories-equipment/the-laboratory-for-wood-anatomy-and-dendrochronology')
        ) insert into tbl_dataset_masters (master_set_id, master_name, url)
        select a.master_set_id, a.master_name, a.url
        from new_dataset_masters a
        left join tbl_dataset_masters b
            on a.master_set_id = b.master_set_id
        where b.master_set_id is null;

        WITH new_error_uncertainties (error_uncertainty_id, error_uncertainty_type, description) AS (VALUES
            (1, 'Ca','The error of a date is estimated as being circa (e.g. 1800 + ca 20 years)')
        ) insert into tbl_error_uncertainties (error_uncertainty_id, error_uncertainty_type, description)
        select a.error_uncertainty_id, a.error_uncertainty_type, a.description
        from new_error_uncertainties a
        left join tbl_error_uncertainties b
            on a.error_uncertainty_id = b.error_uncertainty_id
        where b.error_uncertainty_id is null;

        WITH new_age_types (age_type_id, age_type, description) AS (VALUES
            (1, 'AD','Anno Domini, Christian era; calendar era dates according to the Gregorian calendar.')
        ) insert into tbl_age_types (age_type_id, age_type, description)
        select a.age_type_id, a.age_type, a.description
        from new_age_types a
        left join tbl_age_types b
            on a.age_type_id = b.age_type_id
        where b.age_type_id is null;

        WITH new_season_or_qualifier (season_or_qualifier_id, season_or_qualifier_type, description) AS (VALUES
            (1, 'Winter','Felling date estimated as being during the winter, which is the resting period of the tree'),
        ) insert into tbl_season_or_qualifier (season_or_qualifier_id, season_or_qualifier_type, description)
        select a.season_or_qualifier_id, a.season_or_qualifier_type, a.description
        from new_season_or_qualifier a
        left join tbl_season_or_qualifier b
            on a.season_or_qualifier_id = b.season_or_qualifier_id
        where b.season_or_qualifier_id is null;

        WITH new_sample_description_types (sample_description_type_id, type_name, type_description) AS (VALUES
            (30, 'Wood function','Function or format of the wood'),
        ) insert into tbl_sample_description_types (sample_description_type_id, type_name, type_description)
        select a.sample_description_type_id, a.type_name, a.type_description
        from new_sample_description_types a
        left join tbl_sample_description_types b
            on a.sample_description_type_id = b.sample_description_type_id
        where b.sample_description_type_id is null;

        WITH new_biblio (biblio_id, authors, year, title, full_reference) AS (VALUES
        (6148, 'Andersson, Iwar', '1967', 'Hagby fästningskyrka. Fornvännen, vol 62, 1967, s. 22-36.', 'Andersson, Iwar (1967). Hagby fästningskyrka. Fornvännen, vol 62, 1967, s. 22-36.'),

        ) insert into tbl_biblio (biblio_id, authors, year, title, full_reference)
        select a.biblio_id, a.authors, a.year, a.title, a.full_reference
        from new_biblio a
        left join tbl_biblio b
            on a.biblio_id = b.biblio_id
        where b.biblio_id is null;

        WITH new_contacts (contact_id, address_1, address_2, first_name, last_name, email, url, location_id) AS (VALUES
            (1, 'Environmental Archaeology Lab
        Dept. of Philosophical, Historical & Religious Studes', 'Umeå University
        SE-90187  Umeå', 'Philip', 'Buckland', 'phil.buckland@arke.umu.se', 'http://www.idesam.umu.se/om/personal/visa-person/?uid=phbu0001&guise=anst1', 205),
        ) insert into tbl_contacts (contact_id, address_1, address_2, first_name, last_name, email, url, location_id)
        select a.contact_id, a.address_1, a.address_2, a.first_name, a.last_name, a.email, a.url, a.location_id
        from new_contacts a
        left join tbl_contacts b
            on a.contact_id = b.contact_id
        where b.contact_id is null;

        WITH new_project_types (project_type_id, project_type_name, description) AS (VALUES
            (8, 'Unclassified', 'A project of unknown character.')
        ) insert into tbl_project_types (project_type_id, project_type_name, description)
        select a.project_type_id, a.project_type_name, a.description
        from new_project_types a
        left join tbl_project_types b
            on a.project_type_id = b.project_type_id
        where b.project_type_id is null;

        WITH new_project_stages (project_stage_id, stage_name, description) AS (VALUES
            (6, 'Dendrochronological study', 'An investigation using tree rings to determine the age of wood. Sampling in historic building investigation and archaeological contexts.')
        ) insert into tbl_project_stages (project_stage_id, stage_name, description)
        select a.project_stage_id, a.stage_name, a.description
        from new_project_stages a
        left join tbl_project_stages b
            on a.project_stage_id = b.project_stage_id
        where b.project_stage_id is null;

        perform sead_utility.sync_sequence('public', 'tbl_feature_types');
        perform sead_utility.sync_sequence('public', 'tbl_locations');
        perform sead_utility.sync_sequence('public', 'tbl_sample_group_sampling_contexts');
        perform sead_utility.sync_sequence('public', 'tbl_sample_location_types');
        perform sead_utility.sync_sequence('public', 'tbl_feature_types');
        perform sead_utility.sync_sequence('public', 'tbl_data_type_groups');
        perform sead_utility.sync_sequence('public', 'tbl_data_types');
        perform sead_utility.sync_sequence('public', 'tbl_dataset_masters');
        perform sead_utility.sync_sequence('public', 'tbl_error_uncertainties');
        perform sead_utility.sync_sequence('public', 'tbl_age_types');
        perform sead_utility.sync_sequence('public', 'tbl_season_or_qualifier');
        perform sead_utility.sync_sequence('public', 'tbl_sample_description_types');
        perform sead_utility.sync_sequence('public', 'tbl_biblio');
        perform sead_utility.sync_sequence('public', 'tbl_contacts');
        perform sead_utility.sync_sequence('public', 'tbl_project_types');
        perform sead_utility.sync_sequence('public', 'tbl_project_stages');
        perform sead_utility.sync_sequence('public', 'tbl_isotope_standars');
        perform sead_utility.sync_sequence('public', 'tbl_isotope_types');
*/

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
