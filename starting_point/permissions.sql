--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA public TO humlab_read;


--
-- Name: FUNCTION create_sample_position_view(); Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON FUNCTION public.create_sample_position_view() TO postgres;
GRANT ALL ON FUNCTION public.create_sample_position_view() TO sead_read;


--
-- Name: FUNCTION get_transform_string(method_name character varying, target_srid integer); Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON FUNCTION public.get_transform_string(method_name character varying, target_srid integer) TO postgres;
GRANT ALL ON FUNCTION public.get_transform_string(method_name character varying, target_srid integer) TO sead_read;


--
-- Name: FUNCTION requiredtablestructurechanges(); Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON FUNCTION public.requiredtablestructurechanges() TO postgres;
GRANT ALL ON FUNCTION public.requiredtablestructurechanges() TO sead_read;


--
-- Name: FUNCTION smallbiblioupdates(); Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON FUNCTION public.smallbiblioupdates() TO postgres;
GRANT ALL ON FUNCTION public.smallbiblioupdates() TO sead_read;


--
-- Name: FUNCTION syncsequences(); Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON FUNCTION public.syncsequences() TO postgres;
GRANT ALL ON FUNCTION public.syncsequences() TO sead_read;


--
-- Name: TABLE tbl_abundance_elements; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_abundance_elements TO postgres;
GRANT ALL ON TABLE public.tbl_abundance_elements TO sead_read;
GRANT ALL ON TABLE public.tbl_abundance_elements TO mattias;
GRANT SELECT ON TABLE public.tbl_abundance_elements TO humlab_read;
GRANT SELECT ON TABLE public.tbl_abundance_elements TO johan;


--
-- Name: SEQUENCE tbl_abundance_elements_abundance_element_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_abundance_elements_abundance_element_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_abundance_elements_abundance_element_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_abundance_elements_abundance_element_id_seq TO humlab_read;


--
-- Name: TABLE tbl_abundance_ident_levels; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_abundance_ident_levels TO postgres;
GRANT ALL ON TABLE public.tbl_abundance_ident_levels TO sead_read;
GRANT ALL ON TABLE public.tbl_abundance_ident_levels TO mattias;
GRANT SELECT ON TABLE public.tbl_abundance_ident_levels TO humlab_read;
GRANT SELECT ON TABLE public.tbl_abundance_ident_levels TO johan;


--
-- Name: SEQUENCE tbl_abundance_ident_levels_abundance_ident_level_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_abundance_ident_levels_abundance_ident_level_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_abundance_ident_levels_abundance_ident_level_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_abundance_ident_levels_abundance_ident_level_id_seq TO humlab_read;


--
-- Name: TABLE tbl_abundance_modifications; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_abundance_modifications TO postgres;
GRANT ALL ON TABLE public.tbl_abundance_modifications TO sead_read;
GRANT ALL ON TABLE public.tbl_abundance_modifications TO mattias;
GRANT SELECT ON TABLE public.tbl_abundance_modifications TO humlab_read;
GRANT SELECT ON TABLE public.tbl_abundance_modifications TO johan;


--
-- Name: SEQUENCE tbl_abundance_modifications_abundance_modification_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_abundance_modifications_abundance_modification_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_abundance_modifications_abundance_modification_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_abundance_modifications_abundance_modification_id_seq TO humlab_read;


--
-- Name: TABLE tbl_abundances; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_abundances TO postgres;
GRANT ALL ON TABLE public.tbl_abundances TO sead_read;
GRANT ALL ON TABLE public.tbl_abundances TO mattias;
GRANT SELECT ON TABLE public.tbl_abundances TO humlab_read;
GRANT SELECT ON TABLE public.tbl_abundances TO johan;


--
-- Name: SEQUENCE tbl_abundances_abundance_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_abundances_abundance_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_abundances_abundance_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_abundances_abundance_id_seq TO humlab_read;


--
-- Name: TABLE tbl_activity_types; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_activity_types TO postgres;
GRANT ALL ON TABLE public.tbl_activity_types TO sead_read;
GRANT ALL ON TABLE public.tbl_activity_types TO mattias;
GRANT SELECT ON TABLE public.tbl_activity_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_activity_types TO johan;


--
-- Name: SEQUENCE tbl_activity_types_activity_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_activity_types_activity_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_activity_types_activity_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_activity_types_activity_type_id_seq TO humlab_read;


--
-- Name: TABLE tbl_aggregate_datasets; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_aggregate_datasets TO postgres;
GRANT ALL ON TABLE public.tbl_aggregate_datasets TO sead_read;
GRANT ALL ON TABLE public.tbl_aggregate_datasets TO mattias;
GRANT SELECT ON TABLE public.tbl_aggregate_datasets TO humlab_read;
GRANT SELECT ON TABLE public.tbl_aggregate_datasets TO johan;


--
-- Name: SEQUENCE tbl_aggregate_datasets_aggregate_dataset_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_aggregate_datasets_aggregate_dataset_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_aggregate_datasets_aggregate_dataset_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_aggregate_datasets_aggregate_dataset_id_seq TO humlab_read;


--
-- Name: TABLE tbl_aggregate_order_types; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_aggregate_order_types TO postgres;
GRANT ALL ON TABLE public.tbl_aggregate_order_types TO sead_read;
GRANT ALL ON TABLE public.tbl_aggregate_order_types TO mattias;
GRANT SELECT ON TABLE public.tbl_aggregate_order_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_aggregate_order_types TO johan;


--
-- Name: SEQUENCE tbl_aggregate_order_types_aggregate_order_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_aggregate_order_types_aggregate_order_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_aggregate_order_types_aggregate_order_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_aggregate_order_types_aggregate_order_type_id_seq TO humlab_read;


--
-- Name: TABLE tbl_aggregate_sample_ages; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_aggregate_sample_ages TO postgres;
GRANT ALL ON TABLE public.tbl_aggregate_sample_ages TO sead_read;
GRANT ALL ON TABLE public.tbl_aggregate_sample_ages TO mattias;
GRANT SELECT ON TABLE public.tbl_aggregate_sample_ages TO humlab_read;
GRANT SELECT ON TABLE public.tbl_aggregate_sample_ages TO johan;


--
-- Name: SEQUENCE tbl_aggregate_sample_ages_aggregate_sample_age_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_aggregate_sample_ages_aggregate_sample_age_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_aggregate_sample_ages_aggregate_sample_age_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_aggregate_sample_ages_aggregate_sample_age_id_seq TO humlab_read;


--
-- Name: TABLE tbl_aggregate_samples; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_aggregate_samples TO postgres;
GRANT ALL ON TABLE public.tbl_aggregate_samples TO sead_read;
GRANT ALL ON TABLE public.tbl_aggregate_samples TO mattias;
GRANT SELECT ON TABLE public.tbl_aggregate_samples TO humlab_read;
GRANT SELECT ON TABLE public.tbl_aggregate_samples TO johan;


--
-- Name: SEQUENCE tbl_aggregate_samples_aggregate_sample_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_aggregate_samples_aggregate_sample_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_aggregate_samples_aggregate_sample_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_aggregate_samples_aggregate_sample_id_seq TO humlab_read;


--
-- Name: TABLE tbl_alt_ref_types; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_alt_ref_types TO postgres;
GRANT ALL ON TABLE public.tbl_alt_ref_types TO sead_read;
GRANT ALL ON TABLE public.tbl_alt_ref_types TO mattias;
GRANT SELECT ON TABLE public.tbl_alt_ref_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_alt_ref_types TO johan;


--
-- Name: SEQUENCE tbl_alt_ref_types_alt_ref_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_alt_ref_types_alt_ref_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_alt_ref_types_alt_ref_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_alt_ref_types_alt_ref_type_id_seq TO humlab_read;


--
-- Name: TABLE tbl_analysis_entities; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_analysis_entities TO postgres;
GRANT ALL ON TABLE public.tbl_analysis_entities TO sead_read;
GRANT ALL ON TABLE public.tbl_analysis_entities TO mattias;
GRANT SELECT ON TABLE public.tbl_analysis_entities TO humlab_read;
GRANT SELECT ON TABLE public.tbl_analysis_entities TO johan;


--
-- Name: SEQUENCE tbl_analysis_entities_analysis_entity_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_analysis_entities_analysis_entity_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_analysis_entities_analysis_entity_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_analysis_entities_analysis_entity_id_seq TO humlab_read;


--
-- Name: TABLE tbl_analysis_entity_ages; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_analysis_entity_ages TO postgres;
GRANT ALL ON TABLE public.tbl_analysis_entity_ages TO sead_read;
GRANT ALL ON TABLE public.tbl_analysis_entity_ages TO mattias;
GRANT SELECT ON TABLE public.tbl_analysis_entity_ages TO humlab_read;
GRANT SELECT ON TABLE public.tbl_analysis_entity_ages TO johan;


--
-- Name: SEQUENCE tbl_analysis_entity_ages_analysis_entity_age_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_analysis_entity_ages_analysis_entity_age_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_analysis_entity_ages_analysis_entity_age_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_analysis_entity_ages_analysis_entity_age_id_seq TO humlab_read;


--
-- Name: TABLE tbl_analysis_entity_dimensions; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_analysis_entity_dimensions TO postgres;
GRANT ALL ON TABLE public.tbl_analysis_entity_dimensions TO sead_read;
GRANT ALL ON TABLE public.tbl_analysis_entity_dimensions TO mattias;
GRANT SELECT ON TABLE public.tbl_analysis_entity_dimensions TO humlab_read;
GRANT SELECT ON TABLE public.tbl_analysis_entity_dimensions TO johan;


--
-- Name: SEQUENCE tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_analysis_entity_dimensions_analysis_entity_dimension_id_seq TO humlab_read;


--
-- Name: TABLE tbl_analysis_entity_prep_methods; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_analysis_entity_prep_methods TO postgres;
GRANT ALL ON TABLE public.tbl_analysis_entity_prep_methods TO sead_read;
GRANT ALL ON TABLE public.tbl_analysis_entity_prep_methods TO mattias;
GRANT SELECT ON TABLE public.tbl_analysis_entity_prep_methods TO humlab_read;
GRANT SELECT ON TABLE public.tbl_analysis_entity_prep_methods TO johan;


--
-- Name: SEQUENCE tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_analysis_entity_prep_meth_analysis_entity_prep_method_i_seq TO humlab_read;


