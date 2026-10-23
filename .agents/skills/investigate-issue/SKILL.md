---
name: investigate-issue
description: Investigate a software issue, bug, regression, data inconsistency, or incident using a structured investigation brief and an evidence-first, scoped workflow. Use when asked to carry out an investigation brief, establish root cause, reconstruct history, evaluate impact, or recommend safe remediation. Inspect code, tests, logs, repository history, and available data; produce findings.md. Default to diagnosis and recommendations, not production changes or implementing a fix.
---

# Investigate Issue

Investigate the supplied brief or issue as an **evidence-driven diagnosis**. Produce a reproducible findings report, not an unapproved fix. Use [assets/investigation-findings-template.md](assets/investigation-findings-template.md) as the reporting structure; adapt sections to the case.

## Workflow

1. **Read the investigation brief.** Read the brief in full, including scope, constraints, symptoms, examples, hypotheses, requested outputs, and references. A review with `review-investigation-brief` may precede execution but is not a prerequisite. If there is no formal brief, derive a concise working scope from the request without fabricating facts. Honor repository-specific instructions.
2. **Establish a baseline.** Confirm current branch/version, relevant environment, definitions, and available evidence. Distinguish a reported symptom from a reproduced or otherwise verified observation. For regressions, identify earliest defensible good/bad states.
3. **Prioritize targeted checks.** Start with the smallest failing example; inspect referenced code/data and immediate dependencies before broad searches. Choose discriminating tests for competing hypotheses. Keep a short evidence trail as work proceeds.
4. **Reproduce or reconstruct.** Prefer deterministic isolated reproduction. For historical issues, trace Git commits, release/deployment order, data snapshots, logs, and independent records. Check whether different environments or frontends explain discrepancies. Record exact commands, versions, inputs, and outcomes. If reproduction is unavailable, state why.
5. **Evaluate explanations.** Test hypotheses against observations, seek disconfirming evidence, and separate temporal correlation from causality. Note negative results. State the verified mechanism and conditions of failure, or explicitly leave root cause undetermined.
6. **Assess impact.** Identify confirmed affected cases, estimated possible blast radius, and adjacent failure modes; avoid an exhaustive survey unless needed to test the mechanism. Separate verified impact from plausible risks.
7. **Compare safe resolutions.** Document options, tradeoffs, prerequisites, migrations/data compatibility issues, risk to existing users, validation strategy, and rollback considerations. Do not change source or production state without an explicit implementation instruction.
8. **Write the findings.** Create or update a Markdown report according to the bundled template and requested investigation path. Link every important conclusion to concrete evidence. Present blocked or inconclusive results honestly. Finish with prioritized next actions and a concise handoff.

## Evidence discipline

- Assign **Verified**, **Supported hypothesis**, **Unverified**, or **Ruled out** to material claims, and explain the basis; do not substitute confidence adjectives for evidence.
- Cite repository paths with line numbers or commit IDs when available; record commands and artifacts so someone else can repeat the investigation.
- Preserve contrary evidence and distinguish observations in logs/UI from underlying state. If sources conflict, describe what each establishes rather than silently choosing one.
- Compare against **known-good evidence**, not assumptions about what an identifier, version, or result *should* have been.
- Avoid promising that missing historical state can be derived from version control alone. State dependencies such as data state, environment, and nondeterministic behavior.
- Never claim tests passed unless run; record results and any environmental limitations.

## Safety and scope

- **Investigation-only by default.** Reading code, local searches, `git log`/`git show`/diff, read-only log inspection, and non-destructive local tests are allowed when access is available.
- Do not deploy, commit, push, rewrite history, reset data, edit production resources, run destructive migrations, expose credentials, or modify application code without authorization. Database reads must be genuinely safe and compliant with access rules; a `SELECT` invoking a mutating function is not read-only.
- Safe scratch code, temporary isolated fixtures, or diagnostic tests may be used when necessary. Keep investigative changes separate from source changes, document them, and do not leave accidental modifications.
- If risk, missing permissions, or missing evidence blocks a step, stop **that step**, explain the limitation, and pursue other safe evidence. Avoid speculative repairs.
- Follow the brief's requested stopping point. If it requests diagnosis only, hand off a proposed implementation through the separate planning workflow.

## Investigation efficiency

- Inspect likely files and data flows first. Do not perform a repository-wide audit before a specific lead warrants it.
- Prefer simple commands and direct tests over broad speculative tool calls.
- Re-evaluate the hypothesis set when evidence contradicts the initial framing.
- Keep the report useful even if the investigation is incomplete: confirmed facts, tested hypotheses, limitations, and next best checks.

## Completion check

Ensure the report answers, or labels as unresolved:

1. What exactly happened, and what evidence confirms it?
2. Under what conditions, since when, and to which cases?
3. Which mechanism caused it? Which alternatives were tested?
4. What are the safe remedies, their risks, and validation requirements?
5. What remains unknown, and what is the smallest next action to reduce uncertainty?

Default report location: `docs/investigations/<slug>/findings.md`; follow brief/repository conventions instead. End by stating whether the investigation is conclusive, partially conclusive, or blocked. Do not conflate "report completed" with "bug fixed."
