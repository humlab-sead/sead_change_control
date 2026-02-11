-- Deploy ./sead_model: SEAD_MODEL_COMMENTS

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description   Add comments on tables and columns
  Issue         https://github.com/humlab-sead/sead_change_control/issues/411
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/


set client_encoding = 'UTF8';
set standard_conforming_strings = on;
set client_min_messages = error;

set role sead_master;

comment on schema public is 'standard public schema';

\set autocommit off;
\cd /repo/sead_model/deploy
begin;

\i SEAD_DATABASE_COMMENTS/comments.sql;

commit;

reset role;
