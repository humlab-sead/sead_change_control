-- Deploy sead_db_change_control:CSD_20180521_ADD_DENDROCHRONOLOGY_DATING_DATA to pg

BEGIN;

WITH new_locations(location_id, location_name, location_type_id) AS ( VALUES
    (3736, 'Jönköpings län', 2),
    (3737, 'Kalmar län', 2),
    (3738, 'Kronobergs län', 2),
    (3739, 'Alvesta kommun', 2),
    (3740, 'Borgholm kommun', 2),
    (3741, 'Eksjö kommun', 2),
    (3742, 'Emmaboda kommun', 2),
    (3743, 'Gislaved kommun', 2),
    (3744, 'Hultsfred kommun', 2),
    (3745, 'Hylte kommun', 2),
    (3746, 'Högsby kommun', 2),
    (3747, 'Jönköping kommun', 2),
    (3748, 'Kalmar kommun', 2),
    (3749, 'Lessebo kommun', 2),
    (3750, 'Ljungby kommun', 2),
    (3751, 'Mönsterås kommun', 2),
    (3752, 'Nybro kommun', 2),
    (3753, 'Oskarshamn kommun', 2),
    (3754, 'Tranås kommun', 2),
    (3755, 'Uppvidinge kommun', 2),
    (3756, 'Vaggeryd kommun', 2),
    (3757, 'Vetlanda kommun', 2),
    (3758, 'Vimmerby kommun', 2),
    (3759, 'Värnamo kommun', 2),
    (3760, 'Västervik kommun', 2),
    (3761, 'Växjö kommun', 2),
    (3762, 'Aneby socken', 2),
    (3763, 'Björkö socken', 2),
    (3764, 'Bottnaryd socken', 2),
    (3765, 'Burseryd socken', 2),
    (3766, 'Dädesjö socken', 2),
    (3767, 'Döderhult socken', 2),
    (3768, 'Fagerhult socken', 2),
    (3769, 'Föra socken', 2),
    (3770, 'Hagby socken', 2),
    (3771, 'Huskvarna socken', 2),
    (3772, 'Höreda socken', 2),
    (3773, 'Ingatorp socken', 2),
    (3774, 'Jät socken', 2),
    (3775, 'Kalmar stad socken', 2),
    (3776, 'Kristdala socken', 2),
    (3777, 'Kånna socken', 2),
    (3778, 'Källa socken', 2),
    (3779, 'Linderås socken', 2),
    (3780, 'Ljuder socken', 2),
    (3781, 'Madesjö socken', 2),
    (3782, 'Mortorp socken', 2),
    (3783, 'Målilla-Gårdveda socken', 2),
    (3784, 'Månsarp socken', 2),
    (3785, 'Mönsterås socken', 2),
    (3786, 'Nävelsjö socken', 2),
    (3787, 'Rumskulla  socken', 2),
    (3788, 'Skatelöv socken', 2),
    (3789, 'Svenarum socken', 2),
    (3790, 'Södra Unnaryd socken', 2),
    (3791, 'Tånnö socken', 2),
    (3792, 'Vetlanda socken', 2),
    (3793, 'Vimmerby socken', 2),
    (3794, 'Visingsö socken', 2),
    (3795, 'Vissefjärda socken', 2),
    (3796, 'Västervik socken', 2),
    (3797, 'Ålem socken', 2),
    (3798, 'Åseda socken', 2),
    (3799, 'Älghult socken', 2),
    (3800, 'Osby kommun', 2),
    (3801, 'Örkeneds socken', 2),
    (3802, 'Axebo', 2),
    (3803, 'Brunstorp', 2),
    (3804, 'Bråten', 2),
    (3805, 'Byestad', 2),
    (3806, 'Bökhult', 2),
    (3807, 'Dädesjö', 2),
    (3808, 'Edema', 2),
    (3809, 'Ejdern', 2),
    (3810, 'Fallebotorp', 2),
    (3811, 'Flöxhult', 2),
    (3812, 'Föra', 2),
    (3813, 'Göberga', 2),
    (3814, 'Hagby', 2),
    (3815, 'Hagetorp', 2),
    (3816, 'Hattmakaren', 2),
    (3817, 'Hellerö', 2),
    (3818, 'Hyltan ', 2),
    (3819, 'Hökagården', 2),
    (3820, 'Jät', 2),
    (3821, 'Klyvaren', 2),
    (3822, 'Kronobäck', 2),
    (3823, 'Källa', 2),
    (3824, 'Lilla Rätö ', 2),
    (3825, 'Mortorp', 2),
    (3826, 'Måcketorp', 2),
    (3827, 'Målajord', 2),
    (3828, 'Näktergalen', 2),
    (3829, 'Näset ', 2),
    (3830, 'Nävelsjö', 2),
    (3831, 'Oset', 2),
    (3832, 'Ripan', 2),
    (3833, 'Rådmannen', 2),
    (3834, 'Räpplinge', 2),
    (3835, 'Rödjenäs', 2),
    (3836, 'S:ta Gertruds kyrka ', 2),
    (3837, 'Skatelövs torp', 2),
    (3838, 'Skedebäckshult', 2),
    (3839, 'Skoflickaren ', 2),
    (3840, 'Skrikebo', 2),
    (3841, 'Skäveryd', 2),
    (3842, 'Slammarp', 2),
    (3843, 'Smedbyn', 2),
    (3844, 'Strömsrum ', 2),
    (3845, 'Trollestorp', 2),
    (3846, 'Uranäs', 2),
    (3847, 'Viggesbo', 2),
    (3848, 'Vinäs', 2),
    (3849, 'Yxenhaga', 2),
    (3850, 'Övrabo', 2),
    (3851, 'Vaggeryd kommun', 2),
    (3852, 'Algutsboda socken', 2),
    (3853, 'Gamleby socken', 2),
    (3854, 'Gladhammar socken', 2),
    (3855, 'Hagshult socken', 2),
    (3856, 'Målilla socken', 2),
    (3857, 'Rumskulla socken', 2),
    (3858, 'Sjösås socken', 2),
    (3859, 'Södra Vi socken', 2),
    (3860, 'Växjö socken', 2),
    (3861, 'Abborre', 2),
    (3862, 'Ansvaret', 2),
    (3863, 'Diplomaten', 2),
    (3864, 'Gladhammar', 2),
    (3865, 'Kronobäck ', 2),
    (3866, 'kv Druvan/Dovhjorten', 2),
    (3867, 'Kvarnholmen', 2),
    (3868, 'Rostock', 2),
    (3869, 'Skirsnäs', 2),
    (3870, 'Tyresbo', 2),
    (3871, 'Vi ', 2),
    (3872, 'Västra kajen', 2),
    (3873, 'Åldermannen ', 2),
                                                                     
    (3888, 'Öland', 18),
    (3889, 'Hakarp socken', 2),
    (3890, 'Jönköping', 4),
    (3891, 'Kalmar socken', 2),
    (3892, 'Lofta socken', 2),
    (3893, 'Räpplinge socken', 2),
    (3894, 'Västra Ed', 4)
                                                                     
) INSERT INTO tbl_locations (location_id, location_name, location_type_id)
  SELECT a.location_id, a.location_name, a.location_type_id
  FROM new_locations a
  LEFT JOIN tbl_locations b
    ON a.location_id = b.location_id  
  WHERE b.location_id IS NULL;

WITH new_sample_group_sampling_contexts (sampling_context_id, sampling_context, description) AS (VALUES
    (17, 'Dendrochronological building investigation', 'Investigation of wood for age determination, sampled in a historic building context'),
	(18, 'Dendrochronological archaeological sampling', 'Investigation of wood for age determination, sampled in an archaeological context')
) INSERT INTO tbl_sample_group_sampling_contexts (sampling_context_id, sampling_context, description)
  SELECT a.sampling_context_id, a.sampling_context, a.description
  FROM new_sample_group_sampling_contexts a
  LEFT JOIN tbl_sample_group_sampling_contexts b
    ON a.sampling_context_id = b.sampling_context_id  
  WHERE b.sampling_context_id IS NULL; 
    
WITH new_sample_location_types (sample_location_type_id, location_type, location_type_description) AS (VALUES 
    (71, 'Sampled section', 'A description of the sampled area. i.e. what building or what part of the building was sampled, and possibly its function. (e.g. Västtorn, östra ladan, kor, långhus).'),
    (72, 'Building level', 'On what floor was the sample/-s retrieved.'),
    (73, 'Room', 'In what room of the building was the sample/-s retrieved.'),
    (74, 'Construction part', 'What type of construction part (e.g. wall, roof beam) was sampled.'),
    (75, 'Sampled direction', 'Description of what direction the sampled area is (e.g. byggnadens östra sida, nära norra hörnet).'),
    (76, 'Sampled area', 'Description of the area in the room/building that was sampled (e.g. dörr, under trappan, takstol).'),
    (77, 'Sampled object', 'Description of the object, or part of object, was sampled (e.g. 3:e timmervarv, sparre, grov bjälke, dörrkarm). ')
) INSERT INTO tbl_sample_location_types (sample_location_type_id, location_type, location_type_description) 
  SELECT a.sample_location_type_id, a.location_type, a.location_type_description
  FROM new_sample_location_types a
  LEFT JOIN tbl_sample_location_types b
    ON a.sample_location_type_id = b.sample_location_type_id  
  WHERE b.sample_location_type_id IS NULL; 
  
WITH new_feature_types (feature_type_id, feature_type_name, feature_type_description) AS (VALUES
    (503, 'Barrier', NULL),
    (504, 'Beam', NULL);
    (505, 'Border marker'),
    (506, 'Bridge', NULL),
    (507, 'Collection pit (tar)', NULL),
    (508, 'Container', NULL),
    (509, 'Doorsill timber', NULL),
    (510, 'Dragare (translation pending)', NULL),
    (511, 'Fill layer', NULL),
    (512, 'Floor joist', NULL),
    (513, 'Gabion', 'Cage, cylinder or box filled with rocks, concrete or sometimes sand and soil for use in civil engineering, road building, military application and landscaping'),
    (514, 'Grillage ', 'A framework of timber or steel for support in marshy or treacherous soil '),
    (515, 'Horse gin', NULL),
    (516, 'Jetty/Quay', NULL),
    (517, 'Palisade(in water)', NULL),
    (518, 'Pile bridge', NULL),
    (519, 'Pile of logs', NULL),
    (520, 'Pilings', NULL),
    (521, 'Platform', NULL),
    (522, 'Pole', NULL),
    (523, 'Post', NULL),
    (524, 'Quay', NULL),
    (525, 'Revetment', NULL),
    (526, 'Road construction', NULL),
    (527, 'Roast bed', 'Deposits resulting from the roasting of ore.'),
    (528, 'Sill', NULL),
    (529, 'Sill log', NULL),
    (530, 'Sill or foundation', NULL),
    (531, 'Slag deposit', 'Deposits of slag resulting from metal production.'),
    (532, 'Stone sill', NULL),
    (533, 'Storage pit', NULL),
    (534, 'Tar funnel', NULL),
    (535, 'Timber', NULL),
    (536, 'Timber storage', NULL),
    (537, 'Top-board (Pipe organ)', NULL),
    (538, 'Water gutter', NULL),
    (539, 'Wooden feature', NULL),
    (540, 'Wooden floor', NULL),
    (541, 'Wooden house foundation', NULL),
    
    (542, 'Wooden plank', NULL),
    (543, 'Wooden sill', NULL),
    (544, 'Wooden trackway', NULL),
    (545, 'Wooden tub', NULL),
    (546, 'Wooden wall', NULL),
    (547, 'Profile ', 'A wall of a trench/test pit in an archaeological excavation, depicting the layers at the site and often sampled.'),
    (548, 'Excavation area', NULL),
    (550, 'Unknown', 'Feature type is either of a unknown character or not specified')
) INSERT INTO tbl_feature_types (feature_type_id, feature_type_name, feature_type_description)
  SELECT a.feature_type_id, a.feature_type_name, a.feature_type_description
  FROM new_feature_types a
  LEFT JOIN tbl_feature_types b
    ON a.feature_type_id = b.feature_type_id  
  WHERE b.feature_type_id IS NULL; 

