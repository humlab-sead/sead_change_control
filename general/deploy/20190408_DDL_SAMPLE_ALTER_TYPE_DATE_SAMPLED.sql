-- Deploy sead_db_change_control:CSR_20190408_ALTER_TYPE_PHYSICAL_SAMPLES_DATE_SAMPLED to pg

BEGIN;
/****************************************************************************************************************
  Change author
        Roger Mähler, 2018-06-13
  Change description
        Field date_sampled in tbl_physical_samples has type "character varying", should be "timestamp with time zone"
  Risk assessment
    N/A
  Planning
  Change execution and rollback
    Apply this script.
    Steps to verify change: N/A
    Steps to rollback change: N/A
  Change prerequisites (e.g. tests)
  Change reviewer
  Change Approver Signoff
  Notes:
  Impact on dependent modules
    Changes must be propagated to Clearing House
*****************************************************************************************************************/

    alter table public.tbl_physical_samples alter column date_sampled type timestamp with time zone using date_sampled::timestamp with time zone;

COMMIT;
