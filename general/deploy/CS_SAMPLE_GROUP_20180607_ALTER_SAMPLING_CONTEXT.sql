-- Deploy sead_db_change_control:CSA_20180607_ALTER_SAMPLE_GROUP_SAMPLING_CONTEXT to pg

BEGIN;

    DROP VIEW postgrest_default_api.sample_group_sampling_context;

    ALTER TABLE public.tbl_sample_group_sampling_contexts ALTER COLUMN sampling_context TYPE character varying(60);

    SELECT clearing_house.fn_create_local_union_public_entity_views('clearing_house', 'clearing_house', FALSE, TRUE);


COMMIT;
