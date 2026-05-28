# AI Assistant Instructions for SEAD Change Control System

This repository manages forward-only Sqitch changes for the SEAD database across multiple projects. It is a production data system, so repository workflows favor safety, auditability, and small scoped changes over speed.

## Non-Negotiables

- Treat deployed change requests as append-only history. If behavior must change, prefer a new CR instead of rewriting an old deployed CR.
- A tracked database change should have a GitHub issue.
- Prefer `bin/add-change-request` for new CRs instead of manually wiring plan entries and SQL files.
- For staging deployment and release-validation guidance, default to `bin/deploy-staging` as the deployment entry point. Do not replace it with improvised per-project `sqitch` command sequences unless the task is explicitly about lower-level deploy debugging.
- Use staging for validation. Do not automate or suggest direct production deployment.
- Do not commit credentials, `.env` files, or hard-coded connection strings.

## Repository Defaults

- Use `projects.txt` as the source of truth for deployment order.
- Treat `bin/deploy-staging` as the single default entry point for SEAD staging deployment and release validation workflows.
- Treat project `sqitch.plan` files as release history, not scratch files.
- Prefer small, local edits to the owning project, script, or migration.
- Use existing helper scripts in `bin/` before inventing one-off workflows.
- Keep documentation and examples aligned with real commands in the repository.

## Where To Look

- [README.md](../README.md): repository overview and primary workflows.
- [AGENTS.md](../AGENTS.md): concise repo rules and agent-facing guidance.
- [bin/deploy-staging.md](../bin/deploy-staging.md): staging deployment details.
- [docs/RELEASE-NOTES.md](../docs/RELEASE-NOTES.md): release narrative and change history.
- [resources/tables_and_columns.csv](../resources/tables_and_columns.csv): schema reference.

## File-Scoped Guidance

- [shell-tooling.instructions.md](instructions/shell-tooling.instructions.md): shell tooling in `bin/`, project helper scripts, and deploy hooks.
- [operations-docs.instructions.md](instructions/operations-docs.instructions.md): operator-facing docs, troubleshooting docs, access docs, and the `bin/deploy-staging.md` command reference.
- [system-docs.instructions.md](instructions/system-docs.instructions.md): architecture, lifecycle, development, testing, and documentation-plan guides.
- [sqitch-plan.instructions.md](instructions/sqitch-plan.instructions.md): `sqitch.plan` edits.
- [sqitch-cr-sql.instructions.md](instructions/sqitch-cr-sql.instructions.md): deploy, verify, and revert SQL.
- [github-workflow.instructions.md](instructions/github-workflow.instructions.md): issue, CR, and commit workflow.
- [readme.instructions.md](instructions/readme.instructions.md): root README updates.
- [release-notes.instructions.md](instructions/release-notes.instructions.md): release notes and changelog updates.
- [proposal-writing-guide.instructions.md](instructions/proposal-writing-guide.instructions.md): proposal documents.
- [diagrams.instructions.md](instructions/diagrams.instructions.md): Mermaid diagrams.

## Feature Guidance

Use these on-demand guidance files when the task is about a workflow rather than a specific file edit:

- [change-request-workflow.instructions.md](instructions/features/change-request-workflow.instructions.md): choosing a project, naming a CR, and creating a new change request.
- [deployment-release.instructions.md](instructions/features/deployment-release.instructions.md): staging deployment, status checks, release tags, and monthly release workflow.
- [clearinghouse-submission.instructions.md](instructions/features/clearinghouse-submission.instructions.md): `bin/commit-submission` workflow.
- [database-access-and-credentials.instructions.md](instructions/features/database-access-and-credentials.instructions.md): `.pgpass`, `~/vault`, `psql`, and SQL variable safety.

## Practical Routing

- If the task edits SQL under a project, apply the Sqitch CR SQL guidance first.
- If the task edits operator-facing docs such as `docs/OPERATIONS.md`, `docs/TROUBLESHOOTING.md`, `docs/ACCESS.md`, or `bin/deploy-staging.md`, apply the operational docs guidance first.
- If the task edits system guides such as `docs/ARCHITECTURE.md`, `docs/CHANGE-LIFECYCLE.md`, `docs/DEVELOPMENT.md`, `docs/TESTING.md`, or `docs/DOCUMENTATION-PLAN.md`, apply the system docs guidance first.
- If the task changes release history, tags, or database deployment flow, use the Sqitch plan guidance plus the `bin/deploy-staging` deployment or release guidance.
- If the task asks how to deploy, validate a release, or recover a staging deployment, route through `bin/deploy-staging` first and only drop to lower-level commands when the task is specifically about debugging or changing that script.
- If the task starts with `create a CR` or `which project should this go in?`, use the change-request workflow guidance.
- If the task involves database access or credentials, use the database access and credentials guidance and keep secrets out of chat and files.

Last updated: 2026-05-28
