-- Deploy general: 20140417_DML_RELATIVE_AGE_ADD_DATA

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

        set constraints all deferred;

        with new_relative_age_types("relative_age_type_id", "age_type", "description", "date_updated") as (values
            (14, 'Calibrated 14C 2sd age range', NULL, '2016-10-20')
        ) insert into "public"."tbl_relative_age_types"("relative_age_type_id", "age_type", "description", "date_updated")
          select n."relative_age_type_id", n."age_type", n."description", n."date_updated"::timestamp with time zone
          from new_relative_age_types n
          left join tbl_relative_age_types x
            on x.relative_age_type_id = n.relative_age_type_id
          where x.relative_age_type_id is null;

        with new_relative_ages("relative_age_id", "relative_age_type_id", "relative_age_name", "description", "c14_age_older", "c14_age_younger", "cal_age_older", "cal_age_younger", "notes", "date_updated", "location_id", "abbreviation") as (values
                (1, 3, 'Alleröd', 'Pollen Zone II', 12000.00000, 10500.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'BS-Al'),
                (2, 3, 'Atlantic', 'Pollen Zone VI-VIIa', 7000.00000, 5000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'BS-At'),
                (3, 3, 'Boreal', 'Pollen Zone V', 9500.00000, 7000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'BS-Bo'),
                (4, 3, 'Older Dryas', 'Pollen Zone I', 10500.00000, 10000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'BS-OD'),
                (5, 3, 'Pre-Boreal', 'Pollen Zone IV', 10000.00000, 9500.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'BS-PB'),
                (6, 3, 'Sub-Stlantic', 'Pollen Zone VIII', 2500.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'BS-SA'),
                (7, 3, 'Sub-Boreal', 'Pollen Zone VIIb', 5000.00000, 2500.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'BS-SB'),
                (8, 3, 'Younger Dryas', 'Pollen Zone III', 10500.00000, 10000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'BS-YD'),
                (9, 4, 'Oxygen Isotope Stage 1', 'Warm;=Flandrian;=Holocene', 0.00000, 10000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-01'),
                (10, 4, 'Oxygen Isotope Stage 2', NULL, NULL, NULL, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-02'),
                (11, 4, 'Oxygen Isotope Stage 5e', 'Warm;=Ipswichian;Approx dates (max range)', 132000.00000, 122000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-05e'),
                (12, 4, 'Oxygen Isotope Stage 7', 'Warm;=Marsworth?', 245000.00000, 186000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-07'),
                (13, 4, 'Oxygen Isotope Stage 9', 'Warm;=Hoxnian;Approx dates (max range)', 440000.00000, 302000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-09'),
                (14, 4, 'Oxygen Isotope Stage 11', 'Warm;=Swanscombe', 423000.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-11'),
                (15, 4, 'Oxygen Isotope Stage 12', '=Anglian', 478000.00000, 423000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-12'),
                (16, 5, 'Pollen Zone I', 'Godwin''s Zones', 12000.00000, 10500.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'PZ-I'),
                (17, 5, 'Pollen Zone II', 'Godwin''s Zones', 12000.00000, 10500.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'PZ-II'),
                (18, 5, 'Pollen Zone III', 'Godwin''s Zones', 10500.00000, 10000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'PZ-III'),
                (19, 5, 'Pollen Zone IV', 'Godwin''s Zones', 10000.00000, 9500.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'PZ-IV'),
                (20, 5, 'Pollen Zone V', 'Godwin''s Zones', 9500.00000, 9000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'PZ-V'),
                (21, 5, 'Pollen Zone VI', 'Godwin''s Zones', 9000.00000, 7000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'PZ-VI'),
                (22, 5, 'Pollen Zone VIIa', 'Godwin''s Zones', 7000.00000, 5000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'PZ-VIIa'),
                (23, 5, 'Pollen Zone VIIa/b', 'Godwin''s Zones', 7000.00000, 2500.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'PZ-VIIa/b'),
                (24, 5, 'Pollen Zone VIIb', 'Godwin''s Zones', 5000.00000, 2500.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'PZ-VIIb'),
                (25, 5, 'Pollen Zone VIII', 'Godwin''s Zones', 2500.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'PZ-VIII'),
                (26, 1, 'Historical', NULL, 2000.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1662, 'Hist'),
                (27, 1, 'Arab', 'From beginning of Arab conquest of Eastern Mediterranean to fall of Ottoman Empire', NULL, NULL, 1318.00000, 32.00000, NULL, '2014-04-17', 1663, 'Arab'),
                (28, 1, 'Byzantine', 'Eastern Mediterranean from fall of Rome to Ottoman conquest of Constantinople', NULL, NULL, 1540.00000, 500.00000, NULL, '2014-04-17', 1663, 'Byzantine'),
                (29, 1, 'Graeco-Roman', NULL, NULL, NULL, 2450.00000, 1550.00000, NULL, '2014-04-17', 1663, 'GraecoRom'),
                (30, 1, 'Medieval', NULL, NULL, NULL, 1550.00000, 400.00000, NULL, '2014-04-17', 1664, 'Med'),
                (31, 1, 'Mesolithic', NULL, 10000.00000, 5000.00000, NULL, NULL, NULL, '2014-04-17', 1664, 'Meso'),
                (32, 1, 'Middle Kingdom', NULL, 0.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 64, 'Mking'),
                (33, 1, 'New Kingdom', 'Egyptian New Kingdom', NULL, NULL, 3300.00000, 3280.00000, NULL, '2014-04-17', 64, 'NewKingdom'),
                (34, 1, 'pre-Landnam', 'Pre Landnam ash in Iceland', NULL, NULL, NULL, 1082.00000, NULL, '2014-04-17', 100, 'preLandnam'),
                (35, 1, 'Roman Italy', 'Roman Italy', NULL, NULL, 2200.00000, 1540.00000, NULL, '2014-04-17', 107, 'Roman Italia'),
                (36, 1, 'Roman Gallia', 'Roman France', NULL, NULL, 2010.00000, 1500.00000, NULL, '2014-04-17', 74, 'RomanF'),
                (37, 1, 'Roman Germania', 'Roman Germany', NULL, NULL, 2006.00000, 1500.00000, NULL, '2014-04-17', 82, 'RomanG'),
                (38, 1, 'Saxon', 'Saxon (England)', NULL, NULL, 1540.00000, 884.00000, NULL, '2014-04-17', 240, 'Saxon'),
                (39, 1, 'Neolithic', NULL, 5000.00000, 4000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'Neo'),
                (40, 1, 'Old Kingdom', 'Egypt', NULL, NULL, 5450.00000, 4450.00000, NULL, '2014-04-17', 1661, 'Old Kingdom'),
                (41, 1, 'Palaeolithic', NULL, NULL, 10000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'Palaeo'),
                (42, 1, 'Post Medieval', NULL, 1550.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'PostMed'),
                (43, 1, 'Ptolemaic', 'Egypt post Alexander, pre-Roman', NULL, NULL, 2273.00000, 2000.00000, NULL, '2014-04-17', 1661, 'Ptol'),
                (44, 1, 'Sarqaq', 'Sarqaq Eskimo hunter-gatherer sites in Greenland', NULL, NULL, 4450.00000, 2450.00000, NULL, '2014-04-17', 1661, 'Sarqaq'),
                (45, 1, 'Spanish adobe', 'Post Columbian North & Central America', NULL, NULL, 458.00000, 100.00000, NULL, '2014-04-17', 1661, 'Spanish adobe'),
                (46, 1, 'Viking', NULL, NULL, NULL, 1150.00000, 850.00000, NULL, '2014-04-17', 1661, 'Viking'),
                (47, 1, 'Anglo-Scandinavian', 'Early medieval', NULL, NULL, 1150.00000, 850.00000, NULL, '2014-04-17', 224, 'AS'),
                (48, 1, 'Bronze Age', 'UK Bronze Age', 2500.00000, NULL, NULL, 2550.00000, NULL, '2014-04-17', 224, 'BA'),
                (49, 1, 'Early Saxon', 'Saxon (England)', NULL, NULL, 1540.00000, 1250.00000, NULL, '2014-04-17', 224, 'ESaxon'),
                (50, 1, 'Late Bronze Age UK', NULL, NULL, NULL, 2950.00000, 2600.00000, NULL, '2014-04-17', 224, 'LBronze'),
                (51, 1, 'Late Iron Age UK', NULL, NULL, NULL, 2200.00000, 1907.00000, NULL, '2014-04-17', 224, 'LIron'),
                (52, 1, 'Late Medieval UK', NULL, NULL, NULL, 500.00000, 350.00000, NULL, '2014-04-17', 224, 'LMed'),
                (53, 1, 'Late Roman UK', NULL, NULL, NULL, 1700.00000, 1550.00000, NULL, '2014-04-17', 224, 'LRoman'),
                (54, 1, 'Roman Britannia', 'Roman Britain', NULL, NULL, 1907.00000, 1540.00000, NULL, '2014-04-17', 224, 'RomanUK'),
                (55, 9, 'Holocene', 'MIS 1; Interglacial', 10000.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1664, 'Holocene'),
                (56, 9, 'Lateglacial', 'Pollen Zones I-III', 13500.00000, 10000.00000, NULL, NULL, NULL, '2014-04-17', 1664, 'LG'),
                (57, 9, 'Lateglacial Interstadial', 'Pollen Zones I-II', 12500.00000, 11500.00000, NULL, NULL, NULL, '2014-04-17', 1664, 'LGI'),
                (58, 9, 'Lateglacial Stadial', 'Pollen Zone III; Younger Dryas', 11500.00000, 10000.00000, NULL, NULL, NULL, '2014-04-17', 1664, 'LGS'),
                (59, 9, 'Late Holocene', 'Pollen Zones VIIb-VIII', 5000.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1664, 'LH'),
                (60, 9, 'Eemian', 'MIS 5e;Interglacial', 128000.00000, 110000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'Eemian'),
                (61, 9, 'Early Holocene', 'Pollen Zone IV-VI', 10000.00000, 7000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'EH'),
                (62, 9, 'Early Pleistocene', 'MIS 23-13', 2400000.00000, NULL, NULL, NULL, NULL, '2014-04-17', 1661, 'EPleist'),
                (63, 9, 'Early Weichselian', '=  MIS-5d - 4', 122000.00000, 45000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'EW'),
                (64, 9, 'Mid Holocene', '= Pollen Zone VIIa', 7000.00000, 5000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MH'),
                (65, 9, 'Middle Pleistocene', 'MIS 12-8', NULL, NULL, NULL, NULL, NULL, '2014-04-17', 1661, 'MPleist'),
                (66, 9, 'Pleistocene', 'MIS 23-2', NULL, NULL, 2401950.00000, 11950.00000, NULL, '2014-04-17', 1661, 'Pleisto'),
                (67, 9, 'Pliocene', NULL, NULL, 2400000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'Plio'),
                (68, 9, 'Weichselian', 'MIS-5d to MIS-2', 122000.00000, 10000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'W'),
                (69, 9, 'Wolstonian', 'MIS-8 to MIS-6;Approx dates (max range)', 302000.00000, 186000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'Wolst'),
                (70, 9, 'Wurm', '= Weichselian', NULL, NULL, NULL, NULL, NULL, '2014-04-17', 1661, 'Wurm'),
                (71, 9, 'Anglian', '=MIS-12;Cold', 478000.00000, 423000.00000, NULL, NULL, NULL, '2014-04-17', 224, 'Anglian'),
                (72, 9, 'Chelford', '? MIS-5c Interstadia', NULL, 58000.00000, NULL, NULL, NULL, '2014-04-17', 224, 'Chelford'),
                (73, 9, 'Cromerian', 'MIS-13 Interglacial', NULL, 478000.00000, NULL, NULL, NULL, '2014-04-17', 224, 'Cromerian'),
                (74, 9, 'Devensian', '= Weichselian;MIS-5d to MIS-2', 122000.00000, 10000.00000, NULL, NULL, NULL, '2014-04-17', 224, 'Devensian'),
                (75, 9, 'Dimlington Stadial', 'MIS2', 26000.00000, 13000.00000, NULL, NULL, NULL, '2014-04-17', 224, 'DimlingtonSt'),
                (76, 9, 'Early Wolstonian', 'MIS-8 to ?;End date?;Approx dates (max range)', 302000.00000, NULL, NULL, NULL, NULL, '2014-04-17', 224, 'EWolst'),
                (77, 9, 'Flandrian', '= Holocene;Interglacial', 10000.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 224, 'Flandrian'),
                (78, 9, 'Hoxnian', '= MIS-9 and 11 undifferentiated', 428000.00000, 302000.00000, NULL, NULL, NULL, '2014-04-17', 224, 'Hoxnian'),
                (79, 9, 'Ipswichian', '=MIS- 5e - 7 undifferentiated;Warm;Approx date (max range);Interglacial', 132000.00000, 122000.00000, NULL, NULL, NULL, '2014-04-17', 224, 'Ipswichian'),
                (80, 9, 'Loch Lomond', 'Cold = Lateglacial Stadial = PZ-III', 11500.00000, 10000.00000, NULL, NULL, NULL, '2014-04-17', 224, 'LL'),
                (81, 9, 'Middle Devensian', '=MIS-3', 50000.00000, 25000.00000, NULL, NULL, NULL, '2014-04-17', 224, 'MD'),
                (82, 9, 'Mid-Devensian', '= mid-Weichselian;MIS-3', 122000.00000, 10000.00000, NULL, NULL, NULL, '2014-04-17', 224, 'Mid-Devensian'),
                (83, 9, 'Upton Warren', '= MIS-5a;Interstadial?', NULL, NULL, 43000.00000, 40000.00000, NULL, '2014-04-17', 224, 'UWI'),
                (84, 9, 'Windermere', 'Warm;Interstadial', 13000.00000, 11000.00000, NULL, NULL, NULL, '2014-04-17', 224, 'Windermere'),
                (85, 11, 'Modern', NULL, NULL, 0.00000, 50.00000, NULL, NULL, '2014-04-17', 1661, 'Modern'),
                (86, 11, 'Interglacial, uncertain age', 'Samples from interglacial period of uncertain time origin', NULL, NULL, NULL, NULL, NULL, '2014-04-17', 1661, 'InterG'),
                (87, 2, 'Recent', 'Modern collection data', NULL, NULL, 50.00000, -100.00000, NULL, '2014-04-17', 1661, 'Recent'),
                (88, 1, 'Pre-Columbian', 'Records of Palaearctic or Holoarctic spp in the New World before the arrival of Columbus.', NULL, NULL, 0.00000, 458.00000, NULL, '2014-04-17', 1665, 'Pre-Columbian'),
                (89, 1, 'Iron Age', NULL, NULL, NULL, 2600.00000, 1900.00000, NULL, '2014-04-17', 224, 'Iron'),
                (90, 1, 'Post-Roman', 'Used for sites outside the areas of ''Saxon'' settlement in E England', NULL, NULL, 1550.00000, 1250.00000, NULL, '2014-04-17', 224, 'PostRom'),
                (91, 9, 'Early Devensian', NULL, 0.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 224, 'Edev'),
                (92, 4, 'Oxygen Isotope Stage 3', NULL, 0.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-03'),
                (93, 4, 'Oxygen Isotope Stage 4', NULL, 0.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-04'),
                (94, 4, 'Oxygen Isotope Stage 5', NULL, 0.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-05'),
                (95, 4, 'Oxygen Isotope Stage 5a', 'Warm;=UWI', 0.00000, 70000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-05a'),
                (96, 4, 'Oxygen Isotope Stage 5b', NULL, 0.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-05b'),
                (97, 4, 'Oxygen Isotope Stage 5c', 'Warm;=Chelford', 0.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-05c'),
                (98, 4, 'Oxygen Isotope Stage 5d', NULL, 0.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-05d'),
                (99, 4, 'Oxygen Isotope Stage 6', NULL, 0.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-06'),
                (100, 4, 'Oxygen Isotope Stage 8', NULL, 0.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-08'),
                (101, 4, 'Oxygen Isotope Stage 10', NULL, 0.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-10'),
                (102, 4, 'Oxygen Isotope Stage 13', 'Warm;=Cromerian', 0.00000, 478000.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-13'),
                (103, 4, 'Oxygen Isotope Stage 14', NULL, 0.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-14'),
                (104, 4, 'Oxygen Isotope Stage 14/15', NULL, 0.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-14/15'),
                (105, 4, 'Oxygen Isotope Stage 15', 'Warm;=Waverly Wood', 0.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-15'),
                (106, 4, 'Oxygen Isotope Stage 16', NULL, 0.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-16'),
                (107, 4, 'Oxygen Isotope Stage 17', NULL, 0.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-17'),
                (108, 4, 'Oxygen Isotope Stage 18', NULL, 0.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-18'),
                (109, 4, 'Oxygen Isotope Stage 19', NULL, 0.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-19'),
                (110, 4, 'Oxygen Isotope Stage 20', NULL, 0.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-20'),
                (111, 4, 'Oxygen Isotope Stage 21', NULL, 0.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-21'),
                (112, 4, 'Oxygen Isotope Stage 22', NULL, 0.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-22'),
                (113, 4, 'Oxygen Isotope Stage 23', NULL, 0.00000, 0.00000, NULL, NULL, NULL, '2014-04-17', 1661, 'MIS-23'),
                (389, 1, 'Early Roman', 'Early Roman without regional definition', NULL, NULL, NULL, NULL, NULL, '2018-05-02 09:11:22.794774+02', NULL, 'ERom')
        ) insert into "public"."tbl_relative_ages"("relative_age_id", "relative_age_type_id", "relative_age_name", "description", "c14_age_older", "c14_age_younger", "cal_age_older", "cal_age_younger", "notes", "date_updated", "location_id", "abbreviation")
            select n."relative_age_id", n."relative_age_type_id", n."relative_age_name", n."description", n."c14_age_older", n."c14_age_younger", n."cal_age_older", n."cal_age_younger", n."notes", n."date_updated"::timestamp with time zone, n."location_id", n."abbreviation"
            from new_relative_ages n
            left join tbl_relative_ages x
              on x.relative_age_id = n.relative_age_id
            where x.relative_age_id is null;

        with new_relative_age_refs ("relative_age_ref_id", "biblio_id", "date_updated", "relative_age_id") as (
            values
                (1, 1000, '2014-04-17', 1),
                (2, 1000, '2014-04-17', 2),
                (3, 1000, '2014-04-17', 3),
                (4, 1000, '2014-04-17', 4),
                (5, 1000, '2014-04-17', 5),
                (6, 1000, '2014-04-17', 6),
                (7, 1000, '2014-04-17', 7),
                (8, 1000, '2014-04-17', 8),
                (9, 3962, '2014-04-17', 9),
                (10, 3962, '2014-04-17', 11),
                (11, 3962, '2014-04-17', 12),
                (12, 3962, '2014-04-17', 13),
                (13, 3962, '2014-04-17', 14),
                (14, 3962, '2014-04-17', 15),
                (15, 999, '2014-04-17', 16),
                (16, 999, '2014-04-17', 17),
                (17, 999, '2014-04-17', 18),
                (18, 999, '2014-04-17', 19),
                (19, 999, '2014-04-17', 20),
                (20, 999, '2014-04-17', 21),
                (21, 999, '2014-04-17', 22),
                (22, 999, '2014-04-17', 23),
                (23, 999, '2014-04-17', 24),
                (24, 999, '2014-04-17', 25),
                (25, 1000, '2014-04-17', 55),
                (26, 1000, '2014-04-17', 56),
                (27, 1000, '2014-04-17', 57),
                (28, 1000, '2014-04-17', 58),
                (29, 1000, '2014-04-17', 59),
                (30, 1211, '2014-04-17', 60),
                (31, 3962, '2014-04-17', 63),
                (32, 1211, '2014-04-17', 71),
                (33, 1211, '2014-04-17', 72),
                (34, 1211, '2014-04-17', 73),
                (35, 1211, '2014-04-17', 74),
                (36, 1211, '2014-04-17', 75),
                (37, 1000, '2014-04-17', 77),
                (38, 1354, '2014-04-17', 78),
                (39, 1354, '2014-04-17', 79),
                (40, 1000, '2014-04-17', 80),
                (41, 3299, '2014-04-17', 84),
                (42, 3962, '2014-04-17', 95),
                (43, 3962, '2014-04-17', 97),
                (44, 3962, '2014-04-17', 102),
                (45, 3962, '2014-04-17', 105)
        ) insert into "public"."tbl_relative_age_refs"("relative_age_ref_id", "biblio_id", "date_updated", "relative_age_id")
          select n."relative_age_ref_id", n."biblio_id", n."date_updated"::timestamp with time zone, n."relative_age_id"
          from new_relative_age_refs n
          left join tbl_relative_age_refs x
            on x.relative_age_ref_id = n.relative_age_ref_id
          where x.relative_age_ref_id is null;

        perform sead_utility.sync_sequence('public', 'tbl_relative_age_types');
        perform sead_utility.sync_sequence('public', 'tbl_relative_ages');
        perform sead_utility.sync_sequence('public', 'tbl_relative_age_refs');

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
