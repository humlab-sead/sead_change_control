-- Deploy sead_db_change_control:CSR_20190408_CREATE_TABLE_DATASET_METHODS to pg
BEGIN;

    DO $$
    BEGIN
        BEGIN
        
            IF sead_utility.table_exists('public'::text, 'tbl_dataset_methods'::text) = FALSE THEN
                RAISE EXCEPTION SQLSTATE 'GUARD';
            END IF;
        
            CREATE TABLE IF NOT EXISTS tbl_dataset_methods (
                 dataset_method_id SERIAL PRIMARY KEY,
                 dataset_id int4 NOT NULL,
                 method_id int4 NOT NULL,
                 date_updated timestamptz(6) DEFAULT now(),
                 CONSTRAINT "fk_tbl_dataset_methods_to_tbl_datasets" FOREIGN KEY ("dataset_id")
                    REFERENCES tbl_datasets ("dataset_id") ON DELETE NO ACTION ON UPDATE NO ACTION,
                 CONSTRAINT "fk_tbl_dataset_methods_to_tbl_methods" FOREIGN KEY ("method_id")
                    REFERENCES tbl_methods ("method_id") ON DELETE NO ACTION ON UPDATE NO ACTION
            );

            ALTER TABLE tbl_dataset_methods OWNER TO "sead_master";
            
        EXCEPTION WHEN SQLSTATE 'GUARD' THEN
            RAISE NOTICE 'ALREADY EXECUTED';
        END;
        
    END $$ LANGUAGE plpgsql;
    
COMMIT;