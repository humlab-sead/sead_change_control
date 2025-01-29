-- Deploy utility: 20240530_DDL_UDF_DROP_TABLE_SCRIPT

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2024-05-30
  Description   UDF that generates drop table script
  Issue         https://github.com/humlab-sead/sead_change_control/issues/282
  Prerequisites 
  Reviewer      
  Approver      
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

-- select sead_utility.generate_drop_table_script('tbl_dendro_measurements')
-- drop function if exists sead_utility.generate_drop_table_script(p_table_name character varying);
create or replace function sead_utility.generate_drop_table_script(p_table_name text)
    returns text
as $$
declare v_drop_script text;
declare v_entity_name text;
declare v_view_name text;
begin

    v_entity_name = clearing_house.fn_sead_table_entity_name(p_table_name::name)::character varying;
    v_view_name = replace(p_table_name, 'tbl_', 'view_')::character varying;

    begin
        
        if sead_utility.table_exists('public'::text, p_table_name) = FALSE then
            raise exception sqlstate 'GUARD';
        end if;

        v_drop_script = format('

drop function if exists clearing_house_commit.resolve_%3$s(int);
drop view if exists clearing_house.%2$s;
drop table if exists clearing_house.%1$s;
delete from clearing_house.tbl_clearinghouse_submission_tables where table_name_underscored = ''%1$s'';
delete from clearing_house_commit.tbl_sead_table_keys where table_name = ''%1$s'';

drop view if exists postgrest_api.%1$s;
drop view if exists postgrest_default_api.%3$s;

delete from facet.table_relation
    where source_table_id in (
        select table_id
        from facet.table
        where table_or_udf_name = ''%1$s''
    ) or 
    target_table_id in (
        select table_id
        from facet.table
        where table_or_udf_name = ''%1$s''
    )
    ;

delete from facet.facet_table
    where table_id in (
        select table_id
        from facet.table
        where table_or_udf_name = ''%1$s''
    );

delete from facet.table
    where table_or_udf_name = ''%1$s'';

drop table if exists public."%1$s";
            
        ', p_table_name, v_view_name, v_entity_name);

        -- raise notice '%', v_drop_script;
        return v_drop_script;


    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
        return null;
    end;

end $$ language plpgsql;
