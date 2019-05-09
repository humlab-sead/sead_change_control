-- Deploy sead_db_change_control:ADD_UUID_SUPPORT to pg

begin;

-- https://stackoverflow.com/questions/31247735/how-to-create-guid-in-postgresql

create extension if not exists "uuid-ossp" schema public;

commit;
