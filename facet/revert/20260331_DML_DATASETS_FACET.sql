-- Revert facet:20260331_DML_DATASETS_FACET from pg

BEGIN;

do $$
declare i_facet_id int;
begin
    i_facet_id = (
        select max(facet_id)
        from facet.facet
        where facet_code = 'datasets'
    );

    if i_facet_id is null then
        raise notice 'datasets facet not found, nothing to revert';
        return;
    end if;

    delete from facet.facet_children
    where facet_code = 'datasets'
       or child_facet_code = 'datasets';

    delete from facet.facet_dependency
    where facet_id = i_facet_id
       or dependency_facet_id = i_facet_id;

    delete from facet.facet_clause
    where facet_id = i_facet_id;

    delete from facet.facet_table
    where facet_id = i_facet_id;

    delete from facet.facet
    where facet_id = i_facet_id;
end $$;

COMMIT;
