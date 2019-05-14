-- Deploy sead_db_change_control:CS_SITE_20180601_ALTER_TYPE to pg

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

begin;
do $$
begin

    begin
    
        alter table tbl_dimensions ALTER COLUMN "dimension_abbrev" TYPE character varying(16) COLLATE "pg_catalog"."default";
        alter table tbl_sample_alt_refs ALTER COLUMN "alt_ref" TYPE character varying(60) COLLATE "pg_catalog"."default";
        alter table tbl_sites ALTER COLUMN "site_name" TYPE character varying(60) COLLATE "pg_catalog"."default";

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