--
-- Name: TABLE tbl_species_association_types; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_species_association_types TO postgres;
GRANT ALL ON TABLE public.tbl_species_association_types TO sead_read;
GRANT ALL ON TABLE public.tbl_species_association_types TO mattias;
GRANT SELECT ON TABLE public.tbl_species_association_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_species_association_types TO johan;


--
-- Name: SEQUENCE tbl_association_types_association_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_association_types_association_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_association_types_association_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_association_types_association_type_id_seq TO humlab_read;


--
-- Name: TABLE tbl_biblio; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_biblio TO postgres;
GRANT ALL ON TABLE public.tbl_biblio TO sead_read;
GRANT ALL ON TABLE public.tbl_biblio TO mattias;
GRANT SELECT ON TABLE public.tbl_biblio TO humlab_read;
GRANT SELECT ON TABLE public.tbl_biblio TO johan;


--
-- Name: SEQUENCE tbl_biblio_biblio_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_biblio_biblio_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_biblio_biblio_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_biblio_biblio_id_seq TO humlab_read;


--
-- Name: TABLE tbl_biblio_keywords; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_biblio_keywords TO postgres;
GRANT ALL ON TABLE public.tbl_biblio_keywords TO sead_read;
GRANT ALL ON TABLE public.tbl_biblio_keywords TO mattias;
GRANT SELECT ON TABLE public.tbl_biblio_keywords TO humlab_read;
GRANT SELECT ON TABLE public.tbl_biblio_keywords TO johan;


--
-- Name: SEQUENCE tbl_biblio_keywords_biblio_keyword_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_biblio_keywords_biblio_keyword_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_biblio_keywords_biblio_keyword_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_biblio_keywords_biblio_keyword_id_seq TO humlab_read;


--
-- Name: TABLE tbl_ceramics; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_ceramics TO postgres;
GRANT ALL ON TABLE public.tbl_ceramics TO sead_read;
GRANT ALL ON TABLE public.tbl_ceramics TO mattias;
GRANT SELECT ON TABLE public.tbl_ceramics TO humlab_read;
GRANT SELECT ON TABLE public.tbl_ceramics TO johan;


--
-- Name: SEQUENCE tbl_ceramics_ceramics_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_ceramics_ceramics_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_ceramics_ceramics_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_ceramics_ceramics_id_seq TO humlab_read;


--
-- Name: TABLE tbl_ceramics_measurement_lookup; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_ceramics_measurement_lookup TO postgres;
GRANT ALL ON TABLE public.tbl_ceramics_measurement_lookup TO sead_read;
GRANT ALL ON TABLE public.tbl_ceramics_measurement_lookup TO mattias;
GRANT SELECT ON TABLE public.tbl_ceramics_measurement_lookup TO humlab_read;
GRANT SELECT ON TABLE public.tbl_ceramics_measurement_lookup TO johan;


--
-- Name: SEQUENCE tbl_ceramics_measurement_look_ceramics_measurement_lookup_i_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_ceramics_measurement_look_ceramics_measurement_lookup_i_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_ceramics_measurement_look_ceramics_measurement_lookup_i_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_ceramics_measurement_look_ceramics_measurement_lookup_i_seq TO humlab_read;


--
-- Name: TABLE tbl_ceramics_measurements; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_ceramics_measurements TO postgres;
GRANT ALL ON TABLE public.tbl_ceramics_measurements TO sead_read;
GRANT ALL ON TABLE public.tbl_ceramics_measurements TO mattias;
GRANT SELECT ON TABLE public.tbl_ceramics_measurements TO humlab_read;
GRANT SELECT ON TABLE public.tbl_ceramics_measurements TO johan;


--
-- Name: SEQUENCE tbl_ceramics_measurements_ceramics_measurement_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_ceramics_measurements_ceramics_measurement_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_ceramics_measurements_ceramics_measurement_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_ceramics_measurements_ceramics_measurement_id_seq TO humlab_read;


--
-- Name: TABLE tbl_chron_control_types; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_chron_control_types TO postgres;
GRANT ALL ON TABLE public.tbl_chron_control_types TO sead_read;
GRANT ALL ON TABLE public.tbl_chron_control_types TO mattias;
GRANT SELECT ON TABLE public.tbl_chron_control_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_chron_control_types TO johan;


--
-- Name: SEQUENCE tbl_chron_control_types_chron_control_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_chron_control_types_chron_control_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_chron_control_types_chron_control_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_chron_control_types_chron_control_type_id_seq TO humlab_read;


--
-- Name: TABLE tbl_chron_controls; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_chron_controls TO postgres;
GRANT ALL ON TABLE public.tbl_chron_controls TO sead_read;
GRANT ALL ON TABLE public.tbl_chron_controls TO mattias;
GRANT SELECT ON TABLE public.tbl_chron_controls TO humlab_read;
GRANT SELECT ON TABLE public.tbl_chron_controls TO johan;


--
-- Name: SEQUENCE tbl_chron_controls_chron_control_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_chron_controls_chron_control_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_chron_controls_chron_control_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_chron_controls_chron_control_id_seq TO humlab_read;


--
-- Name: TABLE tbl_chronologies; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_chronologies TO postgres;
GRANT ALL ON TABLE public.tbl_chronologies TO sead_read;
GRANT ALL ON TABLE public.tbl_chronologies TO mattias;
GRANT SELECT ON TABLE public.tbl_chronologies TO humlab_read;
GRANT SELECT ON TABLE public.tbl_chronologies TO johan;


--
-- Name: SEQUENCE tbl_chronologies_chronology_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_chronologies_chronology_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_chronologies_chronology_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_chronologies_chronology_id_seq TO humlab_read;


--
-- Name: TABLE tbl_collections_or_journals; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_collections_or_journals TO postgres;
GRANT ALL ON TABLE public.tbl_collections_or_journals TO sead_read;
GRANT ALL ON TABLE public.tbl_collections_or_journals TO mattias;
GRANT SELECT ON TABLE public.tbl_collections_or_journals TO humlab_read;
GRANT SELECT ON TABLE public.tbl_collections_or_journals TO johan;


--
-- Name: SEQUENCE tbl_collections_or_journals_collection_or_journal_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_collections_or_journals_collection_or_journal_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_collections_or_journals_collection_or_journal_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_collections_or_journals_collection_or_journal_id_seq TO humlab_read;


--
-- Name: TABLE tbl_colours; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_colours TO postgres;
GRANT ALL ON TABLE public.tbl_colours TO sead_read;
GRANT ALL ON TABLE public.tbl_colours TO mattias;
GRANT SELECT ON TABLE public.tbl_colours TO humlab_read;
GRANT SELECT ON TABLE public.tbl_colours TO johan;


--
-- Name: SEQUENCE tbl_colours_colour_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_colours_colour_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_colours_colour_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_colours_colour_id_seq TO humlab_read;


--
-- Name: TABLE tbl_contact_types; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_contact_types TO postgres;
GRANT ALL ON TABLE public.tbl_contact_types TO sead_read;
GRANT ALL ON TABLE public.tbl_contact_types TO mattias;
GRANT SELECT ON TABLE public.tbl_contact_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_contact_types TO johan;


--
-- Name: SEQUENCE tbl_contact_types_contact_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_contact_types_contact_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_contact_types_contact_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_contact_types_contact_type_id_seq TO humlab_read;


--
-- Name: TABLE tbl_contacts; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_contacts TO postgres;
GRANT ALL ON TABLE public.tbl_contacts TO sead_read;
GRANT ALL ON TABLE public.tbl_contacts TO mattias;
GRANT SELECT ON TABLE public.tbl_contacts TO humlab_read;
GRANT SELECT ON TABLE public.tbl_contacts TO johan;


--
-- Name: SEQUENCE tbl_contacts_contact_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_contacts_contact_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_contacts_contact_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_contacts_contact_id_seq TO humlab_read;


--
-- Name: TABLE tbl_coordinate_method_dimensions; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_coordinate_method_dimensions TO postgres;
GRANT ALL ON TABLE public.tbl_coordinate_method_dimensions TO sead_read;
GRANT ALL ON TABLE public.tbl_coordinate_method_dimensions TO mattias;
GRANT SELECT ON TABLE public.tbl_coordinate_method_dimensions TO humlab_read;
GRANT SELECT ON TABLE public.tbl_coordinate_method_dimensions TO johan;


--
-- Name: SEQUENCE tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_coordinate_method_dimensi_coordinate_method_dimension_i_seq TO humlab_read;


--
-- Name: TABLE tbl_data_type_groups; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_data_type_groups TO postgres;
GRANT ALL ON TABLE public.tbl_data_type_groups TO sead_read;
GRANT ALL ON TABLE public.tbl_data_type_groups TO mattias;
GRANT SELECT ON TABLE public.tbl_data_type_groups TO humlab_read;
GRANT SELECT ON TABLE public.tbl_data_type_groups TO johan;


--
-- Name: SEQUENCE tbl_data_type_groups_data_type_group_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_data_type_groups_data_type_group_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_data_type_groups_data_type_group_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_data_type_groups_data_type_group_id_seq TO humlab_read;


--
-- Name: TABLE tbl_data_types; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_data_types TO postgres;
GRANT ALL ON TABLE public.tbl_data_types TO sead_read;
GRANT ALL ON TABLE public.tbl_data_types TO mattias;
GRANT SELECT ON TABLE public.tbl_data_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_data_types TO johan;


--
-- Name: SEQUENCE tbl_data_types_data_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_data_types_data_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_data_types_data_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_data_types_data_type_id_seq TO humlab_read;


--
-- Name: TABLE tbl_dataset_contacts; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_dataset_contacts TO postgres;
GRANT ALL ON TABLE public.tbl_dataset_contacts TO sead_read;
GRANT ALL ON TABLE public.tbl_dataset_contacts TO mattias;
GRANT SELECT ON TABLE public.tbl_dataset_contacts TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dataset_contacts TO johan;


--
-- Name: SEQUENCE tbl_dataset_contacts_dataset_contact_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_dataset_contacts_dataset_contact_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dataset_contacts_dataset_contact_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dataset_contacts_dataset_contact_id_seq TO humlab_read;


