-- Revert facet:20260327_DML_FIX_DATASET_METHODS_FACET from pg

BEGIN;

-- Restore tbl_methods to sequence_id=2
UPDATE facet.facet_table
SET sequence_id = 2
WHERE facet_table_id = 114
  AND facet_id = 39;

-- Re-insert the deprecated tbl_dataset_methods entry as TargetTable
INSERT INTO facet.facet_table (facet_table_id, facet_id, sequence_id, table_id)
VALUES (112, 39, 1, 162)
ON CONFLICT (facet_table_id) DO NOTHING;

COMMIT;
