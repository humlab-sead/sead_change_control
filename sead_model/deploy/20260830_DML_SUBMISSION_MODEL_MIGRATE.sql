-- Deploy sead_model: 20260830_DML_SUBMISSION_MODEL_MIGRATE

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2026-08-30
  Description   Migrate existing data to fit new submission model
  Issue         https://github.com/humlab-sead/sead_change_control/issues/450
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes         Migrate existing data to fit new submission model.
*****************************************************************************************************************/

set client_encoding = 'UTF8';
set client_min_messages = warning;

create or replace function reset_sequence( p_table_name text, p_column_name text )
    returns void language plpgsql as $$
declare
    v_sequence_name text;
    v_max_id bigint;
begin
    v_sequence_name := pg_get_serial_sequence(p_table_name, p_column_name);
    execute format( 'select max(%I) from %I', p_column_name, p_table_name ) into v_max_id;
    perform setval( v_sequence_name, coalesce(v_max_id, 1), v_max_id is not null );
end;
$$;

create or replace function parse_legacy_submission_date(p_date_submitted text)
returns date
language sql
immutable
as $$
    select case
        when btrim(p_date_submitted) ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
            then substring(btrim(p_date_submitted) from 1 for 10)::date
        when btrim(p_date_submitted) ~ '^[0-9]{4}-[0-9]{2}$'
            then (btrim(p_date_submitted) || '-01')::date
        when btrim(p_date_submitted) ~ '^[0-9]{4}$'
            then (btrim(p_date_submitted) || '-01-01')::date
        else null
    end;
$$;

create or replace function migrate_legacy_submission_date()
returns void language plpgsql 
as $$
declare
    legacy_provider_count integer;
    migrated_provider_count integer;
    migrated_submission_count integer;