--
-- Name: TABLE tbl_dataset_masters; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_dataset_masters TO postgres;
GRANT ALL ON TABLE public.tbl_dataset_masters TO sead_read;
GRANT ALL ON TABLE public.tbl_dataset_masters TO mattias;
GRANT SELECT ON TABLE public.tbl_dataset_masters TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dataset_masters TO johan;


--
-- Name: SEQUENCE tbl_dataset_masters_master_set_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_dataset_masters_master_set_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dataset_masters_master_set_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dataset_masters_master_set_id_seq TO humlab_read;


--
-- Name: TABLE tbl_dataset_submission_types; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_dataset_submission_types TO postgres;
GRANT ALL ON TABLE public.tbl_dataset_submission_types TO sead_read;
GRANT ALL ON TABLE public.tbl_dataset_submission_types TO mattias;
GRANT SELECT ON TABLE public.tbl_dataset_submission_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dataset_submission_types TO johan;


--
-- Name: SEQUENCE tbl_dataset_submission_types_submission_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_dataset_submission_types_submission_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dataset_submission_types_submission_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dataset_submission_types_submission_type_id_seq TO humlab_read;


--
-- Name: TABLE tbl_dataset_submissions; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_dataset_submissions TO postgres;
GRANT ALL ON TABLE public.tbl_dataset_submissions TO sead_read;
GRANT ALL ON TABLE public.tbl_dataset_submissions TO mattias;
GRANT SELECT ON TABLE public.tbl_dataset_submissions TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dataset_submissions TO johan;


--
-- Name: SEQUENCE tbl_dataset_submissions_dataset_submission_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_dataset_submissions_dataset_submission_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dataset_submissions_dataset_submission_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dataset_submissions_dataset_submission_id_seq TO humlab_read;


--
-- Name: TABLE tbl_datasets; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_datasets TO postgres;
GRANT ALL ON TABLE public.tbl_datasets TO sead_read;
GRANT ALL ON TABLE public.tbl_datasets TO mattias;
GRANT SELECT ON TABLE public.tbl_datasets TO humlab_read;
GRANT SELECT ON TABLE public.tbl_datasets TO johan;


--
-- Name: SEQUENCE tbl_datasets_dataset_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_datasets_dataset_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_datasets_dataset_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_datasets_dataset_id_seq TO humlab_read;


--
-- Name: TABLE tbl_dating_labs; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_dating_labs TO postgres;
GRANT ALL ON TABLE public.tbl_dating_labs TO sead_read;
GRANT ALL ON TABLE public.tbl_dating_labs TO mattias;
GRANT SELECT ON TABLE public.tbl_dating_labs TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dating_labs TO johan;


--
-- Name: SEQUENCE tbl_dating_labs_dating_lab_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_dating_labs_dating_lab_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dating_labs_dating_lab_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dating_labs_dating_lab_id_seq TO humlab_read;


--
-- Name: TABLE tbl_dating_material; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_dating_material TO postgres;
GRANT ALL ON TABLE public.tbl_dating_material TO sead_read;
GRANT ALL ON TABLE public.tbl_dating_material TO mattias;
GRANT SELECT ON TABLE public.tbl_dating_material TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dating_material TO johan;


--
-- Name: SEQUENCE tbl_dating_material_dating_material_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_dating_material_dating_material_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dating_material_dating_material_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dating_material_dating_material_id_seq TO humlab_read;


--
-- Name: TABLE tbl_dating_uncertainty; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_dating_uncertainty TO postgres;
GRANT ALL ON TABLE public.tbl_dating_uncertainty TO sead_read;
GRANT ALL ON TABLE public.tbl_dating_uncertainty TO mattias;
GRANT SELECT ON TABLE public.tbl_dating_uncertainty TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dating_uncertainty TO johan;


--
-- Name: SEQUENCE tbl_dating_uncertainty_dating_uncertainty_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_dating_uncertainty_dating_uncertainty_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dating_uncertainty_dating_uncertainty_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dating_uncertainty_dating_uncertainty_id_seq TO humlab_read;


--
-- Name: TABLE tbl_dendro; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_dendro TO postgres;
GRANT ALL ON TABLE public.tbl_dendro TO sead_read;
GRANT ALL ON TABLE public.tbl_dendro TO mattias;
GRANT SELECT ON TABLE public.tbl_dendro TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dendro TO johan;


--
-- Name: TABLE tbl_dendro_date_notes; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_dendro_date_notes TO postgres;
GRANT ALL ON TABLE public.tbl_dendro_date_notes TO sead_read;
GRANT ALL ON TABLE public.tbl_dendro_date_notes TO mattias;
GRANT SELECT ON TABLE public.tbl_dendro_date_notes TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dendro_date_notes TO johan;


--
-- Name: SEQUENCE tbl_dendro_date_notes_dendro_date_note_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_dendro_date_notes_dendro_date_note_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dendro_date_notes_dendro_date_note_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dendro_date_notes_dendro_date_note_id_seq TO humlab_read;


--
-- Name: TABLE tbl_dendro_dates; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_dendro_dates TO postgres;
GRANT ALL ON TABLE public.tbl_dendro_dates TO sead_read;
GRANT ALL ON TABLE public.tbl_dendro_dates TO mattias;
GRANT SELECT ON TABLE public.tbl_dendro_dates TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dendro_dates TO johan;


--
-- Name: SEQUENCE tbl_dendro_dates_dendro_date_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_dendro_dates_dendro_date_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dendro_dates_dendro_date_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dendro_dates_dendro_date_id_seq TO humlab_read;


--
-- Name: SEQUENCE tbl_dendro_dendro_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_dendro_dendro_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dendro_dendro_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dendro_dendro_id_seq TO humlab_read;


--
-- Name: TABLE tbl_dendro_measurement_lookup; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_dendro_measurement_lookup TO postgres;
GRANT ALL ON TABLE public.tbl_dendro_measurement_lookup TO sead_read;
GRANT ALL ON TABLE public.tbl_dendro_measurement_lookup TO mattias;
GRANT SELECT ON TABLE public.tbl_dendro_measurement_lookup TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dendro_measurement_lookup TO johan;


--
-- Name: SEQUENCE tbl_dendro_measurement_lookup_dendro_measurement_lookup_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_dendro_measurement_lookup_dendro_measurement_lookup_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dendro_measurement_lookup_dendro_measurement_lookup_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dendro_measurement_lookup_dendro_measurement_lookup_id_seq TO humlab_read;


--
-- Name: TABLE tbl_dendro_measurements; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_dendro_measurements TO postgres;
GRANT ALL ON TABLE public.tbl_dendro_measurements TO sead_read;
GRANT ALL ON TABLE public.tbl_dendro_measurements TO mattias;
GRANT SELECT ON TABLE public.tbl_dendro_measurements TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dendro_measurements TO johan;


--
-- Name: SEQUENCE tbl_dendro_measurements_dendro_measurement_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_dendro_measurements_dendro_measurement_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dendro_measurements_dendro_measurement_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dendro_measurements_dendro_measurement_id_seq TO humlab_read;


--
-- Name: TABLE tbl_dimensions; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_dimensions TO postgres;
GRANT ALL ON TABLE public.tbl_dimensions TO sead_read;
GRANT ALL ON TABLE public.tbl_dimensions TO mattias;
GRANT SELECT ON TABLE public.tbl_dimensions TO humlab_read;
GRANT SELECT ON TABLE public.tbl_dimensions TO johan;


--
-- Name: SEQUENCE tbl_dimensions_dimension_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_dimensions_dimension_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_dimensions_dimension_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_dimensions_dimension_id_seq TO humlab_read;


--
-- Name: TABLE tbl_ecocode_definitions; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_ecocode_definitions TO postgres;
GRANT ALL ON TABLE public.tbl_ecocode_definitions TO sead_read;
GRANT ALL ON TABLE public.tbl_ecocode_definitions TO mattias;
GRANT SELECT ON TABLE public.tbl_ecocode_definitions TO humlab_read;
GRANT SELECT ON TABLE public.tbl_ecocode_definitions TO johan;


--
-- Name: SEQUENCE tbl_ecocode_definitions_ecocode_definition_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_ecocode_definitions_ecocode_definition_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_ecocode_definitions_ecocode_definition_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_ecocode_definitions_ecocode_definition_id_seq TO humlab_read;


--
-- Name: TABLE tbl_ecocode_groups; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_ecocode_groups TO postgres;
GRANT ALL ON TABLE public.tbl_ecocode_groups TO sead_read;
GRANT ALL ON TABLE public.tbl_ecocode_groups TO mattias;
GRANT SELECT ON TABLE public.tbl_ecocode_groups TO humlab_read;
GRANT SELECT ON TABLE public.tbl_ecocode_groups TO johan;


--
-- Name: SEQUENCE tbl_ecocode_groups_ecocode_group_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_ecocode_groups_ecocode_group_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_ecocode_groups_ecocode_group_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_ecocode_groups_ecocode_group_id_seq TO humlab_read;


--
-- Name: TABLE tbl_ecocode_systems; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_ecocode_systems TO postgres;
GRANT ALL ON TABLE public.tbl_ecocode_systems TO sead_read;
GRANT ALL ON TABLE public.tbl_ecocode_systems TO mattias;
GRANT SELECT ON TABLE public.tbl_ecocode_systems TO humlab_read;
GRANT SELECT ON TABLE public.tbl_ecocode_systems TO johan;


--
-- Name: SEQUENCE tbl_ecocode_systems_ecocode_system_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_ecocode_systems_ecocode_system_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_ecocode_systems_ecocode_system_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_ecocode_systems_ecocode_system_id_seq TO humlab_read;


--
-- Name: TABLE tbl_ecocodes; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_ecocodes TO postgres;
GRANT ALL ON TABLE public.tbl_ecocodes TO sead_read;
GRANT ALL ON TABLE public.tbl_ecocodes TO mattias;
GRANT SELECT ON TABLE public.tbl_ecocodes TO humlab_read;
GRANT SELECT ON TABLE public.tbl_ecocodes TO johan;


--
-- Name: SEQUENCE tbl_ecocodes_ecocode_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_ecocodes_ecocode_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_ecocodes_ecocode_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_ecocodes_ecocode_id_seq TO humlab_read;


--
-- Name: TABLE tbl_feature_types; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_feature_types TO postgres;
GRANT ALL ON TABLE public.tbl_feature_types TO sead_read;
GRANT ALL ON TABLE public.tbl_feature_types TO mattias;
GRANT SELECT ON TABLE public.tbl_feature_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_feature_types TO johan;


