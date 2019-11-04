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

        with new_dataset_masters (master_set_id, contact_id, master_name, master_note, url) as (values
            (99999, 999999, 'Sample data Isotopes', 'Sample data for implementing isotope data in to SEAD', '')
        ) insert into tbl_dataset_masters (master_set_id, master_name, url)
        select a.master_set_id, a.master_name, a.url
        from new_dataset_masters a
        /*left join tbl_dataset_masters b
            on a.master_set_id = b.master_set_id
        where b.master_set_id is null*/;

        with new_sample_location_types (sample_location_type_id, location_type, location_type_description) as (values
        	(9999, 'cheramic part', 'Description of what part of ceramic vessel/structure were sampled'),
	        (9999, 'sample position', 'Describes what substance and/or more accurate information on where on the ceramic part the sample came from (e.g. charred deposit from inside the vessel)')
        ) insert into tbl_sample_location_types (sample_location_type_id, location_type, location_type_description)
        select a.sample_location_type_id, a.location_type, a.location_type_description
        from new_sample_location_types a
        /*left join tbl_sample_location_types b
            on a.sample_location_type_id = b.sample_location_type_id
        where b.sample_location_type_id is null*/;

        with new_data_types (data_type_id, data_type_group_id, data_type_name, definition) as (values
            (9999, 1, 'Mixed-method dependent', 'Multiple datatypes from one method. (e.g. multiple isotope types from masspectrometry')),
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

        with new_isotope_types(isotope_type_id, designation, abbreviation, atomic_number, description)
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
            (119, 'collagen g', 'collagen g', , 'weight of collagen in sample (in milligrams)'),
            (120, 'collagen %', 'collagen %', , 'procentage of collagen in sample'),
            (121, 'Concentration', 'Concentration', , 'Concentration in lipids (µg g-1)'),
            (122, 'Meaningful lipids present', 'Meaningful lipids present', , 'Concentration in lipids above threeshold or with biomarkers'),
            (123, 'APAA C16', 'APAA C16', , 'Presence of  C16 ω-(ο-alkylphenyl) alkanoic acids '),
            (124, 'APAA C18', 'APAA C18', , 'Presence of  C18 ω-(ο-alkylphenyl) alkanoic acids '),
            (125, 'APAA C20', 'APAA C20', , 'Presence of  C20 ω-(ο-alkylphenyl) alkanoic acids '),
            (126, 'APAA C22', 'APAA C22', , 'Presence of  C22 ω-(ο-alkylphenyl) alkanoic acids '),
            (127, 'DHYA C16', 'DHYA C16', , 'Presence of  C16 dihydroxyacids'),
            (128, 'DHYA C18', 'DHYA C18', , 'Presence of  C18 dihydroxyacids'),
            (129, 'DHYA C20', 'DHYA C20', , 'Presence of  C20 dihydroxyacids'),
            (130, 'DHYA C22', 'DHYA C22', , 'Presence of  C22 dihydroxyacids'),
            (131, 'TMTD', 'TMTD', , 'Presence of  4,8,12-Trimethyltridecanoic acid'),
            (132, 'Pristanic', 'Pristanic', , 'Presence of  pristanic acid'),
            (133, 'Phytanic', 'Phytanic', , 'Presence of phytanic acid'),
            (134, 'SRR%', 'SRR%', , 'The contribution of the SRR isomer in total phytanic acid (SRR%)'),
            (135, 'Plant signal (PHYST)', 'Plant signal (PHYST)', , 'Presence of plant biomarkers of type PHYST'),
            (136, 'Full aquatic biomarker', 'Full aquatic biomarker', , 'Presence of  at least C20 ω-(ο-alkylphenyl) alkanoic acids  associated to an isoprenoid fatty acid indicative of an aquatic source'),
            (137, 'Partial aquatic biomarker', 'Partial aquatic biomarker', , 'Presence of  C18 ω-(ο-alkylphenyl) alkanoic acids  associated to 4,8,12-Trimethyltridecanoic acid probqbly related to an aquatic source'),
            (138, '>75.5% SRR-phytanic', '>75.5% SRR-phytanic', , 'SRR%>75.5 indicative of an aquatic source'),
            (139, 'Aquatic signal', 'Aquatic signal', , 'Extract with Full aquatic biomarker or >75.5% SSR-phytanic'),
            (140, 'GC-c-IRMS', 'GC-c-IRMS', , 'Compound Specific Isotopes Analysis carried out'),
            (141, 'Fraction (C16:0)', 'Fraction (C16:0)', , 'Biochemical fraction for measurement (C16:0)'),
            (142, '13C/12C', '13C/12C', , '13C/12C isotopic measurement'),
            (143, '13C/12C unc', '13C/12C unc', , 'uncertainty of 13C/12C isotopic measurement'),
            (144, 'Fraction (C18:0)', 'Fraction (C18:0)', , 'Biochemical fraction for measurement (C18:0)'),
            (145, '13C/12C', '13C/12C', , '13C/12C isotopic measurement'),
            (146, '13C/12C unc', '13C/12C unc', , 'uncertainty of 13C/12C isotopic measurement'),
            (147, '13C/12C offset fractions (C18:0-C16:0)', '13C/12C offset fractions (C18:0-C16:0)', , 'Δ13C (C16:0-C18:0)'),
            (148, 'EA-IRMS', 'EA-IRMS', , 'Bulk Isotopes Analysis carried out'),
            (149, 'Fraction (Bulk)', 'Fraction', , 'Biochemical fraction for measurement (Bluk)'),
            (150, 'Quality control', 'Quality control', , 'Above %N threashold (1%)'),
            (151, '13C/12C', '13C/12C', , '13C/12C isotopic measurement'),
            (152, '13C/12C unc', '13C/12C unc', , 'uncertainty of 13C/12C isotopic measurement'),
            (153, '15N/14N', '15N/14N', , '15N/14N isotopic measurement'),
            (154, '15N/14N unc', '15N/14N unc', , 'uncertainty of 15N/14N isotopic measurement'),
            (155, '%C', '%C', , 'C elemental concentration in bone collagen'),
            (156, '%N', '%N', , 'N elemental concentration in bone collagen'),
            (157, 'C/N (atomic)', 'C/N (atomic)', , 'C/N elemental ratio'),
            (158, 'Numbers of labstandards/delta samples', 'Numbers of labstandards/delta samples', , 'The number of lab/international-standards/deltasamples run before the acctual sample were analyzed'),
            (159, 'Bone/dentine (mg)', 'Bone/dentine (mg)', , 'Weight of bone or dentine in sample (in milligrams)'),
            (160, 'Collagen (mg)', 'Collagen (mg)', , 'Weight of collagen in sample (in milligrams)'),
            (161, 'N/S', 'N/S', , 'Ratio of Nitrogen and Sulfur in sample'),
            (162, 'C/S', 'C/S', , 'Ratio of Carbon and Sulfur in sample'),
            (163, 'Plant signal (ALK)', 'Plant signal (ALK)', , 'Presence of plant biomarkers of type ALK'),
            (164, 'Plant signal (LCFA)', 'Plant signal (LCFA)', , 'Presence of plant biomarkers of type LCFA')
        ) insert into tbl_isotope_types (isotope_type_id, designation, abbreviation, atomic_number, description)
        select a.isotope_type_id, a.designation, a.abbreviation, a.atomic_number, a.description
        from new_isotope_types a
        /*left join tbl_isotope_types b
            on a.isotope_type_id = b.isotope_type_id
        where b.isotope_type_id is null*/;

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
