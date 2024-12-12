/*********************************************************************************************************************************
**  Function    populate_clearinghouse_model
**  When        2017-11-06
**  What        Adds data to DB clearing_house specific schema objects
**  Who         Roger Mähler
**  Note
**  Uses
**  Used By     Clearing House server installation. DBA.
**  Revisions
**********************************************************************************************************************************/
-- Select clearing_house.fn_dba_populate_clearing_house_db_model();
Create Or Replace procedure clearing_house.populate_clearinghouse_model() As $$
Begin

    If (Select Count(*) From clearing_house.tbl_clearinghouse_settings) = 0 Then

        Insert Into clearing_house.tbl_clearinghouse_settings (setting_group, setting_key, setting_value, setting_datatype)
            Values
                ('logger', 'folder', '/tmp/', 'string'),
                ('', 'max_execution_time', '120', 'numeric'),
                ('mailer', 'smtp-server', 'mail.acc.umu.se', 'string'),
                ('mailer', 'reply-address', 'noreply@sead.se', 'string'),
                ('mailer', 'sender-name', 'SEAD Clearing House', 'string'),
                ('mailer', 'smtp-auth', 'false', 'bool'),
                ('mailer', 'smtp-username', '', 'string'),
                ('mailer', 'smtp-password', '', 'string'),
                ('signal-templates', 'reject-subject', 'SEAD Clearing House: submission has been rejected', 'string'),
                ('signal-templates', 'reject-body',
'
Your submission to SEAD Clearing House has been rejected!

Reject causes:

#REJECT-CAUSES#

This is an auto-generated mail from the SEAD Clearing House system

', 'string'),

                ('signal-templates', 'reject-cause',
'

Entity type: #ENTITY-TYPE#
Error scope: #ERROR-SCOPE#
Entities: #ENTITY-ID-LIST#
Note:  #ERROR-DESCRIPTION#

--------------------------------------------------------------------

', 'string'),

                ('signal-templates', 'accept-subject', 'SEAD Clearing House: submission has been accepted', 'string'),
                ('signal-templates', 'accept-body',
'

Your submission to SEAD Clearing House has been accepted!

This is an auto-generated mail from the SEAD Clearing House system

', 'string'),

                ('signal-templates', 'reclaim-subject', 'SEAD Clearing House notfication: Submission #SUBMISSION-ID# has been transfered to pending', 'string'),
                ('signal-templates', 'reclaim-body', '

Status of submission #SUBMISSION-ID# has been reset to pending due to inactivity.

A submission is automatically reset to pending status when #DAYS-UNTIL-RECLAIM# days have passed since the submission
was claimed for review, and if no activity during has been registered during last #DAYS-WITHOUT-ACTIVITY# days.

This is an auto-generated mail from the SEAD Clearing House system.

', 'string'),
                ('signal-templates', 'reminder-subject', 'SEAD Clearing House reminder: Submission #SUBMISSION-ID#', 'string'),
                ('signal-templates', 'reminder-body', '

Status of submission #SUBMISSION-ID# has been reset to pending due to inactivity.

A reminder is automatically send when #DAYS-UNTIL-REMINDER# have passed since the submission
was claimed for review.

This is an auto-generated mail from the SEAD Clearing House system.

', 'string'),
                ('reminder', 'days_until_first_reminder', '14', 'numeric'),
                ('reminder', 'days_since_claimed_until_transfer_back_to_pending', '28', 'numeric'),
                ('reminder', 'days_without_activity_until_transfer_back_to_pending', '14', 'numeric');
    End If;

    insert into clearing_house.tbl_clearinghouse_info_references (info_reference_type, display_name, href)
        values
            ('link', 'SEAD overview article',  'http://bugscep.com/phil/publications/Buckland2010_jns.pdf'),
            ('link', 'Popular science description of SEAD aims',  'http://bugscep.com/phil/publications/buckland2011_international_innovation.pdf')
        on conflict do nothing;

    insert into clearing_house.tbl_clearinghouse_use_cases (use_case_id, use_case_name, entity_type_id)
        values  (0, 'General', 0),
                (1, 'Login', 1),
                (2, 'Logout', 1),
                (3, 'Upload submission', 2),
                (4, 'Accept submission', 2),
                (5, 'Reject submission', 2),
                (6, 'Open submission', 2),
                (7, 'Process submission', 2),
                (8, 'Transfer submission', 2),
                (9, 'Add reject cause', 2),
                (10, 'Delete reject cause', 2),
                (11, 'Claim submission', 2),
                (12, 'Unclaim submission', 2),
                (13, 'Execute report', 2),
                (20, 'Add user', 1),
                (21, 'Change user', 1),
                (22, 'Send reminder', 2),
                (23, 'Reclaim submission', 2),
                (24, 'Nag', 0)
        on conflict (use_case_id)
            do update
                set use_case_name = excluded.use_case_name,
                    entity_type_id = excluded.entity_type_id;

    insert into clearing_house.tbl_clearinghouse_data_provider_grades (grade_id, description)
        values (0, 'n/a'), (1, 'Normal'), (2, 'Good'), (3, 'Excellent')
        on conflict (grade_id)
            do update
                set description = excluded.description;

    insert into clearing_house.tbl_clearinghouse_user_roles (role_id, role_name)
        values  (0, 'Undefined'),
                (1, 'Reader'),
                (2, 'Normal'),
                (3, 'Administrator'),
                (4, 'Data Provider')
        on conflict (role_id)
            do update
                set role_name = excluded.role_name;

    Insert Into clearing_house.tbl_clearinghouse_users (user_name, password, full_name, role_id, data_provider_grade_id, create_date, email, signal_receiver)
        Values ('test_reader', '$2y$10$/u3RCeK8Q.2s75UsZmvQ4.4TOxvLNKH8EoH4k6NYYtkAMavjP.dry', 'Test Reader', 1, 0, '2013-10-08', 'roger.mahler@umu.se', false),
                ('test_normal', '$2y$10$/u3RCeK8Q.2s75UsZmvQ4.4TOxvLNKH8EoH4k6NYYtkAMavjP.dry', 'Test Normal', 2, 0, '2013-10-08', 'roger.mahler@umu.se', false),
                ('test_admin', '$2y$10$/u3RCeK8Q.2s75UsZmvQ4.4TOxvLNKH8EoH4k6NYYtkAMavjP.dry', 'Test Administrator', 3, 0, '2013-10-08', 'roger.mahler@umu.se', true),
                ('test_provider', '$2y$10$/u3RCeK8Q.2s75UsZmvQ4.4TOxvLNKH8EoH4k6NYYtkAMavjP.dry', 'Test Provider', 3, 3, '2013-10-08', 'roger.mahler@umu.se', true),
                ('phil_admin', '$2y$10$/u3RCeK8Q.2s75UsZmvQ4.4TOxvLNKH8EoH4k6NYYtkAMavjP.dry', 'Phil Buckland', 3, 3, '2013-10-08', 'phil.buckland@umu.se', true),
                ('mattias_admin', '$2y$10$/u3RCeK8Q.2s75UsZmvQ4.4TOxvLNKH8EoH4k6NYYtkAMavjP.dry', 'Mattias Sjölander', 3, 3, '2013-10-08', 'mattias.sjolander@umu.se', true)
        on conflict do nothing;

    with sead_tables (table_id, table_name, table_name_underscored) as (values
        (1, 'TblSampleTypes', 'tbl_sample_types'),
        (2, 'TblErrorUncertainties', 'tbl_error_uncertainties'),
        (3, 'TblSampleGroupReferences', 'tbl_sample_group_references'),
        (4, 'TblTaxonomyNotes', 'tbl_taxonomy_notes'),
        (5, 'TblPhysicalSampleFeatures', 'tbl_physical_sample_features'),
        (6, 'TblRecordTypes', 'tbl_record_types'),
        (7, 'TblAgeTypes', 'tbl_age_types'),
        (8, 'TblDatasetSubmissions', 'tbl_dataset_submissions'),
        (9, 'TblEcocodeDefinitions', 'tbl_ecocode_definitions'),
        (10, 'TblLocations', 'tbl_locations'),
        (11, 'TblDendroDateNotes', 'tbl_dendro_date_notes'),
        (12, 'TblCeramicsLookup', 'tbl_ceramics_lookup'),
        (13, 'TblTaxonomicOrderBiblio', 'tbl_taxonomic_order_biblio'),
        (14, 'TblTextBiology', 'tbl_text_biology'),
        (15, 'TblTextDistribution', 'tbl_text_distribution'),
        (16, 'TblAnalysisEntityDimensions', 'tbl_analysis_entity_dimensions'),
        (17, 'TblSampleNotes', 'tbl_sample_notes'),
        (18, 'TblSampleGroupDimensions', 'tbl_sample_group_dimensions'),
        (19, 'TblAbundanceElements', 'tbl_abundance_elements'),
        (20, 'TblSampleDescriptionTypes', 'tbl_sample_description_types'),
        (21, 'TblDataTypeGroups', 'tbl_data_type_groups'),
        (22, 'TblUnits', 'tbl_units'),
        (23, 'TblDatasetSubmissionTypes', 'tbl_dataset_submission_types'),
        (24, 'TblAggregateDatasets', 'tbl_aggregate_datasets'),
        (25, 'TblSampleGroupDescriptionTypes', 'tbl_sample_group_description_types'),
        (26, 'TblChronControlTypes', 'tbl_chron_control_types'),
        (27, 'TblSampleLocationTypes', 'tbl_sample_location_types'),
        (28, 'TblDatingMaterial', 'tbl_dating_material'),
        (29, 'TblTaxaMeasuredAttributes', 'tbl_taxa_measured_attributes'),
        (30, 'TblRdb', 'tbl_rdb'),
        (31, 'TblImportedTaxaReplacements', 'tbl_imported_taxa_replacements'),
        (32, 'TblAbundances', 'tbl_abundances'),
        (33, 'TblIdentificationLevels', 'tbl_identification_levels'),
        (34, 'TblContactTypes', 'tbl_contact_types'),
        (35, 'TblTaxonomicOrder', 'tbl_taxonomic_order'),
        (36, 'TblSiteImages', 'tbl_site_images'),
        (37, 'TblEcocodeSystems', 'tbl_ecocode_systems'),
        (38, 'TblTephraRefs', 'tbl_tephra_refs'),
        (39, 'TblTaxaImages', 'tbl_taxa_images'),
        (40, 'TblFeatures', 'tbl_features'),
        (41, 'TblTephraDates', 'tbl_tephra_dates'),
        (42, 'TblActivityTypes', 'tbl_activity_types'),
        (43, 'TblProjects', 'tbl_projects'),
        (44, 'TblDendro', 'tbl_dendro'),
        (45, 'TblMcrNames', 'tbl_mcr_names'),
        (46, 'TblAltRefTypes', 'tbl_alt_ref_types'),
        (47, 'TblIsotopes', 'tbl_isotopes'),
        (48, 'TblMethodGroups', 'tbl_method_groups'),
        (49, 'TblAbundanceModifications', 'tbl_abundance_modifications'),
        (50, 'TblMethods', 'tbl_methods'),
        (51, 'TblDatasetMethods', 'tbl_dataset_methods'),
        (52, 'TblDendroMeasurements', 'tbl_dendro_measurements'),
        (53, 'TblYearsTypes', 'tbl_years_types'),
        (54, 'TblModificationTypes', 'tbl_modification_types'),
        (55, 'TblTaxaReferenceSpecimens', 'tbl_taxa_reference_specimens'),
        (56, 'TblAggregateSamples', 'tbl_aggregate_samples'),
        (57, 'TblSiteLocations', 'tbl_site_locations'),
        (58, 'TblTaxaCommonNames', 'tbl_taxa_common_names'),
        (59, 'TblTaxaTreeGenera', 'tbl_taxa_tree_genera'),
        (60, 'TblTaxaSynonyms', 'tbl_taxa_synonyms'),
        (61, 'TblDatingLabs', 'tbl_dating_labs'),
        (62, 'TblSiteOtherRecords', 'tbl_site_other_records'),
        (63, 'TblSampleGroupCoordinates', 'tbl_sample_group_coordinates'),
        (64, 'TblChronologies', 'tbl_chronologies'),
        (65, 'TblSampleImages', 'tbl_sample_images'),
        (66, 'TblSitePreservationStatus', 'tbl_site_preservation_status'),
        (67, 'TblDatasetMasters', 'tbl_dataset_masters'),
        (68, 'TblSampleGroupSamplingContexts', 'tbl_sample_group_sampling_contexts'),
        (69, 'TblSampleLocations', 'tbl_sample_locations'),
        (70, 'TblSampleCoordinates', 'tbl_sample_coordinates'),
        (71, 'TblIsotopeMeasurements', 'tbl_isotope_measurements'),
        (72, 'TblSampleGroupDescriptionTypeSamplingContexts', 'tbl_sample_group_description_type_sampling_contexts'),
        (73, 'TblImageTypes', 'tbl_image_types'),
        (74, 'TblRdbCodes', 'tbl_rdb_codes'),
        (75, 'TblChronControls', 'tbl_chron_controls'),
        (76, 'TblRdbSystems', 'tbl_rdb_systems'),
        (77, 'TblTephras', 'tbl_tephras'),
        (78, 'TblTaxaTreeFamilies', 'tbl_taxa_tree_families'),
        (79, 'TblPhysicalSamples', 'tbl_physical_samples'),
        (80, 'TblHorizons', 'tbl_horizons'),
        (81, 'TblLithology', 'tbl_lithology'),
        (82, 'TblIsotopeValueSpecifiers', 'tbl_isotope_value_specifiers'),
        (83, 'TblCeramics', 'tbl_ceramics'),
        (84, 'TblSpeciesAssociationTypes', 'tbl_species_association_types'),
        (85, 'TblMeasuredValueDimensions', 'tbl_measured_value_dimensions'),
        (86, 'TblSampleLocationTypeSamplingContexts', 'tbl_sample_location_type_sampling_contexts'),
        (87, 'TblAbundanceIdentLevels', 'tbl_abundance_ident_levels'),
        (88, 'TblProjectStages', 'tbl_project_stages'),
        (89, 'TblLanguages', 'tbl_languages'),
        (90, 'TblSampleGroupNotes', 'tbl_sample_group_notes'),
        (91, 'TblCeramicsMeasurements', 'tbl_ceramics_measurements'),
        (92, 'TblMcrSummaryData', 'tbl_mcr_summary_data'),
        (93, 'TblDatasets', 'tbl_datasets'),
        (94, 'TblSampleHorizons', 'tbl_sample_horizons'),
        (95, 'TblFeatureTypes', 'tbl_feature_types'),
        (96, 'TblIsotopeStandards', 'tbl_isotope_standards'),
        (97, 'TblAnalysisEntityPrepMethods', 'tbl_analysis_entity_prep_methods'),
        (98, 'TblTaxaTreeAuthors', 'tbl_taxa_tree_authors'),
        (99, 'TblEcocodes', 'tbl_ecocodes'),
        (100, 'TblDendroLookup', 'tbl_dendro_lookup'),
        (101, 'TblMcrdataBirmbeetledat', 'tbl_mcrdata_birmbeetledat'),
        (102, 'TblTaxonomicOrderSystems', 'tbl_taxonomic_order_systems'),
        (103, 'TblSampleDimensions', 'tbl_sample_dimensions'),
        (104, 'TblSiteNatgridrefs', 'tbl_site_natgridrefs'),
        (105, 'TblDatingUncertainty', 'tbl_dating_uncertainty'),
        (106, 'TblDendroDates', 'tbl_dendro_dates'),
        (107, 'TblSampleDescriptions', 'tbl_sample_descriptions'),
        (108, 'TblGeochronRefs', 'tbl_geochron_refs'),
        (109, 'TblSampleDescriptionSampleGroupContexts', 'tbl_sample_description_sample_group_contexts'),
        (110, 'TblDimensions', 'tbl_dimensions'),
        (111, 'TblSeasonOrQualifier', 'tbl_season_or_qualifier'),
        (112, 'TblIsotopeTypes', 'tbl_isotope_types'),
        (113, 'TblEcocodeGroups', 'tbl_ecocode_groups'),
        (114, 'TblDatasetContacts', 'tbl_dataset_contacts'),
        (115, 'TblAggregateSampleAges', 'tbl_aggregate_sample_ages'),
        (116, 'TblAggregateOrderTypes', 'tbl_aggregate_order_types'),
        (117, 'TblSeasonTypes', 'tbl_season_types'),
        (118, 'TblAnalysisEntities', 'tbl_analysis_entities'),
        (119, 'TblRelativeAgeTypes', 'tbl_relative_age_types'),
        (120, 'TblAnalysisEntityAges', 'tbl_analysis_entity_ages'),
        (121, 'TblSampleAltRefs', 'tbl_sample_alt_refs'),
        (122, 'TblSampleGroupDescriptions', 'tbl_sample_group_descriptions'),
        (123, 'TblSampleGroups', 'tbl_sample_groups'),
        (124, 'TblCoordinateMethodDimensions', 'tbl_coordinate_method_dimensions'),
        (125, 'TblMeasuredValues', 'tbl_measured_values'),
        (126, 'TblGeochronology', 'tbl_geochronology'),
        (127, 'TblSiteReferences', 'tbl_site_references'),
        (128, 'TblDataTypes', 'tbl_data_types'),
        (129, 'TblSampleColours', 'tbl_sample_colours'),
        (130, 'TblTaxaSeasonality', 'tbl_taxa_seasonality'),
        (131, 'TblRelativeAges', 'tbl_relative_ages'),
        (132, 'TblTextIdentificationKeys', 'tbl_text_identification_keys'),
        (133, 'TblSpeciesAssociations', 'tbl_species_associations'),
        (134, 'TblBiblio', 'tbl_biblio'),
        (135, 'TblTaxaTreeMaster', 'tbl_taxa_tree_master'),
        (136, 'TblRelativeAgeRefs', 'tbl_relative_age_refs'),
        (137, 'TblSampleGroupImages', 'tbl_sample_group_images'),
        (138, 'TblRelativeDates', 'tbl_relative_dates'),
        (139, 'TblContacts', 'tbl_contacts'),
        (140, 'TblSites', 'tbl_sites'),
        (141, 'TblProjectTypes', 'tbl_project_types'),
        (142, 'TblUpdatesLog', 'tbl_updates_log'),
        (143, 'TblColours', 'tbl_colours'),
        (144, 'TblSeasons', 'tbl_seasons'),
        (145, 'TblTaxaTreeOrders', 'tbl_taxa_tree_orders'),
        (146, 'TblLocationTypes', 'tbl_location_types')
    ) insert into clearing_house.tbl_clearinghouse_submission_tables (table_id, table_name, table_name_underscored)
        select table_id, table_name, table_name_underscored
        from sead_tables;

    perform sead_utility.sync_sequences('clearing_house', 'tbl_clearinghouse_submission_tables', 'table_id');

    with sead_tables as (
        Select distinct table_name
        From clearing_house.fn_dba_get_sead_public_db_schema('public', 'sead_master')
    ) insert into clearing_house.tbl_clearinghouse_submission_tables (table_name, table_name_underscored)
        select replace(initcap(replace(table_name, '_', ' ')), ' ', '') , table_name
        from sead_tables
        left join clearing_house.tbl_clearinghouse_submission_tables x
          using (table_name)
        where TRUE
          and table_name Like 'tbl_%'
          and x.table_id is not null;

    insert into clearing_house.tbl_clearinghouse_submission_states (submission_state_id, submission_state_name)
        values	(0, 'Undefined'),
                (1, 'New'),
                (2, 'Pending'),
                (3, 'In progress'),
                (4, 'Accepted'),
                (5, 'Rejected'),
                (9, 'Error')
        on conflict do nothing;

    If (Select Count(*) From clearing_house.tbl_clearinghouse_reject_entity_types) = 0 Then

        Insert Into clearing_house.tbl_clearinghouse_reject_entity_types (entity_type_id, table_id, entity_type)

            Select 0,  0, 'Not specified'
			Union
            Select row_number() over (ORDER BY table_name),  table_id, left(substring(table_name,4),Length(table_name)-4)
            From clearing_house.tbl_clearinghouse_submission_tables
            Where table_name Like 'Tbl%s'
            Order by 1;

        /* Komplettera med nya */
        Insert Into clearing_house.tbl_clearinghouse_reject_entity_types (entity_type_id, table_id, entity_type)

            Select (Select Max(entity_type_id) From clearing_house.tbl_clearinghouse_reject_entity_types) + row_number() over (ORDER BY table_name),  t.table_id, left(substring(table_name,4),Length(table_name)-3)
            From clearing_house.tbl_clearinghouse_submission_tables t
			Left Join clearing_house.tbl_clearinghouse_reject_entity_types x
			  On x.table_id = t.table_id
            Where x.table_id Is Null
            Order by 1;

        /* Fixa beskrivningstext */
        Update clearing_house.tbl_clearinghouse_reject_entity_types as x
			set entity_type = replace(trim(replace(regexp_replace(t.table_name, E'([A-Z])', E'\_\\1','g'), '_', ' ')), 'Tbl ', '')
        From clearing_house.tbl_clearinghouse_submission_tables t
        Where t.table_id = x.table_id
          And replace(trim(replace(regexp_replace(t.table_name, E'([A-Z])', E'\_\\1','g'), '_', ' ')), 'Tbl ', '') <> x.entity_type;

    End If;

    insert into clearing_house.tbl_clearinghouse_reports (report_id, report_name, report_procedure)
        values  ( 1, 'Locations', 'Select * From clearing_house.fn_clearinghouse_report_locations(?)'),
                ( 2, 'Bibliography entries', 'Select * From clearing_house.fn_clearinghouse_report_bibliographic_entries(?)'),
                ( 3, 'Data sets', 'Select * From clearing_house.fn_clearinghouse_report_datasets(?)'),
                ( 4, 'Ecological reference data - Taxonomic order', 'Select * From clearing_house.fn_clearinghouse_report_taxonomic_order(?)'),
                ( 5, 'Taxonomic tree (master)', 'Select * From clearing_house.fn_clearinghouse_report_taxa_tree_master(?)'),
                ( 6, 'Ecological reference data - Taxonomic tree (other)', 'Select * From clearing_house.fn_clearinghouse_report_taxa_other_lists(?)'),
                ( 7, 'Ecological reference data - Taxonomic RGB codes', 'Select * From clearing_house.fn_clearinghouse_report_taxa_rdb(?)'),
                ( 8, 'Ecological reference data - Taxonomic eco-codes', 'Select * From clearing_house.fn_clearinghouse_report_taxa_ecocodes(?)'),
                ( 9, 'Ecological reference data - Taxonomic seasonanlity', 'Select * From clearing_house.fn_clearinghouse_report_taxa_seasonality(?)'),
                (11, 'Relative ages', 'Select * From clearing_house.fn_clearinghouse_report_relative_ages(?)'),
                (12, 'Methods', 'Select * From clearing_house.fn_clearinghouse_report_methods(?)'),
                (13, 'Feature types', 'Select * From clearing_house.fn_clearinghouse_report_feature_types(?)'),
                (14, 'Sample group descriptions', 'Select * From clearing_house.fn_clearinghouse_report_sample_group_descriptions(?)'),
                (15, 'Sample group dimensions', 'Select * From clearing_house.fn_clearinghouse_report_sample_group_dimensions(?)'),
                (16, 'Sample dimensions', 'Select * From clearing_house.fn_clearinghouse_report_sample_dimensions(?)'),
                (17, 'Sample descriptions', 'Select * From clearing_house.fn_clearinghouse_report_sample_descriptions(?)'),
                -- (18, 'Ceramic values', 'Select * From clearing_house.fn_clearinghouse_review_ceramic_values_crosstab(?)')
                (18, 'Analysis values', 'Select * From clearing_house.fn_clearinghouse_review_generic_analysis_lookup_values_crosstab(?, null)')
    on conflict (report_id)
        do update
            set report_name = excluded.report_name,
                report_procedure = excluded.report_procedure;

end $$ language plpgsql;
