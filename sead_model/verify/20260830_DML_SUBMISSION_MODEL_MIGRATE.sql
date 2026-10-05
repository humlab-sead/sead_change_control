-- Verify sead_model:20260830_DML_SUBMISSION_MODEL_MIGRATE on pg

BEGIN;

DO $$
BEGIN
	IF parse_legacy_submission_date('2025-02-17') IS DISTINCT FROM DATE '2025-02-17' THEN
		RAISE EXCEPTION 'Full submission dates were not parsed correctly';
	END IF;

	IF parse_legacy_submission_date('2024-11') IS DISTINCT FROM DATE '2024-11-01' THEN
		RAISE EXCEPTION 'Year-month submission dates were not parsed correctly';
	END IF;

	IF parse_legacy_submission_date('2010') IS DISTINCT FROM DATE '2010-01-01' THEN
		RAISE EXCEPTION 'Year-only submission dates were not parsed correctly';
	END IF;

	IF parse_legacy_submission_date('not a date') IS NOT NULL THEN
		RAISE EXCEPTION 'Invalid submission dates should return NULL';
	END IF;
END;
$$;

ROLLBACK;