begin

    begin

        /* Migrate historical submission data

| submission_id | submission_state_id | biblio_id | upload_date | submission_date | submission_identifier                            | issue_identifier                                              | author | notes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | data_provider_id | submission_name                                | source_name                                                                        | data_types                  | submission_uuid |
|---------------|---------------------|-----------|-------------|-----------------|--------------------------------------------------|---------------------------------------------------------------|--------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|------------------------------------------------|------------------------------------------------------------------------------------|-----------------------------|-----------------|
| 3             | 2                   |           |             | 2023-12-19      | 20231211_DML_SUBMISSION_BUGS_20231219_COMMIT     | https://github.com/humlab-sead/sead_change_control/issues/162 |        | Full (inital) non-incremental import of BugsCEP data version 20230705.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | 1                | BugsCEP submission (Shape Shifter)             | bugsdata_20230705.mdb                                                              | palaeoentomology,entomology | z               |
| 1             | 2                   |           |             | 2010-01-01      | 20100101_DML_SUBMISSION_MAL_000_COMMIT           | https://github.com/humlab-sead/sead_change_control/issues/221 |        | Initial MAL data (equivalent to sead_master_9).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | 2                | Environmental Archaeology Lab (Umeå)/MAL       | sead_master_9                                                                      | dendrochronology            |                 |
| 4             | 2                   |           |             |                 | 20200109_DML_SUBMISSION_CERAMICS_COMMIT          | https://github.com/humlab-sead/sead_change_control/issues/205 |        | Related to https://github.com/humlab-sead/sead_change_control/issues/20                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | 3                | The Laboratory for Ceramic Research (Lund/KFL) | ceramics_data_latest_20200107.xlsx                                                 | ceramics                    |                 |
| 5             | 2                   |           |             |                 | 20240119_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT  | https://github.com/humlab-sead/sead_change_control/issues/218 |        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | 10               | Dendrochronology  pilot project (Lund)         | building_dendro_2023-12_import_v6.xlsx                                             | dendrochronology            |                 |
| 7             | 2                   |           | 2025-02-17  | 2024-11-14      | 20250108_DML_SUBMISSION_ADNA_001_COMMIT          | https://github.com/humlab-sead/sead_change_control/issues/329 |        | Import options:<br>check_only: false<br>data_types: adna<br>dbname: sead_staging_202414_adna<br>dump_to_csv: true<br>filename: data/input/SEAD_aDNA_data_20241114_RM.xlsx<br>output_folder: ./data/output/<br>submission_id: <br>submission_name: 20250108_DML_SUBMISSION_ADNA_001_COMMIT<br>table_names: <br>timestamp: false<br>transfer_format: csv<br>user:                                                                                                                                                                                                                                                                                                                                                      | 12               | SciLifelab Ancient DNA Pilot Project           | https://github.com/user-attachments/files/18618551/SEAD_aDNA_data_20241114_RM.xlsx | adna                        |                 |
| 10            | 2                   |           | 2025-03-07  | 2023-12-31      | 20241213_DML_SUBMISSION_LUND_LIVING_TREES_COMMIT | https://github.com/humlab-sead/sead_change_control/issues/348 |        | Living tree data from Lund Dendrochronology, 2023-12<br>check_only: false<br>data_types: dendrochronology<br>dbname: sead_staging_202502_living_trees<br>dump_to_csv: true<br>explode: true<br>filename: /home/roger/source/sead_clearinghouse_import//data/dendro/lund_living_trees_20241213/lund_living_trees_20241213_RM.xlsx<br>host: null<br>output_folder: /home/roger/source/sead_clearinghouse_import//data/dendro/lund_living_trees_20241213/output<br>port: 5432<br>register: true<br>skip: false<br>submission_id: null<br>submission_name: 20241213_DML_LUND_LIVING_TREES_COMMIT<br>table_names: null<br>tidy_xml: false<br>timestamp: false<br>transfer_format: csv<br>user: null<br>xml_filename: null | 10               | Lund Living Trees                              | lund_living_trees_20241213_RM.xlsx                                                 | dendrochronology            |                 |
        
        */

        if (select count(*) from tbl_data_providers) > 0 then
            raise exception SQLSTATE 'GUARD';
        end if;


        if not exists (select 1 from tbl_contact_types where contact_type_id = 2)
           or not exists (select 1 from tbl_contact_types where contact_type_id = 4) then
            raise exception 'Contact types 2 (Analysed by) and 4 (Samples taken by) are required';
        end if;


        /*********************************************************************************************************************
        ** Initialize data providers from tbl_dataset_masters
        **********************************************************************************************************************/

        select count(*) into legacy_provider_count from tbl_dataset_masters;

        insert into tbl_data_providers ( data_provider_id, data_provider_uuid, data_provider_name, notes, contact_id, biblio_id, url )
            select master_set_id, master_set_uuid, master_name, master_notes, contact_id, biblio_id, url
            from tbl_dataset_masters;

        select count(*) into migrated_provider_count from tbl_data_providers;

        if migrated_provider_count <> legacy_provider_count then
            raise exception 'Provider migration count mismatch: expected %, migrated %', legacy_provider_count, migrated_provider_count;
        end if;

        /*********************************************************************************************************************
        ** MAL submission
        **********************************************************************************************************************/

        perform fn_migrate_submission_datasets(
            p_dataset_ids => ARRAY(
                select dataset_id
                from tbl_datasets
                where master_set_id = 2
            ),
            p_data_provider_id => 2,
            p_submission_name => 'Environmental Archaeology Lab (Umeå)/MAL',
            p_submission_id => 1,
            p_submission_state_id => 2,
            p_biblio_id => null,
            p_upload_date => null,
            p_submission_date => '2010-01-01',
            p_submission_identifier => '20100101_DML_SUBMISSION_MAL_000_COMMIT',
            p_issue_identifier => 'https://github.com/humlab-sead/sead_change_control/issues/221',
            p_author => null,
            p_notes => 'Initial MAL data (equivalent to sead_master_9).',
            p_source_name => 'sead_master_9',
            p_data_types => 'archaeobotany,pollen'
        );

        /*********************************************************************************************************************
        ** BugsCEP submission
        **********************************************************************************************************************/

        perform fn_migrate_submission_datasets(
            p_dataset_ids => ARRAY(
                select dataset_id
                from tbl_datasets
                where master_set_id = 1
            ),
            p_submission_id => 2,
            p_data_provider_id => 1,
            p_submission_name => 'BugsCEP submission (Shape Shifter)',
            p_submission_state_id => 2,
            p_biblio_id => null,
            p_upload_date => null,
            p_submission_date => '2023-12-19',
            p_submission_identifier => '20231211_DML_SUBMISSION_BUGS_20231219_COMMIT',
            p_issue_identifier => 'https://github.com/humlab-sead/sead_change_control/issues/162',
            p_author => null,
            p_notes => 'Full (inital) non-incremental import of BugsCEP data version 20230705.',
            p_source_name => 'bugsdata_20230705.mdb',
            p_data_types => 'palaeoentomology,entomology'
        );

        /*********************************************************************************************************************
        ** Ceramics submission
        **********************************************************************************************************************/

        perform fn_migrate_submission_datasets(
            p_dataset_ids => ARRAY(
                select dataset_id
                from tbl_datasets
                where master_set_id = 3
            ),
            p_submission_id => 3,
            p_data_provider_id => 3,
            p_submission_name => 'The Laboratory for Ceramic Research (Lund/KFL)',
            p_submission_state_id => 2,
            p_biblio_id => null,
            p_upload_date => null,
            p_submission_date => null,
            p_submission_identifier => '20200109_DML_SUBMISSION_CERAMICS_COMMIT',
            p_issue_identifier => 'https://github.com/humlab-sead/sead_change_control/issues/205',
            p_author => null,
            p_notes => 'Related to https://github.com/humlab-sead/sead_change_control/issues/20',
            p_source_name => 'ceramics_data_latest_20200107.xlsx',
            p_data_types => 'ceramics'
        );

        /*********************************************************************************************************************
        ** Dendrochronology submission
        **********************************************************************************************************************/

        perform fn_migrate_submission_datasets(
            p_dataset_ids => ARRAY(
                select distinct dataset_id
                from tbl_dendro
                join tbl_analysis_entities using (analysis_entity_id)
                join tbl_datasets using (dataset_id)
                where master_set_id = 10
            ),
            p_submission_id => 4,
            p_data_provider_id => 10,
            p_submission_name => 'Dendrochronology pilot project (Lund)',
            p_submission_state_id => 2,
            p_biblio_id => null,
            p_upload_date => null,
            p_submission_date => null,
            p_submission_identifier => '20240119_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT',
            p_issue_identifier => 'https://github.com/humlab-sead/sead_change_control/issues/218',
            p_author => null,
            p_notes => null,
            p_source_name => 'building_dendro_2023-12_import_v6.xlsx',
            p_data_types => 'dendrochronology'
        );

        /*********************************************************************************************************************
        ** aDNA submission
        **********************************************************************************************************************/

        perform fn_migrate_submission_datasets(
            p_dataset_ids => ARRAY(
                select dataset_id
                from tbl_datasets
                where master_set_id = 12
            ),
            p_submission_id => 5,
            p_data_provider_id => 12,
            p_submission_name => 'SciLifelab Ancient DNA Pilot Project',
            p_submission_state_id => 2,
            p_biblio_id => null,
            p_upload_date => '2025-02-17',
            p_submission_date => '2024-11-14',
            p_submission_identifier => '20250108_DML_SUBMISSION_ADNA_001_COMMIT',
            p_issue_identifier => 'https://github.com/humlab-sead/sead_change_control/issues/329',
            p_author => null,
            p_notes => E'Import options:\ncheck_only: false\ndata_types: adna\ndbname: sead_staging_202414_adna\ndump_to_csv: true\nfilename: data/input/SEAD_aDNA_data_20241114_RM.xlsx\noutput_folder: ./data/output/\nsubmission_id: \nsubmission_name: 20250108_DML_SUBMISSION_ADNA_001_COMMIT\ntable_names: \ntimestamp: false\ntransfer_format: csv\nuser:',
            p_source_name => 'https://github.com/user-attachments/files/18618551/SEAD_aDNA_data_20241114_RM.xlsx',
            p_data_types => 'adna'
        );

        /*********************************************************************************************************************
        ** Lund living trees submission
        **********************************************************************************************************************/
        -- select 27032 + 4534
        -- total        31566
        -- pilot        27032
        -- living tree  4534
        perform fn_migrate_submission_datasets(
            p_dataset_ids => ARRAY(
                select dataset_id
                from tbl_datasets
                where master_set_id = 10
                  and dataset_id not in (
                    select distinct dataset_id
                    from tbl_dendro
                    join tbl_analysis_entities using (analysis_entity_id)
                    join tbl_datasets using (dataset_id)
                    where master_set_id = 10
                )
            ),
            p_submission_id => 6,
            p_data_provider_id => 10,
            p_submission_name => 'Lund Living Trees',
            p_submission_state_id => 2,
            p_biblio_id => null,
            p_upload_date => '2025-03-07',
            p_submission_date => '2023-12-31',
            p_submission_identifier => '20241213_DML_SUBMISSION_LUND_LIVING_TREES_COMMIT',
            p_issue_identifier => 'https://github.com/humlab-sead/sead_change_control/issues/348',
            p_author => null,
            p_notes => E'Living tree data from Lund Dendrochronology, 2023-12\ncheck_only: false\ndata_types: dendrochronology\ndbname: sead_staging_202502_living_trees\ndump_to_csv: true\nexplode: true\nfilename: /home/roger/source/sead_clearinghouse_import//data/dendro/lund_living_trees_20241213/lund_living_trees_20241213_RM.xlsx\nhost: null\noutput_folder: /home/roger/source/sead_clearinghouse_import//data/dendro/lund_living_trees_20241213/output\nport: 5432\nregister: true\nskip: false\nsubmission_id: null\nsubmission_name: 20241213_DML_LUND_LIVING_TREES_COMMIT\ntable_names: null\ntidy_xml: false\ntimestamp: false\ntransfer_format: csv\nuser: null\nxml_filename: null',
            p_source_name => 'lund_living_trees_20241213_RM.xlsx',
            p_data_types => 'dendrochronology'
        );

        alter table tbl_datasets
            alter column submission_id set not null;

        
    exception when sqlstate 'GUARD' then
        raise notice 'ALREADY EXECUTED';
    end;
    
