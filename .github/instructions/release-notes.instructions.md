---
description: "Use when editing release notes or changelog entries for this repository. Covers monthly release framing, CR references, issue links, and grouping by change type or project."
applyTo: "docs/RELEASE-NOTES.md,CHANGELOG.md"
---
# Release Notes Guidelines

- Write release notes for operators and contributors who need to understand what changed and why it matters.
- Group changes by meaningful buckets such as schema, data, tooling, release workflow, or project area.
- Prefer concrete references: change request names, release tags, issue numbers, affected projects, and notable scripts.
- Distinguish user-visible data or schema changes from repository housekeeping.
- Note moved, deprecated, or superseded CRs when that context matters for deployment or troubleshooting.
- Keep the narrative factual. Do not speculate about impact that was not verified.
- Summarize operationally relevant caveats, warnings, and migration constraints when they affect staging or release workflows.