--
-- Name: SEQUENCE tbl_feature_types_feature_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_feature_types_feature_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_feature_types_feature_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_feature_types_feature_type_id_seq TO humlab_read;


--
-- Name: TABLE tbl_features; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_features TO postgres;
GRANT ALL ON TABLE public.tbl_features TO sead_read;
GRANT ALL ON TABLE public.tbl_features TO mattias;
GRANT SELECT ON TABLE public.tbl_features TO humlab_read;
GRANT SELECT ON TABLE public.tbl_features TO johan;


--
-- Name: SEQUENCE tbl_features_feature_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_features_feature_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_features_feature_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_features_feature_id_seq TO humlab_read;


--
-- Name: TABLE tbl_geochron_refs; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_geochron_refs TO postgres;
GRANT ALL ON TABLE public.tbl_geochron_refs TO sead_read;
GRANT ALL ON TABLE public.tbl_geochron_refs TO mattias;
GRANT SELECT ON TABLE public.tbl_geochron_refs TO humlab_read;
GRANT SELECT ON TABLE public.tbl_geochron_refs TO johan;


--
-- Name: SEQUENCE tbl_geochron_refs_geochron_ref_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_geochron_refs_geochron_ref_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_geochron_refs_geochron_ref_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_geochron_refs_geochron_ref_id_seq TO humlab_read;


--
-- Name: TABLE tbl_geochronology; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_geochronology TO postgres;
GRANT ALL ON TABLE public.tbl_geochronology TO sead_read;
GRANT ALL ON TABLE public.tbl_geochronology TO mattias;
GRANT SELECT ON TABLE public.tbl_geochronology TO humlab_read;
GRANT SELECT ON TABLE public.tbl_geochronology TO johan;


--
-- Name: SEQUENCE tbl_geochronology_geochron_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_geochronology_geochron_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_geochronology_geochron_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_geochronology_geochron_id_seq TO humlab_read;


--
-- Name: TABLE tbl_horizons; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_horizons TO postgres;
GRANT ALL ON TABLE public.tbl_horizons TO sead_read;
GRANT ALL ON TABLE public.tbl_horizons TO mattias;
GRANT SELECT ON TABLE public.tbl_horizons TO humlab_read;
GRANT SELECT ON TABLE public.tbl_horizons TO johan;


--
-- Name: SEQUENCE tbl_horizons_horizon_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_horizons_horizon_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_horizons_horizon_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_horizons_horizon_id_seq TO humlab_read;


--
-- Name: TABLE tbl_identification_levels; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_identification_levels TO postgres;
GRANT ALL ON TABLE public.tbl_identification_levels TO sead_read;
GRANT ALL ON TABLE public.tbl_identification_levels TO mattias;
GRANT SELECT ON TABLE public.tbl_identification_levels TO humlab_read;
GRANT SELECT ON TABLE public.tbl_identification_levels TO johan;


--
-- Name: SEQUENCE tbl_identification_levels_identification_level_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_identification_levels_identification_level_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_identification_levels_identification_level_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_identification_levels_identification_level_id_seq TO humlab_read;


--
-- Name: TABLE tbl_image_types; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_image_types TO postgres;
GRANT ALL ON TABLE public.tbl_image_types TO sead_read;
GRANT ALL ON TABLE public.tbl_image_types TO mattias;
GRANT SELECT ON TABLE public.tbl_image_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_image_types TO johan;


--
-- Name: SEQUENCE tbl_image_types_image_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_image_types_image_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_image_types_image_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_image_types_image_type_id_seq TO humlab_read;


--
-- Name: TABLE tbl_imported_taxa_replacements; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_imported_taxa_replacements TO postgres;
GRANT ALL ON TABLE public.tbl_imported_taxa_replacements TO sead_read;
GRANT ALL ON TABLE public.tbl_imported_taxa_replacements TO mattias;
GRANT SELECT ON TABLE public.tbl_imported_taxa_replacements TO humlab_read;
GRANT SELECT ON TABLE public.tbl_imported_taxa_replacements TO johan;


--
-- Name: SEQUENCE tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_imported_taxa_replacements_imported_taxa_replacement_id_seq TO humlab_read;


--
-- Name: TABLE tbl_keywords; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_keywords TO postgres;
GRANT ALL ON TABLE public.tbl_keywords TO sead_read;
GRANT ALL ON TABLE public.tbl_keywords TO mattias;
GRANT SELECT ON TABLE public.tbl_keywords TO humlab_read;
GRANT SELECT ON TABLE public.tbl_keywords TO johan;


--
-- Name: SEQUENCE tbl_keywords_keyword_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_keywords_keyword_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_keywords_keyword_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_keywords_keyword_id_seq TO humlab_read;


--
-- Name: TABLE tbl_languages; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_languages TO postgres;
GRANT ALL ON TABLE public.tbl_languages TO sead_read;
GRANT ALL ON TABLE public.tbl_languages TO mattias;
GRANT SELECT ON TABLE public.tbl_languages TO humlab_read;
GRANT SELECT ON TABLE public.tbl_languages TO johan;


--
-- Name: SEQUENCE tbl_languages_language_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_languages_language_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_languages_language_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_languages_language_id_seq TO humlab_read;


--
-- Name: TABLE tbl_lithology; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_lithology TO postgres;
GRANT ALL ON TABLE public.tbl_lithology TO sead_read;
GRANT ALL ON TABLE public.tbl_lithology TO mattias;
GRANT SELECT ON TABLE public.tbl_lithology TO humlab_read;
GRANT SELECT ON TABLE public.tbl_lithology TO johan;


--
-- Name: SEQUENCE tbl_lithology_lithology_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_lithology_lithology_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_lithology_lithology_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_lithology_lithology_id_seq TO humlab_read;


--
-- Name: TABLE tbl_location_types; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_location_types TO postgres;
GRANT ALL ON TABLE public.tbl_location_types TO sead_read;
GRANT ALL ON TABLE public.tbl_location_types TO mattias;
GRANT SELECT ON TABLE public.tbl_location_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_location_types TO johan;


--
-- Name: SEQUENCE tbl_location_types_location_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_location_types_location_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_location_types_location_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_location_types_location_type_id_seq TO humlab_read;


--
-- Name: TABLE tbl_locations; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_locations TO postgres;
GRANT ALL ON TABLE public.tbl_locations TO sead_read;
GRANT ALL ON TABLE public.tbl_locations TO mattias;
GRANT SELECT ON TABLE public.tbl_locations TO humlab_read;
GRANT SELECT ON TABLE public.tbl_locations TO johan;


--
-- Name: SEQUENCE tbl_locations_location_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_locations_location_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_locations_location_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_locations_location_id_seq TO humlab_read;


--
-- Name: TABLE tbl_mcr_names; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_mcr_names TO postgres;
GRANT ALL ON TABLE public.tbl_mcr_names TO sead_read;
GRANT ALL ON TABLE public.tbl_mcr_names TO mattias;
GRANT SELECT ON TABLE public.tbl_mcr_names TO humlab_read;
GRANT SELECT ON TABLE public.tbl_mcr_names TO johan;


--
-- Name: SEQUENCE tbl_mcr_names_taxon_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_mcr_names_taxon_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_mcr_names_taxon_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_mcr_names_taxon_id_seq TO humlab_read;


--
-- Name: TABLE tbl_mcr_summary_data; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_mcr_summary_data TO postgres;
GRANT ALL ON TABLE public.tbl_mcr_summary_data TO sead_read;
GRANT ALL ON TABLE public.tbl_mcr_summary_data TO mattias;
GRANT SELECT ON TABLE public.tbl_mcr_summary_data TO humlab_read;
GRANT SELECT ON TABLE public.tbl_mcr_summary_data TO johan;


--
-- Name: SEQUENCE tbl_mcr_summary_data_mcr_summary_data_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_mcr_summary_data_mcr_summary_data_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_mcr_summary_data_mcr_summary_data_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_mcr_summary_data_mcr_summary_data_id_seq TO humlab_read;


--
-- Name: TABLE tbl_mcrdata_birmbeetledat; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_mcrdata_birmbeetledat TO postgres;
GRANT ALL ON TABLE public.tbl_mcrdata_birmbeetledat TO sead_read;
GRANT ALL ON TABLE public.tbl_mcrdata_birmbeetledat TO mattias;
GRANT SELECT ON TABLE public.tbl_mcrdata_birmbeetledat TO humlab_read;
GRANT SELECT ON TABLE public.tbl_mcrdata_birmbeetledat TO johan;


--
-- Name: SEQUENCE tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_mcrdata_birmbeetledat_mcrdata_birmbeetledat_id_seq TO humlab_read;


--
-- Name: TABLE tbl_measured_value_dimensions; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_measured_value_dimensions TO postgres;
GRANT ALL ON TABLE public.tbl_measured_value_dimensions TO sead_read;
GRANT ALL ON TABLE public.tbl_measured_value_dimensions TO mattias;
GRANT SELECT ON TABLE public.tbl_measured_value_dimensions TO humlab_read;
GRANT SELECT ON TABLE public.tbl_measured_value_dimensions TO johan;


--
-- Name: SEQUENCE tbl_measured_value_dimensions_measured_value_dimension_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_measured_value_dimensions_measured_value_dimension_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_measured_value_dimensions_measured_value_dimension_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_measured_value_dimensions_measured_value_dimension_id_seq TO humlab_read;


--
-- Name: TABLE tbl_measured_values; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_measured_values TO postgres;
GRANT ALL ON TABLE public.tbl_measured_values TO sead_read;
GRANT ALL ON TABLE public.tbl_measured_values TO mattias;
GRANT SELECT ON TABLE public.tbl_measured_values TO humlab_read;
GRANT SELECT ON TABLE public.tbl_measured_values TO johan;


--
-- Name: SEQUENCE tbl_measured_values_measured_value_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_measured_values_measured_value_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_measured_values_measured_value_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_measured_values_measured_value_id_seq TO humlab_read;


--
-- Name: TABLE tbl_method_groups; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_method_groups TO postgres;
GRANT ALL ON TABLE public.tbl_method_groups TO sead_read;
GRANT ALL ON TABLE public.tbl_method_groups TO mattias;
GRANT SELECT ON TABLE public.tbl_method_groups TO humlab_read;
GRANT SELECT ON TABLE public.tbl_method_groups TO johan;


