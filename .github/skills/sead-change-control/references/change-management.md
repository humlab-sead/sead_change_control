# Change Management

Use this guidance when the task is not just querying SEAD but changing it in this repository.

## Core Repository Rules

- Treat deployed change requests as append-only history.
- Prefer a new corrective CR over rewriting a deployed migration.
- Use `bin/add-change-request` for new CRs instead of hand-editing plan history.
- A tracked database change should have a GitHub issue.
- Validate on staging or a suitable test database.
- Route deployment guidance through `bin/deploy-staging`, not ad hoc production commands.

## Naming

Use the repository naming convention:

`YYYYMMDD_[DDL|DML]_ENTITY_DESCRIPTION`

Use `DDL` for function changes as well.

## Project Selection

Choose the project by ownership of the data or schema being changed.

- `sead_model`: foundational model structure, core tables, common lookup structure, schema-building objects, and model-export ownership
- `general`: shared schema or shared reference data not owned by one science domain
- domain projects such as `archaeobotany`, `bugs`, `dendrochronology`, `ceramics`, `radiocarbon`, `isotope`, and `adna`: domain-owned structures or data
- `utility`: reusable helper functions or utility objects
- `security`: roles, grants, and privileges

If a change spans shared model structure and one domain project, split it rather than forcing one project to own everything.

## Standard Flow

1. Confirm the owning project.
2. Create or identify the GitHub issue.
3. Run `bin/add-change-request` with the project, change name, note, and issue option.
4. Implement the SQL in the project `deploy/` folder.
5. Add or update `verify/` logic when the change is structural.
6. Validate on staging or a suitable test database.

## Command Pattern

```bash
bin/add-change-request \
  --project sead_model \
  --change 20260530_DDL_EXAMPLE_CHANGE \
  --note "Describe the model change" \
  --create-issue
```

## Migration Review Checklist

- Is the owning project correct?
- Is the change request name compliant?
- Is the SQL forward-only and safe to deploy once?
- Is a new CR being used instead of editing deployed history?
- Does the change include verification where appropriate?
- Does the plan avoid direct production deployment guidance?

## When To Escalate

- The change touches objects owned by more than one project.
- The proposal mixes shared schema and domain data in one CR.
- The user asks for direct production deployment.
- The live schema appears newer than the model exports used for reasoning.