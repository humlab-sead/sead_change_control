--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.21
-- Dumped by pg_dump version 9.6.11

-- Started on 2019-04-12 14:15:27 CEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 13 (class 2615 OID 71187)
-- Name: humlab_utility; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA humlab_utility;


--
-- TOC entry 2356 (class 1247 OID 71778)
-- Name: ecocode_crosstab_cols; Type: TYPE; Schema: humlab_utility; Owner: -
--

CREATE TYPE humlab_utility.ecocode_crosstab_cols AS (
	physical_sample_id integer,
	aquatics integer,
	"Indicators: Standing water" integer,
	"Indicators: Running water" integer,
	"Pasture/Dung" integer,
	meadowland integer,
	"Wood and trees" integer,
	"Indicators: Deciduous" integer,
	"Indicators: Coniferous" integer,
	"Wetlands/marshes" integer,
	"Open wet habitats" integer,
	"Disturbed/arable" integer,
	"Sandy/dry disturbed/arable" integer,
	"Dung/foul habitats" integer,
	carrion integer,
	"Indicators: Dung" integer,
	"Mould beetles" integer,
	"General synanthropic" integer,
	"Stored grain pest" integer,
	"Dry dead wood" integer,
	"Heathland & moorland" integer,
	halotolerant integer,
	ectoparasite integer
);


--
-- TOC entry 872 (class 1255 OID 71779)
-- Name: crosstab_ecocode(text); Type: FUNCTION; Schema: humlab_utility; Owner: -
--

CREATE FUNCTION humlab_utility.crosstab_ecocode(text) RETURNS SETOF humlab_utility.ecocode_crosstab_cols
    LANGUAGE c STABLE STRICT
    AS '$libdir/tablefunc', 'crosstab';


--
-- TOC entry 703 (class 1259 OID 71786)
-- Name: ecocode_pivot_abundance; Type: VIEW; Schema: humlab_utility; Owner: -
--

CREATE VIEW humlab_utility.ecocode_pivot_abundance AS
 SELECT 'sum'::text AS agg_type,
    crosstab_ecocode.physical_sample_id,
    crosstab_ecocode.aquatics,
    crosstab_ecocode."Indicators: Standing water",
    crosstab_ecocode."Indicators: Running water",
    crosstab_ecocode."Pasture/Dung",
    crosstab_ecocode.meadowland,
    crosstab_ecocode."Wood and trees",
    crosstab_ecocode."Indicators: Deciduous",
    crosstab_ecocode."Indicators: Coniferous",
    crosstab_ecocode."Wetlands/marshes",
    crosstab_ecocode."Open wet habitats",
    crosstab_ecocode."Disturbed/arable",
    crosstab_ecocode."Sandy/dry disturbed/arable",
    crosstab_ecocode."Dung/foul habitats",
    crosstab_ecocode.carrion,
    crosstab_ecocode."Indicators: Dung",
    crosstab_ecocode."Mould beetles",
    crosstab_ecocode."General synanthropic",
    crosstab_ecocode."Stored grain pest",
    crosstab_ecocode."Dry dead wood",
    crosstab_ecocode."Heathland & moorland",
    crosstab_ecocode.halotolerant,
    crosstab_ecocode.ectoparasite
   FROM humlab_utility.crosstab_ecocode('SELECT physical_sample_id, ecocode_name::text, abundance_sum::int as abundance FROM humlab_utility.physical_sample_ecocode_abundance'::text) crosstab_ecocode(physical_sample_id, aquatics, "Indicators: Standing water", "Indicators: Running water", "Pasture/Dung", meadowland, "Wood and trees", "Indicators: Deciduous", "Indicators: Coniferous", "Wetlands/marshes", "Open wet habitats", "Disturbed/arable", "Sandy/dry disturbed/arable", "Dung/foul habitats", carrion, "Indicators: Dung", "Mould beetles", "General synanthropic", "Stored grain pest", "Dry dead wood", "Heathland & moorland", halotolerant, ectoparasite)
