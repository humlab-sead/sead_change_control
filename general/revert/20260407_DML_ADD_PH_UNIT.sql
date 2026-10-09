-- Revert general:20260407_DML_ADD_PH_UNIT from pg

BEGIN;

-- Forward-only policy: no revert for deployed data changes.

COMMIT;
