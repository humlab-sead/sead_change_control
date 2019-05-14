-- Revert sead_db_change_control:CSA_20180501_GENERATE_REST_API_SCHEMA from pg

BEGIN;

-- Drop Schema If Exists postgrest_default_api;
-- Drop Role If Exists anonymous_rest_user;

COMMIT;
