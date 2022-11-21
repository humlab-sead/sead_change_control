-- Revert sead_api:20221121_DDL_DELETE_FACET_UDF from pg

begin;

    drop function facet.delete_facet(i_facet_id integer);
commit;
