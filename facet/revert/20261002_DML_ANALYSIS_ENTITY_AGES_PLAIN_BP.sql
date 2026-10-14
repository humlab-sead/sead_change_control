-- Revert facet:20261002_DML_ANALYSIS_ENTITY_AGES_PLAIN_BP from pg

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

    -- Back to the -10000 shift of 20260402_DML_ANALYSIS_ENTITY_AGES_BP_OVERLAP_FIX. Only clients that send
    -- negated BP expect it.
    update facet.facet
    set category_id_expr = 'int4range(lower(age_range) - 10000, upper(age_range) - 10000)',
        category_name_expr = 'int4range(lower(age_range) - 10000, upper(age_range) - 10000)'
    where facet_code = 'analysis_entity_ages';
end $$;

COMMIT;
