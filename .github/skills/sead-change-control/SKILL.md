---
name: sead-change-control
description: "Repository-specific workflow for the SEAD change-control repo. Use when working with SEAD change requests, Sqitch project selection, repository schema source-of-truth files, live schema extraction helpers, staging validation, or migration review in this workspace."
argument-hint: "Describe the change-control task, migration, or local schema source question"
---

# SEAD Change Control

Use this skill for repository-specific SEAD database workflow in this workspace.

## What This Skill Covers

- Local source-of-truth schema files for the current repository
- Sqitch change-request workflow and project ownership rules
- Local extraction helpers for regenerating live schema CSV snapshots
- Repository-specific migration and staging validation guidance

## Core Rules

- Treat the live schema CSV exports in this workspace as the current source-of-truth when they have been regenerated from the live database.
- Treat deployed change requests as append-only history.
- Prefer a corrective CR over rewriting deployed migrations.
- Route change-request creation, verification, and staging validation through repository workflow rather than ad hoc commands.

## Procedure

1. Use [repository schema sources](./references/repository-schema-sources.md) to understand which local files are authoritative in this repo.
2. Use [table schema summary CSV](./references/table-schema-summary.csv) as the current source-of-truth table inventory for this workspace.
3. Use [table schema detailed CSV](./references/table-schema-detailed.csv) as the current source-of-truth column-level schema listing for this workspace.
4. Use [change management](./references/change-management.md) for project selection, CR naming, and migration review.
5. Use [extract-live-schema.sql](./references/extract-live-schema.sql) to refresh the live column-level schema export.
6. Use [extract-live-schema-summary.sql](./references/extract-live-schema-summary.sql) to refresh the live table-level schema summary export.
7. Use [inspect-model.sh](./scripts/inspect-model.sh) when you need quick inspection of the checked-in model exports.
8. Use the base `sead-database` skill for SEAD model concepts, join reasoning, glossary terms, and general SQL guidance.