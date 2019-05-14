-- Deploy sead_db_change_control:CS_ANALYSIS_ENTITY_20170911_ALTER_AGES_PRECISION to pg

/****************************************************************************************************************
  Author        Phil Buckland
  Date          2017-09.11
  Description   Changed numeric ranges of values to 20,5 to match tbl_relative_ages
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
    
        ALTER TABLE "public"."tbl_analysis_entity_ages"
            ALTER COLUMN "age" TYPE numeric(20,5),
            ALTER COLUMN "age_older" TYPE numeric(20,5),
            ALTER COLUMN "age_younger" TYPE numeric(20,5);

        COMMENT ON TABLE "public"."tbl_analysis_entity_ages" IS '20170911PIB: Changed numeric ranges of values to 20,5 to match tbl_relative_ages
            20120504PIB: Should this be connected to physical sample instead of analysis entities? Allowing multiple ages (from multiple dates) for a sample. At the moment it requires a lot of backtracing to find a sample''s age... but then again, it allows... what, exactly?';        

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;


