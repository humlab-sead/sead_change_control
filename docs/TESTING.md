# SEAD Testing and Validation Guide

This document describes what validation means in the SEAD Change Control System and how operators should approach testing database changes.

## Validation Principles

* Validation is based on staging deployment, not only on SQL review.
* The main question is whether a change deploys cleanly and leaves the database in the expected state.
* Testing should reflect the risk of the change. Schema changes, data migrations, and release tagging each need different checks.
* Known gaps in the repository should be documented rather than ignored.

## What Counts as Validation

For most change requests, validation includes some combination of:

1. Reviewing the affected deploy, verify, and revert SQL.
2. Deploying successfully on staging or a comparable test target.
3. Confirming that the expected objects or data changes exist after deployment.
4. Running smoke checks for workflows touched by the change.
5. Running release-level acceptance checks when the change request is part of a tagged release.

## Minimum Expectations for Contributors

Before treating a change as ready:

1. Confirm that the change request is in the correct project.
2. Confirm that the plan entry, issue linkage, and SQL intent are aligned.
3. Validate the change on staging or another safe target when feasible.
4. Review any verify SQL for clear mismatches with the deploy behavior.
5. Capture important caveats for reviewers or release operators.

## Staging Validation

The normal validation path is through `bin/deploy-staging`.

Typical staging validation means:

1. Create a fresh or controlled target database.
2. Deploy to the intended tag or to the latest state.
3. Confirm that the deployment completed successfully.
4. Check the affected schema objects, data state, or downstream behavior.
5. Record any manual follow-up needed for release validation.

See [OPERATIONS.md](OPERATIONS.md) for the standard deployment flow.

## Deploy, Verify, and Revert Scripts

The different script types provide different kinds of confidence:

* `deploy/`: contains the main implementation of the change.
* `verify/`: contains lightweight checks that the intended change is present and usable.
* `revert/`: provides limited rollback support where meaningful, without treating production rollback as the normal recovery path.

In practice, deploy scripts contain most of the real change logic, so a successful staging deployment is usually the strongest validation signal.

## Smoke Checks

After deployment, smoke checks should focus on the area affected by the change:

* For DDL changes: check object existence, column types, constraints, indexes, and permissions where relevant.
* For DML changes: check row presence, key relationships, lookup consistency, and expected counts where appropriate.
* For release validation: confirm that the database reaches the expected tagged state and supports the workflows needed for acceptance.

## Known Gaps

Current repository limitations should be taken into account during validation:

* Automated test coverage is limited.
* Some verify scripts are minimal or act as stubs.
* Release validation still depends on manual acceptance checks.
* Rollback is not the main safety model for this system.

These gaps make disciplined staging validation and clear release notes especially important.

## Release-Level Validation

When validating a release tag:

1. Confirm the intended tag name.
2. Deploy to that tag on staging.
3. Run smoke and acceptance checks.
4. Note caveats, deferred fixes, or operator concerns in [RELEASE-NOTES.md](RELEASE-NOTES.md).

## Practical Rule

When choosing between a theoretical review and a reproducible staging deployment, prefer the reproducible staging deployment.

## Related Documents

* [OPERATIONS.md](OPERATIONS.md): staging deployment and release-validation workflow.
* [DEVELOPMENT.md](DEVELOPMENT.md): contributor workflow and change request creation.
* [TROUBLESHOOTING.md](TROUBLESHOOTING.md): deployment diagnosis when validation fails.
* [RELEASE-NOTES.md](RELEASE-NOTES.md): release checklist and release-specific notes.
* [project-review-2026-01-20.md](project-review-2026-01-20.md): historical analysis of testing gaps.
