-- Deploy bugs: 20190503_DDL_BUGS_ADD_TRANSLATIONS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-05-03
  Description   Add bugs import value translations
  Issue         https://github.com/humlab-sead/sead_change_control/issues/201
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

/*

    NOTE 20221124: These translations is also included in 20191221_DML_SUBMISSION_BUGS_20190303_COMMIT
     
*/

begin;
do $$
begin
    begin
        --delete from bugs_import.bugs_type_translations;
        --delete from bugs_import.id_based_translations;

		-- perform sead_utility.sync_sequences('bugs_import', 'bugs_type_translations', 'type_translation_id');
		-- perform sead_utility.sync_sequences('bugs_import', 'id_based_translations', 'id_based_translation_id');
        perform sead_utility.sync_sequences('bugs_import');
		
		with new_bugs_type_translations (bugs_table, bugs_column, triggering_column_value, target_column, replacement_value) as (
            values
            ('TSite', 'Region', 'Alpes Maritime', 'Region', 'Alpes-Maritimes'),
            ('TSite', 'Region', 'Ameraliksfjord', 'Region', 'Ameraliksfjordur'),
            ('TSite', 'Region', 'Angermannland', 'Region', 'Angermanland'),
            ('TSite', 'Region', 'Co. Down', 'Region', 'County Dowm'),
            ('TSite', 'Region', 'Co. Louth', 'Region', 'County Louth'),
            ('TSite', 'Region', 'Inverness shire', 'Region', 'Inverness-shire'),
            ('TSite', 'Region', 'Leics.', 'Region', 'Leicestershire'),
            ('TSite', 'Region', 'Møen', 'Region', 'Møn'),
            ('TSite', 'Region', 'Noord Brabant', 'Region', 'Noord-Brabant'),
            ('TSite', 'Region', 'Noord Holland', 'Region', 'Noord-Holland'),
            ('TSite', 'Region', 'North', 'Region', 'North Holland'),
            ('TSite', 'Region', null, 'Region', 'Not located'),
            ('TSite', 'Region', 'Notts.', 'Region', 'Nottinghamshire'),
            ('TSite', 'Region', 'Ostergottland', 'Region', 'Ostergotland'),
            ('TSite', 'Region', 'Ostobottnia media', 'Region', 'Ostrobothnia media'),
            ('TSite', 'Region', 'Ostrobottnia australis', 'Region', 'Ostrobothnia australis'),
            ('TSite', 'Region', 'Ostrobottnia borealis', 'Region', 'Ostrobothnia borealis'),
            ('TSite', 'Region', 'Ostrobottnia media', 'Region', 'Ostrobothnia media'),
            ('TSite', 'Region', 'Reykjavik', 'Region', 'Reykjavík'),
            ('TSite', 'Region', 'S Uist, Outer Hebrides', 'Region', 'South Uist, Outer Hebrides'),
            ('TSite', 'Region', 'Sjaelland', 'Region', 'Zealand'),
            ('TSite', 'Region', 'Vagsøy', 'Region', 'Vågsøy'),
            ('TSite', 'Region', 'Yorks', 'Region', 'Yorkshire'),
            ('TSite', 'Region', 'Ångermanland', 'Region', 'Angermanland'),
            ('TSite', 'Region', 'Västergötland
        Västergötland', 'Region', 'Västergötland'),
            ('TSite', 'Country', 'Iran', 'Country', 'Iran, Islamic Republic of'),
            ('TSite', 'Country', 'Slovakia', 'Country', 'Slovakia (Slovak Republic)'),
            ('TSite', 'Country', 'Faroes', 'Country', 'Faroe Islands'),
            ('TSite', 'Country', 'USA', 'Country', 'United States of America'),
            ('TCountsheet', 'SheetContext', 'Archaeological contexts', 'SheetContext', 'Archaeological site'),
            ('TCountsheet', 'SheetType', 'Abundances', 'SheetType', 'Abundance'),
            ('TCountsheet', 'SheetType', 'Presence/Absence', 'SheetType', 'Presence'),
            ('TCountsheet', 'SheetType', 'Presence / Absence', 'SheetType', 'Presence'),
            ('TCountsheet', 'SheetType', 'Partial abundances', 'SheetType', 'Partial abundance'),
            ('TCountsheet', 'SheetType', 'Partial Abundance', 'SheetType', 'Partial abundance'),
            ('TCountsheet', 'SheetType', 'Other', 'SheetType', 'Undefined other'),
            ('TCountsheet', 'SheetType', null, 'SheetType', 'Undefined other'),
            ('TBiology', 'Ref', 'van Dijk 1994', 'Ref', 'Van Dijk 1994'),
            ('TBiology', 'Ref', 'Sinclair 1993b', 'Ref', 'Sinclair 1993B'),
            ('TBiology', 'Ref', 'Whitehead 1992H', 'Ref', 'Whitehead 1992h'),
            ('TBiology', 'Ref', 'Whitehead 1992I', 'Ref', 'Whitehead 1992i'),
            ('TBiology', 'Ref', 'de Buysson 1912', 'Ref', 'De Buysson 1912'),
            ('TBiology', 'Ref', 'Allen 1972B', 'Ref', 'Allen 1972b'),
            ('TBiology', 'Ref', 'Winter 1992B', 'Ref', 'Winter 1992b'),
            ('TBiology', 'Ref', 'Key 1996A', 'Ref', 'Key 1996a'),
            ('TBiology', 'Ref', 'Cooter 1992B', 'Ref', 'Cooter 1992b'),
            ('TBiology', 'Ref', 'Morris 1992B', 'Ref', 'Morris 1992b'),
            ('TBiology', 'Ref', 'van Vondel 1991', 'Ref', 'Van Vondel 1991'),

            ('TDistrib', 'Ref', 'van Vondel 1991', 'Ref', 'Van Vondel 1991'),
            ('TDistrib', 'Ref', 'Sinclair 1993b', 'Ref', 'Sinclair 1993B'),
            ('TDistrib', 'Ref', 'Whitehead 1992E', 'Ref', 'Whitehead 1992e'),
            ('TDistrib', 'Ref', 'Whitehead 1992J', 'Ref', 'Whitehead 1992j'),
            ('TDistrib', 'Ref', 'Whitehead 1992H', 'Ref', 'Whitehead 1992h'),
            ('TDistrib', 'Ref', 'Whitehead 1992I', 'Ref', 'Whitehead 1992i'),
            ('TDistrib', 'Ref', 'Winter 1992B', 'Ref', 'Winter 1992b'),
            ('TDistrib', 'Ref', 'Key 1996A', 'Ref', 'Key 1996a'),
            ('TDistrib', 'Ref', 'Cooter 1992B', 'Ref', 'Cooter 1992b'),
            ('TDistrib', 'Ref', 'Morris 1992B', 'Ref', 'Morris 1992b'),

            ('TSpeciesAssociations', 'Ref', 'Krell et al 2005', 'Ref', 'Krell et al. 2005'),
            ('TSpeciesAssociations', 'Ref', 'Trautner (2006)', 'Ref', 'Trautner 2006'),
            ('TSpeciesAssociations', 'Ref', 'Skidmore unpub.', 'Ref', 'Skidmore unpubl.'),
            ('TSpeciesAssociations', 'Ref', 'Bilton 1988b', 'Ref', 'Bilton 1988'),
            ('TSpeciesAssociations', 'AssociationType', '?predated by', 'AssociationType', 'is predated by?'),
            ('TSpeciesAssociations', 'AssociationType', 'a parasite in nests of', 'AssociationType', 'is parasite in nests of'),
            ('TSpeciesAssociations', 'AssociationType', 'a predator on', 'AssociationType', 'is predator on'),
            ('TSpeciesAssociations', 'AssociationType', 'a predator on larvae of this sp.', 'AssociationType', 'is predator on larvae of'),
            ('TSpeciesAssociations', 'AssociationType', 'adults found in nest of', 'AssociationType', 'adults found in nests of'),
            ('TSpeciesAssociations', 'AssociationType', 'associated with', 'AssociationType', 'undefined association with'),
            ('TSpeciesAssociations', 'AssociationType', 'breeding in same log', 'AssociationType', 'found breeding in same log as'),
            ('TSpeciesAssociations', 'AssociationType', 'bug a predaotor on', 'AssociationType', 'is predator on'),
            ('TSpeciesAssociations', 'AssociationType', 'cleptoparasite', 'AssociationType', 'is kleptoparasitic on'),
            ('TSpeciesAssociations', 'AssociationType', 'commensal?', 'AssociationType', 'is commensal with?'),
            ('TSpeciesAssociations', 'AssociationType', 'in burrows of G mutator', 'AssociationType', 'in burrows of'),
            ('TSpeciesAssociations', 'AssociationType', 'in same habitat', 'AssociationType', 'in same habitat as'),
            ('TSpeciesAssociations', 'AssociationType', 'in same habitat, but not in burials', 'AssociationType', 'in same habitat, but not in burials, as'),
            ('TSpeciesAssociations', 'AssociationType', 'in same habitat, often in numbers.', 'AssociationType', 'in same habitat as, often in numbers,'),
            ('TSpeciesAssociations', 'AssociationType', 'in same habitat often together.', 'AssociationType', 'often together with, and in same habitat, as'),
            ('TSpeciesAssociations', 'AssociationType', 'in same habitat, often together with', 'AssociationType', 'often together with, and in same habitat, as'),
            ('TSpeciesAssociations', 'AssociationType', 'in same habitat.', 'AssociationType', 'in same habitat as'),
            ('TSpeciesAssociations', 'AssociationType', 'in same log', 'AssociationType', 'found in same log as'),
            ('TSpeciesAssociations', 'AssociationType', 'in same pools', 'AssociationType', 'in same pools as'),
            ('TSpeciesAssociations', 'AssociationType', 'in same trees', 'AssociationType', 'in same trees as'),
            ('TSpeciesAssociations', 'AssociationType', 'in same upland pools', 'AssociationType', 'in same upland pools as'),
            ('TSpeciesAssociations', 'AssociationType', 'in same wood', 'AssociationType', 'in same wood as'),
            ('TSpeciesAssociations', 'AssociationType', 'is probably parasitic on pupae of', 'AssociationType', 'is parasitic on pupae of?'),
            ('TSpeciesAssociations', 'AssociationType', 'kleptoparasite in nest', 'AssociationType', 'is kleptoparasitic in nests of'),
            ('TSpeciesAssociations', 'AssociationType', 'kleptoparasitic in burrows of', 'AssociationType', 'is kleptoparasitic in burrows of'),
            ('TSpeciesAssociations', 'AssociationType', 'kleptoparasitised by', 'AssociationType', 'is kleptoparasitised by'),
            ('TSpeciesAssociations', 'AssociationType', 'larva develop in nests of', 'AssociationType', 'larvae develop in nests of'),
            ('TSpeciesAssociations', 'AssociationType', 'Larvae predated by', 'AssociationType', 'larvae predated by'),
            ('TSpeciesAssociations', 'AssociationType', 'larvae predated on by this bug.', 'AssociationType', 'larvae predated by'),
            ('TSpeciesAssociations', 'AssociationType', 'loosely associated with', 'AssociationType', 'is loosely associated with'),
            ('TSpeciesAssociations', 'AssociationType', 'more common and in same habitat as', 'AssociationType', 'in same habitat, but more common than'),
            ('TSpeciesAssociations', 'AssociationType', 'on same host plant.', 'AssociationType', 'on same host plant as'),
            ('TSpeciesAssociations', 'AssociationType', 'overwintering in burrows', 'AssociationType', 'overwintering in burrows of'),
            ('TSpeciesAssociations', 'AssociationType', 'parasite in nests of', 'AssociationType', 'is parasite in nests of'),
            ('TSpeciesAssociations', 'AssociationType', 'parasitic on pupae of', 'AssociationType', 'is parasitic on pupae of'),
            ('TSpeciesAssociations', 'AssociationType', 'parasitized by', 'AssociationType', 'is parasitized by'),
            ('TSpeciesAssociations', 'AssociationType', 'parasitoid on', 'AssociationType', 'is parasitoid on'),
            ('TSpeciesAssociations', 'AssociationType', 'perhaps in same habitat', 'AssociationType', 'in same habitat as?'),
            ('TSpeciesAssociations', 'AssociationType', 'predated by', 'AssociationType', 'is predated by'),
            ('TSpeciesAssociations', 'AssociationType', 'Predated by', 'AssociationType', 'is predated by'),
            ('TSpeciesAssociations', 'AssociationType', 'predated by larvae of', 'AssociationType', 'is predated by larvae of'),
            ('TSpeciesAssociations', 'AssociationType', 'predated in nests by', 'AssociationType', 'is predated in own nests by'),
            ('TSpeciesAssociations', 'AssociationType', 'predated on by this ladybird', 'AssociationType', 'is predated by'),
            ('TSpeciesAssociations', 'AssociationType', 'predator in nests of', 'AssociationType', 'is predator in nests of'),
            ('TSpeciesAssociations', 'AssociationType', 'predator on', 'AssociationType', 'is predator on'),
            ('TSpeciesAssociations', 'AssociationType', 'predator on larvae', 'AssociationType', 'is predator on larvae of'),
            ('TSpeciesAssociations', 'AssociationType', 'predator on larvae of', 'AssociationType', 'is predator on larvae of'),
            ('TSpeciesAssociations', 'AssociationType', 'predator on larvae of?', 'AssociationType', 'is predator on larvae of?'),
            ('TSpeciesAssociations', 'AssociationType', 'predator on?', 'AssociationType', 'is predator on?'),
            ('TSpeciesAssociations', 'AssociationType', 'prey of', 'AssociationType', 'is predated by'),
            ('TSpeciesAssociations', 'AssociationType', 'probably parasitizes pupae of', 'AssociationType', 'is parasitic on pupae of?'),
            ('TSpeciesAssociations', 'AssociationType', 'pupae parasitized by', 'AssociationType', 'pupae parasitised by'),
            ('TSpeciesAssociations', 'AssociationType', 'rarer, but in same habitat as', 'AssociationType', 'in same habitat, but rarer than'),
            ('TSpeciesAssociations', 'AssociationType', 'same habitat', 'AssociationType', 'in same habitat as'),
            ('TSpeciesAssociations', 'AssociationType', 'same habitat as', 'AssociationType', 'in same habitat as'),
            ('TSpeciesAssociations', 'AssociationType', 'same riverine habitat as', 'AssociationType', 'in same riverine habitat as'),
            ('TSpeciesAssociations', 'AssociationType', 'same upland habitat', 'AssociationType', 'in same upland habitat as'),
            ('TSpeciesAssociations', 'AssociationType', 'in same upland habitat', 'AssociationType', 'in same upland habitat as'),
            ('TSpeciesAssociations', 'AssociationType', 'scavenger in nests of', 'AssociationType', 'is scavanger in nests of'),
            ('TSpeciesAssociations', 'AssociationType', 'similar habitat as', 'AssociationType', 'in similar habitat as'),
            ('TSpeciesAssociations', 'AssociationType', 'social parasite in nests of', 'AssociationType', 'is social parasite in nests of'),
            ('TSpeciesAssociations', 'AssociationType', 'social parasite of', 'AssociationType', 'is social parasite of'),
            ('TLab', 'Country', 'USA', 'Country', 'United States of America'),
            ('TLab', 'Country', 'USA???', 'Country', 'United States of America'),
            ('TLab', 'Country', 'Korea', 'Country', 'Korea, Republic Of'),
            ('TLab', 'Country', 'Slovakia', 'Country', 'Slovakia (Slovak Republic)'),
            ('TLab', 'Country', 'Russia', 'Country', 'Russian Federation'),
            ('TLab', 'Country', 'The Netherlands', 'Country', 'Netherlands'),
            ('TLab', 'Country', 'Republic of China', 'Country', 'China'),
            ('TLab', 'Country', 'Iran', 'Country', 'Iran, Islamic Republic of'),
            ('TLab', 'Country', 'République du Sénégal', 'Country', 'Senegal'),
            -- ('TLab', 'Country', 'Senegal', 'Country', 'République du Sénégal'),
            ('TPeriods', 'PeriodCODE', 'Unknown', 'PeriodCODE', '?'),
            ('TPeriods', 'PeriodGeog', 'UK', 'PeriodGeog', 'United Kingdom'),
            ('TPeriods', 'PeriodType', 'Archaeological', 'PeriodType', 'Archaeological period'),
            ('TPeriods', 'PeriodType', 'Geological', 'PeriodType', 'Geological period'),
            ('TPeriods', 'PeriodType', 'Other', 'PeriodType', 'Other age type'),
            ('TPeriods', 'PeriodType', 'Historical', 'PeriodType', 'Historical period'),
            ('TPeriods', 'YearsType', 'Calender', 'YearsType', 'Calendar'),
            ('TDatesCalendar', 'DatingMethod', 'Tephra', 'DatingMethod', 'TephraCal'),
            ('TDatesCalendar', 'DatingMethod', 'Typo', 'DatingMethod', 'TypoCal'),
            ('TDatesCalendar', 'DatingMethod', 'ArchPer', 'DatingMethod', 'ArchPerCal'),
            ('TDatesCalendar', 'DatingMethod', 'GeolPer', 'DatingMethod', 'GeolPerCal'),
            ('TDatesCalendar', 'DatingMethod', 'Humous', 'DatingMethod', 'C14 Humous'),
            ('TDatesCalendar', 'DatingMethod', 'Pollen', 'DatingMethod', 'PollenZone'),
            ('TDatesCalendar', 'Uncertainty', 'from ca.', 'Uncertainty', 'From ca.'),
            ('TDatesCalendar', 'Uncertainty', 'To >', 'Uncertainty', '>'),
            ('TDatesCalendar', 'Uncertainty', 'Tc ca.', 'Uncertainty', 'To ca.'),
            ('TDatesCalendar', 'Uncertainty', 'Ca,', 'Uncertainty', 'Ca.'),
            ('TDatesRadio', 'DatingMethod', 'Typo', 'DatingMethod', 'TypoRadio'),
            ('TDatesRadio', 'DatingMethod', 'GeolPer', 'DatingMethod', 'GeolPerRadio'),
            ('TDatesRadio', 'Uncertainty', 'c', 'Uncertainty', 'Ca.'),
            ('TDatesRadio', 'Uncertainty', 'ca.', 'Uncertainty', 'Ca.'),
            ('TDatesRadio', 'Uncertainty', 'from', 'Uncertainty', 'From'),
            ('TDatesRadio', 'Uncertainty', 'to', 'Uncertainty', 'To'),
            ('TDatesRadio', 'Uncertainty', ' >', 'Uncertainty', '>'),
            ('TDatesRadio', 'Uncertainty', 'ca', 'Uncertainty', 'Ca.'),
            ('TDatesRadio', 'LabID', 'Birmingham', 'LabID', 'Birm'),
            ('TDatesRadio', 'LabID', 'Suerc', 'LabID', 'SUERC'),
            ('TDatesPeriod', 'PeriodCODE', 'OIS-05e', 'PeriodCODE', 'MIS-05e'),
            ('TDatesPeriod', 'PeriodCODE', 'OIS-06', 'PeriodCODE', 'MIS-06'),
            ('TDatesPeriod', 'PeriodCODE', 'OIS-07', 'PeriodCODE', 'MIS-07'),
            ('TDatesPeriod', 'PeriodCODE', 'OIS-09', 'PeriodCODE', 'MIS-09'),
            ('TDatesPeriod', 'PeriodCODE', 'OIS-12', 'PeriodCODE', 'MIS-12'),
            ('TDatesPeriod', 'PeriodCODE', 'OIS-13', 'PeriodCODE', 'MIS-13'),
            ('TDatesPeriod', 'DatingMethod', ' ', 'DatingMethod', null),
            ('TSeasonActiveAdult', 'HSeason', 'Sep', 'HSeason', 'Se'),
            -- ('TDatesPeriod', 'DatingMethod', 'GeolPer', 'TDatesPeriod', 'GeolPer'),
            ('INDEX', 'AUTHORITY', 'Muls & Rey', 'AUTHORITY', 'Muls. & Rey'),
            ('TSynonym', 'SynAuthority', 'Muls & Rey', 'SynAuthority', 'Muls. & Rey'),
            ('TSynonym', 'SynAuthority', 'Motschulsky)', 'SynAuthority', 'Motschulsky'),
            ('TSynonym', 'Ref', 'Böhme 2005', 'Ref', 'Bohme 2005'),
            ('TSynonym', 'SynSpecies', 'birulai', 'SynGenus', 'Helophorus'),
            ('TAttributes', 'AttribUnits', 'm', 'AttribUnits', 'mm'),
            ('TAttributes', 'AttribUnits', '..', 'AttribUnits', 'mm'),
            -- 20191013: Additional translation from bugs import error log.
            ('TSpeciesAssociations', 'AssociationType', 'undefined association with', 'AssociationType', 'has undefined association with'),
            ('TSpeciesAssociations', 'AssociationType', 'inquiline', 'AssociationType', 'inquiline with'),
            ('TSpeciesAssociations', 'AssociationType', 'around nests of', 'AssociationType', 'found around nests of'),
            ('TSpeciesAssociations', 'AssociationType', 'Swarming', 'AssociationType', 'swarms with'),
            -- ('TSpeciesAssociations', 'AssociationType', 'is predated by', 'AssociationType', 'is predated on by'),
            ('TSpeciesAssociations', 'AssociationType', 'larvae predated by', 'AssociationType', 'larvae predated on by'),
            ('TSpeciesAssociations', 'AssociationType', 'cuckoo parasite in burrows of', 'AssociationType', 'is cuckoo parasite in burrows of'),
            ('TSpeciesAssociations', 'AssociationType', 'is kleptoparasitic in nests of', 'AssociationType', 'kleptoparasite in nest of'),
            ('TSpeciesAssociations', 'AssociationType', 'semi-parasitic with ', 'AssociationType', 'is semi-parasitic with'),
            ('TSpeciesAssociations', 'AssociationType', 'is parasite on pupae of?', 'AssociationType', 'parasitizes pupae of?'),
            ('TSpeciesAssociations', 'AssociationType', 'parasite of', 'AssociationType', 'is parasite of'),
            -- ('TSpeciesAssociations', 'AssociationType', 'in same habitat as', 'AssociationType', 'in same habitat'),
            ('TSpeciesAssociations', 'AssociationType', 'pupae parasitised by', 'AssociationType', 'pupa parasitised by'),
            ('TSpeciesAssociations', 'AssociationType', 'endoparasite of pupa', 'AssociationType', 'is endoparasite of pupae of ')
		   	)
            	insert into bugs_import.bugs_type_translations (bugs_table, bugs_column, triggering_column_value, target_column, replacement_value)
					select bugs_table, bugs_column, triggering_column_value, target_column, replacement_value
			  		from new_bugs_type_translations;
        
        with new_id_based_translations (bugs_definition, bugs_table, target_column, replacement_value) as (values

            ('SITE000006', 'TSite', 'Country', 'United Kingdom'),
            ('COUN000955', 'TCountsheet', 'SheetType', 'Presence'),
            ('COUN001127', 'TCountsheet', 'SheetType', 'Presence'),

            ('SAMP004604', 'TSample', 'X', null),
            ('SAMP005693', 'TSample', 'X', null),
            ('SAMP005436', 'TSample', 'X', null),
            ('SAMP005208', 'TSample', 'X', null),
            ('SAMP008714', 'TSample', 'X', null),

            ('Birm', 'TLab', 'Country', 'United Kingdom'),

            ('MIS-01', 'TPeriods', 'BeginBCAD', 'BP'),
            ('LRoman/ASax', 'TPeriods', 'PeriodType', 'Archaeological period'),
            ('BA', 'TPeriods', 'BeginBCAD', 'BP'),
            -- ('Modern', 'TPeriods', 'EndBCAD', 'AD'),
            -- ('Modern', 'TPeriods', 'End', '1950'),
            ('CALE000318', 'TDatesCalendar', 'BCADBP', 'AD'),

            ('559', 'TSpeciesAssociations', 'AssociatedSpeciesCODE', '23.08802300'),
            ('03.0030010', 'INDEX', 'GENUS', 'Peltodytes')
        )
            insert into bugs_import.id_based_translations (bugs_definition, bugs_table, target_column, replacement_value) 
                select bugs_definition, bugs_table, target_column, replacement_value
                from new_id_based_translations;

        perform sead_utility.sync_sequences('bugs_import');

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
