### Included change requests

20191222_DML_DATASET_SUBMISSION_UPDATE
20200422_DML_MAL_QOS_UPDATE_02
20200422_DML_MAL_TAXA_SP_SPP_QOS_UPDATE
20200422_UPDATE_BUGS_REFERENCES_YEAR

20200120_DML_ADD_DOMAIN_FACETS
20200203_DML_ADD_DOMAIN_ASSOCS
20200203_DDL_ADD_DOMAIN_TABLE
20200422_DML_FACET_GRAPH_REROUTE

### Other things to note

## Changes to SEAD Change Control System

### Overview

- Updates (CRs) that targets specific identities have been changed to use alternative keys instead.

### SEAD data changes

Changes to dendrochronology data

- 20191220_DML_SUBMISSION_DENDRO_XYZ_003_COMMIT: Data related to dendro pilot project has been deprecated (#137, #206, #207)
- 20231206_DDL_UPDATE_OF_DENDRO_RELATED_LOOKUPS: Add additional dendro lookup data related to new submission (#153, #218)
- 20231129_DML_ADD_TAXONOMIC_ORDER_DYNTAXA: Added SBDI taxonomic order `Dyntaxa` ([Create species mapping in SEAD](https://github.com/humlab-sead/sbdi/issues/1), #141)
- 20231206_DDL_UPDATE_OF_DENDRO_RELATED_LOOKUPS: Update dendro-related lookups (#153)

Changes to BugsCEP data

- 20231211_DML_SUBMISSION_BUGS_20231219_COMMIT: A full import of BugsCEP database dated 2023-12-19.
- 20220916_DDL_RESULTS_CHRONOLOGY: Adds chronology dating data to BugsCEP physical samples (#17).
- 20200422_DML_UPDATE_BUGS_REFERENCES_YEAR (#69, update of erroneous year in BugsCEP references)

Deprecated changes related to BugsCEP data

- 20191221_DML_SUBMISSION_BUGS_20190303_COMMIT (#204, replaced by #162, first BugsCEP import).
- 20191012_DML_ASSOCIATION_TYPE_UPDATES (#15, moved to #226)
- 20191221_DML_SUBMISSION_BUGS_20190303_COMMIT (#204, initial BugsCEP import).
- 20191221_DML_SUBMISSION_BUGS_20190303_POST_APPLY (part of #204)
- 20200315_DML_BUGS_IMPORT_POST_APPLY_20200219 (developed as part of #62)
- 20200313_DML_BUGS_IMPORT_PUBLIC_20200219 (#62, import of data in `public` schema)
- 20200313_DML_BUGS_IMPORT_TRACE_20200219 (#62, import of data in `bugs_import` schema)
- 20231212_DML_BUGS_ADD_ANALYSIS_ENTITY_AGES (#164, modelled official ages for 889 BugsCEP samples)

Changes to MAL data exported from SEAD master 9

- MAL data now exists as three separate CRs (`mal` project folder).
- 20100101_DML_SUBMISSION_MAL_000_LOOKUPS (#222, MAL lookup data)
- 20100101_DML_SUBMISSION_MAL_000_TAXA (#223, MAL taxonomic data)
- 20100101_DML_SUBMISSION_MAL_000_COMMIT (#221, MAL data)
- 20221206_DML_QUALITY_CONTROL_DATASETS_UPDATES (#145, updates to MAL bibliographic references)

Revised CR that uses explicit (unstable) updates targeting specific identities

- 20221205_DML_QUALITY_CONTROL_BIBLIO_UPDATES (#146, revised to use reference instead of identity)

The following CRs still have severe identity crisis

- 20221206_DML_QUALITY_CONTROL_DATASETS_UPDATES (moved to MAL, ceramics updates excluded #145, #243, #81)
- 20200422_DML_MAL_QOS_UPDATE_02 ()

The following CRs are excluded due to sever identity crisis

- 20221206_DML_QUALITY_CONTROL_DATASETS_UPDATES (no longer valid identities #243, #81)
- 20191219_DML_METHODS_UPDATE (#34)
- 20200219_DML_SITE_LOCATIONS_UPDATE (#54)

Changes to Clearing House data

- 20191221_DML_CLEARINGHOUSE_STARTINGPOINT

### Changes to CR projects and CRs

- New folder structure for CRs, a folder per datatype, a new SEAD `sead_model` folder, removed `submissions`
- CRs (not all, need help here) have been moved to correct folder (#197).
- All CRs now have a link to corresponding Github issue (https://github.com/humlab-sead/sead_change_control/commit/dcc4717bc454480c8867403068f5dee0dd3c3ed3, ).

- 20190408_DML_UPDATE_LOCATION_RECORD deprecated (merged into #20)
- Raise error if target records are missing (https://github.com/humlab-sead/sead_change_control/commit/b273ea4b274c00c44a7c454b6ae60d87a2eaff25)
  - general/deploy/20120921_DML_RECORD_TYPE_UPDATE_PLANTS_POLLEN.sql
  - 
### Changes to SEAD Clearing House Transport System

Improved and more resiliant version:

 - Added UDFs that perform rollback of a transport commit (https://github.com/humlab-sead/sead_clearinghouse/commit/2e2c3234c0b12fea354eaed7042c22d58268b1c9)
 - Fixed bug in XML transport script (https://github.com/humlab-sead/sead_clearinghouse/commit/14ec2c694ccd7a3ce4be833b4f6494f867aca031)
 - Add casting of FKs types when resolving FK public identities (https://github.com/humlab-sead/sead_clearinghouse/commit/3d4c993588a809f1db6c44aab0d24621d6c11c73)
 - Moved script that creates submission's CR to SEAD change control system (https://github.com/humlab-sead/sead_clearinghouse/commit/ddc3e51a82dd565bb85f1d5395014f3adf9ad79a)
 - Improved script that bundles SEAD Clearinghouse import system into a CR (https://github.com/humlab-sead/sead_clearinghouse/commit/c051a683b6f6d35fbba5fdd21dd2125d09e9babe)
 - Fixed value out of range bug when resolving PKs (https://github.com/humlab-sead/sead_clearinghouse/commit/45eb941a536ded04570698ca93987c771e23dbac)
 - Renamed bundle script (https://github.com/humlab-sead/sead_clearinghouse/commit/a7e33caeaf44fdc17ebd04cdfe285dcbf0119eff)
 - Removed very dangerous automatic delete of conflicting records (https://github.com/humlab-sead/sead_clearinghouse/commit/a7e33caeaf44fdc17ebd04cdfe285dcbf0119eff)
 - Fixed error caused by PostgreSQL upgrade to v16.1 (https://github.com/humlab-sead/sead_clearinghouse/commit/9074277ba9a40d5941b8d8c4f6d8205869805923)

### Changes to SEAD change control system

- Sqitch plans now contain links to Github issues.
- Deploy (can) now start from an empty database. (Deploy from previous starting point (`sead master 9`) is still possible).
- 20231207_DML_FACET_GRAPH_UPDATE: removed (empty CR)


### Changes to Schema Changes

- Added project `sead_model` for SEAD model and schema changes. (#217, #230)
- The SEAD model DDL scripts are stored in tables.sql, foreign_keys.sql, comments.sql, grants.sql, indexes.sql.
- Type of `tbl_dataset_submissions.date_submitted` changed from `date` to `text` (#219, #228, https://github.com/humlab-sead/sead_change_control/commit/f7058d482966021446f57b4fd7b0aa7ae7a6db44)
- SEAD_DATABASE_LOOKUPS: Generic (non data type specific) SEAD lookups now reside in a separate CR. (#220)
- PK column types have been changed to `serial/bigserial not null`, explicit sequenced removed (#217, #220) https://github.com/humlab-sead/sead_change_control/commit/76aecd1c7aa5a81ab2ad38346769892e3f9f51e9).
- FK column types changed to match referenced PK column type (https://github.com/humlab-sead/sead_change_control/commit/ddfb52b0beff03c976c42f81e36a97e6b3ce56e7). Previously PK defined as sequence was `bigint`, FKs were `int`.
- 20220922_DDL_CHRONOLOGY_SCHEMA_CHANGES: Changes to chronology tables' schema (#92)

Changes to utility scripts (Bash):

- Added improved script `add-change-request` with options to create and link Github issue (https://github.com/humlab-sead/sead_change_control/commit/42f5ca37753d3b867fed9f0ccf62c3b0f10d49bf)
- Added script `rm-cr` (https://github.com/humlab-sead/sead_change_control/commit/a600a6151d55093b651e35dc79e8773ce9637628) ... https://github.com/humlab-sead/sead_change_control/commit/43a4fd3e23b5d3cdba98ff848af4b4eaf0e92f45 that archives a CR.
- Added script `mv-cr` (https://github.com/humlab-sead/sead_change_control/commit/8ffa4954a5291a5bd03011658b44412fa653bfb6) ... https://github.com/humlab-sead/sead_change_control/commit/e504177e262002647fc65c6767f08abe6ff1c0d4 that moves a CR to another project while preserving links to code and issue, and also preserving deploy tag.
- Added script `update-cr-header` (https://github.com/humlab-sead/sead_change_control/commit/e504177e262002647fc65c6767f08abe6ff1c0d4)... that updates CR name and link to Github issue in CR's deploy file.
- Added script `add-submission-change-request` that bundles a data submission residing in `ready-to-commit` state in the SEAD Clearing House System. This script originates from SEAD Clearing House system but has been improved and made more resilient. (https://github.com/humlab-sead/sead_change_control/commit/8ffa4954a5291a5bd03011658b44412fa653bfb6) ... (https://github.com/humlab-sead/sead_change_control/commit/e504177e262002647fc65c6767f08abe6ff1c0d4)
- Improved script `deploy-staging`
   - Resolved #161 (https://github.com/humlab-sead/sead_change_control/commit/ec75ff051bc176dca0e6b96c86b566c888203bdb)
   - Added `--help` option (https://github.com/humlab-sead/sead_change_control/commit/680cecdd6c4f5dc8e6d94560a561ea9ace57e306)
   - Refactored common logic to utility script (https://github.com/humlab-sead/sead_change_control/commit/f70cd3133e47eec31510109076b3931751de1c12)
   - Added option `--deploy-starting-point` (https://github.com/humlab-sead/sead_change_control/commit/96c1dfa1104a17210a87aac0430d9a5ecd9bed5f)
   - Fixed help text and added `empty` starting point (https://github.com/humlab-sead/sead_change_control/commit/f265afaddde126933f1a8a39f51a34c90b855d7e)
   - Added `--deploy-single-change-request` (https://github.com/humlab-sead/sead_change_control/commit/50d86ba8d55783d98cfedf4d6afc206a00b7713c)
   - Added `--sync-sequences` (https://github.com/humlab-sead/sead_change_control/commit/
   9bfa21eedb17551914ed380e0a1dfe6607da6e16)
   - Added before/after deploy hooks that are bash scripts executed before a project's release targeting a certain deploy tag. This hooks must be placed in a project's root folder and be named as `@YYYY-MM-pre-deploy-hook` and `@YYYY-MM-post-deploy-hook` and reside in project's folder. `@YYYY-MM` must be a valid tag in the project's `sqitch.plan` (e.g. `bugs/@2023.12-post-deploy-hook`). The hooks can be used for e.g. decompressing/compressing large files used by CRs that target specified tag (#133, #162,https://github.com/humlab-sead/sead_change_control/commit/e589995d136bf036bbc242f37429d0199b4121b8, https://github.com/humlab-sead/sead_change_control/commit/bd5dd60dc7aeb7460f38fe3a8b21cf0810463215)
   - Each database can now be deployed in order of deploy tags in one go (https://github.com/humlab-sead/sead_change_control/commit/a9afa0552769bd3cf024afb02d4173af9b6076f3).
   - Added option to prevent release if specified tag doesn't exist in git (https://github.com/humlab-sead/sead_change_control/commit/bd5dd60dc7aeb7460f38fe3a8b21cf0810463215)
   - Fixed problems occuring when kicking out users during deployment (#161)
- Improved script `dump-database`
   - Added option to exclude owners and privileges (https://github.com/humlab-sead/sead_change_control/commit/4f2eda96f3e2cedea9491be572f0ad3c1747676d)
   - Added option to compress data file (https://github.com/humlab-sead/sead_change_control/commit/1f4e582e25386e0e929da10a8c8aa9953078beb2)
   - Added file `projects.txt` that pins order in which projects are deployed (#132)
- Added script `add-issue` that given a CR creates a placeholder issue (or links an existing issue) and updates links in CR script, and adds a link in the issue to the deploy script.
- Added script `tag-projects` that assigns a tag to all projects (https://github.com/humlab-sead/sead_change_control/commit/391f93671b3c80ce3420c033da26c39e4ed872a4)

### Changes to SEAD utility scripts (UDFs in schema sead_utility)

   - Added UDF `sead_utility.constraint_exists` (#202, https://github.com/humlab-sead/sead_change_control/commit/59ff112c26a86c3fee4c414d49ab9e4ee17406cd)
   - Added UDF `sead_utility.get_all_table_counts` (https://github.com/humlab-sead/sead_change_control/commit/16407381c37d5a3c6ee237aa645b42b326ff5f3c)
   - Added view `sead_utility.view_fk_index_check` (#202, https://github.com/humlab-sead/sead_change_control/commit/dea947fb3904be7be749c3de4a85e70899e333d2). Renamed to `foreign_keys_index_check` (https://github.com/humlab-sead/sead_change_control/commit/bf54b98469a40a6bdfd4b1e9663b8b37b96634fb)
   - Added UDP `sead_utility.set_schema_privilege` for assigning privileges (https://github.com/humlab-sead/sead_change_control/commit/59ac0419efaf6484375888e281270f3ce19d34ba)
   - Added UDF `sead_utility.chown` for changing object's owner (https://github.com/humlab-sead/sead_change_control/commit/59ac0419efaf6484375888e281270f3ce19d34ba)
   - Added UDF `sead_utility.get_column_type` that returns column's type (https://github.com/humlab-sead/sead_change_control/commit/95985c763712fcde9a152b30848c1353b914db75)

### Bug fixes

   - CRs are applied in wrong order (#132)
   - [20200429_DDL_UDF_FACET_UPDATE: Missing domain facet children](https://github.com/humlab-sead/sead_change_control/issues/140) (#140)
   - [20220916_DDL_RESULTS_CHRONOLOGY: Error in dataset name](https://github.com/humlab-sead/sead_change_control/issues/143) (#143)

### Known issues and problems

- Missing FK indexes have been added to a number of tables (#202)
 - There still exist CRs doing dangerous identity updates. Identity updates should be prevented or avoided that targets data, but are OK for lookups.
 - Some updates should have additional criterias beside identity (better that they are rendered noop instead of doing faulty updates)

### Detailed command log

#### Bugs import
1. Using `sead_change_control`:
```bash
./bin/deploy-staging --create-database --on-conflict drop --source-type empty --target-db-name sead_staging_202312_bugs --deploy-to-tag @2023.12 --ignore-git-tags
```
1. Using `sead_change_control`:
```bash
 6239  2024-01-21 14:16:15 bin/copy-database --source sead_staging_202312 --target sead_staging_202312_bugs --force --sync-sequences
```
same as
```bash
./bin/deploy-staging --create-database --on-conflict drop --source-type empty --target-db-name sead_staging_202312_bugs --deploy-to-tag @2023.12 --ignore-git-tags
```
1. Using `sead_bugs_import`:
Set target database in conf/application.properties
```
spring.datasource.url=jdbc:postgresql://humlabseadserv.srv.its.umu.se:5432/sead_staging_202312_bugs
```

```bash
nohup java -jar target/bugs.import-0.1-SNAPSHOT.jar --file=./bugsdata/bugsdata_20231219.mdb > logfile.log 2>&1 &
```
1. Using `sead_change_control` on `wsl2` (need access to dbForege DataCompare):
```bash
./bugs-import-sync/create-bugs-sync-script -t ALL --source-database sead_staging_202312_bugs --target-database sead_staging_202312
```

### Checklist

 - [ ] Update/lock current version of SEAD change control system
 - [ ] Archive current SEAD production database
 - [ ] Add release tag to Sqitch database versioning plan
 - [ ] Create a new staging database
 - [ ] Deploy pending changes to staging
 - [ ] Add release tag to SEAD change control repository
 - [ ] Acceptance testing GO/NOGO
 - [ ] Deploy to production
 - [ ] Prepare next months release:
    - [ ] Add new milestone
    - [ ] Add new release project
    - [ ] Add database release issue (use this issue as a template)

ID    TITLE                                                          LABELS                                                        UPDATED
#228  20240104_DDL_DATE_SUBMITTED_TYPE                               schema-change, change-request, sead-model                     about 15 days ago
#226  20190503_DML_TAXA_ADD_SPECIES_ASSOC_TYPES                      change-request, bugs                                          about 16 days ago
#225  20190503_DML_METHOD_ADD_BUGS_METHODS                           change-request, bugs                                          about 16 days ago
#224  SEAD_DATABASE_MODEL: Many foreign key columns in SEAD lack...  schema-change                                                 about 27 days ago
#223  20100101_DML_SUBMISSION_MAL_000_TAXA                           change-request                                                about 28 days ago
#222  20100101_DML_SUBMISSION_MAL_000_LOOKUPS                        change-request                                                about 28 days ago
#221  20100101_DML_SUBMISSION_MAL_000_COMMIT                         change-request                                                about 29 days ago
#220  SEAD_DATABASE_LOOKUPS                                          change-request                                                about 27 days ago
#219  tbl_dataset_submissions field constraint update                schema-change, dendrochronology                               about 29 days ago
#218  DENDRO_BUILDING_DATA_IMPORT_2023-12                            new-data, dendrochronology                                    about 10 minutes ago
#217  SEAD_DATABASE_MODEL                                            change-request                                                about 27 days ago
#216  20191217_DDL_CLEARINGHOUSE_TRANSPORT_SYSTEM                    change-request                                                about 1 month ago
#215  20191217_DDL_CLEARINGHOUSE_SYSTEM                              change-request                                                about 1 month ago
#214  20231219_DML_CLEARINGHOUSE_STARTINGPOINT                       change-request, clearinghouse                                 about 1 month ago
#213  20190101_DML_FACETS_LOOKUP                                     change-request                                                about 1 month ago
#212  20200429_DML_FACETS                                            change-request                                                about 1 month ago
#211  20200429_DDL_UDF_FACET_UPDATE                                  change-request                                                about 1 month ago
#210  20180501_DDL_RESTAPI_CREATE_SAMPLE_AGE_RANGES                  change-request                                                about 1 month ago
#209  20180501_DDL_RESTAPI_GENERATE_SCHEMA                           change-request, bugs                                          about 1 month ago
#207  20191220_DML_SUBMISSION_DENDRO_ARCHEOLOGY_003_COMMIT           change-request, dendrochronology                              about 1 month ago
#206  20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT             change-request, dendrochronology                              about 1 month ago
#205  20200109_DML_SUBMISSION_CERAMICS_005_COMMIT                    change-request, ceramics                                      about 1 month ago
#204  20191221_DML_SUBMISSION_BUGS_20190303_COMMIT                   change-request, bugs                                          about 1 month ago
#203  Wrong project assigned to Isotope datasets                                                                                   about 1 month ago
#202  20190401_DDL_UTILITY_SCHEMA                                    change-request                                                about 15 days ago
#201  20190503_DDL_BUGS_ADD_TRANSLATIONS                             change-request, bugs                                          about 1 month ago
#200  20190503_DDL_BUGS_SETUP_SCHEMA                                 change-request, bugs                                          about 1 month ago
#198  20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT Wrong project_i...                                                                about 1 month ago
#197  Add data type specific projects, move CRs to the correct p...  house-cleaning                                                about 1 month ago
#196  20191213_DDL_CERAMICS_MODEL                                    change-request, ceramics                                      about 1 month ago
#195  20191213_DDL_DENDRO_MODEL                                      change-request, dendrochronology                              about 1 month ago
#194  20191212_DML_UPDATE_SAMPLE_ALT_REFS                            change-request, bugs                                          about 1 month ago
#193  20191212_DML_ADD_RECORD_TYPE                                   change-request, dendrochronology                              about 1 month ago
#192  20190513_DML_DATA_TYPE_ADD_TYPES_CALENDER_DATES                change-request, unspecified-datatype                          about 1 month ago
#191  20190503_DML_DATINGLAB_ADD_UNKNOWN_LAB                         change-request, bugs, unspecified-datatype                    about 1 month ago
#190  20120921_DML_RECORD_TYPE_UPDATE_PLANTS_POLLEN                  change-request, archaeobotany                                 about 1 month ago
#189  20180502_DML_METHOD_UPDATE_METHOD_TL                           change-request, unspecified-datatype                          about 1 month ago
#188  20121220_DML_HORIZON_UPDATE_DESCRIPTION                        change-request, unspecified-datatype                          about 1 month ago
#187  20150522_DML_TAXA_ADD_GENERA_SPHAGNUM                          change-request, unspecified-datatype                          about 1 month ago
#186  20190408_DML_LOCATION_UPDATE_LOCATION_RECORD                   change-request, unspecified-datatype                          about 1 month ago
#185  20180222_DML_BIBLIO_ADD_RECORD                                 change-request, archaeobotany, unspecified-datatype           about 1 month ago
#184  20180607_DDL_SAMPLE_ALTER_TYPES                                change-request, unspecified-datatype                          about 1 month ago
#183  20120921_DML_DATATYPE_UPDATE_DESCRIPTION                       change-request, unspecified-datatype                          about 1 month ago
#182  20170517_DML_DATATYPE_ADD_TYPES                                change-request, unspecified-datatype                          about 1 month ago
#181  20131113_DML_SITE_UPDATE_LAT_LONG                              change-request, unspecified-datatype                          about 1 month ago
#180  20140417_DML_RELATIVE_AGE_ADD_DATA                             change-request, unspecified-datatype                          about 1 month ago
#179  20190503_DML_METHOD_ADD_BUGS_METHODS                           change-request                                                about 1 month ago
#178  20190410_DDL_COMMENTS_UPDATE_COMMENTS                          change-request                                                about 1 month ago
#177  20190411_DDL_ASSIGN_SEQUENCES                                  change-request                                                about 1 month ago
#176  20190410_DDL_RELATIVE_DATING_RENAME_COLUMN                     change-request                                                about 1 month ago
#175  20190410_DDL_TAXA_CREATE_VIEW_ALPHABETICALLY                   change-request                                                about 1 month ago
#174  20190410_DDL_SAMPLE_CREATE_INDEX                               change-request                                                about 1 month ago
#173  20180601_DDL_SITE_ALTER_TYPE                                   change-request                                                about 1 month ago
#172  20180601_DDL_DROP_RADIOCARBON_CALIBRATION                      change-request                                                about 1 month ago
#171  20180601_DDL_TAXA_DROP_VIEWS                                   change-request                                                about 1 month ago
#170  20180601_DDL_SITE_ADD_LOCATION_ACCURACY                        change-request                                                about 1 month ago
#169  20190408_DDL_ECOCODE_REFACTOR_MODEL                            change-request                                                about 1 month ago
#168  20170911_DDL_CHRONOLOGIES_REFACTOR_MODEL                       change-request                                                about 1 month ago
#167  20190408_DDL_DATASET_CREATE_TABLE_DATASET_METHODS              change-request, unspecified-datatype                          about 1 month ago
#166  20170911_DDL_ANALYSIS_ENTITY_ALTER_AGES_PRECISION              change-request                                                about 1 month ago
#165  Updates by serial identity should be prohibited                                                                              about 1 month ago
#164  20231212_DML_BUGS_ADD_ANALYSIS_ENTITY_AGES                     change-request, bugs                                          about 1 month ago
#163  20170911_DML_ANALYSIS_ENTITY_ADD_AGES                          change-request                                                about 1 month ago
#162  20231211_DML_SUBMISSION_BUGS_20231219_COMMIT                   change-request, bugs                                          about 15 days ago
#161  User connections to target database must be closed before ...                                                                about 1 month ago
#160  20190101_DML_FACETS                                            change-request                                                about 1 month ago
#159  20170810_DDL_DATAARC_DATASRC_API                               change-request                                                about 1 month ago
#158  20201221_DDL_ECL_RESTAPI_VIEWS                                 change-request                                                about 1 month ago
#157  20221117_DML_RESTAPI_GENERATE_SCHEMA                           change-request                                                about 1 month ago
#156  20221121_DML_QSE_DENDRO_DATING                                 change-request, dendrochronology                              about 14 days ago
#155  20221121_DDL_UDF_DELETE_FACET                                  change-request                                                about 1 month ago
#154  20231207_DML_FACET_GRAPH_UPDATE                                house-cleaning, change-request                                about 1 month ago
#153  20231206_DDL_UPDATE_OF_DENDRO_RELATED_LOOKUPS: Update dend...  data-correction, change-request, dendrochronology             about 14 days ago
#152  20190513_DML_DATA_TYPE_ADD_TYPES_CALENDER_DATES                change-request                                                about 1 month ago
#151  20131113_DML_SITE_UPDATE_LAT_LONG                              change-request                                                about 1 month ago
#150  20170911_DDL_CHRONOLOGIES_REFACTOR_MODEL                       change-request                                                about 1 month ago
#148  20191213_DML_DENDRO_LOOKUP                                     dendrochronology                                              about 14 days ago
#147  20200115_DDL_TABLE_TEMPERATURES                                                                                              about 1 month ago
#146  20221205_DML_QUALITY_CONTROL_BIBLIO_UPDATES                    data-correction, archaeobotany                                about 1 month ago
#145  20221206_DML_QUALITY_CONTROL_DATASETS_UPDATES                  data-correction, archaeobotany                                about 1 month ago
#144  20231123_DDL_BIBLIO_UUID                                                                                                     about 1 month ago
#143  20220916_DDL_RESULTS_CHRONOLOGY: Error in dataset name         bug, bugs                                                     about 1 month ago
#142  20231129_DDL_MISSING_UNIQUE_CONSTRAINTS                        data-error, data-correction, change-request                   about 1 month ago
#141  20231129_DML_ADD_TAXONOMIC_ORDER_DYNTAXA                       change-request, dendrochronology                              about 1 month ago
#140  20200429_DDL_UDF_FACET_UPDATE: Missing domain facet children   bug                                                           about 1 month ago
#139  20231123_DDL_UUID                                              change-request                                                about 1 month ago
#137  Dendro pilot project dataset update                            enhancement, data-correction, dendrochronology                about 1 month ago
#136  20231120_DML_DENDRO_LOOKUP: New dendro lookup data (202006...  enhancement                                                   about 1 month ago
#135  20231120_DML_DENDRO_MODEL_UPDATE                               enhancement, schema-change, dendrochronology, breaking-ch...  about 1 month ago
#134  Suspicious site coordinates/location                           new                                                           about 2 months ago
#133  Add hooks for extra logics before and after tag deployment     enhancement                                                   about 3 months ago
#132  CRs must be applied in chronological order per sqitch project  bug                                                           about 1 month ago
#229  Formatting of references                                                                                                     about 3 days ago
#129  Can't transform coordinates for site 12                                                                                      about 4 months ago
#128  Spelling errors in tbl_dimensions                              data-error, new, low hanging fruit                            about 4 months ago
#130  "Geochronology" och "Time periods" fungerar inte tillsammans   bug, Supersead                                                about 4 months ago
#126  Sampling methods contains lots of "Temp record"                data-correction, quality-control, Supersead                   about 4 months ago
#125  When selecting Sweden in the country filter, a site in Den...  Supersead                                                     about 4 months ago
#124  Ceramic shard misspelled as 'sherd'                                                                                          about 4 months ago
#123  Updated facet descriptions                                                                                                   about 7 months ago
#122  Sample contexts and Feature types                              question, new                                                 about 7 months ago
#131  Suggestion: Rename facet 'Master datasets' to...               enhancement                                                   about 4 months ago
#121  Ecocode systems lacks definitions                                                                                            about 4 months ago
#120  High abundance counts                                          question                                                      about 4 months ago
#119  Embargo-system                                                                                                               about 3 months ago
#118  tbl_analysis_entity_ages                                       question, new                                                 about 8 months ago
#117  Need better descriptions for some filters                      enhancement, low hanging fruit                                about 8 months ago
#116  Koch ecocode 21285 "FNoDi" has no name                                                                                       about 8 months ago
#114  Tool tip text lacks explanation for several filters            low hanging fruit                                             about 8 months ago
#113  Need to figure out bugs seasonality data                       new                                                           about 8 months ago
#112  Import 'volume after float' and 'sample note' values from ...                                                                about 8 months ago
#115  RDB system filter: är grupperingen korrekt?                                                                                  about 8 months ago
#111  Multiple problems with sample dimensions                       data-error                                                    about 9 months ago
#110  tbl_dendro_dates season indicator needs updating                                                                             about 2 months ago
#109  composite chronology gone?                                     pending-approval                                              about 1 month ago
#108  Outdated information in dataset references                                                                                   about 9 months ago
#107  10 meter ceramic shards                                                                                                      about 11 months ago
#106  Replace various value tables with a more general approach?     discussion                                                    about 10 months ago
#105  Namnsättning av filter: Bibligraphy vs Bibliography            low hanging fruit                                             about 8 months ago
#104  Missing postgREST views                                                                                                      about 1 year ago
#103  20220923_DDL_DEPRECATE_CHRON_CONTROLS: Delete of records d...  schema-change                                                 about 1 month ago
#102  Check MAL bibliography references                              data-correction, quality-control                              about 1 year ago
#98   20191221_DML_CLEARINGHOUSE_STARTINGPOINT                       data-error                                                    about 1 year ago
#97   20200115_DDL_TABLE_TEMPERATURES Temperature table              enhancement, schema-change, new-data                          about 1 year ago
#96   Bugs import error                                              bug, data-error                                               about 1 year ago
#95   20180501_DDL_RESTAPI_GENERATE_SCHEMA                           schema-change                                                 about 1 year ago
#94   20220923_DDL_FACET_SCHEMA_UPDATE (cascaded constraints)        schema-change                                                 about 1 year ago
#93   20220923_DDL_DEPRECATE_CHRON_CONTROLS                          schema-change                                                 about 1 year ago
#92   20220922_DDL_CHRONOLOGY_SCHEMA_CHANGES                         schema-change                                                 about 1 year ago
#91   New filters/facets for dendro                                  enhancement                                                   about 1 month ago
#90   HOWTO Add a CR to SEAD change control system                   HOWTO                                                         about 1 year ago
#89   Dendro lookups standardization and update                      data-correction, dendrochronology                             about 1 month ago
#88   Update of previous dendro data                                 help wanted                                                   about 3 years ago
#86   Change filter item name                                                                                                      about 1 year ago
#99   20221206_DML_SITE_DESCRIPTION_HOGDAL_UPDATE                    data-correction                                               about 1 year ago
#85   Updated sqitch-docker.sh URL                                                                                                 about 1 year ago
#84   Site 344 has faulty data                                       help wanted, data-error                                       about 3 years ago
#83   Tbl_site_references biblio quality assurance                   quality-control                                               about 1 year ago
#82   Metadata for later ingestion of missing MAL bibliography       missing-data, data-correction, quality-control                about 1 year ago
#81   Tbl_biblio quality assurance and update                        data-correction                                               about 1 year ago
#80   20221205_DML_CERAMICS_METHOD_ID_UPDATE                         data-error, data-correction, pending-approval                 about 1 year ago
#79   Major error detected for reference column in tbl_datasets      help wanted, data-error                                       about 3 years ago
#127  Biblio sometimes loads publication year twice                  bug                                                           about 5 months ago
#78   Ceramic data quality control                                   bug, help wanted, data-error, data-correction                 about 3 years ago
#77   20200429_DDL_UDF_FACET_UPDATE (revisited)                      enhancement                                                   about 1 year ago
#75   Region facet fails to load                                     data-error                                                    about 5 months ago
#76   20200429_DML_FACET_UPDATES (part of, rename facet)             data-correction                                               about 1 year ago
#74   SEAD @2020.03 release (DATABASE) DONE!                         monthly-release                                               about 1 year ago
#73   Rename facet display title                                     help wanted, data-error, data-correction                      about 1 year ago
#72   Methods with unspecified or undefined record types             help wanted                                                   about 1 year ago
#71   20200422_DML_FACET_GRAPH_REROUTE: Missing facet graph rela...                                                                about 1 year ago
#70   Deprecate legacy tables                                        house-cleaning                                                about 1 year ago
#69   20200422_UPDATE_BUGS_REFERENCES_YEAR                           data-correction, bugs                                         about 1 month ago
#68   Add sp./spp. to all Genus currently lacking such instances     data-correction                                               about 1 year ago
#66   20200422_DML_MAL_QOS_UPDATE_02                                 data-correction                                               about 3 years ago
#65   Duplicate abbreviation values in tbl_relative_ages             bug, help wanted, question, data-error                        about 1 year ago
#64   20191012_DDL_ECOCODE_GEOJSON_EXPORT                            enhancement, help wanted, pending-approval                    about 1 year ago
#62   20200313_DML_BUGS_IMPORT_PUBLIC_20200219: Bugs incremental...  help wanted, pending-approval                                 about 1 month ago
#60   Improve sequence sync script                                                                                                 about 3 years ago
#59   Create script "copy-database"                                  enhancement                                                   about 1 year ago
#67   Time Period filter is not loading                                                                                            about 3 years ago
#57   Remove temporary databases from @2020.01 release.              house-cleaning                                                about 1 year ago
#61   Import Bugs database v20200219                                                                                               about 1 year ago
#56   SEAD @2020.02 release (DELAYED ETA 2020-03-15)                 monthly-release, delayed                                      about 3 years ago
#55   Add table descriptions to database model                       enhancement                                                   about 1 year ago
#54   20200219_DML_SITE_LOCATIONS_UPDATE                             data-error, unspecified-datatype                              about 1 month ago
#53   Data Quality Control                                           enhancement, quality-control                                  about 1 year ago
#52   SEAD @2020.01: Release checklist                               monthly-release                                               about 3 years ago
#51   20200422_DML_MAL_TAXA_SP_SPP_QOS_UPDATE                        data-correction                                               about 3 years ago
#50   Bugs Ecocodes system missing from Eco code System filter       data-error                                                    about 1 year ago
#48   20200120_DML_ADD_DOMAIN_FACETS: Add facet parent/child rel...  enhancement                                                   about 1 month ago
#47   Missing ceramics tables                                        help wanted, missing-data                                     about 3 years ago
#149  20200120_DML_ADD_DOMAIN_FACETS: Add facet portal functiona...  enhancement                                                   about 1 month ago
#58   Ceramics: Missing data in production                           data-error                                                    about 1 year ago
#45   20200210_DML_MAL_QOS_UPDATE_01: MAL dataset Quality Assura...  data-correction, unspecified-datatype                         about 1 month ago
#43   tbl_measured_value_dimensions and tbl_analysis_entity_dime...                                                                about 1 year ago
#39   20200203_DML_ADD_YEAR_TYPES: Populate tbl_years_types          missing-data, unspecified-datatype                            about 1 month ago
#38   20200203_DML_METHOD_UPDATE: Update characters in method de...  data-error, unspecified-datatype                              about 1 month ago
#63   Isotope: Remaining errors in Isotope data                      data-error                                                    about 1 year ago
#37   20200203_DML_FACET_UI_ELEMENTS_UPDATE: Correct Filter grou...  data-correction                                               about 1 month ago
#36   New Bugs methods must have fixed IDs.                          missing-data                                                  about 4 years ago
#35   20191221_DDL_UDF_BUGS_IMPORT_POST_APPLY: Add Bugs alt ref ...  missing-data                                                  about 1 month ago
#33   SEAD @2019.12: Release checklist                               monthly-release                                               about 1 year ago
#32   New result facet that targets datasets                         enhancement, missing-data                                     about 4 years ago
#31   New facet "Dataset methods"                                    enhancement, missing-data                                     about 4 years ago
#30   20190101_DDL_FACET_SCHEMA: New facet "Master datasets"         enhancement, missing-data                                     about 1 month ago
#29   20190101_DDL_FACET_SCHEMA: add facet description field         enhancement                                                   about 1 year ago
#28   20191219_DML_METHODS_UPDATE: Methods missing record type       invalid, missing-data, unspecified-datatype                   about 1 month ago
#27   Eco code system 4 missing                                      missing-data                                                  about 1 year ago
#26   20190101_DDL_FACET_SCHEMA: Region facet request                enhancement                                                   about 1 month ago
#25   Filter has corrupt name                                        data-correction                                               about 1 year ago
#24   Integration of temperature proxy data                          wontfix                                                       about 1 year ago
#23   Dendrochronology record type needed                            missing-data                                                  about 1 year ago
#22   20200315_DML_ECOCODE_ADD_SYSTEM_4: Anolds & van der Maarel...  new-data, archaeobotany                                       about 1 month ago
#21   Incorrect column name in queries to ecocode_definitions        bug                                                           about 1 year ago
#20   20191125_DML_CERAMICS_LOOKUP: Ceramics lookup data             missing-data                                                  about 1 year ago
#34   20191219_DML_METHODS_UPDATE: Method abbrev. is sometimes null  data-correction, unspecified-datatype                         about 1 month ago
#19   Wrong record_type for some methods?                                                                                          about 4 years ago
#18   20170101_DDL_BIBLIO_REFACTOR_MODEL: Biblio refactoring MAL...  consolidation                                                 about 1 month ago
#44   Facets: Measured value facets should target analysis entity    bug, data-error                                               about 1 year ago
#42   20191213_BUGS_IMPORT_POST_APPLY: Bugs Sample codes need to...  missing-data                                                  about 1 month ago
#17   20220916_DDL_RESULTS_CHRONOLOGY: analysis_entity_ages is e...  missing-data, new-data, archaeobotany, bugs                   about 1 month ago
#16   20191014_DML_DATASET_NULL_MASTER_ID                            data-error                                                    about 1 year ago
#15   20191012_DML_ASSOCIATION_TYPE_UPDATES                          data-error                                                    about 1 year ago
#14   20191012_DDL_ISOTOPE_MODEL                                     enhancement, isotope                                          about 1 month ago
#46   Bugs import assigns NULL value as system id to all ecocode...                                                                about 1 year ago
#13   Column facet.facet.facet_key changed to facet_code.            enhancement                                                   about 1 year ago
#12   Identity changed for ROOT facet group                          bug                                                           about 1 year ago
#11   Deploy of submission failed: "Cannot change to directory ....  bug                                                           about 1 year ago
#10   Sqitch reports "Use of uninitialized value"...                 bug                                                           about 1 year ago
#9    Inconsistent sqitch.plan prevents deploy                       bug                                                           about 1 year ago
#8    Add README file                                                                                                              about 4 years ago
#7    Improve script that creates new staging database               enhancement                                                   about 1 year ago
#6    Add CCS repository for security related tasks                  enhancement                                                   about 1 year ago
#5    20180613_DDL_AUDIT_DEPLOY_AUDIT_SYSTEM: Audit system           enhancement                                                   about 1 year ago
#49   20191222_DML_DATASET_SUBMISSION_UPDATE: Dataset submission...  missing-data, archaeobotany                                   about 1 month ago
#4    20170906_DDL_RELATIVE_DATES_ALTER_RELATION (update)            bug                                                           about 1 year ago
#3    SQL update of references after DDL refactor                    data-correction, quality-control                              about 1 year ago
#2    Review pending change set(s)                                   quality-control                                               about 1 year ago
#101  20190503_DDL_TAXA_ATTRIBUTE_TYPE_LENGTH SqlException           bug                                                           about 1 year ago
#100  Update all MAL-datasets that is NULL to ID 2                   bug                                                           about 1 year ago
#1    Consolidate public schema.                                     consolidation                                                 about 1 year ago
