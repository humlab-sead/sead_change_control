# SEAD System Documentation Plan

This document defines the recommended system documentation set for the SEAD Change Control System. It is intended to keep the documentation compact, operationally useful, and aligned with how this repository is actually used.

## Documentation Goals

- Explain what the repository controls and what it does not.
- Make the standard operating path obvious, especially staging deployment through `bin/deploy-staging`.
- Reduce tribal knowledge for change-request authors, reviewers, and release operators.
- Separate stable reference material from workflow guidance and from historical review notes.

## Recommended Documentation Set

### Keep and clarify existing docs

#### `README.md`

Keep this as the repository entry point.

Recommended scope:

- What the SEAD Change Control System is.
- The repository's main projects and deployment model.
- The primary workflows: add a CR, deploy to staging, tag a release.
- A short documentation index linking to the docs below.

This file should stay short and route readers to deeper documents.

#### `bin/deploy-staging.md`

Keep this as the command reference for the central deploy script.

Recommended scope:

- Options and examples.
- Command behavior and supported deployment modes.
- Notes about snapshots, tags, hooks, and logging.

This file should remain the detailed reference for the script itself, not the full operations runbook.

#### `docs/RELEASE-NOTES.md`

Keep this as release history and release checklist material.

Recommended scope:

- Monthly release narrative.
- Notable CRs and project changes.
- Release checklist and release-specific caveats.

### Current system docs

#### `docs/ARCHITECTURE.md`

Purpose: explain how the system is structured.

Recommended sections:

- System purpose and boundaries.
- Why Sqitch is used here.
- Forward-only migration model.
- Project layout and responsibilities.
- Dependency and deployment order from `projects.txt`.
- Key workflow scripts and what owns each workflow.
- Diagram of the deployment chain and project layers.

Use this doc to answer: How is the SEAD CCS organized, and why is it organized this way?

#### `docs/OPERATIONS.md`

Purpose: define the standard operator workflow.

Recommended sections:

- Operational principles and safety rules.
- Standard staging deployment flow.
- Release-validation flow.
- When to use `bin/deploy-staging` and when not to improvise lower-level commands.
- Log files, outputs, and where to inspect failures.
- Acceptance and smoke-check expectations.
- Recovery guidance for failed staging deploys.

Use this doc to answer: What is the normal, approved way to operate this system?

#### `docs/DEVELOPMENT.md`

Purpose: define the contributor workflow for change requests.

Recommended sections:

- Local prerequisites.
- How to choose the right Sqitch project.
- How to create a new change request with `bin/add-change-request`.
- Naming conventions for CRs.
- Issue linkage expectations.
- When to create a corrective CR instead of editing old history.
- Review expectations before merge.

Use this doc to answer: How do I make a safe, normal change in this repository?

#### `docs/TESTING.md`

Purpose: describe validation expectations for migrations and releases.

Recommended sections:

- What counts as validation in this repository.
- Deploy validation on staging.
- Expectations for deploy, verify, and revert scripts.
- Smoke tests after deployment.
- Data migration checks.
- Testing gaps and known manual steps.

Use this doc to answer: What do I need to run or verify before I can trust a change?

#### `docs/TROUBLESHOOTING.md`

Purpose: provide symptom-driven operational help.

Recommended sections:

- Missing tag in Git or plan.
- Sqitch status or plan drift.
- Verify failures.
- Existing target database conflict handling.
- Sequence sync issues.
- Hook failures.
- Partial or interrupted staging deploys.
- How to collect useful logs before escalating.

Use this doc to answer: A deployment or CR workflow failed. What should I check next?

#### `docs/ACCESS.md`

Purpose: document environment setup and access expectations without storing secrets.

Recommended sections:

- Required tools.
- Expected `sqitch.conf` locations.
- How `psql` access is typically configured.
- `.pgpass` and local vault conventions.
- Environment variables expected by scripts.
- Security boundaries for credentials in docs and automation.

Use this doc to answer: What local setup do I need before I can work safely with this system?

#### `docs/CHANGE-LIFECYCLE.md`

Purpose: describe how a database change moves through the system.

Recommended sections:

- Issue creation or issue linking.
- Change request creation.
- SQL authoring and review.
- Validation on staging.
- Tagging and release inclusion.
- Release notes update.
- Post-release follow-up and corrective changes.

Use this doc to answer: What is the lifecycle from idea to released database change?

## Recommended Ownership Of Existing Material

### Move or summarize from `README.md`

Keep brief versions in the README and move detailed workflow material into deeper docs.

- Keep high-level install and project summary in `README.md`.
- Keep short examples for `bin/add-change-request`, `bin/deploy-staging`, and `bin/tag-projects` in `README.md`.
- Move extended workflow explanation and operator decision-making into `docs/DEVELOPMENT.md` and `docs/OPERATIONS.md`.

### Reuse `bin/deploy-staging.md`

Do not merge this into the general operations doc.

- Keep detailed CLI options in `bin/deploy-staging.md`.
- Reference it from `docs/OPERATIONS.md` as the authoritative command reference.
- Put workflow guidance, guardrails, and failure handling in `docs/OPERATIONS.md`.

### Reuse `docs/project-review-2026-01-20.md`

Treat this as historical analysis, not as operational guidance.

- Mine it for architecture notes when refining `docs/ARCHITECTURE.md`.
- Mine it for testing gaps when refining `docs/TESTING.md`.
- Mine it for documentation and operational recommendations when refining `docs/OPERATIONS.md` and `docs/TROUBLESHOOTING.md`.
- Do not rely on it as the day-to-day source of truth.

### Keep `docs/RELEASE-NOTES.md` release-focused

- Keep release notes, release checklist items, and release caveats here.
- Do not expand it into a general operations manual.

## Suggested Navigation Structure

The documentation should read in this order for new contributors:

1. `README.md`
2. `docs/ARCHITECTURE.md`
3. `docs/CHANGE-LIFECYCLE.md`
4. `docs/DEVELOPMENT.md`
5. `docs/ACCESS.md`
6. `docs/TESTING.md`
7. `docs/OPERATIONS.md`
8. `docs/TROUBLESHOOTING.md`
9. `docs/RELEASE-NOTES.md`

The documentation should read in this order for release operators:

1. `README.md`
2. `docs/OPERATIONS.md`
3. `bin/deploy-staging.md`
4. `docs/CHANGE-LIFECYCLE.md`
5. `docs/TROUBLESHOOTING.md`
6. `docs/ACCESS.md`
7. `docs/RELEASE-NOTES.md`

All recommended core system documentation files in this plan now exist.