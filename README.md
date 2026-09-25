# SEAD Change Control System

Sensible SEAD change control system (CCS) using [Sqitch](https://sqitch.org/). Issues for data and lookup data here.

## Documentation

Start with these repository guides:

- [docs/DOCUMENTATION-PLAN.md](docs/DOCUMENTATION-PLAN.md): documentation structure and rollout plan.
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md): system structure, project layering, and repository boundaries.
- [docs/CHANGE-LIFECYCLE.md](docs/CHANGE-LIFECYCLE.md): the path from issue creation through staging validation and release inclusion.
- [docs/ACCESS.md](docs/ACCESS.md): local access patterns, credential handling, and `sqitch.conf` expectations.
- [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md): contributor workflow for creating and validating CRs.
- [docs/OPERATIONS.md](docs/OPERATIONS.md): standard staging deployment and release-validation workflow.
- [docs/TESTING.md](docs/TESTING.md): validation expectations and known testing gaps.
- [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md): deployment and validation failure diagnosis.
- [bin/deploy-staging.md](bin/deploy-staging.md): detailed command reference for the central deploy script.
- [docs/RELEASE-NOTES.md](docs/RELEASE-NOTES.md): release history, checklist material, and release caveats.
- [AGENTS.md](AGENTS.md): repository-specific guidance for AI agents and automation.

## Prerequisites

Most contributors will need:

- `sqitch`
- `psql`
- `gh`
- PostgreSQL access suitable for staging validation
- A working `sqitch.conf`

Typical `sqitch.conf` locations:

- `./sqitch.conf`
- `~/.sqitch/sqitch.conf`
- `$(sqitch --etc-path)/sqitch.conf`

See [docs/ACCESS.md](docs/ACCESS.md) for preferred local credential sources and `bin/psql.sh` usage.

## Projects

Deployment order is defined in [projects.txt](projects.txt):

1. `utility`, `sead_model`, `security`
2. `general`
3. `mal`, `archaeobotany`, `dendrochronology`, `adna`, `bugs`, `isotope`, `ceramics`, `radiocarbon`
4. `subsystem`, `sead_api`, `facet`

Choose the owning project before creating a CR. See [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) for project-selection guidance.

## Common Workflows

### Create a change request

Use `bin/add-change-request` instead of hand-editing plan entries and SQL stubs.

```bash
bin/add-change-request \
  --project general \
  --change 20260528_DDL_EXAMPLE_CHANGE \
  --note "Describe the database change" \
  --create-issue
```

Use the naming convention `YYYYMMDD_[DDL|DML]_ENTITY_DESCRIPTION`.

Use `DDL` for function changes as well; do not introduce a separate `UDF` type in new CR names.

See [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) for the contributor workflow.

### Deploy to staging

Use `bin/deploy-staging` as the standard deployment entry point for staging and release validation.

```bash
./bin/deploy-staging \
  --create-database \
  --source-type empty \
  --target-db-name sead_staging_test \
  --deploy-to-tag latest
```

See [docs/OPERATIONS.md](docs/OPERATIONS.md) for the workflow and [bin/deploy-staging.md](bin/deploy-staging.md) for full command reference.

### Tag a release

```bash
bin/tag-projects --tag "@2026.05" --note "May 2026 release"
```

See [docs/RELEASE-NOTES.md](docs/RELEASE-NOTES.md) for release-facing checklist material.

## Repository Notes

- Treat deployed change requests as append-only history.
- Prefer a new corrective CR over rewriting deployed history.
- Route staging deployment and release validation through `bin/deploy-staging`.
- Keep detailed operational steps in [docs/OPERATIONS.md](docs/OPERATIONS.md), not in the README.
