# SEAD System Documentation Plan

This document defines the recommended documentation set for the SEAD Change Control System. The aim is to keep the documentation compact, useful in day-to-day work, and aligned with how the repository is actually used.

## Documentation Goals

* Make it clear what this repository controls, and what it does not.
* Make the standard operating path easy to find, especially staging deployment through `bin/deploy-staging`.
* Reduce reliance on informal knowledge among change-request authors, reviewers, and release operators.
* Keep stable reference material separate from workflow guidance and historical review notes.

## Recommended Documentation Set

### Keep and clarify existing docs

#### `README.md`

Keep this as the repository entry point.

Recommended scope:

* What the SEAD Change Control System is.
* The repository’s main projects and deployment model.
* The main workflows: add a change request, deploy to staging, and tag a release.
* A short documentation index linking to the documents below.

This file should stay short and point readers to the more detailed documentation.

#### `bin/deploy-staging.md`

Keep this as the command reference for the central deploy script.

Recommended scope:

* Options and examples.
* Command behavior and supported deployment modes.
* Notes about snapshots, tags, hooks, and logging.

This file should remain the detailed reference for the script itself. It should not become the full operations runbook.

#### `docs/RELEASE-NOTES.md`

Keep this as release history and release checklist material.

Recommended scope:

* Monthly release narrative.
* Notable change requests and project changes.
* Release checklist and release-specific caveats.

### Current system docs

#### `docs/ARCHITECTURE.md`

Purpose: explain how the system is structured.

Recommended sections:

* System purpose and boundaries.
* Why Sqitch is used here.
* Forward-only migration model.
* Project layout and responsibilities.
* Dependency and deployment order from `projects.txt`.
* Key workflow scripts and what each script is responsible for.
* Diagram of the deployment chain and project layers.

Use this document to answer: How is the SEAD Change Control System organized, and why is it organized this way?

#### `docs/OPERATIONS.md`

Purpose: define the standard operator workflow.

Recommended sections:

* Operational principles and safety rules.
* Standard staging deployment flow.
* Release-validation flow.
* When to use `bin/deploy-staging`, and when not to improvise with lower-level commands.
* Log files, outputs, and where to inspect failures.
* Acceptance and smoke-check expectations.
* Recovery guidance for failed staging deployments.

Use this document to answer: What is the normal, approved way to operate this system?

#### `docs/DEVELOPMENT.md`

Purpose: define the contributor workflow for change requests.

Recommended sections:

* Local prerequisites.
* How to choose the right Sqitch project.
* How to create a new change request with `bin/add-change-request`.
* Naming conventions for change requests.
* Issue linkage expectations.
* When to create a corrective change request instead of editing old history.
* Review expectations before merge.

Use this document to answer: How do I make a safe, normal change in this repository?

#### `docs/TESTING.md`

Purpose: describe validation expectations for migrations and releases.

Recommended sections:

* What counts as validation in this repository.
* Deploy validation on staging.
* Expectations for deploy, verify, and revert scripts.
* Smoke tests after deployment.
* Data migration checks.
* Testing gaps and known manual steps.

Use this document to answer: What do I need to run or verify before I can trust a change?

#### `docs/TROUBLESHOOTING.md`

Purpose: provide symptom-driven operational help.

Recommended sections:

* Missing tag in Git or plan.
* Sqitch status or plan drift.
* Verify failures.
* Existing target database conflicts.
* Sequence sync issues.
* Hook failures.
* Partial or interrupted staging deployments.
* How to collect useful logs before escalating.

Use this document to answer: A deployment or change-request workflow failed. What should I check next?

#### `docs/ACCESS.md`

Purpose: document environment setup and access expectations without storing secrets.

Recommended sections:

* Required tools.
* Expected `sqitch.conf` locations.
* How `psql` access is typically configured.
* `.pgpass` and local vault conventions.
* Environment variables expected by scripts.
* Security boundaries for credentials in docs and automation.

Use this document to answer: What local setup do I need before I can work safely with this system?

#### `docs/CHANGE-LIFECYCLE.md`

Purpose: describe how a database change moves through the system.

Recommended sections:

* Issue creation or issue linking.
* Change request creation.
* SQL authoring and review.
* Validation on staging.
* Tagging and release inclusion.
* Release notes update.
* Post-release follow-up and corrective changes.

Use this document to answer: What is the lifecycle from idea to released database change?

## Recommended Ownership of Existing Material

### Move or summarize from `README.md`

Keep brief versions in the README and move detailed workflow material into the deeper documentation.

* Keep the high-level install notes and project summary in `README.md`.
* Keep short examples for `bin/add-change-request`, `bin/deploy-staging`, and `bin/tag-projects` in `README.md`.
* Move extended workflow explanations and operator decision-making into `docs/DEVELOPMENT.md` and `docs/OPERATIONS.md`.

### Reuse `bin/deploy-staging.md`

Do not merge this into the general operations document.

* Keep detailed CLI options in `bin/deploy-staging.md`.
* Reference it from `docs/OPERATIONS.md` as the authoritative command reference.
* Put workflow guidance, guardrails, and failure handling in `docs/OPERATIONS.md`.

### Reuse `docs/project-review-2026-01-20.md`

Treat this as historical analysis, not as operational guidance.

* Use it as a source for architecture notes when refining `docs/ARCHITECTURE.md`.
* Use it as a source for testing gaps when refining `docs/TESTING.md`.
* Use it as a source for documentation and operational recommendations when refining `docs/OPERATIONS.md` and `docs/TROUBLESHOOTING.md`.
* Do not rely on it as the day-to-day source of truth.

### Keep `docs/RELEASE-NOTES.md` release-focused

* Keep release notes, release checklist items, and release caveats here.
* Do not expand it into a general operations manual.

## Suggested Navigation Structure

For new contributors, the documentation should be read in this order:

1. `README.md`
2. `docs/ARCHITECTURE.md`
3. `docs/CHANGE-LIFECYCLE.md`
4. `docs/DEVELOPMENT.md`
5. `docs/ACCESS.md`
6. `docs/TESTING.md`
7. `docs/OPERATIONS.md`
8. `docs/TROUBLESHOOTING.md`
9. `docs/RELEASE-NOTES.md`

For release operators, the documentation should be read in this order:

1. `README.md`
2. `docs/OPERATIONS.md`
3. `bin/deploy-staging.md`
4. `docs/CHANGE-LIFECYCLE.md`
5. `docs/TROUBLESHOOTING.md`
6. `docs/ACCESS.md`
7. `docs/RELEASE-NOTES.md`

All recommended core system documentation files in this plan now exist.
