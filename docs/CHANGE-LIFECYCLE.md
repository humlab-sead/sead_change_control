# SEAD Change Lifecycle

This document describes the normal lifecycle of a database change in the SEAD Change Control System, from the initial issue through staging validation and release inclusion.

## Lifecycle Principles

* Treat tracked database changes as auditable work items, not as loose SQL edits.
* Each tracked change should have a GitHub issue.
* New change requests should normally be created with `bin/add-change-request`.
* Deployed history is append-only. If a change needs to be corrected later, create a new corrective change request rather than rewriting deployed history.
* Staging validation and release validation should go through `bin/deploy-staging`.

## End-to-End Flow

The normal lifecycle is:

1. Identify the change and create or confirm the GitHub issue.
2. Choose the Sqitch project that owns the change.
3. Create the change request with `bin/add-change-request`.
4. Implement the deploy, verify, and revert SQL as needed.
5. Review and validate the change on staging or another suitable test target.
6. Include the change in the appropriate release tag.
7. Validate the release boundary on staging.
8. Record release notes and any operational caveats.
9. If follow-up is needed after release, create a corrective change request instead of rewriting deployed history.

## 1. Issue Creation or Issue Linking

Start by creating or identifying the GitHub issue that will track the change.

The issue should make the database work easy to trace later. Include:

* The affected project.
* The intended change name, if known.
* A concise description of the database problem or requested change.
* The likely SQL surface or affected objects, if already known.

If an issue already exists, use that issue ID when creating the change request instead of creating duplicate tracking.

## 2. Project Selection

Choose the project based on ownership of the schema or data being changed, not based on convenience.

Use these routing rules as a quick guide:

* Shared schema or broadly reused data: usually `general`, or `sead_model` for foundational model changes.
* Roles, grants, or privileges: `security`.
* Reusable helper functions: `utility`.
* Domain-specific changes: the owning domain project, such as `bugs`, `mal`, `archaeobotany`, or `dendrochronology`.
* API-facing or subsystem-owned objects: `sead_api`, `subsystem`, or `facet`, as appropriate.

If a change spans shared structure and domain-specific data, split the work along ownership boundaries rather than forcing everything into one convenient project.

See [DEVELOPMENT.md](DEVELOPMENT.md) for the detailed project-selection table used by contributors.

## 3. Change Request Creation

Create the change request with `bin/add-change-request`.

Normal pattern:

```bash
bin/add-change-request \
  --project general \
  --change 20260528_DDL_EXAMPLE_CHANGE \
  --note "Explain the change briefly" \
  --create-issue
```

When the issue already exists:

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

Use `DDL` for function changes as well. Do not introduce a separate `UDF` type in new change request names.

This keeps plan history, file layout, and issue linkage aligned with the repository workflow.

## 4. SQL Authoring

After creating the change request, implement the SQL in the owning project:

* `deploy/` for the main change logic.
* `verify/` for validation logic, where meaningful.
* `revert/` for limited rollback support, where maintained.

Keep the change narrow, readable, and consistent with the plan entry and issue description.

General expectations:

* Keep the deploy and verify logic aligned.
* Avoid hidden assumptions about deployment order beyond the repository history and [projects.txt](../projects.txt).
* Prefer small corrective follow-up change requests over rewriting old deployed files.

## 5. Review and Validation

Before treating the change as ready:

1. Confirm that the change request is in the correct project.
2. Confirm that the issue, change name, and SQL intent match.
3. Review the deploy and verify SQL together.
4. Validate the change on staging or another safe test target.
5. Capture any operational caveats for release notes or reviewers.

For most meaningful changes, a successful staging deployment is the strongest sign that the change is safe to carry forward.

See [TESTING.md](TESTING.md) for validation expectations.

## 6. Tagging and Release Inclusion

When the change is ready to be included in a release, use the repository tagging workflow rather than informal notes.

Typical release tagging:

```bash
bin/tag-projects --tag "@2026.05" --note "May 2026 release"
```

Release tags should follow the `@YYYY.MM` format.

At this point, the change becomes part of a release boundary that should be validated on staging.

## 7. Release Validation on Staging

Release validation should go through `bin/deploy-staging`.

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
5. Preserve logs and note any caveats.

See [OPERATIONS.md](OPERATIONS.md) for the standard operator workflow.

## 8. Release Notes Update

When a change materially affects release behavior, schema, or data interpretation, record it in [RELEASE-NOTES.md](RELEASE-NOTES.md).

Typical release-note content includes:

* Notable change requests.
* Important operational caveats.
* Acceptance concerns or deferred work.
* Any release-specific context that later operators will need.

This is where the technical change becomes part of the repository’s operational history.

## 9. Post-Release Follow-Up and Corrective Changes

If a problem is found after a change has been tagged or deployed:

* Do not casually rewrite deployed history.
* Create a new corrective change request in the appropriate project.
* Link or update the issue trail so the relationship remains clear.
* Add release-note context when the correction matters operationally.

The goal is to preserve auditability and reproducibility while still allowing the system to evolve safely.

## Quick Checklist

1. Issue exists or is linked.
2. Correct project chosen.
3. Change request created with `bin/add-change-request`.
4. SQL implemented in the owning project.
5. Validation completed on staging or another suitable test target.
6. Release tag applied when appropriate.
7. Release validated through `bin/deploy-staging`.
8. Release notes updated when needed.
9. Follow-up handled through a corrective change request, not a history rewrite.

## Related Documents

* [DEVELOPMENT.md](DEVELOPMENT.md): contributor workflow and project selection.
* [TESTING.md](TESTING.md): validation expectations.
* [OPERATIONS.md](OPERATIONS.md): staging deployment and release-validation workflow.
* [RELEASE-NOTES.md](RELEASE-NOTES.md): release history and checklist.
* [README.md](../README.md): repository entry point.
