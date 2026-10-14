-- Verify facet:20261006_DML_CERAMIC_TEMPERING_FACET on pg

BEGIN;

-- Helper view exists and returns rows.
select 1 / count(*)
from facet.ceramic_tempering;

-- Facet exists with key metadata.
select 1 / count(*)
from facet.facet
where facet_code = 'ceramic_tempering'
  and display_title = 'Tempering'
  and facet_type_id = 1
  and category_id_expr = 'facet.ceramic_tempering.tempering_id'
  and category_name_expr = 'facet.ceramic_tempering.tempering_name'
  and is_applicable = true;

-- Facet targets the helper view.
select 1 / count(*)
from facet.facet_table ft
join facet.facet f using (facet_id)
join facet.table t using (table_id)
where f.facet_code = 'ceramic_tempering'
  and ft.sequence_id = 1
  and t.table_or_udf_name = 'facet.ceramic_tempering';

-- The helper view's only relation is to tbl_analysis_entities.
select 1 / (case when count(*) = 1 and bool_and(o.table_or_udf_name = 'tbl_analysis_entities') then 1 else 0 end)
from facet.table_relation r
join facet.table t on t.table_or_udf_name = 'facet.ceramic_tempering'
join facet.table o on o.table_id = case when r.source_table_id = t.table_id then r.target_table_id else r.source_table_id end
where t.table_id in (r.source_table_id, r.target_table_id);

-- Facet is a child of the ceramic domain.
select 1 / count(*)
from facet.facet_children
where facet_code = 'ceramic'
  and child_facet_code = 'ceramic_tempering';

ROLLBACK;
