-- Deploy sead_db_change_control:ADD_UUID_SUPPORT to pg

BEGIN;

-- https://stackoverflow.com/questions/31247735/how-to-create-guid-in-postgresql

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" SCHEMA public;

COMMIT;
