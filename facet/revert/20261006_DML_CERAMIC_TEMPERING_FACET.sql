-- Revert facet:20261006_DML_CERAMIC_TEMPERING_FACET from pg

BEGIN;

do $$
declare i_facet_id int;
declare i_table_id int;
begin

    i_facet_id = (select facet_id from facet.facet where facet_code = 'ceramic_tempering');
    i_table_id = (select table_id from facet.table where table_or_udf_name = 'facet.ceramic_tempering');

    delete from facet.facet_children
    where facet_code = 'ceramic_tempering'
       or child_facet_code = 'ceramic_tempering';

    if i_facet_id is not null then
        delete from facet.facet_dependency where i_facet_id in (facet_id, dependency_facet_id);
        delete from facet.facet_clause where facet_id = i_facet_id;
        delete from facet.facet_table where facet_id = i_facet_id;
        delete from facet.facet where facet_id = i_facet_id;
    end if;

    if i_table_id is not null then
        delete from facet.table_relation where i_table_id in (source_table_id, target_table_id);
        delete from facet.table where table_id = i_table_id;
    end if;

    drop view if exists facet.ceramic_tempering;

end $$;

COMMIT;
