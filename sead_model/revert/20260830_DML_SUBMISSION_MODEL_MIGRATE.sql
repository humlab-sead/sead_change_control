-- Revert sead_model:20260830_DML_SUBMISSION_MODEL_MIGRATE from pg

BEGIN;

DROP FUNCTION IF EXISTS migrate_submission_datasets(integer, integer[]);
DROP FUNCTION IF EXISTS parse_legacy_submission_date(text);

COMMIT;
