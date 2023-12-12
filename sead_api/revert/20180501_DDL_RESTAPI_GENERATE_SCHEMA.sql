-- Revert sead_api: 20180501_DDL_RESTAPI_GENERATE_SCHEMA

BEGIN;

-- Drop Schema If Exists postgrest_default_api;
-- Drop Role If Exists anonymous_rest_user;

COMMIT;
