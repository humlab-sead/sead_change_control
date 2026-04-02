-- Verify facet:20260323_DML_FACET_DESCRIPTIONS

BEGIN;

set search_path = facet, pg_catalog;

-- Spot-check a sample of updated descriptions to confirm the deploy ran correctly
select 1/count(*) from facet.facet where facet_id = 3  and description = 'Magnetic susceptibility of sediment samples, reflecting magnetic mineral concentration and indicating burning or human activity';
select 1/count(*) from facet.facet where facet_id = 5  and description = 'Proportion of organic matter in sediment, determined by comparing sample weight before and after combustion at 550°C';
select 1/count(*) from facet.facet where facet_id = 12 and description = 'The category of biological or physical proxy used to derive palaeoenvironmental or archaeological data (e.g. pollen, insects, magnetic susceptibility)';
select 1/count(*) from facet.facet where facet_id = 33 and description = 'The recorded count or estimated quantity of a taxon within a sample';
select 1/count(*) from facet.facet where facet_id = 53 and description = 'Age range filter for dendrochronology, covering both estimated felling year and outermost tree ring date';

ROLLBACK;