--
-- Name: SEQUENCE tbl_method_groups_method_group_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_method_groups_method_group_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_method_groups_method_group_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_method_groups_method_group_id_seq TO humlab_read;


--
-- Name: TABLE tbl_methods; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_methods TO postgres;
GRANT ALL ON TABLE public.tbl_methods TO sead_read;
GRANT ALL ON TABLE public.tbl_methods TO mattias;
GRANT SELECT ON TABLE public.tbl_methods TO humlab_read;
GRANT SELECT ON TABLE public.tbl_methods TO johan;


--
-- Name: SEQUENCE tbl_methods_method_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_methods_method_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_methods_method_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_methods_method_id_seq TO humlab_read;


--
-- Name: TABLE tbl_modification_types; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_modification_types TO postgres;
GRANT ALL ON TABLE public.tbl_modification_types TO sead_read;
GRANT ALL ON TABLE public.tbl_modification_types TO mattias;
GRANT SELECT ON TABLE public.tbl_modification_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_modification_types TO johan;


--
-- Name: SEQUENCE tbl_modification_types_modification_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_modification_types_modification_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_modification_types_modification_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_modification_types_modification_type_id_seq TO humlab_read;


--
-- Name: TABLE tbl_physical_sample_features; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_physical_sample_features TO postgres;
GRANT ALL ON TABLE public.tbl_physical_sample_features TO sead_read;
GRANT ALL ON TABLE public.tbl_physical_sample_features TO mattias;
GRANT SELECT ON TABLE public.tbl_physical_sample_features TO humlab_read;
GRANT SELECT ON TABLE public.tbl_physical_sample_features TO johan;


--
-- Name: SEQUENCE tbl_physical_sample_features_physical_sample_feature_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_physical_sample_features_physical_sample_feature_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_physical_sample_features_physical_sample_feature_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_physical_sample_features_physical_sample_feature_id_seq TO humlab_read;


--
-- Name: TABLE tbl_physical_samples; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_physical_samples TO postgres;
GRANT ALL ON TABLE public.tbl_physical_samples TO sead_read;
GRANT ALL ON TABLE public.tbl_physical_samples TO mattias;
GRANT SELECT ON TABLE public.tbl_physical_samples TO humlab_read;
GRANT SELECT ON TABLE public.tbl_physical_samples TO johan;


--
-- Name: SEQUENCE tbl_physical_samples_physical_sample_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_physical_samples_physical_sample_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_physical_samples_physical_sample_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_physical_samples_physical_sample_id_seq TO humlab_read;


--
-- Name: TABLE tbl_project_stages; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_project_stages TO postgres;
GRANT ALL ON TABLE public.tbl_project_stages TO sead_read;
GRANT ALL ON TABLE public.tbl_project_stages TO mattias;
GRANT SELECT ON TABLE public.tbl_project_stages TO humlab_read;
GRANT SELECT ON TABLE public.tbl_project_stages TO johan;


--
-- Name: SEQUENCE tbl_project_stage_project_stage_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_project_stage_project_stage_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_project_stage_project_stage_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_project_stage_project_stage_id_seq TO humlab_read;


--
-- Name: TABLE tbl_project_types; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_project_types TO postgres;
GRANT ALL ON TABLE public.tbl_project_types TO sead_read;
GRANT ALL ON TABLE public.tbl_project_types TO mattias;
GRANT SELECT ON TABLE public.tbl_project_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_project_types TO johan;


--
-- Name: SEQUENCE tbl_project_types_project_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_project_types_project_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_project_types_project_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_project_types_project_type_id_seq TO humlab_read;


--
-- Name: TABLE tbl_projects; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_projects TO postgres;
GRANT ALL ON TABLE public.tbl_projects TO sead_read;
GRANT ALL ON TABLE public.tbl_projects TO mattias;
GRANT SELECT ON TABLE public.tbl_projects TO humlab_read;
GRANT SELECT ON TABLE public.tbl_projects TO johan;


--
-- Name: SEQUENCE tbl_projects_project_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_projects_project_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_projects_project_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_projects_project_id_seq TO humlab_read;


--
-- Name: TABLE tbl_publication_types; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_publication_types TO postgres;
GRANT ALL ON TABLE public.tbl_publication_types TO sead_read;
GRANT ALL ON TABLE public.tbl_publication_types TO mattias;
GRANT SELECT ON TABLE public.tbl_publication_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_publication_types TO johan;


--
-- Name: SEQUENCE tbl_publication_types_publication_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_publication_types_publication_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_publication_types_publication_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_publication_types_publication_type_id_seq TO humlab_read;


--
-- Name: TABLE tbl_publishers; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_publishers TO postgres;
GRANT ALL ON TABLE public.tbl_publishers TO sead_read;
GRANT ALL ON TABLE public.tbl_publishers TO mattias;
GRANT SELECT ON TABLE public.tbl_publishers TO humlab_read;
GRANT SELECT ON TABLE public.tbl_publishers TO johan;


--
-- Name: SEQUENCE tbl_publishers_publisher_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_publishers_publisher_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_publishers_publisher_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_publishers_publisher_id_seq TO humlab_read;


--
-- Name: TABLE tbl_radiocarbon_calibration; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_radiocarbon_calibration TO postgres;
GRANT ALL ON TABLE public.tbl_radiocarbon_calibration TO sead_read;
GRANT ALL ON TABLE public.tbl_radiocarbon_calibration TO mattias;
GRANT SELECT ON TABLE public.tbl_radiocarbon_calibration TO humlab_read;
GRANT SELECT ON TABLE public.tbl_radiocarbon_calibration TO johan;


--
-- Name: SEQUENCE tbl_radiocarbon_calibration_radiocarbon_calibration_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_radiocarbon_calibration_radiocarbon_calibration_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_radiocarbon_calibration_radiocarbon_calibration_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_radiocarbon_calibration_radiocarbon_calibration_id_seq TO humlab_read;


--
-- Name: TABLE tbl_rdb; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_rdb TO postgres;
GRANT ALL ON TABLE public.tbl_rdb TO sead_read;
GRANT ALL ON TABLE public.tbl_rdb TO mattias;
GRANT SELECT ON TABLE public.tbl_rdb TO humlab_read;
GRANT SELECT ON TABLE public.tbl_rdb TO johan;


--
-- Name: TABLE tbl_rdb_codes; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_rdb_codes TO postgres;
GRANT ALL ON TABLE public.tbl_rdb_codes TO sead_read;
GRANT ALL ON TABLE public.tbl_rdb_codes TO mattias;
GRANT SELECT ON TABLE public.tbl_rdb_codes TO humlab_read;
GRANT SELECT ON TABLE public.tbl_rdb_codes TO johan;


--
-- Name: SEQUENCE tbl_rdb_codes_rdb_code_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_rdb_codes_rdb_code_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_rdb_codes_rdb_code_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_rdb_codes_rdb_code_id_seq TO humlab_read;


--
-- Name: SEQUENCE tbl_rdb_rdb_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_rdb_rdb_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_rdb_rdb_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_rdb_rdb_id_seq TO humlab_read;


--
-- Name: TABLE tbl_rdb_systems; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_rdb_systems TO postgres;
GRANT ALL ON TABLE public.tbl_rdb_systems TO sead_read;
GRANT ALL ON TABLE public.tbl_rdb_systems TO mattias;
GRANT SELECT ON TABLE public.tbl_rdb_systems TO humlab_read;
GRANT SELECT ON TABLE public.tbl_rdb_systems TO johan;


--
-- Name: SEQUENCE tbl_rdb_systems_rdb_system_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_rdb_systems_rdb_system_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_rdb_systems_rdb_system_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_rdb_systems_rdb_system_id_seq TO humlab_read;


--
-- Name: TABLE tbl_record_types; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_record_types TO postgres;
GRANT ALL ON TABLE public.tbl_record_types TO sead_read;
GRANT ALL ON TABLE public.tbl_record_types TO mattias;
GRANT SELECT ON TABLE public.tbl_record_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_record_types TO johan;


--
-- Name: SEQUENCE tbl_record_types_record_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_record_types_record_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_record_types_record_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_record_types_record_type_id_seq TO humlab_read;


--
-- Name: TABLE tbl_relative_age_refs; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_relative_age_refs TO postgres;
GRANT ALL ON TABLE public.tbl_relative_age_refs TO sead_read;
GRANT ALL ON TABLE public.tbl_relative_age_refs TO mattias;
GRANT SELECT ON TABLE public.tbl_relative_age_refs TO humlab_read;
GRANT SELECT ON TABLE public.tbl_relative_age_refs TO johan;


--
-- Name: SEQUENCE tbl_relative_age_refs_relative_age_ref_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_relative_age_refs_relative_age_ref_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_relative_age_refs_relative_age_ref_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_relative_age_refs_relative_age_ref_id_seq TO humlab_read;


--
-- Name: TABLE tbl_relative_age_types; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_relative_age_types TO postgres;
GRANT ALL ON TABLE public.tbl_relative_age_types TO sead_read;
GRANT ALL ON TABLE public.tbl_relative_age_types TO mattias;
GRANT SELECT ON TABLE public.tbl_relative_age_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_relative_age_types TO johan;


--
-- Name: SEQUENCE tbl_relative_age_types_relative_age_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_relative_age_types_relative_age_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_relative_age_types_relative_age_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_relative_age_types_relative_age_type_id_seq TO humlab_read;


--
-- Name: TABLE tbl_relative_ages; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_relative_ages TO postgres;
GRANT ALL ON TABLE public.tbl_relative_ages TO sead_read;
GRANT ALL ON TABLE public.tbl_relative_ages TO mattias;
GRANT SELECT ON TABLE public.tbl_relative_ages TO humlab_read;
GRANT SELECT ON TABLE public.tbl_relative_ages TO johan;


--
-- Name: SEQUENCE tbl_relative_ages_relative_age_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_relative_ages_relative_age_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_relative_ages_relative_age_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_relative_ages_relative_age_id_seq TO humlab_read;


--
-- Name: TABLE tbl_relative_dates; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_relative_dates TO postgres;
GRANT ALL ON TABLE public.tbl_relative_dates TO sead_read;
GRANT ALL ON TABLE public.tbl_relative_dates TO mattias;
GRANT SELECT ON TABLE public.tbl_relative_dates TO humlab_read;
GRANT SELECT ON TABLE public.tbl_relative_dates TO johan;


