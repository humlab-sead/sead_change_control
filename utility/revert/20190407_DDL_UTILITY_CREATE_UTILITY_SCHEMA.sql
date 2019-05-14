-- Revert sead_db_change_control:create_sead_utility_schema from pg

begin;

    drop schema sead_utility cascade;

commit;
