-- Deploy sead_api: 20221117_DML_RESTAPI_GENERATE_SCHEMA

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2022-11-17
  Description   Refresh REST API schema
  Issue         https://github.com/humlab-sead/sead_change_control/issues/157
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

Set client_min_messages = warning;

select sead_utility.create_postgrest_default_api_schema();

