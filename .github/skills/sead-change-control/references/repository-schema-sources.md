# Repository Schema Sources

This repository keeps both checked-in model exports and live-schema snapshots.

## Current Source Of Truth

- [table-schema-detailed.csv](./table-schema-detailed.csv): current source-of-truth column-level schema export from the live database
- [table-schema-summary.csv](./table-schema-summary.csv): current source-of-truth table-level schema export from the live database

Treat these as the primary current schema references when they have been regenerated from the live database.

## Checked-In Model Exports

- `sead_model/deploy/SEAD_DATABASE_MODEL/tables.sql`: base table definitions
- `sead_model/deploy/SEAD_DATABASE_MODEL/foreignkeys.sql`: checked-in relationship definitions
- `sead_model/deploy/SEAD_MODEL_COMMENTS/comments.sql`: checked-in table and column comments

Use these when you need the repository's model history, compare live schema to checked-in structure, or inspect model-export intent.

## Refresh Helpers

- [extract-live-schema.sql](./extract-live-schema.sql): regenerate `table-schema-detailed.csv`
- [extract-live-schema-summary.sql](./extract-live-schema-summary.sql): regenerate `table-schema-summary.csv`
- [inspect-model.sh](../scripts/inspect-model.sh): inspect checked-in model exports quickly

## Practical Use

- For exact current table or column facts, start with the live CSV exports.
- For join verification against checked-in repository structure, use `foreignkeys.sql` and the model exports.
- For conceptual explanation of the SEAD model, use the base `sead-database` skill.