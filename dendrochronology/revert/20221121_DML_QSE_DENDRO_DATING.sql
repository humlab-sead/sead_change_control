-- Revert dendrochronology: 20221121_DML_QSE_DENDRO_DATING

begin;

    drop view if exists "postgrest_api"."qse_dendro_dating";

commit;
