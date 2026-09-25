---
description: "Use only for database access and credential questions: connecting with psql or bin/psql.sh, configuring .pgpass or ~/vault files, setting SQITCH or PG connection variables, or safely passing SQL variables with psql."
---
# Database Access And Credentials

- Keep secrets out of repository files, chat responses, and shell history when possible.
- Prefer `~/.pgpass` and repository-adjacent local vault files over hard-coded credentials.
- Use repository scripts such as `bin/psql.sh` when they match the task.

## Preferred Credential Sources

- `~/.pgpass` with `0600` permissions.
- `~/vault/.default.sead.server`
- `~/vault/.default.sead.username`
- `~/vault/.sqitch.env`

## Safe Practices

- Do not commit `.env` files or embed connection strings in scripts.
- Avoid `PGPASSWORD` in process arguments or exported session state when safer alternatives exist.
- For SQL variable passing, prefer `psql -v` over string concatenation.
- Validate user-supplied identifiers before interpolating them into generated SQL or shell commands.

## Common Access Commands

```bash
bin/psql.sh
psql -h server -p 5433 -U user -d sead_staging
```
