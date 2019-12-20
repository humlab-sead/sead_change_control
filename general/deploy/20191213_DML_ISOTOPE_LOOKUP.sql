-- Deploy sead_change_control:20191012_DML_ISOTOPE_LOOKUP_DATA to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-11-04
  Description
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
declare new_id int;
begin

    begin

        new_id = 11;
        with new_dataset_masters (master_set_id, contact_id, master_name, master_note, url) as (values
            (11, 999999, 'Sample data Isotopes', 'Sample data for implementing isotope data in to SEAD', '')
        ) insert into tbl_dataset_masters (master_set_id, master_name, url)
        select a.master_set_id, a.master_name, a.url
        from new_dataset_masters a
        /*left join tbl_dataset_masters b
            on a.master_set_id = b.master_set_id
        where b.master_set_id is null*/;

        new_id = 78;
        with new_sample_location_types (sample_location_type_id, location_type, location_type_description) as (values
        	(new_id + 0, 'cheramic part', 'Description of what part of ceramic vessel/structure were sampled'),
	        (new_id + 1, 'sample position', 'Describes what substance and/or more accurate information on where on the ceramic part the sample came from (e.g. charred deposit from inside the vessel)')
        ) insert into tbl_sample_location_types (sample_location_type_id, location_type, location_type_description)
        select a.sample_location_type_id, a.location_type, a.location_type_description
        from new_sample_location_types a
        /*left join tbl_sample_location_types b
            on a.sample_location_type_id = b.sample_location_type_id
        where b.sample_location_type_id is null*/;

        new_id = 46;
        with new_data_types (data_type_id, data_type_group_id, data_type_name, definition) as (values
            (new_id + 0, 1, 'Mixed-method dependent', 'Multiple datatypes from one method. (e.g. multiple isotope types from masspectrometry)')
        ) insert into tbl_data_types (data_type_id, data_type_group_id, data_type_name, definition)
        select a.data_type_id, a.data_type_group_id, a.data_type_name, a.definition
        from new_data_types a
        /*left join tbl_data_types b
            on a.data_type_id = b.data_type_id
        where b.data_type_id is null*/;

        with new_isotope_value_specifiers (isotope_value_specifier_id, name, description) as (values
         	(0, 'Undefined', 'Not defined'),
        	(1, 'Detected, numeric', 'Isotope detected and quantifiable'),
        	(2, 'Detected', 'Isotope/lipid detected in the sample, represented by text.'),
        	(3, 'Detected, less than', 'Isotope/lipid detected in the sample, amount below threshold (i.e isotope detected <0.3)'),
        	(4, 'Non detected', 'Isotope/lipid might be present in the sample, but not detected.')
        ) insert into tbl_isotope_value_specifiers (isotope_value_specifier_id, name, description)
        select a.isotope_value_specifier_id, a.name, a.description
        from new_isotope_value_specifiers a
        /*left join tbl_isotope_value_specifiers b
            on a.isotope_value_specifier_id = b.isotope_value_specifier_id
        where b.isotope_value_specifier_id is null*/;

        insert into tbl_isotope_standards (isotope_standard_id)
            values (1)
                on conflict do nothing;

        with new_isotope_types(isotope_type_id, designation, abbreviation, atomic_number, description) as (values
            (1, 'actinium', 'Ac', 89, 'basic chemical element'),
            (2, 'aluminium (aluminum)', 'Al', 13, 'basic chemical element'),
            (3, 'americium', 'Am', 95, 'basic chemical element'),
            (4, 'antimony', 'Sb', 51, 'basic chemical element'),
            (5, 'argon', 'Ar', 18, 'basic chemical element'),
            (6, 'arsenic', 'As', 33, 'basic chemical element'),
            (7, 'astatine', 'At', 85, 'basic chemical element'),
            (8, 'barium', 'Ba', 56, 'basic chemical element'),
            (9, 'berkelium', 'Bk', 97, 'basic chemical element'),
            (10, 'beryllium', 'Be', 4, 'basic chemical element'),
            (11, 'bismuth', 'Bi', 83, 'basic chemical element'),
            (12, 'bohrium', 'Bh', 107, 'basic chemical element'),
            (13, 'boron', 'B', 5, 'basic chemical element'),
            (14, 'bromine', 'Br', 35, 'basic chemical element'),
            (15, 'cadmium', 'Cd', 48, 'basic chemical element'),
            (16, 'caesium (cesium)', 'Cs', 55, 'basic chemical element'),
            (17, 'calcium', 'Ca', 20, 'basic chemical element'),
            (18, 'californium', 'Cf', 98, 'basic chemical element'),
            (19, 'carbon', 'C', 6, 'basic chemical element'),
            (20, 'cerium', 'Ce', 58, 'basic chemical element'),
            (21, 'chlorine', 'Cl', 17, 'basic chemical element'),
            (22, 'chromium', 'Cr', 24, 'basic chemical element'),
            (23, 'cobalt', 'Co', 27, 'basic chemical element'),
            (24, 'copernicium', 'Cn', 112, 'basic chemical element'),
            (25, 'copper', 'Cu', 29, 'basic chemical element'),
            (26, 'curium', 'Cm', 96, 'basic chemical element'),
            (27, 'darmstadtium', 'Ds', 110, 'basic chemical element'),
            (28, 'dubnium', 'Db', 105, 'basic chemical element'),
            (29, 'dysprosium', 'Dy', 66, 'basic chemical element'),
            (30, 'einsteinium', 'Es', 99, 'basic chemical element'),
            (31, 'erbium', 'Er', 68, 'basic chemical element'),
            (32, 'europium', 'Eu', 63, 'basic chemical element'),
            (33, 'fermium', 'Fm', 100, 'basic chemical element'),
            (34, 'flerovium', 'Fl', 114, 'basic chemical element'),
            (35, 'fluorine', 'F', 9, 'basic chemical element'),
            (36, 'francium', 'Fr', 87, 'basic chemical element'),
            (37, 'gadolinium', 'Gd', 64, 'basic chemical element'),
            (38, 'gallium', 'Ga', 31, 'basic chemical element'),
            (39, 'germanium', 'Ge', 32, 'basic chemical element'),
            (40, 'gold', 'Au', 79, 'basic chemical element'),
            (41, 'hafnium', 'Hf', 72, 'basic chemical element'),
            (42, 'hassium', 'Hs', 108, 'basic chemical element'),
            (43, 'helium', 'He', 2, 'basic chemical element'),
            (44, 'holmium', 'Ho', 67, 'basic chemical element'),
            (45, 'hydrogen', 'H', 1, 'basic chemical element'),
            (46, 'indium', 'In', 49, 'basic chemical element'),
            (47, 'iodine', 'I', 53, 'basic chemical element'),
            (48, 'iridium', 'Ir', 77, 'basic chemical element'),
            (49, 'iron', 'Fe', 26, 'basic chemical element'),
            (50, 'krypton', 'Kr', 36, 'basic chemical element'),
            (51, 'lanthanum', 'La', 57, 'basic chemical element'),
            (52, 'lawrencium', 'Lr', 103, 'basic chemical element'),
            (53, 'lead', 'Pb', 82, 'basic chemical element'),
            (54, 'lithium', 'Li', 3, 'basic chemical element'),
            (55, 'livermorium', 'Lv', 116, 'basic chemical element'),
            (56, 'lutetium', 'Lu', 71, 'basic chemical element'),
            (57, 'magnesium', 'Mg', 12, 'basic chemical element'),
            (58, 'manganese', 'Mn', 25, 'basic chemical element'),
            (59, 'meitnerium', 'Mt', 109, 'basic chemical element'),
            (60, 'mendelevium', 'Md', 101, 'basic chemical element'),
            (61, 'mercury', 'Hg', 80, 'basic chemical element'),
            (62, 'molybdenum', 'Mo', 42, 'basic chemical element'),
            (63, 'neodymium', 'Nd', 60, 'basic chemical element'),
            (64, 'neon', 'Ne', 10, 'basic chemical element'),
            (65, 'neptunium', 'Np', 93, 'basic chemical element'),
            (66, 'nickel', 'Ni', 28, 'basic chemical element'),
            (67, 'niobium', 'Nb', 41, 'basic chemical element'),
            (68, 'nitrogen', 'N', 7, 'basic chemical element'),
            (69, 'nobelium', 'No', 102, 'basic chemical element'),
            (70, 'osmium', 'Os', 76, 'basic chemical element'),
            (71, 'oxygen', 'O', 8, 'basic chemical element'),
            (72, 'palladium', 'Pd', 46, 'basic chemical element'),
            (73, 'phosphorus', 'P', 15, 'basic chemical element'),
            (74, 'platinum', 'Pt', 78, 'basic chemical element'),
            (75, 'plutonium', 'Pu', 94, 'basic chemical element'),
            (76, 'polonium', 'Po ', 84, 'basic chemical element'),
            (77, 'potassium', 'K', 19, 'basic chemical element'),
            (78, 'praseodymium', 'Pr', 59, 'basic chemical element'),
            (79, 'promethium', 'Pm', 61, 'basic chemical element'),
            (80, 'protactinium', 'Pa', 91, 'basic chemical element'),
            (81, 'radium', 'Ra', 88, 'basic chemical element'),
            (82, 'radon', 'Rn', 86, 'basic chemical element'),
            (83, 'rhenium', 'Re', 75, 'basic chemical element'),
            (84, 'rhodium', 'Rh', 45, 'basic chemical element'),
            (85, 'roentgenium', 'Rg', 111, 'basic chemical element'),
            (86, 'rubidium', 'Rb', 37, 'basic chemical element'),
            (87, 'ruthenium', 'Ru', 44, 'basic chemical element'),
            (88, 'rutherfordium', 'Rf', 104, 'basic chemical element'),
            (89, 'samarium', 'Sm', 62, 'basic chemical element'),
            (90, 'scandium', 'Sc', 21, 'basic chemical element'),
            (91, 'seaborgium', 'Sg', 106, 'basic chemical element'),
            (92, 'selenium', 'Se', 34, 'basic chemical element'),
            (93, 'silicon', 'Si', 14, 'basic chemical element'),
            (94, 'silver', 'Ag', 47, 'basic chemical element'),
            (95, 'sodium', 'Na', 11, 'basic chemical element'),
            (96, 'strontium', 'Sr', 38, 'basic chemical element'),
            (97, 'sulfur', 'S', 16, 'basic chemical element'),
            (98, 'tantalum', 'Ta', 73, 'basic chemical element'),
            (99, 'technetium', 'Tc', 43, 'basic chemical element'),
            (100, 'tellurium', 'Te', 52, 'basic chemical element'),
            (101, 'terbium', 'Tb', 65, 'basic chemical element'),
            (102, 'thallium', 'Tl', 81, 'basic chemical element'),
            (103, 'thorium', 'Th', 90, 'basic chemical element'),
            (104, 'thulium', 'Tm', 69, 'basic chemical element'),
            (105, 'tin', 'Sn', 50, 'basic chemical element'),
            (106, 'titanium', 'Ti', 22, 'basic chemical element'),
            (107, 'tungsten', 'W', 74, 'basic chemical element'),
            (108, 'ununoctium', 'Uuo', 118, 'basic chemical element'),
            (109, 'ununpentium', 'Uup', 115, 'basic chemical element'),
            (110, 'ununseptium', 'Uus', 117, 'basic chemical element'),
            (111, 'ununtrium', 'Uut', 113, 'basic chemical element'),
            (112, 'uranium', 'U', 92, 'basic chemical element'),
            (113, 'vanadium', 'V', 23, 'basic chemical element'),
            (114, 'xenon', 'Xe', 54, 'basic chemical element'),
            (115, 'ytterbium', 'Yb', 70, 'basic chemical element'),
            (116, 'yttrium', 'Y', 39, 'basic chemical element'),
            (117, 'zinc', 'Zn', 30, 'basic chemical element'),
            (118, 'zirconium', 'Zr', 40, 'basic chemical element'),
            (119, 'collagen g', 'collagen g', NULL, 'weight of collagen in sample (in milligrams)'),
            (120, 'collagen %', 'collagen %', NULL, 'procentage of collagen in sample'),
            (121, 'Concentration', 'Concentration', NULL, 'Concentration in lipids (µg g-1)'),
            (122, 'Meaningful lipids present', 'Meaningful lipids present', NULL, 'Concentration in lipids above threeshold or with biomarkers'),
            (123, 'APAA C16', 'APAA C16', NULL, 'Presence of  C16 ω-(ο-alkylphenyl) alkanoic acids '),
            (124, 'APAA C18', 'APAA C18', NULL, 'Presence of  C18 ω-(ο-alkylphenyl) alkanoic acids '),
            (125, 'APAA C20', 'APAA C20', NULL, 'Presence of  C20 ω-(ο-alkylphenyl) alkanoic acids '),
            (126, 'APAA C22', 'APAA C22', NULL, 'Presence of  C22 ω-(ο-alkylphenyl) alkanoic acids '),
            (127, 'DHYA C16', 'DHYA C16', NULL, 'Presence of  C16 dihydroxyacids'),
            (128, 'DHYA C18', 'DHYA C18', NULL, 'Presence of  C18 dihydroxyacids'),
            (129, 'DHYA C20', 'DHYA C20', NULL, 'Presence of  C20 dihydroxyacids'),
            (130, 'DHYA C22', 'DHYA C22', NULL, 'Presence of  C22 dihydroxyacids'),
            (131, 'TMTD', 'TMTD', NULL, 'Presence of  4,8,12-Trimethyltridecanoic acid'),
            (132, 'Pristanic', 'Pristanic', NULL, 'Presence of  pristanic acid'),
            (133, 'Phytanic', 'Phytanic', NULL, 'Presence of phytanic acid'),
            (134, 'SRR%', 'SRR%', NULL, 'The contribution of the SRR isomer in total phytanic acid (SRR%)'),
            (135, 'Plant signal (PHYST)', 'Plant signal (PHYST)', NULL, 'Presence of plant biomarkers of type PHYST'),
            (136, 'Full aquatic biomarker', 'Full aquatic biomarker', NULL, 'Presence of  at least C20 ω-(ο-alkylphenyl) alkanoic acids  associated to an isoprenoid fatty acid indicative of an aquatic source'),
            (137, 'Partial aquatic biomarker', 'Partial aquatic biomarker', NULL, 'Presence of  C18 ω-(ο-alkylphenyl) alkanoic acids  associated to 4,8,12-Trimethyltridecanoic acid probqbly related to an aquatic source'),
            (138, '>75.5% SRR-phytanic', '>75.5% SRR-phytanic', NULL, 'SRR%>75.5 indicative of an aquatic source'),
            (139, 'Aquatic signal', 'Aquatic signal', NULL, 'Extract with Full aquatic biomarker or >75.5% SSR-phytanic'),
            (140, 'GC-c-IRMS', 'GC-c-IRMS', NULL, 'Compound Specific Isotopes Analysis carried out'),
            (141, 'Fraction (C16:0)', 'Fraction (C16:0)', NULL, 'Biochemical fraction for measurement (C16:0)'),
            (142, '13C/12C', '13C/12C', NULL, '13C/12C isotopic measurement'),
            (143, '13C/12C unc', '13C/12C unc', NULL, 'uncertainty of 13C/12C isotopic measurement'),
            (144, 'Fraction (C18:0)', 'Fraction (C18:0)', NULL, 'Biochemical fraction for measurement (C18:0)'),
            (145, '13C/12C', '13C/12C', NULL, '13C/12C isotopic measurement'),
            (146, '13C/12C unc', '13C/12C unc', NULL, 'uncertainty of 13C/12C isotopic measurement'),
            (147, '13C/12C offset fractions (C18:0-C16:0)', '13C/12C offset fractions (C18:0-C16:0)', NULL, 'Δ13C (C16:0-C18:0)'),
            (148, 'EA-IRMS', 'EA-IRMS', NULL, 'Bulk Isotopes Analysis carried out'),
            (149, 'Fraction (Bulk)', 'Fraction', NULL, 'Biochemical fraction for measurement (Bluk)'),
            (150, 'Quality control', 'Quality control', NULL, 'Above %N threashold (1%)'),
            (151, '13C/12C', '13C/12C', NULL, '13C/12C isotopic measurement'),
            (152, '13C/12C unc', '13C/12C unc', NULL, 'uncertainty of 13C/12C isotopic measurement'),
            (153, '15N/14N', '15N/14N', NULL, '15N/14N isotopic measurement'),
            (154, '15N/14N unc', '15N/14N unc', NULL, 'uncertainty of 15N/14N isotopic measurement'),
            (155, '%C', '%C', NULL, 'C elemental concentration in bone collagen'),
            (156, '%N', '%N', NULL, 'N elemental concentration in bone collagen'),
            (157, 'C/N (atomic)', 'C/N (atomic)', NULL, 'C/N elemental ratio'),
            (158, 'Numbers of labstandards/delta samples', 'Numbers of labstandards/delta samples', NULL, 'The number of lab/international-standards/deltasamples run before the acctual sample were analyzed'),
            (159, 'Bone/dentine (mg)', 'Bone/dentine (mg)', NULL, 'Weight of bone or dentine in sample (in milligrams)'),
            (160, 'Collagen (mg)', 'Collagen (mg)', NULL, 'Weight of collagen in sample (in milligrams)'),
            (161, 'N/S', 'N/S', NULL, 'Ratio of Nitrogen and Sulfur in sample'),
            (162, 'C/S', 'C/S', NULL, 'Ratio of Carbon and Sulfur in sample'),
            (163, 'Plant signal (ALK)', 'Plant signal (ALK)', NULL, 'Presence of plant biomarkers of type ALK'),
            (164, 'Plant signal (LCFA)', 'Plant signal (LCFA)', NULL, 'Presence of plant biomarkers of type LCFA')
        ) insert into tbl_isotope_types (isotope_type_id, designation, abbreviation, atomic_number, description)
        select a.isotope_type_id, a.designation, a.abbreviation, a.atomic_number, a.description
        from new_isotope_types a
        /*left join tbl_isotope_types b
            on a.isotope_type_id = b.isotope_type_id
        where b.isotope_type_id is null*/;

        new_id = 68;
        with new_contacts (contact_id, address_1, address_2, first_name, last_name, email, url, phone_number) as (values
            (new_id + 0, 'BioArCh, Department of Archaeology, University of York, Heslington, York YO10 5DD, UK', '', 'Josie', 'Thomas', 'josie.thomas@york.ac.uk', 'https://archaeologydataservice.ac.uk/archives/view/idopea_ahrc_2018/', '+44 1904 328802'),
            (new_id + 1, 'Environmental Archaeology Lab, Umeå University', '', 'Mats', 'Eriksson', 'mats.eriksson@umu.se', 'https://archaeologydataservice.ac.uk/archives/view/idopea_ahrc_2018/', '+46 907866741')
        ) insert into tbl_contacts (contact_id, address_1, address_2, first_name, last_name, email, url, phone_number)
        select a.contact_id, a.address_1, a.address_2, a.first_name, a.last_name, a.email, a.url, a.phone_number
        from new_contacts a
        /*left join tbl_contacts b
            on a.contact_id = b.contact_id
        where b.contact_id is null*/;

        new_id = 6291;
        with new_biblio (biblio_id, authors, year, title, full_reference, doi, notes, url) as (values
            (
                new_id + 0,
                'Craig, O.E., Saul, H., Lucquin, A., Nishida, Y., Taché, K., Clarke, L., Thompson, A., Altoft, D.T., Uchiyama, J., Ajimoto, M. and Gibbs, K.',
                2013,
                'Earliest evidence for the use of pottery',
                'Craig, O.E., Saul, H., Lucquin, A., Nishida, Y., Taché, K., Clarke, L., Thompson, A., Altoft, D.T., Uchiyama, J., Ajimoto, M. and Gibbs, K.  2013. Earliest evidence for the use of pottery. Nature, 496(7445), p.351.',
                'https://www.nature.com/articles/nature12109',
                null,
                'https://www.nature.com/articles/nature12109.pdf'
            ),
            (
                new_id + 1,
                'Lucquin, A., Gibbs, K., Uchiyama, J., Saul, H., Ajimoto, M., Eley, Y., Radini, A., Heron, C.P., Shoda, S., Nishida, Y. and Lundy, J.',
                2016,
                'Ancient lipids document continuity in the use of early hunter–gatherer pottery through 9,000 years of Japanese prehistory',
                'Lucquin, A., Gibbs, K., Uchiyama, J., Saul, H., Ajimoto, M., Eley, Y., Radini, A., Heron, C.P., Shoda, S., Nishida, Y. and Lundy, J. 2016. Ancient lipids document continuity in the use of early hunter–gatherer pottery through 9,000 years of Japanese prehistory. Proceedings of the National Academy of Sciences, 113(15), pp.3991-3996.',
                'https://www.pnas.org/content/113/15/3991',
                null,
                'https://www.pnas.org/content/pnas/113/15/3991.full.pdf'
            ),
            (
                new_id + 2,
                'Lucquin, A., Robson, H.K., Eley, Y., Shoda, S., Veltcheva, D., Gibbs, K., Heron, C.P., Isaksson, S., Nishida, Y., Taniguchi, Y. and Nakajima, S.',
                2018,
                'The impact of environmental change on the use of early pottery by East Asian hunter-gatherers',
                'Lucquin, A., Robson, H.K., Eley, Y., Shoda, S., Veltcheva, D., Gibbs, K., Heron, C.P., Isaksson, S., Nishida, Y., Taniguchi, Y. and Nakajima, S. 2018. The impact of environmental change on the use of early pottery by East Asian hunter-gatherers. Proceedings of the National Academy of Sciences, 115(31), pp.7931-7936.',
                'https://www.pnas.org/content/115/31/7931',
                null,
                'https://www.pnas.org/content/pnas/115/31/7931.full.pdf'
            ),
            (
                new_id + 3,
                'Papakosta, V., Smittenberg, R.H., Gibbs, K., Jordan, P. and Isaksson, S.',
                2015,
                'Extraction and derivatization of absorbed lipid residues from very small and very old samples of ceramic potsherds for molecular analysis by gas chromatography–mass spectrometry (GC–MS) and single compound stable carbon isotope analysis by gas chromatography–combustion–isotope ratio mass spectrometry (GC–C–IRMS)',
                'Papakosta, V., Smittenberg, R.H., Gibbs, K., Jordan, P. and Isaksson, S. 2015. Extraction and derivatization of absorbed lipid residues from very small and very old samples of ceramic potsherds for molecular analysis by gas chromatography–mass spectrometry (GC–MS) and single compound stable carbon isotope analysis by gas chromatography–combustion–isotope ratio mass spectrometry (GC–C–IRMS). Microchemical Journal, 123, pp.196-200.',
                'https://doi.org/10.1016/j.microc.2015.06.013',
                'Incipient Jōmon,Absorbed lipid residues, Solvent extraction, Acidic extraction, Gas chromatography–mass spectrometry, Stable carbon isotopes',
                'https://reader.elsevier.com/reader/sd/pii/S0026265X15001356'
            ),
            (
                new_id + 4,
                'Meier‐Augenstein, W. and Kemp, H.F',
                2009,
                'Stable isotope analysis: general principles and limitations',
                'Meier‐Augenstein, W. and Kemp, H.F. 2009. Stable isotope analysis: general principles and limitations. Wiley Encyclopedia of Forensic Science.',
                'https://doi.org/10.1002/9780470061589.fsa1041',
                'investigative focus, isotope ratio, linkage, provenance, stable isotope signature, stable isotope profile',
                'https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=2&ved=2ahUKEwiytdS8jObiAhWwk4sKHeMUCW0QFjABegQIBRAC&url=https%3A%2F%2Fwww.researchgate.net%2Fprofile%2FClaudia_Cunha%2Fpost%2FWhat_archaeologicals_methods_can_be_applied_to_studies_of_anthropology_of_food%2Fattachment%2F59d61ea879197b807797d127%2FAS%253A279741983674372%25401443707094633%2Fdownload%2Ffsa1041.pdf&usg=AOvVaw2hbk-enYkzFDnz2kR4obyT'
            ),
            (
                new_id + 5,
                'Brock, F., Higham, T. and Ramsey, C.B.' ,
                2010,
                'Pre-screening techniques for identification of samples suitable for radiocarbon dating of poorly preserved bones',
                'Brock, F., Higham, T. and Ramsey, C.B. (2010). Pre-screening techniques for identification of samples suitable for radiocarbon dating of poorly preserved bones. Journal of Archaeological Science 37: 855 – 865.',
                'https://doi.org/10.1016/j.jas.2009.11.015',
                'Radiocarbon dating, Bone collagen, Nitrogen',
                'https://reader.elsevier.com/reader/sd/pii/S0305440309004336'
            )
        ) insert into tbl_biblio (biblio_id, authors, year, title, full_reference, doi, notes, url)
        select a.biblio_id, a.authors, a.year, a.title, a.full_reference, a.doi, a.notes, a.url
        from new_biblio a
        /*left join tbl_biblio b
            on a.biblio_id = b.biblio_id
        where b.biblio_id is null*/;

        new_id =  3895;
        with new_locations(location_id, location_name, location_type_id, default_lat_dd, default_long_dd) as ( values
        	(new_id +  0, 'Tochigi prefecture',	    2,	36.6763115,	    139.8094394),
        	(new_id +  1, 'Shiga prefecture',	    2,	35.2471599,	    136.1092995),
        	(new_id +  2, 'Hiroshima Prefecture',	2,	34.4557655,	    132.4373114),
        	(new_id +  3, 'Saga prefecture',	    2,	33.31162345,	130.258994),
        	(new_id +  4, 'Gunma prefecture',	    2,	36.5219914,	    139.0334981),
        	(new_id +  5, 'Niigata prefecture',	    2,	37.64508315,	138.7674579),
        	(new_id +  6, 'Kagoshima prefecture',	2,	29.6646725,	    129.8003557),
        	(new_id +  7, 'Hokkaido prefecture',	2,	43.43905915,	142.7220621),
        	(new_id +  8, 'Ehime prefecture',	    2,	33.5932911,	    132.8525472),
        	(new_id +  9, 'Nagano prefecture',	    2,	36.1143974,	    138.0318452),
        	(new_id + 10, 'Chiba prefecture',	    2,	35.50104105,	140.3091766),
        	(new_id + 11, 'Shizuoka prefecture',	2,	35.10951685,	138.3253921),
        	(new_id + 12, 'Kumamoto prefecture',	2,	32.6450942,	    130.6339892),
        	(new_id + 13, 'Yamanashi prefecture',	2,	35.57004815,	138.6572887),
        	(new_id + 14, 'Akita prefecture',	    2,	39.692085,	    140.343581),
        	(new_id + 15, 'Fukui prefecture',	    2,	35.8196589,	    136.1408376)
        ) insert into tbl_locations (location_id, location_name, location_type_id)
        select a.location_id, a.location_name, a.location_type_id
        from new_locations a
        /*left join tbl_locations b
            on a.location_id = b.location_id
        where b.location_id is null*/;

        -- perform sead_utility.sync_sequence('public', 'tbl_dataset_masters');
        -- perform sead_utility.sync_sequence('public', 'tbl_sample_location_types');
        -- perform sead_utility.sync_sequence('public', 'tbl_data_types');
        -- perform sead_utility.sync_sequence('public', 'tbl_isotope_types');
        -- perform sead_utility.sync_sequence('public', 'tbl_contacts');
        -- perform sead_utility.sync_sequence('public', 'tbl_biblio');
        -- perform sead_utility.sync_sequence('public', 'tbl_locations');

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
