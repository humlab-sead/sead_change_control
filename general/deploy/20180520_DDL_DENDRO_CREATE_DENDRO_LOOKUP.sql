-- Deploy sead_db_change_control:CS_DENDRO_20190520_CREATE_DENDRO_LOOKUP to pg

BEGIN;

DO $$
BEGIN
	BEGIN
    
        IF sead_utility.table_exists('public'::text, 'tbl_dendro_lookup'::text) = TRUE THEN
            RAISE EXCEPTION SQLSTATE 'GUARD';
        END IF;
        
        CREATE TABLE tbl_dendro_lookup (
            dendro_lookup_id SERIAL PRIMARY KEY,
            method_id int4,
            name varchar COLLATE "pg_catalog"."default" NOT NULL,
            description text COLLATE "pg_catalog"."default",
            date_updated timestamptz(6) DEFAULT now(),
            CONSTRAINT "fk_dendro_lookup_method_id"
                FOREIGN KEY ("method_id") REFERENCES tbl_methods (method_id)
                    ON DELETE NO ACTION ON UPDATE NO ACTION
        );
        
        ALTER TABLE tbl_dendro
            DROP CONSTRAINT IF EXISTS "fk_dendro_dendro_measurement_id",
            DROP COLUMN "dendro_measurement_id",
            ADD COLUMN "dendro_lookup_id" int4 NOT NULL,
            ADD CONSTRAINT "fk_dendro_dendro_lookup_id"
                FOREIGN KEY ("dendro_lookup_id") REFERENCES tbl_dendro_lookup (dendro_lookup_id)
                    ON DELETE NO ACTION ON UPDATE NO ACTION;

        ALTER TABLE tbl_dendro_lookup OWNER TO "sead_master";
        
        DROP TABLE IF EXISTS "public"."tbl_dendro_measurement_lookup";
        
        COMMENT ON TABLE tbl_dendro_lookup IS 'Type=lookup';

    EXCEPTION WHEN SQLSTATE 'GUARD' THEN
        RAISE NOTICE 'ALREADY EXECUTED';
    END;
    
END $$;

ROLLBACK;
