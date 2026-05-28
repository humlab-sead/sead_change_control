# AI Agent Guidelines for SEAD Change Control System

This file is the short operational companion to [.github/copilot-instructions.md](.github/copilot-instructions.md). It is for autonomous agents and subagents working in this repository.

## Core Rules

- Treat deployed change requests as append-only history.
- Prefer a new corrective CR over rewriting an old deployed CR.
- Use `bin/add-change-request` for new CRs instead of hand-editing plan history.
- Treat `bin/deploy-staging` as the default deployment entry point for SEAD staging and release validation work; do not substitute ad hoc `sqitch` command sequences unless the task is explicitly about lower-level deploy debugging.
- A tracked database change should have a GitHub issue.
- Validate on staging or a suitable test database.
- Do not automate or suggest direct production deployment.
- Do not commit credentials, `.env` files, or hard-coded connection strings.

## Primary Routing

- [.github/copilot-instructions.md](.github/copilot-instructions.md): root repository defaults and guidance index.
- [.github/instructions/operations-docs.instructions.md](.github/instructions/operations-docs.instructions.md): operator-facing docs, troubleshooting docs, access docs, and `bin/deploy-staging.md`.
- [.github/instructions/system-docs.instructions.md](.github/instructions/system-docs.instructions.md): architecture, lifecycle, development, testing, and documentation-plan docs.
- [.github/instructions/sqitch-cr-sql.instructions.md](.github/instructions/sqitch-cr-sql.instructions.md): deploy, verify, and revert SQL.
- [.github/instructions/sqitch-plan.instructions.md](.github/instructions/sqitch-plan.instructions.md): `sqitch.plan` rules.
- [.github/instructions/shell-tooling.instructions.md](.github/instructions/shell-tooling.instructions.md): `bin/` scripts, helper tooling, and hooks.
- [.github/instructions/github-workflow.instructions.md](.github/instructions/github-workflow.instructions.md): issues, CR workflow, and commits.

## Workflow Guides

- [.github/instructions/features/change-request-workflow.instructions.md](.github/instructions/features/change-request-workflow.instructions.md): choosing a project, naming a CR, and standard CR lifecycle.
- [.github/instructions/features/deployment-release.instructions.md](.github/instructions/features/deployment-release.instructions.md): staging deploys, status checks, and release tags.
- [.github/instructions/features/clearinghouse-submission.instructions.md](.github/instructions/features/clearinghouse-submission.instructions.md): `bin/commit-submission` workflow.
- [.github/instructions/features/database-access-and-credentials.instructions.md](.github/instructions/features/database-access-and-credentials.instructions.md): `.pgpass`, `~/vault`, `psql`, and SQL variable safety.

## Agent Expectations

- Work locally and narrowly. Prefer the owning project, script, or migration over broad repo scans.
- Preserve existing workflow scripts and repository conventions unless the task requires changing them.
- When answering deployment or release-validation questions, start from `bin/deploy-staging` and consult its guidance before proposing lower-level alternatives.
- For SQL changes, keep headers, issue linkage, and forward-only migration safety intact.
- For shell changes, prefer small safe edits and verify the touched command path after editing.
- Escalate when the task implies production deployment, destructive data deletion, unclear project boundaries, or cross-project release coordination.

## Subagent Report Format

When returning work as a subagent, use this shape:

```text
TASK: brief description

ACTIONS TAKEN:
1. ...
2. ...

FILES MODIFIED:
- path/to/file

VALIDATION:
- command or check performed

ISSUES OR RISKS:
- blocker, uncertainty, or notable limitation

NEXT STEP:
- optional follow-up if needed
```

Last updated: 2026-05-28
