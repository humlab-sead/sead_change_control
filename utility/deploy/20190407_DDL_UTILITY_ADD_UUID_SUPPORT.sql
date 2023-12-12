-- Deploy utility: 20190407_DDL_UTILITY_ADD_UUID_SUPPORT

begin;

-- https://stackoverflow.com/questions/31247735/how-to-create-guid-in-postgresql

create extension if not exists "uuid-ossp" schema public;

commit;
