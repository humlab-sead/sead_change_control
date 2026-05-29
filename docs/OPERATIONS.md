# SEAD Operations Guide

This document describes the standard operating path for staging deployment and release validation in the SEAD Change Control System.

## Operating Principles

* Treat deployment work as operationally sensitive.
* Use staging for validation. Do not use this repository as instructions for direct production deployment.
* Use `bin/deploy-staging` as the default deployment entry point for staging and release validation.
* Use [projects.txt](../projects.txt) as the source of truth for deployment order.
* If a deployed change needs to be corrected, create a new corrective change request instead of rewriting release history.

## Standard Deployment Path

For normal deployment and release-validation work, the path is:

1. Confirm the intended tag or deployment scope.
2. Review the relevant project plans and release notes.
3. Create or refresh a staging database.
4. Run `bin/deploy-staging` with the appropriate source and tag options.
5. Inspect deployment logs and errors.
6. Run smoke checks and acceptance checks.
7. Record release notes or follow-up actions.

If a deployment question does not clearly require lower-level commands, start with `bin/deploy-staging` and consult [bin/deploy-staging.md](../bin/deploy-staging.md) before proposing alternatives.

## Common Operator Tasks

### Check release state

Use narrow status checks when you need to understand the current state before deployment:

```bash
make status target_databases=staging
sqitch status --target staging -C general
```

Use the project-local `sqitch.plan` history when tags or expected state look inconsistent.

### Create a fresh staging database and deploy to latest

```bash
./bin/deploy-staging \
  --create-database \
  --source-type empty \
  --target-db-name sead_staging_test \
  --deploy-to-tag latest
```

This is the default pattern when you need a clean validation target.

### Deploy to a specific release tag

```bash
./bin/deploy-staging \
  --create-database \
  --source-type empty \
  --target-db-name sead_staging_202605 \
  --deploy-to-tag @2026.05
```

Use tagged deployment when validating a release boundary rather than the current head.

### Tag a release

```bash
bin/tag-projects --tag "@2026.05" --note "May 2026 release"
```

Release tags should follow the `@YYYY.MM` format.

## When to Use Lower-Level Commands

Do not replace routine staging deployments with ad hoc per-project `sqitch deploy` sequences.

Lower-level commands are appropriate only when:

* You are debugging `bin/deploy-staging` itself.
* You are inspecting the state of a single project during diagnosis.
* You are working on tooling or verifying a narrow behavior that the higher-level script hides.

Even in those cases, treat `bin/deploy-staging` as the reference path that the system is expected to support.

## Logs and Operational Evidence

During or after deployment, inspect:

* `logs/` for timestamped deployment logs.
* Terminal output from `bin/deploy-staging`.
* The affected project’s `sqitch.plan` for expected tags and change-request ordering.
* [docs/RELEASE-NOTES.md](RELEASE-NOTES.md) for release checklist and release-specific context.

If a deployment result is surprising, capture the target database name, tag, source type, and relevant log path before changing anything else.

## Standard Validation Expectations

After a staging deployment:

1. Confirm that the deploy command completed without unresolved errors.
2. Confirm that the expected tag or change-request set was applied.
3. Run any project-specific smoke checks needed for the release.
4. Review the acceptance criteria for the release.
5. Record caveats in [docs/RELEASE-NOTES.md](RELEASE-NOTES.md) when they matter for later operators.

See [TESTING.md](TESTING.md) for a more detailed validation checklist.

## Recovery Guidance

If a staging deployment fails:

1. Stop and preserve the failing command, target database name, and logs.
2. Determine whether the failure is related to tag history, project ordering, target database state, or SQL behavior.
3. Inspect the relevant project plan before modifying deployment commands.
4. Prefer creating a fresh validation database over manually repairing a broken staging state, unless the task is specifically incident analysis.
5. Use targeted lower-level commands only after the normal path has been understood.

The goal is to preserve reproducibility. Avoid one-off manual repairs that cannot be repeated.

## Monthly Release Flow

The normal monthly release-validation flow is:

1. Confirm the release tag.
2. Tag the relevant projects.
3. Create a fresh staging database.
4. Deploy pending changes to the target tag.
5. Run acceptance and smoke checks.
6. Update release notes with notable change requests and caveats.

The release checklist in [docs/RELEASE-NOTES.md](RELEASE-NOTES.md) remains the release-facing companion to this operations guide.

## Related Documents

* [bin/deploy-staging.md](../bin/deploy-staging.md): detailed command reference.
* [ACCESS.md](ACCESS.md): local access and credential setup.
* [TESTING.md](TESTING.md): validation expectations and known gaps.
* [TROUBLESHOOTING.md](TROUBLESHOOTING.md): symptom-driven deployment diagnosis.
* [RELEASE-NOTES.md](RELEASE-NOTES.md): release history and checklist.