--
-- Name: SEQUENCE tbl_relative_dates_relative_date_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_relative_dates_relative_date_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_relative_dates_relative_date_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_relative_dates_relative_date_id_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_alt_refs; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_alt_refs TO postgres;
GRANT ALL ON TABLE public.tbl_sample_alt_refs TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_alt_refs TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_alt_refs TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_alt_refs TO johan;


--
-- Name: SEQUENCE tbl_sample_alt_refs_sample_alt_ref_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_alt_refs_sample_alt_ref_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_alt_refs_sample_alt_ref_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_alt_refs_sample_alt_ref_id_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_colours; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_colours TO postgres;
GRANT ALL ON TABLE public.tbl_sample_colours TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_colours TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_colours TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_colours TO johan;


--
-- Name: SEQUENCE tbl_sample_colours_sample_colour_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_colours_sample_colour_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_colours_sample_colour_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_colours_sample_colour_id_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_coordinates; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_coordinates TO postgres;
GRANT ALL ON TABLE public.tbl_sample_coordinates TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_coordinates TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_coordinates TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_coordinates TO johan;


--
-- Name: SEQUENCE tbl_sample_coordinates_sample_coordinates_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_coordinates_sample_coordinates_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_coordinates_sample_coordinates_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_coordinates_sample_coordinates_id_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_description_sample_group_contexts; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_description_sample_group_contexts TO postgres;
GRANT ALL ON TABLE public.tbl_sample_description_sample_group_contexts TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_description_sample_group_contexts TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_description_sample_group_contexts TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_description_sample_group_contexts TO johan;


--
-- Name: SEQUENCE tbl_sample_description_sample_sample_description_sample_gro_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_description_sample_sample_description_sample_gro_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_description_sample_sample_description_sample_gro_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_description_sample_sample_description_sample_gro_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_description_types; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_description_types TO postgres;
GRANT ALL ON TABLE public.tbl_sample_description_types TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_description_types TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_description_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_description_types TO johan;


--
-- Name: SEQUENCE tbl_sample_description_types_sample_description_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_description_types_sample_description_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_description_types_sample_description_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_description_types_sample_description_type_id_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_descriptions; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_descriptions TO postgres;
GRANT ALL ON TABLE public.tbl_sample_descriptions TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_descriptions TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_descriptions TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_descriptions TO johan;


--
-- Name: SEQUENCE tbl_sample_descriptions_sample_description_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_descriptions_sample_description_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_descriptions_sample_description_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_descriptions_sample_description_id_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_dimensions; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_dimensions TO postgres;
GRANT ALL ON TABLE public.tbl_sample_dimensions TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_dimensions TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_dimensions TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_dimensions TO johan;


--
-- Name: SEQUENCE tbl_sample_dimensions_sample_dimension_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_dimensions_sample_dimension_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_dimensions_sample_dimension_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_dimensions_sample_dimension_id_seq TO humlab_read;


--
-- Name: SEQUENCE tbl_sample_geometry_sample_geometry_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_geometry_sample_geometry_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_geometry_sample_geometry_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_geometry_sample_geometry_id_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_group_coordinates; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_group_coordinates TO postgres;
GRANT ALL ON TABLE public.tbl_sample_group_coordinates TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_group_coordinates TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_group_coordinates TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_group_coordinates TO johan;


--
-- Name: SEQUENCE tbl_sample_group_coordinates_sample_group_position_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_group_coordinates_sample_group_position_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_group_coordinates_sample_group_position_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_group_coordinates_sample_group_position_id_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_group_description_type_sampling_contexts; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_group_description_type_sampling_contexts TO postgres;
GRANT ALL ON TABLE public.tbl_sample_group_description_type_sampling_contexts TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_group_description_type_sampling_contexts TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_group_description_type_sampling_contexts TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_group_description_type_sampling_contexts TO johan;


--
-- Name: SEQUENCE tbl_sample_group_description__sample_group_desciption_sampl_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_group_description__sample_group_desciption_sampl_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_group_description__sample_group_desciption_sampl_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_group_description__sample_group_desciption_sampl_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_group_description_types; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_group_description_types TO postgres;
GRANT ALL ON TABLE public.tbl_sample_group_description_types TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_group_description_types TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_group_description_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_group_description_types TO johan;


--
-- Name: SEQUENCE tbl_sample_group_description__sample_group_description_type_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_group_description__sample_group_description_type_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_group_description__sample_group_description_type_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_group_description__sample_group_description_type_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_group_descriptions; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_group_descriptions TO postgres;
GRANT ALL ON TABLE public.tbl_sample_group_descriptions TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_group_descriptions TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_group_descriptions TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_group_descriptions TO johan;


--
-- Name: SEQUENCE tbl_sample_group_descriptions_sample_group_description_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_group_descriptions_sample_group_description_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_group_descriptions_sample_group_description_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_group_descriptions_sample_group_description_id_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_group_dimensions; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_group_dimensions TO postgres;
GRANT ALL ON TABLE public.tbl_sample_group_dimensions TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_group_dimensions TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_group_dimensions TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_group_dimensions TO johan;


--
-- Name: SEQUENCE tbl_sample_group_dimensions_sample_group_dimension_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_group_dimensions_sample_group_dimension_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_group_dimensions_sample_group_dimension_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_group_dimensions_sample_group_dimension_id_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_group_images; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_group_images TO postgres;
GRANT ALL ON TABLE public.tbl_sample_group_images TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_group_images TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_group_images TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_group_images TO johan;


--
-- Name: SEQUENCE tbl_sample_group_images_sample_group_image_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_group_images_sample_group_image_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_group_images_sample_group_image_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_group_images_sample_group_image_id_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_group_notes; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_group_notes TO postgres;
GRANT ALL ON TABLE public.tbl_sample_group_notes TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_group_notes TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_group_notes TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_group_notes TO johan;


--
-- Name: SEQUENCE tbl_sample_group_notes_sample_group_note_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_group_notes_sample_group_note_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_group_notes_sample_group_note_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_group_notes_sample_group_note_id_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_group_references; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_group_references TO postgres;
GRANT ALL ON TABLE public.tbl_sample_group_references TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_group_references TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_group_references TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_group_references TO johan;


--
-- Name: SEQUENCE tbl_sample_group_references_sample_group_reference_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_group_references_sample_group_reference_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_group_references_sample_group_reference_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_group_references_sample_group_reference_id_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_group_sampling_contexts; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_group_sampling_contexts TO postgres;
GRANT ALL ON TABLE public.tbl_sample_group_sampling_contexts TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_group_sampling_contexts TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_group_sampling_contexts TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_group_sampling_contexts TO johan;


--
-- Name: SEQUENCE tbl_sample_group_sampling_contexts_sampling_context_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_group_sampling_contexts_sampling_context_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_group_sampling_contexts_sampling_context_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_group_sampling_contexts_sampling_context_id_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_groups; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_groups TO postgres;
GRANT ALL ON TABLE public.tbl_sample_groups TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_groups TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_groups TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_groups TO johan;


--
-- Name: SEQUENCE tbl_sample_groups_sample_group_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_groups_sample_group_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_groups_sample_group_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_groups_sample_group_id_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_horizons; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_horizons TO postgres;
GRANT ALL ON TABLE public.tbl_sample_horizons TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_horizons TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_horizons TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_horizons TO johan;


--
-- Name: SEQUENCE tbl_sample_horizons_sample_horizon_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_horizons_sample_horizon_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_horizons_sample_horizon_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_horizons_sample_horizon_id_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_images; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_images TO postgres;
GRANT ALL ON TABLE public.tbl_sample_images TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_images TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_images TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_images TO johan;


--
-- Name: SEQUENCE tbl_sample_images_sample_image_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_images_sample_image_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_images_sample_image_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_images_sample_image_id_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_location_type_sampling_contexts; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_location_type_sampling_contexts TO postgres;
GRANT ALL ON TABLE public.tbl_sample_location_type_sampling_contexts TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_location_type_sampling_contexts TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_location_type_sampling_contexts TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_location_type_sampling_contexts TO johan;


--
-- Name: SEQUENCE tbl_sample_location_sampling__sample_location_type_sampling_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_location_sampling__sample_location_type_sampling_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_location_sampling__sample_location_type_sampling_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_location_sampling__sample_location_type_sampling_seq TO humlab_read;


--
-- Name: SEQUENCE tbl_sample_location_sampling_contex_sample_location_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_location_sampling_contex_sample_location_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_location_sampling_contex_sample_location_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_location_sampling_contex_sample_location_type_id_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_location_types; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_location_types TO postgres;
GRANT ALL ON TABLE public.tbl_sample_location_types TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_location_types TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_location_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_location_types TO johan;


--
-- Name: SEQUENCE tbl_sample_location_types_sample_location_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_location_types_sample_location_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_location_types_sample_location_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_location_types_sample_location_type_id_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_locations; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_locations TO postgres;
GRANT ALL ON TABLE public.tbl_sample_locations TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_locations TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_locations TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_locations TO johan;


--
-- Name: SEQUENCE tbl_sample_locations_sample_location_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_locations_sample_location_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_locations_sample_location_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_locations_sample_location_id_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_notes; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_notes TO postgres;
GRANT ALL ON TABLE public.tbl_sample_notes TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_notes TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_notes TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_notes TO johan;


--
-- Name: SEQUENCE tbl_sample_notes_sample_note_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_notes_sample_note_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_notes_sample_note_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_notes_sample_note_id_seq TO humlab_read;


--
-- Name: TABLE tbl_sample_types; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sample_types TO postgres;
GRANT ALL ON TABLE public.tbl_sample_types TO sead_read;
GRANT ALL ON TABLE public.tbl_sample_types TO mattias;
GRANT SELECT ON TABLE public.tbl_sample_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sample_types TO johan;


--
-- Name: SEQUENCE tbl_sample_types_sample_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sample_types_sample_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sample_types_sample_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sample_types_sample_type_id_seq TO humlab_read;


--
-- Name: TABLE tbl_season_types; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_season_types TO postgres;
GRANT ALL ON TABLE public.tbl_season_types TO sead_read;
GRANT ALL ON TABLE public.tbl_season_types TO mattias;
GRANT SELECT ON TABLE public.tbl_season_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_season_types TO johan;


