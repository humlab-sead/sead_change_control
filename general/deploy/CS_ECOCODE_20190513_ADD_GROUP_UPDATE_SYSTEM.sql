-- Deploy sead_change_control:CS_ECOCODE_20190513_ADD_GROUP_UPDATE_SYSTEM to pg

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
    
        INSERT INTO "public"."tbl_ecocode_groups"("ecocode_group_id", "date_updated", "definition", "ecocode_system_id", "name", "abbreviation") VALUES (7, '2017-09-04 13:41:11.782203+02', NULL, 2, 'Habitat trait', 'BugsCEP');

        UPDATE "public"."tbl_ecocode_groups" SET "date_updated" = '2017-08-14 11:58:50.916+02', "definition" = NULL, "ecocode_system_id" = 3, "name" = 'Ecology', "abbreviation" = 'Eco' WHERE "ecocode_group_id" = 1;
        UPDATE "public"."tbl_ecocode_groups" SET "date_updated" = '2017-08-14 11:58:50.932+02', "definition" = NULL, "ecocode_system_id" = 3, "name" = 'Food Condition', "abbreviation" = 'FCo' WHERE "ecocode_group_id" = 2;
        UPDATE "public"."tbl_ecocode_groups" SET "date_updated" = '2017-08-14 11:58:50.932+02', "definition" = NULL, "ecocode_system_id" = 3, "name" = 'Food Dependency', "abbreviation" = 'FDe' WHERE "ecocode_group_id" = 3;
        UPDATE "public"."tbl_ecocode_groups" SET "date_updated" = '2017-08-14 11:58:50.932+02', "definition" = NULL, "ecocode_system_id" = 3, "name" = 'Food Nourishment', "abbreviation" = 'FNo' WHERE "ecocode_group_id" = 4;
        UPDATE "public"."tbl_ecocode_groups" SET "date_updated" = '2017-08-14 11:58:50.932+02', "definition" = NULL, "ecocode_system_id" = 3, "name" = 'Habitat Range', "abbreviation" = 'HRa' WHERE "ecocode_group_id" = 5;
        UPDATE "public"."tbl_ecocode_groups" SET "date_updated" = '2017-08-14 11:58:50.947+02', "definition" = NULL, "ecocode_system_id" = 3, "name" = 'Habitat Type', "abbreviation" = 'HTy' WHERE "ecocode_group_id" = 6;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'BEco01', "date_updated" = '2017-08-14 11:58:52.4+02', "definition" = 'Aquatics', "ecocode_group_id" = 7, "name" = 'Aquatics', "notes" = 'Living in/on water, in any form. From temporary pools to lakes and rivers.', "sort_order" = 0 WHERE "ecocode_definition_id" = 1;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'BEco01a', "date_updated" = '2017-08-14 11:58:52.416+02', "definition" = 'Standing water (ponds) indicators', "ecocode_group_id" = 7, "name" = 'Indicators: Standing water', "notes" = 'Primary habitat in/on pools, ponds, slow flowing water – including temporary ponds, but avoiding species specifically in vegetation and mud or banks of ponds.', "sort_order" = 0 WHERE "ecocode_definition_id" = 2;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'BEco01b', "date_updated" = '2017-08-14 11:58:52.416+02', "definition" = 'Running water (rivers/streams) indicators', "ecocode_group_id" = 7, "name" = 'Indicators: Running water', "notes" = 'Rivers and/or streams. Species predominantly found in these.', "sort_order" = 0 WHERE "ecocode_definition_id" = 3;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'BEco02', "date_updated" = '2017-08-14 11:58:52.416+02', "definition" = 'Pasture/Dung', "ecocode_group_id" = 7, "name" = 'Pasture/Dung', "notes" = 'Grazed land of varying form. Includes most dung beetles, including those that are not stenotopic to dung. Mostly open landscape, but may include pasture-woodland when in combination with BEco4.', "sort_order" = 0 WHERE "ecocode_definition_id" = 4;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'BEco03', "date_updated" = '2017-08-14 11:58:52.416+02', "definition" = 'Meadowland', "ecocode_group_id" = 7, "name" = 'Meadowland', "notes" = 'Natural grassland or near equivalents. Open landscape.', "sort_order" = 0 WHERE "ecocode_definition_id" = 5;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'BEco04', "date_updated" = '2017-08-14 11:58:52.416+02', "definition" = 'Wood and trees', "ecocode_group_id" = 7, "name" = 'Wood and trees', "notes" = 'Species tied to either the actual wood, trees or the forest/woodland environment. Generally shade tolerant.', "sort_order" = 0 WHERE "ecocode_definition_id" = 6;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'BEco04a', "date_updated" = '2017-08-14 11:58:52.432+02', "definition" = 'Deciduous Wood and tree indicators', "ecocode_group_id" = 7, "name" = 'Indicators: Deciduous', "notes" = 'Specifically deciduous wood or woodland, species not found on coniferous wood except on rare occasions.', "sort_order" = 0 WHERE "ecocode_definition_id" = 7;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'BEco04b', "date_updated" = '2017-08-14 11:58:52.432+02', "definition" = 'Coniferous Wood and tree indicators', "ecocode_group_id" = 7, "name" = 'Indicators: Coniferous', "notes" = 'Specifically coniferous wood or woodland, species not found on deciduous wood except on rare occasions.', "sort_order" = 0 WHERE "ecocode_definition_id" = 8;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'BEco05a', "date_updated" = '2017-08-14 11:58:52.432+02', "definition" = 'Wetlands/marshes', "ecocode_group_id" = 7, "name" = 'Wetlands/marshes', "notes" = 'Water tolerant but not living specifically in the water. May include mud and bank species, as well as those moss & reed dwellers that prefer permanently wet environments.', "sort_order" = 0 WHERE "ecocode_definition_id" = 9;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'BEco05b', "date_updated" = '2017-08-14 11:58:52.432+02', "definition" = 'Open wet habitats, shingle, etc', "ecocode_group_id" = 7, "name" = 'Open wet habitats', "notes" = 'Hydrophilous shade intolerant species, shingle, beaches etc. and other exposed wet environments.', "sort_order" = 0 WHERE "ecocode_definition_id" = 10;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'BEco06a', "date_updated" = '2017-08-14 11:58:52.432+02', "definition" = 'Disturbed ground/arable', "ecocode_group_id" = 7, "name" = 'Disturbed/arable', "notes" = 'Any disturbed ground surface, be it by animal, geological or human action. Includes ploughed fields, edges of watering holes, farm yards, glacial margins etc.', "sort_order" = 0 WHERE "ecocode_definition_id" = 11;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'BEco06b', "date_updated" = '2017-08-14 11:58:52.432+02', "definition" = 'Sandy/dry disturbed ground/arable', "ecocode_group_id" = 7, "name" = 'Sandy/dry disturbed/arable', "notes" = 'Similar to the above, but more xerophilous species. Typifies beach, dune and aeolian landscapes, or ploughed fields on more sandy soils. A more dominant environment in southern Europe than BEco6a.', "sort_order" = 0 WHERE "ecocode_definition_id" = 12;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'BEco07a', "date_updated" = '2017-08-14 11:58:52.432+02', "definition" = 'Dung/foul decaying habitats', "ecocode_group_id" = 7, "name" = 'Dung/foul habitats', "notes" = 'A wide category for species that live in decaying, muddy and fetid environments, including compost, wet hay, dung and muddy edges of water.', "sort_order" = 0 WHERE "ecocode_definition_id" = 13;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'BEco07b', "date_updated" = '2017-08-14 11:58:52.432+02', "definition" = 'Carrion', "ecocode_group_id" = 7, "name" = 'Carrion', "notes" = 'Animal carcasses of all forms, dry or wet.', "sort_order" = 0 WHERE "ecocode_definition_id" = 14;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'BEco07c', "date_updated" = '2017-08-14 11:58:52.432+02', "definition" = 'Dung indicators', "ecocode_group_id" = 7, "name" = 'Indicators: Dung', "notes" = 'Primary habitat dung, or dung essential for reproduction. Includes parasites of other species that live in dung. Majority of species not found in other environments represented by the broader class BEco7a, but some may be found on occasions outside of dung.', "sort_order" = 0 WHERE "ecocode_definition_id" = 15;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'BEco08', "date_updated" = '2017-08-14 11:58:52.432+02', "definition" = 'Mould beetles of all types.', "ecocode_group_id" = 7, "name" = 'Mould beetles', "notes" = 'Large part of the typical indoor synanthropic fauna in northern Europe.', "sort_order" = 0 WHERE "ecocode_definition_id" = 16;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'BEco09a', "date_updated" = '2017-08-14 11:58:52.432+02', "definition" = 'General synanthropic', "ecocode_group_id" = 7, "name" = 'General synanthropic', "notes" = 'In association with humans, either when outside of their ‘natural’ geographical range, or in all known records. This term may be geographically specific, and is used in a north European context here.', "sort_order" = 0 WHERE "ecocode_definition_id" = 17;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'BEco09b', "date_updated" = '2017-08-14 11:58:52.432+02', "definition" = 'Stored grain pest', "ecocode_group_id" = 7, "name" = 'Stored grain pest', "notes" = 'Pests of stored products.', "sort_order" = 0 WHERE "ecocode_definition_id" = 18;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'BEco10', "date_updated" = '2017-08-14 11:58:52.432+02', "definition" = 'Dry dead wood', "ecocode_group_id" = 7, "name" = 'Dry dead wood', "notes" = 'Wood in constructions, but also similar natural environments such as large fallen trees, especially in warmer climates.', "sort_order" = 0 WHERE "ecocode_definition_id" = 19;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'BEco12', "date_updated" = '2017-08-14 11:58:52.432+02', "definition" = 'Heathland and moorland', "ecocode_group_id" = 7, "name" = 'Heathland & moorland', "notes" = 'Heathland and moorland, but may also indicate the under-storey of a Boreal forest.', "sort_order" = 0 WHERE "ecocode_definition_id" = 20;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'BEco13', "date_updated" = '2017-08-14 11:58:52.432+02', "definition" = 'Halotolerant (all salts)', "ecocode_group_id" = 7, "name" = 'Halotolerant', "notes" = 'Salt tolerant, often coastal or salt marsh tied, but not just NaCl – can be species found on mineral rich ploughed soils or where mineral precipitation is prominent.', "sort_order" = 0 WHERE "ecocode_definition_id" = 21;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecto', "date_updated" = '2017-08-14 11:58:52.447+02', "definition" = 'Ectoparasites', "ecocode_group_id" = 7, "name" = 'Ectoparasite', "notes" = 'External parasites of humans and animals', "sort_order" = 0 WHERE "ecocode_definition_id" = 22;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecoab', "date_updated" = '2017-08-14 11:59:00.28+02', "definition" = 'in trees.', "ecocode_group_id" = 1, "name" = 'arboricolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 23;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecoag', "date_updated" = '2017-08-14 11:59:00.28+02', "definition" = 'agarics', "ecocode_group_id" = 1, "name" = 'agaricolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 24;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecoak', "date_updated" = '2017-08-14 11:59:00.28+02', "definition" = 'in tree tops.', "ecocode_group_id" = 1, "name" = 'akrodendric', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 25;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecoap', "date_updated" = '2017-08-14 11:59:00.28+02', "definition" = 'in reeds.', "ecocode_group_id" = 1, "name" = 'arundicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 26;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecoaq', "date_updated" = '2017-08-14 11:59:00.28+02', "definition" = 'in water', "ecocode_group_id" = 1, "name" = 'aquatic', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 27;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecoar', "date_updated" = '2017-08-14 11:59:00.28+02', "definition" = 'on sand.', "ecocode_group_id" = 1, "name" = 'arenicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 28;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecoav', "date_updated" = '2017-08-14 11:59:00.28+02', "definition" = 'in arable fields.', "ecocode_group_id" = 1, "name" = 'arvicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 29;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecobo', "date_updated" = '2017-08-14 11:59:00.296+02', "definition" = 'tube fungi.', "ecocode_group_id" = 1, "name" = 'boleticolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 30;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecoca', "date_updated" = '2017-08-14 11:59:00.296+02', "definition" = 'in cadavers.', "ecocode_group_id" = 1, "name" = 'cadavericolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 31;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecoco', "date_updated" = '2017-08-14 11:59:00.296+02', "definition" = 'under bark.', "ecocode_group_id" = 1, "name" = 'corticolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 32;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecocp', "date_updated" = '2017-08-14 11:59:00.296+02', "definition" = 'in fields.', "ecocode_group_id" = 1, "name" = 'campicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 33;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecocv', "date_updated" = '2017-08-14 11:59:00.296+02', "definition" = 'in caves.', "ecocode_group_id" = 1, "name" = 'cavernicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 34;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecode', "date_updated" = '2017-08-14 11:59:00.296+02', "definition" = 'in waste places.', "ecocode_group_id" = 1, "name" = 'deserticolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 35;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecodt', "date_updated" = '2017-08-14 11:59:00.296+02', "definition" = 'in litter', "ecocode_group_id" = 1, "name" = 'detriticolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 36;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecofl', "date_updated" = '2017-08-14 11:59:00.296+02', "definition" = 'on flowers.', "ecocode_group_id" = 1, "name" = 'floricolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 37;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecofu', "date_updated" = '2017-08-14 11:59:00.296+02', "definition" = 'in fungi.', "ecocode_group_id" = 1, "name" = 'fungicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 38;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecogr', "date_updated" = '2017-08-14 11:59:00.296+02', "definition" = 'on grasses', "ecocode_group_id" = 1, "name" = 'graminicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 39;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecohe', "date_updated" = '2017-08-14 11:59:00.296+02', "definition" = 'on herbs.', "ecocode_group_id" = 1, "name" = 'herbicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 40;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecohu', "date_updated" = '2017-08-14 11:59:00.312+02', "definition" = 'in the humus layer.', "ecocode_group_id" = 1, "name" = 'humicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 41;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecolc', "date_updated" = '2017-08-14 11:59:00.312+02', "definition" = 'in mud.', "ecocode_group_id" = 1, "name" = 'linicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 42;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecoli', "date_updated" = '2017-08-14 11:59:00.312+02', "definition" = 'in wood.', "ecocode_group_id" = 1, "name" = 'lignicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 43;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecolm', "date_updated" = '2017-08-14 11:59:00.312+02', "definition" = 'in inland waters.', "ecocode_group_id" = 1, "name" = 'limnicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 44;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecomi', "date_updated" = '2017-08-14 11:59:00.312+02', "definition" = 'in galleries nests lairs of rodents etc.', "ecocode_group_id" = 1, "name" = 'microcavernicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 45;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecomu', "date_updated" = '2017-08-14 11:59:00.312+02', "definition" = 'in moss.', "ecocode_group_id" = 1, "name" = 'muscicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 46;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Econi', "date_updated" = '2017-08-14 11:59:00.312+02', "definition" = 'in birds'' nests.', "ecocode_group_id" = 1, "name" = 'nidicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 47;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Econv', "date_updated" = '2017-08-14 11:59:00.312+02', "definition" = 'snow.', "ecocode_group_id" = 1, "name" = 'nivicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 48;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecopa', "date_updated" = '2017-08-14 11:59:00.312+02', "definition" = 'in swamps.', "ecocode_group_id" = 1, "name" = 'paludicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 49;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecope', "date_updated" = '2017-08-14 11:59:00.312+02', "definition" = 'among stones.', "ecocode_group_id" = 1, "name" = 'petricolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 50;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecoph', "date_updated" = '2017-08-14 11:59:00.312+02', "definition" = 'leaves.', "ecocode_group_id" = 1, "name" = 'phyllicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 51;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecopl', "date_updated" = '2017-08-14 11:59:00.312+02', "definition" = 'on shoots.', "ecocode_group_id" = 1, "name" = 'planticolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 52;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecopo', "date_updated" = '2017-08-14 11:59:00.312+02', "definition" = 'in fungi (e.g. dry rot).', "ecocode_group_id" = 1, "name" = 'polyporicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 53;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecopr', "date_updated" = '2017-08-14 11:59:00.327+02', "definition" = 'in meadows.', "ecocode_group_id" = 1, "name" = 'praticolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 54;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecops', "date_updated" = '2017-08-14 11:59:00.327+02', "definition" = 'tied to specific host animal', "ecocode_group_id" = 1, "name" = 'parasitic', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 55;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecopt', "date_updated" = '2017-08-14 11:59:00.327+02', "definition" = 'in plant debris.', "ecocode_group_id" = 1, "name" = 'phytodetriticolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 56;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecopy', "date_updated" = '2017-08-14 11:59:00.327+02', "definition" = 'in leaf debris.', "ecocode_group_id" = 1, "name" = 'phyllodetriticolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 57;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecori', "date_updated" = '2017-08-14 11:59:00.327+02', "definition" = 'on river banks.', "ecocode_group_id" = 1, "name" = 'ripicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 58;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecosi', "date_updated" = '2017-08-14 11:59:00.327+02', "definition" = 'in woodland.', "ecocode_group_id" = 1, "name" = 'silvicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 59;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecosk', "date_updated" = '2017-08-14 11:59:00.327+02', "definition" = 'in dung', "ecocode_group_id" = 1, "name" = 'stercoricolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 60;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecosp', "date_updated" = '2017-08-14 11:59:00.327+02', "definition" = 'in Sphagnum.', "ecocode_group_id" = 1, "name" = 'sphagnicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 61;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecost', "date_updated" = '2017-08-14 11:59:00.327+02', "definition" = 'on the steppes.', "ecocode_group_id" = 1, "name" = 'steppicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 62;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecosu', "date_updated" = '2017-08-14 11:59:00.327+02', "definition" = 'at sap.', "ecocode_group_id" = 1, "name" = 'succicolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 63;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecote', "date_updated" = '2017-08-14 11:59:00.327+02', "definition" = 'in the earth.', "ecocode_group_id" = 1, "name" = 'terricolous or subterranean', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 64;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecoto', "date_updated" = '2017-08-14 11:59:00.343+02', "definition" = 'by waterfalls.', "ecocode_group_id" = 1, "name" = 'torrenticolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 65;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecoxy', "date_updated" = '2017-08-14 11:59:00.343+02', "definition" = 'in wood debris.', "ecocode_group_id" = 1, "name" = 'xylodetriticolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 66;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'Ecozo', "date_updated" = '2017-08-14 11:59:00.343+02', "definition" = 'in animal debris', "ecocode_group_id" = 1, "name" = 'zoodetriticolous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 67;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FCoHo', "date_updated" = '2017-08-14 11:59:00.343+02', "definition" = 'slimey dissolved consistency.', "ecocode_group_id" = 2, "name" = 'holoprobic', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 68;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FCoMe', "date_updated" = '2017-08-14 11:59:00.343+02', "definition" = 'distinct traces of rot in the whole substrate.', "ecocode_group_id" = 2, "name" = 'mesoprobic', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 69;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FCoOl', "date_updated" = '2017-08-14 11:59:00.343+02', "definition" = 'beginning to rot.', "ecocode_group_id" = 2, "name" = 'oligoprobic', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 70;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FDeEk', "date_updated" = '2017-08-14 11:59:00.343+02', "definition" = 'feeds on the plant’s outer parts.', "ecocode_group_id" = 3, "name" = 'ectophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 71;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FDeEn', "date_updated" = '2017-08-14 11:59:00.343+02', "definition" = 'feeds on the plant’s inner parts.', "ecocode_group_id" = 3, "name" = 'endophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 72;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FDeMe', "date_updated" = '2017-08-14 11:59:00.343+02', "definition" = 'feeds on plant structural parts.', "ecocode_group_id" = 3, "name" = 'merotopic', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 73;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FDeMo', "date_updated" = '2017-08-14 11:59:00.343+02', "definition" = 'specialises on a  specific plant or animal species.', "ecocode_group_id" = 3, "name" = 'monophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 74;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FDeOl', "date_updated" = '2017-08-14 11:59:00.343+02', "definition" = 'on a narrow range of often closely related species.', "ecocode_group_id" = 3, "name" = 'oligophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 75;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FDeOm', "date_updated" = '2017-08-14 11:59:00.343+02', "definition" = 'on living or dead plant and animal materials.', "ecocode_group_id" = 3, "name" = 'omnivorous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 76;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FDePo', "date_updated" = '2017-08-14 11:59:00.343+02', "definition" = 'on a wide variety of various plant or animal species.', "ecocode_group_id" = 3, "name" = 'polyphagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 77;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FDeXe', "date_updated" = '2017-08-14 11:59:00.343+02', "definition" = 'developing on an otherwise not common food.', "ecocode_group_id" = 3, "name" = 'xenophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 78;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FDeXn', "date_updated" = '2017-08-14 11:59:00.359+02', "definition" = 'prefers a foodstuff originating from abroad.', "ecocode_group_id" = 3, "name" = 'xenophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 79;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoAl', "date_updated" = '2017-08-14 11:59:00.359+02', "definition" = 'feeds on algae.', "ecocode_group_id" = 4, "name" = 'algophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 80;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoAp', "date_updated" = '2017-08-14 11:59:00.359+02', "definition" = 'on aphids.', "ecocode_group_id" = 4, "name" = 'aphidophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 81;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoBl', "date_updated" = '2017-08-14 11:59:00.359+02', "definition" = 'on buds.', "ecocode_group_id" = 4, "name" = 'blastophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 82;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoCa', "date_updated" = '2017-08-14 11:59:00.359+02', "definition" = 'on seeds.', "ecocode_group_id" = 4, "name" = 'carpophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 83;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoCe', "date_updated" = '2017-08-14 11:59:00.359+02', "definition" = 'in galls.', "ecocode_group_id" = 4, "name" = 'cecidophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 84;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoCo', "date_updated" = '2017-08-14 11:59:00.359+02', "definition" = 'on bark.', "ecocode_group_id" = 4, "name" = 'cortivorous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 85;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoCp', "date_updated" = '2017-08-14 11:59:00.359+02', "definition" = 'in dung.', "ecocode_group_id" = 4, "name" = 'coprophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 86;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoCu', "date_updated" = '2017-08-14 11:59:00.359+02', "definition" = 'on stalks.', "ecocode_group_id" = 4, "name" = 'caulophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 87;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoDi', "date_updated" = '2017-08-14 11:59:00.359+02', "definition" = 'eats Dipterous larvae', "ecocode_group_id" = 4, "name" = NULL, "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 88;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoEn', "date_updated" = '2017-08-14 11:59:00.359+02', "definition" = 'eats insects.', "ecocode_group_id" = 4, "name" = 'entomophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 89;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoFr', "date_updated" = '2017-08-14 11:59:00.359+02', "definition" = 'on fruits.', "ecocode_group_id" = 4, "name" = 'fructivorous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 90;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoHe', "date_updated" = '2017-08-14 11:59:00.359+02', "definition" = 'eats worms', "ecocode_group_id" = 4, "name" = 'helminthophagous  ', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 91;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoKr', "date_updated" = '2017-08-14 11:59:00.359+02', "definition" = 'on living animals (parasitic).', "ecocode_group_id" = 4, "name" = 'kreophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 92;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoLi', "date_updated" = '2017-08-14 11:59:00.374+02', "definition" = 'on lichens.', "ecocode_group_id" = 4, "name" = 'lichenophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 93;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoMi', "date_updated" = '2017-08-14 11:59:00.374+02', "definition" = 'eats mites', "ecocode_group_id" = 4, "name" = NULL, "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 94;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoMm', "date_updated" = '2017-08-14 11:59:00.374+02', "definition" = 'eats ants.', "ecocode_group_id" = 4, "name" = 'myrmecophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 95;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoMs', "date_updated" = '2017-08-14 11:59:00.374+02', "definition" = 'feeds on mosses', "ecocode_group_id" = 4, "name" = 'muscophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 96;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoMu', "date_updated" = '2017-08-14 11:59:00.374+02', "definition" = 'eats mollusca.', "ecocode_group_id" = 4, "name" = 'molluscophagous   ', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 97;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoMy', "date_updated" = '2017-08-14 11:59:00.374+02', "definition" = 'on fungi.', "ecocode_group_id" = 4, "name" = 'mycetophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 98;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoNe', "date_updated" = '2017-08-14 11:59:00.374+02', "definition" = 'on dead animals.', "ecocode_group_id" = 4, "name" = 'necrophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 99;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoOo', "date_updated" = '2017-08-14 11:59:00.374+02', "definition" = 'eats eggs.', "ecocode_group_id" = 4, "name" = 'oophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 100;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoPh', "date_updated" = '2017-08-14 11:59:00.374+02', "definition" = 'plant materials.', "ecocode_group_id" = 4, "name" = 'phytophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 101;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoPl', "date_updated" = '2017-08-14 11:59:00.374+02', "definition" = 'on phloem wood', "ecocode_group_id" = 4, "name" = 'phloeophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 102;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoPn', "date_updated" = '2017-08-14 11:59:00.374+02', "definition" = 'eats pollen.', "ecocode_group_id" = 4, "name" = 'pollenophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 103;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoPy', "date_updated" = '2017-08-14 11:59:00.374+02', "definition" = 'on leaves.', "ecocode_group_id" = 4, "name" = 'phyllophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 104;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoRh', "date_updated" = '2017-08-14 11:59:00.374+02', "definition" = 'on roots.', "ecocode_group_id" = 4, "name" = 'rhizophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 105;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoSa', "date_updated" = '2017-08-14 11:59:00.39+02', "definition" = 'in rotting materials.', "ecocode_group_id" = 4, "name" = 'saprophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 106;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoSp', "date_updated" = '2017-08-14 11:59:00.39+02', "definition" = 'on spores.', "ecocode_group_id" = 4, "name" = 'sporophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 107;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoXy', "date_updated" = '2017-08-14 11:59:00.39+02', "definition" = 'in wood.', "ecocode_group_id" = 4, "name" = 'xylophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 108;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'FNoZo', "date_updated" = '2017-08-14 11:59:00.39+02', "definition" = 'animal materials.', "ecocode_group_id" = 4, "name" = 'zoophagous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 109;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HRaEh', "date_updated" = '2017-08-14 11:59:00.39+02', "definition" = 'tolerates a wide range of temperatures.', "ecocode_group_id" = 5, "name" = 'eurythermal', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 110;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HRaEm', "date_updated" = '2017-08-14 11:59:00.39+02', "definition" = 'tolerates a wide range of moisture conditions.', "ecocode_group_id" = 5, "name" = 'euryhygric', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 111;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HRaEu', "date_updated" = '2017-08-14 11:59:00.39+02', "definition" = 'in many varied biotopes.', "ecocode_group_id" = 5, "name" = 'eurytopic', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 112;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HRaSf', "date_updated" = '2017-08-14 11:59:00.39+02', "definition" = 'synanthropic, but not restrictedly so.', "ecocode_group_id" = 5, "name" = 'Facultative Sy', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 113;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HRaSh', "date_updated" = '2017-08-14 11:59:00.39+02', "definition" = 'only in a narrow temperature range.', "ecocode_group_id" = 5, "name" = 'stenothermic', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 114;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HRaSm', "date_updated" = '2017-08-14 11:59:00.39+02', "definition" = 'only in a narrow moisture range.', "ecocode_group_id" = 5, "name" = 'stenohygric', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 115;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HRaSn', "date_updated" = '2017-08-14 11:59:00.39+02', "definition" = 'typical, but non-obligate synanthrope.', "ecocode_group_id" = 5, "name" = 'Typically Sy', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 116;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HRaSs', "date_updated" = '2017-08-14 11:59:00.39+02', "definition" = 'strongly, often obligate synanthrope.', "ecocode_group_id" = 5, "name" = 'Strong Sy', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 117;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HRaSt', "date_updated" = '2017-08-14 11:59:00.39+02', "definition" = 'only in the specified biotope.', "ecocode_group_id" = 5, "name" = 'stenotopic', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 118;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HRaSy', "date_updated" = '2017-08-14 11:59:00.405+02', "definition" = 'living in close association with Man.', "ecocode_group_id" = 5, "name" = 'synanthropic', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 119;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HRaUb', "date_updated" = '2017-08-14 11:59:00.405+02', "definition" = 'occurs everywhere.', "ecocode_group_id" = 5, "name" = 'ubiquitous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 120;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTyac', "date_updated" = '2017-08-14 11:59:00.405+02', "definition" = 'prefers acid conditions.', "ecocode_group_id" = 6, "name" = 'acidophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 121;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTyam', "date_updated" = '2017-08-14 11:59:00.405+02', "definition" = 'attracted to amyls in wood', "ecocode_group_id" = 6, "name" = 'amylophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 122;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTyap', "date_updated" = '2017-08-14 11:59:00.405+02', "definition" = 'associated with bees & wasps', "ecocode_group_id" = 6, "name" = 'apoidephilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 123;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTych', "date_updated" = '2017-08-14 11:59:00.405+02', "definition" = 'attracted by colour.', "ecocode_group_id" = 6, "name" = 'chromophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 124;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTyco', "date_updated" = '2017-08-14 11:59:00.405+02', "definition" = 'dung.', "ecocode_group_id" = 6, "name" = 'coprophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 125;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTyha', "date_updated" = '2017-08-14 11:59:00.405+02', "definition" = 'salty environments.', "ecocode_group_id" = 6, "name" = 'halophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 126;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTyhe', "date_updated" = '2017-08-14 11:59:00.405+02', "definition" = 'prefers light.', "ecocode_group_id" = 6, "name" = 'heliophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 127;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTyhl', "date_updated" = '2017-08-14 11:59:00.405+02', "definition" = 'wood.', "ecocode_group_id" = 6, "name" = 'xylophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 128;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTyht', "date_updated" = '2017-08-14 11:59:00.405+02', "definition" = 'tolerant of saline habitats', "ecocode_group_id" = 6, "name" = 'halotolerant', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 129;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTyhy', "date_updated" = '2017-08-14 11:59:00.405+02', "definition" = 'prefers moisture.', "ecocode_group_id" = 6, "name" = 'hygrophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 130;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTykr', "date_updated" = '2017-08-14 11:59:00.405+02', "definition" = 'water sources.', "ecocode_group_id" = 6, "name" = 'krenophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 131;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTymm', "date_updated" = '2017-08-14 11:59:00.405+02', "definition" = 'associated with ants.', "ecocode_group_id" = 6, "name" = 'myrmecophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 132;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTymy', "date_updated" = '2017-08-14 11:59:00.421+02', "definition" = 'fungi.', "ecocode_group_id" = 6, "name" = 'mycetophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 133;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTyne', "date_updated" = '2017-08-14 11:59:00.421+02', "definition" = 'associated with carrion.', "ecocode_group_id" = 6, "name" = 'necrophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 134;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTyos', "date_updated" = '2017-08-14 11:59:00.421+02', "definition" = 'smell.', "ecocode_group_id" = 6, "name" = 'osmophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 135;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HType', "date_updated" = '2017-08-14 11:59:00.421+02', "definition" = 'among stones.', "ecocode_group_id" = 6, "name" = 'petrophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 136;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTyph', "date_updated" = '2017-08-14 11:59:00.421+02', "definition" = 'prefers shade.', "ecocode_group_id" = 6, "name" = 'pholeophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 137;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTyps', "date_updated" = '2017-08-14 11:59:00.421+02', "definition" = 'sand.', "ecocode_group_id" = 6, "name" = 'psammophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 138;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTyrh', "date_updated" = '2017-08-14 11:59:00.421+02', "definition" = 'associated with flowing water.', "ecocode_group_id" = 6, "name" = 'rheophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 139;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTyro', "date_updated" = '2017-08-14 11:59:00.421+02', "definition" = 'associated with rodents', "ecocode_group_id" = 6, "name" = 'rodentophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 140;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTysa', "date_updated" = '2017-08-14 11:59:00.421+02', "definition" = 'in rotting materials.', "ecocode_group_id" = 6, "name" = 'saprophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 141;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTysi', "date_updated" = '2017-08-14 11:59:00.421+02', "definition" = 'on gravel.', "ecocode_group_id" = 6, "name" = 'silicophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 142;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTyth', "date_updated" = '2017-08-14 11:59:00.421+02', "definition" = 'prefers warm conditions.', "ecocode_group_id" = 6, "name" = 'thermophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 143;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTyti', "date_updated" = '2017-08-14 11:59:00.421+02', "definition" = 'contiguous.', "ecocode_group_id" = 6, "name" = 'tixophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 144;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTytr', "date_updated" = '2017-08-14 11:59:00.421+02', "definition" = 'in caves.', "ecocode_group_id" = 6, "name" = 'trogophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 145;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTyty', "date_updated" = '2017-08-14 11:59:00.437+02', "definition" = 'in bogs.', "ecocode_group_id" = 6, "name" = 'tyrphophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 146;

        UPDATE "public"."tbl_ecocode_definitions" SET "abbreviation" = 'HTyxe', "date_updated" = '2017-08-14 11:59:00.437+02', "definition" = 'prefers dry  places.', "ecocode_group_id" = 6, "name" = 'xerophilous', "notes" = NULL, "sort_order" = 0 WHERE "ecocode_definition_id" = 147;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
