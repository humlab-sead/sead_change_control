-- Verify facet:20260327_DML_FIX_DATASET_METHODS_FACET on pg

BEGIN;

-- Verify tbl_dataset_methods entry (facet_table_id=112) has been removed for facet_id=39
SELECT 1 / (1 - COUNT(*))
FROM facet.facet_table
WHERE facet_table_id = 112
  AND facet_id = 39;

-- Verify tbl_methods (facet_table_id=114) is now sequence_id=1 (TargetTable)
SELECT 1 / COUNT(*)
FROM facet.facet_table
WHERE facet_table_id = 114
  AND facet_id = 39
  AND sequence_id = 1;

ROLLBACK;
