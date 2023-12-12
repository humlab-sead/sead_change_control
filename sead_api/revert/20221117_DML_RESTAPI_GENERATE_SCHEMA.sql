-- Revert sead_api: 20221117_DML_RESTAPI_GENERATE_SCHEMA

BEGIN;

-- Drop Schema If Exists postgrest_default_api;
-- Drop Role If Exists anonymous_rest_user;

COMMIT;
