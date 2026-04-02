-- Deploy facet:20260402_DML_ANALYSIS_ENTITY_AGES_BP_OVERLAP_FIX to pg
/****************************************************************************************************************
  Author        Johan von Boer
  Date          2026-04-02
  Description   Align analysis_entity_ages range expression with BP overlap semantics
  Issue         Local-only change (no GitHub issue yet)
  Prerequisites 20240404_DDL_ANALYSIS_AGES_FACET
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

set client_encoding = 'UTF8';
set client_min_messages = error;

BEGIN;

do $$
begin
    if not exists (
        select 1
        from facet.facet
        where facet_code = 'analysis_entity_ages'
    ) then
        raise exception 'Facet analysis_entity_ages does not exist.';
    end if;

    update facet.facet
    set category_id_expr = 'int4range(lower(age_range) - 10000, upper(age_range) - 10000)',
        category_name_expr = 'int4range(lower(age_range) - 10000, upper(age_range) - 10000)',
        description = 'Analysis entity ages (intersects, BP-aligned)'
    where facet_code = 'analysis_entity_ages';
end $$;

COMMIT;
