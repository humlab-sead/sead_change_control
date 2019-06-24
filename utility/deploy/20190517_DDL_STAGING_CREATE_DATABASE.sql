-- Deploy utility:CS_STAGING_20190517_CREATE_DATABASE to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

/*
\connect postgres

select pg_terminate_backend(pid)
from pg_stat_activity
where datname in ('sead_staging_tng');

\connect postgres
drop database sead_staging_tng;

create database sead_staging_facet with template = sead_staging_tng_template encoding = 'utf8';


ALTER DATABASE sead_staging_facet OWNER TO sead_master;
\connect postgres



*/
