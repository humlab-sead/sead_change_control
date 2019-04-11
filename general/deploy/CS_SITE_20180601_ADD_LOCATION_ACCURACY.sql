-- Deploy sead_db_change_control:CS_SITE_20180601_ADD_LOCATION_ACCURACY to pg

BEGIN;

DO $$
BEGIN
	BEGIN
    
        IF sead_utility.column_exists('public'::text, 'tbl_sites'::text, 'site_location_accuracy'::text) = TRUE THEN
            RAISE EXCEPTION SQLSTATE 'GUARD';
        END IF;
        
        ALTER TABLE "tbl_sites" ADD COLUMN "site_location_accuracy" varchar COLLATE "pg_catalog"."default";

        COMMENT ON COLUMN "tbl_sites"."site_location_accuracy"
            IS 'Accuracy of highest location resolution level. E.g. Nearest settlement, lake, bog, ancient monument, approximate';

    EXCEPTION WHEN SQLSTATE 'GUARD' THEN
        RAISE NOTICE 'ALREADY EXECUTED';
    END;
    
END $$;

ROLLBACK;
