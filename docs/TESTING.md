# SEAD Testing And Validation Guide

This document describes what validation means in the SEAD Change Control System and how contributors and operators should think about testing database changes.

## Validation Principles

- Validation is centered on staging deployment, not just SQL review.
- The most important question is whether a change deploys cleanly and leaves the database in the expected state.
- Testing should match the risk of the change. Schema changes, data migrations, and release tagging each need different checks.
- Known repository gaps should be documented rather than ignored.

## What Counts As Validation

For most CRs, validation includes some combination of:

1. Review of the affected deploy, verify, and revert SQL.
2. Successful deployment on staging or a comparable test target.
3. Confirmation that expected objects or data changes exist after deploy.
4. Smoke checks for workflows touched by the change.
5. Release-level acceptance checks when the CR is part of a tag.

## Minimum Expectations For Contributors

Before treating a change as ready:

1. Confirm the CR is in the correct project.
2. Confirm the plan entry, issue linkage, and SQL intent are aligned.
3. Validate the change on staging or an equivalent safe target when feasible.
4. Review any verify SQL for obvious mismatches with the deploy behavior.
5. Capture important caveats for reviewers or release operators.

## Staging Validation

The normal validation path is through `bin/deploy-staging`.

Typical staging validation means:

1. Create a fresh or controlled target database.
2. Deploy to the intended tag or latest.
3. Confirm the deploy completed successfully.
4. Check the affected schema objects, data state, or downstream behavior.
5. Record any manual follow-up required for release validation.

See [OPERATIONS.md](OPERATIONS.md) for the standard deployment flow.

## Deploy, Verify, And Revert Scripts

Different script types support different confidence signals:

- `deploy/`: the primary implementation surface.
- `verify/`: lightweight checks that the intended change is present and usable.
- `revert/`: limited rollback support where meaningful, without assuming production rollback is the default recovery path.

In practice, deploy scripts carry most of the real change logic, so successful staging deployment is the strongest signal.

## Smoke Checks

After deployment, smoke checks should focus on the specific impact area:

- For DDL changes: object existence, column types, constraints, indexes, and permissions when relevant.
- For DML changes: row presence, key relationships, lookup consistency, and expected counts where appropriate.
- For release validation: the database reaches the expected tagged state and supports the workflows needed for acceptance.

## Known Gaps

Current repository limitations should be assumed during validation:

- Automated test coverage is limited.
- Some verify scripts are minimal or act as stubs.
- Release validation still depends on manual acceptance checks.
- Rollback is not the primary safety model for this system.

These gaps make staging discipline and clear release notes more important.

## Release-Level Validation

When validating a release tag:

1. Confirm the intended tag name.
2. Deploy to that tag on staging.
3. Run smoke and acceptance checks.
4. Note caveats, deferred fixes, or operator concerns in [RELEASE-NOTES.md](RELEASE-NOTES.md).

## Practical Rule

If there is a choice between a theoretical review and a reproducible staging deploy, prefer the reproducible staging deploy.

## Related Documents

- [OPERATIONS.md](OPERATIONS.md): staging deployment and release-validation workflow.
- [DEVELOPMENT.md](DEVELOPMENT.md): contributor workflow and CR creation.
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md): deployment diagnosis when validation fails.
- [RELEASE-NOTES.md](RELEASE-NOTES.md): release checklist and release-specific notes.
- [project-review-2026-01-20.md](project-review-2026-01-20.md): historical analysis of testing gaps.