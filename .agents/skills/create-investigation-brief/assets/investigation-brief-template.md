# Investigation brief: <specific issue or invariant at risk>

> Replace angle-bracket instructions with case-specific details. Remove this note and any inapplicable examples. Explicitly mark genuinely missing information **Unknown — to investigate**.

## Objective

<State the investigation's primary question and desired evidence-backed outcome. Describe what to establish, not a fix to implement.>

**Mode:** Investigation only. Remediation requires separate approval unless explicitly authorized below.

## Issue description

**Observed behavior:** <What has actually been reported or verified? Include a concrete failing example if available.>

**Expected behavior / invariant:** <What should remain true? Cite contractual or domain expectations where possible.>

**Impact:** <Consequences for users, data integrity, reproducibility, operations, or security. Separate observed damage from possible impact.>

**Known evidence and timeline:**

| Observation or artifact | Source / location | Date or version | Status / qualification |
| --- | --- | --- | --- |
| <Specific observation> | <Issue, log, output, record, screenshot, or commit> | <When> | <Verified, reported, disputed, unknown> |

<Call out conflicting evidence or uncertain terminology explicitly.>

## Working hypotheses

<Describe likely mechanisms **as hypotheses**, plus at least one plausible alternative when relevant. Do not present a preferred hypothesis as the root cause.>

- **H1:** <Possible cause and a check that would support or refute it.>
- **H2:** <Alternative explanation and distinguishing evidence.>

## System context

<Brief overview of the system, data flow, or historical process that the investigator must understand.>

**Relevant entry points:** <Repositories, file paths, commands, configuration, services, tables, or deployment scripts; include only useful ones.>

**Environment and baseline:** <Affected versions, deployment history, available reference data, backup/snapshot sources, or known-good state. Mark unknowns.>

## Investigation priorities

### 1. Verify and characterize the discrepancy

- <Compare reported symptom with independent evidence and establish a minimal reproducible case or historical baseline.>
- <Identify earliest known-good and known-bad observations when relevant.>

### 2. Reconstruct or trace the behavior

- <Trace the code, data, dependency, execution order, or historical changes relevant to the symptom.>
- <Record the exact evidence and conditions required to reproduce the anomaly, or explain why reproduction is unavailable.>

### 3. Determine root cause and extent

- <Test competing hypotheses; distinguish correlation from cause.>
- <Assess affected inputs, users, data, environments, and related entities only as justified by evidence.>

### 4. Evaluate remediation and prevention

- <Compare feasible remedies, consequences, risks, and verification requirements.>
- <Propose tests or safeguards that would detect recurrence. Do not implement during an investigation-only phase.>

## Scope and constraints

**In scope:** <Primary questions and artifacts.>

**Secondary scope:** <Related concerns to examine if supported by findings.>

**Out of scope:** <Unrelated systems, exhaustive scans, production changes, or planned architecture work.>

**Permissions / safety:** Read-only production investigation by default; no deployment, destructive commands, data repair, code changes, migration, or history rewriting without explicit approval. Use isolated experiments when safe. Follow repository-specific security/data-access rules.

## Expected deliverables

Produce an evidence-based findings report, normally `docs/investigations/<slug>/findings.md` (adapt to local conventions), containing:

1. Executive summary, status, confidence, and impact.
2. Reproduction or historical reconstruction, including environment/baseline.
3. Findings and evidence ledger (with exact files/lines, commits, logs, records, or queries).
4. Root-cause assessment: confirmed, likely, ruled out, and unresolved hypotheses.
5. Scope/blast-radius analysis and remediation alternatives with risks.
6. Recommended next actions, validation approach, and preventive measures.
7. Evidence gaps, blockers, and questions requiring external records or decisions.

## Completion criteria

- <Primary discrepancies are accounted for with evidence, or evidence gaps and next verification steps are explicit.>
- <Findings are reproducible or traceable to concrete artifacts.>
- <Remediation options and risks are documented without making unapproved changes.>

## References

- <Original report / issue and comments>
- <Relevant documentation, repository paths, snapshots, or external records>
