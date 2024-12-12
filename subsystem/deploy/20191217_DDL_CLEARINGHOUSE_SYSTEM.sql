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

alter user clearinghouse_worker createdb;

grant usage on schema public, sead_utility to clearinghouse_worker;
grant all privileges on all tables in schema public, sead_utility to clearinghouse_worker;
grant all privileges on all sequences in schema public, sead_utility to clearinghouse_worker;
grant execute on all functions in schema public, sead_utility to clearinghouse_worker;

alter default privileges in schema public, sead_utility grant all privileges on tables to clearinghouse_worker;
alter default privileges in schema public, sead_utility grant all privileges on sequences to clearinghouse_worker;

drop schema if exists clearing_house cascade;

create schema if not exists clearing_house authorization clearinghouse_worker;

set role clearinghouse_worker;


\set autocommit off;

\cd /repo/subsystem/deploy

begin;


\i 20191217_DDL_CLEARINGHOUSE_SYSTEM/01_clearinghouse_model.sql;
\i 20191217_DDL_CLEARINGHOUSE_SYSTEM/02_utility.sql;
\i 20191217_DDL_CLEARINGHOUSE_SYSTEM/03_populate_clearinghouse_model.sql;
\i 20191217_DDL_CLEARINGHOUSE_SYSTEM/04_entity_model.sql;

call clearing_house.create_clearinghouse_model(false);
call clearing_house.populate_clearinghouse_model();
call clearing_house.create_public_model(false, false);

\i 20191217_DDL_CLEARINGHOUSE_SYSTEM/06_extract_and_resolve.sql;
\i 20191217_DDL_CLEARINGHOUSE_SYSTEM/07_review.sql;
\i 20191217_DDL_CLEARINGHOUSE_SYSTEM/08_reporting.sql;

commit;

reset role;
