/*********************************************************************************************************************************
 **  Function    create_clearinghouse_model
 **  When        2013-10-17
 **  What        Creates DB clearing_house specific schema objects (not entity objects) for Clearing House application
 **  Who         Roger Mähler
 **  Note
 **  Uses
 **  Used By     Clearing House server installation. DBA.
 **  Revisions
 **********************************************************************************************************************************/
-- Select clearing_house.fn_dba_create_clearing_house_db_model();
-- Drop Function If Exists fn_dba_create_clearing_house_db_model(BOOLEAN);
create or replace procedure clearing_house.create_clearinghouse_model(p_drop_tables boolean = false)
    as $$
    begin
        if(p_drop_tables) then
            drop table if exists clearing_house.tbl_clearinghouse_activity_log;
            drop table if exists clearing_house.tbl_clearinghouse_submissions;
            drop table if exists clearing_house.tbl_clearinghouse_signal_log;

            drop table if exists clearing_house.tbl_clearinghouse_submissions;
            drop table if exists clearing_house.tbl_clearinghouse_reject_cause_types;
            drop table if exists clearing_house.tbl_clearinghouse_reject_causes;
            drop table if exists clearing_house.tbl_clearinghouse_users;
            drop table if exists clearing_house.tbl_clearinghouse_user_roles;
            drop table if exists clearing_house.tbl_clearinghouse_data_provider_grades;
            drop table if exists clearing_house.tbl_clearinghouse_submission_states;

        end if;

        if(p_drop_tables) then
            drop table if exists clearing_house.tbl_clearinghouse_submission_xml_content_values;
            drop table if exists clearing_house.tbl_clearinghouse_submission_xml_content_records;
            drop table if exists clearing_house.tbl_clearinghouse_submission_xml_content_columns;
            drop table if exists clearing_house.tbl_clearinghouse_submission_xml_content_tables;
            drop table if exists clearing_house.tbl_clearinghouse_submission_tables;

        end if;

        create table if not exists clearing_house.tbl_clearinghouse_settings(
            setting_id serial not null,
            setting_group character varying(255 ) not null,
            setting_key character varying(255 ) not null,
            setting_value text not null,
            setting_datatype text not null,
            constraint pk_tbl_clearinghouse_settings primary key(setting_id )
        );

        drop index if exists clearing_house.idx_tbl_clearinghouse_settings_key;
        create unique index idx_tbl_clearinghouse_settings_key on clearing_house.tbl_clearinghouse_settings(setting_key);

            drop index if exists clearing_house.idx_tbl_clearinghouse_settings_group;
            create index idx_tbl_clearinghouse_settings_group on clearing_house.tbl_clearinghouse_settings(setting_group);

                create table if not exists clearing_house.tbl_clearinghouse_info_references(
                    info_reference_id serial not null,
                    info_reference_type character varying(255 ) not null,
                    display_name character varying(255 ) not null,
                    href character varying(255 ),
                    constraint pk_tbl_clearinghouse_info_references primary key(info_reference_id )
                );

                create table if not exists clearing_house.tbl_clearinghouse_sessions(
                    session_id serial not null,
                    user_id int not null default(0 ),
                    ip character varying(255 ),
                    start_time date not null,
                    stop_time date,
                    constraint pk_tbl_clearinghouse_sessions_session_id primary key(session_id )
                );

                create table if not exists clearing_house.tbl_clearinghouse_signals(
                    signal_id serial not null,
                    use_case_id int not null default(0 ),
                    recipient_user_id int not null default(0 ),
                    recipient_address text not null,
                    signal_time date not null,
                    subject text,
                    body text,
                    status text,
                    constraint pk_clearinghouse_signals_signal_id primary key(signal_id )
                );


                /*********************************************************************************************************************************
                 ** activity
                 **********************************************************************************************************************************/
                create table if not exists clearing_house.tbl_clearinghouse_use_cases(
                    use_case_id int not null,
                    use_case_name character varying(255 ) not null,
                    entity_type_id int not null default(0 ),
                    constraint pk_tbl_clearinghouse_use_cases primary key(use_case_id )
                );

                create table if not exists clearing_house.tbl_clearinghouse_activity_log(
                    activity_log_id serial not null,
                    use_case_id int not null default(0 ),
                    user_id int not null default(0 ),
                    session_id int not null default(0 ),
                    entity_type_id int not null default(0 ),
                    entity_id int not null default(0 ),
                    execute_start_time date not null,
                    execute_stop_time date,
                    status_id int not null default(0 ),
                    activity_data text null,
                    message text not null default('' ),
                    constraint pk_activity_log_id primary key(activity_log_id )
                );

                drop index if exists clearing_house.idx_clearinghouse_activity_entity_id;
                create index idx_clearinghouse_activity_entity_id on clearing_house.tbl_clearinghouse_activity_log(entity_type_id, entity_id);

                    create table if not exists clearing_house.tbl_clearinghouse_signal_log(
                        signal_log_id serial not null,
                        use_case_id int not null,
                        signal_time date not null,
                        email text not null,
                        cc text not null,
                        subject text not null,
                        body text not null,
                        constraint pk_signal_log_id primary key(signal_log_id )
                    );


                    /*********************************************************************************************************************************
                     ** Users
                     **********************************************************************************************************************************/
                    create table if not exists clearing_house.tbl_clearinghouse_data_provider_grades(
                        grade_id int not null,
                        description character varying(255 ) not null,
                        constraint pk_grade_id primary key(grade_id )
                    );

                    create table if not exists clearing_house.tbl_clearinghouse_user_roles(
                        role_id int not null,
                        role_name character varying(255 ) not null,
                        constraint pk_role_id primary key(role_id )
                    );

                    create table if not exists clearing_house.tbl_clearinghouse_users(
                        user_id serial not null,
                        user_name character varying(255 ) not null,
                        full_name character varying(255 ) not null default('' ),
                        password character varying(255 ) not null,
                        email character varying(1024 ) not null default('' ),
                        signal_receiver boolean not null default(false ),
                        role_id int not null default(1 ),
                        data_provider_grade_id int not null default(2 ),
                        is_data_provider boolean not null default(false ),
                        create_date date not null,
                        constraint pk_user_id primary key(user_id ),
                        constraint fk_tbl_user_roles_role_id foreign key(role_id ) references clearing_house.tbl_clearinghouse_user_roles(role_id ) match simple on update no action on delete no action,
                        constraint fk_tbl_data_provider_grades_grade_id foreign key(data_provider_grade_id ) references clearing_house.tbl_clearinghouse_data_provider_grades(grade_id ) match simple on update no action on delete no action
                    );


                    /*********************************************************************************************************************************
                     ** Submissions
                     **********************************************************************************************************************************/
                    create table if not exists clearing_house.tbl_clearinghouse_submission_states(
                        submission_state_id int not null,
                        submission_state_name character varying(255 ) not null,
                        constraint pk_submission_state_id primary key(submission_state_id )
                    );

                    create table if not exists clearing_house.tbl_clearinghouse_submissions(
                        submission_id serial not null,
                        submission_state_id integer not null,
                        data_types character varying(255 ),
                        upload_user_id integer not null,
                        upload_date date not null default now( ),
                        upload_content text,
                        "xml" xml,
                        status_text text,
                        claim_user_id integer,
                        claim_date_time date,
                        constraint pk_submission_id primary key(submission_id ),
                        constraint fk_tbl_submissions_user_id_user_id foreign key(claim_user_id ) references clearing_house.tbl_clearinghouse_users(user_id ) match simple on update no action on delete no action,
                        constraint fk_tbl_submissions_state_id_state_id foreign key(submission_state_id ) references clearing_house.tbl_clearinghouse_submission_states(submission_state_id ) match simple on update no ACTION on delete no ACTION
                    );


                    /*********************************************************************************************************************************
                     ** XML content tables - intermediate tables using during process
                     **********************************************************************************************************************************/
                    create table if not exists clearing_house.tbl_clearinghouse_submission_tables(
                        table_id serial not null,
                        table_name character varying(255 ) not null,
                        table_name_underscored character varying(255 ) not null,
                        constraint pk_tbl_clearinghouse_submission_tables primary key(table_id )
                    );

                    drop index if exists clearing_house.idx_tbl_clearinghouse_submission_tables_name1;
                    create unique index idx_tbl_clearinghouse_submission_tables_name1 on clearing_house.tbl_clearinghouse_submission_tables(table_name);

                        drop index if exists clearing_house.idx_tbl_clearinghouse_submission_tables_name2;
                        create unique index idx_tbl_clearinghouse_submission_tables_name2 on clearing_house.tbl_clearinghouse_submission_tables(table_name_underscored);

                            create table if not exists clearing_house.tbl_clearinghouse_submission_xml_content_tables(
                                content_table_id serial not null,
                                submission_id int not null,
                                table_id int not null,
                                record_count int not null,
                                constraint pk_tbl_submission_xml_content_meta_tables_table_id primary key(content_table_id ),
                                constraint fk_tbl_clearinghouse_submission_xml_content_tables foreign key(table_id ) references clearing_house.tbl_clearinghouse_submission_tables(table_id ) match simple on update no action on delete cascade,
                                constraint fk_tbl_clearinghouse_submission_xml_content_tables_sid foreign key(submission_id ) references clearing_house.tbl_clearinghouse_submissions(submission_id ) match simple on update no action on delete cascade
                            );

                            drop index if exists clearing_house.fk_idx_tbl_submission_xml_content_tables_table_name;
                            create unique index fk_idx_tbl_submission_xml_content_tables_table_name on clearing_house.tbl_clearinghouse_submission_xml_content_tables(submission_id, table_id);

                                create table if not exists clearing_house.tbl_clearinghouse_submission_xml_content_columns(
                                    column_id serial not null,
                                    submission_id int not null,
                                    table_id int not null,
                                    column_name character varying(255 ) not null,
                                    column_name_underscored character varying(255 ) not null,
                                    data_type character varying(255 ) not null,
                                    fk_flag boolean not null,
                                    fk_table character varying(255 ) null,
                                    fk_table_underscored character varying(255 ) null,
                                    constraint pk_tbl_submission_xml_content_columns_column_id primary key(column_id ),
                                    constraint fk_tbl_submission_xml_content_columns_table_id foreign key(table_id ) references clearing_house.tbl_clearinghouse_submission_tables(table_id ) match simple on update no action on delete cascade
                                );

                                drop index if exists clearing_house.idx_tbl_submission_xml_content_columns_submission_id;
                                create unique index idx_tbl_submission_xml_content_columns_submission_id on clearing_house.tbl_clearinghouse_submission_xml_content_columns(submission_id, table_id, column_name);

                                    create table if not exists clearing_house.tbl_clearinghouse_submission_xml_content_records(
                                        record_id serial not null,
                                        submission_id int not null,
                                        table_id int not null,
                                        local_db_id int null,
                                        public_db_id int null,
                                        constraint pk_tbl_submission_xml_content_records_record_id primary key(record_id ),
                                        constraint fk_tbl_submission_xml_content_records_table_id foreign key(table_id ) references clearing_house.tbl_clearinghouse_submission_tables(table_id ) match simple on update no action on delete cascade
                                    );

                                    drop index if exists clearing_house.idx_tbl_submission_xml_content_records_submission_id;
                                    create unique index idx_tbl_submission_xml_content_records_submission_id on clearing_house.tbl_clearinghouse_submission_xml_content_records(submission_id, table_id, local_db_id);

                                        create table if not exists clearing_house.tbl_clearinghouse_submission_xml_content_values(
                                            value_id serial not null,
                                            submission_id int not null,
                                            table_id int not null,
                                            local_db_id int not null,
                                            column_id int not null,
                                            fk_flag boolean null,
                                            fk_local_db_id int null,
                                            fk_public_db_id int null,
                                            value text null,
                                            constraint pk_tbl_submission_xml_content_record_values_value_id primary key(value_id ),
                                            constraint fk_tbl_submission_xml_content_meta_record_values_table_id foreign key(table_id ) references clearing_house.tbl_clearinghouse_submission_tables(table_id ) match simple on update no action on delete cascade
                                        );

                                        drop index if exists clearing_house.idx_tbl_submission_xml_content_record_values_column_id;
                                        create unique index idx_tbl_submission_xml_content_record_values_column_id on clearing_house.tbl_clearinghouse_submission_xml_content_values(submission_id, table_id, local_db_id, column_id);

                                            create table if not exists "clearing_house"."tbl_clearinghouse_sead_create_table_log"(
                                                "create_script" text collate "pg_catalog"."default",
                                                "drop_script" text collate "pg_catalog"."default"
                                            );

                                            create table if not exists "clearing_house"."tbl_clearinghouse_sead_create_view_log"(
                                                "create_script" text collate "pg_catalog"."default",
                                                "drop_script" text collate "pg_catalog"."default"
                                            );

                                            create table if not exists clearing_house.tbl_clearinghouse_submission_tables(
                                                table_id integer not null default nextval('clearing_house.tbl_clearinghouse_submission_tables_table_id_seq'::regclass ),
                                                table_name character varying(255 ) collate pg_catalog."default" not null,
                                                table_name_underscored character varying(255 ) collate pg_catalog."default" not null,
                                                constraint pk_tbl_clearinghouse_submission_tables primary key(table_id )
                                            );

                                            drop index if exists clearing_house.idx_tbl_clearinghouse_submission_tables_name1;
                                            create unique index idx_tbl_clearinghouse_submission_tables_name1 on clearing_house.tbl_clearinghouse_submission_tables using btree(table_name collate pg_catalog."default") tablespace pg_default;

                                                drop index if exists clearing_house.idx_tbl_clearinghouse_submission_tables_name2;
                                                create unique index idx_tbl_clearinghouse_submission_tables_name2 on clearing_house.tbl_clearinghouse_submission_tables using btree(table_name_underscored collate pg_catalog."default") tablespace pg_default;

                                                    create table if not exists clearing_house.tbl_clearinghouse_accepted_submissions(
                                                        accepted_submission_id serial not null,
                                                        process_state_id bool not null,
                                                        submission_id int,
                                                        upload_file text,
                                                        accept_user_id integer,
                                                        constraint pk_tbl_clearinghouse_accepted_submissions primary key(accepted_submission_id )
                                                    );

                                                    create table if not exists clearing_house.tbl_clearinghouse_reject_entity_types(
                                                        entity_type_id int not null,
                                                        table_id int null,
                                                        entity_type character varying(255 ) not null,
                                                        constraint pk_tbl_clearinghouse_reject_entity_types primary key(entity_type_id )
                                                    );

                                                    drop index if exists clearing_house.fk_clearinghouse_reject_entity_types;
                                                    create index fk_clearinghouse_reject_entity_types on clearing_house.tbl_clearinghouse_reject_entity_types(table_id);

                                                        create table if not exists clearing_house.tbl_clearinghouse_submission_rejects(
                                                            submission_reject_id serial not null,
                                                            submission_id int not null,
                                                            site_id int not null default(0 ),
                                                            entity_type_id int not null,
                                                            reject_scope_id int not null,
                                                            /* 0, 1=specific, 2=general */
                                                            reject_description text null,
                                                            constraint pk_tbl_clearinghouse_submission_rejects primary key(submission_reject_id ),
                                                            constraint fk_tbl_clearinghouse_submission_rejects_submission_id foreign key(submission_id ) references clearing_house.tbl_clearinghouse_submissions(submission_id ) match simple on update no action on delete cascade
                                                        );

                                                        drop index if exists clearing_house.fk_clearinghouse_submission_rejects;
                                                        create index fk_clearinghouse_submission_rejects on clearing_house.tbl_clearinghouse_submission_rejects(submission_id);

                                                            create table if not exists clearing_house.tbl_clearinghouse_submission_reject_entities(
                                                                reject_entity_id serial not null,
                                                                submission_reject_id int not null,
                                                                local_db_id int not null,
                                                                constraint pk_tbl_clearinghouse_submission_reject_entities primary key(reject_entity_id ),
                                                                constraint fk_tbl_clearinghouse_submission_reject_entities foreign key(submission_reject_id ) references clearing_house.tbl_clearinghouse_submission_rejects(submission_reject_id ) match simple on update no action on delete cascade
                                                            );

                                                            drop index if exists clearing_house.fk_clearinghouse_submission_reject_entities_submission;
                                                            create index fk_clearinghouse_submission_reject_entities_submission on clearing_house.tbl_clearinghouse_submission_reject_entities(submission_reject_id);

                                                                drop index if exists clearing_house.fk_clearinghouse_submission_reject_entities_local_db_id;
                                                                create index fk_clearinghouse_submission_reject_entities_local_db_id on clearing_house.tbl_clearinghouse_submission_reject_entities(local_db_id);

                                                                    create table if not exists clearing_house.tbl_clearinghouse_reports(
                                                                        report_id int not null,
                                                                        report_name character varying(255 ),
                                                                        report_procedure text not null,
                                                                        constraint pk_tbl_clearinghouse_reports primary key(report_id )
                                                                    );

                                                                    create table if not exists clearing_house.tbl_clearinghouse_sead_unknown_column_log(
                                                                        column_log_id serial not null,
                                                                        submission_id int,
                                                                        table_name text,
                                                                        column_name text,
                                                                        column_type text,
                                                                        alter_sql text,
                                                                        constraint pk_tbl_clearinghouse_sead_unknown_column_log primary key(column_log_id )
                                                                    );

end
$$
language plpgsql;

do $$
begin
    if not exists(
        select
            1
        from
            pg_type
            join pg_namespace on pg_type.typnamespace = pg_namespace.oid
        where
            typname = 'transport_type'
            and nspname = 'clearing_house') then
    create domain clearing_house.transport_type char check(value is null
        or value in('C', 'U', 'D')) default null null;
end if;
end
$$
language plpgsql;

