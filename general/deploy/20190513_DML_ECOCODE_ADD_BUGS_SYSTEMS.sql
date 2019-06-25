-- Deploy sead_change_control:CS_ECOCODE_20170814_ADD_SYSTEM_2 to pg

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes         The psql "\COPY" commands loads local files and accepts relative paths
*****************************************************************************************************************/

/*
COPY (SELECT * FROM tbl_ecocode_systems WHERE ecocode_system_id in (2, 3)
) TO '/tmp/20190513_DML_ECOCODE_ADD_BUGS_SYSTEMS_ecocode_systems.csv' WITH (FORMAT csv, ENCODING 'utf8');

COPY (SELECT * FROM tbl_ecocode_groups WHERE ecocode_group_id in (2, 3)
) TO '/tmp/20190513_DML_ECOCODE_ADD_BUGS_SYSTEMS_ecocode_groups.csv' WITH (FORMAT csv, ENCODING 'utf8');

COPY (
    SELECT tbl_ecocode_definitions.*
    FROM tbl_ecocode_definitions
    JOIN tbl_ecocode_groups using (ecocode_group_id)
    WHERE tbl_ecocode_groups.ecocode_system_id in (2, 3)
) TO '/tmp/20190513_DML_ECOCODE_ADD_BUGS_SYSTEMS_ecocode_definitions.csv' WITH (FORMAT csv, ENCODING 'utf8');

COPY (
    SELECT tbl_ecocodes.*
    FROM tbl_ecocodes
    JOIN tbl_ecocode_definitions using (ecocode_definition_id)
    JOIN tbl_ecocode_groups using (ecocode_group_id)
    WHERE tbl_ecocode_groups.ecocode_system_id in (2, 3)
) TO '/tmp/20190513_DML_ECOCODE_ADD_BUGS_SYSTEMS_ecocodes.csv' WITH (FORMAT csv, ENCODING 'utf8');
*/

begin;

    alter table public.tbl_ecocode_definitions
        drop constraint "fk_ecocode_definitions_ecocode_group_id",
        add constraint "fk_ecocode_definitions_ecocode_group_id" foreign key (ecocode_group_id)  references tbl_ecocode_groups(ecocode_group_id) on delete cascade;

    alter table public.tbl_ecocode_groups
        drop constraint "fk_ecocode_groups_ecocode_system_id",
        add constraint "fk_ecocode_groups_ecocode_system_id" foreign key (ecocode_system_id)  references tbl_ecocode_systems(ecocode_system_id) on delete cascade;

    alter table public.tbl_ecocodes
        drop constraint "fk_ecocodes_ecocodedef_id",
        add constraint "fk_ecocodes_ecocodedef_id" foreign key (ecocode_definition_id)  references tbl_ecocode_definitions(ecocode_definition_id) on delete cascade;

    delete from tbl_ecocode_systems where ecocode_system_id in (2, 3);

    select sead_utility.sync_sequence('public', 'tbl_ecocode_systems');
    select sead_utility.sync_sequence('public', 'tbl_ecocode_groups');
    select sead_utility.sync_sequence('public', 'tbl_ecocode_definitions');
    select sead_utility.sync_sequence('public', 'tbl_ecocodes');

    \COPY tbl_ecocode_systems        FROM './deploy/data/20190513_DML_ECOCODE_ADD_BUGS_SYSTEMS_ecocode_systems.csv' WITH (FORMAT csv, ENCODING 'utf8');
    \COPY tbl_ecocode_groups         FROM './deploy/data/20190513_DML_ECOCODE_ADD_BUGS_SYSTEMS_ecocode_groups.csv' WITH (FORMAT csv, ENCODING 'utf8');
    \COPY tbl_ecocode_definitions    FROM './deploy/data/20190513_DML_ECOCODE_ADD_BUGS_SYSTEMS_ecocode_definitions.csv' WITH (FORMAT csv, ENCODING 'utf8');
    \COPY tbl_ecocodes               FROM './deploy/data/20190513_DML_ECOCODE_ADD_BUGS_SYSTEMS_ecocodes.csv' WITH (FORMAT csv, ENCODING 'utf8');

    select sead_utility.sync_sequence('public', 'tbl_ecocode_systems');
    select sead_utility.sync_sequence('public', 'tbl_ecocode_groups');
    select sead_utility.sync_sequence('public', 'tbl_ecocode_definitions');
    select sead_utility.sync_sequence('public', 'tbl_ecocodes');

commit;
