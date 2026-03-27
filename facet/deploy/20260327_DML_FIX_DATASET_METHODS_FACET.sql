-- Deploy facet:20260327_DML_FIX_DATASET_METHODS_FACET

/****************************************************************************************************************
  Author        Johan von Boer
  Date          2026-03-27
  Description   Fix dataset_methods facet (facet_id=39): remove deprecated tbl_dataset_methods
                entry and promote tbl_methods as TargetTable (sequence_id=1).
  Issue         https://github.com/humlab-sead/sead_change_control/issues/423
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes         The facet's category_id_expr is 'tbl_methods.method_id', so tbl_methods must be
                the TargetTable (sequence_id=1). tbl_dataset_methods (table_id=162) is deprecated
                and empty. tbl_datasets (facet_table_id=113) joins to tbl_methods via
                tbl_datasets.method_id = tbl_methods.method_id (table_relation_id=67).

                Before:
                  facet_table_id=112  sequence_id=1  table_id=162  tbl_dataset_methods  (DEPRECATED)
                  facet_table_id=113  sequence_id=2  table_id=86   tbl_datasets
                  facet_table_id=114  sequence_id=2  table_id=89   tbl_methods

                After:
                  facet_table_id=113  sequence_id=2  table_id=86   tbl_datasets
                  facet_table_id=114  sequence_id=1  table_id=89   tbl_methods
*****************************************************************************************************************/

set client_encoding = 'UTF8';
set client_min_messages = error;

BEGIN;

-- Remove deprecated tbl_dataset_methods entry (only if it still references this facet)
DELETE FROM facet.facet_table
WHERE facet_table_id = 112
  AND facet_id = 39;

-- Promote tbl_methods to sequence_id=1 so it becomes the TargetTable
UPDATE facet.facet_table
SET sequence_id = 1
WHERE facet_table_id = 114
  AND facet_id = 39
  AND sequence_id IS DISTINCT FROM 1;

COMMIT;
