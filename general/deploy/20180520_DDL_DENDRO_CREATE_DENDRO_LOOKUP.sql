-- Deploy sead_db_change_control:CS_DENDRO_20190520_CREATE_DENDRO_LOOKUP to pg

begin;

do $$
begin
	begin
    
        if sead_utility.table_exists('public'::text, 'tbl_dendro_lookup'::text) = true then
            raise exception sqlstate 'GUARD';
        end if;
        
        create table tbl_dendro_lookup (
            dendro_lookup_id serial primary key,
            method_id int4,
            name varchar collate "pg_catalog"."default" not null,
            description text collate "pg_catalog"."default",
            date_updated timestamptz(6) default now(),
            constraint "fk_dendro_lookup_method_id"
                foreign key ("method_id") references tbl_methods (method_id)
                    on delete no action on update no action
        );
        
        alter table tbl_dendro
            drop constraint if exists "fk_dendro_dendro_measurement_id",
            drop column "dendro_measurement_id",
            add column "dendro_lookup_id" int4 not null,
            add constraint "fk_dendro_dendro_lookup_id"
                foreign key ("dendro_lookup_id") references tbl_dendro_lookup (dendro_lookup_id)
                    on delete no action on update no action;

        alter table tbl_dendro_lookup owner to "sead_master";
        
        drop table if exists "public"."tbl_dendro_measurement_lookup";
        
        comment on table tbl_dendro_lookup is 'type=lookup';

    exception when sqlstate 'GUARD' then
        raise notice 'already executed';
    end;
    
end $$;

commit;
