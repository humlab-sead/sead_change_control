-- Deploy sead_db_change_control:20221117_DML_RESTAPI_GENERATE_SCHEMA to pg

/****************************************************************************************************************
  Change author
    Roger Mähler, 2018-06-12
  Change description
    Generate schema POSTGREST REST API publication of SEAD base table
  Risk assessment
  Planning
    Low risk
  Change execution and rollback
    Apply this script.
    Steps to verify change: N/A
    Steps to rollback change: N/A
  Change prerequisites (e.g. tests)
  Change reviewer
  Change Approver Signoff
  Notes:
*****************************************************************************************************************/
Set client_min_messages = warning;

select sead_utility.create_postgrest_default_api_schema();

