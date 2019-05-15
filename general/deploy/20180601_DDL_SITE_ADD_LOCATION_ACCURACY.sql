-- Deploy sead_db_change_control:CS_SITE_20180601_ADD_LOCATION_ACCURACY to pg

begin;

do $$
begin
	begin
    
        if sead_utility.column_exists('public'::text, 'tbl_sites'::text, 'site_location_accuracy'::text) = true then
            raise exception sqlstate 'GUARD';
        end if;
        
        alter table "tbl_sites" add column "site_location_accuracy" varchar collate "pg_catalog"."default";

        comment on column "tbl_sites"."site_location_accuracy"
            is 'accuracy of highest location resolution level. e.g. nearest settlement, lake, bog, ancient monument, approximate';

    exception when sqlstate 'GUARD' then
        raise notice 'already executed';
    end;
    
end $$;

commit;
