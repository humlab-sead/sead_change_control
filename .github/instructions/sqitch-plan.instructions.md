---
description: "Use when editing a Sqitch plan file. Covers plan syntax, issue links, tag placement, append-only history, and safe handling of deployed change requests."
applyTo: "*/sqitch.plan"
---
# Sqitch Plan Guidelines

- Treat `sqitch.plan` as release history, not a scratch file. Make the smallest possible change.
- Prefer `bin/add-change-request`, `bin/mv-cr`, `bin/rm-cr`, and `bin/tag-projects` over hand-editing plans when those workflows fit the task.
- Preserve the header lines exactly: `%syntax-version`, `%project`, and `%uri`.
- Do not reorder historical entries or rewrite timestamps, authors, or issue comments unless the task is specifically to repair plan metadata.
- New change names must follow the repository convention `YYYYMMDD_[DDL|DML|UDF]_DESCRIPTION`.
- Keep issue links in plan comments when a change is tracked by GitHub.
- Release tags must use the existing `@YYYY.MM` format and remain in chronological order.
- Never modify a deployed change in place just to change behavior; prefer a new change request unless the user explicitly asks for plan maintenance.
- If a plan edit affects ordering or dependencies, check the project-local impact only; do not reshuffle unrelated entries.