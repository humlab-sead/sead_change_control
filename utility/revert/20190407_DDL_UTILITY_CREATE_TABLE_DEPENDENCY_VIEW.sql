-- Revert sead_db_change_control:CREATE_TABLE_DEPENDENCY_VIEW from pg

BEGIN;

DROP VIEW IF EXISTS sead_utility.table_dependencies;

COMMIT;
