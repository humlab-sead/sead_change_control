-- Revert sead_db_change_control:CSA_20180607_ALTER_SAMPLE_GROUP_SAMPLING_CONTEXT from pg

BEGIN;

    -- DROP VIEW clearing_house.view_sample_group_sampling_contexts;

COMMIT;