WITH new_data_type_groups (data_type_group_id, data_type_group_name, description) AS (VALUES
	(19, 'Geographical','Geographical data either as a value or as a string.')
) INSERT INTO tbl_data_type_groups (data_type_group_id, data_type_group_name, description)
  SELECT a.data_type_group_id, a.data_type_group_name, a.description
  FROM new_data_type_groups a
  LEFT JOIN tbl_data_type_groups b
    ON a.data_type_group_id = b.data_type_group_id
  WHERE b.data_type_group_id IS NULL;
        
WITH new_data_types (data_type_id, data_type_group_id, data_type_name, definition) AS (VALUES
	(43, 19, 'Estimated Years', 'Dates that are an estimation'),
	(44, 19, 'Composite date', 'A date which may include other information than the age, such as season, terminus and/or error margin.'),
	(45, 19, 'Approximate location', 'Geographical location given as approximate values or text. May include multiple levels, text strings and exclusions (e.g. not Poland).')
) INSERT INTO tbl_data_types (data_type_id, data_type_group_id, data_type_name, definition)
  SELECT a.data_type_id, a.data_type_group_id, a.data_type_name, a.definition
  FROM new_data_types a
  LEFT JOIN tbl_data_types b
    ON a.data_type_id = b.data_type_id
  WHERE b.data_type_id IS NULL;
  
WITH new_dataset_masters (master_set_id, master_name, url) AS (VALUES
    (10, 'The Laboratory for Wood Anatomy and Dendrochronology (Lund)','https://www.geology.lu.se/research/laboratories-equipment/the-laboratory-for-wood-anatomy-and-dendrochronology')
) -- INSERT INTO tbl_dataset_masters (master_set_id, master_name, url)
  SELECT a.master_set_id, a.master_name, a.url
  FROM new_dataset_masters a
  LEFT JOIN tbl_dataset_masters b
    ON a.master_set_id = b.master_set_id
  WHERE b.master_set_id IS NULL;
  
INSERT INTO new_dendro_lookup (dendro_lookup_id, method_id, name, description, date_updated) (VALUES
    (121, 10, 'Tree species', 'Species name of the tree the sample came from.', '2018-05-31 16:24:11.022085+02'),
    (122, 10, 'Tree rings', 'Number of tree rings inferred as years.', '2018-05-31 16:24:11.022085+02'),
    (123, 10, 'earlywood/late wood', 'A notation on whether the outermost part of the tree grew early in the growing season or late in the growing season.', '2018-05-31 16:24:11.022085+02'),
    (124, 10, 'No. of radius ', 'Number of radius analysed.', '2018-05-31 16:24:11.022085+02'),
    (125, 10, '3 time series', 'A notation on whether 3 time series have been analysed for the sample. ', '2018-05-31 16:24:11.022085+02'),
    (126, 10, 'Sapwood (Sp)', 'The outer layers of a tree, between the pith and the cambium. ', '2018-05-31 16:24:11.022085+02'),
    (127, 10, 'Bark (B)', 'Whether bark was present in the sample. ', '2018-05-31 16:24:11.022085+02'),
    (128, 10, 'Waney edge (W)', 'The last formed tree ring before felling or sampling. Presence of this represents the last year of growth.', '2018-05-31 16:24:11.022085+02'),
    (129, 10, 'Pith (P)', 'The central core of a tree stem or twig.', '2018-05-31 16:24:11.022085+02'),
    (130, 10, 'Tree age ≥', 'The analysed age of the tree.', '2018-05-31 16:24:11.022085+02'),
    (131, 10, 'Tree age ≤', 'The analysed age of the tree.', '2018-05-31 16:24:11.022085+02'),
    (132, 10, 'Inferred growth year ≥', 'The growth year inferred from the analysed tree rings. ', '2018-05-31 16:24:11.022085+02'),
    (133, 10, 'Inferred growth year ≤', 'The growth year inferred from the analysed tree rings. ', '2018-05-31 16:24:11.022085+02'),
    (134, 10, 'Estimated felling year', ' The felling year, inferred from the  analysed outermost tree-ring date', '2018-05-31 16:24:11.022085+02'),
    (135, 10, 'Estimated felling year, lower accuracy', ' The felling year, inferred from the  analysed tree rings, with lower accuracy', '2018-05-31 16:24:11.022085+02'),
    (136, 10, 'Provenance', 'The provenance of the sampled tree, inferred by comparing the sample with others. ', '2018-05-31 16:24:11.022085+02'),
    (137, 10, 'Outermost tree-ring date', 'The date of the outermost tree-ring', '2018-05-31 16:24:11.022085+02'),
    (138, 10, 'Not dated', 'Used to mark samples as not having been succesfully dated, i. e. analysed but not dated', '2018-05-31 16:24:11.022085+02'),
    (139, 10, 'Date note', 'Notes on  a sample not dated', '2018-05-31 16:24:11.022085+02'),
    (140, 10, 'Provenance comment', 'Comments on the provenance of a sample', '2018-05-31 16:24:11.022085+02')
) INSERT INTO tbl_dendro_lookup (dendro_lookup_id, method_id, name, description, date_updated)
  SELECT a.dendro_lookup_id, a.method_id, a.name, a.description, a.date_updated
  FROM new_dendro_lookup a
  LEFT JOIN tbl_dendro_lookup b
    ON a.dendro_lookup_id = b.dendro_lookup_id  
  WHERE b.dendro_lookup_id IS NULL; 

WITH new_error_uncertainties (error_uncertainty_id, error_uncertainty_type, description) AS (VALUES
    (1, 'Ca','The error of a date is estimated as being circa (e.g. 1800 + ca 20 years)')
) INSERT INTO tbl_error_uncertainties (error_uncertainty_id, error_uncertainty_type, description)
  SELECT a.error_uncertainty_id, a.error_uncertainty_type, a.description
  FROM new_error_uncertainties a
  LEFT JOIN tbl_error_uncertainties b
    ON a.error_uncertainty_id = b.error_uncertainty_id  
  WHERE b.error_uncertainty_id IS NULL; 

WITH new_age_types (age_type_id, age_type, description) AS (VALUES
    (1, 'AD','Anno Domini, Christian era; calendar era dates according to the Gregorian calendar.')
) INSERT INTO tbl_age_types (age_type_id, age_type, description)
  SELECT a.age_type_id, a.age_type, a.description
  FROM new_age_types a
  LEFT JOIN tbl_age_types b
    ON a.age_type_id = b.age_type_id  
  WHERE b.age_type_id IS NULL; 

WITH new_season_or_qualifier (season_or_qualifier_id, season_or_qualifier_type, description) AS (VALUES
    (1, 'Winter','Felling date estimated as being during the winter, which is the resting period of the tree'),
    (2, 'Summer','Summer period (at most May to August) for the estimated felling date of a tree'),
    (3, 'After','When the waney edge is missing in dendrochronological analysis the felling date is estimated after the date of the outermost tree ring')
) INSERT INTO tbl_season_or_qualifier (season_or_qualifier_id, season_or_qualifier_type, description)
  SELECT a.season_or_qualifier_id, a.season_or_qualifier_type, a.description
  FROM new_season_or_qualifier a
  LEFT JOIN tbl_season_or_qualifier b
    ON a.season_or_qualifier_id = b.season_or_qualifier_id  
  WHERE b.season_or_qualifier_id IS NULL; 

WITH new_sample_description_types (sample_description_type_id, type_name, type_description) AS (VALUES
    (30, 'Wood function','Function or format of the wood'),
    (31, 'Wood shape','Information about how the wood has been handled (e.g. how has a log been split: full section, half section etc.)'),
    (32, 'Wood processing markings','Information about potential processing grooves (e.g. axe grooves)'),
    (33, 'Wood processing technique','Specification about the technique used to cause the wood markings'),
    (34, 'Wood general markings','Information about wood markings not related to the processing of it (e.g. traces of paint)'),
    (35, 'Wood reuse','Information about the potential reuse of the wood (e.g. house move, reused timber)')
) INSERT INTO tbl_sample_description_types (sample_description_type_id, type_name, type_description)
  SELECT a.sample_description_type_id, a.type_name, a.type_description
  FROM new_sample_description_types a
  LEFT JOIN tbl_sample_description_types b
    ON a.sample_description_type_id = b.sample_description_type_id  
  WHERE b.sample_description_type_id IS NULL; 

