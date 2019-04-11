-- Deploy sead_db_change_control:CSR_20190408_REFACTOR_CHRONOLOGIES to pg

BEGIN;

    DO $$
    BEGIN
        BEGIN
        
            IF sead_utility.column_exists('public'::text, 'tbl_chronologies'::text, 'relative_age_type_id'::text) = TRUE THEN
                RAISE EXCEPTION SQLSTATE 'GUARD';
            END IF;
        
            ALTER TABLE tbl_chronologies
                ALTER COLUMN "age_model" TYPE varchar(255) COLLATE "pg_catalog"."default",
                ALTER COLUMN "chronology_name" TYPE varchar(255) COLLATE "pg_catalog"."default",
                ALTER COLUMN "sample_group_id" DROP NOT NULL,
                ADD COLUMN "relative_age_type_id" int4,
                DROP COLUMN "age_type_id";

            COMMENT ON COLUMN "public"."tbl_chronologies"."relative_age_type_id" IS 'Constraint removed to obsolete table (tbl_age_types), replaced by non-binding id of relative_age_types - but not fully implemented. Notes should be used to inform on chronology years types and construction.';
            COMMENT ON TABLE "public"."tbl_chronologies" IS '20170911PIB: Removed Not Null requirement for sample-group_id to allow for chronologies not tied to a single sample group (e.e. calibrated ages for DataArc or other projects)
Increased length of some fields.
20120504PIB: Note that the dropped age type recorded the type of dates (C14 etc) used in constructing the chronology... but is only one per chonology enough? Can a chronology not be made up of mulitple types of age? (No, years types can only be of one sort - need to calibrate if mixed?)';

        EXCEPTION WHEN SQLSTATE 'GUARD' THEN
            RAISE NOTICE 'ALREADY EXECUTED';
        END;
        
    END $$ LANGUAGE plpgsql;
    
COMMIT;
