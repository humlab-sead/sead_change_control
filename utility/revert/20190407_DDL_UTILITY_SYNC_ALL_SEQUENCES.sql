-- Revert sead_db_change_control:ADMIN_SYNC_ALL_SEQUENCES on pg

BEGIN;

-- XXX Add verifications here.

ROLLBACK;