-- Deploy adna: 20241029_DML_ADNA_LOOKUPS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-10-29
  Description   Lookups for aDNA test data
  Issue         https://github.com/humlab-sead/sead_change_control/issues/318
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
    declare v_new_contact_id int;
    declare v_new_record_type_id int;
    declare v_submission_identifier text;
    declare v_change_request_identifier text;
begin

    v_submission_identifier = 'adna_pilot_lookup_import_oct_2024.xlsx'
    v_change_request_identifier = '20241029_DML_ADNA_LOOKUPS'


    with new_data (system_id, location_name, location_type_id) as (
        values
            ('1', 'Skänninge parish', '2')
        ) 
        insert into tbl_locations (location_id, location_name, location_type_id) 
            select sead_utility.allocate_system_id(
                v_submission_identifier,
                v_change_request_identifier,
                'tbl_locations',
                'location_id',
                new_data.system_id,
                row_to_json(new_data.*)::jsonb               
            ), location_name, location_type_id::int
            from new_data;

    with new_data (system_id, address_1, address_2, location_id, email, first_name, last_name, phone_number, url) as (
        values
            ('1', 'SciLifelab Ancient DNA, Norbyvägen 18 A, 752 36, Uppsala University, Uppsala', 'Uppsala', '4233', 'magnus.lundgren@scilifelab.uu.se', 'Magnus', 'Lundgren', NULL, 'https://www.scilifelab.se/units/ancient-dna/'),
            ('2', 'SciLifelab Ancient DNA, Norbyvägen 18 A, 752 36, Uppsala University, Uppsala', 'Uppsala', '4233', 'magnus.lundgren@scilifelab.uu.se', 'SciLifelab Ancient DNA', NULL, NULL, 'https://www.scilifelab.se/units/ancient-dna/'),
            ('3', 'Arkeologerna, Statens Historiska Museer', NULL, NULL, 'caroline.ahlstrom.arcini@arkeologerna.com', 'Caroline', 'Arcini Ahlström', NULL, 'https://arkeologerna.com/')
        )
            insert into tbl_contacts (contact_id, address_1, address_2, email, first_name, last_name) 
                select sead_utility.allocate_system_id(
	                v_submission_identifier,
	                v_change_request_identifier,
	                'tbl_contacts',
	                'contact_id',
	                new_data.system_id::text,
	                row_to_json(new_data.*)::jsonb               
            	), address_1, address_2, location_id, email, first_name, last_name, phone_number, url
                from new_data;

    with new_data (system_id, site_preservation_status_id, site_name, site_description, national_site_identifier, latitude_dd, longitude_dd, site_location_accuracy) as (
        values 
            ('1', NULL, 'Skänninge Abbey', NULL, 'L2011:9764', '58.398269', '15.082804', NULL, 'Cultural Heritage site')
        )
        insert into tbl_sites (system_id, site_preservation_status_id, site_name, site_description, national_site_identifier, latitude_dd, longitude_dd, altitude, site_location_accuracy)
            select 
                sead_utility.allocate_system_id(
	                v_submission_identifier,
	                v_change_request_identifier,
	                'tbl_sites',
	                'site_id',
	                new_data.system_id::text,
	                row_to_json(new_data.*)::jsonb               
            	), site_preservation_status_id::int, site_name, site_description, national_site_identifier,
					latitude_dd::numeric(18,10), longitude_dd::numeric(18,10), site_location_accuracy
            from new_data;

    with new_data (system_id, sampling_context, description) as (
		values
            ('1', 'aDNA analysis', 'Sampling for ancient DNA analysis.')
        )
        insert into tbl_sample_group_sampling_contexts (sampling_context_id, sampling_context, description)
            select 
                sead_utility.allocate_system_id(
	                v_submission_identifier,
	                v_change_request_identifier,
	                'tbl_sample_group_sampling_contexts',
	                'sampling_context_id',
	                new_data.system_id::text,
	                row_to_json(new_data.*)::jsonb
            	), sampling_context, description
            from new_data;

    with new_data (system_id, record_type_name, record_type_description) as (
        values
            ('1', 'ancient DNA', 'Extraction, sequencing, and analysis of ancient DNA.')
        )
		insert into tbl_record_types (system_id, record_type_name, record_type_description)
            select 
                sead_utility.allocate_system_id(
	                v_submission_identifier,
	                v_change_request_identifier,
	                'tbl_record_types',
	                'record_type_id',
	                new_data.system_id::text,
	                row_to_json(new_data.*)::jsonb
            	), record_type_name, record_type_description
            from new_data;

    v_new_record_type_id = sead_utility.get_allocated_system_id(
        v_submission_identifier, v_change_request_identifier, 'tbl_record_types', 'record_type_id', '1'
    );

    with new_data (system_id, biblio_id, method_name, method_abbrev_or_alt_name, description, record_type_id, method_group_id) as (
		values
            ('1', NULL, 'Ancient DNA analysis', 'aDNA', 'Extraction and analysis of ancient DNA recovered from biological material (human, animal, plants, etc.)', v_new_record_type_id, '1')
        )
        insert into tbl_methods (method_id, biblio_id, method_name, method_abbrev_or_alt_name, description, record_type_id, method_group_id)
            select 
                sead_utility.allocate_system_id(
	                v_submission_identifier,
	                v_change_request_identifier,
	                'tbl_methods',
	                'method_id',
	                new_data.system_id::text,
	                row_to_json(new_data.*)::jsonb
            	), biblio_id, method_name, method_abbrev_or_alt_name, description, record_type_id, method_group_id::int
            from new_data;

    v_new_contact_id = sead_utility.get_allocated_system_id(
        v_submission_identifier, v_change_request_identifier, 'tbl_contacts', 'contact_id', '2'
    );

    with new_data (system_id, master_name, master_notes, biblio_id, contact_id, url) as (
		values
            ('1', 'SciLifelab Ancient DNA', NULL, NULL, v_new_contact_id, 'https://www.scilifelab.se/units/ancient-dna/')
        )
        insert into tbl_dataset_masters (master_set_id, master_name, master_notes, biblio_id, contact_id, url)
            select 
                sead_utility.allocate_system_id(
	                v_submission_identifier,
	                v_change_request_identifier,
	                'tbl_dataset_masters',
	                'master_set_id',
	                new_data.system_id::text,
	                row_to_json(new_data.*)::jsonb
            	), master_name, master_notes, biblio_id::int, contact_id, url
            from new_data;


    with new_data (system_id, alt_ref_type, description) as (
        values
            ('1', 'Sequence Library ID', 'Sequence library ID code (generated by ADU) generated for aDNA data'),
            ('2', 'Associated DNA library ID', 'DNA library ID associated with a sample')
        )
		insert into tbl_alt_ref_types (alt_ref_type_id, record_type_name, record_type_description)
            select 
                sead_utility.allocate_system_id(
	                v_submission_identifier,
	                v_change_request_identifier,
	                'tbl_alt_ref_types',
	                'alt_ref_type_id',
	                new_data.system_id::text,
	                row_to_json(new_data.*)::jsonb
            	), alt_ref_type, description
            from new_data;


	with new_data (system_id, bugs_reference, doi, isbn, notes, title, year, authors, full_reference, url) as (
        values
            ('1', NULL, NULL, NULL, NULL, 'Ygle, Guve och Rane i Skänninge: DNA-analyser löste frågan om deras släktskap', '2020', 'Caroline, A.A., Hedvall, R., Lundgren, M.', 'Caroline, A.A., Hedvall, R., Lundgren, M. 2020. Ygle, Guve och Rane i Skänninge: DNA-analyser löste frågan om deras släktskap. Fornvännen, 115, 274-278. Accessed at: urn:nbn:se:raa:diva-6201', 'https://raa.diva-portal.org/smash/record.jsf?pid=diva2%3A1529218&dswid=3543')
        ) 
    	    insert into tbl_biblio (biblio_id, bugs_reference, doi, isbn, notes, title, year, authors, full_reference, url)
            select 
                sead_utility.allocate_system_id(
	                v_submission_identifier,
	                v_change_request_identifier,
	                'tbl_biblio',
	                'biblio_id',
	                new_data.system_id::text,
	                row_to_json(new_data.*)::jsonb
            	), bugs_reference, doi, isbn, notes, title, year, authors, full_reference, url
            from new_data;

	with new_data (system_id, system_description, system_name) as (
        values
            ('1', 'National Center for Biotechnology Information (NCBI) Taxonomy Database with classification and nomenclature for all organisms in the public sequence databases.', 'NCBI taxonomy')
        ) 
    	    insert into tbl_taxonomic_order_systems (biblio_id, system_description, system_name)
            select 
                sead_utility.allocate_system_id(
	                v_submission_identifier,
	                v_change_request_identifier,
	                'tbl_taxonomic_order_systems',
	                'taxonomic_order_system_id',
	                new_data.system_id::text,
	                row_to_json(new_data.*)::jsonb
            	), system_description, system_name
            from new_data;

	with new_data (system_id, family_name, order_id, family_id) as (
        values
            ('1', 'National Center for Biotechnology Information (NCBI) Taxonomy Database with classification and nomenclature for all organisms in the public sequence databases.', 'NCBI taxonomy')
        ) 
    	    insert into tbl_taxa_tree_families (family_id, family_name, order_id, family_id)
            select 
                sead_utility.allocate_system_id(
	                v_submission_identifier,
	                v_change_request_identifier,
	                'tbl_taxa_tree_families',
	                'family_id',
	                new_data.system_id::text,
	                row_to_json(new_data.*)::jsonb
            	), family_name, order_id, family_id
            from new_data;

    v_new_method_id = sead_utility.get_allocated_system_id(
        v_submission_identifier, v_change_request_identifier, 'tbl_methods', 'method_id', '1'
    );

	with new_data (	with new_data (system_id, method_id, name, description) as (
        values
            ('1', v_new_method_id, 'organism genome mapped to', 'Organism whose reference sequence / genome assembly was used for sequence alignment'),
            ('2', v_new_method_id, 'reference genome assembly', 'reference sequence / genome assembly name or accession code'),
            ('3', v_new_method_id, 'Endogenous reads (filtered)', 'The number of sequence reads which have successfully mapped to the organism reference sequence after filtering.'),
            ('4', v_new_method_id, 'Average read length', 'The average length of mapped sequence reads, excluding reads shorter than 35 bases and reads with less than 90% consensus to the species reference.'),
            ('5', v_new_method_id, 'Average depth of coverage - genome (x)', 'The number of times on average that a given nucleotide in the genome has been sequenced.'),
            ('6', v_new_method_id, 'Breadth of coverage - genome (%)', 'The percentage of the reference sequence / genome assembly covered after alignment.'),
            ('7', v_new_method_id, 'Average depth of coverage - mtDNA (x)', 'The number of times on average that a given nucleotide in the mitochondrial genome has been sequenced.'),
            ('8', v_new_method_id, 'mtDNA reads', 'The number of sequence reads which have successfully mapped to the mitochondrial DNA in the reference sequence'),
            ('9', v_new_method_id, 'X chromosome reads', 'The number of sequence reads which have successfully mapped to the X chromosome in the reference sequence'),
            ('10', v_new_method_id, 'Y chromosome reads', 'The number of sequence reads which have successfully mapped to the Y chromosome in reference sequence'),
            ('11', v_new_method_id, 'Molecular sex - Ry', 'Prediction of molecular sex of individual. Ry is based on the ratio of reads aligning to the X and Y chromosomes.'),
            ('12', v_new_method_id, 'Molecular sex - Rx', 'Prediction of molecular sex of individual. Rx is based on the ratio of reads aligning to the X chromosome and autosomes'),
            ('13', v_new_method_id, 'mtDNA haplogroup', 'Prediction of mitochondrial DNA haplogroup'),
            ('14', v_new_method_id, 'Y haplogroup', 'Prediction of Y chromosome haplogroup'),
            ('15', v_new_method_id, '1st deg. relatives', 'List of sample IDs that are 1st degree relatives to the analysed individual.'),
            ('16', v_new_method_id, '2nd deg. relatives', 'List of sample IDs that are 2nd degree relatives to the analysed individual.'),
            ('17', v_new_method_id, '>2nd deg. relatives', 'List of sample IDs that are further than 2nd degree relatives to the analysed individual.')
        ) 
    	    insert into tbl_value_classes (value_class_id, method_id, name, description)
            select 
                sead_utility.allocate_system_id(
	                v_submission_identifier,
	                v_change_request_identifier,
	                'tbl_value_classes',
	                'value_class_id',
	                new_data.system_id::text,
	                row_to_json(new_data.*)::jsonb
            	), family_name, method_id, name, description
            from new_data;

end $$;
commit;
