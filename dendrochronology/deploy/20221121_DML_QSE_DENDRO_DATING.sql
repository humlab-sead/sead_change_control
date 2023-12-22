-- Deploy dendrochronology: 20221121_DML_QSE_DENDRO_DATING
 /****************************************************************************************************************
  Author        Roger Mähler
  Date          2022-11-21
  Description   Dendro dating reporting view (JvB)
  Prerequisites
  Issue         https://github.com/humlab-sead/sead_change_control/issues/156
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/ begin;

do $$
begin
    -- FIXME: Breaking change
    drop view if exists postgrest_api.qse_dendro_dating;

    create or replace view postgrest_api.qse_dendro_dating as
        select distinct ps.physical_sample_id,
            ae.analysis_entity_id,
            dl.name as "date_type",
            ps.sample_name as "sample",
            t.age_type as "age_type",
            dd.age_older as "older",
            dd.age_younger as "younger",
            s.season_name as "season"
            -- dd.error_plus AS plus,
            -- dd.error_minus AS minus,
            -- eu.error_uncertainty_type AS error_uncertainty,
            -- soq.season_or_qualifier_type AS season
        from tbl_physical_samples ps
        join tbl_analysis_entities ae on ps.physical_sample_id = ae.physical_sample_id
        join tbl_dendro_dates dd on ae.analysis_entity_id = dd.analysis_entity_id
        left join tbl_seasons s using ("season_id")
        left join tbl_age_types t using ("age_type_id")
        left join tbl_dendro_lookup dl using ("dendro_lookup_id");

    alter view if exists postgrest_api.qse_dendro_dating owner to postgrest;

    grant all privileges on table postgrest_api.qse_dendro_dating to humlab_admin;

    comment on view postgrest_api.qse_dendro_dating  is null;

end $$;
commit;
