-- Deploy sead_db_change_control:CS_SAMPLE_20190410_CREATE_INDEX to pg

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

set client_min_messages to warning;

begin;
do $$
begin

    begin

        drop index if exists idx_tbl_physical_sample_features_feature_id;

        create index idx_tbl_physical_sample_features_feature_id on tbl_physical_sample_features (feature_id);

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;

end $$;
commit;
