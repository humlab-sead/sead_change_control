-- Deploy sead_change_control:20191219_DML_METHODS_UPDATE to pg

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

        --if sead_utility.column_exists('public'::text, 'table_name'::text, 'column_name'::text) = TRUE then
        --    raise exception SQLSTATE 'GUARD';
        --end if;

        update tbl_methods set record_type_id = 12 where method_id = 74;
        update tbl_methods set record_type_id = 12 where method_id = 94;
        update tbl_methods set record_type_id = 12 where method_id = 32;
        update tbl_methods set record_type_id = 12 where method_id = 33;
        update tbl_methods set record_type_id = 12 where method_id = 35;
        update tbl_methods set record_type_id = 12 where method_id = 36;
        update tbl_methods set record_type_id = 19 where method_id = 38;
        update tbl_methods set record_type_id = 19 where method_id = 39;
        update tbl_methods set record_type_id = 12 where method_id = 37;
        update tbl_methods set record_type_id = 12 where method_id = 106;
        update tbl_methods set record_type_id = 19 where method_id = 151;
        update tbl_methods set record_type_id = 11 where method_id = 97;
        update tbl_methods set record_type_id = 11 where method_id = 100;
        update tbl_methods set record_type_id = 11 where method_id = 98;
        update tbl_methods set record_type_id = 11 where method_id = 101;
        update tbl_methods set record_type_id = 19 where method_id = 154;
        update tbl_methods set record_type_id = 19 where method_id = 127;
        update tbl_methods set record_type_id = 19 where method_id = 128;
        update tbl_methods set record_type_id = 19 where method_id = 129;
        update tbl_methods set record_type_id = 19 where method_id = 130;
        update tbl_methods set record_type_id = 19 where method_id = 131;
        update tbl_methods set record_type_id = 19 where method_id = 132;
        update tbl_methods set record_type_id = 19 where method_id = 133;
        update tbl_methods set record_type_id = 19 where method_id = 134;
        update tbl_methods set record_type_id = 19 where method_id = 135;
        update tbl_methods set record_type_id = 19 where method_id = 136;
        update tbl_methods set record_type_id = 19 where method_id = 137;
        update tbl_methods set record_type_id = 19 where method_id = 138;
        update tbl_methods set record_type_id = 19 where method_id = 139;
        update tbl_methods set record_type_id = 19 where method_id = 140;
        update tbl_methods set record_type_id = 19 where method_id = 141;
        update tbl_methods set record_type_id = 19 where method_id = 142;
        update tbl_methods set record_type_id = 19 where method_id = 143;
        update tbl_methods set record_type_id = 19 where method_id = 144;
        update tbl_methods set record_type_id = 19 where method_id = 145;
        update tbl_methods set record_type_id = 19 where method_id = 146;
        update tbl_methods set record_type_id = 19 where method_id = 147;
        update tbl_methods set record_type_id = 19 where method_id = 148;
        update tbl_methods set record_type_id = 19 where method_id = 149;
        update tbl_methods set record_type_id = 19 where method_id = 152;
        update tbl_methods set record_type_id = 19 where method_id = 153;
        update tbl_methods set record_type_id = 19 where method_id = 155;
        update tbl_methods set record_type_id = 19 where method_id = 156;
        update tbl_methods set record_type_id = 19 where method_id = 150;
        update tbl_methods set record_type_id = 19 where method_id = 159;
        update tbl_methods set record_type_id = 19 where method_id = 163;

        update tbl_methods set record_type_id = 0  where record_type_id is NULL;

        update tbl_methods set description = 'Rikets höjdsystem 1970. Swedish national altitude system 1970.' where method_id = 102;
        update tbl_methods set description = 'Rikets koordinatsystem RT90 5 gon V' where method_id = 103;
        update tbl_methods set description = 'Qualitative soil horizon classifications used by MAL. Derived from: Troedsson, Tryggve & Nykvist, Nils (1973). Marklära och markvÃ¥rd. Stockholm: Almqvist & Wiksell' where method_id = 104;
        update tbl_methods set description = 'Site-specific grid or unknown site or sampling grid or coordinate system.' where method_id = 105;
        update tbl_methods set description = 'Bartington MS2 & MS2D' where method_id = 106;
        update tbl_methods set description = 'Conductivity in µS (H2O)' where method_id = 107;
        update tbl_methods set description = 'Göteborgs kommuns koordinatsystem. Gothenburg municipality coordinate system.' where method_id = 108;
        update tbl_methods set description = 'Acidity (pH)' where method_id = 109;
        update tbl_methods set description = 'Acidity (pH) (KCl 0,1M)' where method_id = 110;
        update tbl_methods set description = 'Plant macrofossil amount quantified by absolute volume' where method_id = 111;
        update tbl_methods set description = 'Preparation method: Sieving through 600µ seive (retaining seive contents)' where method_id = 112;
        update tbl_methods set description = 'Malmö stads koordinatnät. Malmä city coordinate system. In use until 2008-01-01' where method_id = 113;
        update tbl_methods set description = 'Global coordinate system zone UTM 32 in WGS84 system. Last Revised: June 2, 1995 Area: World - N hemisphere - 6°E to 12°E - by country' where method_id = 114;
        update tbl_methods set description = 'Depth from surface lower sample boundary (depth is positive)' where method_id = 115;
        update tbl_methods set description = 'Depth from ground surface to upper sample boundary (depth is positive)' where method_id = 116;
        update tbl_methods set description = 'Depth from ground surface to lower sample boundary (depth is positive)' where method_id = 122;
        update tbl_methods set description = 'Official geodetic datum (reference system/projection) of Norway. UTM zone U32. EUREF89. https://www.kartverket.no/Posisjonstjenester/Kartprojeksjoner/' where method_id = 123;
        update tbl_methods set description = 'Preparation method: Sieving through  1.25mm seive (retaining seive contents)' where method_id = 124;
        update tbl_methods set description = 'Upper sample boundary positive' where method_id = 125;
        update tbl_methods set description = 'Lower sample boundary depth positive' where method_id = 126;
        update tbl_methods set description = 'WGS84 UTM zone 33N' where method_id = 120;

        update tbl_methods set method_abbrev_or_alt_name = 'RH70' where method_id = 102;
        update tbl_methods set method_abbrev_or_alt_name = 'RT90 5 gon V' where method_id = 103;
        update tbl_methods set method_abbrev_or_alt_name = 'MAL soil horizons' where method_id = 104;
        update tbl_methods set method_abbrev_or_alt_name = 'Local or unknown grid' where method_id = 105;
        update tbl_methods set method_abbrev_or_alt_name = 'MS Loop' where method_id = 106;
        update tbl_methods set method_abbrev_or_alt_name = 'µS (H2O)' where method_id = 107;
        update tbl_methods set method_abbrev_or_alt_name = 'Göteborgs kommuns koordinatsystem' where method_id = 108;
        update tbl_methods set method_abbrev_or_alt_name = 'pH' where method_id = 109;
        update tbl_methods set method_abbrev_or_alt_name = 'pH (KCl 0,1M)' where method_id = 110;
        update tbl_methods set method_abbrev_or_alt_name = 'Plant macros (volume)' where method_id = 111;
        update tbl_methods set method_abbrev_or_alt_name = 'Sieving 600µ' where method_id = 112;
        update tbl_methods set method_abbrev_or_alt_name = 'Malmö stads koordinatnät' where method_id = 113;
        update tbl_methods set method_abbrev_or_alt_name = 'WGS84 UTM 32' where method_id = 114;
        update tbl_methods set method_abbrev_or_alt_name = 'Depth lower (from surface)' where method_id = 115;
        update tbl_methods set method_abbrev_or_alt_name = 'Depth upper (from surface)' where method_id = 116;
        update tbl_methods set method_abbrev_or_alt_name = 'Depth lower (from surface)' where method_id = 122;
        update tbl_methods set method_abbrev_or_alt_name = 'EUREF89 UTM U32 ' where method_id = 123;
        update tbl_methods set method_abbrev_or_alt_name = 'Sieving 1.25mm' where method_id = 124;
        update tbl_methods set method_abbrev_or_alt_name = 'Upper sample boundary (positive depth)' where method_id = 125;
        update tbl_methods set method_abbrev_or_alt_name = 'Lower sample boundary (positive depth)' where method_id = 126;
        update tbl_methods set method_abbrev_or_alt_name = 'WGS84 UTM 33N' where method_id = 120;

        update tbl_methods set method_abbrev_or_alt_name = 'Rikets höjdsystem 1970' where method_id = 102;
        update tbl_methods set method_abbrev_or_alt_name = 'RT90 5 gon V' where method_id = 103;
        update tbl_methods set method_abbrev_or_alt_name = 'MAL soil horizon classifications' where method_id = 104;
        update tbl_methods set method_abbrev_or_alt_name = 'Local or unknown grid' where method_id = 105;
        update tbl_methods set method_abbrev_or_alt_name = 'MS loop' where method_id = 106;
        update tbl_methods set method_abbrev_or_alt_name = 'Conductivity µS (H2O)' where method_id = 107;
        update tbl_methods set method_abbrev_or_alt_name = 'Göteborgs kommuns koordinatsystem' where method_id = 108;
        update tbl_methods set method_abbrev_or_alt_name = 'pH (H2O)' where method_id = 109;
        update tbl_methods set method_abbrev_or_alt_name = 'pH (KCl 0,1M)' where method_id = 110;
        update tbl_methods set method_abbrev_or_alt_name = 'Plant macros (volume)' where method_id = 111;
        update tbl_methods set method_abbrev_or_alt_name = 'Sieving 600µ' where method_id = 112;
        update tbl_methods set method_abbrev_or_alt_name = 'Malmö stads koordinatnät' where method_id = 113;
        update tbl_methods set method_abbrev_or_alt_name = 'WGS84 UTM zone 32' where method_id = 114;
        update tbl_methods set method_abbrev_or_alt_name = 'Depth from surface lower sample boundary' where method_id = 115;
        update tbl_methods set method_abbrev_or_alt_name = 'Depth surface to upper sample boundary' where method_id = 116;
        update tbl_methods set method_abbrev_or_alt_name = 'Depth surface to lower sample boundary' where method_id = 122;
        update tbl_methods set method_abbrev_or_alt_name = 'EUREF89 UTM U32 ' where method_id = 123;
        update tbl_methods set method_abbrev_or_alt_name = 'Sieving 1.25mm' where method_id = 124;
        update tbl_methods set method_abbrev_or_alt_name = 'Upper sample boundary (positive depth)' where method_id = 125;
        update tbl_methods set method_abbrev_or_alt_name = 'Lower sample boundary (positive depth)' where method_id = 126;
        update tbl_methods set method_abbrev_or_alt_name = 'WGS84 UTM zone 33N' where method_id = 120;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