WITH new_biblio (biblio_id, authors, year, title, full_reference) AS (VALUES
 (6148, 'Andersson, Iwar', '1967', 'Hagby fästningskyrka. Fornvännen, vol 62, 1967, s. 22-36.', 'Andersson, Iwar (1967). Hagby fästningskyrka. Fornvännen, vol 62, 1967, s. 22-36.'),
 (6149, 'Bartholin, Thomas', '1985', 'Dendrokronologisk analyse af loftsbod, Bråtens gård, Taberg, Månsarp sn, Småland. Kvartärsgeologiska avdelningen, Lunds universitet, 1985-04-12.', 'Bartholin, Thomas (1985). Dendrokronologisk analyse af loftsbod, Bråtens gård, Taberg, Månsarp sn, Småland. Kvartärsgeologiska avdelningen, Lunds universitet, 1985-04-12.'),
 (6150, 'Bartholin, Thomas', '1986', 'Dendrokronologisk datering af loft fra Vissingsö. Kvartärsgeologiska avdelningen, Lunds universitet, 1986-07-28.', 'Bartholin, Thomas (1986). Dendrokronologisk datering af loft fra Vissingsö. Kvartärsgeologiska avdelningen, Lunds universitet, 1986-07-28.'),
 (6151, 'Bartholin, Thomas', '1987', 'Dendrokronologisk undersögelse af Appelbladska Smedjan, Huskvarna. Kvartärsgeologiska avdelningen, Lunds universitet, 1987-08-06.', 'Bartholin, Thomas (1987). Dendrokronologisk undersögelse af Appelbladska Smedjan, Huskvarna. Kvartärsgeologiska avdelningen, Lunds universitet, 1987-08-06.'),
 (6152, 'Bartholin, Thomas', '1987', 'Dendrokronologisk undersögelse af loft vägplank fra Yxenhaga Gammelstuga med formodet oprindelse fra "Sanda k:a", nu magasinet på Brunstorp, Huskvarna. Kvartärsgeologiska avdelningen, Lunds universitet, 1987-08-10.', 'Bartholin, Thomas (1987). Dendrokronologisk undersögelse af loft vägplank fra Yxenhaga Gammelstuga med formodet oprindelse fra "Sanda k:a", nu magasinet på Brunstorp, Huskvarna. Kvartärsgeologiska avdelningen, Lunds universitet, 1987-08-10.'),
 (6153, 'Bartholin, Thomas', '1987', 'Dendrokronologisk undersögelse af loft, Brunstorp, Huskvarna. Kvartärsgeologiska avdelningen, Lunds universitet, 1987-08-05.', 'Bartholin, Thomas (1987). Dendrokronologisk undersögelse af loft, Brunstorp, Huskvarna. Kvartärsgeologiska avdelningen, Lunds universitet, 1987-08-05.'),
 (6154, 'Bartholin, Thomas', '1989', 'Dendrokronologisk datering af loft på Dädesjö hembygdsgård, Småland. Kvartärsgeologiska avdelningen, Lunds universitet, 1989-11-30.', 'Bartholin, Thomas (1989). Dendrokronologisk datering af loft på Dädesjö hembygdsgård, Småland. Kvartärsgeologiska avdelningen, Lunds universitet, 1989-11-30.'),
 (6155, 'Bartholin, Thomas', '1992', 'Dendrokronologisk analyse af tagstolene over långhuset, Jät ka, Småland. Dendroprov nr. 75109-127. Kvartärsgeologiska avdelningen, Lunds universitet, 1992-11-05.', 'Bartholin, Thomas (1992). Dendrokronologisk analyse af tagstolene over långhuset, Jät ka, Småland. Dendroprov nr. 75109-127. Kvartärsgeologiska avdelningen, Lunds universitet, 1992-11-05.'),
 (6156, 'Bartholin, Thomas', '1993', 'Dendrokronologisk analyse af  f d bostadshus på gården Högetorp, Döderhults sn, Småland. Kvartärsgeologiska avdelningen, Lunds universitet, 1993-01-16.', 'Bartholin, Thomas (1993). Dendrokronologisk analyse af  f d bostadshus på gården Högetorp, Döderhults sn, Småland. Kvartärsgeologiska avdelningen, Lunds universitet, 1993-01-16.'),
 (6157, 'Bartholin, Thomas', '1993', 'Dendrokronologisk analyse af tagstolen i Nävelsjö kyrka. Kvartärsgeologiska avdelningen, Lunds universitet, 1993-02-04.', 'Bartholin, Thomas (1993). Dendrokronologisk analyse af tagstolen i Nävelsjö kyrka. Kvartärsgeologiska avdelningen, Lunds universitet, 1993-02-04.'),
 (6158, 'Bartholin, Thomas', '1994', 'Dendrokronologisk analyse af fähus på "Sjöhorven", Målajord 1:7, Dädesjö sn. Kvartärsgeologiska avdelningen, Lunds universitet, 1994-08-30.', 'Bartholin, Thomas (1994). Dendrokronologisk analyse af fähus på "Sjöhorven", Målajord 1:7, Dädesjö sn. Kvartärsgeologiska avdelningen, Lunds universitet, 1994-08-30.'),
 (6159, 'Bartholin, Thomas', '1994', 'Dendrokronologisk analyse af pröver fra bostadshus, "Pärlhuset", Bystad 1:2, Vetlanda sn. Kvartärsgeologiska avdelningen, Lunds universitet, 1994-11-03.', 'Bartholin, Thomas (1994). Dendrokronologisk analyse af pröver fra bostadshus, "Pärlhuset", Bystad 1:2, Vetlanda sn. Kvartärsgeologiska avdelningen, Lunds universitet, 1994-11-03.'),
 (6160, 'Bartholin, Thomas', '1995', 'Dendrokronologisk analyse af gästgivaregården, Trollestorp 1:8, Annerstad. Kvartärsgeologiska avdelningen, Lunds universitet, 1995-05-10.', 'Bartholin, Thomas (1995). Dendrokronologisk analyse af gästgivaregården, Trollestorp 1:8, Annerstad. Kvartärsgeologiska avdelningen, Lunds universitet, 1995-05-10.'),
 (6161, 'Bartholin, Thomas', '1995', 'Dendrokronologisk analyse af kv Näktergalen 3, Vimmerby sn, Småland. Kvartärsgeologiska avdelningen, Lunds universitet, 1995-02-15.', 'Bartholin, Thomas (1995). Dendrokronologisk analyse af kv Näktergalen 3, Vimmerby sn, Småland. Kvartärsgeologiska avdelningen, Lunds universitet, 1995-02-15.'),
 (6162, 'Bartholin, Thomas', '1995', 'Dendrokronologisk analyse af soldattorpet  "Sjöhorven", Målajord 1:7, Dädesjö sn. Kvartärsgeologiska avdelningen, Lunds universitet, 1995-05-10.', 'Bartholin, Thomas (1995). Dendrokronologisk analyse af soldattorpet  "Sjöhorven", Målajord 1:7, Dädesjö sn. Kvartärsgeologiska avdelningen, Lunds universitet, 1995-05-10.'),
 (6163, 'Bartholin, Thomas', '1996', 'Dendrokronologisk analys av Vinäs slott, Västra Eds sn, Småland. Nationalmuseet/NNU Köpenhamn, rapport 12 mars 1996.', 'Bartholin, Thomas (1996). Dendrokronologisk analys av Vinäs slott, Västra Eds sn, Småland. Nationalmuseet/NNU Köpenhamn, rapport 12 mars 1996.'),
 (6164, 'Barup, Kerstin & Iakobi, Johan', '1995', 'Dackestugan på Kulturen i Lund. Byggnadsundersökning av Dacke stugan 1995. LTH-Arkitektur II, Bebyggelsevård.', 'Barup, Kerstin & Iakobi, Johan (1995). Dackestugan på Kulturen i Lund. Byggnadsundersökning av Dacke stugan 1995. LTH-Arkitektur II, Bebyggelsevård.'),
 (6165, 'Barup, Kerstin & Iakobi, Johan', '1995', 'Dackestugan på Kulturen i Lund. Byggnadsundersökning av Dackestugan 1995. LTH-Arkitektur II, Bebyggelsevård.', 'Barup, Kerstin & Iakobi, Johan (1995). Dackestugan på Kulturen i Lund. Byggnadsundersökning av Dackestugan 1995. LTH-Arkitektur II, Bebyggelsevård.'),
 (6166, 'Boström, Ragnhild', '1969', 'Källa kyrkor. Sveriges kyrkor, vol. 128. Öland 1:4.', 'Boström, Ragnhild (1969). Källa kyrkor. Sveriges kyrkor, vol. 128. Öland 1:4.'),
 (6167, 'Boström, Ragnhild', '1972', 'Föra kyrkor. Sveriges kyrkor, vol. 142. Öland 1:6.', 'Boström, Ragnhild (1972). Föra kyrkor. Sveriges kyrkor, vol. 142. Öland 1:6.'),
 (6168, 'Boström, Ragnhild', '1990', '"Räpplinge kyrka" ur: En bok om Räpplinge. Utgiven av Räpplinge Hembygdsförening 1990.', 'Boström, Ragnhild (1990). "Räpplinge kyrka" ur: En bok om Räpplinge. Utgiven av Räpplinge Hembygdsförening 1990.'),
 (6169, 'Eggertsson, Ólafur', '1995', 'Dendrokronologisk analys. Kv Näktergalen 3, Vimmerby. Laboratoriet för Vedanatomi och Dendrokronologi, 1995-12-07.', 'Eggertsson, Ólafur (1995). Dendrokronologisk analys. Kv Näktergalen 3, Vimmerby. Laboratoriet för Vedanatomi och Dendrokronologi, 1995-12-07.'),
 (6170, 'Eggertsson, Ólafur', '1998', 'Dendrokronologisk analys. Kristdala och norra Skåne. Laboratoriet för Vedanatomi och Dendrokronologi, 1998-11-20.', 'Eggertsson, Ólafur (1998). Dendrokronologisk analys. Kristdala och norra Skåne. Laboratoriet för Vedanatomi och Dendrokronologi, 1998-11-20.'),
 (6171, 'Eggertsson, Ólafur', '1998', 'Dendrokronologisk analys. Norregård, Aneby, Vetlanda kommun. Laboratoriet för Vedanatomi och Dendrokronologi, 1998-08-24.', 'Eggertsson, Ólafur (1998). Dendrokronologisk analys. Norregård, Aneby, Vetlanda kommun. Laboratoriet för Vedanatomi och Dendrokronologi, 1998-08-24.'),
 (6172, 'Eggertsson, Ólafur', '1998', 'Dendrokronologisk analys. Prover från fastigheten Rådmannen 2 i Kalmar. Laboratoriet för Vedanatomi och Dendrokronologi, 1998-04-08.', 'Eggertsson, Ólafur (1998). Dendrokronologisk analys. Prover från fastigheten Rådmannen 2 i Kalmar. Laboratoriet för Vedanatomi och Dendrokronologi, 1998-04-08.'),
 (6173, 'Eggertsson, Ólafur', '1998', 'Dendrokronologisk analys. Skrikebo 1:29, Baggestorpskvarn. Laboratoriet för Vedanatomi och Dendrokronologi, 1998-10-20.', 'Eggertsson, Ólafur (1998). Dendrokronologisk analys. Skrikebo 1:29, Baggestorpskvarn. Laboratoriet för Vedanatomi och Dendrokronologi, 1998-10-20.'),
 (6174, 'Eggertsson, Ólafur', '1998', 'Dendrokronologisk analys.Rödjenäs gård och torpstuga från Rödjenäs, Björkö sn. Laboratoriet för Vedanatomi och Dendrokronologi, 1998-08-24.', 'Eggertsson, Ólafur (1998). Dendrokronologisk analys.Rödjenäs gård och torpstuga från Rödjenäs, Björkö sn. Laboratoriet för Vedanatomi och Dendrokronologi, 1998-08-24.'),
 (6175, 'Eggertsson, Ólafur', '1999', 'Dendrokronologisk analys. Aspagården, Västervik. Laboratoriet för Vedanatomi och Dendrokronologi, 1999-06-04.', 'Eggertsson, Ólafur (1999). Dendrokronologisk analys. Aspagården, Västervik. Laboratoriet för Vedanatomi och Dendrokronologi, 1999-06-04.'),
 (6176, 'Eggertsson, Ólafur', '1999', 'Dendrokronologisk analys. Två prover från en stuga, Burseryd. Laboratoriet för Vedanatomi och Dendrokronologi, 1999-03-02.', 'Eggertsson, Ólafur (1999). Dendrokronologisk analys. Två prover från en stuga, Burseryd. Laboratoriet för Vedanatomi och Dendrokronologi, 1999-03-02.'),
 (6177, 'Eggertsson, Ólafur', '2000', 'Dendrokronologisk analys. Klockstapel i Ljuder sn. Laboratoriet för Vedanatomi och Dendrokronologi, 2000-06-26.', 'Eggertsson, Ólafur (2000). Dendrokronologisk analys. Klockstapel i Ljuder sn. Laboratoriet för Vedanatomi och Dendrokronologi, 2000-06-26.'),
 (6178, 'Jonsson, Magdalena', '2010', '”Gröna stugan”, kulturhistorisk utredning, kv Klyvaren 6, Ängö, Kalmar kn, Kalmar län, Småland. Kalmar läns museum, byggnadsantikvarisk rapport 2010.', 'Jonsson, Magdalena (2010). ”Gröna stugan”, kulturhistorisk utredning, kv Klyvaren 6, Ängö, Kalmar kn, Kalmar län, Småland. Kalmar läns museum, byggnadsantikvarisk rapport 2010.'),
 (6179, 'Lamke, Lotta', '2010', 'Röda huset i Hyltan. Hyltan 1.3, Målilla sn, Kalmar län, Småland. Antikvarisk medverkan vid renovering av yttertak och skorsten. Kalmar läns museum, byggnadsantikvarisk rapport 2010.', 'Lamke, Lotta (2010). Röda huset i Hyltan. Hyltan 1.3, Målilla sn, Kalmar län, Småland. Antikvarisk medverkan vid renovering av yttertak och skorsten. Kalmar läns museum, byggnadsantikvarisk rapport 2010.'),
 (6180, 'Linderson, Hans & Eggertsson, Ólafur', '1997', 'Dendrokronologisk analys. Datering av Grankvistgården i Vimmerby. Laboratoriet för Vedanatomi och Dendrokronologi, 1997-06-04.', 'Linderson, Hans & Eggertsson, Ólafur (1997). Dendrokronologisk analys. Datering av Grankvistgården i Vimmerby. Laboratoriet för Vedanatomi och Dendrokronologi, 1997-06-04.'),
 (6181, 'Linderson, Hans & Eggertsson, Ólafur', '1997', 'Dendrokronologisk analys. Skedebäckshult, Smedjevik, Nybro. Laboratoriet för Vedanatomi och Dendrokronologi, 1997.', 'Linderson, Hans & Eggertsson, Ólafur (1997). Dendrokronologisk analys. Skedebäckshult, Smedjevik, Nybro. Laboratoriet för Vedanatomi och Dendrokronologi, 1997.'),
 (6182, 'Linderson, Hans & Eggertsson, Ólafur', '1999', 'Dendrokronologisk analys. Göberga gård, Tranås kommun, huvudbyggnad och flygel. Laboratoriet för Vedanatomi och Dendrokronologi, 1999-10-27.', 'Linderson, Hans & Eggertsson, Ólafur (1999). Dendrokronologisk analys. Göberga gård, Tranås kommun, huvudbyggnad och flygel. Laboratoriet för Vedanatomi och Dendrokronologi, 1999-10-27.'),
 (6183, 'Linderson, Hans', '2000', 'Dendrokronologisk analys. Timmerhus på Skrikebo 1:29 (övre våning tidigare daterad), Oskarshamn kn. Laboratoriet för Vedanatomi och Dendrokronologi, 2000-11-15.', 'Linderson, Hans (2000). Dendrokronologisk analys. Timmerhus på Skrikebo 1:29 (övre våning tidigare daterad), Oskarshamn kn. Laboratoriet för Vedanatomi och Dendrokronologi, 2000-11-15.'),
 (6184, 'Linderson, Hans', '2001', 'Dendrokronologisk analys av ett hus i Bökhult, 15 km öster om Hyltebruk. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2001:49.', 'Linderson, Hans (2001). Dendrokronologisk analys av ett hus i Bökhult, 15 km öster om Hyltebruk. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2001:49.'),
 (6185, 'Linderson, Hans', '2002', 'Dendrokronologisk analys av fastigheten Målajord 1:7, Dädesjö. Småland. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2002:51.', 'Linderson, Hans (2002). Dendrokronologisk analys av fastigheten Målajord 1:7, Dädesjö. Småland. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2002:51.'),
 (6186, 'Linderson, Hans', '2002', 'Dendrokronologisk analys av Lilla Rätö gårds huvudbyggnad i Västervik. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2002:15.', 'Linderson, Hans (2002). Dendrokronologisk analys av Lilla Rätö gårds huvudbyggnad i Västervik. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2002:15.'),
 (6187, 'Linderson, Hans', '2003', 'Dendrokronologisk analys av den ursprungliga huvudbyggnaden på Hellerö egendom, N Västervik. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2003:13.', 'Linderson, Hans (2003). Dendrokronologisk analys av den ursprungliga huvudbyggnaden på Hellerö egendom, N Västervik. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2003:13.'),
 (6188, 'Linderson, Hans', '2003', 'Dendrokronologisk analys av huvudbyggnad, rättarbostad och bränneri i Viggesbo, Vimmerby. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2003:20.', 'Linderson, Hans (2003). Dendrokronologisk analys av huvudbyggnad, rättarbostad och bränneri i Viggesbo, Vimmerby. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2003:20.'),
 (6189, 'Linderson, Hans', '2004', 'Dendrokronologisk analys av brandskadade fastigheten Ripan 10 i Vimmerby. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2004:24.', 'Linderson, Hans (2004). Dendrokronologisk analys av brandskadade fastigheten Ripan 10 i Vimmerby. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2004:24.'),
 (6190, 'Linderson, Hans', '2004', 'Dendrokronologisk analys av Grankvistgården i Vimmerby. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2004:25.', 'Linderson, Hans (2004). Dendrokronologisk analys av Grankvistgården i Vimmerby. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2004:25.'),
 (6191, 'Linderson, Hans', '2004', 'Dendrokronologisk analys av huvudbyggnad, rättarbostad, bränneri, mejeri samt västra och östra ladugårdslängorna i Viggesbo , Vimmerby. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2004:32.', 'Linderson, Hans (2004). Dendrokronologisk analys av huvudbyggnad, rättarbostad, bränneri, mejeri samt västra och östra ladugårdslängorna i Viggesbo , Vimmerby. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2004:32.'),
 (6192, 'Linderson, Hans', '2007', 'Dendrokronologisk analys  av fastigheten Rådmannen 6, Kalmar. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2007:54.', 'Linderson, Hans (2007). Dendrokronologisk analys  av fastigheten Rådmannen 6, Kalmar. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2007:54.'),
 (6193, 'Linderson, Hans', '2007', 'Dendrokronologisk analys av gamla arrendatorbostaden på Flöxhults säteri i Älghult. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2007:30.', 'Linderson, Hans (2007). Dendrokronologisk analys av gamla arrendatorbostaden på Flöxhults säteri i Älghult. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2007:30.'),
 (6194, 'Linderson, Hans', '2008', 'Dendrokronologisk analys av ett gårdshus på Hattmakaren 6, Kvarnholmen, Kalmar. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2008:3.', 'Linderson, Hans (2008). Dendrokronologisk analys av ett gårdshus på Hattmakaren 6, Kvarnholmen, Kalmar. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2008:3.'),
 (6195, 'Linderson, Hans', '2008', 'Dendrokronologisk analys av golvbjälklaget i mangårdsbyggnaden, Övrabo, Höreda socken, Eksjö. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2008:54.', 'Linderson, Hans (2008). Dendrokronologisk analys av golvbjälklaget i mangårdsbyggnaden, Övrabo, Höreda socken, Eksjö. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2008:54.'),
 (6196, 'Linderson, Hans', '2008', 'Dendrokronologisk analys av stenkällaren på Kronobäcks klosterruin, Mönsterås. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2008:05.', 'Linderson, Hans (2008). Dendrokronologisk analys av stenkällaren på Kronobäcks klosterruin, Mönsterås. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2008:05.'),
 (6197, 'Linderson, Hans', '2008', 'Dendrokronologisk analys av Vinäs "slott", Kalmar län. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2008:27.', 'Linderson, Hans (2008). Dendrokronologisk analys av Vinäs "slott", Kalmar län. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2008:27.'),
 (6198, 'Linderson, Hans', '2008', 'Dendrokronologisk analys samt dito komplettering av fastigheten Rådmannen 6, Kalmar. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2008:8.', 'Linderson, Hans (2008). Dendrokronologisk analys samt dito komplettering av fastigheten Rådmannen 6, Kalmar. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2008:8.'),
 (6199, 'Linderson, Hans', '2009', 'Dendrokronologisk analys av Dackestugan på Kulturen i Lund. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2009:62.', 'Linderson, Hans (2009). Dendrokronologisk analys av Dackestugan på Kulturen i Lund. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2009:62.'),
 (6200, 'Linderson, Hans', '2009', 'Dendrokronologisk analys av huvudbyggnaden i Slammarp 1:14, Ingatorp, Eksjö kommun. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2009:13.', 'Linderson, Hans (2009). Dendrokronologisk analys av huvudbyggnaden i Slammarp 1:14, Ingatorp, Eksjö kommun. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2009:13.'),
 (6201, 'Linderson, Hans', '2009', 'Dendrokronologisk analys av mangårdsbyggnaden på Skatelövs torp 5:9 i Alvesta kommun. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2009:70.', 'Linderson, Hans (2009). Dendrokronologisk analys av mangårdsbyggnaden på Skatelövs torp 5:9 i Alvesta kommun. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2009:70.'),
 (6202, 'Linderson, Hans', '2009', 'Dendrokronologisk analys av västra ladan och "svinhuset" på Viggesbo, Vimmerby. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2009:23.', 'Linderson, Hans (2009). Dendrokronologisk analys av västra ladan och "svinhuset" på Viggesbo, Vimmerby. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2009:23.'),
 (6203, 'Linderson, Hans', '2010', 'Dendrokronologisk analys av bårhuset, sannolikt en före detta tiondebod, vid Mortorp kyrka.. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:13.', 'Linderson, Hans (2010). Dendrokronologisk analys av bårhuset, sannolikt en före detta tiondebod, vid Mortorp kyrka.. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:13.'),
 (6204, 'Linderson, Hans', '2010', 'Dendrokronologisk analys av ett hanband i gamla Källa kyrkas vapenhus, Öland. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:45.', 'Linderson, Hans (2010). Dendrokronologisk analys av ett hanband i gamla Källa kyrkas vapenhus, Öland. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:45.'),
 (6205, 'Linderson, Hans', '2010', 'Dendrokronologisk analys av fastigheten Klyvaren 6 i Kalmar. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:24.', 'Linderson, Hans (2010). Dendrokronologisk analys av fastigheten Klyvaren 6 i Kalmar. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:24.'),
 (6206, 'Linderson, Hans', '2010', 'Dendrokronologisk analys av fiskarstugan Näset 1 på Stensö, Kalmar. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:38.', 'Linderson, Hans (2010). Dendrokronologisk analys av fiskarstugan Näset 1 på Stensö, Kalmar. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:38.'),
 (6207, 'Linderson, Hans', '2010', 'Dendrokronologisk analys av Föra kyrkas västtorn, Öland. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:44.', 'Linderson, Hans (2010). Dendrokronologisk analys av Föra kyrkas västtorn, Öland. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:44.'),
 (6208, 'Linderson, Hans', '2010', 'Dendrokronologisk analys av Hagby kyrka, Kalmar. Nationella laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2001:35.', 'Linderson, Hans (2010). Dendrokronologisk analys av Hagby kyrka, Kalmar. Nationella laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2001:35.'),
 (6209, 'Linderson, Hans', '2010', 'Dendrokronologisk analys av Mangårdsbyggnaden på Lagerhamnska gården, Ålem, Mönsterås. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:59.', 'Linderson, Hans (2010). Dendrokronologisk analys av Mangårdsbyggnaden på Lagerhamnska gården, Ålem, Mönsterås. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:59.'),
 (6210, 'Linderson, Hans', '2010', 'Dendrokronologisk analys av mangårdsbyggnaden på Skatelövs torp 5:9 i Alvesta kommun - komplettering. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:26.', 'Linderson, Hans (2010). Dendrokronologisk analys av mangårdsbyggnaden på Skatelövs torp 5:9 i Alvesta kommun - komplettering. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:26.'),
 (6211, 'Linderson, Hans', '2010', 'Dendrokronologisk analys av mangårdsbyggnaden på Skäveryd 1:1, Vissefjärda, Småland. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:23.', 'Linderson, Hans (2010). Dendrokronologisk analys av mangårdsbyggnaden på Skäveryd 1:1, Vissefjärda, Småland. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:23.'),
 (6212, 'Linderson, Hans', '2010', 'Dendrokronologisk analys av porten mellan långhuset och vapenhuset i Källa gamla kyrka på Öland. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:69.', 'Linderson, Hans (2010). Dendrokronologisk analys av porten mellan långhuset och vapenhuset i Källa gamla kyrka på Öland. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:69.'),
 (6213, 'Linderson, Hans', '2011', 'Dendrokronologisk analys av Dackestugan på Kulturen i Lund - komplettering av golvplank. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2011:70.', 'Linderson, Hans (2011). Dendrokronologisk analys av Dackestugan på Kulturen i Lund - komplettering av golvplank. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2011:70.'),
 (6214, 'Linderson, Hans', '2011', 'Dendrokronologisk analys av Mangårdsbyggnaden på fastigheten Hyltan 1:3 i Målilla, Kalmar län. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2011:62.', 'Linderson, Hans (2011). Dendrokronologisk analys av Mangårdsbyggnaden på fastigheten Hyltan 1:3 i Målilla, Kalmar län. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2011:62.'),
 (6215, 'Linderson, Hans', '2011', 'Dendrokronologisk analys av prover från Rackargården, Kalmar. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2011:45.', 'Linderson, Hans (2011). Dendrokronologisk analys av prover från Rackargården, Kalmar. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2011:45.'),
 (6216, 'Linderson, Hans', '2011', 'Dendrokronologisk analys av Räpplinge kyrkas västtorn, Öland. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:46.', 'Linderson, Hans (2011). Dendrokronologisk analys av Räpplinge kyrkas västtorn, Öland. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:46.'),
 (6217, 'Linderson, Hans', '2012', 'Dendrokronologisk analys av Mocketorpsgården, Kulturen i Lund. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2012:13.', 'Linderson, Hans (2012). Dendrokronologisk analys av Mocketorpsgården, Kulturen i Lund. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2012:13.'),
 (6218, 'Linderson, Hans', '2012', 'Dendrokronologisk analys av målat virke i magasinet på Brunstorp, Huskvarna. Är Öxnahaga (Yxenhagas) gammelstuga byggt av virke från den försvunna Sanda kyrka? Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2012:27.', 'Linderson, Hans (2012). Dendrokronologisk analys av målat virke i magasinet på Brunstorp, Huskvarna. Är Öxnahaga (Yxenhagas) gammelstuga byggt av virke från den försvunna Sanda kyrka? Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2012:27.'),
 (6219, 'Linderson, Hans', '2012', 'Dendrokronologisk analys av torpet Försjö, Oset 1:2, Ryforsbruk, Bottnaryd. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2012:3.', 'Linderson, Hans (2012). Dendrokronologisk analys av torpet Försjö, Oset 1:2, Ryforsbruk, Bottnaryd. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2012:3.'),
 (6220, 'Magnusson, Gösta', '2004', 'Sjöhorven : kulturhistoriska studier kring Målajords soldattorp i Dädesjö socken', 'Magnusson, Gösta (2004). Sjöhorven : kulturhistoriska studier kring Målajords soldattorp i Dädesjö socken'),
 (6221, 'Meissner, Katja ', '2010', 'Dendrokronologisk datering av fiskestugan på fastigheten Näset 1, Stensö, Kalmar. Kalmar läns museum, rapport 2010.', 'Meissner, Katja  (2010). Dendrokronologisk datering av fiskestugan på fastigheten Näset 1, Stensö, Kalmar. Kalmar läns museum, rapport 2010.'),
 (6222, 'Meissner, Katja ', '2010', 'Dendrokronologisk datering av Räpplinge kyrka, Räpplinge socken, Borgholm kommun, Öland. Kalmar läns museum, rapport 2010.', 'Meissner, Katja  (2010). Dendrokronologisk datering av Räpplinge kyrka, Räpplinge socken, Borgholm kommun, Öland. Kalmar läns museum, rapport 2010.'),
 (6223, 'Meissner, Katja & Jonsson, Magdalena', '2011', 'Dendrokronologisk datering Skoflickaren 5, ”Rackargården”, Kvarnholmen, Kalmar kommun, Småland. Kalmar läns museum, rapport 2011.', 'Meissner, Katja & Jonsson, Magdalena (2011). Dendrokronologisk datering Skoflickaren 5, ”Rackargården”, Kvarnholmen, Kalmar kommun, Småland. Kalmar läns museum, rapport 2011.'),
 (6224, 'Meissner, Katja', '2010', 'Dendrokronologisk datering av Föra kyrka, Föra socken, Borgholm kommun, Öland. Kalmar läns museum, rapport 2010.', 'Meissner, Katja (2010). Dendrokronologisk datering av Föra kyrka, Föra socken, Borgholm kommun, Öland. Kalmar läns museum, rapport 2010.'),
 (6225, 'Meissner, Katja', '2010', 'Dendrokronologisk datering av Källa gamla kyrka, Källa socken, Borgholm kommun, Öland. Kalmar läns museum, rapport 2010.', 'Meissner, Katja (2010). Dendrokronologisk datering av Källa gamla kyrka, Källa socken, Borgholm kommun, Öland. Kalmar läns museum, rapport 2010.'),
 (6226, 'Meissner, Katja', '2010', 'Dendrokronologisk datering av Lagerhamnska gården, Strömsrum 2:3, Ålem socken, Mönsterås kommun, Småland. Kalmar läns museum, rapport 2010.', 'Meissner, Katja (2010). Dendrokronologisk datering av Lagerhamnska gården, Strömsrum 2:3, Ålem socken, Mönsterås kommun, Småland. Kalmar läns museum, rapport 2010.'),
 (6227, 'Meissner, Katja', '2010', 'Dendrokronologisk datering av långhusportalen i Källa gamla kyrka, Källa socken, Borgholm kommun, Öland. Kalmar läns museum, rapport 2010.', 'Meissner, Katja (2010). Dendrokronologisk datering av långhusportalen i Källa gamla kyrka, Källa socken, Borgholm kommun, Öland. Kalmar läns museum, rapport 2010.'),
 (6228, 'Molander, Örjan', '2008', 'Arkiater Wahlboms hus, Kvarteret Rådmannen 6, Kvarnholmen, Kalmar kommun, Småland. Kalmar läns museum, byggnadsantikvarisk rapport 2008.', 'Molander, Örjan (2008). Arkiater Wahlboms hus, Kvarteret Rådmannen 6, Kvarnholmen, Kalmar kommun, Småland. Kalmar läns museum, byggnadsantikvarisk rapport 2008.'),
 (6229, 'Molander, Örjan', '2008', 'Dendrokronologisk datering av gårdshus på fastigheten Hattmakaren 6, Kvarnholmen, Kalmar. Rapport 2008-02-28.', 'Molander, Örjan (2008). Dendrokronologisk datering av gårdshus på fastigheten Hattmakaren 6, Kvarnholmen, Kalmar. Rapport 2008-02-28.'),
 (6230, 'Molander, Örjan', '2009', 'Dendrokronologisk datering av Vinäs, ”Slottet”, Västra Ed socken, Västerviks kommun, Kalmar län, Småland. Kalmar läns museum, rapport 2009.', 'Molander, Örjan (2009). Dendrokronologisk datering av Vinäs, ”Slottet”, Västra Ed socken, Västerviks kommun, Kalmar län, Småland. Kalmar läns museum, rapport 2009.'),
 (6231, 'Molander, Örjan', '2010', 'F.d. Tiondebod vid Mortorp kyrka, Mortorp socken, Kalmar län, Växjö stift, Småland. Resultat från dendrokronologisk undersökning. Kalmar läns museum, kyrkoantikvarisk rapport 2010.', 'Molander, Örjan (2010). F.d. Tiondebod vid Mortorp kyrka, Mortorp socken, Kalmar län, Växjö stift, Småland. Resultat från dendrokronologisk undersökning. Kalmar läns museum, kyrkoantikvarisk rapport 2010.'),
 (6232, 'Palm, Veronika', '2008', 'Silverskatten vid Hellerö. Rapport från arkeologisk undersökning. Hellerö 1:21, Västra Ed socken, Småland. Kalmar läns museum, Arkeologisk rapport 2008.', 'Palm, Veronika (2008). Silverskatten vid Hellerö. Rapport från arkeologisk undersökning. Hellerö 1:21, Västra Ed socken, Småland. Kalmar läns museum, Arkeologisk rapport 2008.'),
 (6233, 'Riksantikvarieämbetet', '1981', 'Byggnadsminnen 1961-1978 - Förteckning över byggnadsminnen enligt lagen den 9 december 1960 (nr 690).  ', 'Riksantikvarieämbetet (1981). Byggnadsminnen 1961-1978 - Förteckning över byggnadsminnen enligt lagen den 9 december 1960 (nr 690).  '),
 (6234, 'Serlander, Daniel & Grimhammar, Daniel &  Nilsson, Nicholas', '2011', 'Kronobäcks klosterkyrkoruin. Förundersökning inför byggandet av ny informationsbyggnad 2009-2010. Kronobäck 1:7, Mönsterås socken och kommun, Kalmar län. Kalmar läns museum, Arkeologisk rapport 2011:17.', 'Serlander, Daniel & Grimhammar, Daniel &  Nilsson, Nicholas (2011). Kronobäcks klosterkyrkoruin. Förundersökning inför byggandet av ny informationsbyggnad 2009-2010. Kronobäck 1:7, Mönsterås socken och kommun, Kalmar län. Kalmar läns museum, Arkeologisk rapport 2011:17.'),
 (6235, 'Tengö, Pär', '2006', 'Gårdshus, Hattmakaren 6, Kalmar.', 'Tengö, Pär (2006). Gårdshus, Hattmakaren 6, Kalmar.'),
 (6236, 'Bartholin, Thomas', '1991', 'Dendrokronologisk analyse af pröver fra Gammleby og Kalmar. Kvartärsgeologiska avdelningen, Lunds universitet, 1991-11-08.', 'Bartholin, Thomas. 1991. Dendrokronologisk analyse af pröver fra Gammleby og Kalmar. Kvartärsgeologiska avdelningen, Lunds universitet, 1991-11-08.'),
 (6237, 'Bartholin, Thomas', '1991', 'Dendrokronologisk undersögelse af pålbron i Södra Vi sn, Vi 15:1, Småland. Kvartärsgeologiska avdelningen, Lunds universitet, 1991-09-25.', 'Bartholin, Thomas. 1991. Dendrokronologisk undersögelse af pålbron i Södra Vi sn, Vi 15:1, Småland. Kvartärsgeologiska avdelningen, Lunds universitet, 1991-09-25.'),
 (6238, 'Bartholin, Thomas', '1991', 'Dendrokronologisk undersögelse av påle fra pålbro i Södra Vi sn. Kvartärsgeologiska avdelningen, Lunds universitet, 1991-04-23.', 'Bartholin, Thomas. 1991. Dendrokronologisk undersögelse av påle fra pålbro i Södra Vi sn. Kvartärsgeologiska avdelningen, Lunds universitet, 1991-04-23.'),
 (6239, 'Bartholin, Thomas', '1992', 'Dendrokronologisk analyse af 2 päle fra Garpön, Rumskulla sn, Fl. nr 234. Kvartärsgeologiska avdelningen, Lunds universitet, 1992-10-26.', 'Bartholin, Thomas. 1992. Dendrokronologisk analyse af 2 päle fra Garpön, Rumskulla sn, Fl. nr 234. Kvartärsgeologiska avdelningen, Lunds universitet, 1992-10-26.'),
 (6240, 'Bartholin, Thomas', '1994', 'Dendrokronologisk og vedanatomisk analyse af  pröver fra VA-schakt, Hamngatan, Gamleby, mars-april 1994. Kvartärsgeologiska avdelningen, Lunds universitet, 1994-06-24.', 'Bartholin, Thomas. 1994. Dendrokronologisk og vedanatomisk analyse af  pröver fra VA-schakt, Hamngatan, Gamleby, mars-april 1994. Kvartärsgeologiska avdelningen, Lunds universitet, 1994-06-24.'),
 (6241, 'Bartholin, Thomas', '1995', 'Dendrokronologisk undersögelse af 2 päle fra bro ved Krönsberg Vi 15:1, Södra Vi sn, Småland. Kvartärsgeologiska avdelningen, Lunds universitet, 1995-01-17.', 'Bartholin, Thomas. 1995. Dendrokronologisk undersögelse af 2 päle fra bro ved Krönsberg Vi 15:1, Södra Vi sn, Småland. Kvartärsgeologiska avdelningen, Lunds universitet, 1995-01-17.'),
 (6242, 'Eggertsson, Ólafur & Linderson, Hans', '1998', 'Dendrokronologisk analys. Träanläggning, troligen kavelbro, Gamleby, Kalmar län. Laboratoriet för Vedanatomi och Dendrokronologi, 1998-02-16.', 'Eggertsson, Ólafur & Linderson, Hans. 1998. Dendrokronologisk analys. Träanläggning, troligen kavelbro, Gamleby, Kalmar län. Laboratoriet för Vedanatomi och Dendrokronologi, 1998-02-16.'),
 (6243, 'Eggertsson, Ólafur', '1996', 'Dendrokronologisk analys. Dendroprov från arkeologisk undersökning vid järnvägsstationen, Kalmar. Laboratoriet för Vedanatomi och Dendrokronologi, 1996-09-06.', 'Eggertsson, Ólafur. 1996. Dendrokronologisk analys. Dendroprov från arkeologisk undersökning vid järnvägsstationen, Kalmar. Laboratoriet för Vedanatomi och Dendrokronologi, 1996-09-06.'),
 (6244, 'Eggertsson, Ólafur', '1996', 'Dendrokronologisk analys. Källarholmen, Mönsterås sn, Småland, Fornl.nr 82: prov nr 1-6. Kalmar, centralstation, Pålverk vid bastionen Christina Regina: påle 2 och 3. Laboratoriet för Vedanatomi och Dendrokronologi, 1996-01-11.', 'Eggertsson, Ólafur. 1996. Dendrokronologisk analys. Källarholmen, Mönsterås sn, Småland, Fornl.nr 82: prov nr 1-6. Kalmar, centralstation, Pålverk vid bastionen Christina Regina: påle 2 och 3. Laboratoriet för Vedanatomi och Dendrokronologi, 1996-01-11.'),
 (6245, 'Eggertsson, Ólafur', '1997', 'Dendrokronologisk analys. Dendroprov från kv Åldermannen 19, Kalmar. Laboratoriet för Vedanatomi och Dendrokronologi, 1997-01-27.', 'Eggertsson, Ólafur. 1997. Dendrokronologisk analys. Dendroprov från kv Åldermannen 19, Kalmar. Laboratoriet för Vedanatomi och Dendrokronologi, 1997-01-27.'),
 (6246, 'Eggertsson, Ólafur', '1997', 'Dendrokronologisk analys. Prov från bropåle, Kalmar. Laboratoriet för Vedanatomi och Dendrokronologi, 1997-01-10.', 'Eggertsson, Ólafur. 1997. Dendrokronologisk analys. Prov från bropåle, Kalmar. Laboratoriet för Vedanatomi och Dendrokronologi, 1997-01-10.'),
 (6247, 'Eggertsson, Ólafur', '1998', 'Dendrokronologisk analys. Bryggkonstruktion, Kalmar län. Laboratoriet för Vedanatomi och Dendrokronologi, 1998-01-21.', 'Eggertsson, Ólafur. 1998. Dendrokronologisk analys. Bryggkonstruktion, Kalmar län. Laboratoriet för Vedanatomi och Dendrokronologi, 1998-01-21.'),
 (6248, 'Eggertsson, Ólafur', '1998', 'Dendrokronologisk analys. Prover från Kvarnholmen 2:6, fästningsverk. Laboratoriet för Vedanatomi och Dendrokronologi, 1998-12-16.', 'Eggertsson, Ólafur. 1998. Dendrokronologisk analys. Prover från Kvarnholmen 2:6, fästningsverk. Laboratoriet för Vedanatomi och Dendrokronologi, 1998-12-16.'),
 (6249, 'Eggertsson, Ólafur', '1998', 'Dendrokronologisk analys. Två prover från Rostockaholme, Kalmar län. Laboratoriet för Vedanatomi och Dendrokronologi, 1998-04-08.', 'Eggertsson, Ólafur. 1998. Dendrokronologisk analys. Två prover från Rostockaholme, Kalmar län. Laboratoriet för Vedanatomi och Dendrokronologi, 1998-04-08.'),
 (6250, 'Eggertsson, Ólafur', '1999', 'Dendrokronologisk analys. Förhistorisk väganläggning, ev. vagndelar, Växjö sn. Laboratoriet för Vedanatomi och Dendrokronologi, 1999-05-25.', 'Eggertsson, Ólafur. 1999. Dendrokronologisk analys. Förhistorisk väganläggning, ev. vagndelar, Växjö sn. Laboratoriet för Vedanatomi och Dendrokronologi, 1999-05-25.'),
 (6251, 'Linderson, Hans', '2002', 'Dendrokronologisk analys av bropålar i sjön Örken, centrala Småland. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2002:38', 'Linderson, Hans. 2002. Dendrokronologisk analys av bropålar i sjön Örken, centrala Småland. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2002:38'),
 (6252, 'Linderson, Hans', '2004', 'Dendrokronologisk analys av Munkbron mot Nydalakloster,  Jönköping länd. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2004:03', 'Linderson, Hans. 2004. Dendrokronologisk analys av Munkbron mot Nydalakloster,  Jönköping länd. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2004:03'),
 (6253, 'Linderson, Hans', '2007', 'Dendrokronologisk analys av byggrester från kvarteret Diplomaten, Jönköping. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2007:33.', 'Linderson, Hans. 2007. Dendrokronologisk analys av byggrester från kvarteret Diplomaten, Jönköping. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2007:33.'),
 (6254, 'Linderson, Hans', '2008', 'Dendrokronologisk analys av byggrester från kvarteret Diplomaten, Jönköping. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2008:12.', 'Linderson, Hans. 2008. Dendrokronologisk analys av byggrester från kvarteret Diplomaten, Jönköping. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2008:12.'),
 (6255, 'Linderson, Hans', '2008', 'Dendrokronologisk analys av en pålspärr vid Kronobäck, Mönsterås. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2008:10.', 'Linderson, Hans. 2008. Dendrokronologisk analys av en pålspärr vid Kronobäck, Mönsterås. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2008:10.'),
 (6256, 'Linderson, Hans', '2008', 'Dendrokronologisk analys av stenkista från kvarteret Dovhjorten, Jönköping. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2008:59.', 'Linderson, Hans. 2008. Dendrokronologisk analys av stenkista från kvarteret Dovhjorten, Jönköping. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2008:59.'),
 (6257, 'Linderson, Hans', '2009', 'Dendrokronologisk analys av en större slaggdeponi från Gladhammars gruvor. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2009:53.', 'Linderson, Hans. 2009. Dendrokronologisk analys av en större slaggdeponi från Gladhammars gruvor. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2009:53.'),
 (6258, 'Linderson, Hans', '2009', 'Dendrokronologisk analys av rundtimmer från kvarteret Mästaren i Kalmar. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2009:71.', 'Linderson, Hans. 2009. Dendrokronologisk analys av rundtimmer från kvarteret Mästaren i Kalmar. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2009:71.'),
 (6259, 'Linderson, Hans', '2009', 'Dendrokronologisk analys av virkesfynd från en arkeologisk utgrävning av kvarteret Ansvaret i Jönköping. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2009:32.', 'Linderson, Hans. 2009. Dendrokronologisk analys av virkesfynd från en arkeologisk utgrävning av kvarteret Ansvaret i Jönköping. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2009:32.'),
 (6260, 'Linderson, Hans', '2010', 'Dendrokronologisk analys av en spontanläggning utanför befästningen i Kalmar, Kvarnholmen 2:2. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:71.', 'Linderson, Hans. 2010. Dendrokronologisk analys av en spontanläggning utanför befästningen i Kalmar, Kvarnholmen 2:2. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:71.'),
 (6261, 'Linderson, Hans', '2010', 'Dendrokronologisk analys av en stabiliserande påle till stadsmuren från kvarteret Gesällen i Kalmar. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:42.', 'Linderson, Hans. 2010. Dendrokronologisk analys av en stabiliserande påle till stadsmuren från kvarteret Gesällen i Kalmar. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:42.'),
 (6262, 'Linderson, Hans', '2010', 'Dendrokronologisk analys av träkistor mot vättern på kvarteret Abborren, Jönköping. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:6.', 'Linderson, Hans. 2010. Dendrokronologisk analys av träkistor mot vättern på kvarteret Abborren, Jönköping. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:6.'),
 (6263, 'Linderson, Hans', '2010', 'Dendrokronologisk analys av virke från ett område (K) med tjärrframställningsanläggningar vid Målilla, väg 23. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapportnr. 2010:67.', 'Linderson, Hans. 2010. Dendrokronologisk analys av virke från ett område (K) med tjärrframställningsanläggningar vid Målilla, väg 23. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapportnr. 2010:67.'),
 (6264, 'Linderson, Hans', '2010', 'Dendrokronologisk analys från en arkeologisk undersökning, Gota Media, Kalmar. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:62.', 'Linderson, Hans. 2010. Dendrokronologisk analys från en arkeologisk undersökning, Gota Media, Kalmar. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2010:62.'),
 (6265, 'Linderson, Hans', '2011', 'Dendrokronologisk analys av byggrester från kvarteret Druvan/Dovhjorten, Jönköping. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr  2011:44.', 'Linderson, Hans. 2011. Dendrokronologisk analys av byggrester från kvarteret Druvan/Dovhjorten, Jönköping. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr  2011:44.'),
 (6266, 'Linderson, Hans', '2011', 'Dendrokronologisk analys av en arkeologisk förundersökning vid västra kajen i Jönköping. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2011:49', 'Linderson, Hans. 2011. Dendrokronologisk analys av en arkeologisk förundersökning vid västra kajen i Jönköping. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2011:49'),
 (6267, 'Linderson, Hans', '2011', 'Dendrokronologisk analys av virke från markanläggningar vid Gladhammars gruvor, Kalmar län. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2011:19.', 'Linderson, Hans. 2011. Dendrokronologisk analys av virke från markanläggningar vid Gladhammars gruvor, Kalmar län. Nationella Laboratoriet för Vedanatomi och Dendrokronologi, rapport nr 2011:19.'),
 (6268, ' Sandberg, Fredrik & Palm, Veronica & Nilsson, Nicholas med bidrag från GAL och SLU', '2011', 'Gladhammars gruvor - Särskild arkeologisk undersökning 2010. Kalmar läns museum, Arkeologisk rapport 2011:19.', ' Sandberg, Fredrik & Palm, Veronica & Nilsson, Nicholas med bidrag från GAL och SLU. 2011. Gladhammars gruvor - Särskild arkeologisk undersökning 2010. Kalmar läns museum, Arkeologisk rapport 2011:19.'),
 (6269, ' Skoglund, Peter &  Lagerås, Per', '2002', 'En vendeltida vagn från södra Småland - fyndet från Skirsnäs mosse i ny belysningning. Fornvännen, vol 97, 2002, s. 73-86.', ' Skoglund, Peter &  Lagerås, Per. 2002. En vendeltida vagn från södra Småland - fyndet från Skirsnäs mosse i ny belysningning. Fornvännen, vol 97, 2002, s. 73-86.'),
 (6270, 'Blohmé, Mats', '2006', 'Christina Regina. Ölandskajen, Kvarnholmen, Fornl.nr 93, Småland. Arkeologisk förundersökning, 2001. Kalmar läns museum. Nationella rapportprojektet 2006. ', 'Blohmé, Mats. 2006. Christina Regina. Ölandskajen, Kvarnholmen, Fornl.nr 93, Småland. Arkeologisk förundersökning, 2001. Kalmar läns museum. Nationella rapportprojektet 2006. '),
 (6271, 'Bramstång, Carina & Tagesson, Göran', '2011', 'Bastionen Gustavus Primus. Bevarade bastionsmurar inom fastigheten Kvarnholmen 2:5, RAÄ 93, Kalmar stad och kommun, Kalmar län. Arkeologisk förundersökning, UV öst rapport 2011:11.', 'Bramstång, Carina & Tagesson, Göran. 2011. Bastionen Gustavus Primus. Bevarade bastionsmurar inom fastigheten Kvarnholmen 2:5, RAÄ 93, Kalmar stad och kommun, Kalmar län. Arkeologisk förundersökning, UV öst rapport 2011:11.'),
 (6272, 'Gustafsson, Pierre &  Schütz, Berit', '1998', ' Kulbackensmuseum, B. Schutz/P. Gustafsson. Arkeologisk undersökning på Storgatan NV om tingshuset. 98.08.26/MBL.', 'Gustafsson, Pierre &  Schütz, Berit. 1998.  Kulbackensmuseum, B. Schutz/P. Gustafsson. Arkeologisk undersökning på Storgatan NV om tingshuset. 98.08.26/MBL.'),
 (6273, 'Haltiner Nordström, Susanne', '2009', 'Arkeologisk förundersökning. Kvarteret Dovhjorten. Inför nybyggnation inom RAÄ 50, stadsdelen Öster, Jönköpings stad. Jönköpings läns museum, rapport 2009:20. ', 'Haltiner Nordström, Susanne. 2009. Arkeologisk förundersökning. Kvarteret Dovhjorten. Inför nybyggnation inom RAÄ 50, stadsdelen Öster, Jönköpings stad. Jönköpings läns museum, rapport 2009:20. '),
 (6274, 'Heimdahl, Jens & Vestbö Franzén, Å. ', '2009', 'Tyska madens gröna rum. Specialstudier till den arkeologiska undersökningen i kvarteret Diplomaten, RAÄ 50, Jönköpings stad. Jönköpings läns museum. Arkeologisk rapport 2009:41. ', 'Heimdahl, Jens & Vestbö Franzén, Å. . 2009. Tyska madens gröna rum. Specialstudier till den arkeologiska undersökningen i kvarteret Diplomaten, RAÄ 50, Jönköpings stad. Jönköpings läns museum. Arkeologisk rapport 2009:41. '),
 (6275, 'Hällström, Agneta ', '2007', 'Rostockaholme. Rostock 1:4, Algutsboda socken, Emmaboda kommun, Småland. Fornl nr 79. Arkeologisk undersökning 1991 - 2001. Nationella rapportprojektet 2007,Kalmar läns museum, Rapport juni 2007.', 'Hällström, Agneta . 2007. Rostockaholme. Rostock 1:4, Algutsboda socken, Emmaboda kommun, Småland. Fornl nr 79. Arkeologisk undersökning 1991 - 2001. Nationella rapportprojektet 2007,Kalmar läns museum, Rapport juni 2007.'),
 (6276, 'Konsmar, Angelika', '2011', 'Befästningskonstruktioner norr om kv Muren, Kvarnholmen 2:2 och del av 2:1, Kvarnholmen Kalmar, RAÄ 93, Kalmar domkyrkoförsamling, Kalmar stad och kommun, Kalmar län, Småland.  Arkeologisk förundersökning, UV öst rapport 2011:3.', 'Konsmar, Angelika. 2011. Befästningskonstruktioner norr om kv Muren, Kvarnholmen 2:2 och del av 2:1, Kvarnholmen Kalmar, RAÄ 93, Kalmar domkyrkoförsamling, Kalmar stad och kommun, Kalmar län, Småland.  Arkeologisk förundersökning, UV öst rapport 2011:3.'),
 (6277, 'Lamke, Lotta & Nilsson, Håkan', '2004', 'Lamke , L. & Nilsson, H. 2004. Kulturhistorisk utredning av Gladhammarsgruvområde . Kalmar läns museum , Projekt Gladhammar, Rapport 2004:09. ', 'Lamke, Lotta & Nilsson, Håkan. 2004. Lamke , L. & Nilsson, H. 2004. Kulturhistorisk utredning av Gladhammarsgruvområde . Kalmar läns museum , Projekt Gladhammar, Rapport 2004:09. '),
 (6278, 'Lamke, Lotta', '2005', 'Kv Magistern, Kvarnholmen. Kulturhistorisk utredning, Kalmar läns museum, Kalmar.', 'Lamke, Lotta. 2005. Kv Magistern, Kvarnholmen. Kulturhistorisk utredning, Kalmar läns museum, Kalmar.'),
 (6279, 'Lamke, Lotta', '2010', 'Gesällen 25, Kvarnholmen 2:2 och del av Kvarnholmen 2:1 – Bebyggelsehistorisk översikt. Kalmar läns museum, Byggnadsantikvarisk rapport 2010.', 'Lamke, Lotta. 2010. Gesällen 25, Kvarnholmen 2:2 och del av Kvarnholmen 2:1 – Bebyggelsehistorisk översikt. Kalmar läns museum, Byggnadsantikvarisk rapport 2010.'),
 (6280, 'Nilsson, Nicholas & Källström, Michael', '2009', 'Kv Åldermannen. Arkeologisk förundersökning 1996. Kv Åldermannen, Norra Långgatan, Kvarnholmen, Kalmar. Kalmar läns museum, Arkeologisk rapport 2009:22.', 'Nilsson, Nicholas & Källström, Michael. 2009. Kv Åldermannen. Arkeologisk förundersökning 1996. Kv Åldermannen, Norra Långgatan, Kvarnholmen, Kalmar. Kalmar läns museum, Arkeologisk rapport 2009:22.'),
 (6281, 'Nordman, Ann-Marie & Pettersson, Claes', '2009', 'Arkeologisk förundersökning. Att öppna arkivet, inför planerad byggnation av ABM-hus inom del av kvarteret Diplomaten, Jönköpings stad, fornlämning RAÄ 50. Kristine församling i Jönköpings stad, Jönköpings län. Jönköpings läns museum. Arkeologisk rapport 2009:39. ', 'Nordman, Ann-Marie & Pettersson, Claes. 2009. Arkeologisk förundersökning. Att öppna arkivet, inför planerad byggnation av ABM-hus inom del av kvarteret Diplomaten, Jönköpings stad, fornlämning RAÄ 50. Kristine församling i Jönköpings stad, Jönköpings län. Jönköpings läns museum. Arkeologisk rapport 2009:39. '),
 (6282, 'Nordman, Ann-Marie & Pettersson, Claes  ', '2009', 'Den centrala periferin. Arkeologisk undersökning i kvarteret Diplomaten, faktori- och hantverksgårdar i Jönköping 1620-1790, RAÄ 50, Jönköpings stad. Jönköpings läns museum. Arkeologisk rapport 2009:40. ', 'Nordman, Ann-Marie & Pettersson, Claes  . 2009. Den centrala periferin. Arkeologisk undersökning i kvarteret Diplomaten, faktori- och hantverksgårdar i Jönköping 1620-1790, RAÄ 50, Jönköpings stad. Jönköpings läns museum. Arkeologisk rapport 2009:40. '),
 (6283, 'Nordman, Ann-Marie & Pettersson, Claes & Heimdahl, Jens', '2010', 'På denna blöta grund – 2,5 meter stadsarkeologi i ett kärr. SKAS, vol 2/2010', 'Nordman, Ann-Marie & Pettersson, Claes & Heimdahl, Jens. 2010. På denna blöta grund – 2,5 meter stadsarkeologi i ett kärr. SKAS, vol 2/2010'),
 (6284, 'Nordman, Ann-Marie', '2010', 'Kv Abborren 2. Rapport över arkeologisk förundersökning inom fornlämning 50, Jönköpings stad, Jönköpings län. Jönköpings läns museum. Arkeologisk rapport 2010:61.', 'Nordman, Ann-Marie. 2010. Kv Abborren 2. Rapport över arkeologisk förundersökning inom fornlämning 50, Jönköpings stad, Jönköpings län. Jönköpings läns museum. Arkeologisk rapport 2010:61.'),
 (6285, 'Nordström, Annika  &  Tagesson, Göran', '2009', 'Stadslager inom kv Mästaren på Kvarnholmen. Kv Mästaren 5-8, 21-22, RAÄ 93,Kalmar stad och kommun, Kalmar län. Arkeologisk förundersökning, UV öst rapport 2009:31.', 'Nordström, Annika  &  Tagesson, Göran. 2009. Stadslager inom kv Mästaren på Kvarnholmen. Kv Mästaren 5-8, 21-22, RAÄ 93,Kalmar stad och kommun, Kalmar län. Arkeologisk förundersökning, UV öst rapport 2009:31.'),
 (6286, 'Palm, Veronika & Åstrand, Johan & Danielsson, Peter', '2011', 'Boplatslämningar, kolningsgropar och tjärdalar. Arkeologisk förundersökning och särskild undersökning 2010. Förbifart Målilla - omläggning av väg 23/47, Målilla socken, Hultsfreds kommun. Kalmar läns museum, Arkeologisk rapport 2011:05.', 'Palm, Veronika & Åstrand, Johan & Danielsson, Peter. 2011. Boplatslämningar, kolningsgropar och tjärdalar. Arkeologisk förundersökning och särskild undersökning 2010. Förbifart Målilla - omläggning av väg 23/47, Målilla socken, Hultsfreds kommun. Kalmar läns museum, Arkeologisk rapport 2011:05.'),
 (6287, 'Rajala, Eeva', '2006', 'Källarholmen. Källarholmen, Mönsterås socken, Mönsterås kommun, Småland. Fornl nr 82, Arkeologisk undersökning, 1994, Dendroprovtagning, 1995. Rapport december 2006, Kalmar läns museum. Nationella rapportprojektet 2006.', 'Rajala, Eeva. 2006. Källarholmen. Källarholmen, Mönsterås socken, Mönsterås kommun, Småland. Fornl nr 82, Arkeologisk undersökning, 1994, Dendroprovtagning, 1995. Rapport december 2006, Kalmar läns museum. Nationella rapportprojektet 2006.'),
 (6288, 'Rubensson, Leif & Åstrand, Johan', '2007', 'Gamleby. Fornlämning 450, Gamleby sn, Västerviks kommun, Småland. Arkeologiska förundersökningar 1991 och 1994. Kalmar läns museum. Nationella rapportprojektet 2007. ', 'Rubensson, Leif & Åstrand, Johan. 2007. Gamleby. Fornlämning 450, Gamleby sn, Västerviks kommun, Småland. Arkeologiska förundersökningar 1991 och 1994. Kalmar läns museum. Nationella rapportprojektet 2007. '),
 (6289, 'Sandberg, Fredrik & Palm, Veronika & Carlsson, Eva & Nilsson, Nicholas', '2009', 'Gladhammars gruvor. Arkeologisk förundersökning 2009. Gladhammars gruvområde, RAÄ 155 och 229, samt hyttområde, RAÄ 277. Gladhammars socken, Västerviks kommun, Kalmar län. Kalmar läns museum, rapport 2009:52. ', 'Sandberg, Fredrik & Palm, Veronika & Carlsson, Eva & Nilsson, Nicholas. 2009. Gladhammars gruvor. Arkeologisk förundersökning 2009. Gladhammars gruvområde, RAÄ 155 och 229, samt hyttområde, RAÄ 277. Gladhammars socken, Västerviks kommun, Kalmar län. Kalmar läns museum, rapport 2009:52. '),
 (6290, 'Stibéus, Magnus & Tagesson, Göran', '2008', 'Bebyggelse och kulturlager från 1600-tal fram till idag vid Norra Munksjöstranden. RAÄ 50, kv Ansvaret 5 och 6, Jönköpings stad och kommun, Jönköpings län. Arkeologisk förundersökning, UV öst rapport 2008:4.', 'Stibéus, Magnus & Tagesson, Göran. 2008. Bebyggelse och kulturlager från 1600-tal fram till idag vid Norra Munksjöstranden. RAÄ 50, kv Ansvaret 5 och 6, Jönköpings stad och kommun, Jönköpings län. Arkeologisk förundersökning, UV öst rapport 2008:4.')

) INSERT INTO tbl_biblio (biblio_id, authors, year, title, full_reference)
  SELECT a.biblio_id, a.authors, a.year, a.title, a.full_reference
  FROM new_biblio a
  LEFT JOIN tbl_biblio b
    ON a.biblio_id = b.biblio_id
  WHERE b.biblio_id IS NULL;

