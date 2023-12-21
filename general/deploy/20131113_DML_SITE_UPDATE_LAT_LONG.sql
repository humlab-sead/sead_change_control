-- Deploy general: 20131113_DML_SITE_UPDATE_LAT_LONG

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2013-11-13
  Description   https://github.com/humlab-sead/sead_change_control/issues/151: Set latitude/longitude on 61 sites
  Issue         https://github.com/humlab-sead/sead_change_control/issues/181: https://github.com/humlab-sead/sead_change_control/issues/151
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
    
        update "public"."tbl_sites" set "latitude_dd" = 56.8882890000, "longitude_dd" = 12.5898220000 where "site_id" = 57;
        update "public"."tbl_sites" set "latitude_dd" = 58.3914190000, "longitude_dd" = 11.7564390000 where "site_id" = 60;
        update "public"."tbl_sites" set "latitude_dd" = 55.5672222226, "longitude_dd" = 12.9844440000 where "site_id" = 78;
        update "public"."tbl_sites" set "latitude_dd" = 55.5638888889, "longitude_dd" = 12.9794440000 where "site_id" = 84;
        update "public"."tbl_sites" set "latitude_dd" = 68.6027777778, "longitude_dd" = 19.8483330000 where "site_id" = 85;
        update "public"."tbl_sites" set "latitude_dd" = 57.4808833337, "longitude_dd" = 12.6857750000 where "site_id" = 90;
        update "public"."tbl_sites" set "latitude_dd" = 69.2344444441, "longitude_dd" = 29.2851536467 where "site_id" = 93;
        update "public"."tbl_sites" set "latitude_dd" = 70.4894444441, "longitude_dd" = 29.2500000000 where "site_id" = 97;
        update "public"."tbl_sites" set "latitude_dd" = 70.3221555559, "longitude_dd" = 25.1738640000 where "site_id" = 100;
        update "public"."tbl_sites" set "latitude_dd" = 58.2962444441, "longitude_dd" = 12.5179000000 where "site_id" = 102;
        update "public"."tbl_sites" set "latitude_dd" = 55.5611111111, "longitude_dd" = 12.9716670000 where "site_id" = 105;
        update "public"."tbl_sites" set "latitude_dd" = 61.2238444448, "longitude_dd" = 11.4983500000 where "site_id" = 111;
        update "public"."tbl_sites" set "latitude_dd" = 59.1138888889, "longitude_dd" =  9.7980560000 where "site_id" = 119;
        update "public"."tbl_sites" set "latitude_dd" = 61.2758333337, "longitude_dd" = 11.6069440000 where "site_id" = 121;
        update "public"."tbl_sites" set "latitude_dd" = 55.9519444444, "longitude_dd" = 11.8752780000 where "site_id" = 122;
        update "public"."tbl_sites" set "latitude_dd" = 70.6983333330, "longitude_dd" = 23.6280560000 where "site_id" = 123;
        update "public"."tbl_sites" set "latitude_dd" = 58.4809444448, "longitude_dd" = 13.4798470000 where "site_id" = 124;
        update "public"."tbl_sites" set "latitude_dd" = 55.1130555556, "longitude_dd" = 14.8705560000 where "site_id" = 128;
        update "public"."tbl_sites" set "latitude_dd" = 61.2220416670, "longitude_dd" = 11.4927940000 where "site_id" = 132;
        update "public"."tbl_sites" set "latitude_dd" = 70.9619444444, "longitude_dd" = 26.6700000000 where "site_id" = 135;
        update "public"."tbl_sites" set "latitude_dd" = 63.5861750000, "longitude_dd" = 19.7208000000 where "site_id" = 139;
        update "public"."tbl_sites" set "latitude_dd" = 61.3736111114, "longitude_dd" = 11.5144440000 where "site_id" = 143;
        update "public"."tbl_sites" set "latitude_dd" = 61.3844444441, "longitude_dd" = 11.5433330000 where "site_id" = 153;
        update "public"."tbl_sites" set "latitude_dd" = 70.0669444445, "longitude_dd" = 27.5586110000 where "site_id" = 159;
        update "public"."tbl_sites" set "latitude_dd" = 58.1368305552, "longitude_dd" = 12.9879640000 where "site_id" = 163;
        update "public"."tbl_sites" set "latitude_dd" = 61.2266527781, "longitude_dd" = 11.4976690000 where "site_id" = 165;
        update "public"."tbl_sites" set "latitude_dd" = 63.5844444441, "longitude_dd" = 19.5839940000 where "site_id" = 176;
        update "public"."tbl_sites" set "latitude_dd" = 60.5190944448, "longitude_dd" = 15.4388000000 where "site_id" = 178;
        update "public"."tbl_sites" set "latitude_dd" = 63.8449999997, "longitude_dd" = 20.1447220000 where "site_id" = 186;
        update "public"."tbl_sites" set "latitude_dd" = 63.7231280000, "longitude_dd" = 20.1977080000 where "site_id" = 193;
        update "public"."tbl_sites" set "latitude_dd" = 63.6594444444, "longitude_dd" = 19.9786470000 where "site_id" = 203;
        update "public"."tbl_sites" set "latitude_dd" = 63.2226500000, "longitude_dd" = 18.0569330000 where "site_id" = 209;
        update "public"."tbl_sites" set "latitude_dd" = 59.3774777781, "longitude_dd" = 15.6313890000 where "site_id" = 213;
        update "public"."tbl_sites" set "latitude_dd" = 58.3846361108, "longitude_dd" = 13.8942830000 where "site_id" = 241;
        update "public"."tbl_sites" set "latitude_dd" = 61.3833333330, "longitude_dd" = 11.5238890000 where "site_id" = 243;
        update "public"."tbl_sites" set "latitude_dd" = 63.3916190000, "longitude_dd" = 19.2470690000 where "site_id" = 254;
        update "public"."tbl_sites" set "latitude_dd" = 55.5647222222, "longitude_dd" = 12.9733330000 where "site_id" = 257;
        update "public"."tbl_sites" set "latitude_dd" = 59.5261110000, "longitude_dd" = 18.9977780000 where "site_id" = 258;
        update "public"."tbl_sites" set "latitude_dd" = 55.7500000000, "longitude_dd" = 13.0000000000 where "site_id" = 262;
        update "public"."tbl_sites" set "latitude_dd" = 59.5927222219, "longitude_dd" = 16.4485110000 where "site_id" = 268;
        update "public"."tbl_sites" set "latitude_dd" = 55.5549100000, "longitude_dd" = 12.9971000000 where "site_id" = 278;
        update "public"."tbl_sites" set "latitude_dd" = 66.0204310000, "longitude_dd" = 22.6298390000 where "site_id" = 288;
        update "public"."tbl_sites" set "latitude_dd" = 59.5347220000, "longitude_dd" = 18.5644440000 where "site_id" = 289;
        update "public"."tbl_sites" set "latitude_dd" = 65.9296833337, "longitude_dd" = 22.8561527000 where "site_id" = 291;
        update "public"."tbl_sites" set "latitude_dd" = 66.0250170000, "longitude_dd" = 22.6166670000 where "site_id" = 292;
        update "public"."tbl_sites" set "latitude_dd" = 65.9783861114, "longitude_dd" = 19.1512030000 where "site_id" = 294;
        update "public"."tbl_sites" set "latitude_dd" = 59.6830555559, "longitude_dd" = 18.9266670000 where "site_id" = 305;
        update "public"."tbl_sites" set "latitude_dd" = 59.5152777778, "longitude_dd" = 18.7777780000 where "site_id" = 320;
        update "public"."tbl_sites" set "latitude_dd" = 59.6732250000, "longitude_dd" = 17.8628360000 where "site_id" = 328;
        update "public"."tbl_sites" set "latitude_dd" = 58.3914190000, "longitude_dd" = 11.7564390000 where "site_id" = 334;
        update "public"."tbl_sites" set "latitude_dd" = 59.6973220000, "longitude_dd" = 18.4795030000 where "site_id" = 337;
        update "public"."tbl_sites" set "latitude_dd" = 61.1331666670, "longitude_dd" = 16.9196920000 where "site_id" = 345;
        update "public"."tbl_sites" set "latitude_dd" = 59.5775000000, "longitude_dd" = 18.9636110000 where "site_id" = 350;
        update "public"."tbl_sites" set "latitude_dd" = 58.7519720000, "longitude_dd" = 17.0113527780 where "site_id" = 354;
        update "public"."tbl_sites" set "latitude_dd" = 59.6833333330, "longitude_dd" = 18.9552780000 where "site_id" = 358;
        update "public"."tbl_sites" set "latitude_dd" = 59.7014100000, "longitude_dd" = 16.4985500000 where "site_id" = 369;
        update "public"."tbl_sites" set "latitude_dd" = 62.5760694448, "longitude_dd" = 12.5677750000 where "site_id" = 373;
        update "public"."tbl_sites" set "latitude_dd" = 59.5655555556, "longitude_dd" = 18.9725000000 where "site_id" = 374;
        update "public"."tbl_sites" set "latitude_dd" = 58.6117388889, "longitude_dd" = 11.4540140000 where "site_id" = 378;
        update "public"."tbl_sites" set "latitude_dd" = 66.0217560000, "longitude_dd" = 22.6267110000 where "site_id" = 384;
        update "public"."tbl_sites" set "latitude_dd" = 64.9952583000, "longitude_dd" = 21.3126555555 where "site_id" = 386;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
