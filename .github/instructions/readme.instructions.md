---
description: "Use when editing the root README.md for this repository. Covers project overview, key Sqitch workflows, major folders, and links to the right deeper docs."
applyTo: "README.md"
---
# README Instructions

## Purpose

- Keep `README.md` focused on what the SEAD Change Control System is, how the repository is organized, and which commands a contributor should use first.
- Treat the README as an entry point to Sqitch projects, change-request workflow, and release tooling, not as a full runbook.

## What belongs in `README.md`

- A short explanation of the repository purpose and the forward-only change model.
- A concise list of the main Sqitch projects or project groups.
- The primary workflows contributors actually use, such as adding a CR, tagging a release, and deploying to staging.
- Brief prerequisites like `sqitch`, `psql`, `gh`, and any expected PostgreSQL access setup.
- Links to the most relevant deeper docs that exist in this repository, such as `bin/deploy-staging.md`, `docs/RELEASE-NOTES.md`, and `AGENTS.md`.

## What does not belong in `README.md`

- Long release histories.
- Detailed per-project schema discussion.
- Full operational procedures or incident guidance.
- Repeated command help text copied from scripts when a short example is enough.

## Writing rules

- Prefer concrete command examples over broad prose.
- Keep folder descriptions short and accurate.
- Do not reference documentation files that do not exist.
- Link readers to the specific script or doc that owns the detail instead of reproducing it.
- Keep the README compact enough to scan quickly.

## Sources to trust

- `projects.txt` for project order.
- `bin/` scripts for supported workflows and flags.
- Project-local `sqitch.plan` files for actual change and tag history.
- `docs/RELEASE-NOTES.md` for release-level narrative.
- `AGENTS.md` and `.github/copilot-instructions.md` for repository-specific AI guidance.
