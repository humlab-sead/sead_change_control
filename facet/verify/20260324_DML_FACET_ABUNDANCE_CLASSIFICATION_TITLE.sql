-- Verify facet:20260324_DML_FACET_ABUNDANCE_CLASSIFICATION_TITLE

BEGIN;

set search_path = facet, pg_catalog;

select 1/count(*) from facet.facet
where facet_id = 31
  and display_title = 'Abundance classification';

ROLLBACK;
