-- Revert dendrochronology: 20221121_DML_QSE_DENDRO_DATING

begin;

    call sead_utility.drop_view('postgrest_api.qse_dendro_dating');

commit;
