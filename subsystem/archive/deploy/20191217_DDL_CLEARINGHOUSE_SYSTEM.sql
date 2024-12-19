-- Deploy subsystem: 20191217_DDL_CLEARINGHOUSE_SYSTEM
/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-12-17
  Description   Deploy of Clearinghouse Transport System.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/215
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
*****************************************************************************************************************/

set client_encoding = 'UTF8';
set standard_conforming_strings = on;
set client_min_messages = warning;

drop schema if exists clearing_house cascade;

create schema if not exists clearing_house authorization clearinghouse_worker;

set role clearinghouse_worker;


\set autocommit off;

\cd /repo/subsystem/deploy

begin;


\i 20191217_DDL_CLEARINGHOUSE_SYSTEM/00_assign_privileges.sql;
\i 20191217_DDL_CLEARINGHOUSE_SYSTEM/01_utility_functions.sql;
\i 20191217_DDL_CLEARINGHOUSE_SYSTEM/02_clearinghouse_model.sql;
\i 20191217_DDL_CLEARINGHOUSE_SYSTEM/03_populate_clearinghouse_model.sql;
\i 20191217_DDL_CLEARINGHOUSE_SYSTEM/04_entity_model.sql;

call clearing_house.create_clearinghouse_model(false);
call clearing_house.populate_clearinghouse_model();
call clearing_house.create_public_model(false, false);

\i 20191217_DDL_CLEARINGHOUSE_SYSTEM/06_extract_and_resolve.sql;
\i 20191217_DDL_CLEARINGHOUSE_SYSTEM/05_review_ceramic_values.sql;
\i 20191217_DDL_CLEARINGHOUSE_SYSTEM/05_review_dataset.sql;
\i 20191217_DDL_CLEARINGHOUSE_SYSTEM/05_review_sample_group.sql;
\i 20191217_DDL_CLEARINGHOUSE_SYSTEM/05_review_sample.sql;
\i 20191217_DDL_CLEARINGHOUSE_SYSTEM/05_review_site.sql;
\i 20191217_DDL_CLEARINGHOUSE_SYSTEM/08_reporting.sql;

commit;

reset role;
