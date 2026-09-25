---
description: "Use when asked to create a GitHub issue, prepare a commit, or handle the repository's issue plus change-request workflow for Sqitch changes."
---
# GitHub Workflow

- In this repository, a tracked database change should have a GitHub issue. Treat issue linkage as required for new CR work unless the user explicitly says the issue already exists.
- For new Sqitch change requests, prefer `bin/add-change-request --issue-id ...` or `bin/add-change-request --create-issue` instead of manually creating files and then patching plan metadata by hand.
- Do not manually edit `sqitch.plan` just to wire up issue references if the repository scripts can do that safely.
- When creating or documenting an issue for a CR, include the project, change name, purpose, and affected SQL path so the issue and plan comment stay easy to correlate.
- Use the fast path by default: check status once, understand the scoped files, and avoid extra repo scans unless the change is unclear.
- Stage only files relevant to the requested task; never use `git add .`.
- Leave unrelated user changes unstaged and mention them in the handoff.
- Prefer one atomic commit unless the user explicitly asks to split commits.
- Use a concise conventional-style subject when committing, and include the issue reference when it should close or link the work.
- Prefer commit subjects that mention the affected project or workflow when relevant, for example `feat(general): add site lookup CR` or `fix(bin): harden deploy-staging tag validation`.
- Include `Closes #<issue>` or `Fixes #<issue>` in the commit body when the commit is intended to close the related issue.
- For issue creation, keep the body concise and operational: problem, proposed change, and affected files or projects are usually enough.
- If `gh issue create` is needed directly, prefer `--body-file - <<'EOF'` to avoid shell substitution problems.
