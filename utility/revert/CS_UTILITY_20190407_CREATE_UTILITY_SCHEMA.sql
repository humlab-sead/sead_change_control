-- Revert sead_db_change_control:create_sead_utility_schema from pg

BEGIN;

DROP SCHEMA sead_utility;

COMMIT;
