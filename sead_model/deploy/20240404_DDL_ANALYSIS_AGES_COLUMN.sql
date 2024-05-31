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
  Notes
*****************************************************************************************************************/


begin;
do $$
begin

    set client_encoding = 'UTF8';

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


    alter table public.tbl_dendro_dates
        drop column if exists age_range;

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


end $$;
commit;


