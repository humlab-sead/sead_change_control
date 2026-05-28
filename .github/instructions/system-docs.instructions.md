---
description: "Use when editing system documentation such as docs/ARCHITECTURE.md, docs/CHANGE-LIFECYCLE.md, docs/DEVELOPMENT.md, docs/TESTING.md, or docs/DOCUMENTATION-PLAN.md. Covers repository boundaries, project ownership, change lifecycle, staging-first validation, and documentation structure."
applyTo: "docs/ARCHITECTURE.md,docs/CHANGE-LIFECYCLE.md,docs/DEVELOPMENT.md,docs/TESTING.md,docs/DOCUMENTATION-PLAN.md"
---
# System Documentation Guide

## Purpose

- Keep system docs focused on how SEAD change control is structured, changed, and validated.
- Explain ownership, lifecycle, and validation rules without drifting into full command reference material.
- Keep documentation structure intentional so readers can move from overview to workflow to operations cleanly.

## What belongs in these docs

- Repository boundaries and the role of Sqitch projects.
- Project ownership and deployment order.
- Change-request lifecycle from issue to release validation.
- Contributor workflow, review expectations, and corrective-change rules.
- Testing and validation expectations as they actually work in this repository.
- Documentation structure and reading order when maintaining doc indexes or plans.

## What does not belong in these docs

- Full CLI reference copied from scripts.
- Incident-response detail that belongs in operational docs.
- Release-note narrative that belongs in `docs/RELEASE-NOTES.md`.
- Generic software-process advice that is not specific to SEAD CCS.

## Writing rules

- Explain the repository as a change-control system, not as a generic SQL folder.
- Prefer ownership, dependency, and lifecycle explanations over background history.
- Keep development and testing guidance honest about current repository practice, including manual steps and limits in automation.
- Route operational procedures to `docs/OPERATIONS.md` and command detail to `bin/deploy-staging.md` when those docs own the detail.
- Keep documentation plans and navigation guidance aligned with docs that actually exist.

## Sources to trust

- `projects.txt` for project order.
- `bin/add-change-request` and workflow docs for CR creation flow.
- Project-local `sqitch.plan` files for real change and tag history.
- `docs/OPERATIONS.md` and `bin/deploy-staging.md` for staging validation flow.
- `docs/TESTING.md` for current validation expectations.
- `README.md` for the public entry point into the repo.

## Practical guardrails

- If a system doc mentions validation, prefer staging-first validation over theoretical review-only guidance.
- If a system doc mentions corrective work, prefer a new corrective CR over rewriting deployed history.
- If a documentation-plan edit changes reading order or scope, keep it aligned with the files that actually exist in `docs/`.