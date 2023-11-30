-- Revert sead_change_control:20231129_DML_ADD_TAXONOMIC_ORDER_DYNTAXA from pg

BEGIN;

    drop table if exists dyntaxa_taxonomyc_order_system_temp;

    delete from 
    delete from tbl_taxonomic_order_systems where taxonomic_order_system_id = 2;



COMMIT;