WITH new_contacts AS (VALUES
    (1, 'Environmental Archaeology Lab
 Dept. of Philosophical, Historical & Religious Studes', 'Umeå University
SE-90187  Umeå', 'Philip', 'Buckland', 'phil.buckland@arke.umu.se', 'http://www.idesam.umu.se/om/personal/visa-person/?uid=phbu0001&guise=anst1', 205),
    (34, 'Knadriks Kulturbygg', 'Blekinge, Skåne', 'Karl-Magnus', 'Melin', NULL, 'http://www.knadrikskulturbygg.se/', 1004),
    (35, 'The Laboratory for Wood Anatomy and Dendrochronology', 'Lund University', 'Hans', 'Linderson', 'hans.linderson@geol.lu.se', 'https://www.geology.lu.se/hans-linderson', NULL),
    (36, 'Byggkult: Byggnadsvård och kulturmiljö', 'Kalmar', 'Katja', 'Meissner', 'katja@byggkult.se', 'http://www.byggkult.se/kontakt/', NULL),
    (37, 'Kalmar läns museum', 'Kalmar stad', 'Nicholas', 'Nilsson', NULL, 'http://www.kalmarlansmuseum.se/museet/personal/nicholas-nilsson/', NULL),
    (38, 'Kalmar läns museum', 'Kalmar', 'Lotta', 'Lamke', NULL, 'http://www.kalmarlansmuseum.se/', NULL),
    (39, 'Kalmar läns museum', 'Kalmar', 'Magdalena', 'Jonsson', NULL, 'http://www.kalmarlansmuseum.se/', NULL),
    (40, 'Kalmar läns museum', 'Kalmar', 'Max', 'Jahrehorn', NULL, 'http://www.kalmarlansmuseum.se/', NULL),
    (41, 'Kalmar läns museum', 'Kalmar', 'Richard', 'Edlund', NULL, 'http://www.kalmarlansmuseum.se/', NULL),
    (42, 'Kulturen', 'Lund', 'Örjan', 'Hörlin', NULL, 'https://www.kulturen.com/', NULL),
    (43, 'Kalmar läns museum', 'Kalmar', 'Örjan', 'Molander', NULL, 'http://www.kalmarlansmuseum.se/', NULL),
    (44, 'Länstyrelsen Jönköping län', 'Jönköping', 'Anders', 'Wallander', NULL, NULL, NULL),
    (45, 'CMB Uppdragsarkeologi AB ', 'Löddeköpinge', 'Bondesson Hvid', 'Bo', NULL, 'https://se.linkedin.com/in/bo-bondesson-hvid-8866a4aa', NULL),
    (46, 'Hembygdsförening Oskarshamn-Döderhult', 'Kalmar', 'Torsten', 'Karlsson', NULL, NULL, NULL),
    (47, 'Kalmar läns museum', 'Kalmar stad', 'Eeva', 'Rajala', NULL, NULL, NULL),
    (48, 'Kalmar läns museum', 'Kalmar stad', 'Lars', 'Einarsson', NULL, NULL, NULL),
    (49, 'Kalmar läns museum', 'Kalmar stad', 'Mats', 'Pettersson', NULL, NULL, NULL),
    (50, 'Kalmar läns museum', 'Kalmar stad', 'Michael', 'Källström', NULL, NULL, NULL),
    (51, 'Smålands museum', 'Växjö', 'Peter', 'Skoglund', NULL, NULL, NULL),
    (52, 'Kalmar läns museum', 'Kalmar stad', 'Torbjörn', 'Sjögren', NULL, NULL, NULL),
    (53, 'Västerviks museum', 'Kulbacken', 'Pierre', 'Gustafsson', NULL, NULL, NULL),
    (54, 'Kalmar läns museum', 'Kalmar stad', 'Per', 'Olin', NULL, NULL, NULL),
    (55, 'Byggnadsvård Qvarnarp', NULL, 'Sten', 'Janér', NULL, 'http://www.byggnadsvardqvarnarp.se/', NULL),
    (56, 'The Laboratory for Wood Anatomy and Dendrochronology', 'Lund University', 'VDL', NULL, NULL, 'https://www.geology.lu.se/research/laboratories-equipment/the-laboratory-for-wood-anatomy-and-dendrochronology', NULL),
    (57, 'Riksantikvarieämbetet', NULL, 'Peter', 'Sjömar', NULL, NULL, NULL),
    (58, NULL, NULL, 'Harry', 'Bergensblad', NULL, NULL, NULL),
    (59, NULL, NULL, 'Jarl', 'Karlsson', NULL, NULL, NULL),
    (60, NULL, NULL, 'Lennart', 'Grandelius', NULL, NULL, NULL),
    (61, NULL, NULL, 'Magnus', 'Samuelsson', NULL, NULL, NULL),
    (62, NULL, NULL, 'Ólafur', 'Eggertsson', NULL, NULL, NULL),
    (63, NULL, NULL, 'Thomas', 'Bartholin', NULL, NULL, NULL),
    (64, NULL, NULL, 'Unspecified', NULL, NULL, NULL, NULL),
    (65, NULL, NULL, 'Private', NULL, NULL, NULL, NULL),
    (67, 'Environmental Archaeology Lab Dept. of Philosophical, Historical & Religious Studies', 'Umeå University', 'Mattias', 'Sjölander', 'mattias.sjolander@umu.se', 'http://www.idesam.umu.se/om/personal/?uid=masj0062&guiseId=360086&orgId=4864cb4234d0bf7c77c65d7f78ffca7ecaf285c7&name=Mattias%20Sj%c3%b6lander', 205)
) INSERT INTO tbl_contacts (contact_id, address_1, address_2, first_name, last_name, email, url, location_id) 
  SELECT a.contact_id, a.address_1, a.address_2, a.first_name, a.last_name, a.email, a.url, a.location_id
  FROM new_biblio a
  LEFT JOIN tbl_contacts b
    ON a.contact_id = b.contact_id
  WHERE b.contact_id IS NULL;

WITH tbl_project_types (project_type_id, project_type_name, description) AS (VALUES
    (8, 'Unclassified', 'A project of unknown character.')
) INSERT INTO tbl_project_types (project_type_id, project_type_name, description)
  SELECT a.project_type_id, a.project_type_name, a.description
  FROM tbl_project_types a
  LEFT JOIN tbl_project_types b
    ON a.project_type_id = b.project_type_id  
  WHERE b.project_type_id IS NULL; 

WITH new_project_stages (project_stage_id, stage_name, description) AS (VALUES
    (6, 'Dendrochronological study', 'An investigation using tree rings to determine the age of wood. Sampling in historic building investigation and archaeological contexts.')
) INSERT INTO tbl_project_stages (project_stage_id, stage_name, description)
  SELECT a.project_stage_id, a.stage_name, a.description
  FROM new_project_stages a
  LEFT JOIN tbl_project_stages b
    ON a.project_stage_id = b.project_stage_id  
  WHERE b.project_stage_id IS NULL; 

COMMIT;
