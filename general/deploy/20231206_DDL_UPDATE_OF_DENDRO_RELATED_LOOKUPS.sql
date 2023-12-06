-- Deploy sead_change_control:20231206_DDL_UPDATE_OF_DENDRO_RELATED_LOOKUPS to pg
/****************************************************************************************************************
Author        Roger Mähler
Date          2023-12-06
Description   See https://github.com/humlab-sead/sead_change_control/issues/153 
Prerequisites 
Reviewer      
Approver      
Idempotent    Yes
Notes
 *****************************************************************************************************************/
begin;

do $$
begin

    update tbl_dendro_lookup set name = 'Earlywood/Latewood' where dendro_lookup_id = 123;
    update tbl_dendro_lookup set description = 'Number of analysed radii.' where dendro_lookup_id = 124;
    update tbl_dendro_lookup set name = 'EW/LW measurements', description = 'Record of whether the earlywood and latewood of each ring has been measured separately.' where dendro_lookup_id = 125;
    update tbl_dendro_lookup set description = 'Number of sapwood rings in a sample.' where dendro_lookup_id = 126;
    update tbl_dendro_lookup set description = 'The outermost ring immediately inside the bark. Presence of this represents the last year of growth and the exact felling year.' where dendro_lookup_id = 128;
    update tbl_dendro_lookup set description = 'The innermost ring of a tree stem or twig.' where dendro_lookup_id = 129;
    update tbl_dendro_lookup set description = 'The minimum estimated age of the tree.' where dendro_lookup_id = 130;
    update tbl_dendro_lookup set description = 'The maximum estimated age of the tree.' where dendro_lookup_id = 131;
    update tbl_dendro_lookup set description = 'The minimum estimated growth year as inferred from the analysed tree rings. ' where dendro_lookup_id = 132;
    update tbl_dendro_lookup set description = 'The maximal estimated growth year as inferred from the analysed tree rings.' where dendro_lookup_id = 133;
    update tbl_dendro_lookup set description = 'The felling year as inferred from the analysed outermost tree-ring date' where dendro_lookup_id = 134;
    update tbl_dendro_lookup set name = 'Possible estimated felling year', description = 'Used for samples where dating has not been succesful but a non-statistically satisfactory dating suggestion is given.' where dendro_lookup_id = 135;

    update tbl_sample_group_description_types set description = 'Specification of the technique used for the framework of the structure. (e.g. "timber framing")' where sample_group_description_type_id = 57;

    update tbl_sample_location_types set description = 'A description of the sampled area. i.e. what building or what part of the building was sampled, and possibly its function. (e.g. "western tower", "eastern barn", "chancel").' where sample_location_type_id = 71;
    update tbl_sample_location_types set description = 'Description of what direction the sampled area is (e.g. "eastern side", "northern corner").' where sample_location_type_id = 75;
    update tbl_sample_location_types set description = 'Description of the area in the room/building that was sampled (e.g. "door", "beneath stairs", "truss").' where sample_location_type_id = 76;
    update tbl_sample_location_types set description = 'Description of the object, or part of object, was sampled (e.g. "3rd log from bottom", "doorframe", "beam").' where sample_location_type_id = 77;

    update tbl_season_types set description = 'A division of the year, marked by changes in weather. This can include multiple seasons (e.g. winter-spring, summer-winter).' where season_type_id = 10;
    
end $$;

commit;