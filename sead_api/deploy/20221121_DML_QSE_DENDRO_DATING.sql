-- Deploy sead_api:20221121_DML_QSE_DENDRO_DATING to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;
do $$
begin

    begin

        create or replace view "postgrest_api"."qse_dendro_dating" as
        select distinct ps.physical_sample_id,
            ae.analysis_entity_id,
            dl.name AS date_type,
            ps.sample_name AS sample,
            at.age_type,
            dd.age_older AS older,
            dd.age_younger AS younger,
            dd.error_plus AS plus,
            dd.error_minus AS minus,
            eu.error_uncertainty_type AS error_uncertainty,
            soq.season_or_qualifier_type AS season
        from ((((((tbl_physical_samples ps
            join tbl_analysis_entities ae on ((ps.physical_sample_id = ae.physical_sample_id)))
            join tbl_dendro_dates dd on ((ae.analysis_entity_id = dd.analysis_entity_id)))
            left join tbl_season_or_qualifier soq on ((soq.season_or_qualifier_id = dd.season_or_qualifier_id)))
            left join tbl_age_types at on ((at.age_type_id = dd.age_type_id)))
            left join tbl_error_uncertainties eu on ((eu.error_uncertainty_id = dd.error_uncertainty_id)))
            left join tbl_dendro_lookup dl on ((dd.dendro_lookup_id = dl.dendro_lookup_id)));

        alter view if exists "postgrest_api"."qse_dendro_dating" owner to postgrest;
        grant select on table "postgrest_api"."qse_dendro_dating" to humlab_admin; --warn: grant\revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
        grant insert on table "postgrest_api"."qse_dendro_dating" to humlab_admin; --warn: grant\revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
        grant update on table "postgrest_api"."qse_dendro_dating" to humlab_admin; --warn: grant\revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
        grant delete on table "postgrest_api"."qse_dendro_dating" to humlab_admin; --warn: grant\revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
        grant truncate on table "postgrest_api"."qse_dendro_dating" to humlab_admin; --warn: grant\revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
        grant references on table "postgrest_api"."qse_dendro_dating" to humlab_admin; --warn: grant\revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
        grant trigger on table "postgrest_api"."qse_dendro_dating" to humlab_admin; --warn: grant\revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

        comment on view "postgrest_api"."qse_dendro_dating"  is null;

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