UNION
 SELECT 'count'::text AS agg_type,
    crosstab_ecocode.physical_sample_id,
    crosstab_ecocode.aquatics,
    crosstab_ecocode."Indicators: Standing water",
    crosstab_ecocode."Indicators: Running water",
    crosstab_ecocode."Pasture/Dung",
    crosstab_ecocode.meadowland,
    crosstab_ecocode."Wood and trees",
    crosstab_ecocode."Indicators: Deciduous",
    crosstab_ecocode."Indicators: Coniferous",
    crosstab_ecocode."Wetlands/marshes",
    crosstab_ecocode."Open wet habitats",
    crosstab_ecocode."Disturbed/arable",
    crosstab_ecocode."Sandy/dry disturbed/arable",
    crosstab_ecocode."Dung/foul habitats",
    crosstab_ecocode.carrion,
    crosstab_ecocode."Indicators: Dung",
    crosstab_ecocode."Mould beetles",
    crosstab_ecocode."General synanthropic",
    crosstab_ecocode."Stored grain pest",
    crosstab_ecocode."Dry dead wood",
    crosstab_ecocode."Heathland & moorland",
    crosstab_ecocode.halotolerant,
    crosstab_ecocode.ectoparasite
   FROM humlab_utility.crosstab_ecocode('SELECT physical_sample_id, ecocode_name::text, abundance_count::int as abundance FROM humlab_utility.physical_sample_ecocode_abundance'::text) crosstab_ecocode(physical_sample_id, aquatics, "Indicators: Standing water", "Indicators: Running water", "Pasture/Dung", meadowland, "Wood and trees", "Indicators: Deciduous", "Indicators: Coniferous", "Wetlands/marshes", "Open wet habitats", "Disturbed/arable", "Sandy/dry disturbed/arable", "Dung/foul habitats", carrion, "Indicators: Dung", "Mould beetles", "General synanthropic", "Stored grain pest", "Dry dead wood", "Heathland & moorland", halotolerant, ectoparasite);


--
-- TOC entry 704 (class 1259 OID 71791)
-- Name: physical_sample_dating; Type: VIEW; Schema: humlab_utility; Owner: -
--

CREATE VIEW humlab_utility.physical_sample_dating AS
 WITH abundance_analysis AS (
         SELECT ae.physical_sample_id
           FROM ((public.tbl_analysis_entities ae
             JOIN public.tbl_abundances ab_1 ON ((ab_1.analysis_entity_id = ae.analysis_entity_id)))
             JOIN public.tbl_taxa_tree_master tm ON ((tm.taxon_id = ab_1.taxon_id)))
          GROUP BY ae.physical_sample_id
        ), dating AS (
         SELECT a.physical_sample_id,
            1 AS dating_type,
            aea.age_older,
            aea.age_younger,
            NULL::character varying AS age_name,
            NULL::character varying AS age_abbreviation
           FROM (public.tbl_analysis_entities a
             JOIN public.tbl_analysis_entity_ages aea ON ((aea.analysis_entity_id = a.analysis_entity_id)))
          GROUP BY a.physical_sample_id, aea.age_older, aea.age_younger
        UNION
         SELECT ae.physical_sample_id,
            2 AS dating_type,
            ra.cal_age_older AS age_older,
            ra.cal_age_younger AS age_younger,
            ra.relative_age_name AS age_name,
            ra.abbreviation AS age_abbreviation
           FROM ((public.tbl_analysis_entities ae
             JOIN public.tbl_relative_dates rd ON ((rd.analysis_entity_id = ae.analysis_entity_id)))
             JOIN public.tbl_relative_ages ra ON ((rd.relative_age_id = ra.relative_age_id)))
          GROUP BY ae.physical_sample_id, 2::integer, ra.cal_age_older, ra.cal_age_younger, ra.relative_age_name, ra.abbreviation
        ), site_location AS (
         SELECT s.site_id,
            s.site_name,
            s.latitude_dd,
            s.longitude_dd,
            sg.sample_group_id,
            l.location_type_id,
            l.location_name
           FROM ((((public.tbl_sample_groups sg
             JOIN public.tbl_sites s ON ((s.site_id = sg.site_id)))
             JOIN public.tbl_site_locations sl_1 ON ((sl_1.site_id = s.site_id)))
             JOIN public.tbl_locations l ON ((l.location_id = sl_1.location_id)))
             JOIN public.tbl_location_types lt ON ((lt.location_type_id = l.location_type_id)))
          WHERE (NOT ((s.latitude_dd IS NULL) OR (s.longitude_dd IS NULL)))
          GROUP BY s.site_id, s.site_name, s.latitude_dd, s.longitude_dd, sg.sample_group_id, l.location_type_id, l.location_name
        )
 SELECT sl.location_name,
    sl.site_id,
    sl.site_name,
    sl.latitude_dd,
    sl.longitude_dd,
    ps.physical_sample_id,
    d.dating_type,
    d.age_older,
    d.age_younger,
    d.age_name,
    d.age_abbreviation
   FROM (((public.tbl_physical_samples ps
     JOIN site_location sl ON ((sl.sample_group_id = ps.sample_group_id)))
     JOIN abundance_analysis ab ON ((ab.physical_sample_id = ps.physical_sample_id)))
     LEFT JOIN dating d ON ((d.physical_sample_id = ps.physical_sample_id)))
  WHERE (sl.location_type_id = 1);