end $$;


create or replace function fn_migrate_submission_datasets(
    p_dataset_ids int[],

    p_submission_id int,
    p_data_provider_id integer, 
    p_submission_name text,
    p_submission_state_id integer,
    p_biblio_id integer DEFAULT NULL,
    p_upload_date date DEFAULT NULL,
    p_submission_date date DEFAULT NULL,
    p_submission_identifier text DEFAULT NULL,
    p_issue_identifier text DEFAULT NULL,
    p_author text DEFAULT NULL,
    p_notes text DEFAULT NULL,
    p_source_name text DEFAULT NULL,
    p_data_types text DEFAULT NULL,
    p_submission_uuid uuid DEFAULT gen_random_uuid()

) returns void language plpgsql
as $$
begin

    /* Parameter checks */

    -- 1. p_dataset_ids must all exist in the tbl_datasets table
    -- 2. p_submission_id must exist in the tbl_submissions table
    -- 3. p_data_provider_id must exist in the tbl_data_providers table
    -- 4. p_submission_name must not be null
    -- 5. p_submission_state_id must exist in the tbl_submission_states table
    -- 6. p_biblio_id must exist in the tbl_biblios table if not null
    -- 7. p_upload_date must not be null
    -- 8. p_submission_date must not be null
    -- 9. p_submission_identifier must not be null
    -- 10. p_issue_identifier must not be null
    -- 11. p_author must not be null
    -- 12. p_notes must not be null
    -- 13. p_source_name must not be null
    -- 14. p_data_types must not be null
    
    /***************************************************************************************************************
     ** Step 1: Migrate submission tasks.
     **         These are derived from dataset submissions based on submission types not in (10, 11).
     ***************************************************************************************************************/

    insert into tbl_submissions (
        submission_id,
        data_provider_id,
        submission_name,
        submission_state_id,
        biblio_id,
        upload_date,
        submission_date,
        submission_identifier,
        issue_identifier,
        author,
        notes,
        source_name,
        data_types
    )
        values (
            p_submission_id,
            p_data_provider_id,
            p_submission_name,
            p_submission_state_id,
            p_biblio_id,
            p_upload_date,
            p_submission_date,
            p_submission_identifier,
            p_issue_identifier,
            p_author,
            p_notes,
            p_source_name,
            p_data_types
        );
        
    perform reset_sequence('tbl_submissions', 'submission_id');

    /***************************************************************************************************************
     ** Step 2: Migrate submission tasks.
     **         These are derived from dataset submissions based on submission types not in (10, 11).
     ***************************************************************************************************************/

    insert into tbl_submission_tasks (
        -- submission_task_id,
        submission_task_type_id,
        contact_id,
        submission_id,
        biblio_id,
        event_date,
        notes
    )
        select
            -- source.dataset_submission_id,
            source.submission_type_id,
            source.contact_id,
            p_submission_id,
            datasets.biblio_id,
            parse_legacy_submission_date(source.date_submitted),
            source.notes
        from tbl_dataset_submissions source
        join tbl_datasets datasets on datasets.dataset_id = source.dataset_id
        where source.submission_type_id not in (10, 11)
        and source.dataset_id = any(p_dataset_ids);

    /***************************************************************************************************************
     ** Step 3: Move tasks with submission types 10 and 11 to dataset contacts
     **         These are dataset-related tasks that are currently incorrectly recorded as submission tasks.
     ***************************************************************************************************************/

    insert into tbl_dataset_contacts (contact_id, contact_type_id, dataset_id, event_date)
        select distinct
            source.contact_id,
            case source.submission_type_id
                when 10 then 4
                when 11 then 2
            end,
            source.dataset_id,
            parse_legacy_submission_date(source.date_submitted)
        from tbl_dataset_submissions source
        where source.dataset_id = any(p_dataset_ids)
          and source.submission_type_id in (10, 11)
          and not exists (
                select 1
                from tbl_dataset_contacts target
                where target.dataset_id = source.dataset_id
                and target.contact_id = source.contact_id
                and target.contact_type_id = case source.submission_type_id
                    when 10 then 4
                    when 11 then 2
                end
                and target.event_date is not distinct from parse_legacy_submission_date(source.date_submitted)
            );


    /* Step 4: Update datasets with the new submission ID */

    update tbl_datasets
        set submission_id = p_submission_id
    where dataset_id = any(p_dataset_ids);

    if (
        select count(*)
        from tbl_submission_tasks
        where submission_id = p_submission_id
    ) <> (
        select count(*)
        from tbl_dataset_submissions
        where dataset_id = any(p_dataset_ids)
          and submission_type_id not in (10, 11)
    ) then
        raise exception 'Submission task migration count mismatch';
    end if;

    if exists (
        select 1
        from tbl_datasets datasets
        where datasets.dataset_id = any(p_dataset_ids)
          and datasets.submission_id is null
    ) then
        raise exception 'One or more datasets have no migrated submission';
    end if;

end;
$$;

do $$
begin
    raise notice 'Starting migration of submission datasets';
    perform fn_migrate_submission_datasets();
end;
$$;
