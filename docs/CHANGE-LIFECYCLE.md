# SEAD Change Lifecycle

This document describes the normal lifecycle of a database change in the SEAD Change Control System, from the first issue through staging validation and release inclusion.

## Lifecycle Principles

- Treat tracked database changes as auditable work items, not just loose SQL edits.
- A tracked change should have a GitHub issue.
- New change requests should normally be created with `bin/add-change-request`.
- Deployed history is append-only. If behavior must change later, prefer a new corrective CR over rewriting deployed history.
- Staging validation and release validation should route through `bin/deploy-staging`.

## End-To-End Flow

The normal lifecycle is:

1. Identify the change and create or confirm the GitHub issue.
2. Choose the owning Sqitch project.
3. Create the change request with `bin/add-change-request`.
4. Implement the deploy, verify, and revert SQL as needed.
5. Review and validate the change on staging or a suitable test target.
6. Include the change in the appropriate release tag.
7. Validate the release boundary on staging.
8. Record release notes and operational caveats.
9. If follow-up is needed after release, add a corrective CR instead of rewriting deployed history.

## 1. Issue Creation Or Issue Linking

Start by creating or identifying the GitHub issue that will track the change.

The issue should make it easy to correlate the database work later, so include:

- The affected project.
- The intended change name when known.
- A concise description of the database problem or requested change.
- The likely SQL surface or affected objects when that is already clear.

If the issue already exists, carry that issue ID into CR creation rather than creating duplicate tracking.

## 2. Project Selection

Choose the project by ownership of the schema or data being changed, not by convenience.

Use these routing rules as a quick filter:

- Shared schema or broadly reused data: usually `general`, or `sead_model` for foundational model changes.
- Roles, grants, or privileges: `security`.
- Reusable helper functions: `utility`.
- Domain-specific changes: the owning domain project such as `bugs`, `mal`, `archaeobotany`, or `dendrochronology`.
- API-facing or subsystem-owned objects: `sead_api`, `subsystem`, or `facet` as appropriate.

If the change spans shared structure and domain-specific data, split the work along ownership boundaries instead of forcing it into one convenient project.

See [DEVELOPMENT.md](DEVELOPMENT.md) for the detailed project-selection table used by contributors.

## 3. Change Request Creation

Create the CR with `bin/add-change-request`.

Normal patterns:

```bash
bin/add-change-request \
  --project general \
  --change 20260528_DDL_EXAMPLE_CHANGE \
  --note "Explain the change briefly" \
  --create-issue
```

Or, when the issue already exists:

```bash
bin/add-change-request \
  --project general \
  --change 20260528_DDL_EXAMPLE_CHANGE \
  --note "Explain the change briefly" \
  --issue-id 123
```

Use the established naming convention:

```text
YYYYMMDD_[DDL|DML]_ENTITY_DESCRIPTION
```

Use `DDL` for function changes as well; do not use a separate `UDF` type in new CR names.

This keeps plan history, file layout, and issue linkage aligned with repository workflow.

## 4. SQL Authoring

After creating the CR, implement the SQL in the owning project:

- `deploy/` for the primary change logic
- `verify/` for validation logic where meaningful
- `revert/` for limited rollback support where maintained

Keep the change narrow, readable, and consistent with the plan entry and issue description.

General expectations:

- Keep deploy and verify intent aligned.
- Avoid hidden assumptions about deployment order beyond repository history and [projects.txt](../projects.txt).
- Prefer small corrective follow-up CRs over rewriting old deployed files.

## 5. Review And Validation

Before treating the change as ready:

1. Confirm the CR is in the correct project.
2. Confirm the issue, change name, and SQL intent all match.
3. Review deploy and verify SQL together.
4. Validate on staging or a suitable safe target.
5. Capture any operational caveats for release notes or reviewers.

For most meaningful changes, successful staging deployment is the strongest signal that the change is safe to carry forward.

See [TESTING.md](TESTING.md) for validation expectations.

## 6. Tagging And Release Inclusion

When the change is ready to be included in a release, use repository tagging workflow rather than ad hoc notes.

Typical release tagging:

```bash
bin/tag-projects --tag "@2026.05" --note "May 2026 release"
```

Release tags should follow the `@YYYY.MM` format.

At this point, the change becomes part of a release boundary that should be validated on staging.

## 7. Release Validation On Staging

Release validation should route through `bin/deploy-staging`.

Typical release-boundary validation:

```bash
./bin/deploy-staging \
  --create-database \
  --source-type empty \
  --target-db-name sead_staging_202605 \
  --deploy-to-tag @2026.05
```

Normal release validation means:

1. Confirm the intended tag.
2. Create a fresh or controlled staging target.
3. Deploy to the release tag.
4. Run smoke and acceptance checks.
5. Preserve logs and caveats.

See [OPERATIONS.md](OPERATIONS.md) for the standard operator workflow.

## 8. Release Notes Update

When the change materially affects release behavior, schema, or data interpretation, record it in [RELEASE-NOTES.md](RELEASE-NOTES.md).

Typical release-note content includes:

- Notable CRs.
- Important operational caveats.
- Acceptance concerns or deferred work.
- Any release-specific context later operators will need.

This is the point where the technical change becomes part of the repository’s operational history.

## 9. Post-Release Follow-Up And Corrective Changes

If a problem is found after a change is tagged or deployed:

- Do not casually rewrite deployed history.
- Create a new corrective CR in the appropriate project.
- Link or update the issue trail so the relationship stays clear.
- Add release-note context when the correction matters operationally.

The goal is to preserve auditability and reproducibility while still allowing the system to evolve safely.

## Quick Checklist

1. Issue exists or is linked.
2. Correct project chosen.
3. CR created with `bin/add-change-request`.
4. SQL implemented in the owning project.
5. Validation completed on staging or a suitable test target.
6. Release tag applied when appropriate.
7. Release validated through `bin/deploy-staging`.
8. Release notes updated when needed.
9. Follow-up handled through a corrective CR, not history rewrite.

## Related Documents

- [DEVELOPMENT.md](DEVELOPMENT.md): contributor workflow and project selection.
- [TESTING.md](TESTING.md): validation expectations.
- [OPERATIONS.md](OPERATIONS.md): staging deployment and release-validation workflow.
- [RELEASE-NOTES.md](RELEASE-NOTES.md): release history and checklist.
- [README.md](../README.md): repository entry point.