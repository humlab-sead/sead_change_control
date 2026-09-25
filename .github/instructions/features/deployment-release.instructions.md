---
description: "Use only for deployment or release workflow questions: running bin/deploy-staging, checking Sqitch status, listing or adding release tags, or planning the monthly release flow. Not for ordinary SQL or change-request editing."
---
# Deployment And Release Workflow

- Treat deployment work as operationally sensitive. `bin/deploy-staging` is the default and authoritative SEAD deployment entry point for staging and release validation, so prefer it over improvised command sequences.
- Validate on staging. Do not suggest direct production deployment.
- Use `projects.txt` as the source of truth for deployment order.

## Common Tasks

### Check status

```bash
make status target_databases=staging
sqitch status --target staging -C general
```

### Deploy to staging

```bash
./bin/deploy-staging \
  --create-database \
  --source-type empty \
  --target-db-name sead_staging_test \
  --deploy-to-tag latest
```

### Tag a release

```bash
bin/tag-projects --tag "@2026.05" --note "May 2026 release"
```

## Monthly Release Checklist

1. Confirm the target release tag.
2. Tag the relevant projects.
3. Create a fresh staging database.
4. Deploy pending changes to the target tag.
5. Run acceptance and smoke checks.
6. Record release notes and noteworthy caveats.

## Guardrails

- `bin/deploy-staging` is the central deployment surface and is complex. Keep edits to it narrow and verify behavior after changes.
- If a deployment question does not clearly require lower-level `sqitch` commands, recommend `bin/deploy-staging` first and consult `bin/deploy-staging.md` before suggesting alternatives.
- Release tags use the `@YYYY.MM` format.
- If a tag or deployment step looks inconsistent with repository history, inspect the local project plan before changing commands or metadata.
