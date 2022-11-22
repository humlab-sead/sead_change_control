-- Deploy sead_change_control:CS_ECOCODE_20180222_ADD_SYSTEM_ID to pg

/****************************************************************************************************************
  Author
  Date          2018-02-22
  Description   This script adds the 'Dutch ecological classification for plants' ecocode system to SEAD
                This version of the script has no hard-coded identities.
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes         The data used in the CTEs has been generated usin the following SQL expressions on
                ecocode tables loaded by previous version of this script in a temp DB with ONLY
                this ecocode system loaded data.

                1) Create a new temp DB with `copy-database`
                2) Delete existing ecocodes.

                    delete from tbl_ecocodes;
                    delete from tbl_ecocode_definitions;
                    delete from tbl_ecocode_groups;
                    delete from tbl_ecocode_systems;

                3) Run prior version of this script with fixed, hard-coded identeties.
                4) Create data that can be inserted in CTEs below.

                    select format('(%s, %L, %L, %L),', ecocode_group_id, definition, name, abbreviation)
                    from tbl_ecocode_groups

                    select format(
                    	'(%s, %s, %L, %L, %L, %L, %s, %L::int[]),',
                    	d.ecocode_definition_id, d.ecocode_group_id, d.abbreviation, definition, d.name, d.notes, d.sort_order, array_agg(e.taxon_id)
                    )
                    from tbl_ecocodes e
                    join tbl_ecocode_definitions d using (ecocode_definition_id)
                    group by d.ecocode_definition_id, d.ecocode_group_id, d.abbreviation, definition, d.name, d.notes, d.sort_order

*****************************************************************************************************************/

do $$
declare
	v_group record;
	v_definition record;
	v_date  date = '2020-03-14';
	v_ecocode_system_id integer = 4;
	v_ecocode_group_id integer;
	v_ecocode_definition_id integer;
