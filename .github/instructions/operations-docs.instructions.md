---
description: "Use when editing operational documentation such as docs/OPERATIONS.md, docs/TROUBLESHOOTING.md, docs/ACCESS.md, or bin/deploy-staging.md. Covers staging-first workflow, deploy-staging routing, troubleshooting shape, credential safety, and separation of command reference from runbook guidance."
applyTo: "docs/OPERATIONS.md,docs/TROUBLESHOOTING.md,docs/ACCESS.md,bin/deploy-staging.md"
---
# Operational Documentation Guide

## Purpose

- Keep operational docs focused on how this repository is run and diagnosed in practice.
- Treat `bin/deploy-staging` as the default and authoritative deployment entry point for staging deployment and release validation.
- Keep operational writing aligned with the repository's staging-first safety model.

## What belongs in these docs

- Standard staging deployment and release-validation workflow.
- When to use `bin/deploy-staging` and when lower-level commands are only appropriate for debugging.
- Credential and access patterns that are safe to document, such as `~/.pgpass`, `~/vault/*`, `sqitch.conf`, and `bin/psql.sh` usage.
- Symptom-driven troubleshooting steps, likely failure points, and the evidence operators should collect.
- Clear separation between command reference, workflow guidance, and incident guidance.

## What does not belong in these docs

- Direct production deployment instructions.
- Embedded secrets, credentials, or real connection strings.
- Generic PostgreSQL tutorials that are not specific to SEAD workflow.
- Repetition of full command help text when a script reference already owns that detail.
- Architecture or lifecycle discussion that belongs in the system guides.

## Writing rules

- Start from the approved workflow path, not from low-level alternatives.
- Prefer concrete commands and operator decision points over broad prose.
- Keep troubleshooting symptom-driven and evidence-first.
- Document safe local credential patterns, not secret values.
- For `bin/deploy-staging.md`, keep the file as a command reference, not a full runbook.
- Reference the owning source instead of copying behavior descriptions from memory.

## Sources to trust

- `bin/deploy-staging` for supported deployment flags and actual behavior.
- `bin/psql.sh` for local access defaults.
- `projects.txt` for deployment order.
- `docs/RELEASE-NOTES.md` for release checklist context and release caveats.
- `docs/OPERATIONS.md` for workflow guidance.
- `docs/TROUBLESHOOTING.md` for diagnostic structure.

## Practical guardrails

- If an operator-facing doc suggests a deployment path, route through `bin/deploy-staging` first unless the content is explicitly about debugging that script.
- If a doc discusses access, explain file locations and setup shape, not secrets.
- If a doc discusses failure handling, prefer reproducible recovery over one-off manual repair.