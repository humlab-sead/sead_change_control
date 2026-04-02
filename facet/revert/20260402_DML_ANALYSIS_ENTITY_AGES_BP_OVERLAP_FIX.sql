-- Revert facet:20260402_DML_ANALYSIS_ENTITY_AGES_BP_OVERLAP_FIX from pg

BEGIN;

do $$
begin
    if not exists (
        select 1
        from facet.facet
        where facet_code = 'analysis_entity_ages'
    ) then
        raise notice 'analysis_entity_ages facet not found, nothing to revert';
        return;
    end if;

    update facet.facet
    set category_id_expr = 'age_range',
        category_name_expr = 'age_range',
        description = 'Analysis entity ages (intersects)'
    where facet_code = 'analysis_entity_ages';
end $$;

COMMIT;
