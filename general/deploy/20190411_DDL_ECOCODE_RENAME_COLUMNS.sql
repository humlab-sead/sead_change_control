-- Deploy sead_change_control:CS_ECOCODE_20190411_RENAME_COLUMNS to pg

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
    
        if sead_utility.column_exists('public'::text, 'tbl_ecocode_definitions'::text, 'name'::text) = TRUE then
            raise exception 'GUARD';
        end if;
        
        drop index if exists tbl_ecocode_groups_idx_label;

        alter table tbl_ecocode_definitions rename column "label" to "name";

        alter table tbl_ecocode_groups alter  column "label" type character varying(200) default NULL::character varying;
        alter table tbl_ecocode_groups rename column "label" to "name";
        alter table tbl_ecocode_groups add    column "abbreviation" character varying(255);
        
        create index tbl_ecocode_groups_idx_name ON public.tbl_ecocode_groups USING btree (name);

    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;
commit;
