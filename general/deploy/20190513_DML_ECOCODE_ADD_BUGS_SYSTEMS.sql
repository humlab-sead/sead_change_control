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

    delete from tbl_ecocodes /*
    where ecocode_id in (
        select c.ecocode_id
        from tbl_ecocode_systems s
        join tbl_ecocode_groups g using (ecocode_system_id)
        join tbl_ecocode_definitions using (ecocode_group_id)
        join tbl_ecocodes c using (ecocode_definition_id)
        where s.ecocode_system_id in (2, 3)
    )*/;

    delete from tbl_ecocode_definitions/*
    where ecocode_definition_id in (
        select d.ecocode_definition_id
        from tbl_ecocode_groups g
        join tbl_ecocode_definitions d using (ecocode_group_id)
        where g.ecocode_system_id in (2, 3)
    )*/;

    delete from tbl_ecocode_groups/*
    where ecocode_system_id in (2, 3)*/;

    delete from tbl_ecocode_systems/*
    where ecocode_system_id in (2, 3)*/;

    delete from tbl_ecocode_groups;

    --create table temp_ecocode_systems as select * from tbl_ecocode_systems where FALSE;
    --create table temp_ecocode_groups as select * from tbl_ecocode_groups where FALSE;
    --create table temp_ecocode_definitions as select * from tbl_ecocode_definitions where FALSE;
    --create table temp_ecocodes as select * from tbl_ecocodes where FALSE;

    select sead_utility.sync_sequence('public', 'tbl_ecocode_systems');
    select sead_utility.sync_sequence('public', 'tbl_ecocode_groups');
    select sead_utility.sync_sequence('public', 'tbl_ecocode_definitions');
    select sead_utility.sync_sequence('public', 'tbl_ecocodes');

    \COPY tbl_ecocode_systems        FROM './deploy/data/20190513_DML_ECOCODE_ADD_BUGS_SYSTEMS_ecocode_systems.csv' WITH (FORMAT csv, ENCODING 'utf8');
    \COPY tbl_ecocode_groups         FROM './deploy/data/20190513_DML_ECOCODE_ADD_BUGS_SYSTEMS_ecocode_groups.csv' WITH (FORMAT csv, ENCODING 'utf8');
    \COPY tbl_ecocode_definitions    FROM './deploy/data/20190513_DML_ECOCODE_ADD_BUGS_SYSTEMS_ecocode_definitions.csv' WITH (FORMAT csv, ENCODING 'utf8');
    --\COPY tbl_ecocodes               FROM './deploy/data/20190513_DML_ECOCODE_ADD_BUGS_SYSTEMS_ecocodes.csv' WITH (FORMAT csv, ENCODING 'utf8');

    select sead_utility.sync_sequence('public', 'tbl_ecocode_systems');
    select sead_utility.sync_sequence('public', 'tbl_ecocode_groups');
    select sead_utility.sync_sequence('public', 'tbl_ecocode_definitions');
    select sead_utility.sync_sequence('public', 'tbl_ecocodes');

commit;
