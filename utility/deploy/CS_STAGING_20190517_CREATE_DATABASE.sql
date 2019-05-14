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
where datname in ('sead_master_9', 'sead_staging');

drop database if exists sead_staging;

\connect postgres

create database sead_staging with template = sead_master_9 encoding = 'utf8';

\connect postgres

ALTER DATABASE sead_staging OWNER TO sead_master;

*/
