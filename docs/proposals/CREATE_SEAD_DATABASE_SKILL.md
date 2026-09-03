A Skill is a small add-on that teaches AI/ML agent how to do a repeatable task or follow a domain-specific workflow. For the SEAD database, the goal would not be to “train” the model on the whole database, but to give it enough structured guidance that it can reliably answer questions, write safe SQL, explain schema relationships, and follow SEAD-specific conventions.

For SEAD, I would design the Skill as a **database-understanding assistant** with three layers:

## 1. Core skill instructions

The `SKILL.md` file would tell AI/ML agent when to use the skill and how to behave.

Example trigger:

> Use this skill when the user asks questions about the SEAD database, its schema, taxonomic/environmental archaeology data model, PostgreSQL structure, Sqitch change management, APIs, data import workflows, quality control, or how to write/explain SQL queries against SEAD.

The instructions would include rules like:

* Prefer explaining SEAD concepts using the actual schema, not generic archaeology/database assumptions.
* Ask clarifying questions when table meaning, chronology, site/sample context, or dataset scope is ambiguous.
* Never invent table names, column names, constraints, or relationships.
* Distinguish between conceptual SEAD entities, physical PostgreSQL tables, API models, and frontend/search concepts.
* When writing SQL, include assumptions and warn when a query needs validation against the live schema.

## 2. Reference files that describe SEAD

This is the most important part. Instead of putting everything into `SKILL.md`, the skill should include modular references, for example:

```text
sead-database/
├── SKILL.md
├── agents/
│   └── openai.yaml
├── references/
│   ├── schema-overview.md
│   ├── table-groups.md
│   ├── core-entities.md
│   ├── relationships.md
│   ├── sql-patterns.md
│   ├── data-import-workflows.md
│   ├── change-management.md
│   ├── api-overview.md
│   └── glossary.md
└── scripts/
    └── optional schema helpers
```

For SEAD, useful reference files might include:

**`schema-overview.md`**
A compact map of the database: major schemas, domains, and table families.

**`core-entities.md`**
Definitions of key SEAD concepts such as sites, samples, datasets, methods, taxa, abundance records, dating, analysis entities, locations, and bibliographic sources.

**`relationships.md`**
The high-value join paths. For example: how a physical sample connects to site, dataset, method, proxy evidence, taxon, chronology, and publication metadata.

**`sql-patterns.md`**
Reusable query templates:

* “Find samples for a site”
* “List datasets by site or region”
* “Get taxa associated with a sample group”
* “Join abundance data to taxonomic metadata”
* “Trace a dataset to import/provenance metadata”
* “Check whether a table is lookup/reference/core data”

**`change-management.md`**
SEAD-specific rules for Sqitch, migration naming, review, release procedures, and safe database changes.

**`glossary.md`**
Domain vocabulary: environmental archaeology terms, SEAD-specific names, abbreviations, and legacy terminology.

## 3. Optional scripts for schema extraction

A very useful pattern is to include scripts that generate reference material from the live PostgreSQL schema.

For example:

```text
scripts/
├── extract_schema.py
├── extract_foreign_keys.py
├── summarize_tables.py
└── validate_sql.py
```

These could produce Markdown files like:

```text
references/generated/
├── tables.md
├── columns.md
├── foreign-keys.md
├── indexes.md
└── enum-or-lookup-values.md
```

The Skill itself should probably **not contain a full database dump**. Instead, it should contain schema metadata, documentation, join maps, and examples. If live access is needed, the Skill should instruct AI/ML agent how to use the relevant connector, API, SQL tool, or uploaded schema export.

## A practical SEAD Skill could support these tasks

Examples of user prompts it should handle well:

> “Which tables do I need to join to get taxa found at a site?”

> “Write a PostgreSQL query that lists samples, sites, datasets, and dating information for a given site.”

> “Explain where bibliographic references are stored and how they connect to datasets.”

> “I want to add a new lookup table. What Sqitch workflow should I follow?”

> “Review this migration script for SEAD conventions.”

> “Explain the difference between physical samples, analysis entities, datasets, and results in SEAD.”

## Suggested first version

I would start with a lean Skill rather than trying to encode everything at once:

```text
sead-database/
├── SKILL.md
├── agents/
│   └── openai.yaml
└── references/
    ├── schema-overview.md
    ├── core-entities.md
    ├── join-patterns.md
    ├── sql-style-guide.md
    ├── change-management.md
    └── glossary.md
```

Then iterate after real use. The first version should help AI/ML agent avoid hallucinating schema details and guide it toward asking the right questions.

## What I would need to build it

The most useful inputs would be:

1. A schema export, preferably from PostgreSQL: tables, columns, primary keys, foreign keys, views, comments, indexes.
2. Existing SEAD documentation, even if fragmented.
3. A few representative SQL queries that SEAD developers already trust.
4. Examples of questions you want the Skill to answer.
5. Rules for whether the Skill should only explain/query, or also help draft migrations and API changes.

A good next step would be to create a **SEAD database skill scaffold** with placeholders for schema references and query patterns, then progressively fill it using your existing SEAD documentation and schema exports.
