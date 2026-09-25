# SEAD Change Control Architecture

This document explains how the SEAD Change Control System is organized and why the repository has its current structure.

## Purpose

The SEAD Change Control System manages forward-only database changes for SEAD across several Sqitch projects. It brings schema changes, data updates, release tagging, and staging deployment workflows together in one repository. This makes the database history easier to audit, reproduce, and understand over time.

## System Boundaries

This repository is responsible for:

* Sqitch plan history for each project.
* Deploy, verify, and revert SQL for tracked change requests.
* Workflow scripts in `bin/` for creating change requests, tagging releases, and deploying to staging.
* Release notes and operational guidance.

This repository is not the source of truth for:

* Runtime application behavior outside database change control.
* Secrets or credentials.
* Production deployment automation.

## Core Design Principles

* Database history should normally move forward. If a deployed change needs to be corrected, add a new corrective change request rather than rewriting existing history.
* Projects are separated by domain or responsibility so the scope of each change remains clear.
* Release history is recorded in `sqitch.plan` files and release tags, not in informal notes.
* Staging deployment and release validation should go through `bin/deploy-staging`.

## Project Layers

The deployment order is defined in [projects.txt](../projects.txt). It follows the dependency order between projects:

1. Foundation: `utility`, `sead_model`, `security`
2. Core schema and shared data: `general`
3. Domain projects: `mal`, `archaeobotany`, `dendrochronology`, `adna`, `bugs`, `isotope`, `ceramics`, `radiocarbon`
4. Downstream systems: `subsystem`, `sead_api`, `facet`

This order matters because later projects depend on database objects created by earlier projects.

## Repository Structure

The main parts of the repository are:

* `bin/`: workflow scripts and operational entry points.
* `[project]/sqitch.plan`: append-only change and tag history for each project.
* `[project]/deploy/`: SQL used to apply changes.
* `[project]/verify/`: SQL used to validate changes.
* `[project]/revert/`: SQL used for limited rollback support.
* `docs/`: system and release documentation.
* `projects.txt`: the authoritative deployment order.

## Key Workflows

The main workflow for operators and contributors is:

* Create a change request with `bin/add-change-request`.
* Add or update SQL in the project that owns the change.
* Validate the change on staging.
* Tag releases with `bin/tag-projects`.
* Deploy or check release state with `bin/deploy-staging`.

For deployment and release work, [bin/deploy-staging.md](../bin/deploy-staging.md) is the command reference, while [OPERATIONS.md](OPERATIONS.md) describes the overall workflow.

## Why Multiple Sqitch Projects?

The repository uses several Sqitch projects rather than one large plan because this keeps the change history easier to work with. It allows changes to be grouped by domain, keeps release history readable, clarifies ownership, and makes dependencies visible through the deployment order.

The tradeoff is that operational workflows need to be more carefully coordinated. This is why `projects.txt`, release tags, and `bin/deploy-staging` are central parts of the system.

## Operational Architecture

The deployment model is built around staging validation:

* Release intent is recorded with Sqitch tags.
* A fresh or controlled staging database is prepared.
* `bin/deploy-staging` applies changes in project order.
* Acceptance checks and smoke tests confirm the result before release decisions are made.

The repository deliberately favors repeatable staging deployments over ad hoc direct actions in production.

## Related Documents

* [OPERATIONS.md](OPERATIONS.md): standard operating workflow and deployment guardrails.
* [DEVELOPMENT.md](DEVELOPMENT.md): contributor workflow for new change requests and SQL changes.
* [TESTING.md](TESTING.md): validation expectations and known gaps.
* [DOCUMENTATION-PLAN.md](DOCUMENTATION-PLAN.md): broader documentation structure and planned follow-up documents.
