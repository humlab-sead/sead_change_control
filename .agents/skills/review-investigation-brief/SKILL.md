---
name: review-investigation-brief
description: Critically review an existing software investigation brief (brief.md) for evidence quality, unsupported assumptions, scope, feasibility, investigative priorities, constraints, and actionable deliverables. Use when asked to review, assess readiness, or critique a draft investigation specification before an AI coding agent investigates an issue. Return prioritized, section-specific review findings without investigating the issue or rewriting the brief by default.
---

# Review Investigation Brief

Act as an **independent, skeptical reviewer** of an existing investigation brief. Improve its fitness for an evidence-driven investigation, not its persuasiveness or prose alone. Review `docs/investigations/<slug>/brief.md` (or the user-specified brief) in full.

## Workflow

1. **Read the brief and context.** Read referenced issue descriptions, user-supplied observations, and directly relevant documentation when available. Check claims selectively against primary evidence; do not run the investigation or exhaustively survey the repository. Mark inaccessible sources as unverified.
2. **Assess the issue definition.** Verify that observed vs expected behavior, affected examples, potential impact, and time/version information are intelligible. Distinguish reports from verified facts; preserve contrary evidence.
3. **Challenge causal framing.** Look for assumed root causes, circular reasoning, solution-first instructions, ignored alternatives, and historical claims stronger than the sources justify. Prefer discriminating checks over confirmation of a favored hypothesis.
4. **Evaluate the investigation plan.** Ask whether the first steps can establish a baseline or reproduce/reconstruct the symptom; whether subsequent steps are targeted, ordered by value, technically feasible, and proportionate to severity; and whether required data, access, or snapshots are identified.
5. **Test scope and handoff.** Evaluate in/out-of-scope boundaries, escalation conditions, safety permissions, clear stopping criteria, and concrete findings/report outputs. Ensure diagnosis does not silently authorize code changes, database updates, or deployment.
6. **Prioritize feedback.** Report only actionable issues, anchored to specific sections or statements, and explain why they matter. Suggest precise changes or replacement wording when helpful. Do not invent missing facts.
7. **Give a readiness assessment.** Declare `Ready`, `Ready with minor revisions`, or `Needs revision`, with concise justification and the minimum changes needed to proceed safely and productively.

## Review dimensions

- **Objective:** A verifiable question and outcome, not an instruction to prove a predetermined theory or implement a fix.
- **Evidence:** Distinction between observed, reported, inferred, and unknown; dated, traceable sources; contradictory records retained.
- **Hypotheses:** Plausible alternatives and checks that can distinguish them; no presumption that chronology implies causation.
- **Feasibility:** Available files, history, logs, snapshots, environments, tooling, access and realistic limits of reconstruction.
- **Scope:** A narrow first pass, rational expansion triggers, explicit exclusions, appropriate prioritization.
- **Safety:** Investigation-only default; clear approval gates for production access, destructive/irreversible actions, code changes and implementation.
- **Deliverables:** An evidence ledger or equivalent, confirmed vs possible impact, uncertainty, remediation options, verification record, and handoff criteria.

## Response format

### Assessment

**Readiness:** Ready | Ready with minor revisions | Needs revision

**Summary:** One or two sentences about whether another agent could execute the brief effectively.

### Findings

Order by severity. For each finding provide:

- **Severity:** `Blocking` (cannot start safely/meaningfully), `Important` (may misdirect or significantly waste effort), or `Minor` (clarity/efficiency).
- **Location:** Heading, quote, or line/section of the brief.
- **Concern:** Concrete failure mode, unsupported inference, ambiguity, or omission.
- **Suggested change:** Specific, minimal revision or example text. If data is unavailable, say what should remain explicitly unknown.

Omit empty severity categories. Do not inflate an otherwise usable brief with stylistic comments.

### Next step

Give the smallest set of necessary revisions; explicitly say when no material changes are needed. Optionally highlight strengths only where they inform readiness.

## Boundaries

- **Review-only by default:** Do not change `brief.md`, create `findings.md`, run diagnostics, propose a code patch, or perform remediation. If the user explicitly requests revisions, edit only the brief, preserve intent and evidence, and summarize changes.
- Separate **missing inputs that prevent investigation** from **unknowns the investigation is meant to resolve**. Do not demand answers that belong in `findings.md`.
- Do not require every possible hypothesis, reproduction, checklist item, or section when a lean brief would suffice.
- Cite source paths/issues/commits when checked; disclose when review is based on the brief alone. Never claim to have verified inaccessible evidence.
- Follow repository conventions for document paths and instructions. Do not create a persistent `review.md` unless explicitly requested; the review ordinarily lives in the agent conversation.

## Completion check

Before returning, ensure each substantive suggestion improves evidence quality, bias control, scope, feasibility, safety, or output clarity. Confirm that the readiness decision matches the reported findings.
