# `bin/deploy-staging` Reference

`bin/deploy-staging` is the default and authoritative deployment entry point for SEAD staging deployment and release validation. Use [docs/OPERATIONS.md](../docs/OPERATIONS.md) for the standard workflow and use this file as the command reference.

## What The Script Does

The script coordinates staging deployment by:

- Creating a target database from an empty start, an existing database, or a dump file.
- Deploying to `latest`, to a specific release tag, to a chain of release tags, or to a single change request.
- Running deployment in project order.
- Running tag-level and CR-level deploy hooks when they exist.
- Writing a deploy log under `logs/`.
- Optionally synchronizing sequences after deployment.

## Access And Defaults

The script reads local defaults for host and user from:

- `~/vault/.default.sead.server`
- `~/vault/.default.sead.username`

The script runs `psql` with `--no-password`, so password-based authentication must already be available through `~/.pgpass` or another suitable local PostgreSQL setup.

See [docs/ACCESS.md](../docs/ACCESS.md) for local credential guidance.

## Command-Line Options

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
      --source [DBNAME|FILE]          Specify the source database or dump file, depending on source type.
                                                      Optional if "--create-database" is specified, otherwise ignored.
                                                      Default: "sead_master_9" if source type is "db"
                                                      Default: "./starting_point/sead_master_9_public.sql.gz" if source type is "dump"
                                                      Default: "empty" if source type is "empty" (value is ignored)
      --on-conflict [drop|rename]     Specify what happens if the target database already exists.
                                                      Optional if "--create-database" is specified. Default: rename
      --deploy-to-tag TAG             Deploy to a specific tag. Set tag to "latest" for full deployment
      --deploy-from-tag TAG           Start deployment from tag TAG. Only valid for source type "db"
      --deploy-chain-to-tag TAG       Deploy the entire chain of databases up to the specified tag
      --deploy-starting-point         Create a starting point, then exit
      --deploy-single-change-request  Only deploy the specified CR, then exit
      --sqitch-project PROJECT        Specify the Sqitch project to deploy
      --rename-end-of-chain           Rename the last database in the chain to the target name
      --verbose                       Enable verbose output
      --display-status                Display the status of the target database
```

## Standard Examples

### Create a fresh staging database and deploy to latest

```bash
./bin/deploy-staging \
   --create-database \
   --source-type empty \
   --target-db-name sead_staging_test \
   --deploy-to-tag latest
```

### Create a fresh staging database and deploy to a release tag

```bash
./bin/deploy-staging \
   --create-database \
   --source-type empty \
   --target-db-name sead_staging_202605 \
   --deploy-to-tag @2026.05
```

### Deploy from an existing source database to a release tag

```bash
./bin/deploy-staging \
   --create-database \
   --source-type db \
   --source sead_production_202401 \
   --target-db-name sead_staging_202605_from_prod \
   --deploy-to-tag @2026.05
```

### Deploy from the starting-point dump to a release tag

```bash
./bin/deploy-staging \
   --create-database \
   --source-type dump \
   --target-db-name sead_staging_202605_from_dump \
   --deploy-to-tag @2026.05
```

### Deploy the release chain up to a tag

```bash
./bin/deploy-staging \
   --create-database \
   --source-type dump \
   --target-db-name sead_staging_chain \
   --deploy-chain-to-tag @2026.05
```

## Hooks

The script can run deploy hooks when they exist:

- `project/@YYYY.MM-pre-deploy-hook`
- `project/@YYYY.MM-post-deploy-hook`
- `project/deploy/<cr>/<cr>-post-deploy-hook`

If deployment fails around a tag or CR boundary, inspect the relevant hook and the deploy log together.

## Logging

Deploy logs are written under `logs/` with timestamped names similar to:

```text
logs/20260528153000_deploy_sead_staging_test_empty.log
```

Preserve the log path whenever a deployment fails. It is the first place to look before improvising lower-level commands.

## Guardrails

- Use `bin/deploy-staging` for routine staging deployment and release validation instead of ad hoc per-project deploy sequences.
- Treat `--ignore-git-tags` as an exception, not a default.
- Prefer a fresh validation database over manual repair of a broken staging deploy.
- Use [docs/TROUBLESHOOTING.md](../docs/TROUBLESHOOTING.md) when the deploy path fails.