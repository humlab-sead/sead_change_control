# 📦 Changelog 
[![conventional commits](https://img.shields.io/badge/conventional%20commits-1.0.0-yellow.svg)](https://conventionalcommits.org)
[![semantic versioning](https://img.shields.io/badge/semantic%20versioning-2.0.0-green.svg)](https://semver.org)
> All notable changes to this project will be documented in this file


## [1.14.0](https://github.com/humlab-sead/sead_change_control/compare/v1.13.2...v1.14.0) (2026-02-12)

### 🍕 Features

* add new tables for storing generic key-value properties ([#412](https://github.com/humlab-sead/sead_change_control/issues/412)) ([86d426a](https://github.com/humlab-sead/sead_change_control/commit/86d426a72230fec20f098a5758e6948d5ec70e70))

## [1.13.2](https://github.com/humlab-sead/sead_change_control/compare/v1.13.1...v1.13.2) (2026-02-12)

### 🐛 Bug Fixes

* correct SQL file references in SEAD_MODEL_COMMENTS and COUNTRY_CODES scripts ([8a4b71c](https://github.com/humlab-sead/sead_change_control/commit/8a4b71ccb63fa91335b30c9893d92b48564466b5))

## [1.13.1](https://github.com/humlab-sead/sead_change_control/compare/v1.13.0...v1.13.1) (2026-02-11)

### 🐛 Bug Fixes

* disable password (assume .pgpass) ([d292d8a](https://github.com/humlab-sead/sead_change_control/commit/d292d8ab9fc62dd614194419f83c2ff8f85f95a2))
* moved load of comments away from SEAD model ([#441](https://github.com/humlab-sead/sead_change_control/issues/441)) ([b1d92be](https://github.com/humlab-sead/sead_change_control/commit/b1d92be5676c898e760f4ae55b2b94abeed0680a))

## [1.13.0](https://github.com/humlab-sead/sead_change_control/compare/v1.12.0...v1.13.0) (2026-02-10)

### 🍕 Features

* add February 2026 release entries to sqitch plans across multiple projects ([3536770](https://github.com/humlab-sead/sead_change_control/commit/35367704660adb8bfaca6365a5fb7618067dcdd0))

### 🐛 Bug Fixes

* correct command execution in tag_projects function and ensure strict error handling ([6e5a87c](https://github.com/humlab-sead/sead_change_control/commit/6e5a87c468a3f1e2cd5fc5f249ca8c2d822f8dbb))

## [1.12.0](https://github.com/humlab-sead/sead_change_control/compare/v1.11.0...v1.12.0) (2026-02-10)

### 🍕 Features

* add country codes to utility table ([e6d1cca](https://github.com/humlab-sead/sead_change_control/commit/e6d1ccaddc8b23e6b1d62ebba90a000ca94bb962))
* add utility functions for singularization and entity name conversion, and create full-text search materialized view ([5c5b2de](https://github.com/humlab-sead/sead_change_control/commit/5c5b2dedaf98ac31c71a5b5b1f661209188d0fee))

## [1.11.0](https://github.com/humlab-sead/sead_change_control/compare/v1.10.0...v1.11.0) (2026-02-10)

### 🍕 Features

* add project review document for SEAD Change Control System ([16eb89f](https://github.com/humlab-sead/sead_change_control/commit/16eb89f542a0c0d32b3005d321df20e7f972a6ca))
* add script to update repository topics with a specified topic ([f224f61](https://github.com/humlab-sead/sead_change_control/commit/f224f61a4daa878c08b22aabe5126ceedd8f802c))
* add SQLFluff configuration for consistent SQL formatting ([b20658a](https://github.com/humlab-sead/sead_change_control/commit/b20658a066f59e8fa3bef4d940900076fd1867a0))
* iniial commit for radiocarbon pilot data ([59194bd](https://github.com/humlab-sead/sead_change_control/commit/59194bdb0f38804c8719420f793c3458df38c1bb))

## [1.10.0](https://github.com/humlab-sead/sead_change_control/compare/v1.9.0...v1.10.0) (2026-02-01)

### 🍕 Features

* add aDNA accession link deployment scripts ([#395](https://github.com/humlab-sead/sead_change_control/issues/395)) ([35030dc](https://github.com/humlab-sead/sead_change_control/commit/35030dcd629d5127d922429cebd38b8a05d74ed7))
* enhance aDNA accession link script with distinct selection ([c37b855](https://github.com/humlab-sead/sead_change_control/commit/c37b855150a56ec71073ca5e07bd7454163e41b1))

## [1.9.0](https://github.com/humlab-sead/sead_change_control/compare/v1.8.0...v1.9.0) (2026-02-01)

### 🍕 Features

* implement post-deploy hook for ancient DNA method and dataset updates ([43e60fd](https://github.com/humlab-sead/sead_change_control/commit/43e60fdada4d70e609d9e654bef23a32f2d677d7))

## [1.8.0](https://github.com/humlab-sead/sead_change_control/compare/v1.7.0...v1.8.0) (2026-02-01)

### 🍕 Features

* add dataset and method files for ancient DNA analysis ([e729851](https://github.com/humlab-sead/sead_change_control/commit/e729851654ee64180a559d910dd2af30d3af4f35))
* add post-deploy hook for ancient DNA dataset insertion ([3479f47](https://github.com/humlab-sead/sead_change_control/commit/3479f470fcad71630fe1e1a3c4f7366599da3aa7))
* add two separate methods for aDNA data ([#366](https://github.com/humlab-sead/sead_change_control/issues/366)) ([3f5def4](https://github.com/humlab-sead/sead_change_control/commit/3f5def484a89fa85f926065ce6c184dc2e83af34))

## [1.7.0](https://github.com/humlab-sead/sead_change_control/compare/v1.6.0...v1.7.0) (2026-01-20)

### 🍕 Features

* add AI agent guidelines for SEAD Change Control System ([9327005](https://github.com/humlab-sead/sead_change_control/commit/932700537538e927f4485002d58b47cb155149c4))
* add comprehensive release notes for December 2023 major release ([d396a09](https://github.com/humlab-sead/sead_change_control/commit/d396a0987e00e4fce0557d56c46a53b85cf4ce10))

## [1.6.0](https://github.com/humlab-sead/sead_change_control/compare/v1.5.0...v1.6.0) (2026-01-20)

### 🍕 Features

* add AI assistant instructions for SEAD Change Control System ([f1b987b](https://github.com/humlab-sead/sead_change_control/commit/f1b987b1feaa5ef53ce5a9c19cb46787ba355661))

### 🐛 Bug Fixes

* clean up psql.sh formatting and improve command echoing ([9582a3f](https://github.com/humlab-sead/sead_change_control/commit/9582a3f615268101cf1aba7cb3c8f1cfbd0a0539))
* remove 'docs' entry from .gitignore and ensure proper newline at end of file ([3525449](https://github.com/humlab-sead/sead_change_control/commit/35254494a56b9add71a71acecdb11c168cdb3e15))

## [1.5.0](https://github.com/humlab-sead/sead_change_control/compare/v1.4.4...v1.5.0) (2025-11-20)

### 🍕 Features

* add DDL for site types including tables and initial data ([82001c7](https://github.com/humlab-sead/sead_change_control/commit/82001c72f920cdc2c9cc0cd6a82aa35f5caacba0))
* add script to generate SQL comment statements from CSV ([a266049](https://github.com/humlab-sead/sead_change_control/commit/a266049d476bb09153472a34ebda67559fb31481))

### 🐛 Bug Fixes

* correct casing of 'Evaluation_date' to 'evaluation_date' in site preservation status table ([#217](https://github.com/humlab-sead/sead_change_control/issues/217)) ([2e3ed23](https://github.com/humlab-sead/sead_change_control/commit/2e3ed23f77fda4e32c17d7a1d891fc9fbfa86aae))
* correct environment variable loading and improve argument handling in psql script ([cbc7e0c](https://github.com/humlab-sead/sead_change_control/commit/cbc7e0cc229fcc023291a66ec41745eafcc572b0))
* remove duplicate issue reference in analysis ages facet description ([2a73122](https://github.com/humlab-sead/sead_change_control/commit/2a7312200d4af71c2dbec1c130a56dd0e0c0ba44))

### 🧑‍💻 Code Refactoring

* enhance fn_table_columns function to include additional metadata and improve view definition ([2482975](https://github.com/humlab-sead/sead_change_control/commit/2482975f08379d82f9cfbd1224d989d5fb450985))
* remove default values for source_filename and target_folder in export_excel_sheets function ([99dc133](https://github.com/humlab-sead/sead_change_control/commit/99dc133255559c8ff7e91157d345d1028c54e55b))
* simplify patch-cr script by using utility script ([4a92f45](https://github.com/humlab-sead/sead_change_control/commit/4a92f4543ff77471cde95e81cd10799749c75a57))
* streamline sync-comments script and improve usage instructions ([53c8198](https://github.com/humlab-sead/sead_change_control/commit/53c8198988e431a87bbdb7211910de1ea187b3a9))

## [1.4.4](https://github.com/humlab-sead/sead_change_control/compare/v1.4.3...v1.4.4) (2025-05-18)

### 🐛 Bug Fixes

* deployed changes in clearinghouse commit system related to explicit columns ([928b57a](https://github.com/humlab-sead/sead_change_control/commit/928b57a22f69d7ee22246e1d8c485eead7a23eec))
* fixes SQL syntax error ([#371](https://github.com/humlab-sead/sead_change_control/issues/371)) ([51ad21c](https://github.com/humlab-sead/sead_change_control/commit/51ad21c0f931d6249330ae1ffe76b28cad78f82d))
* move create extension postgis above change roll (resolves [#370](https://github.com/humlab-sead/sead_change_control/issues/370)) ([982203b](https://github.com/humlab-sead/sead_change_control/commit/982203b242ab442e81784b500362b2d35e78461b))
* resolves [#379](https://github.com/humlab-sead/sead_change_control/issues/379) ([d3c87d7](https://github.com/humlab-sead/sead_change_control/commit/d3c87d7b4d676104b6029d3ed1461ec6960ed51b))
* update database URIs for staging and production targets ([b3e3cdf](https://github.com/humlab-sead/sead_change_control/commit/b3e3cdf4a400c7aa552ea7a3e8302677d33deb9a))
* use explicit cplumns in import (Wrong site location accuracy ([#378](https://github.com/humlab-sead/sead_change_control/issues/378)) ([0868162](https://github.com/humlab-sead/sead_change_control/commit/086816224dfa6392465baa5d8ddb6e1609bd096d))

### 🧑‍💻 Code Refactoring

* renamed function dbexec to execute_sql ([cb7944b](https://github.com/humlab-sead/sead_change_control/commit/cb7944b10b51cfd4be8a49d80f32255fec2c95d7))

## [1.4.3](https://github.com/humlab-sead/sead_change_control/compare/v1.4.2...v1.4.3) (2025-05-14)

### 🐛 Bug Fixes

* install postgis when deploying from scratch ([#375](https://github.com/humlab-sead/sead_change_control/issues/375)) ([4c084bd](https://github.com/humlab-sead/sead_change_control/commit/4c084bd724edade8dee9517fbdfe4a32c2e44a2d))

## [1.4.2](https://github.com/humlab-sead/sead_change_control/compare/v1.4.1...v1.4.2) (2025-05-14)

### 🐛 Bug Fixes

* temporary patch added for ([#374](https://github.com/humlab-sead/sead_change_control/issues/374)) ([0d95a26](https://github.com/humlab-sead/sead_change_control/commit/0d95a26aa0c1995c70bce77f312d6c505c33bb4f))

## [1.4.1](https://github.com/humlab-sead/sead_change_control/compare/v1.4.0...v1.4.1) (2025-05-09)

### 🐛 Bug Fixes

* resolves [#374](https://github.com/humlab-sead/sead_change_control/issues/374) (constructions facet) ([9ad8241](https://github.com/humlab-sead/sead_change_control/commit/9ad8241905c93a7815fce2589f45143dbc8c2cef))

## [1.4.0](https://github.com/humlab-sead/sead_change_control/compare/v1.3.0...v1.4.0) (2025-04-24)

### 🍕 Features

* add check for existence before deleting from facet_children table ([57582a7](https://github.com/humlab-sead/sead_change_control/commit/57582a7050884381942d0c301cdf9fb2aac47274))
* add dump-table-data script for exporting table data to CSV files ([170b5b6](https://github.com/humlab-sead/sead_change_control/commit/170b5b67567d1cf792e52bffedfb8c2d21ff9dc2))
* add on delete cascade to FK in analysis tables (resolved [#371](https://github.com/humlab-sead/sead_change_control/issues/371)) ([7f5659b](https://github.com/humlab-sead/sead_change_control/commit/7f5659b605690bbd026a8dd01869c3bad7a9484d))
* add qualifier_id column to tbl_sample_[group_]dimensions (resolves [#334](https://github.com/humlab-sead/sead_change_control/issues/334)) ([9f15b46](https://github.com/humlab-sead/sead_change_control/commit/9f15b466583d0c04dff739641d23f36c45c308bf))
* create view for typed analysis values to enhance data retrieval ([c3be82f](https://github.com/humlab-sead/sead_change_control/commit/c3be82f453bca6eb94f6c0550b2013a8633e74a9))

### 🐛 Bug Fixes

* correct issue link formatting in sqitch.plan ([d518310](https://github.com/humlab-sead/sead_change_control/commit/d51831075823e0969eba22275080f9ae9f8ae316))
* removed newline in record type name ([3e1e7ad](https://github.com/humlab-sead/sead_change_control/commit/3e1e7adbed69e6a485a5078c44f06e7e2510b931))
* update gzip command in export-database script to use '-n' flag for better compatibility ([d64802f](https://github.com/humlab-sead/sead_change_control/commit/d64802f71cfb9a482d5a5270356c4f0579372794))

### 🧑‍💻 Code Refactoring

* replace typed_analysis_values view with a CTE ([46da430](https://github.com/humlab-sead/sead_change_control/commit/46da430400c9f443fbcbd07174011e9b804002dd))

## [1.3.0](https://github.com/humlab-sead/sead_change_control/compare/v1.2.2...v1.3.0) (2025-04-22)

### 🍕 Features

* add domain facet for aDNA (resolves [#369](https://github.com/humlab-sead/sead_change_control/issues/369)) ([f68af4e](https://github.com/humlab-sead/sead_change_control/commit/f68af4ed423947e299514e211e00502ba5e56cbc))
* add old tables and columns spreadsheet ([6b8612b](https://github.com/humlab-sead/sead_change_control/commit/6b8612bb193f3cf0887b664b60064d18b5b53e6a))

### 🐛 Bug Fixes

* improved logic when updating existing facet ([f7de5e9](https://github.com/humlab-sead/sead_change_control/commit/f7de5e95bd67dd734469172157e2b9f5b6a28103))

## [1.2.2](https://github.com/humlab-sead/sead_change_control/compare/v1.2.1...v1.2.2) (2025-04-22)

### 🐛 Bug Fixes

* update category_id_operator to use '&&' for facet type analysis_entity_ages ([684081a](https://github.com/humlab-sead/sead_change_control/commit/684081abe5adde865936d1ec82fde5e69a56be63))

## [1.2.1](https://github.com/humlab-sead/sead_change_control/compare/v1.2.0...v1.2.1) (2025-04-22)

### 🧑‍💻 Code Refactoring

* removed fix that submission's id when restored ([cb85475](https://github.com/humlab-sead/sead_change_control/commit/cb85475da4fd0f647562590af9c97635a8031252))

## [1.2.0](https://github.com/humlab-sead/sead_change_control/compare/v1.1.0...v1.2.0) (2025-04-22)

### 🍕 Features

* add transport system check before generating change request ([e032154](https://github.com/humlab-sead/sead_change_control/commit/e0321545e4b08da4899ff710324781ab5dfdbc9f))
* parameterize id assignment when loading dumped submissions ([429da7c](https://github.com/humlab-sead/sead_change_control/commit/429da7c8014670a30958c156b3c54ec62176cd55))
* update semantic-release and plugins to specific versions for consistency ([e36a45d](https://github.com/humlab-sead/sead_change_control/commit/e36a45d5ad3709d4861de72c7446fb0373c48e91))

### 🐛 Bug Fixes

* add call to refactoresd reset_public_sequence_ids in deployment scripts ([fc208f1](https://github.com/humlab-sead/sead_change_control/commit/fc208f1249d4140cb7fd3b5e00b2fa8f32eca9fa))
* add missing tbl_clearinghouse_submissions to  list in dump_submission function ([8da76cb](https://github.com/humlab-sead/sead_change_control/commit/8da76cb8798b66be43998248ca6ea76b5597d6b2))
* deployed transport system ([1b957af](https://github.com/humlab-sead/sead_change_control/commit/1b957afc81b663aa160da320204369cff7daa618))
* enhance usage messages ([7dff5ba](https://github.com/humlab-sead/sead_change_control/commit/7dff5baf4ab5c9486c490522e78071cdce0a00ee))
* improve log file naming ([ffd6958](https://github.com/humlab-sead/sead_change_control/commit/ffd69584fafb8a23b5c02e52037ae962ef5d74c9))
* improve log message for new submission ID in dump_submission function ([bb5794f](https://github.com/humlab-sead/sead_change_control/commit/bb5794f42f81c6fecc697bf1d5496ed2ad9f77a9))
* rename dump-submission to submission ([e323eec](https://github.com/humlab-sead/sead_change_control/commit/e323eec9325a4691730184fa3b90f10c1018602b))
* replace perform with call for reset_public_sequence_ids in multiple deployment scripts ([5a84b8c](https://github.com/humlab-sead/sead_change_control/commit/5a84b8c9f9ab9561551ea31d92517aa86da079b4))
* update faulty arguments in UDF call ([6728b65](https://github.com/humlab-sead/sead_change_control/commit/6728b656f9577c557bd4746f167e2a7e48f4a12e))
* update source database name and improve script structure in reset-adna ([8ab4bfd](https://github.com/humlab-sead/sead_change_control/commit/8ab4bfde5ab3fd9065b2124259039fad234f3289))
* update table exclusion condition in dump_submission function ([e9b1c2f](https://github.com/humlab-sead/sead_change_control/commit/e9b1c2ffe0d87abe2b3e177277f395a1076db4a6))

### 📝 Documentation

* add detailed documentation for commit-submission script ([f78487c](https://github.com/humlab-sead/sead_change_control/commit/f78487ca97da8a25395f3ddf0ccd937c9756ce7c))

### 🧑‍💻 Code Refactoring

* replace hardcoded table list with dynamic retrieval in dump_submission function ([443db08](https://github.com/humlab-sead/sead_change_control/commit/443db08b23580fad2adefe37c8ca66631c568f6b))

## [](https://github.com/humlab-sead/sead_change_control/compare/v1.1.0...v) (2025-04-19)
## [1.1.0](https://github.com/humlab-sead/sead_change_control/compare/v25.0.0...v1.1.0) (2025-04-19)

### Features

* add January 2025 release entry to sqitch plan ([b93673c](https://github.com/humlab-sead/sead_change_control/commit/b93673c564d287adf9556a6320f6aba27fc697c8))
* add release workflow and configuration for semantic-release ([fe3ed4e](https://github.com/humlab-sead/sead_change_control/commit/fe3ed4ee8270eb53f3099a760b8ae1a6f7573674))
* enhance release workflow with semantic-release plugins and configuration ([240eab4](https://github.com/humlab-sead/sead_change_control/commit/240eab490fc1ec94ff642ce74e8bbb082f5434fa))
* update release workflow with Node.js 20 and actions/checkout@v4 ([000fb04](https://github.com/humlab-sead/sead_change_control/commit/000fb04eaa35e0c67c4f9a137e882d950c21a5fa))
## [25.0.0](https://github.com/humlab-sead/sead_change_control/compare/v1.0.0...v25.0.0) (2025-04-15)

### Features

* add  `sync-comments` script setup/sync procedures for comments ([22860e4](https://github.com/humlab-sead/sead_change_control/commit/22860e44cbf02a0f1fecf5f48d7303e2a17505b7))
* add function to release allocated system IDs ([b42ba76](https://github.com/humlab-sead/sead_change_control/commit/b42ba76ed525a0c82915c5bb7fe26f93f5043cb2))
* add geonames import script for database integration ([bf3e8cb](https://github.com/humlab-sead/sead_change_control/commit/bf3e8cb11490be0ae2c4c2fb8e4f218e8b0de1a8))
* add index on geonames name column for improved query performance ([f69c9fb](https://github.com/humlab-sead/sead_change_control/commit/f69c9fb80363b5899328670abd513b484db20302))
* add initial .tbls.yml configuration for database schema documentation ([3d0d0e2](https://github.com/humlab-sead/sead_change_control/commit/3d0d0e2bb74b17aed8d4984cd9cd3a9dd95757e2))
* add ls-cr script for listing change requests with various options ([d5ceecf](https://github.com/humlab-sead/sead_change_control/commit/d5ceecfbbb508ab305bc8ee7bb43f78a28966f2a))
* add overide of schemaspy main.html ([79e9f96](https://github.com/humlab-sead/sead_change_control/commit/79e9f96166544bd94c76f4505eddd448b8249659))
* add patch-cr script for applying change requests to the database ([7bf9772](https://github.com/humlab-sead/sead_change_control/commit/7bf9772a2f077c907e3d0425ac70889b1925be3d))
* add pgsql wrapper script isql ([b56b2ca](https://github.com/humlab-sead/sead_change_control/commit/b56b2cad60fcbc3c94d8045bcd9aa621b5dbfd65))
* add qualifier_id column to tbl_sample_dimensions ([#356](https://github.com/humlab-sead/sead_change_control/issues/356)) ([7f526c6](https://github.com/humlab-sead/sead_change_control/commit/7f526c67e701f0f2ef541da6fe7ea97b6ae65cae))
* add resolve function for submission name and update copy script generation ([#367](https://github.com/humlab-sead/sead_change_control/issues/367)) ([0480408](https://github.com/humlab-sead/sead_change_control/commit/0480408304bc0291aa2023d52b32222195eb5cf8))
* add script for generating documentation using SchemaSpy with PostgreSQL support ([0b35665](https://github.com/humlab-sead/sead_change_control/commit/0b356655fb17bee25566b9360d28f846c69fe6a1))
* add support for generating only SQL scripts in dump_submission function ([0023ec1](https://github.com/humlab-sead/sead_change_control/commit/0023ec17c79efcf3d40b29c871a86e4ce3e16049))
* add sync-comments script for extracting and uploading comments from Excel to database ([29e6ead](https://github.com/humlab-sead/sead_change_control/commit/29e6ead2c33fda4f0c2cff34b949043d7e0e3d07))
* add update-adna-cr script for managing ADNA submissions and database updates ([ca021fa](https://github.com/humlab-sead/sead_change_control/commit/ca021fadca671dc03b92a23636d60a29c50d666b))
* Add utility for storing and restoring view definitions ([#324](https://github.com/humlab-sead/sead_change_control/issues/324)) ([6234f94](https://github.com/humlab-sead/sead_change_control/commit/6234f9455da5cf8afd92c32c12626ca47eab82c9))
* add UUID column to value types for improved data integrity ([f9241a0](https://github.com/humlab-sead/sead_change_control/commit/f9241a06890fbb32dfca4df11d0486f98ad6e337))
* add UUID columns to value qualifier and type tables, update clearinghouse system ([ce16c8b](https://github.com/humlab-sead/sead_change_control/commit/ce16c8b3758eefa8a4f7a1f9fd7190ecd3686d88))
* backported 20241023_ALLOCATE_SYSTEM_IDS to 20190401_DDL_UTILITY_SCHEMA ([96ab722](https://github.com/humlab-sead/sead_change_control/commit/96ab722b3b900e91863281848d1eeb5c4df58d07))
* create view for encoded dendro analysis values with enhanced data processing ([61d61db](https://github.com/humlab-sead/sead_change_control/commit/61d61dba45952960fc03198ae0f9fef702cbb7c0))
* enhance analysis value handling with new flags and improved data processing ([8bfe557](https://github.com/humlab-sead/sead_change_control/commit/8bfe557c5a6798b50f1a5d82a65a5bcf07e64de5))
* enhance analysis value processing with additional felling year estimations and uncertainty handling ([c219870](https://github.com/humlab-sead/sead_change_control/commit/c219870bd868148b95bccc7f2e0f6626174149e0))
* enhance analysis value processing with additional qualifiers and improved uncertainty handling ([d2fdd77](https://github.com/humlab-sead/sead_change_control/commit/d2fdd779d401c085ad337b158b9316b723600bb9))
* enhance dump-database script with additional options and improved usage instructions ([72229f7](https://github.com/humlab-sead/sead_change_control/commit/72229f7f27411ee89f077920ca699d4fc29c8599))
* enhance encoded dendro analysis values view with improved value handling and qualifiers ([4a26fd5](https://github.com/humlab-sead/sead_change_control/commit/4a26fd587c89adcda4a0744e999028b9ab7b3f5a))
* improve analysis value processing with case-insensitive qualifiers and uncertainty indicators ([5ddf906](https://github.com/humlab-sead/sead_change_control/commit/5ddf906c9e09f6945b5822d5b3a11bfbe85bb200))
* improved deployment script ([aebd6a5](https://github.com/humlab-sead/sead_change_control/commit/aebd6a540e27a4902e627cbf85732a752538ac88))
* Increase size of descriptive field in dimensions ([#323](https://github.com/humlab-sead/sead_change_control/issues/323)) ([861d149](https://github.com/humlab-sead/sead_change_control/commit/861d14900d140555e7e6ac192b4cf92bbcf8631e))
* release allocated IDs and update value types in new dendro lookups ([ce5cc26](https://github.com/humlab-sead/sead_change_control/commit/ce5cc265168b178b0e757299548c4099c99bf715))
* update documentation layout by removing unnecessary columns and adding a new columns page ([937bd3d](https://github.com/humlab-sead/sead_change_control/commit/937bd3d3b42d8937f58b4b13e9688b9939af53ba))
* update encoded dendro analysis values view with enhanced qualifiers and range handling ([de4f51c](https://github.com/humlab-sead/sead_change_control/commit/de4f51c13a351b99cc6b82daa660c1ed805b1ac9))

### Bug Fixes

* 20240924_DDL_MEASURED_VALUES_REFACTOR create table using clearinghouse_worker role ([#319](https://github.com/humlab-sead/sead_change_control/issues/319)) ([d8ce710](https://github.com/humlab-sead/sead_change_control/commit/d8ce710bd5aba6ed5704dea53334c38a8b1e6d52))
* add cascade option to sead_utility.drop_view and sead_utility.drop_table procedures for improved flexibility ([c3590c1](https://github.com/humlab-sead/sead_change_control/commit/c3590c147e7683f803725907e4710c912e364a0e))
* add missing semicolon in DML scripts for geochronology and sample group facets ([36107fc](https://github.com/humlab-sead/sead_change_control/commit/36107fc214450f2eda3399779348242218807a60))
* add source_name column to clearinghouse_submissions import in copy_in.sql ([5c13fa0](https://github.com/humlab-sead/sead_change_control/commit/5c13fa03a0b7a4998b5b9cc38c7a48dd91bdde18))
* change client_min_messages setting to error for stricter error handling ([b843ebf](https://github.com/humlab-sead/sead_change_control/commit/b843ebf1fa031fca8964d27fb3a955609b8526e2))
* change perform to call for clearing_house_commit in generate_data function ([c1caa21](https://github.com/humlab-sead/sead_change_control/commit/c1caa210644dbea8484233b86ac934380b0bb10a))
* correct comment syntax in comments.sql for site_location_accuracy column ([62450cd](https://github.com/humlab-sead/sead_change_control/commit/62450cd9e7146cffc2a1a770ada024d1e21bf29b))
* correct error message output and enhance colorize function for better usability ([3a8691f](https://github.com/humlab-sead/sead_change_control/commit/3a8691f0bc976d3e6e96b617d28098b185ba1557))
* correct folder existence check in commit-submission script ([0b9f6de](https://github.com/humlab-sead/sead_change_control/commit/0b9f6dece005220da43e1baa910e7988c06b7a77))
* correct folder existence check in post-deploy hook script ([c060568](https://github.com/humlab-sead/sead_change_control/commit/c0605687d7594e7ffe53c5fde777cb8d295f4aca))
* correct indentation in deploy script output ([36496f5](https://github.com/humlab-sead/sead_change_control/commit/36496f570325943c5df34faa70b530dc14872bf0))
* correct join condition in DML_NEW_DENDRO_LOOKUPS.sql ([c40c550](https://github.com/humlab-sead/sead_change_control/commit/c40c55035d5be1cb471f97c887b02911f1dabae1))
* correct sort expression in DML facets SQL script ([105dcd9](https://github.com/humlab-sead/sead_change_control/commit/105dcd95ccee63e69fa5d4617f14654dbb71f292))
* correct syntax error ([ab06208](https://github.com/humlab-sead/sead_change_control/commit/ab06208e5a0c4a7eb1bade840118912dcb2b30e2))
* correct syntax for dropping table in SQL script ([3e9b1d5](https://github.com/humlab-sead/sead_change_control/commit/3e9b1d5337e9cae3db8df7936f8e1d8c06e98aae))
* correct usage message for compress option and remove commented-out SQL queries ([e2ea119](https://github.com/humlab-sead/sead_change_control/commit/e2ea1192da7dba24deb08994b6f2d3af908ffe06))
* enhance view drop logic in 20220923_DDL_DEPRECATE_CHRON_CONTROLS.sql to prevent errors when views do not exist ([0104b7b](https://github.com/humlab-sead/sead_change_control/commit/0104b7bd510f0a8016e58678cbdd4042b51039f4))
* fix use of --force and source/target db in copy-database script ([6501e64](https://github.com/humlab-sead/sead_change_control/commit/6501e6435939c44584a56ebdc291f05dea0c70fa))
* fixed script ([#317](https://github.com/humlab-sead/sead_change_control/issues/317)) ([1f9cb8f](https://github.com/humlab-sead/sead_change_control/commit/1f9cb8f37f31a7f7c49b7726f4f03ac64379ab35))
* fixed typo ([d5e0282](https://github.com/humlab-sead/sead_change_control/commit/d5e0282921cb07a253222d7fbaa1839998ef998d))
* fixed typo in variable names ([dfbbf16](https://github.com/humlab-sead/sead_change_control/commit/dfbbf16e72e39a52f67be4ca2676db4863b1a8d8))
* handle empty deployment status in deploy-staging script ([4b663b0](https://github.com/humlab-sead/sead_change_control/commit/4b663b055653f228f9faf7a1180222a35bcba327))
* improve error handling for unspecified target database in isql script ([bbb6374](https://github.com/humlab-sead/sead_change_control/commit/bbb637469d9dae9d89c2351fed267c69ab7d5bcb))
* improve error handling in restore_submission function ([4e2c24f](https://github.com/humlab-sead/sead_change_control/commit/4e2c24f2ce40fd402cdbfd42db85a1379624915c))
* made idempotent ([#144](https://github.com/humlab-sead/sead_change_control/issues/144)) ([84c5501](https://github.com/humlab-sead/sead_change_control/commit/84c5501b41b0a332de51348b0ec0fde04f497e2f))
* remove hash symbol from note URL in add-change-request script ([7661886](https://github.com/humlab-sead/sead_change_control/commit/7661886b435f9e963012c0bf8ec867afcc9b11c0))
* remove redundant integer type check in analysis value processing ([204d722](https://github.com/humlab-sead/sead_change_control/commit/204d722ae7fc3fc2eaba41bd09aae7c7a3bf446b))
* remove trailing comma in clearing_house_commit procedure parameters ([aa7545c](https://github.com/humlab-sead/sead_change_control/commit/aa7545c0396717066b499854679b9ca635a64f31))
* remove trailing comma in tbl_chronologies table definition ([70031bc](https://github.com/humlab-sead/sead_change_control/commit/70031bcba99efd00ed8d12316404058fc8ea722b))
* remove trailing commas in SQL update statements for tbl_methods ([cebc8f9](https://github.com/humlab-sead/sead_change_control/commit/cebc8f975a07d9003324dab08dba9956d6134863))
* removed constraint ([#168](https://github.com/humlab-sead/sead_change_control/issues/168), cdc9aa3cfc9189cf8eb88141991be80615af14b4) ([cdee3a7](https://github.com/humlab-sead/sead_change_control/commit/cdee3a75fc7eee3ef04182c5c56630faf4406c5d))
* rename function for better clarity in utility script ([52fa60b](https://github.com/humlab-sead/sead_change_control/commit/52fa60b43e5d5574ec5369962edd929781ee9e52))
* reorder projects in deployment list for correct sequence ([9324086](https://github.com/humlab-sead/sead_change_control/commit/93240862825ddad5fac12dd3eba616b9bc140559))
* replace drop statements with sead_utility calls for consistency and improved error handling ([bdf7233](https://github.com/humlab-sead/sead_change_control/commit/bdf723339499a2cc3212011524f6cf481e04aa5c))
* replace drop table statement with sead_utility.drop_table call for consistency ([9f8d7b0](https://github.com/humlab-sead/sead_change_control/commit/9f8d7b057ea94252108d02aabba44d37c1375d67))
* replace drop table statement with sead_utility.drop_table call for consistency ([46e574e](https://github.com/humlab-sead/sead_change_control/commit/46e574e7416fba86c4c985a1a4046492835cd22f))
* replace drop view statements with sead_utility.drop_view calls for consistency and error handling ([8b216e9](https://github.com/humlab-sead/sead_change_control/commit/8b216e94e10742cb5d9f5fa8c8b3329fa81b403b))
* Resolves [#349](https://github.com/humlab-sead/sead_change_control/issues/349) [deploy-staging} Mutual exclusion check of use of options fail ([844d017](https://github.com/humlab-sead/sead_change_control/commit/844d017f79f207cd791e0b7cd16d3bd3a359b1ed))
* Resolves [#352](https://github.com/humlab-sead/sead_change_control/issues/352) ([6ea6b5b](https://github.com/humlab-sead/sead_change_control/commit/6ea6b5b94986ee99a9a51286e86a38a6586a4ab6))
* simplify post-deploy-hook argument handling ([51203cb](https://github.com/humlab-sead/sead_change_control/commit/51203cb59abce67c7bf0b5a680761f0d732994eb))
* streamline reset-adna script ([5de54b4](https://github.com/humlab-sead/sead_change_control/commit/5de54b405a5f0e6ccebbb19787c172f2c67a2300))
* update analysis value processing to use stripped values and enhance felling year estimations ([d7c882d](https://github.com/humlab-sead/sead_change_control/commit/d7c882dde2847c32253eecb9140f2f47680a9ea1))
* update clearing_house_commit call, add missing parameter ([433485f](https://github.com/humlab-sead/sead_change_control/commit/433485fdc97a21362708d31da506b55bcbd95f1b))
* update copy commands to include site_location_accuracy column in SQL scripts ([bf22564](https://github.com/humlab-sead/sead_change_control/commit/bf225648093d8185b9f68456523422574f83f98f))
* update database port from 5432 to 5433 ([e4835fd](https://github.com/humlab-sead/sead_change_control/commit/e4835fd48fdc5e7f49ea4ba0f12f5df84266bf01))
* update drop_database function to specify postgres for execution ([720057c](https://github.com/humlab-sead/sead_change_control/commit/720057cba025e722b4ccce4aef1a7b6a20982cdd))
* update function name for clarity in Clearinghouse Transport System SQL ([a3d45d5](https://github.com/humlab-sead/sead_change_control/commit/a3d45d51c47d0713245c3316a2ca9b69309296d2))
* update reset-adna script to include additional patch commands ([dbfe329](https://github.com/humlab-sead/sead_change_control/commit/dbfe32941fbca10520679ceaad72f5fb68908894))
* update root folder resolution and add warning for missing data folder in commit-submission script ([053202e](https://github.com/humlab-sead/sead_change_control/commit/053202e9919bc2b08e4174a41134904072ad681f))
* update view drop logic in 20221121_DML_QSE_DENDRO_DATING.sql to prevent breaking changes ([18d0601](https://github.com/humlab-sead/sead_change_control/commit/18d0601fb851d4168ec153f9ad1a1ce0e8bf436d))
