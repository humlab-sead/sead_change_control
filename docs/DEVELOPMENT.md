# SEAD Development Guide

This document describes the normal contributor workflow for creating and validating database changes in this repository.

## Working Assumptions

* This repository manages database change history, not just individual SQL files.
* Deployed history is append-only. If an old deployed change needs to be adjusted, create a corrective change request rather than rewriting it.
* Each tracked database change should have a linked GitHub issue.
* New change requests should normally be created with `bin/add-change-request`.

## Local Prerequisites

Contributors typically need:

* `sqitch`
* `psql`
* `gh`
* Local PostgreSQL access suitable for staging or development validation
* A working `sqitch.conf`

The repository README lists typical `sqitch.conf` locations. [ACCESS.md](ACCESS.md) describes the expected local access patterns.

## Choose the Right Project

Choose the owning Sqitch project before writing SQL.

Pick the project based on the object, schema, or data domain that owns the change, not on which folder is most familiar.

| Project            | Use this when                                                                                                    | Usually not this project when                                            |
| ------------------ | ---------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| `utility`          | Adding reusable database helper functions or generic utility objects used across projects                        | The change is specific to one schema or one data domain                  |
| `sead_model`       | Changing foundational model structure, core tables, common lookup structure, or schema-building objects          | The change is a local data correction or a domain-specific submission    |
| `security`         | Adding or changing roles, grants, privileges, or security-related objects                                        | The change is ordinary schema or data work                               |
| `general`          | Working with shared schema, shared reference data, or general-purpose DDL or DML not owned by one domain project | The change clearly belongs to a single domain project                    |
| `mal`              | Working with MAL-specific data or lookups owned by the MAL import and maintenance flow                           | The object is part of shared public schema rather than MAL-owned content |
| `archaeobotany`    | Working with archaeobotany-specific data, submissions, or related lookups                                        | The change is generic and reused across several domains                  |
| `dendrochronology` | Working with dendro-specific data, schema extensions tied to dendro content, or dendro submissions               | The change belongs in shared schema or shared utilities                  |
| `adna`             | Making Ancient DNA-specific changes                                                                              | The work is not owned by the aDNA domain                                 |
| `bugs`             | Working with BugsCEP-specific data imports, adjustments, or supporting structures                                | The change is general schema work or belongs to another data domain      |
| `isotope`          | Working with isotope-specific data or related domain objects                                                     | The change is generic across domains                                     |
| `ceramics`         | Working with ceramics-specific data or related domain objects                                                    | The change belongs to shared schema or another science domain            |
| `radiocarbon`      | Working with radiocarbon-specific data or domain structures                                                      | The work is general chronology infrastructure shared elsewhere           |
| `subsystem`        | Changing subsystem-owned objects or support structures                                                           | The work is really API-facing, security-related, or domain data          |
| `sead_api`         | Making external API-facing database changes or changes to API support structures                                 | The work is not owned by the API surface                                 |
| `facet`            | Changing facet or REST-query storage structures                                                                  | The work belongs to shared schema rather than facet-owned storage        |

If ownership is unclear, inspect nearby plans and related existing change requests before creating a new one.

## Create a Change Request

Use `bin/add-change-request` instead of manually editing plan files and creating SQL stubs.

Example:

```bash
bin/add-change-request \
  --project general \
  --change 20260528_DDL_EXAMPLE_CHANGE \
  --note "Describe the database change" \
  --create-issue
```

This keeps the plan history, file layout, and issue linkage aligned with the repository workflow.

## Naming Convention

Use the established change request naming convention:

```text
YYYYMMDD_[DDL|DML]_ENTITY_DESCRIPTION
```

Use `DDL` for function changes as well. Do not introduce a separate `UDF` type in new change request names.

Good names are specific enough to be easy to recognize in plan history and release notes.

## Authoring SQL

The usual files to edit are:

* `[project]/deploy/**/*.sql`
* `[project]/verify/**/*.sql`
* `[project]/revert/**/*.sql`

General expectations:

* Keep changes small and scoped to the owning project.
* Make deploy scripts safe and easy to understand.
* Keep verify scripts aligned with what the deploy script changes.
* Avoid hidden assumptions about deployment order beyond what `projects.txt` and the project history already define.

## Issue Linkage

Tracked database changes should have a GitHub issue.

The normal pattern is:

1. Create the change request with `bin/add-change-request`.
2. Create or link the issue at the same time.
3. Keep the issue, plan comment, and SQL header aligned.

## Review Expectations

Before opening or merging a change, confirm that:

1. The change request is in the correct project.
2. The change name follows the repository convention.
3. Issue linkage is present.
4. Deploy and verify SQL reflect the same intent.
5. The change has been validated on staging or another suitable test target.
6. The release impact is understood.

## Corrective Changes

If a deployed change request needs to be changed:

* Do not casually rewrite deployed history.
* Create a new corrective change request that makes the required adjustment.
* Update release notes when the correction matters operationally.

This preserves auditability and keeps staging validation reproducible.

## Related Documents

* [ARCHITECTURE.md](ARCHITECTURE.md): system structure and project layering.
* [ACCESS.md](ACCESS.md): local access and credential setup.
* [TESTING.md](TESTING.md): validation expectations.
* [OPERATIONS.md](OPERATIONS.md): staging deployment and release-validation workflow.
* [README.md](../README.md): entry point and key commands.