--
-- TOC entry 705 (class 1259 OID 71796)
-- Name: ecocode_dating; Type: VIEW; Schema: humlab_utility; Owner: -
--

CREATE VIEW humlab_utility.ecocode_dating AS
 SELECT a.physical_sample_id,
    a.agg_type,
    a.aquatics,
    a."Indicators: Standing water",
    a."Indicators: Running water",
    a."Pasture/Dung",
    a.meadowland,
    a."Wood and trees",
    a."Indicators: Deciduous",
    a."Indicators: Coniferous",
    a."Wetlands/marshes",
    a."Open wet habitats",
    a."Disturbed/arable",
    a."Sandy/dry disturbed/arable",
    a."Dung/foul habitats",
    a.carrion,
    a."Indicators: Dung",
    a."Mould beetles",
    a."General synanthropic",
    a."Stored grain pest",
    a."Dry dead wood",
    a."Heathland & moorland",
    a.halotolerant,
    a.ectoparasite,
    d.location_name,
    d.site_id,
    d.site_name,
    d.latitude_dd,
    d.longitude_dd,
    d.dating_type,
    d.age_older,
    d.age_younger,
    d.age_name,
    d.age_abbreviation,
    ps.sample_group_id,
    ps.alt_ref_type_id,
    ps.sample_type_id,
    ps.sample_name,
    ps.date_updated,
    ps.date_sampled
   FROM ((humlab_utility.ecocode_pivot_abundance a
     JOIN humlab_utility.physical_sample_dating d USING (physical_sample_id))
     JOIN public.tbl_physical_samples ps USING (physical_sample_id));


--
-- TOC entry 706 (class 1259 OID 71801)
-- Name: ecocode_dating_geojson; Type: VIEW; Schema: humlab_utility; Owner: -
--

