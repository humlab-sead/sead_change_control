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
        NOTE! Value below are just examples and should be removed from file!

        WITH new_locations(location_id, location_name, location_type_id) AS ( VALUES
            (3736, 'Jönköpings län', 2),

        ) insert into tbl_locations (location_id, location_name, location_type_id)
        select a.location_id, a.location_name, a.location_type_id
        from new_locations a
        left join tbl_locations b
            on a.location_id = b.location_id
        where b.location_id is null;

        WITH new_sample_location_types (sample_location_type_id, location_type, location_type_description) AS (VALUES
            (71, 'Sampled section', 'A description of the sampled area. i.e. what building or what part of the building was sampled, and possibly its function. (e.g. Västtorn, östra ladan, kor, långhus).'),
        ) insert into tbl_sample_location_types (sample_location_type_id, location_type, location_type_description)
        select a.sample_location_type_id, a.location_type, a.location_type_description
        from new_sample_location_types a
        left join tbl_sample_location_types b
            on a.sample_location_type_id = b.sample_location_type_id
        where b.sample_location_type_id is null;

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

        -- SAME FOR tbl_isotope_value_specifiers AND tbl_isotope_types AND tbl_isotope_standards

        perform sead_utility.sync_sequence('public', 'tbl_sample_location_types');
        perform sead_utility.sync_sequence('public', 'tbl_locations');
        perform sead_utility.sync_sequence('public', 'tbl_data_types');
        perform sead_utility.sync_sequence('public', 'tbl_dataset_masters');
        perform sead_utility.sync_sequence('public', 'tbl_biblio');
        perform sead_utility.sync_sequence('public', 'tbl_contacts');
        perform sead_utility.sync_sequence('public', 'tbl_isotope_value_specifiers');
        perform sead_utility.sync_sequence('public', 'tbl_isotope_types');
        perform sead_utility.sync_sequence('public', 'tbl_isotope_standards');
*/

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
