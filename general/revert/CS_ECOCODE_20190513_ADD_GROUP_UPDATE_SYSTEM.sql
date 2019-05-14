-- Revert sead_change_control:CS_ECOCODE_20190513_ADD_GROUP_UPDATE_SYSTEM from pg

BEGIN;
    DELETE FROM "public"."tbl_ecocode_groups" WHERE "ecocode_group_id" = 7;
COMMIT;
