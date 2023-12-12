-- Deploy sead_api: 20170810_DDL_DATAARC_DATASRC_API

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2017-08-10
  Description   These view selects and formats data
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

        -- create extension tablefunc;

        raise notice 'DATAARC API has been deprecated';
        raise exception SQLSTATE 'GUARD';

        -- if sead_utility.view_exists('public'::text, 'sead_utility'::text, 'column_name'::text) = TRUE then
        --     raise exception SQLSTATE 'GUARD';
        -- end if;

        drop view if exists sead_utility.ecocode_dating_geojson;
        drop view if exists sead_utility.ecocode_dating;
        drop view if exists sead_utility.physical_sample_dating;
        drop view if exists sead_utility.ecocode_pivot_abundance;
        drop materialized view if exists sead_utility.physical_sample_ecocode_abundance;
        drop function if exists sead_utility.crosstab_ecocode(text);
        drop type if exists sead_utility.ecocode_crosstab_cols;


        -- set client_min_messages = warning;
        -- set plpgsql.extra_warnings to 'shadowed_variables';

        -- create type sead_utility.ecocode_crosstab_cols as (
        --     "physical_sample_id" integer,
        --     "aquatics" integer,
        --     "Indicators: Standing water" integer,
        --     "Indicators: Running water" integer,
        --     "Pasture/Dung" integer,
        --     "meadowland" integer,
        --     "Wood and trees" integer,
        --     "Indicators: Deciduous" integer,
        --     "Indicators: Coniferous" integer,
        --     "Wetlands/marshes" integer,
        --     "Open wet habitats" integer,
        --     "Disturbed/arable" integer,
        --     "Sandy/dry disturbed/arable" integer,
        --     "Dung/foul habitats" integer,
        --     "carrion" integer,
        --     "Indicators: Dung" integer,
        --     "Mould beetles" integer,
        --     "General synanthropic" integer,
        --     "Stored grain pest" integer,
        --     "Dry dead wood" integer,
        --     "Heathland & moorland" integer,
        --     "halotolerant" integer,
        --     "ectoparasite" integer
        -- );


        -- create function sead_utility.crosstab_ecocode(text) returns setof sead_utility.ecocode_crosstab_cols
        --     language c stable strict
        --     as '$libdir/tablefunc', 'crosstab';

        -- /*******************************************************************************************************************************************************************
        -- **  View    sead_utility.ecocode_pivot_abundance
        -- **  What    Returns physical samples’ abundance data for each aggregate types ‘sum’ and ‘count pivoted by ecocodes.
        -- **  Who     Phil & Roger
        -- **  Note    crosstab(text source_sql, text category_sql):
        -- **   "source_sql is a SQL statement that produces the source set of data. This statement must return one row_name column, one category column, and one value column.
        -- **    It may also have one or more "extra" columns. The row_name column must be first. The category and value columns must be the last two columns, in that order.
        -- **    Any columns between row_name and category are treated as "extra". The "extra" columns are expected to be the same for all rows with the same row_name value."
        -- **   "category_sql is a SQL statement that produces the set of categories. This statement must return only one column. It must produce at least one row, or an
        -- **    error will be generated. Also, it must not produce duplicate values, or an error will be generated."
        -- ********************************************************************************************************************************************************************/

        -- create view sead_utility.ecocode_pivot_abundance as
        --  select 'sum'::text as agg_type,
        --     crosstab_ecocode.physical_sample_id,
        --     crosstab_ecocode.aquatics,
        --     crosstab_ecocode."Indicators: Standing water",
        --     crosstab_ecocode."Indicators: Running water",
        --     crosstab_ecocode."Pasture/Dung",
        --     crosstab_ecocode.meadowland,
        --     crosstab_ecocode."Wood and trees",
        --     crosstab_ecocode."Indicators: Deciduous",
        --     crosstab_ecocode."Indicators: Coniferous",
        --     crosstab_ecocode."Wetlands/marshes",
        --     crosstab_ecocode."Open wet habitats",
        --     crosstab_ecocode."Disturbed/arable",
        --     crosstab_ecocode."Sandy/dry disturbed/arable",
        --     crosstab_ecocode."Dung/foul habitats",
        --     crosstab_ecocode.carrion,
        --     crosstab_ecocode."Indicators: Dung",
        --     crosstab_ecocode."Mould beetles",
        --     crosstab_ecocode."General synanthropic",
        --     crosstab_ecocode."Stored grain pest",
        --     crosstab_ecocode."Dry dead wood",
        --     crosstab_ecocode."Heathland & moorland",
        --     crosstab_ecocode.halotolerant,
        --     crosstab_ecocode.ectoparasite
        --    from sead_utility.crosstab_ecocode('select physical_sample_id, ecocode_name::text, abundance_sum::int as abundance from sead_utility.physical_sample_ecocode_abundance order by 1, 2'::text) crosstab_ecocode(physical_sample_id, aquatics, "Indicators: Standing water", "Indicators: Running water", "Pasture/Dung", meadowland, "Wood and trees", "Indicators: Deciduous", "Indicators: Coniferous", "Wetlands/marshes", "Open wet habitats", "Disturbed/arable", "Sandy/dry disturbed/arable", "Dung/foul habitats", carrion, "Indicators: Dung", "Mould beetles", "General synanthropic", "Stored grain pest", "Dry dead wood", "Heathland & moorland", halotolerant, ectoparasite)
        -- union
        --  select 'count'::text as agg_type,
        --     crosstab_ecocode.physical_sample_id,
        --     crosstab_ecocode.aquatics,
        --     crosstab_ecocode."Indicators: Standing water",
        --     crosstab_ecocode."Indicators: Running water",
        --     crosstab_ecocode."Pasture/Dung",
        --     crosstab_ecocode.meadowland,
        --     crosstab_ecocode."Wood and trees",
        --     crosstab_ecocode."Indicators: Deciduous",
        --     crosstab_ecocode."Indicators: Coniferous",
        --     crosstab_ecocode."Wetlands/marshes",
        --     crosstab_ecocode."Open wet habitats",
        --     crosstab_ecocode."Disturbed/arable",
        --     crosstab_ecocode."Sandy/dry disturbed/arable",
        --     crosstab_ecocode."Dung/foul habitats",
        --     crosstab_ecocode.carrion,
        --     crosstab_ecocode."Indicators: Dung",
        --     crosstab_ecocode."Mould beetles",
        --     crosstab_ecocode."General synanthropic",
        --     crosstab_ecocode."Stored grain pest",
        --     crosstab_ecocode."Dry dead wood",
        --     crosstab_ecocode."Heathland & moorland",
        --     crosstab_ecocode.halotolerant,
        --     crosstab_ecocode.ectoparasite
        --    from sead_utility.crosstab_ecocode('select physical_sample_id, ecocode_name::text, abundance_count::int as abundance from sead_utility.physical_sample_ecocode_abundance order by 1, 2'::text) crosstab_ecocode(physical_sample_id, aquatics, "Indicators: Standing water", "Indicators: Running water", "Pasture/Dung", meadowland, "Wood and trees", "Indicators: Deciduous", "Indicators: Coniferous", "Wetlands/marshes", "Open wet habitats", "Disturbed/arable", "Sandy/dry disturbed/arable", "Dung/foul habitats", carrion, "Indicators: Dung", "Mould beetles", "General synanthropic", "Stored grain pest", "Dry dead wood", "Heathland & moorland", halotolerant, ectoparasite);

        -- /***************************************************************************************
        -- **  View    sead_utility.physical_sample_dating
        -- **  What    Helper view used in ecocode GeoJSON export
        -- **          compiles dating analysis data for each physical sample.
        -- **  Who     Phil & Roger
        -- ****************************************************************************************/

        -- create view sead_utility.physical_sample_dating as
        --  with abundance_analysis as (
        --          select ae.physical_sample_id
        --            from ((public.tbl_analysis_entities ae
        --              join public.tbl_abundances ab_1 on ((ab_1.analysis_entity_id = ae.analysis_entity_id)))
        --              join public.tbl_taxa_tree_master tm on ((tm.taxon_id = ab_1.taxon_id)))
        --           group by ae.physical_sample_id
        --         ), dating as (
        --          select a.physical_sample_id,
        --             1 as dating_type,
        --             aea.age_older,
        --             aea.age_younger,
        --             null::character varying as age_name,
        --             null::character varying as age_abbreviation
        --            from (public.tbl_analysis_entities a
        --              join public.tbl_analysis_entity_ages aea on ((aea.analysis_entity_id = a.analysis_entity_id)))
        --           group by a.physical_sample_id, aea.age_older, aea.age_younger
        --         union
        --          select ae.physical_sample_id,
        --             2 as dating_type,
        --             ra.cal_age_older as age_older,
        --             ra.cal_age_younger as age_younger,
        --             ra.relative_age_name as age_name,
        --             ra.abbreviation as age_abbreviation
        --            from ((public.tbl_analysis_entities ae
        --              join public.tbl_relative_dates rd on ((rd.analysis_entity_id = ae.analysis_entity_id)))
        --              join public.tbl_relative_ages ra on ((rd.relative_age_id = ra.relative_age_id)))
        --           group by ae.physical_sample_id, 2::integer, ra.cal_age_older, ra.cal_age_younger, ra.relative_age_name, ra.abbreviation
        --         ), site_location as (
        --          select s.site_id,
        --             s.site_name,
        --             s.latitude_dd,
        --             s.longitude_dd,
        --             sg.sample_group_id,
        --             l.location_type_id,
        --             l.location_name
        --            from ((((public.tbl_sample_groups sg
        --              join public.tbl_sites s on ((s.site_id = sg.site_id)))
        --              join public.tbl_site_locations sl_1 on ((sl_1.site_id = s.site_id)))
        --              join public.tbl_locations l on ((l.location_id = sl_1.location_id)))
        --              join public.tbl_location_types lt on ((lt.location_type_id = l.location_type_id)))
        --           where (not ((s.latitude_dd is null) or (s.longitude_dd is null)))
        --           group by s.site_id, s.site_name, s.latitude_dd, s.longitude_dd, sg.sample_group_id, l.location_type_id, l.location_name
        --         )
        --  select sl.location_name,
        --     sl.site_id,
        --     sl.site_name,
        --     sl.latitude_dd,
        --     sl.longitude_dd,
        --     ps.physical_sample_id,
        --     d.dating_type,
        --     d.age_older,
        --     d.age_younger,
        --     d.age_name,
        --     d.age_abbreviation
        --    from (((public.tbl_physical_samples ps
        --      join site_location sl on ((sl.sample_group_id = ps.sample_group_id)))
        --      join abundance_analysis ab on ((ab.physical_sample_id = ps.physical_sample_id)))
        --      left join dating d on ((d.physical_sample_id = ps.physical_sample_id)))
        --   where (sl.location_type_id = 1);

        -- /***************************************************************************************
        -- **  View    sead_utility.ecocode_dating
        -- **  What    Returns compiled result for ecocode dating export.
        -- **  Who     Phil & Roger
        -- ****************************************************************************************/

        -- create view sead_utility.ecocode_dating as
        --  select a.physical_sample_id,
        --     a.agg_type,
        --     a.aquatics,
        --     a."Indicators: Standing water",
        --     a."Indicators: Running water",
        --     a."Pasture/Dung",
        --     a.meadowland,
        --     a."Wood and trees",
        --     a."Indicators: Deciduous",
        --     a."Indicators: Coniferous",
        --     a."Wetlands/marshes",
        --     a."Open wet habitats",
        --     a."Disturbed/arable",
        --     a."Sandy/dry disturbed/arable",
        --     a."Dung/foul habitats",
        --     a.carrion,
        --     a."Indicators: Dung",
        --     a."Mould beetles",
        --     a."General synanthropic",
        --     a."Stored grain pest",
        --     a."Dry dead wood",
        --     a."Heathland & moorland",
        --     a.halotolerant,
        --     a.ectoparasite,
        --     d.location_name,
        --     d.site_id,
        --     d.site_name,
        --     d.latitude_dd,
        --     d.longitude_dd,
        --     d.dating_type,
        --     d.age_older,
        --     d.age_younger,
        --     d.age_name,
        --     d.age_abbreviation,
        --     ps.sample_group_id,
        --     ps.alt_ref_type_id,
        --     ps.sample_type_id,
        --     ps.sample_name,
        --     ps.date_updated,
        --     ps.date_sampled
        --   from ((sead_utility.ecocode_pivot_abundance a
        --   join sead_utility.physical_sample_dating d USING (physical_sample_id))
        --   join public.tbl_physical_samples ps USING (physical_sample_id));

        -- /***************************************************************************************
        -- **  View    sead_utility.ecocode_dating_geojson
        -- **  What    Returns GeoJSON objects for each aggregate type (sum and count) from data returned by VIEW ecocode_dating
        -- **  Who     Phil & Roger
        -- ****************************************************************************************/

        -- create view sead_utility.ecocode_dating_geojson as
        --  select ecocode_dating.agg_type,
        --     json_build_object('type', 'FeatureCollection', 'features', json_agg(json_build_object('type', 'Feature', 'id', ecocode_dating.physical_sample_id, 'geometry', json_build_object('type', 'Point', 'coordinates', json_build_array(ecocode_dating.longitude_dd, ecocode_dating.latitude_dd)), 'properties', json_build_object('id', ecocode_dating.physical_sample_id, 'country', ecocode_dating.location_name, 'sampleData', json_build_object('site_id', ecocode_dating.site_id, 'site_name', ecocode_dating.site_name, 'sample_name', ecocode_dating.sample_name, 'sample_group_id', ecocode_dating.sample_group_id, 'dating_type', (ARRAY['Calibrated radiocarbon dates'::text, 'Relative dates'::text])[ecocode_dating.dating_type], 'start', ecocode_dating.age_older, 'end', ecocode_dating.age_younger, 'age_name', ecocode_dating.age_name, 'age_abbreviation', ecocode_dating.age_abbreviation), 'indicators', json_build_object('Aquatics', ecocode_dating.aquatics, 'Indicators: Standing water', ecocode_dating."Indicators: Standing water", 'Indicators: Running water', ecocode_dating."Indicators: Running water", 'Pasture/Dung', ecocode_dating."Pasture/Dung", 'Meadowland', ecocode_dating.meadowland, 'Wood and trees', ecocode_dating."Wood and trees", 'Indicators: Deciduous', ecocode_dating."Indicators: Deciduous", 'Indicators: Coniferous', ecocode_dating."Indicators: Coniferous", 'Wetlands/marshes', ecocode_dating."Wetlands/marshes", 'Open wet habitats', ecocode_dating."Open wet habitats", 'Disturbed/arable', ecocode_dating."Disturbed/arable", 'Sandy/dry disturbed/arable', ecocode_dating."Sandy/dry disturbed/arable", 'Dung/foul habitats', ecocode_dating."Dung/foul habitats", 'Carrion', ecocode_dating.carrion, 'Indicators: Dung', ecocode_dating."Indicators: Dung", 'Mould beetles', ecocode_dating."Mould beetles", 'General synanthropic', ecocode_dating."General synanthropic", 'Stored grain pest', ecocode_dating."Stored grain pest", 'Dry dead wood', ecocode_dating."Dry dead wood", 'Heathland & moorland', ecocode_dating."Heathland & moorland", 'Halotolerant', ecocode_dating.halotolerant, 'Ectoparasite', ecocode_dating.ectoparasite))))) AS ecocode_json
        --  from sead_utility.ecocode_dating
        --  group by ecocode_dating.agg_type;

        -- /***************************************************************************************
        -- **  View    sead_utility.physical_sample_ecocode_abundance
        -- **  What    Helper view used in ecocode GeoJSON export of ecocodes
        -- **  Who     Phil & Roger
        -- **  Note    View DOES NOT automatically update when data change.
        -- **          Run
        -- **          REFRESH MATERIALIZED VIEW sead_utility.physical_sample_ecocode_abundance
        -- ****************************************************************************************/

        -- create materialized view sead_utility.physical_sample_ecocode_abundance as
        --  select ps.physical_sample_id,
        --     ed.name as ecocode_name,
        --     sum(ab.abundance) as abundance_sum,
        --     count(ab.abundance) as abundance_count
        --    from ((((((public.tbl_analysis_entities ae
        --      join public.tbl_physical_samples ps on ((ps.physical_sample_id = ae.physical_sample_id)))
        --      join public.tbl_abundances ab on ((ab.analysis_entity_id = ae.analysis_entity_id)))
        --      join public.tbl_taxa_tree_master tm on ((tm.taxon_id = ab.taxon_id)))
        --      join public.tbl_ecocodes e on ((tm.taxon_id = e.taxon_id)))
        --      join public.tbl_ecocode_definitions ed on ((e.ecocode_definition_id = ed.ecocode_definition_id)))
        --      join public.tbl_ecocode_groups eg on ((eg.ecocode_group_id = ed.ecocode_group_id)))
        --     where eg.ecocode_system_id = 2
        --   group by ps.physical_sample_id, ed.name
        --   with no data;

        -- create unique index idx_physical_sample_ecocode_abundance on sead_utility.physical_sample_ecocode_abundance using btree (physical_sample_id, ecocode_name);

        -- refresh materialized view sead_utility.physical_sample_ecocode_abundance;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
