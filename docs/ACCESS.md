# SEAD Access And Credentials Guide

This guide describes the expected local setup for working with SEAD change control scripts and database connections without storing secrets in the repository.

## Principles

- Keep secrets out of repository files, chat, and shell history.
- Use local credential stores such as `~/.pgpass` and `~/vault/*` over hard-coded passwords.
- Use repository scripts such as `bin/psql.sh` when they match the task.
- Avoid relying on `PGPASSWORD` unless there is no safer practical option.

## Required Tools

Most contributors and operators need:

- `psql`
- `sqitch`
- `gh` for issue-related workflow

## `sqitch.conf` Locations

Typical `sqitch.conf` locations are:

- `./sqitch.conf`
- `~/.sqitch/sqitch.conf`
- `$(sqitch --etc-path)/sqitch.conf`

Keep connection defaults and targets in local configuration rather than embedding them in repository files.

## Preferred Local Credential Sources

The repository already assumes these local patterns:

- `~/.pgpass` with `0600` permissions
- `~/vault/.default.sead.server`
- `~/vault/.default.sead.username`
- `~/vault/.sqitch.env` as a local vault convention when a script or workflow expects Sqitch-related environment values

Do not commit any of these files.

## How `bin/psql.sh` Resolves Defaults

`bin/psql.sh` uses these inputs, in order of practicality:

- `PGHOST`, `PGPORT`, `PGUSER`, and `PGDATABASE` when they are already set
- `~/vault/.default.sead.server` and `~/vault/.default.sead.username` for host and user defaults
- Default database `sead_staging`
- Default port `5433`

Example:

```bash
bin/psql.sh
bin/psql.sh --database sead_staging_test
```

Direct `psql` usage is also fine when you need explicit control:

```bash
psql -h server -p 5433 -U user -d sead_staging
```

## How `bin/deploy-staging` Resolves Access

`bin/deploy-staging` reads host and user defaults from:

- `~/vault/.default.sead.server`
- `~/vault/.default.sead.username`

The deploy script runs `psql` with `--no-password`, so password-based authentication must already be satisfied through libpq-compatible mechanisms such as `~/.pgpass` or equivalent local setup. Test access before starting a deploy if you are unsure.

Use [bin/deploy-staging.md](../bin/deploy-staging.md) for command details and [OPERATIONS.md](OPERATIONS.md) for the standard deployment path.

## Safe Practices

- Do not commit `.env` files or hard-coded connection strings.
- Prefer `psql -v` for SQL variable passing instead of shell string concatenation.
- Validate user-supplied identifiers before interpolating them into SQL or shell commands.
- Prefer local vault files and libpq configuration over exported long-lived credentials.

## Quick Access Checks

Before running a larger workflow, verify the basics:

1. Confirm host and user defaults are the ones you expect.
2. Confirm `~/.pgpass` permissions are `0600` if that file is in use.
3. Confirm `bin/psql.sh` can reach the intended database.
4. Confirm the target named in `sqitch.conf` or on the command line is the intended environment.

## Related Documents

- [DEVELOPMENT.md](DEVELOPMENT.md): contributor workflow.
- [OPERATIONS.md](OPERATIONS.md): staging deployment and release-validation workflow.
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md): diagnosis when access or deploy steps fail.
- [README.md](../README.md): repository entry point.