begin
    begin

		perform sead_utility.sync_sequence('public', 'tbl_ecocodes', 'ecocode_id');
		perform sead_utility.sync_sequence('public', 'tbl_ecocode_groups', 'ecocode_group_id');
		perform sead_utility.sync_sequence('public', 'tbl_ecocode_definitions', 'ecocode_definition_id');

		if (select count(*) from tbl_ecocode_systems where ecocode_system_id = v_ecocode_system_id) = 1 then
			raise exception SQLSTATE 'GUARD';
		end if;

		set client_encoding = 'UTF8';
		set client_min_messages = warning;

		create temp table temp_ecocode_groups AS
			with ecocode_groups(local_ecocode_group_id, global_ecocode_group_id, definition, name, abbreviation) as (values
				( 4, 0, '1 Plants on arable fields and dry brushwoods', 'Arable fields and dry brushwoods', NULL),
				( 5, 0, '2 Plants on disturbed sites or open, moist to wet, humus-poor soil', 'Disturbed sites or open, moist to wet, humus-poor soil', NULL),
				( 6, 0, '3 Plants from sea dunes, salt waters and salt marshes', 'Sea dunes, salt waters and salt marshes', NULL),
				( 7, 0, '4 Plants from fresh waters and freshwater shores', 'Fresh waters and freshwater shores', NULL),
				( 8, 0, '5 Plants from fertilized grasslands on moderately nutrient rich to nutrient rich, moist to wet soil', 'Fertilized grasslands on moderately nutrient rich to nutrient rich, moist to wet soil', NULL),
				( 9, 0, '6 Plants on dry grasslands and walls', 'Dry grasslands and walls', NULL),
				(10, 0, '7 Plants on heathlands, fens, rough pastures and calcareous bogs', 'Heathlands, fens, rough pastures and calcareous bogs', NULL),
				(11, 0, '8 Plants on clearcuttings, borders between grasslands and forests, and shrubland', 'Clearcuttings, borders between grasslands and forests, and shrubland', NULL),
				(12, 0, '9 Plants from forests', 'Forests', NULL)
			) select *
			  from ecocode_groups;

		create temp table temp_ecocode_definitions AS
			with ecocode_definitions(local_ecocode_definition_id, local_ecocode_group_id, abbreviation, definition, name, notes, sort_order, taxon_ids) as (values
				(184, 9, '6a', 'Walls', 'Walls', '', 26, '{1225,1333,2652,2653,286,291,293,297,4321,5263,5535,5646}'::int[]),
				(189, 10, '7a', 'Moderately nutrient-rich, non-calcareous, acidic low moor bogs and wet, humic dune valleys', 'Moderately nutrient-rich, non-calcareous, acidic low moor bogs and wet, humic dune valleys', '', 31, '{1612,18108,1953,1983,2008,2026,2055,2102,2215,226,2272,2871,2881,3183,3199,3297,3342,3417,3506,3670,3789,3797,4502,5014,5196,5389,5487,5609}'::int[]),
				(179, 7, '4d', 'Wash-up belts, wet brushwoods and willow thickets accompanying river courses', 'Wash-up belts, wet brushwoods and willow thickets accompanying river courses', '', 21, '{1065,1097,1100,1113,1251,1253,144,147,174,1790,1807,1811,2309,2463,2986,3045,3136,3143,3268,412,4258,4541,5046,5068,5132,5136,5193,5207,5208,5454,604,730,784,808,834,851,950}'::int[]),
				(161, 4, '1b', 'Arable fields on calcareous soil', 'Arable fields on calcareous soil', '', 3, '{1022,1332,1375,1377,1419,1563,2301,2311,2380,239,2915,2934,2937,3474,4417,4450,4490,4607,5011,5021,5273,5276,5557,5561}'::int[]),
				(181, 8, '5a', 'Fertilized grasslands on moderately moist soil', 'Fertilized grasslands on moderately moist soil', '', 23, '{1096,1155,1362,1600,168,17999,18122,18138,18164,18222,185,219,2200,223,228,2403,2410,2432,2439,249,2518,252,2538,256,2569,2704,2870,3012,314,3496,3627,3712,3729,3735,3754,3769,3815,3818,3911,3914,3950,3968,4070,4137,420,4245,4323,4480,4582,475,4992,506,5239,524,5370,5372,547,5569,685,706,797,918}'::int[]),
				(190, 10, '7b', 'Moderately nutrient-poor, calcareous, alkaline marshes', 'Moderately nutrient-poor, calcareous, alkaline marshes', '', 32, '{1963,1969,1993,1994,2032,2148,2159,2160,2177,2245,2665,2839,3355,3403,3419,3573}'::int[]),
				(201, 12, '9b', 'Forests on mature, moderately nutrient-rich to nutrient-rich, moderately moist to dry soils', 'Forests on mature, moderately nutrient-rich to nutrient-rich, moderately moist to dry soils', '', 43, '{1042,1505,1601,17,1783,18095,181,18127,18221,1825,1925,2118,2219,2223,2237,2243,2610,2614,263,266,276,2906,2949,300,3049,3090,3093,3401,3421,3522,3752,3857,3905,4004,4067,4392,4404,4425,4499,4650,4673,4747,4759,5107,5311,5623,5644,723,966}'::int[]),
				(202, 12, '9c', 'Forests on young , nutrient-rich, moderately moist soil', 'Forests on young , nutrient-rich, moderately moist soil', '', 44, '{1049,118,123,1358,1821,201,2624,2633,2703,2764,2769,2776,2781,2817,3105,4056,4421,4909,5039,5316,5533,5534,5608,573,574,6,62,73,962}'::int[]),
				(162, 4, '1c', 'Arable fields on moderately nutritious, non-calcareus soil', 'Arable fields on moderately nutritious, non-calcareus soil', '', 4, '{107,1284,1527,1552,1583,18001,18007,18033,18053,18054,18161,18208,18259,2605,2940,2941,3039,3097,350,3549,3556,3728,3732,3782,380,3844,4003,4112,4113,4116,4193,4336,469,5301,5375,5396,5575,5633,615,992}'::int[]),
				(174, 6, '3c', 'High salt marshes and contact situations between salt and fresh environments', 'High salt marshes and contact situations between salt and fresh environments', '', 16, '{1166,151,1514,166,1887,1979,1992,2094,216,2875,3194,3622,3643,3707,3959,3960,4017}'::int[]),
				(196, 11, '8b', 'Borders between grasslands and forests on nutrient-rich (especially nitrogen), non-calcareous, humic, moderately moist soils', 'Borders between grasslands and forests on nutrient-rich (especially nitrogen), non-calcareous, humic, moderately moist soils', '', 38, '{1028,1067,135,150,1545,1607,1611,176,18052,18088,18097,18111,18118,202,2053,2115,255,2597,2641,2694,2699,2708,2772,2942,2943,2952,2956,3094,3159,3286,3306,3494,3540,3724,4197,4329,4686,4982,4985,5536,5538,689,78,952}'::int[]),
				(183, 9, '6', 'Plants on dry grasslands and walls', 'Plants on dry grasslands and walls', '', 25, '{1086}'::int[]),
				(193, 10, '7e', 'Dry heathlands and unfertilized grasslands on moderately moist to dry, nutrient- poor, acidic and humic soils', 'Dry heathlands and unfertilized grasslands on moderately moist to dry, nutrient- poor, acidic and humic soils', '', 35, '{128,1764,18039,1804,18071,18102,18220,1878,1989,2088,2248,2249,2254,2362,2364,2366,2563,2673,2920,3118,3121,3122,3129,3337,3338,344,3467,3513,379,3824,4008,4715,5003,5383,5579,791}'::int[]),
				(187, 9, '6d', 'Grasslands on dry, fairly nutrient-poor, calcium-poor, acidic soil', 'Grasslands on dry, fairly nutrient-poor, calcium-poor, acidic soil', '', 29, '{1326,1368,1374,1588,1769,18005,2358,2483,2484,2511,2891,3673,3694,3695,3698,3811,3904,3909,4150,4181,4251,4702,5291}'::int[]),
				(164, 4, '1e', 'Brushwoods on rarely trodden, nutrient-rich, non-humic and non-calcareus, dry soil', 'Brushwoods on rarely trodden, nutrient-rich, non-humic and non-calcareus, dry soil', '', 6, '{1030,1103,1110,1120,1221,1236,1249,1252,1262,1292,1316,1446,1649,1653,1676,1688,1696,1704,1734,1794,18002,18011,18225,213,2231,2386,2449,2452,2461,2465,2470,2602,2701,2706,2711,2765,3160,3165,333,357,360,3620,3731,3840,3875,3986,4155,4211,4719,4728,4732,5294,536,5406,5463,548,559,817,819,86,861,88,912,922,930,940,98}'::int[]),
				(170, 5, '2c', 'Open , moderately nutrient-rich to nutrien- poor, moist soil', 'Open , moderately nutrient-rich to nutrien- poor, moist soil', '', 12, '{1476,1490,1517,1523,1590,1763,2134,2167,2230,2657,2660,2863,2877,3113,3133,3135,3192,3501,4219,4466,4741,5277,5488,625,776}'::int[]),
				(192, 10, '7d', 'High fens, wet heathlands and unfertilized grasslands on wet, very nutrient-poor, acidic and humic soils', 'High fens, wet heathlands and unfertilized grasslands on wet, very nutrient-poor, acidic and humic soils', '', 34, '{18107,2039,2155,2165,2170,2171,2208,2209,2246,2259,2280,2286,2663,2879,3125,3189,3202,3511,4007,5241,5255}'::int[]),
				(176, 7, '4a', 'Fresh to moderately brackish , nutrient-rich waters', 'Fresh to moderately brackish , nutrient-rich waters', '', 18, '{1339,1341,1343,1345,1625,1626,18121,2741,2750,2793,2794,2795,2797,3069,3070,3071,3072,3075,3085,3184,3205,3208,4339,4340,4347,4353,4355,4357,4372,4375,4376,4377,4379,4382,4383,4385,4390,4486,4494,4504,4506,4519,5210,947,948}'::int[]),
				(169, 5, '2b', 'Open , nutrient-rich (especially nitrogen), wet soil', 'Open , nutrient-rich (especially nitrogen), wet soil', '', 11, '{1301,1322,1702,1722,2859,3699,3799,386,3979,4208,425,427,429,4297,4308,432,5368,546,905}'::int[]),
				(168, 5, '2a', 'Nutrient-rich sites with changing water levels or otherwise fluctuating environmental conditions', 'Nutrient-rich sites with changing water levels or otherwise fluctuating environmental conditions', '', 10, '{1300,1304,1719,18036,18147,18156,1886,2010,206,2070,2072,2129,2149,2240,2520,2523,2543,2853,2865,2868,2874,2882,2912,2983,2989,2993,3052,3197,3484,3680,3692,3708,3829,3896,4078,4204,4268,4272,4531,4533,4699,4735,5270,5390,675,693,775}'::int[]),
				(163, 4, '1d', 'Frequently trodden sites on dry, nutrient-rich soil', 'Frequently trodden sites on dry, nutrient-rich soil', '', 5, '{1141,1176,1177,1258,1455,1510,1512,1520,18021,18185,3839,3883,3886,3961,3989,4049,4228,540}'::int[]),
				(191, 10, '7c', 'Unfertilized grasslands on moist to wet, moderately nutrient-poor , weakly acidic, peaty soils', 'Unfertilized grasslands on moist to wet, moderately nutrient-poor , weakly acidic, peaty soils', '', 33, '{1472,1897,1932,2014,2079,2093,2120,2205,243,2866,3079,3375,3407,3431,5549,5610,680,827}'::int[]),
				(160, 4, '1a', 'Arable fields on nutrient-rich, non-calcareous soil', 'Arable fields on nutrient-rich, non-calcareous soil', '', 2, '{1140,1222,1308,1327,136,1413,1421,1604,1715,18018,1802,1803,18144,18165,18199,18200,18209,18217,2133,2304,2310,2314,2576,2645,2695,2953,2955,2957,3139,3499,3524,3529,3571,3711,3741,3992,3997,4011,4196,4216,5354,5384,5385,5386,5387,5545,616,716,821,842,846,850,89}'::int[]),
				(159, 4, '1', 'Plants on arable fields and dry brushwoods', 'Arable fields and dry brushwoods', '', 1, '{18030,18179,2603,3190,5459}'::int[]),
				(172, 6, '3a', 'Beaches , coastal dunes and sandy tidal high water marks', 'Beaches , coastal dunes and sandy tidal high water marks', '', 14, '{1128,1179,1437,1633,1637,1641,1661,196,2389,3543,3715,3867,3895,3983}'::int[]),
				(186, 9, '6c', 'Grasslands on dry, moderately nutrient-rich, calcareous or zinc-containing, neutral to alkaline soil', 'Grasslands on dry, moderately nutrient-rich, calcareous or zinc-containing, neutral to alkaline soil', '', 28, '{1068,1203,1328,1354,1462,1508,1578,158,160,1754,1844,193,1952,2203,2294,2319,2372,2477,2500,2502,3021,3050,3051,3054,3345,3418,3437,3457,3497,3636,3751,3758,3800,3939,3940,3975,3976,4057,4180,4402,4476,454,489,49,4924,4991,5000,509,5363,699,734}'::int[]),
				(198, 11, '8d', 'Shrublands on moderately moist to dry, nutrient-rich soil', 'Shrublands on moderately moist to dry, nutrient-rich soil', '', 40, '{1025,1389,1410,148,1785,18210,1822,1860,19,2226,2398,2705,2724,2737,3216,4446,4447,4654,4692,4748,4764,4768,4781,4809,4819,4822,4829,4843,5414,959}'::int[]),
				(177, 7, '4b', 'Fresh, moderately nutrient-poor to very nutrient-poor waters and their periodically drying shores', 'Fresh, moderately nutrient-poor to very nutrient-poor waters and their periodically drying shores', '', 19, '{1325,1378,152,2137,2140,2227,2228,2739,2742,2832,2834,2860,3080,3081,3082,3083,3178,3835,43,4343,4364,4381,5504,5525}'::int[]),
				(182, 8, '5b', 'Moderately fertilized grasslands on wet ground', 'Moderately fertilized grasslands on wet ground', '', 24, '{1495,1771,1772,18256,1981,2180,2402,2420,2838,2898,2922,3088,320,3200,3781,3947,4573,4576,4581,4583,4595,4599,4670,4927,4989,528,532,5378,554,5550,792}'::int[]),
				(197, 11, '8c', 'Borders between grasslands and forests on calcareous, loamy , moderately moist to dry soils', 'Borders between grasslands and forests on calcareous, loamy , moderately moist to dry soils', '', 39, '{1085,131,1363,1367,1458,1565,2338,2408,2529,280,283,3004,3044,3398,3425,3426,3429,3435,4543,4561,4563,4671,4816,5328,5601,60,676}'::int[]),
				(204, 12, '9e', 'Forests and forest edges on fairly nutrient-poor to very nutrient-poor, non-calcareus, dry soil', 'Forests and forest edges on fairly nutrient-poor to very nutrient-poor, non-calcareus, dry soil', '', 46, '{1405,1770,1779,1780,1786,18083,18093,18154,1823,2186,2210,2216,2261,2262,2269,2283,2363,2397,2609,2612,2615,2619,264,2897,2909,3053,3115,3126,3201,3352,3406,3420,3477,3611,3832,3951,4326,4330,4604,4763,4901,4933,5051,670,837,978,980,984}'::int[]),
				(195, 11, '8a', 'Clear cuttings on moderately moist to dry, moderately nutrient rich to nutrient-rich soils', 'Clear cuttings on moderately moist to dry, moderately nutrient rich to nutrient-rich soils', '', 37, '{1762,18,18191,2078,21,2654,2935,2938,3308,3761,4674,4867,5268,5401,624,807,813}'::int[]),
				(185, 9, '6b', 'Grasslands on dry, moderately nutrient-rich to nutrient-rich, non-calcareus to moderately calcareous slightly acidic to slightly alkaline soil', 'Grasslands on dry, moderately nutrient-rich to nutrient-rich, non-calcareus to moderately calcareous slightly acidic to slightly alkaline soil', '', 27, '{1036,1078,1151,1214,1432,1434,1450,1451,1487,1531,1536,1843,1848,1854,1911,230,2440,2514,2548,2552,2579,2580,2593,3057,3092,3110,3439,3498,3677,3814,387,4005,4035,4055,4151,4152,4419,4492,5016,5252,5362,5388,5397,5559,5626,581,607,608,610,647,67,700,801,880}'::int[]),
				(178, 7, '4c', 'Nutrient-rich waterfronts and swamps', 'Nutrient-rich waterfronts and swamps', '', 20, '{1037,12,122,1298,1334,153,155,177,18040,18055,18105,18120,1888,1896,1901,1984,2081,2090,2099,2124,2130,214,2141,215,2172,2174,2235,250,267,2825,2965,2979,3032,3293,3303,36,37,39,3931,3935,3936,4023,4042,4069,4289,4512,46,4996,5296,5306,5315,5358,5366,5510,5516,5526,5528}'::int[]),
				(165, 4, '1f', 'Brushwoods on rarely trodden, calcareous , non-humic , dry soil', 'Brushwoods on rarely trodden, calcareous , non-humic , dry soil', '', 7, '{1000,1010,1014,1182,1185,1187,1244,1309,1313,1317,1525,1700,1712,18170,2196,2297,2968,2998,3024,3317,3500,3725,440,447,450,4555,4556,464,5318,5323,5334,5343,5352,5411,5473,549,687,725,733,997,998}'::int[]),
				(203, 12, '9d', 'Forests on mature, calcareous , dry ground', 'Forests on mature, calcareous , dry ground', '', 45, '{1060,1372,1409,1767,1824,1967,2220,2315,236,3,3347,3348,3350,3424,3473,4002,4416,4427,4434,4739,4994,5483,5489,5492,5493,5499,5530,5619,5638,5651,5653,77}'::int[]),
				(173, 6, '3b', 'Salt and strongly brackish waters, mudflats and low salt marshes', 'Salt and strongly brackish waters, mudflats and low salt marshes', '', 15, '{1650,1652,1743,1751,18162,2911,3634,3653,4090,4092,4096,4098,5022,5023,5666,5665}'::int[]),
				(200, 12, '9a', 'Forests on nutrient-rich, moist to wet soils and from source areas', 'Forests on nutrient-rich, moist to wet soils and from source areas', '', 42, '{1144,1147,1152,1344,1347,1384,1608,1988,2087,2096,2244,25,2729,2732,3035,3196,3213,3223,3224,3521,3929,4320,4682,5080,5119,5190,5220,5221,5382,5485,5486,951,964}'::int[]),
				(166, 4, '1g', 'Brushwoods on hardly trodden , nutrient-rich, humic , moderately dry soil', 'Brushwoods on hardly trodden , nutrient-rich, humic , moderately dry soil', '', 8, '{1127,1366,1686,180,18159,18254,2707,2924,2959,3156,3248,3577,363,367,374,402,4198,4201,4223,4302,443,5020,515,589,688,832,862,915}'::int[])

			) select *
			  from ecocode_definitions;

		insert into public.tbl_ecocode_systems (ecocode_system_id, biblio_id, definition, "name", notes) values
			(v_ecocode_system_id, 5555, 'Dutch ecological classification for plants', 'Arnolds & van der Maarel (plants)', 'Experimental inclusion of this system to test use of plant traits in SEAD');
			-- correct reference? select * from tbl_biblio where biblio_id = 5555

		for v_group in select * from temp_ecocode_groups loop

			insert into tbl_ecocode_groups (definition, ecocode_system_id, name, abbreviation)
				values (v_group.definition, v_ecocode_system_id, v_group.name, v_group. abbreviation)
					returning ecocode_group_id INTO v_ecocode_group_id;

			update temp_ecocode_groups
				set global_ecocode_group_id = v_ecocode_group_id
					where local_ecocode_group_id = v_group.local_ecocode_group_id;

			raise notice '%', v_group.name;

		end loop;

		for v_definition in select * from temp_ecocode_definitions loop

			select global_ecocode_group_id
				into v_ecocode_group_id
					from temp_ecocode_groups
						where local_ecocode_group_id = v_definition.local_ecocode_group_id;

			insert into tbl_ecocode_definitions (abbreviation, definition, ecocode_group_id, "name", notes, sort_order)
				values (v_definition.abbreviation, v_definition.definition, v_ecocode_group_id, v_definition."name", v_definition.notes, v_definition.sort_order)
					returning ecocode_definition_id
						into v_ecocode_definition_id;

			insert into tbl_ecocodes (ecocode_definition_id, taxon_id)
				select v_ecocode_definition_id, unnest(v_definition.taxon_ids);

			raise notice '%', v_definition.name;

		end loop;

		drop table temp_ecocode_definitions;
		drop table temp_ecocode_groups;

	exception when sqlstate 'GUARD' then
		raise notice 'ALREADY EXECUTED';
	end;

end $$ language plpgsql;
