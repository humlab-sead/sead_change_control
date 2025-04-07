# Deploy Staging Bash Script

This repository contains a Bash script designed for deploying database changes to a staging environment. The script automates the deployment process using Sqitch, a database change management tool, and integrates with the SEAD Change Control System.

## Features
- Supports different deployment modes: `deploy-to-tag`, `deploy-chain-to-tag`, and `deploy-single-change-request`.
- Automatically creates and sets up target databases based on specified source types (empty, existing database, or dump file).
- Handles schema creation and conflict resolution (drop or rename existing databases).
- Synchronizes sequences post-deployment if required.
- Executes pre-deploy and post-deploy hooks if they exist.
- Logs deployment actions and outputs to a log file.

## Usage

### Command-line options
```bash
usage: deploy-staging [OPTIONS]...

Options:
    --host SERVERNAME               Specify the server name (default: ${g_host})
    --port PORT                     Specify the port number (default: 5433)
    --user USERNAME                 Specify the user on the target server (default: ${g_user})
    --target-db-name DBNAME         Specify the target database name (required)
    --create-database               Create a new database from the specified source
    --create-snapshot               Create a snapshot of the database
    --dry-run                       Simulate a database snapshot operation. No changes are made
    --tags                          Display tags, then exit. No changes are made
    --sync-sequences                Synchronize all sequences post-deployment
    --ignore-git-tags               Continue deployment even if a Sqitch tag is missing in Git
    --source-type [empty|db|dump]   Specify the source type: a database name or a dump filename.
                                    Required if "--create-database" is specified, otherwise ignored
    --source [DBNAME|FILE]          Specify the name of the source database or dump file, depending on source type.
                                    Optional if "--create-database" is specified, otherwise ignored.
                                    Default: "sead_master_9" if "source_type" is "db"
                                    Default: "./starting_point/sead_master_9_public.sql.gz" if "source_type" is "dump"
                                    Default: "empty" if "source_type" is "empty" (value is ignored)
    --on-conflict [drop|rename]     Specify the action if the target database already exists: drop or rename it.
                                    Optional if "--create-database" is specified, otherwise ignored. Default: rename
    --deploy-to-tag TAG             Specify the Sqitch deploy tag. Optional. Set tag to "latest" for full deployment
    --deploy-from-tag TAG           Start deploy from tag TAG. Optional. Only valid for source type "db".
    --deploy-chain-to-tag TAG       Deploy the entire chain of databases up to the specified tag. Optional. Set tag to "latest" for full deployment
    --deploy-starting-point         Create a starting point, then exit
    --deploy-single-change-request  Only deploy given CR, then exit
    --sqitch-project PROJECT        Specify the Sqitch project to deploy
    --rename-end-of-chain           Rename the last database in the chain to the target name (e.g. removes tag)
    --verbose                       Enable verbose output

Examples:

1. Deploy changes to a new, empty database up to tag @2024.03:
   ./bin/deploy-staging --create-database --source-type empty --target-db-name sead_test --deploy-chain-to-tag @2022.12

2. Deploy changes to a new database based on sead_production_202401 up to tag @2024.03:
   ./bin/deploy-staging --create-database --source-type db --source sead_production_202401 --deploy-to-tag @2024.03

3. Deploy changes to a new database from starting point (sead_master_9 dump) up to tag @2024.03:
   ./bin/deploy-staging --create-database --source-type dump --target-db-name sead_test_202403 --deploy-to-tag @2024.03

4. Deploy the entire sequence of monthly databases starting from sead_master_9 and ending at tag @2022.12. The databases will be named sead_test_yyymmm based on tag. If a database already exists, it will be renamed to sead_test_yyymmm_YYYYMMDDHHMMSS:
   ./bin/deploy-staging --create-database --source-type dump --target-db-name sead_test --deploy-chain-to-tag @2022.12