---
description: "Use when editing Sqitch change-request SQL under deploy/, verify/, or revert/. Covers forward-only migrations, headers, idempotency, verification, and repo-specific migration safety."
applyTo: "*/deploy/**/*.sql,*/verify/**/*.sql,*/revert/**/*.sql"
---
# Sqitch Change SQL Guidelines

- Write SQL for this repository as tracked change requests, not as ad hoc migrations.
- Keep the standard header block with author, date, description, issue URL, and idempotency status.
- Default to forward-only thinking. If a deployed change is wrong, prefer a new corrective CR over rewriting old history.
- Use `BEGIN` and `COMMIT` where PostgreSQL allows it.
- Favor idempotent or guarded DDL/DML when practical, especially for lookup data, constraints, and additive schema changes.
- Avoid `DROP ... CASCADE` as a convenience in mature schema changes unless the task explicitly replaces disposable objects and the impact is understood.
- Preserve scientific data and stable identities. Be cautious with updates or deletes that rely on brittle integer identities.
- Keep deploy scripts focused on the requested schema or data change; do not mix unrelated cleanup into the same CR.
- For `verify/` scripts, assert the intended objects, columns, constraints, or data conditions, then roll back.
- For `revert/` scripts, stay minimal and honest about limitations; do not invent broad rollback support that the repository does not operationally rely on.