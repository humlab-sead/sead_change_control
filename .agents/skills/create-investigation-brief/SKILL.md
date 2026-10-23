---
name: create-investigation-brief
description: Turn a rough bug report, incident, anomaly, GitHub issue, logs, or user notes into a self-contained, evidence-driven software investigation brief. Use when asked to create or structure an investigation brief for an AI coding agent from an issue or rough notes before diagnosis or remediation. For an independent critique of an existing brief, use review-investigation-brief instead. Produce a Markdown investigation brief using the bundled template; do not execute the investigation or implement a fix unless separately requested.
---

# Create Investigation Brief

Convert unstructured reports into an executable **investigation contract**, not an implementation plan. Use [assets/investigation-brief-template.md](assets/investigation-brief-template.md) as the output structure.

## Core principles

- **Separate observations, hypotheses, and unknowns.** Distinguish reported from independently verified facts; never present a suspected cause as established.
- **Ground claims in evidence.** Cite accessible issues, logs, files, commits, and dated records; flag missing or conflicting evidence rather than inventing details.
- **Make the investigation actionable.** Define clear questions, prioritized checks, evidence needed to answer them, and concrete findings/deliverables.
- **Constrain the scope.** Start with the smallest informative case; expand only when relevant evidence or dependencies justify it.
- **Keep creation separate from execution.** Prepare or revise the brief only; do not run the investigation, implement fixes, or modify code, databases, infrastructure, or other operational resources.
- **Preserve safety boundaries.** State investigation-only defaults and explicit approval gates for risky actions in the resulting brief.

These requirements apply **without needing to be repeated in the user's prompt**.

## Workflow

1. **Collect context selectively.** Read user notes, linked issues and comments, supplied evidence, and the few repository files needed to describe the system. When links or sources are inaccessible, record that limitation; never imply they were read. Prefer targeted inspection over repository surveys.
2. **Separate epistemic categories.** Distinguish (a) observed behavior, (b) expected behavior or invariant, (c) evidence and its date/source, (d) hypotheses, and (e) unknowns. Phrase proposed causes as unconfirmed until supported by evidence. Retain contradictory observations.
3. **Define the outcome.** State what the investigation should establish, why it matters, and how success will be assessed. Prefer questions and evidence requirements over predetermined solutions.
4. **Scope the work.** Set prioritized investigation stages: verify the symptom and baseline; reproduce or reconstruct; trace cause and timing; assess blast radius; evaluate remedies. Tailor these stages to the report. Specify in-scope, secondary, and out-of-scope work.
5. **Constrain risky investigation activity in the brief.** Specify the default investigation-only scope: no production mutation, destructive commands, deployments, commits, pushes, migrations, or implementation of fixes without explicit authorization. The future investigator may use read-only inspection and safe isolated experiments within the permissions and constraints documented in the brief. Do not perform these experiments while creating the brief.
6. **Define handoff.** Require a findings report with traceable evidence (paths/lines, commits, queries, logs, issue references), verified facts vs hypotheses, uncertainty, impact, remediation alternatives, and open questions. Explicitly forbid an unsupported claim of root cause.
7. **Write and self-check.** Create a standalone Markdown brief based on the template. Remove instructional placeholder text. Mark essential missing details `Unknown — to investigate` rather than inventing them. Check that another agent can start from the brief without this chat.

## Authoring rules

- **Be neutral about cause.** Do not convert the reporter's explanation into fact or bias the plan toward confirming it.
- **Make checks testable.** Specify concrete artifacts, reproductions, comparisons, or identity mappings when relevant; avoid vague directives like "investigate thoroughly."
- **Prioritize the smallest useful scope.** Focus on a representative failing case before generalizing; widen only when dependencies or evidence justify it.
- **Include temporal evidence.** For regressions or historical inconsistencies, ask for earliest known good/bad states and independently dated sources.
- **Respect existing conventions.** Follow any repository investigation directory or naming convention; otherwise suggest `docs/investigations/<slug>/brief.md`. Do not edit unrelated documents or publish issues without request.
- **Do not stall on optional details.** Use explicitly labelled unknowns and assumptions. Ask a question only if the brief cannot be meaningfully formulated without the answer.
- **Avoid duplication.** Summarize technical background needed for execution; link to canonical code/docs rather than restating extensive documentation.
- **Keep the brief implementation-free by default.** If the user explicitly mentions a future fix, distinguish the diagnostic phase and document a separately authorized remediation phase with validation and rollback planning; do not carry it out as part of this skill.

## Output quality check

Before delivery, verify that the document states:

- What went wrong, what should have happened, and why it matters.
- What is observed vs suspected, with source references and discrepancies.
- What to inspect first, what to postpone, and which alternate explanations to consider.
- Which activities require permission and what is explicitly out of scope.
- What concrete report/artifacts prove the investigation was carried out, including how uncertainty is reported.

Return the brief file path and a short summary of scope and unresolved inputs. Suggest `review-investigation-brief` for an independent critical review, especially when the issue is complex or high-impact. Do **not** execute the investigation as part of this skill; hand it off to `investigate-issue` when requested.
