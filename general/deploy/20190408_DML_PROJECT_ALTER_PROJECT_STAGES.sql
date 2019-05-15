-- Deploy sead_db_change_control:CSR_20190408_REFACTOR_PROJECT_STAGES to pg

do $$
begin
    perform sead_utility.set_as_serial('tbl_project_stages', 'project_stage_id');
end $$;