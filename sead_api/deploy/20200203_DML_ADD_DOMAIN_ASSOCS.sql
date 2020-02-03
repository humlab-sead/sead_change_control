-- Deploy sead_api:20200203_DML_ADD_DOMAIN_ASSOCS to pg

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

    declare s_facets text;
    declare j_facets jsonb;

    begin

	insert into facet.facet_children (facet_code, child_facet_code, position)
		select 'palaeoentomology', facet_code, position
		from facet.facet
		join (values
			('Eco code system', 1),
			('Eco code', 2),
			('Abundances', 3),
			('Geochronology', 4),
			('Time periods', 5),
			('Seasons', 6),
			('Family', 7),
			('Genus', 8),
			('Taxa', 9),
			('Author', 10),
			('Feature type', 11),
			('Bibligraphy modern', 12),
			-- ('Bibligraphy fossil', 13), -- missing
			('Country', 14),
			('Site', 15),
			('Sample group', 16)
			-- ('rdb_system', 17), -- missing fungerar på samma sätt som eco codes',
			-- ('rdb_codes', 18), -- missing fungerar på samma sätt som eco codes',
			-- ('Analysis entity ages', 19), -- missing
			-- ('tbl_sample_group_sampling_contexts', 20), -- missing
			-- ('tbl_data_types', 21) -- missing
		) as v(display_title, position) using (display_title)
		where is_applicable = TRUE;

	insert into facet.facet_children (facet_code, child_facet_code, position)
		select 'archaeobotany', facet_code, position
		from facet.facet
		join (values
			('Eco code system', 1),
			('Eco code', 2),
			('Abundances', 3),
			('Geochronology', 4),
			('Time periods', 5),
			('Seasons', 6),
			('Family', 7),
			('Genus', 8),
			('Taxa', 9),
			('Author', 10),
			('Feature type', 11),
			('Bibligraphy modern', 12),
			-- ('Bibligraphy fossil', 13), -- missing
			('Country', 14),
			('Site', 15),
			('Sample group', 16)
			-- ('Analysis entity ages', 19), -- missing
			-- ('tbl_sample_group_sampling_contexts', 20), -- missing
			-- ('tbl_data_types', 21), -- missing
			-- ('tbl_modification_types', 22), -- missing
			-- ('tbl_abundance_elements', 23) -- missing
		) as v(display_title, position) using (display_title)
		where is_applicable = TRUE;

	insert into facet.facet_children (facet_code, child_facet_code, position)
		select 'pollen', facet_code, position
		from facet.facet
		join (values
			('Eco code system', 1),
			('Eco code', 2),
			('Abundances', 3),
			('Geochronology', 4),
			('Time periods', 5),
			('Seasons', 6),
			('Family', 7),
			('Genus', 8),
			('Taxa', 9),
			('Author', 10),
			('Feature type', 11),
			('Bibligraphy modern', 12),
			-- ('Bibligraphy fossil', 13), -- missing
			('Country', 14),
			('Site', 15),
			('Sample group', 16)
			-- ('Analysis entity ages', 19), -- missing
			-- ('tbl_sample_group_sampling_contexts', 20), -- missing
			-- ('tbl_data_types', 21), -- missing
			-- ('tbl_abundance_elements', 23) -- missing
		) as v(display_title, position) using (display_title)
		where is_applicable = TRUE;

	insert into facet.facet_children (facet_code, child_facet_code, position)
		select 'geoarchaeology', facet_code, position
		from facet.facet
		join (values
			('MS Heating 550', 1),
			('Phosphate p-kvot', 2),
			('Geochronology', 3),
			('Time periods', 4),
			('Feature type', 5),
			('Bibligraphy modern', 6),
			-- ('Bibligraphy fossil', 7), -- missing
			('Country', 8),
			('Site', 9),
			('Sample group', 10),
			-- ('Analysis entity ages', 11), -- missing
			-- ('tbl_sample_group_sampling_contexts', 12), -- missing
			-- ('tbl_data_types', 13), -- missing
			('Loss on ignition', 14),
			('MS', 15)
		) as v(display_title, position) using (display_title)
		where is_applicable = TRUE;

	insert into facet.facet_children (facet_code, child_facet_code, position)
		select 'dendrochronology', facet_code, position
		from facet.facet
		join (values
			('Geochronology', 1),
			('Time periods', 2),
			('Family', 3),
			('Genus', 4),
			('Taxa', 5),
			('Author', 6),
			('Feature type', 7),
			('Bibligraphy modern', 8),
			-- ('Bibligraphy fossil', 9), -- missing
			('Country', 10),
			('Site', 11),
			('Sample group', 12)
			-- ('Analysis entity ages', 19), -- missing
			-- ('tbl_sample_group_sampling_contexts', 20), -- missing
			-- ('tbl_data_types', 21), -- missing
		) as v(display_title, position) using (display_title)
		where is_applicable = TRUE;

	insert into facet.facet_children (facet_code, child_facet_code, position)
		select 'ceramic', facet_code, position
		from facet.facet
		join (values
			('Geochronology', 1),
			('Time periods', 2),
			('Feature type', 7),
			('Bibligraphy modern', 8),
			-- ('Bibligraphy fossil', 9), -- missing
			('Country', 10),
			('Site', 11),
			('Sample group', 12)
			-- ('Analysis entity ages', 19), -- missing
			-- ('tbl_sample_group_sampling_contexts', 20), -- missing
			-- ('tbl_data_types', 21), -- missing
		) as v(display_title, position) using (display_title)
		where is_applicable = TRUE;

end $$;

commit;