CREATE VIEW humlab_utility.ecocode_dating_geojson AS
 SELECT ecocode_dating.agg_type,
    json_build_object('type', 'FeatureCollection', 'features', json_agg(json_build_object('type', 'Feature', 'id', ecocode_dating.physical_sample_id, 'geometry', json_build_object('type', 'Point', 'coordinates', json_build_array(ecocode_dating.longitude_dd, ecocode_dating.latitude_dd)), 'properties', json_build_object('id', ecocode_dating.physical_sample_id, 'country', ecocode_dating.location_name, 'sampleData', json_build_object('site_id', ecocode_dating.site_id, 'site_name', ecocode_dating.site_name, 'sample_name', ecocode_dating.sample_name, 'sample_group_id', ecocode_dating.sample_group_id, 'dating_type', (ARRAY['Calibrated radiocarbon dates'::text, 'Relative dates'::text])[ecocode_dating.dating_type], 'start', ecocode_dating.age_older, 'end', ecocode_dating.age_younger, 'age_name', ecocode_dating.age_name, 'age_abbreviation', ecocode_dating.age_abbreviation), 'indicators', json_build_object('Aquatics', ecocode_dating.aquatics, 'Indicators: Standing water', ecocode_dating."Indicators: Standing water", 'Indicators: Running water', ecocode_dating."Indicators: Running water", 'Pasture/Dung', ecocode_dating."Pasture/Dung", 'Meadowland', ecocode_dating.meadowland, 'Wood and trees', ecocode_dating."Wood and trees", 'Indicators: Deciduous', ecocode_dating."Indicators: Deciduous", 'Indicators: Coniferous', ecocode_dating."Indicators: Coniferous", 'Wetlands/marshes', ecocode_dating."Wetlands/marshes", 'Open wet habitats', ecocode_dating."Open wet habitats", 'Disturbed/arable', ecocode_dating."Disturbed/arable", 'Sandy/dry disturbed/arable', ecocode_dating."Sandy/dry disturbed/arable", 'Dung/foul habitats', ecocode_dating."Dung/foul habitats", 'Carrion', ecocode_dating.carrion, 'Indicators: Dung', ecocode_dating."Indicators: Dung", 'Mould beetles', ecocode_dating."Mould beetles", 'General synanthropic', ecocode_dating."General synanthropic", 'Stored grain pest', ecocode_dating."Stored grain pest", 'Dry dead wood', ecocode_dating."Dry dead wood", 'Heathland & moorland', ecocode_dating."Heathland & moorland", 'Halotolerant', ecocode_dating.halotolerant, 'Ectoparasite', ecocode_dating.ectoparasite))))) AS ecocode_json
   FROM humlab_utility.ecocode_dating
  GROUP BY ecocode_dating.agg_type;


--
-- TOC entry 702 (class 1259 OID 71780)
-- Name: physical_sample_ecocode_abundance; Type: MATERIALIZED VIEW; Schema: humlab_utility; Owner: -
--

CREATE MATERIALIZED VIEW humlab_utility.physical_sample_ecocode_abundance AS
 SELECT ps.physical_sample_id,
    ed.name AS ecocode_name,
    sum(ab.abundance) AS abundance_sum,
    count(ab.abundance) AS abundance_count
   FROM ((((((public.tbl_analysis_entities ae
     JOIN public.tbl_physical_samples ps ON ((ps.physical_sample_id = ae.physical_sample_id)))
     JOIN public.tbl_abundances ab ON ((ab.analysis_entity_id = ae.analysis_entity_id)))
     JOIN public.tbl_taxa_tree_master tm ON ((tm.taxon_id = ab.taxon_id)))
     JOIN public.tbl_ecocodes e ON ((tm.taxon_id = e.taxon_id)))
     JOIN public.tbl_ecocode_definitions ed ON ((e.ecocode_definition_id = ed.ecocode_definition_id)))
     JOIN public.tbl_ecocode_groups eg ON ((eg.ecocode_group_id = ed.ecocode_group_id)))
  GROUP BY ps.physical_sample_id, ed.name
  WITH NO DATA;


--
-- TOC entry 4007 (class 1259 OID 71785)
-- Name: idx_physical_sample_ecocode_abundance; Type: INDEX; Schema: humlab_utility; Owner: -
--

CREATE UNIQUE INDEX idx_physical_sample_ecocode_abundance ON humlab_utility.physical_sample_ecocode_abundance USING btree (physical_sample_id, ecocode_name);


--
-- TOC entry 4269 (class 0 OID 71780)
-- Dependencies: 702 4271
-- Name: physical_sample_ecocode_abundance; Type: MATERIALIZED VIEW DATA; Schema: humlab_utility; Owner: -
--

REFRESH MATERIALIZED VIEW humlab_utility.physical_sample_ecocode_abundance;


-- Completed on 2019-04-12 14:15:27 CEST

--
-- PostgreSQL database dump complete
--

