-- Deploy facet:20261002_DML_ANALYSIS_ENTITY_AGES_PLAIN_BP to pg
/****************************************************************************************************************
  Author        Johan von Boer
  Date          2026-10-02
  Description   Put the analysis_entity_ages facet back on plain age_range (conventional years BP)
  Issue         Local-only change (no GitHub issue yet)
  Prerequisites 20260402_DML_ANALYSIS_ENTITY_AGES_BP_OVERLAP_FIX
  Reviewer
  Approver
  Idempotent    Yes
  Notes         20260402_DML_ANALYSIS_ENTITY_AGES_BP_OVERLAP_FIX shifted the facet by -10000 years to make up for
                the client sending negated BP. A shift can't undo a sign flip, so the timeline filtered on the
                wrong period for every window not centred on 5000 BP. The client now sends picks in plain BP
                as [younger, older], so the facet goes back to the expression from 20240404_DDL_ANALYSIS_AGES_FACET.
                This is a forward change rather than a revert, because the shift is tagged and released and the
                revert would also restore an older description. The description is left as it is.
                The sead_query_api redis cache needs flushing after deploy.
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
    set category_id_expr = 'age_range',
        category_name_expr = 'age_range'
    where facet_code = 'analysis_entity_ages';
end $$;

COMMIT;
