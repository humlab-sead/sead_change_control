-- Deploy sead_db_change_control:CSR_20190408_REFACTOR_PROJECT_STAGES to pg

begin;

    do $$
    begin

        if not exists (select 1 from pg_class where relname = 'tbl_project_stages_project_stage_id_seq' )
        then
            create sequence tbl_project_stages_project_stage_id_seq;
        end if;

        alter table tbl_project_stages
            alter column "project_stage_id"
                set default nextval('tbl_project_stages_project_stage_id_seq'::regclass);

        select setval('tbl_project_stages_project_stage_id_seq', coalesce((select max(project_stage_id)+1 from tbl_project_stages), 1), false);

    end $$ language plpgsql;

commit;
