do $$ begin 

    if not exists (select 1 from tbl_methods where method_id = 175) then

    insert into tbl_methods("method_id", "biblio_id", "date_updated", "description", "method_abbrev_or_alt_name", "method_group_id", "method_name", "record_type_id", "unit_id")
        values (
                176,
                NULL,
                '2025-04-24 08:34:07.182333+00',
                'Library preparation of ancient DNA recovered from biological material (human, animal, plants, etc.).',
                'aDNA-Library',
                1,
                'Ancient DNA analysis (Library Preparation)',
                22,
                NULL
        );
    end if;

    if exists (select 1 from tbl_methods where method_id = 175 and "method_abbrev_or_alt_name" = 'aDNA-Sample') then
        update tbl_methods
        set "method_abbrev_or_alt_name" = 'aDNA-Sample',
            "description" = 'Extraction and analysis of ancient DNA recovered from biological material (human, animal, plants, etc.).',
            "method_name" = 'Ancient DNA analysis (Sample Extraction/Analysis)'
        where "method_id" = 175;
    end if;

    if not exists (select 1 from tbl_datasets where method_id = 176 and dataset_name like 'library%') then
        update tbl_datasets
        set "method_id" = 176 -- select * from tbl_datasets
        where "method_id" = 175
        and "dataset_name" like 'library%';
    end if;

end $$ language plpgsql;