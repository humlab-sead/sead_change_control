# Release Notes December 2023 

## Overview

This is a major release that involves new data (BugsCEP and dendrochronology data), schema changes and lots of improvements to the SEAD Change Control System, the way data and CRs are organized and stored, as well as improvements to utility scripts used in the release workflow.

Release highlights are:
- The release includes a full, non-incremental import of BugsCEP data from 2023-12-19.
- New dendrochronology data that (for now) replaces data from the pilot project.
- The release workflow now starts from a new empty SEAD database.
- A major overhaul and refactoring of the SEAD Import System.

### Changes to the SEAD Model (Schema Changes)

- SEAD_DATABASE_LOOKUPS: Generic (non data type specific) SEAD lookups now reside in a separate CR. ([#220](https://github.com/humlab-sead/sead_change_control/issues/220))
- 20220922_DDL_CHRONOLOGY_SCHEMA_CHANGES: Changes to chronology tables' schema ([#92](https://github.com/humlab-sead/sead_change_control/issues/92))
- 20220923_DDL_DEPRECATE_CHRON_CONTROLS: Deprecate tables ([#93](https://github.com/humlab-sead/sead_change_control/issues/93))
- 20231120_DML_DENDRO_MODEL: Updated schema for dendrochronology data ([#135](https://github.com/humlab-sead/sead_change_control/issues/135))

Changes to SEAD schema (SEAD_DATABASE_MODEL, [#217](https://github.com/humlab-sead/sead_change_control/issues/217)):

- All table and column comments have been moved to `sead_model\deploy\SEAD_DATABASE_MODEL\comments.sql`
- Explicit sequence definitions and defaults have been replaced with "serial" (int4) or "bigserial" (bigint)
- Default serial data type (most often a PK) is hence changed to integer (int) instead of bigint.
- Tables "tbl_analysis_entities", "tbl_abundances" and "tbl_measured_values" only tables with "bigserial" OK.
- PK column types have been changed to `serial/bigserial not null`, explicit sequenced removed ([#217](https://github.com/humlab-sead/sead_change_control/issues/217), [#220](https://github.com/humlab-sead/sead_change_control/issues/220), [76aecd1](https://github.com/humlab-sead/sead_change_control/commit/76aecd1c7aa5a81ab2ad38346769892e3f9f51e9)).
- FK column types changed to match referenced PK column type ([ddfb52b](https://github.com/humlab-sead/sead_change_control/commit/ddfb52b0beff03c976c42f81e36a97e6b3ce56e7)). Previously PK defined as sequence was `bigint`, FKs were `int` ([#224](https://github.com/humlab-sead/sead_change_control/issues/224)).
- It is a simple task to change type from "serial" to "bigserial" when needed.
- All _views_ in public schema have been dropped (deprecated):
   - view_taxa_tree
   - view_taxa_tree_select
- All _user defined functions_ in public schema have been removed (deprecated):
   - create_sample_position_view
   - get_transform_string
   - requiredtablestructurechanges
   - smallbiblioupdates
   - syncsequences
- All _user defined_ types in public schema have been removed (deprecated).
- Comments on tables & columns have now LF as linebreak (was CR/LF).
- ~~Timestamp is now timestamp(6), e.g. the same but with explicit precision~~.
- 20240104_DDL_DATE_SUBMITTED_TYPE: Type of `date_submitted` changed from `date` to `text` ([#219](https://github.com/humlab-sead/sead_change_control/issues/219), [#228](https://github.com/humlab-sead/sead_change_control/issues/228), [f7058d4](https://github.com/humlab-sead/sead_change_control/commit/f7058d482966021446f57b4fd7b0aa7ae7a6db44))
- Missing FK indexes have been added to a number of tables ([#202](https://github.com/humlab-sead/sead_change_control/issues/202), [f2f20e7](https://github.com/humlab-sead/sead_change_control/commit/f2f20e7e3cb7aace1a9b2c7e86a8ada56ed355be), [indexes.sql](https://github.com/humlab-sead/sead_change_control/blob/master/sead_model/deploy/SEAD_DATABASE_MODEL/indexes.sql))

### SEAD Data Changes

Changes to dendrochronology data

- 20191220_DML_SUBMISSION_DENDRO_XYZ_003_COMMIT: Data related to dendro pilot project has been deprecated ([#137](https://github.com/humlab-sead/sead_change_control/issues/137), [#206](https://github.com/humlab-sead/sead_change_control/issues/206), [#207](https://github.com/humlab-sead/sead_change_control/issues/207))
- 20231206_DDL_UPDATE_OF_DENDRO_RELATED_LOOKUPS: Add additional dendro lookup data related to new submission ([#153](https://github.com/humlab-sead/sead_change_control/issues/153), [#218](https://github.com/humlab-sead/sead_change_control/issues/218))
- 20231129_DML_ADD_TAXONOMIC_ORDER_DYNTAXA: Added SBDI taxonomic order `Dyntaxa` ([Create species mapping in SEAD](https://github.com/humlab-sead/sbdi/issues/1), [#141](https://github.com/humlab-sead/sead_change_control/issues/141))
- 20231120_DML_DENDRO_LOOKUP: Additional dendro-related lookups ([#136](https://github.com/humlab-sead/sead_change_control/issues/136), [#153](https://github.com/humlab-sead/sead_change_control/issues/153))
- 20231120_DML_DENDRO_LOOKUP: Fix handling of lookups common to both CRs ([#20](https://github.com/humlab-sead/sead_change_control/issues/20), [#148](https://github.com/humlab-sead/sead_change_control/issues/148), [2316d0f](https://github.com/humlab-sead/sead_change_control/commit/2316d0f3b8f54c9982f120f8c9fa4439d97860ff))
- 20231120_DML_DENDRO_MODEL: Revised. Added missing FK constraint to `tbl_seasons` ([#135](https://github.com/humlab-sead/sead_change_control/issues/135), [f0a84e6](https://github.com/humlab-sead/sead_change_control/blob/f0a84e6273050d244f160e390a09f6c4d9963dff/dendrochronology/deploy/20231120_DML_DENDRO_MODEL.sql))

Changes to BugsCEP data

- 20231211_DML_SUBMISSION_BUGS_20231219_COMMIT: A full import of BugsCEP database dated 2023-12-19 ([#162](https://github.com/humlab-sead/sead_change_control/issues/162)).
- 20220916_DDL_RESULTS_CHRONOLOGY: Adds chronology dating data to BugsCEP physical samples ([#17](https://github.com/humlab-sead/sead_change_control/issues/17), [#248](https://github.com/humlab-sead/sead_change_control/issues/248)).
- 20200422_DML_UPDATE_BUGS_REFERENCES_YEAR ([#69](https://github.com/humlab-sead/sead_change_control/issues/69), update of erroneous year in BugsCEP references).
- 20200316_DDL_BUGS_ECOCODE_GEOJSON Moved to ([#64](https://github.com/humlab-sead/sead_change_control/issues/64), @2023-12 since it is dependent on 20231211_DML_SUBMISSION_BUGS_20231219_COMMIT)

Note: See issue [#248](https://github.com/humlab-sead/sead_change_control/issues/248) for a log of warnings occuring when deploying 20220916_DDL_RESULTS_CHRONOLOGY.

Deprecated changes related to BugsCEP data:

- 20191221_DML_SUBMISSION_BUGS_20190303_COMMIT ([#204](https://github.com/humlab-sead/sead_change_control/issues/204), replaced by [#162](https://github.com/humlab-sead/sead_change_control/issues/162), first BugsCEP import).
- 20191012_DML_ASSOCIATION_TYPE_UPDATES ([#15](https://github.com/humlab-sead/sead_change_control/issues/15), moved to [#226](https://github.com/humlab-sead/sead_change_control/issues/226))
- 20191221_DML_SUBMISSION_BUGS_20190303_COMMIT ([#204](https://github.com/humlab-sead/sead_change_control/issues/204), initial BugsCEP import).
- 20191221_DML_SUBMISSION_BUGS_20190303_POST_APPLY (part of [#204](https://github.com/humlab-sead/sead_change_control/issues/204))
- 20200315_DML_BUGS_IMPORT_POST_APPLY_20200219 (developed as part of [#62](https://github.com/humlab-sead/sead_change_control/issues/62))
- 20200313_DML_BUGS_IMPORT_PUBLIC_20200219 ([#62](https://github.com/humlab-sead/sead_change_control/issues/62), import of data in `public` schema)
- 20200313_DML_BUGS_IMPORT_TRACE_20200219 ([#62](https://github.com/humlab-sead/sead_change_control/issues/62), import of data in `bugs_import` schema)
- 20231212_DML_BUGS_ADD_ANALYSIS_ENTITY_AGES ([#164](https://github.com/humlab-sead/sead_change_control/issues/164), modelled official ages for 889 BugsCEP samples)

Changes to MAL data exported from SEAD master 9

- MAL data now exists as three separate CRs (`mal` project folder).
- 20100101_DML_SUBMISSION_MAL_000_LOOKUPS ([#222](https://github.com/humlab-sead/sead_change_control/issues/222), MAL lookup data)
- 20100101_DML_SUBMISSION_MAL_000_TAXA ([#223](https://github.com/humlab-sead/sead_change_control/issues/223), MAL taxonomic data)
- 20100101_DML_SUBMISSION_MAL_000_COMMIT ([#221](https://github.com/humlab-sead/sead_change_control/issues/221), MAL data)
- 20221206_DML_QUALITY_CONTROL_DATASETS_UPDATES ([#145](https://github.com/humlab-sead/sead_change_control/issues/145), updates to MAL bibliographic references)

Revised CR that uses explicit (unstable) updates targeting specific identities

- 20221205_DML_QUALITY_CONTROL_BIBLIO_UPDATES ([#146](https://github.com/humlab-sead/sead_change_control/issues/146), revised to use reference instead of identity)

The following CRs still have severe identity crisis

- 20221206_DML_QUALITY_CONTROL_DATASETS_UPDATES (moved to MAL, ceramics updates excluded [#145](https://github.com/humlab-sead/sead_change_control/issues/145), [#243](https://github.com/humlab-sead/sead_change_control/issues/243), [#81](https://github.com/humlab-sead/sead_change_control/issues/81))
- 20200422_DML_MAL_QOS_UPDATE_02
- (more CRs exist)

The following CRs are excluded due to sever identity crisis

- 20221206_DML_QUALITY_CONTROL_DATASETS_UPDATES (no longer valid identities [#243](https://github.com/humlab-sead/sead_change_control/issues/243), [#81](https://github.com/humlab-sead/sead_change_control/issues/81))
- 20191219_DML_METHODS_UPDATE ([#34](https://github.com/humlab-sead/sead_change_control/issues/34))
- 20200219_DML_SITE_LOCATIONS_UPDATE ([#54](https://github.com/humlab-sead/sead_change_control/issues/54))

Changes to Clearing House Data

- 20191221_DML_CLEARINGHOUSE_STARTINGPOINT: Deprecated (with old dendro data)
- 20231219_DML_CLEARINGHOUSE_STARTINGPOINT: Starting point with only ceramics and isotope data ([#214](https://github.com/humlab-sead/sead_change_control/issues/214))
- 20191217_DDL_CLEARINGHOUSE_SYSTEM: Revised, pinned table identities ([#215](https://github.com/humlab-sead/sead_change_control/issues/215), [1b3cc07](https://github.com/humlab-sead/sead_change_control/commit/1b3cc075277fc490b6b17c3f3aa2be28c09641a4))

### Changes to CR Projects and Existing CRs

Structural changes

- Changed folder structure of the SEAD Change Control System (([#197](https://github.com/humlab-sead/sead_change_control/issues/197)):
   - Addition of data type specific projects: `mal`, `bugs`, `ceramics`, `isotope`, `dendrochronology`.
   - Added project `sead_model` for SEAD model and schema changes. ([#217](https://github.com/humlab-sead/sead_change_control/issues/217), [#230](https://github.com/humlab-sead/sead_change_control/issues/230))
   - Removed `submissions` project ([#197](https://github.com/humlab-sead/sead_change_control/issues/197))
   - CRs (not all, need help here) have been moved to correct folder ([#197](https://github.com/humlab-sead/sead_change_control/issues/197)).
   - The SEAD model DDL scripts are stored in tables.sql, foreign_keys.sql, comments.sql, grants.sql, indexes.sql.
- All CRs have been update with link to corresponding Github issue ([dcc4717](https://github.com/humlab-sead/sead_change_control/commit/dcc4717bc454480c8867403068f5dee0dd3c3ed3), ...).

Mostly house cleaning changes

- 20190408_DML_UPDATE_LOCATION_RECORD deprecated (merged into [#20](https://github.com/humlab-sead/sead_change_control/issues/20))
- 20120921_DML_RECORD_TYPE_UPDATE_PLANTS_POLLEN: Raise error if target records are missing ([b273ea4](https://github.com/humlab-sead/sead_change_control/commit/b273ea4b274c00c44a7c454b6ae60d87a2eaff25))
- 20231207_DML_FACET_GRAPH_UPDATE: removed (empty CR)
- 20200422_UPDATE_BUGS_REFERENCES_YEAR: Changed so that update targets `bugs_reference` instead of `biblio_id`.
- 20221205_DML_CERAMICS_METHOD_ID_UPDATE: Update by explicit method names.
- 20221121_DML_DENDRO_LOOKUP_STANDARD_UPDATE: Removed unknown CR (was empty noop).
- 20221121_DML_QSE_DENDRO_DATING: Revised to conform with new dendrochronology schema ([#135](https://github.com/humlab-sead/sead_change_control/issues/135), [#156](https://github.com/humlab-sead/sead_change_control/issues/156))
- 20191213_DML_DENDRO_LOOKUP: Deprecate tables `tbl_error_uncertainties` and `tbl_season_or_qualifier` ([#135](https://github.com/humlab-sead/sead_change_control/issues/135), [#148](https://github.com/humlab-sead/sead_change_control/issues/148))
- 20170810_DDL_DATAARC_DATASRC_API: Deprecated (replaced by [#000](https://github.com/humlab-sead/sead_change_control/issues/000))
- 20191012_DDL_FACET_MEASURED_VALUE_UDF: Merged into 20190101_DDL_FACET_SCHEMA in prior release ([#160](https://github.com/humlab-sead/sead_change_control/issues/160))
- 20190101_DML_FACETS_LOOKUP: Moved facet lookups to separate CR ([#160](https://github.com/humlab-sead/sead_change_control/issues/160), [#213](https://github.com/humlab-sead/sead_change_control/issues/213))
- 20231120_DML_DENDRO_LOOKUP, 20191213_DML_CERAMICS_LOOKUP: Fix handling of lookups common to both CRs ([#20](https://github.com/humlab-sead/sead_change_control/issues/20), [#148](https://github.com/humlab-sead/sead_change_control/issues/148), [2316d0f](https://github.com/humlab-sead/sead_change_control/commit/2316d0f3b8f54c9982f120f8c9fa4439d97860ff))
- 20200507_DDL_FACET_ABUNDANCE_UPDATE: Fixed failure in update of view caused by changes underlying table schemas ([35f8689](https://github.com/humlab-sead/sead_change_control/commit/35f86894199fd8914c3077410e4000b69b4f00ce)) 

### Changes to SEAD Clearing House Import System (https://vscode.dev/github/humlab-sead/sead_clearinghouse_import/pull/28)

This system imports a prepared Excel file into the SEAD Clearing House. 

The system has been vastly improved, simplified and made more resilient to changes in the SEAD public schema. ([PR [#28](https://github.com/humlab-sead/sead_change_control/issues/28)](https://github.com/humlab-sead/sead_clearinghouse_import/pull/28))

- Migration to `pypoetry`
- Now uses schema from specified SEAD database (previously dependent on schema in Excel file).
- More complete validation of input file.
- Better test converage and test fixtures (test data).
- Improved extensibility (validation, upload strategy)
- Improved logging.
- Improved CLI, more options for step-by-step import.
- Added client side XML parsing, and CSV upload ([6daa0cf](https://github.com/humlab-sead/sead_clearinghouse_import/commit/6daa0cf34f2b77009a07fe9af964ef54ca5a4461)).



### Changes to SEAD Clearing House Transport System

This system exports a (ready-to-be-commited) submission from the SEAD Clearing House to a SEAD Change Control CR.

Improved and more resiliant version:

- Added UDFs that perform rollback of a transport commit ([2e2c323](https://github.com/humlab-sead/sead_clearinghouse/commit/2e2c3234c0b12fea354eaed7042c22d58268b1c9))
- Fixed bug in XML transport script ([14ec2c6](https://github.com/humlab-sead/sead_clearinghouse/commit/14ec2c694ccd7a3ce4be833b4f6494f867aca031))
- Add casting of FKs types when resolving FK public identities ([3d4c993](https://github.com/humlab-sead/sead_clearinghouse/commit/3d4c993588a809f1db6c44aab0d24621d6c11c73))
- Moved script that creates submission's CR to SEAD change control system ([ddc3e51](https://github.com/humlab-sead/sead_clearinghouse/commit/ddc3e51a82dd565bb85f1d5395014f3adf9ad79a))
- Improved script that bundles SEAD Clearinghouse import system into a CR ([c051a68](https://github.com/humlab-sead/sead_clearinghouse/commit/c051a683b6f6d35fbba5fdd21dd2125d09e9babe))
- Fixed value out of range bug when resolving PKs ([45eb941](https://github.com/humlab-sead/sead_clearinghouse/commit/45eb941a536ded04570698ca93987c771e23dbac))
- Renamed bundle script ([a7e33ca](https://github.com/humlab-sead/sead_clearinghouse/commit/a7e33caeaf44fdc17ebd04cdfe285dcbf0119eff))
- Removed very dangerous automatic delete of conflicting records ([a7e33ca](https://github.com/humlab-sead/sead_clearinghouse/commit/a7e33caeaf44fdc17ebd04cdfe285dcbf0119eff))
- Fixed error caused by PostgreSQL upgrade to v16.1 ([9074277](https://github.com/humlab-sead/sead_clearinghouse/commit/9074277ba9a40d5941b8d8c4f6d8205869805923))
- 20240112_DDL_CLEARINGHOUSE_UPLOAD_CSV: Major change: Moved away from XML upload and server side parsing to client parsing and CSV upload. ([#27](https://github.com/humlab-sead/sead_change_control/issues/27), [#230](https://github.com/humlab-sead/sead_change_control/issues/230))

### Changes to SEAD Change Control System

- Sqitch plans now contain links to Github issues (automatic updated when creating CRs).
- Deploy (can) now start from an empty database.
- Deploy from previous starting point (`sead master 9`) is still possible.

### Changes to Utility Scripts (Bash)

Improvements to `add-change-request` script 

- Added options to create and link Github issue ([42f5ca3](https://github.com/humlab-sead/sead_change_control/commit/42f5ca37753d3b867fed9f0ccf62c3b0f10d49bf))

Improvements to `deploy-staging` script 

- Resolved [#161](https://github.com/humlab-sead/sead_change_control/issues/161) ([ec75ff0](https://github.com/humlab-sead/sead_change_control/commit/ec75ff051bc176dca0e6b96c86b566c888203bdb))
- Added `--help` option ([680cecd](https://github.com/humlab-sead/sead_change_control/commit/680cecdd6c4f5dc8e6d94560a561ea9ace57e306))
- Refactored common logic to utility script ([f70cd31](https://github.com/humlab-sead/sead_change_control/commit/f70cd3133e47eec31510109076b3931751de1c12))
- Added option `--deploy-starting-point` ([96c1dfa](https://github.com/humlab-sead/sead_change_control/commit/96c1dfa1104a17210a87aac0430d9a5ecd9bed5f))
- Fixed help text and added `empty` starting point ([f265afa](https://github.com/humlab-sead/sead_change_control/commit/f265afaddde126933f1a8a39f51a34c90b855d7e))
- Added `--deploy-single-change-request` ([50d86ba](https://github.com/humlab-sead/sead_change_control/commit/50d86ba8d55783d98cfedf4d6afc206a00b7713c))
- Added `--sync-sequences` ([
9bfa21](https://github.com/humlab-sead/sead_change_control/commit/)
9bfa21eedb17551914ed380e0a1dfe6607da6e16)
- Added before/after deploy hooks that are bash scripts executed before a project's release targeting a certain deploy tag. This hooks must be placed in a project's root folder and be named as `@YYYY-MM-pre-deploy-hook` and `@YYYY-MM-post-deploy-hook` and reside in project's folder. `@YYYY-MM` must be a valid tag in the project's `sqitch.plan` (e.g. `bugs/@2023.12-post-deploy-hook`). The hooks can be used for e.g. decompressing/compressing large files used by CRs that target specified tag ([#133](https://github.com/humlab-sead/sead_change_control/issues/133), [#162](https://github.com/humlab-sead/sead_change_control/issues/162),[e589995](https://github.com/humlab-sead/sead_change_control/commit/e589995d136bf036bbc242f37429d0199b4121b8), [bd5dd60](https://github.com/humlab-sead/sead_change_control/commit/bd5dd60dc7aeb7460f38fe3a8b21cf0810463215))
- Each database can now be deployed in order of deploy tags in one go ([a9afa05](https://github.com/humlab-sead/sead_change_control/commit/a9afa0552769bd3cf024afb02d4173af9b6076f3)).
- Added option to prevent release if specified tag doesn't exist in git ([bd5dd60](https://github.com/humlab-sead/sead_change_control/commit/bd5dd60dc7aeb7460f38fe3a8b21cf0810463215))
- Fixed problems occuring when kicking out users during deployment ([#161](https://github.com/humlab-sead/sead_change_control/issues/161))
- Added file `projects.txt` that pins order in which projects are deployed ([#132](https://github.com/humlab-sead/sead_change_control/issues/132), [d0cc954](https://github.com/humlab-sead/sead_change_control/commit/d0cc9544aad6e9c21e2767dc7e3ba510aadaf55d))
- Default deploy order: `utility sead_model security general mal archaeobotany dendrochronology bugs isotope ceramics subsystem sead_api`

Other improvements
- Added script `add-issue` that given a CR creates a placeholder issue (or links an existing issue) and updates links in CR script, and adds a link in the issue to the deploy script.
- Added script `add-issue-refs` that uses Github CLI client `gh` to add comment in existing CR issue with links to CR SQL deploy script.
- Added script `tag-projects` that assigns a tag to all projects ([391f936](https://github.com/humlab-sead/sead_change_control/commit/391f93671b3c80ce3420c033da26c39e4ed872a4))
- Added script `rm-cr` ([a600a61](https://github.com/humlab-sead/sead_change_control/commit/a600a6151d55093b651e35dc79e8773ce9637628)) ... [43a4fd3](https://github.com/humlab-sead/sead_change_control/commit/43a4fd3e23b5d3cdba98ff848af4b4eaf0e92f45) that archives a CR.
- Added script `mv-cr` ([8ffa495](https://github.com/humlab-sead/sead_change_control/commit/8ffa4954a5291a5bd03011658b44412fa653bfb6)) ... [e504177](https://github.com/humlab-sead/sead_change_control/commit/e504177e262002647fc65c6767f08abe6ff1c0d4) that moves a CR to another project while preserving links to code and issue, and also preserving deploy tag.
- Added script `update-cr-header` ([e504177](https://github.com/humlab-sead/sead_change_control/commit/e504177e262002647fc65c6767f08abe6ff1c0d4))... that updates CR name and link to Github issue in CR's deploy file.

Improvements to `dump-database` script

- Added option to exclude owners and privileges ([4f2eda9](https://github.com/humlab-sead/sead_change_control/commit/4f2eda96f3e2cedea9491be572f0ad3c1747676d))
- Added option to compress data file ([1f4e582](https://github.com/humlab-sead/sead_change_control/commit/1f4e582e25386e0e929da10a8c8aa9953078beb2))

New script `create-bugs-sync-script`

- Creates a SQL sync script of state of the SEAD database before and after a BugsCEP import. This script is a vital part of the BugsCEP import workflow.
- The script generates a complete deploy script that can be added to a new CR that commits a BugsCEP import into the SEAD database.
- The script is located in folder `bugs/bugs-import-sync`.
- This script uses Devart dbForge DataCompare and msut be run from within WSL2 on a computer with this application installed.

New script `add-submission-change-request`

- This script bundles a data submission residing in `ready-to-commit` state in the SEAD Clearing House System.
- The script originates from SEAD Clearing House system but has been improved and made more resilient. ([8ffa495](https://github.com/humlab-sead/sead_change_control/commit/8ffa4954a5291a5bd03011658b44412fa653bfb6)) ... ([e504177](https://github.com/humlab-sead/sead_change_control/commit/e504177e262002647fc65c6767f08abe6ff1c0d4))
- This script is part of the workflow that submits a new data submission into SEAD production via SEAD Change Control System.


### Changes to SEAD SQL Utility Scripts (UDFs in schema sead_utility)

- Added UDF `sead_utility.constraint_exists` ([#202](https://github.com/humlab-sead/sead_change_control/issues/202), [59ff112](https://github.com/humlab-sead/sead_change_control/commit/59ff112c26a86c3fee4c414d49ab9e4ee17406cd))
- Added UDF `sead_utility.get_all_table_counts` ([1640738](https://github.com/humlab-sead/sead_change_control/commit/16407381c37d5a3c6ee237aa645b42b326ff5f3c))
- Added view `sead_utility.view_fk_index_check` ([#202](https://github.com/humlab-sead/sead_change_control/issues/202), [dea947f](https://github.com/humlab-sead/sead_change_control/commit/dea947fb3904be7be749c3de4a85e70899e333d2)). Renamed to `foreign_keys_index_check` ([bf54b98](https://github.com/humlab-sead/sead_change_control/commit/bf54b98469a40a6bdfd4b1e9663b8b37b96634fb))
- Added UDP `sead_utility.set_schema_privilege` for assigning privileges ([59ac041](https://github.com/humlab-sead/sead_change_control/commit/59ac0419efaf6484375888e281270f3ce19d34ba))
- Added UDF `sead_utility.chown` for changing object's owner ([59ac041](https://github.com/humlab-sead/sead_change_control/commit/59ac0419efaf6484375888e281270f3ce19d34ba))
- Added UDF `sead_utility.get_column_type` that returns column's type ([95985c7](https://github.com/humlab-sead/sead_change_control/commit/95985c763712fcde9a152b30848c1353b914db75))

### Changes Related to BugsCEP Import System

- 20190503_DDL_BUGS_SETUP_SCHEMA: Revised. Added unique constraints and (ignore dupes) triggers on `bugs_import.bugs_type_translations` and `bugs_import.id_based_translations` ([b0a705a](https://github.com/humlab-sead/sead_change_control/commit/b0a705a32790a5f29ce433d721f11580c22f2ee8)).

### Bug fixes

- CRs are applied in wrong order ([#132](https://github.com/humlab-sead/sead_change_control/issues/132))
- [20200429_DDL_UDF_FACET_UPDATE: Missing domain facet children](https://github.com/humlab-sead/sead_change_control/issues/140) ([#140](https://github.com/humlab-sead/sead_change_control/issues/140))
- [20220916_DDL_RESULTS_CHRONOLOGY: Error in dataset name](https://github.com/humlab-sead/sead_change_control/issues/143) ([#143](https://github.com/humlab-sead/sead_change_control/issues/143))
- 20190407_DDL_UTILITY_SYNC_ALL_SEQUENCES: Revised, prevent incorrect initialisation of sequences: ([8f8b160](https://github.com/humlab-sead/sead_change_control/commit/8f8b160624ad42ab0b6cdcb79bf217d7a9b955a0))
- 20190407_DDL_UTILITY_CREATE_UTILITY_SCHEMA: Revised, fixed wrong object owner ([bf54b98](https://github.com/humlab-sead/sead_change_control/commit/bf54b98469a40a6bdfd4b1e9663b8b37b96634fb)).
- Fixed several CRs neglected to update sequences after explicit identity insert ([df1f204](https://github.com/humlab-sead/sead_change_control/commit/df1f2048d0d1dd7c6e1c84a21392281260e08610) through [bff0dd4](https://github.com/humlab-sead/sead_change_control/commit/bff0dd4c6d2d5aa3be48ffee6d6ebe57eadbd9a6))
- 20220916_DDL_RESULTS_CHRONOLOGY: Revised, fixed assignment of incorrect count sheet code ([36ce4e4](https://github.com/humlab-sead/sead_change_control/commit/36ce4e43ef0b63eebd8d2c5b4fdbfd0558ddb035)).
- 20220916_DDL_RESULTS_CHRONOLOGY: Revised, fixed error caused by new BugsCEP data that doesn't exist CR ([3423b89](https://github.com/humlab-sead/sead_change_control/commit/3423b896476fe8d478b9bef12a14fb9e0e30b7b9))
- 20240112_DDL_CLEARINGHOUSE_UPLOAD_CSV: Fixed bug in xpath queries ([9f80268](https://github.com/humlab-sead/sead_change_control/commit/9f8026809a7e8dc2d35b640b45c7b88235bf3f1a)).

### Known Issues and Problems

 - There still exist CRs doing dangerous identity updates. Identity updates should be prevented or avoided that targets data, but are OK for lookups.
 - Some updates should have additional criterias beside identity (better that they are rendered noop instead of doing faulty updates)
 - Some links in CR issue to e.g. CR's SQL deploy file is wrong. Most often this happens for moved CRs, and in which case the link should be updated with correct project in URL.
 - Note! Updates of bibliographic references targeting ceramics data has been excluded ([#82](https://github.com/humlab-sead/sead_change_control/issues/82), [#243](https://github.com/humlab-sead/sead_change_control/issues/243)). Referenced identities does not exist in any database.

### Overview of Deployment Workflow

#### Import of new BugsCEP data

1. Using `sead_change_control`, create a target database for BugsCEP import by deploying all CRs up until new (not yet created) BugsCEP CR.

```bash
./bin/deploy-staging --create-database --on-conflict drop --source-type empty --target-db-name sead_staging_202312_bugs --deploy-to-tag @2023.12 --ignore-git-tags
```
same as

1. Using Github, create a relase milestone.

1. Using Github, assign relevant issues to release milestone.

1. Using `sead_change_control`

   ```bash
   bin/copy-database --source sead_staging_202312 --target sead_staging_202312_bugs --force --sync-sequences
   ```

1. Perform a new BugsCEP import and create a CR

   - Using `sead_bugs_import`, download latest version of the BugsCEP MS Access data file:

      ```bash
      ./bugs/bin/download-bugs-data
      ```

   - Set target database in conf/application.properties
      ```conf
         spring.datasource.url=jdbc:postgresql://servername:port/sead_staging_202312_bugs
      ```

   - Run bugsimport

      ```bash
      nohup java -jar target/bugs.import-0.1-SNAPSHOT.jar --file=./bugsdata/bugsdata_20231219.mdb > logfile.log 2>&1 &
      ```

   - Using `sead_change_control` on `wsl2` (need access to dbForege DataCompare):

      ```bash
      ./bugs/bin/create-bugs-sync-script -t ALL --source-database sead_staging_202312_bugs --target-database sead_staging_202312
      ```

   - Create a new CR for BugsCEP import

      ```bash
      bin/add-change-request --project submissions \
         --change 20231211_DML_SUBMISSION_BUGS_20230705_COMMIT \
         --create-issue \
         --note "Full (inital) non-incremental import of BugsCEP data version 20230705."
      ```

      Add sync SQL scripts to folder bugs/deploy/20231211_DML_SUBMISSION_BUGS_20230705_COMMIT
      Add (replace existing) code in bugs/deploy/20231211_DML_SUBMISSION_BUGS_20230705_COMMIT.sql with:

      ```sql      
      set client_encoding = 'UTF8';
      set client_min_messages to warning;
      \set autocommit off;

      set search_path TO public;

      do $$ begin
         perform sead_utility.sync_sequences('bugs_import');
         perform sead_utility.set_fk_is_deferrable('public', true, false);
      end $$ language plpgsql;

      begin;

      set constraints all deferred;

      \ir 20231211_DML_SUBMISSION_BUGS_20231219_COMMIT/public.sql
      \ir 20231211_DML_SUBMISSION_BUGS_20231219_COMMIT/bugs_import.sql

      commit;

      do $$ begin
         perform bugs_import.post_import_updates();
         perform sead_utility.set_fk_is_deferrable('public', false, false);
         perform sead_utility.sync_sequences('public');
         perform sead_utility.sync_sequences('bugs_import');
      end $$ language plpgsql;
      ```

1. Import new dendrochronology data

   - Prepare Excel with new data

   - Using `sead_clearinghouse_import`, import the Excel into SEAD Clearing House

      ```
      PYTHONPATH=. python importer/scripts/import_excel.py \
         data/input/building_dendro_2023-12_import_v6.xlsx --no-timestamp --database sead_staging_202212 --register
            --explode --data-types dendrochronology --transfer-format csv
      ```

   - Using Clearing House `https://`, verify the submitted data.

   - Using `sead_change_control`, bundle submitted data into a CR

      ```
      bin/add-submission-change-request --id 5 --database sead_staging_202212 --project dendrochronology --note "Dendrochronology V6"
      ```

1. Using `sead_change_control` deploy new `sead_staging` databases:

### Release Checklist

 - [x] Update/lock current version of SEAD change control system
 - [x] Archive current SEAD production database
 - [x] Add release tag to Sqitch database versioning plan
 - [x] Create a new staging database
 - [x] Deploy pending changes to staging
 - [*] Add release tag to SEAD change control repository
 - [x] Create Release Notes (issue, change log)
 - [ ] Acceptance testing GO/NOGO
 - [ ] Deploy to production
 - [ ] Close milestone
 - [ ] Prepare next months release:
    - [ ] Add new milestone
    - [ ] Add new release project
    - [ ] Add database release issue (use this issue as a template)
