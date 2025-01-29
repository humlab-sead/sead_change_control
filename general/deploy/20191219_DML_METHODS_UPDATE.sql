-- Deploy general: 20191219_DML_METHODS_UPDATE

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-12-19
  Description   Methods updates
  Issue         https://github.com/humlab-sead/sead_change_control/issues/34
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

        update tbl_methods set record_type_id = 0 where record_type_id is NULL;

        update tbl_methods set record_type_id = 11 where method_id in (100, 101, 97, 98) and record_type_id <> 11;
        update tbl_methods set record_type_id = 12 where method_id in (106, 32, 33, 35, 36, 37, 74, 94) and record_type_id <> 12;
        update tbl_methods
            set record_type_id = 19
        where method_id in (
            127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 159, 163, 38, 39
        ) and record_type_id <> 19;

        create temp table temp_method_updates as
            with updated_data ("method_id", "description", "method_abbrev_or_alt_name", "method_group_id", "method_name", "record_type_id", "unit_id") as (values
                (102, 'Rikets höjdsystem 1970. Swedish national altitude system 1970.', 'RH70', '17', 'Rikets höjdsystem 1970', NULL, '1'),
                (103, 'Rikets koordinatsystem RT90 5 gon V', 'RT90 5 gon V', '17', 'RT90 5 gon V', NULL, '4'),
                (104, 'Qualitative soil horizon classifications used by MAL. Derived from: Troedsson, Tryggve & Nykvist, Nils (1973). Marklära och markvård. Stockholm: Almqvist & Wiksell', 'MAL soil horizons', '18', 'MAL soil horizon classifications', '11', NULL),
                (105, 'Site-specific grid or unknown site or sampling grid or coordinate system.', 'Local or unknown grid', '17', 'Local or unknown grid', NULL, '1'),
                (106, 'Bartington MS2 & MS2D', 'MS Loop', '2', 'MS loop', '10', NULL),
                (107, 'Conductivity in µS (H2O)', 'µS (H2O)', '2', 'Conductivity µS (H2O)', '12', NULL),
                (108, 'Göteborgs kommuns koordinatsystem. Gothenburg municipality coordinate system.', 'Göteborgs kommuns koordinatsystem', '17', 'Göteborgs kommuns koordinatsystem', NULL, '1'),
                (109, 'Acidity (pH)', 'pH', '2', 'pH (H2O)', '12', NULL),
                (110, 'Acidity (pH) (KCl 0,1M)', 'pH (KCl 0,1M)', '2', 'pH (KCl 0,1M)', '12', NULL),
                (111, 'Plant macrofossil amount quantified by absolute volume', 'Plant macros (volume)', '1', 'Plant macros (volume)', '2', '14'),
                (112, 'Preparation method: Sieving through 600µ seive (retaining seive contents)', 'Sieving 600µ', '16', 'Sieving 600µ', NULL, '2'),
                (113, 'Malmö stads koordinatnät. Malmä city coordinate system. In use until 2008-01-01', 'Malmö stads koordinatnät', '17', 'Malmö stads koordinatnät', NULL, NULL),
                (114, 'Global coordinate system zone UTM 32 in WGS84 system. Last Revised: June 2, 1995 Area: World - N hemisphere - 6°E to 12°E - by country', 'WGS84 UTM 32', '17', 'WGS84 UTM zone 32', NULL, '4'),
                (115, 'Depth from surface lower sample boundary (depth is positive)', 'Depth lower (from surface)', '17', 'Depth from surface lower sample boundary', NULL, '1'),
                (116, 'Depth from ground surface to upper sample boundary (depth is positive)', 'Depth upper (from ground surface)', '17', 'Depth surface to upper sample boundary', NULL, '1'),
                (122, 'Depth from ground surface to lower sample boundary (depth is positive)', 'Depth lower (from ground surface)', '17', 'Depth surface to lower sample boundary', NULL, '1'),
                (123, 'Official geodetic datum (reference system/projection) of Norway. UTM zone U32. EUREF89. https://www.kartverket.no/Posisjonstjenester/Kartprojeksjoner/', 'EUREF89 UTM U32', '17', 'EUREF89 UTM U32', NULL, NULL),
                (124, 'Preparation method: Sieving through 1.25mm seive (retaining seive contents)', 'Sieving 1.25mm', '16', 'Sieving 1.25mm', NULL, '2'),
                (125, 'Upper sample boundary positive', 'Upper sample boundary (positive depth)', '17', 'Upper sample boundary (positive depth)', NULL, '1'),
                (126, 'Lower sample boundary depth positive', 'Lower sample boundary (positive depth)', '17', 'Lower sample boundary (positive depth)', NULL, '1'),
                (120, 'WGS84 UTM zone 33N', 'WGS84 UTM 33N', '17', 'WGS84 UTM zone 33N', NULL, '4')
            )  select "method_id"::int, "description", "method_abbrev_or_alt_name", "method_group_id"::int, "method_name", "record_type_id"::int, "unit_id"::int
			  from updated_data;

        update tbl_methods
            set "description" = temp_method_updates."description",
            from temp_method_updates
            where tbl_methods."method_id" = temp_method_updates."method_id" and tbl_methods."description" <> temp_method_updates."description";

        update tbl_methods
            set "method_abbrev_or_alt_name" = temp_method_updates."method_abbrev_or_alt_name",
            from temp_method_updates
            where tbl_methods."method_id" = temp_method_updates."method_id" and tbl_methods."method_abbrev_or_alt_name" <> temp_method_updates."method_abbrev_or_alt_name";

        update tbl_methods
            set "method_group_id" = temp_method_updates."method_group_id",
            from temp_method_updates
            where tbl_methods."method_id" = temp_method_updates."method_id" and tbl_methods."method_group_id" <> temp_method_updates."method_group_id";

        update tbl_methods
            set "method_name" = temp_method_updates."method_name",
            from temp_method_updates
            where tbl_methods."method_id" = temp_method_updates."method_id" and tbl_methods."method_name" <> temp_method_updates."method_name";

        update tbl_methods
            set "record_type_id" = temp_method_updates."record_type_id",
            from temp_method_updates
            where tbl_methods."method_id" = temp_method_updates."method_id" and tbl_methods."record_type_id" <> temp_method_updates."record_type_id";

        update tbl_methods
            set "unit_id" = temp_method_updates."unit_id",
            from temp_method_updates
            where tbl_methods."method_id" = temp_method_updates."method_id" and tbl_methods."unit_id" <> temp_method_updates."unit_id";
        

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
