-- Deploy sead_model:01_SEAD_MODEL to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2023-12-20
  Issue         https://github.com/humlab-sead/sead_change_control/issues/217
  Description   DDL for generating the startingpoint of the SEAD database model
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes         The model is based on the SEAD database sead_master_9
*****************************************************************************************************************/

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


-- CREATE DATABASE sead_staging_mal WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
-- ALTER DATABASE sead_staging_mal OWNER TO sead_master;
-- \connect sead_staging_mal

CREATE SCHEMA public;

ALTER SCHEMA public OWNER TO postgres;

COMMENT ON SCHEMA public IS 'standard public schema';

set client_min_messages to warning;
\set autocommit off;

\cd /repo/sead_model/deploy


begin;

\i SEAD_DATABASE_MODEL/tables.sql
\i SEAD_DATABASE_MODEL/foreignkeys.sql
\i SEAD_DATABASE_MODEL/udfs.sql
\i SEAD_DATABASE_MODEL/views.sql
\i SEAD_DATABASE_MODEL/indexes.sql
\i SEAD_DATABASE_MODEL/grants.sql
\i SEAD_DATABASE_MODEL/comments.sql

commit;

