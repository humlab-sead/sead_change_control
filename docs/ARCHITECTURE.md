# SEAD Change Control Architecture

This document describes how the SEAD Change Control System is organized and why the repository is structured the way it is.

## Purpose

The SEAD Change Control System manages forward-only database changes for SEAD across multiple Sqitch projects. It combines schema changes, data changes, release tagging, and staging deployment workflows in one repository so the database history remains auditable and reproducible.

## System Boundaries

This repository is responsible for:

- Sqitch plan history for each project.
- Deploy, verify, and revert SQL for tracked change requests.
- Workflow scripts in `bin/` for creating CRs, tagging releases, and deploying to staging.
- Release notes and operational guidance.

This repository is not the source of truth for:

- Runtime application behavior outside database change control.
- Secrets and credentials.
- Production deployment automation.

## Core Design Principles

- Forward-only history is preferred. If a deployed change needs correction, add a new corrective CR instead of rewriting history.
- Projects are separated by domain or responsibility so change scope stays understandable.
- Release history lives in `sqitch.plan` files and release tags, not in ad hoc notes.
- Staging deployment and release validation are routed through `bin/deploy-staging`.

## Project Layers

Deployment order is defined in [projects.txt](../projects.txt) and reflects dependency order:

1. Foundation: `utility`, `sead_model`, `security`
2. Core schema and shared data: `general`
3. Domain projects: `mal`, `archaeobotany`, `dendrochronology`, `adna`, `bugs`, `isotope`, `ceramics`, `radiocarbon`
4. Downstream systems: `subsystem`, `sead_api`, `facet`

This order matters because later projects assume objects created by earlier ones already exist.

## Repository Structure

The most important repository surfaces are:

- `bin/`: workflow scripts and operational entry points.
- `[project]/sqitch.plan`: append-only change and tag history per project.
- `[project]/deploy/`: forward migration SQL.
- `[project]/verify/`: validation SQL.
- `[project]/revert/`: limited rollback SQL.
- `docs/`: system and release documentation.
- `projects.txt`: authoritative deployment order.

## Key Workflow Surfaces

The main operator and contributor paths are:

- Create a change request with `bin/add-change-request`.
- Author or update SQL in the owning project.
- Validate on staging.
- Tag releases with `bin/tag-projects`.
- Deploy or validate release state with `bin/deploy-staging`.

For deployment and release work, [bin/deploy-staging.md](../bin/deploy-staging.md) is the command reference and [OPERATIONS.md](OPERATIONS.md) is the workflow guide.

## Why Multiple Sqitch Projects

The repository uses multiple projects instead of one large plan so that:

- Changes can be grouped by domain.
- Release history stays readable.
- Ownership boundaries are clearer.
- Dependencies can be expressed in deployment order rather than in one oversized plan.

The tradeoff is that operational workflows need stronger coordination. That is why `projects.txt`, release tags, and `bin/deploy-staging` are central.

## Operational Architecture

The deployment model is centered on staging validation:

- Release intent is recorded through Sqitch tags.
- A fresh or controlled staging database is created.
- `bin/deploy-staging` applies changes in project order.
- Acceptance and smoke checks confirm the result before release decisions are made.

This repository deliberately favors reproducible staging deploys over ad hoc direct production actions.

## Related Documents

- [OPERATIONS.md](OPERATIONS.md): standard operating path and deployment guardrails.
- [DEVELOPMENT.md](DEVELOPMENT.md): contributor workflow for new CRs and SQL changes.
- [TESTING.md](TESTING.md): validation expectations and known gaps.
- [DOCUMENTATION-PLAN.md](DOCUMENTATION-PLAN.md): broader documentation structure and planned follow-on documents.