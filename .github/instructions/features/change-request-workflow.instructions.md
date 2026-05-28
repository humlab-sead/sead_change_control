---
description: "Use only for explicit change-request workflow questions: creating a new CR, choosing a Sqitch project, naming a CR, or deciding which bin/add-change-request arguments to use. Not for editing SQL inside an existing CR."
---
# Change Request Workflow

- Prefer `bin/add-change-request` for new CRs. It updates the plan and keeps metadata consistent.
- New change names should follow `YYYYMMDD_[DDL|DML]_ENTITY_DESCRIPTION`.
- Use `DDL` for function changes as well; do not introduce a separate `UDF` type in new CR names.
- A tracked CR should have a GitHub issue. Use `--create-issue` or pass `--issue-id` when the issue already exists.
- Choose the project by ownership of the data or schema being changed, not by convenience.

## Project Selection Guide

Choose the project by the object or data domain that owns the change, not by which folder is most familiar.

| Project | Use this when | Usually not this project when |
| --- | --- | --- |
| `utility` | Adding reusable database helper functions or generic utility objects used across projects | The change is specific to one schema or one data domain |
| `sead_model` | Changing foundational model structure, core tables, common lookup structure, or schema-building objects | The change is a local data correction or a domain-specific submission |
| `security` | Adding or changing roles, grants, privileges, or security-related objects | The change is ordinary schema or data work |
| `general` | Shared schema, shared reference data, or general-purpose DDL/DML not owned by one domain project | The change clearly belongs to a single domain project |
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

## Quick Routing Examples

- Add a shared public table or alter a common table column: usually `general`, or `sead_model` if it changes core model structure.
- Add grants, roles, or privilege changes: `security`.
- Add a reusable SQL helper function: `utility`.
- Commit a BugsCEP import or correct Bugs-specific data: `bugs`.
- Commit a dendro submission or dendro-owned lookup/model adjustment: `dendrochronology`.
- Add API support tables or API-owned objects: `sead_api`.
- If the change spans shared schema and one domain project, put the shared structural part in `general` or `sead_model` and keep domain data in the owning project.

## When To Stop And Re-evaluate

- The change touches objects owned by more than one project.
- The change mixes shared schema and domain data in one CR.
- The easiest folder differs from the actual owner of the data or schema.
- The repository history for similar changes points to a different project than your first guess.

## Standard Flow

1. Confirm the target project.
2. Create or identify the GitHub issue.
3. Run `bin/add-change-request` with the chosen project, CR name, note, and issue option.
4. Implement the SQL in the project `deploy/` folder.
5. Add or update `verify/` logic when the change is structural.
6. Validate on staging or a suitable test database.

## Command Pattern

```bash
bin/add-change-request \
  --project general \
  --change 20260527_DDL_EXAMPLE_CHANGE \
  --note "Explain the change briefly" \
  --create-issue
```

## Guardrails

- Do not bypass `bin/add-change-request` just to save time.
- Do not manually rewrite historical plan entries for normal feature work.
- Do not modify a deployed CR in place when a corrective CR is the safer path.