--
-- Name: SEQUENCE tbl_season_types_season_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_season_types_season_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_season_types_season_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_season_types_season_type_id_seq TO humlab_read;


--
-- Name: TABLE tbl_seasons; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_seasons TO postgres;
GRANT ALL ON TABLE public.tbl_seasons TO sead_read;
GRANT ALL ON TABLE public.tbl_seasons TO mattias;
GRANT SELECT ON TABLE public.tbl_seasons TO humlab_read;
GRANT SELECT ON TABLE public.tbl_seasons TO johan;


--
-- Name: SEQUENCE tbl_seasons_season_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_seasons_season_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_seasons_season_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_seasons_season_id_seq TO humlab_read;


--
-- Name: TABLE tbl_site_images; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_site_images TO postgres;
GRANT ALL ON TABLE public.tbl_site_images TO sead_read;
GRANT ALL ON TABLE public.tbl_site_images TO mattias;
GRANT SELECT ON TABLE public.tbl_site_images TO humlab_read;
GRANT SELECT ON TABLE public.tbl_site_images TO johan;


--
-- Name: SEQUENCE tbl_site_images_site_image_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_site_images_site_image_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_site_images_site_image_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_site_images_site_image_id_seq TO humlab_read;


--
-- Name: TABLE tbl_site_locations; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_site_locations TO postgres;
GRANT ALL ON TABLE public.tbl_site_locations TO sead_read;
GRANT ALL ON TABLE public.tbl_site_locations TO mattias;
GRANT SELECT ON TABLE public.tbl_site_locations TO humlab_read;
GRANT SELECT ON TABLE public.tbl_site_locations TO johan;


--
-- Name: SEQUENCE tbl_site_locations_site_location_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_site_locations_site_location_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_site_locations_site_location_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_site_locations_site_location_id_seq TO humlab_read;


--
-- Name: TABLE tbl_site_natgridrefs; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_site_natgridrefs TO postgres;
GRANT ALL ON TABLE public.tbl_site_natgridrefs TO sead_read;
GRANT ALL ON TABLE public.tbl_site_natgridrefs TO mattias;
GRANT SELECT ON TABLE public.tbl_site_natgridrefs TO humlab_read;
GRANT SELECT ON TABLE public.tbl_site_natgridrefs TO johan;


--
-- Name: SEQUENCE tbl_site_natgridrefs_site_natgridref_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_site_natgridrefs_site_natgridref_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_site_natgridrefs_site_natgridref_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_site_natgridrefs_site_natgridref_id_seq TO humlab_read;


--
-- Name: TABLE tbl_site_other_records; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_site_other_records TO postgres;
GRANT ALL ON TABLE public.tbl_site_other_records TO sead_read;
GRANT ALL ON TABLE public.tbl_site_other_records TO mattias;
GRANT SELECT ON TABLE public.tbl_site_other_records TO humlab_read;
GRANT SELECT ON TABLE public.tbl_site_other_records TO johan;


--
-- Name: SEQUENCE tbl_site_other_records_site_other_records_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_site_other_records_site_other_records_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_site_other_records_site_other_records_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_site_other_records_site_other_records_id_seq TO humlab_read;


--
-- Name: TABLE tbl_site_preservation_status; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_site_preservation_status TO postgres;
GRANT ALL ON TABLE public.tbl_site_preservation_status TO sead_read;
GRANT ALL ON TABLE public.tbl_site_preservation_status TO mattias;
GRANT SELECT ON TABLE public.tbl_site_preservation_status TO humlab_read;
GRANT SELECT ON TABLE public.tbl_site_preservation_status TO johan;


--
-- Name: SEQUENCE tbl_site_preservation_status_site_preservation_status_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_site_preservation_status_site_preservation_status_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_site_preservation_status_site_preservation_status_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_site_preservation_status_site_preservation_status_id_seq TO humlab_read;


--
-- Name: TABLE tbl_site_references; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_site_references TO postgres;
GRANT ALL ON TABLE public.tbl_site_references TO sead_read;
GRANT ALL ON TABLE public.tbl_site_references TO mattias;
GRANT SELECT ON TABLE public.tbl_site_references TO humlab_read;
GRANT SELECT ON TABLE public.tbl_site_references TO johan;


--
-- Name: SEQUENCE tbl_site_references_site_reference_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_site_references_site_reference_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_site_references_site_reference_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_site_references_site_reference_id_seq TO humlab_read;


--
-- Name: TABLE tbl_sites; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_sites TO postgres;
GRANT ALL ON TABLE public.tbl_sites TO sead_read;
GRANT ALL ON TABLE public.tbl_sites TO mattias;
GRANT SELECT ON TABLE public.tbl_sites TO humlab_read;
GRANT SELECT ON TABLE public.tbl_sites TO johan;


--
-- Name: SEQUENCE tbl_sites_site_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_sites_site_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_sites_site_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_sites_site_id_seq TO humlab_read;


--
-- Name: TABLE tbl_species_associations; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_species_associations TO postgres;
GRANT ALL ON TABLE public.tbl_species_associations TO sead_read;
GRANT ALL ON TABLE public.tbl_species_associations TO mattias;
GRANT SELECT ON TABLE public.tbl_species_associations TO humlab_read;
GRANT SELECT ON TABLE public.tbl_species_associations TO johan;


--
-- Name: SEQUENCE tbl_species_associations_species_association_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_species_associations_species_association_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_species_associations_species_association_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_species_associations_species_association_id_seq TO humlab_read;


--
-- Name: TABLE tbl_taxa_common_names; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_taxa_common_names TO postgres;
GRANT ALL ON TABLE public.tbl_taxa_common_names TO sead_read;
GRANT ALL ON TABLE public.tbl_taxa_common_names TO mattias;
GRANT SELECT ON TABLE public.tbl_taxa_common_names TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxa_common_names TO johan;


--
-- Name: SEQUENCE tbl_taxa_common_names_taxon_common_name_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_taxa_common_names_taxon_common_name_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxa_common_names_taxon_common_name_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxa_common_names_taxon_common_name_id_seq TO humlab_read;


--
-- Name: TABLE tbl_taxa_images; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_taxa_images TO postgres;
GRANT ALL ON TABLE public.tbl_taxa_images TO sead_read;
GRANT ALL ON TABLE public.tbl_taxa_images TO mattias;
GRANT SELECT ON TABLE public.tbl_taxa_images TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxa_images TO johan;


--
-- Name: SEQUENCE tbl_taxa_images_taxa_images_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_taxa_images_taxa_images_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxa_images_taxa_images_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxa_images_taxa_images_id_seq TO humlab_read;


--
-- Name: TABLE tbl_taxa_measured_attributes; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_taxa_measured_attributes TO postgres;
GRANT ALL ON TABLE public.tbl_taxa_measured_attributes TO sead_read;
GRANT ALL ON TABLE public.tbl_taxa_measured_attributes TO mattias;
GRANT SELECT ON TABLE public.tbl_taxa_measured_attributes TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxa_measured_attributes TO johan;


--
-- Name: SEQUENCE tbl_taxa_measured_attributes_measured_attribute_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_taxa_measured_attributes_measured_attribute_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxa_measured_attributes_measured_attribute_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxa_measured_attributes_measured_attribute_id_seq TO humlab_read;


--
-- Name: TABLE tbl_taxa_reference_specimens; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_taxa_reference_specimens TO postgres;
GRANT ALL ON TABLE public.tbl_taxa_reference_specimens TO sead_read;
GRANT ALL ON TABLE public.tbl_taxa_reference_specimens TO mattias;
GRANT SELECT ON TABLE public.tbl_taxa_reference_specimens TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxa_reference_specimens TO johan;


--
-- Name: SEQUENCE tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxa_reference_specimens_taxa_reference_specimen_id_seq TO humlab_read;


--
-- Name: TABLE tbl_taxa_seasonality; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_taxa_seasonality TO postgres;
GRANT ALL ON TABLE public.tbl_taxa_seasonality TO sead_read;
GRANT ALL ON TABLE public.tbl_taxa_seasonality TO mattias;
GRANT SELECT ON TABLE public.tbl_taxa_seasonality TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxa_seasonality TO johan;


--
-- Name: SEQUENCE tbl_taxa_seasonality_seasonality_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_taxa_seasonality_seasonality_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxa_seasonality_seasonality_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxa_seasonality_seasonality_id_seq TO humlab_read;


--
-- Name: TABLE tbl_taxa_synonyms; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_taxa_synonyms TO postgres;
GRANT ALL ON TABLE public.tbl_taxa_synonyms TO sead_read;
GRANT ALL ON TABLE public.tbl_taxa_synonyms TO mattias;
GRANT SELECT ON TABLE public.tbl_taxa_synonyms TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxa_synonyms TO johan;


--
-- Name: SEQUENCE tbl_taxa_synonyms_synonym_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_taxa_synonyms_synonym_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxa_synonyms_synonym_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxa_synonyms_synonym_id_seq TO humlab_read;


--
-- Name: TABLE tbl_taxa_tree_authors; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_taxa_tree_authors TO postgres;
GRANT ALL ON TABLE public.tbl_taxa_tree_authors TO sead_read;
GRANT ALL ON TABLE public.tbl_taxa_tree_authors TO mattias;
GRANT SELECT ON TABLE public.tbl_taxa_tree_authors TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxa_tree_authors TO johan;


--
-- Name: SEQUENCE tbl_taxa_tree_authors_author_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_taxa_tree_authors_author_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxa_tree_authors_author_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxa_tree_authors_author_id_seq TO humlab_read;


--
-- Name: TABLE tbl_taxa_tree_families; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_taxa_tree_families TO postgres;
GRANT ALL ON TABLE public.tbl_taxa_tree_families TO sead_read;
GRANT ALL ON TABLE public.tbl_taxa_tree_families TO mattias;
GRANT SELECT ON TABLE public.tbl_taxa_tree_families TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxa_tree_families TO johan;


--
-- Name: SEQUENCE tbl_taxa_tree_families_family_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_taxa_tree_families_family_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxa_tree_families_family_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxa_tree_families_family_id_seq TO humlab_read;


