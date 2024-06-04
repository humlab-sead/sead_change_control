-- Revert sead_api: 20221121_DDL_UDF_DELETE_FACET

begin;

    drop function facet.delete_facet(i_facet_id integer);
commit;
