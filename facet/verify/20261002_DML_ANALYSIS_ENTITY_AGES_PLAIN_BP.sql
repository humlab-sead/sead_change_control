-- Verify facet:20261002_DML_ANALYSIS_ENTITY_AGES_PLAIN_BP on pg

BEGIN;

-- Facet metadata should use plain age_range, i.e. conventional years BP.
-- What the client sends as picks is covered by the client's timeline smoke test, since a verify can't call the query API.
select 1 / count(*)
from facet.facet
where facet_code = 'analysis_entity_ages'
  and facet_type_id = 4
  and category_id_operator = '&&'
  and category_id_expr = 'age_range'
  and category_name_expr = 'age_range';

ROLLBACK;
