-- Revert facet:20260324_DML_FACET_ABUNDANCE_CLASSIFICATION_TITLE

BEGIN;

set search_path = facet, pg_catalog;

update facet.facet
set display_title = 'abundance classification'
where facet_id = 31;

COMMIT;
