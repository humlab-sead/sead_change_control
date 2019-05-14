-- Deploy sead_db_change_control:CSR_20190408_REFACTOR_SAMPLE_COORDINATES to pg

begin;

    do $$
    begin

        if not exists (select 1 from pg_class where relname = 'tbl_sample_coordinates_sample_coordinate_id_seq' )
        then
            create sequence tbl_sample_coordinates_sample_coordinate_id_seq;
        end if;

        alter table tbl_sample_coordinates
            alter column "sample_coordinate_id"
                set default nextval('tbl_sample_coordinates_sample_coordinate_id_seq'::regclass);

        select setval('tbl_sample_coordinates_sample_coordinate_id_seq', coalesce((select max(sample_coordinate_id)+1 from tbl_sample_coordinates), 1), false);

    end $$ language plpgsql;

commit;
