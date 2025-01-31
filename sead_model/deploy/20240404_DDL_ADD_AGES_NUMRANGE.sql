-- Deploy sead_model: 20240404_DDL_ADD_AGES_NUMRANGE

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-04-04
  Description   Add age ranges to analysis ages and dendro dates.
  Issue         https://github.com/humlab-sead/sead_change_control/issues/286
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes         tbl_analysis_entity_ages.age_range added as a backported update to SEAD_DATABASE_MODEL/tables.sql
*****************************************************************************************************************/


begin;
do $$
begin

	raise notice '20240404_DDL_ADD_AGES_NUMRANGE has been backported to SEAD model and is now idempotent';
	
    if not exists (
        select * from information_schema.columns
        where TRUE
		  and "table_schema" = 'public'
		  and "table_name" = 'tbl_analysis_entity_ages'
          and "column_name" = 'age_range'
          and "data_type" = 'int4range'
    ) then
	    alter table public.tbl_analysis_entity_ages
	        drop column if exists age_range;
	
		/* BP (Before Present), age_older >= age_younger */
	    alter table public.tbl_analysis_entity_ages
	        add column age_range int4range null
	            generated always as (
	                case when age_younger is null and age_older is null then null
	                else int4range(
	                    coalesce(age_younger::int, age_older::int),
	                    coalesce(age_older::int, age_younger::int) + 1
	                )
	            	end) stored;
	end if;

    if not exists (
        select * from information_schema.columns
        where TRUE
		  and "table_schema" = 'public'
		  and "table_name" = 'tbl_dendro_dates'
          and "column_name" = 'age_range'
          and "data_type" = 'int4range'
    ) then
	
		/* BCE/CE age_older <= age_younger */
	    alter table public.tbl_dendro_dates
	        add column age_range int4range null
	            generated always as (
	                case when age_younger is null and age_older is null then null
	                else int4range(
	                    coalesce(age_older::int, age_younger::int),
	                    coalesce(age_younger::int, age_older::int) + 1
	                )
	            	end) stored;
	end if;
	
end $$;
commit;


