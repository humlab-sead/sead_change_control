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
        COPY (
            SELECT * FROM tbl_ecocode_systems WHERE ecocode_system_id = 2
        )
            TO '/tmp/CS_ECOCODE_20170814_tbl_ecocode_systems_2.csv'
                WITH (FORMAT csv, ENCODING 'utf8');

        COPY (
            SELECT * FROM tbl_ecocode_groups WHERE ecocode_group_id = 2
        )
                TO '/tmp/CS_ECOCODE_20170814_tbl_ecocode_groups_2.csv'
                    WITH (FORMAT csv, ENCODING 'utf8');

        COPY (
            SELECT tbl_ecocode_definitions.*
            FROM tbl_ecocode_definitions
            JOIN tbl_ecocode_groups using (ecocode_group_id)
            WHERE tbl_ecocode_groups.ecocode_system_id = 2
        )
            TO '/tmp/CS_ECOCODE_20170814_tbl_ecocode_definitions_2.csv'
                WITH (FORMAT csv, ENCODING 'utf8');

        COPY (
            SELECT tbl_ecocodes.*
            FROM tbl_ecocodes
            JOIN tbl_ecocode_definitions using (ecocode_definition_id)
            JOIN tbl_ecocode_groups using (ecocode_group_id)
            WHERE tbl_ecocode_groups.ecocode_system_id = 2
        )
            TO '/tmp/CS_ECOCODE_20170814_tbl_ecocode_2.csv'
                WITH (FORMAT csv, ENCODING 'utf8');
*/

\COPY tbl_ecocode_systems        FROM './data/CS_ECOCODE_20170814_tbl_ecocode_systems_2.csv' WITH (FORMAT csv ENCODING 'utf8');
\COPY tbl_ecocode_groups         FROM './data/CS_ECOCODE_20170814_tbl_ecocode_groups_2.csv' WITH (FORMAT csv ENCODING 'utf8');
\COPY tbl_ecocode_definitions    FROM './data/CS_ECOCODE_20170814_tbl_ecocode_definitions_2.csv' WITH (FORMAT csv ENCODING 'utf8');
\COPY tbl_ecocodes               FROM './data/CS_ECOCODE_20170814_tbl_ecocodes_2.csv' WITH (FORMAT csv ENCODING 'utf8');
