-- Revert sead_change_control:CS_ECOCODE_20190513_ADD_GROUP_UPDATE_SYSTEM from pg

begin;
    --delete from "public"."tbl_ecocode_groups" where "ecocode_group_id" = 7;
commit;
