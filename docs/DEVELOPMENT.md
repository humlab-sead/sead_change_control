# SEAD Development Guide

This document describes the normal contributor workflow for creating and validating database changes in this repository.

## Working Assumptions

- This repository manages database change history, not just loose SQL files.
- Deployed history is append-only. Prefer a corrective CR over rewriting an old deployed change.
- Each tracked database change should have a linked GitHub issue.
- New change requests should normally be created with `bin/add-change-request`.

## Local Prerequisites

Contributors typically need:

- `sqitch`
- `psql`
- `gh`
- Local PostgreSQL access suitable for staging or development validation
- A working `sqitch.conf`

The repository README lists typical `sqitch.conf` locations, and [ACCESS.md](ACCESS.md) covers the expected local access patterns.

## Choose The Right Project

Pick the owning Sqitch project before writing SQL.

Choose the project by the object or data domain that owns the change, not by which folder is most familiar.

| Project | Use this when | Usually not this project when |
| --- | --- | --- |
| `utility` | Adding reusable database helper functions or generic utility objects used across projects | The change is specific to one schema or one data domain |
| `sead_model` | Changing foundational model structure, core tables, common lookup structure, or schema-building objects | The change is a local data correction or a domain-specific submission |
| `security` | Adding or changing roles, grants, privileges, or security-related objects | The change is ordinary schema or data work |
| `general` | Shared schema, shared reference data, or general-purpose DDL or DML not owned by one domain project | The change clearly belongs to a single domain project |
| `mal` | MAL-specific data or lookup work owned by the MAL import and maintenance flow | The object is part of shared public schema rather than MAL-owned content |
| `archaeobotany` | Archaeobotany-specific data, submissions, or related lookups | The change is generic and reused across multiple domains |
| `dendrochronology` | Dendro-specific data, schema extensions tied to dendro content, or dendro submissions | The change belongs in shared schema or shared utilities |
| `adna` | Ancient DNA-specific changes | The work is not owned by the aDNA domain |
| `bugs` | BugsCEP-specific data imports, adjustments, or supporting structures | The change is general schema or non-Bugs domain data |
| `isotope` | Isotope-specific data or related domain objects | The change is generic across domains |
| `ceramics` | Ceramics-specific data or related domain objects | The change belongs to shared schema or another science domain |
| `radiocarbon` | Radiocarbon-specific data or domain structures | The work is general chronology infrastructure shared elsewhere |
| `subsystem` | Changes to subsystem-owned objects and support structures | The work is really API-facing, security-related, or domain data |
| `sead_api` | External API-facing database changes or API support structures | The work is not owned by the API surface |
| `facet` | Facet or REST-query storage structures | The work is shared schema rather than facet-owned storage |

If the ownership is unclear, inspect nearby plans and related existing CRs before creating a new one.

## Create A Change Request

Use `bin/add-change-request` instead of manually wiring plan files and SQL stubs.

Example:

```bash
bin/add-change-request \
  --project general \
  --change 20260528_DDL_EXAMPLE_CHANGE \
  --note "Describe the database change" \
  --create-issue
```

This keeps plan history, file layout, and issue linkage aligned with repository workflow.

## Naming Convention

Use the established CR naming convention:

```text
YYYYMMDD_[DDL|DML]_ENTITY_DESCRIPTION
```

Use `DDL` for function changes as well; do not use a separate `UDF` type in new CR names.

Good names are specific enough to be recognizable in plan history and release notes.

## Authoring SQL

The usual edit surfaces are:

- `[project]/deploy/**/*.sql`
- `[project]/verify/**/*.sql`
- `[project]/revert/**/*.sql`

General expectations:

- Keep changes small and scoped to the owning project.
- Make deploy scripts safe and comprehensible.
- Keep verify scripts aligned with what the deploy script changes.
- Avoid hidden assumptions about deployment order beyond what `projects.txt` and project history already express.

## Issue Linkage

Tracked database changes should have a GitHub issue.

The normal pattern is:

1. Create the CR with `bin/add-change-request`.
2. Create or link the issue at the same time.
3. Keep the issue, plan comment, and SQL header aligned.

## Review Expectations

Before opening or merging a change, confirm:

1. The CR is in the correct project.
2. The change name follows repository convention.
3. Issue linkage is present.
4. Deploy and verify SQL reflect the same intent.
5. The change has been validated on staging or a suitable test target.
6. Release impact is understood.

## Corrective Changes

If a deployed CR needs to be changed:

- Do not rewrite deployed history casually.
- Prefer a new corrective CR that makes the desired adjustment.
- Update release notes when the correction matters operationally.

This preserves auditability and keeps staging validation reproducible.

## Related Documents

- [ARCHITECTURE.md](ARCHITECTURE.md): system structure and project layering.
- [ACCESS.md](ACCESS.md): local access and credential setup.
- [TESTING.md](TESTING.md): validation expectations.
- [OPERATIONS.md](OPERATIONS.md): staging deployment and release-validation workflow.
- [README.md](../README.md): entry point and key commands.