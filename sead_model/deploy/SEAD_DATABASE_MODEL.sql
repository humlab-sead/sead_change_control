-- Deploy sead_model: SEAD_DATABASE_MODEL
/****************************************************************************************************************
  Author        Roger Mähler
  Date          2023-12-20
  Description   SEAD database model (public schema)
  Issue         https://github.com/humlab-sead/sead_change_control/issues/217
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes         The model is based on the SEAD database sead_master_9
*****************************************************************************************************************/

set client_encoding = 'UTF8';
set standard_conforming_strings = on;
set client_min_messages = error;

set role sead_master;

create schema if not exists public;

create extension if not exists postgis;

comment on schema public is 'standard public schema';

\set autocommit off;
\cd /repo/sead_model/deploy
begin;


\i SEAD_DATABASE_MODEL/tables.sql;
\i SEAD_DATABASE_MODEL/foreignkeys.sql;
\i SEAD_DATABASE_MODEL/indexes.sql;
\i SEAD_DATABASE_MODEL/grants.sql;
\i SEAD_DATABASE_MODEL/comments.sql;

commit;

reset role;
