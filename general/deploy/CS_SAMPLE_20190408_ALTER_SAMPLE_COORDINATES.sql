-- Deploy sead_db_change_control:CSR_20190408_REFACTOR_SAMPLE_COORDINATES to pg

BEGIN;

    DO $$
    BEGIN

        IF NOT EXISTS (SELECT 1 FROM pg_class where relname = 'tbl_sample_coordinates_sample_coordinate_id_seq' )
        THEN
            CREATE SEQUENCE tbl_sample_coordinates_sample_coordinate_id_seq;
        END IF;

        ALTER TABLE tbl_sample_coordinates
            ALTER COLUMN "sample_coordinate_id"
                SET DEFAULT nextval('tbl_sample_coordinates_sample_coordinate_id_seq'::regclass);
                
        SELECT setval('tbl_sample_coordinates_sample_coordinate_id_seq', COALESCE((SELECT MAX(sample_coordinate_id)+1 FROM tbl_sample_coordinates), 1), false);

    END $$ LANGUAGE plpgsql;

COMMIT;
