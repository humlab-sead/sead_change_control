-- Deploy utility: 20190517_DDL_STAGING_CREATE_DATABASE
/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-05-17
  Description   Create a new staging database
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
