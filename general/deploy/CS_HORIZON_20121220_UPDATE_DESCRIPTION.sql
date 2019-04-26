-- Deploy sead_change_control:CS_HORIZON_20121220_UPDATE_DESCRIPTION to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-04-22
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
    
        update tbl_horizons set description = '(http://www.fao.org) O horizons or layers: Layers dominated by organic material, consisting of undecomposed or partially decomposed litter, such as leaves, needles, twigs, moss, and lichens, which has accumulated on the surface; they may be on top of either mineral or organic soils. O horizons are not saturated with water for prolonged periods. The mineral fraction of such material is only a small percentage of the volume of the material and generally is much less than half of the weight.
An O layer may be at the surface of a mineral soil or at any depth beneath the surface if it is buried. An horizon formed by illuviation of organic material into a mineral subsoil is not an O horizon, though some horizons formed in this manner contain much organic matter.' where horizon_id = 10;

        update tbl_horizons set description = '(http://www.fao.org) A horizons: Mineral horizons which formed at the surface or below an O horizon, in which all or much of the original rock structure has been obliterated and which are characterized by one or more of the following:
    - an accumulation of humified organic matter intimately mixed with the mineral fraction and not displaying properties characteristic of E or B horizons (see below);
    - properties resulting from cultivation, pasturing, or similar kinds of disturbance; or
    - a morphology which is different from the underlying B or C horizon, resulting from processes related to the surface.' where horizon_id = 11;

        update tbl_horizons set description = '(http://www.fao.org) B horizons: Horizons that formed below an A, E, O or H horizon, and in which the dominant features are the obliteration of all or much of the original rock structure, together with one or a combination of the following:
    - illuvial concentration, alone or in combination, of silicate clay, iron, aluminum, humus, carbonates, gypsum or silica;
    - evidence of removal of carbonates;
    - residual concentration of sesquioxides;
    - coatings of sesquioxides that make the horizon conspicuously lower in value, higher in chrome, or redder in hue than overlying and underlying horizons without apparent illuviation of iron;
    - alteration that forms silicate clay or liberates oxides or both and that forms a granular, blocky, or prismatic structure if volume changes accompany changes in moisture content; or
    - brittleness.' where horizon_id = 14;
        
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
