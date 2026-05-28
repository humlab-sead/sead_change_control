# SEAD Troubleshooting Guide

This guide is for deployment and validation failures in the SEAD Change Control System. It is intentionally symptom-driven and assumes that the normal deployment path starts with `bin/deploy-staging`.

## First Response

Before changing commands or editing data, capture the basic facts of the failure:

1. The exact failing command.
2. The target database name.
3. The source type and source name, if used.
4. The target tag or CR scope.
5. The deploy log path under `logs/`.
6. Any relevant project or CR names.

For staging failures, prefer preserving evidence and creating a fresh validation database over manual repair of a broken state.

## Authentication Or Connection Failures

Symptoms usually look like connection refusal, authentication failure, or `psql` errors before deployment starts.

Check these first:

- Confirm host and user defaults are correct in `~/vault/.default.sead.server` and `~/vault/.default.sead.username`.
- Confirm your local PostgreSQL authentication is usable non-interactively when `bin/deploy-staging` runs `psql --no-password`.
- Confirm `~/.pgpass` exists with `0600` permissions when password-based auth is required.
- Use `bin/psql.sh` to verify you can reach the expected database with the same local defaults.

See [ACCESS.md](ACCESS.md) for the supported local credential patterns.

## Missing Tag In Git Or Plan

Symptoms usually look like a requested release tag not being found or deployment stopping before the intended boundary.

Check these first:

1. Confirm the tag name follows `@YYYY.MM`.
2. Inspect the relevant project's `sqitch.plan` and confirm the tag exists where you expect it.
3. Confirm the local repository history matches the plan history you are relying on.
4. Check whether the task genuinely requires `--ignore-git-tags` or whether the tag inconsistency should be fixed first.

Do not make `--ignore-git-tags` the default answer to tag problems. Use it only when the history is understood and the workflow explicitly allows it.

## Existing Target Database Conflicts

Symptoms usually look like target database creation failing because the database name already exists.

Check these first:

- If you are using `--create-database`, confirm whether `--on-conflict rename` or `--on-conflict drop` is the intended behavior.
- Prefer `rename` when you want to preserve the previous validation database.
- Prefer a fresh target name when diagnosis is more important than reusing a familiar name.

Avoid manual one-off cleanup unless the operational context is already understood.

## Unexpected Deployment Scope Or Plan Drift

Symptoms usually look like too many changes being applied, too few changes being applied, or project order not matching expectations.

Check these first:

1. Confirm whether you used `--deploy-to-tag`, `--deploy-chain-to-tag`, or `--deploy-single-change-request`.
2. Confirm the target scope is compatible with the selected source type.
3. Review [projects.txt](../projects.txt) for deployment order.
4. Inspect the relevant project `sqitch.plan` files for CR and tag placement.
5. Use narrow status checks such as `sqitch status --target staging -C general` when you need a quick sanity check.

If the question is about routine staging deployment, return to the normal `bin/deploy-staging` path rather than improvising per-project deploy sequences.

## Hook Failures

Symptoms usually look like deployment reaching a tag or CR boundary and then failing while a hook runs.

Current hook surfaces include:

- `project/@YYYY.MM-pre-deploy-hook`
- `project/@YYYY.MM-post-deploy-hook`
- `project/deploy/<cr>/<cr>-post-deploy-hook`

Check these first:

1. Confirm the failing hook path from the deploy output or log.
2. Confirm the hook still matches the target database and tag assumptions.
3. Confirm the failure belongs to the hook and not to an earlier SQL step.

Treat hook debugging as a lower-level workflow. Preserve the failing command and log before narrowing the scope.

## Sequence Sync Issues

Symptoms usually look like deployment succeeding but later inserts or validations failing because sequence values are behind table data.

Check these first:

- Confirm whether the workflow should have used `--sync-sequences`.
- Confirm the apparent sequence problem was introduced by the deployed change and not by older target state.
- Prefer re-running validation on a fresh database when sequence state is uncertain.

## Partial Or Interrupted Staging Deploys

Symptoms usually look like a deployment that stopped mid-run, produced some side effects, and left the target in an uncertain state.

Recommended response:

1. Preserve the failing command and deploy log.
2. Determine whether the failure happened before or after Sqitch changes were applied.
3. Prefer a fresh validation database instead of manual patching.
4. Only move to lower-level commands after the normal path and failure point are understood.

Reproducibility matters more than salvaging a broken staging database.

## Where To Look

The most useful diagnostic surfaces are:

- `logs/` for timestamped deploy logs.
- Terminal output from `bin/deploy-staging`.
- The affected project's `sqitch.plan`.
- [OPERATIONS.md](OPERATIONS.md) for the standard deployment flow.
- [bin/deploy-staging.md](../bin/deploy-staging.md) for the command reference.
- [RELEASE-NOTES.md](RELEASE-NOTES.md) for release-specific caveats.

## Escalate With Context

When handing off a deployment problem, include:

1. The exact command.
2. The target database name.
3. The tag or CR scope.
4. The log file path.
5. The first clear error message.
6. Any recent change to plans, tags, or hooks.