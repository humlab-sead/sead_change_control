comment on column "public"."tbl_abundance_elements"."record_type_id" is 'used to restrict list of available elements according to record type. enables specific use of single term for multiple proxies whilst avoiding confusion, e.g. mni insects, mni seeds';
comment on column "public"."tbl_abundance_elements"."element_name" is 'short name for element, e.g. mni, seed, leaf';
comment on column "public"."tbl_abundance_elements"."element_description" is 'explanation of short name, e.g. minimum number of individuals, base of seed grain, covering of leaf or flower bud';
comment on column "public"."tbl_abundances"."abundance_element_id" is 'allows recording of different parts for single taxon, e.g. leaf, seed, mni etc.';
comment on column "public"."tbl_abundances"."abundance" is 'usually count value (abundance) but can be presence (1) or catagorical or relative scale, as defined by tbl_data_types through tbl_datasets';
comment on table "public"."tbl_abundances" is '20120503pib deleted column "abundance_modification_id" as appeared superfluous with "abundance_id" in tbl_adbundance_modifications';
comment on column "public"."tbl_aggregate_datasets"."aggregate_dataset_name" is 'name of aggregated dataset';
comment on column "public"."tbl_aggregate_datasets"."description" is 'Notes explaining the purpose of the aggregated set of analysis entities';
comment on column "public"."tbl_aggregate_order_types"."aggregate_order_type" is 'aggregate order name, e.g. site name, age, sample depth, altitude';
comment on column "public"."tbl_aggregate_order_types"."description" is 'explanation of ordering system';
comment on table "public"."tbl_aggregate_order_types" is '20120504pib: drop this? or replace with alternative?';
comment on column "public"."tbl_aggregate_samples"."aggregate_sample_name" is 'optional name for aggregated entity.';
comment on table "public"."tbl_aggregate_samples" is '20120504pib: can we drop aggregate sample name? seems excessive and unnecessary sample names can be traced.';
comment on table "public"."tbl_analysis_entities" is '20120503pib deleted column preparation_method_id, but may need to cater for this in datasets...
20120506pib: deleted method_id and added table for multiple methods per entity';
comment on table "public"."tbl_analysis_entity_ages" is '20120504pib: should this be connected to physical sample instead of analysis entities? allowing multiple ages (from multiple dates) for a sample. at the moment it requires a lot of backtracing to find a sample''s age... but then again, it allows... what, exactly?';
comment on column "public"."tbl_analysis_entity_prep_methods"."method_id" is 'preparation methods only';
comment on table "public"."tbl_analysis_entity_prep_methods" is '20120506pib: created to cater for multiple preparation methods for analysis but maintaining simple dataset concept.';
comment on table "public"."tbl_ceramics_measurements" is 'Type=lookup';
comment on table "public"."tbl_chronologies" is '20120504pib: note that the dropped age type recorded the type of dates (c14 etc) used in constructing the chronology... but is only one per chonology enough? can a chronology not be made up of mulitple types of age?';
comment on column "public"."tbl_dataset_masters"."biblio_id" is 'primary reference for master dataset if available, e.g. buckland & buckland 2006 for bugscep';
comment on column "public"."tbl_dataset_masters"."master_name" is 'identification of master dataset, e.g. mal, bugscep, dendrolab';
comment on column "public"."tbl_dataset_masters"."master_notes" is 'description of master dataset, its form (e.g. database, lab) and any other relevant information for tracing it.';
comment on column "public"."tbl_dataset_masters"."url" is 'website or other url for master dataset, be it a project, lab or... other';
comment on column "public"."tbl_dataset_submission_types"."submission_type" is 'descriptive name for type of submission, e.g. original submission, ingestion from another database';
comment on column "public"."tbl_dataset_submission_types"."description" is 'explanation of submission type, explaining clearly data ingestion mechanism';
comment on column "public"."tbl_dataset_submissions"."notes" is 'any details of submission not covered by submission_type information, such as name of source from which submission originates if not covered elsewhere in database, e.g. from bugscep';
comment on column "public"."tbl_datasets"."dataset_name" is 'something uniquely identifying the dataset for this site. may be same as sample group name, or created adhoc if necessary, but preferably with some meaning.';
comment on column "public"."tbl_dating_labs"."contact_id" is 'address details are stored in tbl_contacts';
comment on column "public"."tbl_dating_labs"."international_lab_id" is 'international standard radiocarbon lab identifier.
from http://www.radiocarbon.org/info/labcodes.html';
comment on column "public"."tbl_dating_labs"."lab_name" is 'international standard name of radiocarbon lab, from http://www.radiocarbon.org/info/labcodes.html';
comment on table "public"."tbl_dating_labs" is '20120504pib: reduced this table and linked to tbl_contacts for address related data';
comment on table "public"."tbl_dating_material" is '20130722PIB: Added field date_updated';
comment on table "public"."tbl_dendro_dates" is '20130722PIB: Added field dating_uncertainty_id to cater for >< etc.
20130722PIB: prefixed fieldnames age_younger and age_older with "cal_" to conform with equivalent names in other tables';
comment on table "public"."tbl_dendro_measurements" is 'Type=lookup';
comment on column "public"."tbl_dimensions"."method_group_id" is 'Limits choice of dimension by method group (e.g. size measurements, coordinate systems)';
comment on column "public"."tbl_features"."feature_name" is 'estabilished reference name/number for the feature (note: not the sample). e.g. well 47, anl.3, c107.
remember that a sample can come from multiple features (e.g. c107 in well 47) but each feature should have a separate record.';
comment on column "public"."tbl_features"."feature_description" is 'description of the feature. may include any field notes, lab notes or interpretation information useful for interpreting the sample data.';
comment on column "public"."tbl_geochron_refs"."biblio_id" is 'reference for specific date';
comment on column "public"."tbl_geochronology"."age" is 'radiocarbon (or other radiometric) age.';
comment on column "public"."tbl_geochronology"."error_older" is 'plus (+) side of the measured error (set same as error_younger if standard +/- error)';
comment on column "public"."tbl_geochronology"."error_younger" is 'minus (-) side of the measured error (set same as error_younger if standard +/- error)';
comment on column "public"."tbl_geochronology"."delta_13c" is 'delta 13c where available for calibration correction.';
comment on column "public"."tbl_geochronology"."notes" is 'notes specific to this date';
comment on table "public"."tbl_geochronology" is '20130722PIB: Altered field uncertainty (varchar) to dating_uncertainty_id and linked to tbl_dating_uncertainty to enable lookup of uncertainty modifiers for dates';
comment on column "public"."tbl_locations"."default_lat_dd" is 'default latitude in decimal degrees for location, e.g. mid point of country. leave empty if not known.';
comment on column "public"."tbl_locations"."default_long_dd" is 'default longitude in decimal degrees for location, e.g. mid point of country';
comment on column "public"."tbl_modification_types"."modification_type_name" is 'short name of modification, e.g. carbonised';
comment on column "public"."tbl_modification_types"."modification_type_description" is 'clear explanation of modification so that name makes sense to non-domain scientists';
comment on column "public"."tbl_physical_samples"."alt_ref_type_id" is 'type of name represented by primary sample name, e.g. lab number, museum number etc.';
comment on column "public"."tbl_physical_samples"."sample_type_id" is 'physical form of sample, e.g. bulk sample, kubienta subsample, core subsample, dendro core, dendro slice...';
comment on column "public"."tbl_physical_samples"."sample_name" is 'reference number or name of sample. multiple references/names can be added as alternative references.';
comment on column "public"."tbl_physical_samples"."date_sampled" is 'Date samples were taken. ';
comment on table "public"."tbl_physical_samples" is '20120504PIB: deleted columns XYZ and created external tbl_sample_coodinates
20120506PIB: deleted columns depth_top & depth_bottom and moved to tbl_sample_dimensions
20130416PIB: changed to date_sampled from date to varchar format to increase flexibility';
comment on column "public"."tbl_project_stages"."stage_name" is 'stage of project in investigative cycle, e.g. desktop study, prospection, final excavation';
comment on column "public"."tbl_project_stages"."description" is 'explanation of stage name term, including details of purpose and general contents';
comment on column "public"."tbl_project_types"."project_type_name" is 'descriptive name for project type, e.g. consultancy, research, teaching; also combinations consultancy/teaching';
comment on column "public"."tbl_project_types"."description" is 'project type combinations can be used where appropriate, e.g. teaching/research';
comment on column "public"."tbl_projects"."project_name" is 'name of project (e.g. phil''s phd thesis, malmö ringroad vägverket)';
comment on column "public"."tbl_projects"."project_abbrev_name" is 'optional. abbreviation of project name or acronym (e.g. vgv, swedab)';
comment on column "public"."tbl_projects"."description" is 'brief description of project and any useful information for finding out more.';
comment on column "public"."tbl_radiocarbon_calibration"."c14_yr_bp" is 'mid-point of c14 age.';
comment on column "public"."tbl_radiocarbon_calibration"."cal_yr_bp" is 'mid-point of calibrated age.';
comment on column "public"."tbl_rdb"."location_id" is 'geographical source/relevance of the specific code. e.g. the international iucn classification of species in the uk.';
comment on column "public"."tbl_rdb_systems"."location_id" is 'geaographical relevance of rdb code system, e.g. uk, international, new forest';
comment on column "public"."tbl_record_types"."record_type_name" is 'short name of proxy/proxies in group';
comment on column "public"."tbl_record_types"."record_type_description" is 'detailed description of group and explanation for grouping';
comment on table "public"."tbl_record_types" is 'may also use this to group methods - e.g. phosphate analyses (whereas tbl_method_groups would store the larger group "palaeo chemical/physical" methods)';
comment on column "public"."tbl_relative_age_types"."age_type" is 'name of chronological age type, e.g. archaeological period, single calendar date, calendar age range, blytt-sernander';
comment on column "public"."tbl_relative_age_types"."description" is 'description of chronological age type, e.g. period defined by archaeological and or geological dates representing cultural activity period, climate period defined by palaeo-vegetation records';
comment on table "public"."tbl_relative_age_types" is '20130723PIB: replaced date_updated column with new one with same name but correct data type
20140226EE: replaced date_updated column with correct time data type';
comment on column "public"."tbl_relative_ages"."relative_age_name" is 'name of the dating period, e.g. bronze age. calendar ages should be given appropriate names such as ad 1492, 74 bc';
comment on column "public"."tbl_relative_ages"."description" is 'a description of the (usually) period.';
comment on column "public"."tbl_relative_ages"."c14_age_older" is 'c14 age of younger boundary of period (where relevant).';
comment on column "public"."tbl_relative_ages"."c14_age_younger" is 'c14 age of later boundary of period (where relevant). leave blank for calendar ages.';
comment on column "public"."tbl_relative_ages"."cal_age_older" is '(approximate) age before present (1950) of earliest boundary of period. or if calendar age then the calendar age converted to bp.';
comment on column "public"."tbl_relative_ages"."cal_age_younger" is '(approximate) age before present (1950) of latest boundary of period. or if calendar age then the calendar age converted to bp.';
comment on column "public"."tbl_relative_ages"."notes" is 'any further notes not included in the description, such as reliability of definition or fuzzyness of boundaries.';
comment on column "public"."tbl_relative_ages"."abbreviation" is 'Standard abbreviated form of name if available';
comment on table "public"."tbl_relative_ages" is '20120504PIB: removed biblio_id as is replaced by tbl_relative_age_refs
20130722PIB: changed colour in model to AliceBlue to reflect degree of user addition possible (i.e. ages can be added for reference in tbl_relative_dates)';
comment on column "public"."tbl_relative_dates"."method_id" is 'dating method used to attribute sample to period or calendar date.';
comment on column "public"."tbl_relative_dates"."notes" is 'any notes specific to the dating of this sample to this calendar or period based age';
comment on table "public"."tbl_relative_dates" is '20120504PIB: Added method_id to store dating method used to attribute sample to period or calendar date (e.g. strategraphic dating, typological)
20130722PIB: addded field dating_uncertainty_id to cater for "from", "to" and "ca." etc. especially from import of BugsCEP';
comment on column "public"."tbl_sample_coordinates"."accuracy" is 'GPS type accuracy, e.g. 5m 10m 0.01m';
comment on column "public"."tbl_sample_dimensions"."dimension_id" is 'details of the dimension measured';
comment on column "public"."tbl_sample_dimensions"."method_id" is 'method describing dimension measurement, with link to units used';
comment on column "public"."tbl_sample_dimensions"."dimension_value" is 'numerical value of dimension, in the units indicated in the documentation and interface.';
comment on table "public"."tbl_sample_dimensions" is '20120506pib: depth measurements for samples moved here from tbl_physical_samples';
comment on column "public"."tbl_sample_group_sampling_contexts"."sampling_context" is 'short but meaningful name defining sample group context, e.g. stratigraphic sequence, archaeological excavation';
comment on column "public"."tbl_sample_group_sampling_contexts"."description" is 'full explanation of the grouping term';
comment on column "public"."tbl_sample_group_sampling_contexts"."sort_order" is 'allows lists to group similar or associated group context close to each other, e.g. modern investigations together, palaeo investigations together';
comment on table "public"."tbl_sample_group_sampling_contexts" is 'Type=lookup';
comment on column "public"."tbl_sample_groups"."method_id" is 'sampling method, e.g. russian auger core, pitfall traps. note different from context in that it is specific to method of sample retrieval and not type of investigation.';
comment on column "public"."tbl_sample_groups"."sample_group_name" is 'Name which identifies the collection of samples. For ceramics, use vessel number.';
comment on column "public"."tbl_sample_notes"."note_type" is 'origin of the note, e.g. field note, lab note';
comment on column "public"."tbl_sample_notes"."note" is 'note contents';
comment on column "public"."tbl_site_natgridrefs"."method_id" is 'points to coordinate system.';
comment on table "public"."tbl_site_natgridrefs" is '20120507pib: removed tbl_national_grids and trasfered storage of coordinate systems to tbl_methods';
comment on column "public"."tbl_site_other_records"."biblio_id" is 'reference to publication containing data';
comment on column "public"."tbl_site_other_records"."record_type_id" is 'reference to type of data (proxy)';
comment on column "public"."tbl_site_preservation_status"."site_id" is 'allows multiple preservation/threat records per site';
comment on column "public"."tbl_site_preservation_status"."preservation_status_or_threat" is 'descriptive name for:
preservation status, e.g. (e.g. lost, damaged, threatened) or
main reason for potential or real risk to site (e.g. hydroelectric, oil exploitation, mining, forestry, climate change, erosion)';
comment on column "public"."tbl_site_preservation_status"."description" is 'brief description of site preservation status or threat to site preservation. include data here that does not fit in the other fields (for now - we may expand these features later if demand exists)';
comment on column "public"."tbl_site_preservation_status"."assessment_type" is 'type of assessment giving information on preservation status and threat, e.g. unesco report, archaeological survey';
comment on column "public"."tbl_site_preservation_status"."assessment_author_contact_id" is 'person or authority in tbl_contacts responsible for the assessment of preservation status and threat';
comment on column "public"."tbl_site_preservation_status"."Evaluation_date" is 'Date of assessment, either formal or informal';
comment on column "public"."tbl_species_associations"."associated_taxon_id" is 'Taxon with which the primary taxon (taxon_id) is associated. ';
comment on column "public"."tbl_species_associations"."biblio_id" is 'Reference where relationship between taxa is described or mentioned';
comment on column "public"."tbl_species_associations"."taxon_id" is 'Primary taxon in relationship, i.e. this taxon has x relationship with the associated taxon';
comment on column "public"."tbl_species_associations"."association_type_id" is 'Type of association between primary taxon (taxon_id) and associated taxon. Note that the direction of the association is important in most cases (e.g. x predates on y)';
comment on table "public"."tbl_taxa_images" is '20140226EE: changed the data type for date_updated';
comment on table "public"."tbl_taxa_reference_specimens" is '20140226EE: changed date_updated to correct data type';
comment on column "public"."tbl_taxa_seasonality"."location_id" is 'geographical relevance of seasonality data';
comment on column "public"."tbl_taxa_synonyms"."notes" is 'Any information useful to the history or usage of the synonym.';
comment on column "public"."tbl_taxa_synonyms"."synonym" is 'Synonym at level defined by id level. I.e. if synonym is at genus level, then only the genus synonym is included here. Another synonym record is used for the species level synonym for the same taxon only if the name is different to that used in the master list.';
comment on column "public"."tbl_taxa_synonyms"."reference_type" is 'Form of information relating to the synonym in the given bibliographic link, e.g. by use, definition, incorrect usage.';
comment on table "public"."tbl_taxa_tree_master" is '20130416PIB: removed default=0 for author_id and genus_id as was incorrect';
comment on table "public"."tbl_tephra_dates" is '20130722PIB: Added field dating_uncertainty_id to cater for >< etc.';