--
-- Name: TABLE tbl_taxa_tree_genera; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_taxa_tree_genera TO postgres;
GRANT ALL ON TABLE public.tbl_taxa_tree_genera TO sead_read;
GRANT ALL ON TABLE public.tbl_taxa_tree_genera TO mattias;
GRANT SELECT ON TABLE public.tbl_taxa_tree_genera TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxa_tree_genera TO johan;


--
-- Name: SEQUENCE tbl_taxa_tree_genera_genus_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_taxa_tree_genera_genus_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxa_tree_genera_genus_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxa_tree_genera_genus_id_seq TO humlab_read;


--
-- Name: TABLE tbl_taxa_tree_master; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_taxa_tree_master TO postgres;
GRANT ALL ON TABLE public.tbl_taxa_tree_master TO sead_read;
GRANT ALL ON TABLE public.tbl_taxa_tree_master TO mattias;
GRANT SELECT ON TABLE public.tbl_taxa_tree_master TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxa_tree_master TO johan;


--
-- Name: SEQUENCE tbl_taxa_tree_master_taxon_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_taxa_tree_master_taxon_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxa_tree_master_taxon_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxa_tree_master_taxon_id_seq TO humlab_read;


--
-- Name: TABLE tbl_taxa_tree_orders; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_taxa_tree_orders TO postgres;
GRANT ALL ON TABLE public.tbl_taxa_tree_orders TO sead_read;
GRANT ALL ON TABLE public.tbl_taxa_tree_orders TO mattias;
GRANT SELECT ON TABLE public.tbl_taxa_tree_orders TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxa_tree_orders TO johan;


--
-- Name: SEQUENCE tbl_taxa_tree_orders_order_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_taxa_tree_orders_order_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxa_tree_orders_order_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxa_tree_orders_order_id_seq TO humlab_read;


--
-- Name: TABLE tbl_taxonomic_order; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_taxonomic_order TO postgres;
GRANT ALL ON TABLE public.tbl_taxonomic_order TO sead_read;
GRANT ALL ON TABLE public.tbl_taxonomic_order TO mattias;
GRANT SELECT ON TABLE public.tbl_taxonomic_order TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxonomic_order TO johan;


--
-- Name: TABLE tbl_taxonomic_order_biblio; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_taxonomic_order_biblio TO postgres;
GRANT ALL ON TABLE public.tbl_taxonomic_order_biblio TO sead_read;
GRANT ALL ON TABLE public.tbl_taxonomic_order_biblio TO mattias;
GRANT SELECT ON TABLE public.tbl_taxonomic_order_biblio TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxonomic_order_biblio TO johan;


--
-- Name: SEQUENCE tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxonomic_order_biblio_taxonomic_order_biblio_id_seq TO humlab_read;


--
-- Name: TABLE tbl_taxonomic_order_systems; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_taxonomic_order_systems TO postgres;
GRANT ALL ON TABLE public.tbl_taxonomic_order_systems TO sead_read;
GRANT ALL ON TABLE public.tbl_taxonomic_order_systems TO mattias;
GRANT SELECT ON TABLE public.tbl_taxonomic_order_systems TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxonomic_order_systems TO johan;


--
-- Name: SEQUENCE tbl_taxonomic_order_systems_taxonomic_order_system_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_taxonomic_order_systems_taxonomic_order_system_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxonomic_order_systems_taxonomic_order_system_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxonomic_order_systems_taxonomic_order_system_id_seq TO humlab_read;


--
-- Name: SEQUENCE tbl_taxonomic_order_taxonomic_order_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_taxonomic_order_taxonomic_order_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxonomic_order_taxonomic_order_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxonomic_order_taxonomic_order_id_seq TO humlab_read;


--
-- Name: TABLE tbl_taxonomy_notes; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_taxonomy_notes TO postgres;
GRANT ALL ON TABLE public.tbl_taxonomy_notes TO sead_read;
GRANT ALL ON TABLE public.tbl_taxonomy_notes TO mattias;
GRANT SELECT ON TABLE public.tbl_taxonomy_notes TO humlab_read;
GRANT SELECT ON TABLE public.tbl_taxonomy_notes TO johan;


--
-- Name: SEQUENCE tbl_taxonomy_notes_taxonomy_notes_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_taxonomy_notes_taxonomy_notes_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_taxonomy_notes_taxonomy_notes_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_taxonomy_notes_taxonomy_notes_id_seq TO humlab_read;


--
-- Name: TABLE tbl_tephra_dates; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_tephra_dates TO postgres;
GRANT ALL ON TABLE public.tbl_tephra_dates TO sead_read;
GRANT ALL ON TABLE public.tbl_tephra_dates TO mattias;
GRANT SELECT ON TABLE public.tbl_tephra_dates TO humlab_read;
GRANT SELECT ON TABLE public.tbl_tephra_dates TO johan;


--
-- Name: SEQUENCE tbl_tephra_dates_tephra_date_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_tephra_dates_tephra_date_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_tephra_dates_tephra_date_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_tephra_dates_tephra_date_id_seq TO humlab_read;


--
-- Name: TABLE tbl_tephra_refs; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_tephra_refs TO postgres;
GRANT ALL ON TABLE public.tbl_tephra_refs TO sead_read;
GRANT ALL ON TABLE public.tbl_tephra_refs TO mattias;
GRANT SELECT ON TABLE public.tbl_tephra_refs TO humlab_read;
GRANT SELECT ON TABLE public.tbl_tephra_refs TO johan;


--
-- Name: SEQUENCE tbl_tephra_refs_tephra_ref_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_tephra_refs_tephra_ref_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_tephra_refs_tephra_ref_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_tephra_refs_tephra_ref_id_seq TO humlab_read;


--
-- Name: TABLE tbl_tephras; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_tephras TO postgres;
GRANT ALL ON TABLE public.tbl_tephras TO sead_read;
GRANT ALL ON TABLE public.tbl_tephras TO mattias;
GRANT SELECT ON TABLE public.tbl_tephras TO humlab_read;
GRANT SELECT ON TABLE public.tbl_tephras TO johan;


--
-- Name: SEQUENCE tbl_tephras_tephra_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_tephras_tephra_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_tephras_tephra_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_tephras_tephra_id_seq TO humlab_read;


--
-- Name: TABLE tbl_text_biology; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_text_biology TO postgres;
GRANT ALL ON TABLE public.tbl_text_biology TO sead_read;
GRANT ALL ON TABLE public.tbl_text_biology TO mattias;
GRANT SELECT ON TABLE public.tbl_text_biology TO humlab_read;
GRANT SELECT ON TABLE public.tbl_text_biology TO johan;


--
-- Name: SEQUENCE tbl_text_biology_biology_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_text_biology_biology_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_text_biology_biology_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_text_biology_biology_id_seq TO humlab_read;


--
-- Name: TABLE tbl_text_distribution; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_text_distribution TO postgres;
GRANT ALL ON TABLE public.tbl_text_distribution TO sead_read;
GRANT ALL ON TABLE public.tbl_text_distribution TO mattias;
GRANT SELECT ON TABLE public.tbl_text_distribution TO humlab_read;
GRANT SELECT ON TABLE public.tbl_text_distribution TO johan;


--
-- Name: SEQUENCE tbl_text_distribution_distribution_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_text_distribution_distribution_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_text_distribution_distribution_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_text_distribution_distribution_id_seq TO humlab_read;


--
-- Name: TABLE tbl_text_identification_keys; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_text_identification_keys TO postgres;
GRANT ALL ON TABLE public.tbl_text_identification_keys TO sead_read;
GRANT ALL ON TABLE public.tbl_text_identification_keys TO mattias;
GRANT SELECT ON TABLE public.tbl_text_identification_keys TO humlab_read;
GRANT SELECT ON TABLE public.tbl_text_identification_keys TO johan;


--
-- Name: SEQUENCE tbl_text_identification_keys_key_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_text_identification_keys_key_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_text_identification_keys_key_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_text_identification_keys_key_id_seq TO humlab_read;


--
-- Name: TABLE tbl_units; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_units TO postgres;
GRANT ALL ON TABLE public.tbl_units TO sead_read;
GRANT ALL ON TABLE public.tbl_units TO mattias;
GRANT SELECT ON TABLE public.tbl_units TO humlab_read;
GRANT SELECT ON TABLE public.tbl_units TO johan;


--
-- Name: SEQUENCE tbl_units_unit_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_units_unit_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_units_unit_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_units_unit_id_seq TO humlab_read;


--
-- Name: TABLE tbl_updates_log; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_updates_log TO postgres;
GRANT ALL ON TABLE public.tbl_updates_log TO sead_read;
GRANT ALL ON TABLE public.tbl_updates_log TO mattias;
GRANT SELECT ON TABLE public.tbl_updates_log TO humlab_read;
GRANT SELECT ON TABLE public.tbl_updates_log TO johan;


--
-- Name: TABLE tbl_years_types; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.tbl_years_types TO postgres;
GRANT ALL ON TABLE public.tbl_years_types TO sead_read;
GRANT ALL ON TABLE public.tbl_years_types TO mattias;
GRANT SELECT ON TABLE public.tbl_years_types TO humlab_read;
GRANT SELECT ON TABLE public.tbl_years_types TO johan;


--
-- Name: SEQUENCE tbl_years_types_years_type_id_seq; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON SEQUENCE public.tbl_years_types_years_type_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.tbl_years_types_years_type_id_seq TO sead_read;
GRANT SELECT ON SEQUENCE public.tbl_years_types_years_type_id_seq TO humlab_read;


--
-- Name: TABLE view_taxa_tree; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.view_taxa_tree TO postgres;
GRANT ALL ON TABLE public.view_taxa_tree TO sead_read;
GRANT ALL ON TABLE public.view_taxa_tree TO mattias;
GRANT SELECT ON TABLE public.view_taxa_tree TO humlab_read;
GRANT SELECT ON TABLE public.view_taxa_tree TO johan;


--
-- Name: TABLE view_taxa_tree_select; Type: ACL; Schema: public; Owner: sead_master
--

GRANT ALL ON TABLE public.view_taxa_tree_select TO postgres;
GRANT ALL ON TABLE public.view_taxa_tree_select TO sead_read;
GRANT ALL ON TABLE public.view_taxa_tree_select TO mattias;
GRANT SELECT ON TABLE public.view_taxa_tree_select TO humlab_read;
GRANT SELECT ON TABLE public.view_taxa_tree_select TO johan;


--
-- PostgreSQL database dump complete
--
