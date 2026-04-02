-- Verify facet:20260402_DML_ANALYSIS_ENTITY_AGES_BP_OVERLAP_FIX on pg

BEGIN;

-- Facet metadata should use the BP-aligned shifted range expression.
select 1 / count(*)
from facet.facet
where facet_code = 'analysis_entity_ages'
  and facet_type_id = 4
  and category_id_operator = '&&'
  and category_id_expr = 'int4range(lower(age_range) - 10000, upper(age_range) - 10000)'
  and category_name_expr = 'int4range(lower(age_range) - 10000, upper(age_range) - 10000)';

-- Requested behavior check:
-- filtering "76 BP to 10k BP" should be equivalent to the currently generated filter range
-- once the facet expression has been shifted into the internal category domain.
with base as (
    select
        s.site_id,
        a.age_range,
        int4range(lower(a.age_range) - 10000, upper(a.age_range) - 10000) as shifted_age_range
    from tbl_analysis_entity_ages a
    join tbl_analysis_entities ae
      on ae.analysis_entity_id = a.analysis_entity_id
    join tbl_physical_samples ps
      on ps.physical_sample_id = ae.physical_sample_id
    join tbl_sample_groups sg
      on sg.sample_group_id = ps.sample_group_id
    join tbl_sites s
      on s.site_id = sg.site_id
    where a.age_range is not null
),
counts as (
    select
        count(distinct site_id) filter (
            where age_range && int4range(76, 10000, '[]')
        ) as expected_bp_overlap_sites,
        count(distinct site_id) filter (
            where shifted_age_range && int4range(-9924, 76, '[]')
        ) as shifted_generated_overlap_sites
    from base
)
select 1 / count(*)
from counts
where expected_bp_overlap_sites = shifted_generated_overlap_sites;

ROLLBACK;
