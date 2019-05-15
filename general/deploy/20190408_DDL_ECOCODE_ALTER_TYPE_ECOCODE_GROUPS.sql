-- Deploy sead_db_change_control:CSR_20190408_ALTER_TYPE_ECOCODE_GROUPS to pg

/****************************************************************************************************************
  Author        
  Date          
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
    
        if sead_utility.column_exists('public'::text, 'tbl_ecocode_groups'::text, 'name'::text) = FALSE then
        
            alter table "public"."tbl_ecocode_groups"
                add column "name" varchar(200) collate "pg_catalog"."default" default null::character varying;
                
            update "public"."tbl_ecocode_groups" set "name" = "label";
            
        end if;
        
        if sead_utility.column_exists('public'::text, 'tbl_ecocode_groups'::text, 'abbreviation'::text) = FALSE then
            alter table "public"."tbl_ecocode_groups"
                add column "abbreviation" varchar(50) collate "pg_catalog"."default" default null::character varying;
        end if;
        
        alter table "public"."tbl_ecocode_groups"
            drop column if exists "label";

        alter table tbl_ecocode_groups
            alter column "name" TYPE varchar(200) COLLATE "pg_catalog"."default",
            alter column "abbreviation" TYPE varchar(50) COLLATE "pg_catalog"."default";
        
        drop index if exists "public"."tbl_ecocode_groups_idx_label";
        create index "tbl_ecocode_groups_idx_label" on "public"."tbl_ecocode_groups" (
          "name" collate "pg_catalog"."default" "pg_catalog"."text_ops" asc nulls last
        );

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
