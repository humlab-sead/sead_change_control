-- Deploy sead_db_change_control:CSR_20190408_REFACTOR_PROJECT_STAGES to pg

BEGIN;

    DO $$
    BEGIN

        IF NOT EXISTS (SELECT 1 FROM pg_class where relname = 'tbl_project_stages_project_stage_id_seq' )
        THEN
            CREATE SEQUENCE tbl_project_stages_project_stage_id_seq;
        END IF;

        ALTER TABLE tbl_project_stages
            ALTER COLUMN "project_stage_id"
                SET DEFAULT nextval('tbl_project_stages_project_stage_id_seq'::regclass);
                
        SELECT setval('tbl_project_stages_project_stage_id_seq', COALESCE((SELECT MAX(project_stage_id)+1 FROM tbl_project_stages), 1), false);

    END $$ LANGUAGE plpgsql;

COMMIT;
