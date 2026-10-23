# Investigation skills

Three complementary AI coding-agent skills for evidence-driven investigation **before** implementation:

```text
Issue, observations, logs, reports
              |
              v
 create-investigation-brief
              |
              v
 docs/investigations/<slug>/brief.md
              |
              v
 review-investigation-brief  <--- optional revise-and-review loop
              |
              v
       investigate-issue
              |
              v
 docs/investigations/<slug>/findings.md
              |
              v
Decision: close / investigate further / propose or plan a fix
```

## Responsibilities

| Skill | Purpose | Artifact |
| --- | --- | --- |
| `create-investigation-brief` | Turn rough observations and sources into a neutral, scoped, actionable investigation brief. | `brief.md` |
| `review-investigation-brief` | Independently challenge evidence, hypotheses, scope, feasibility, safety and deliverables; provide prioritized feedback and readiness assessment. | Review in conversation (no required `review.md`) |
| `investigate-issue` | Execute the evidence-driven investigation, test competing hypotheses and document results and remediation options. | `findings.md` |

Skills are independent. For a simple issue, a formal review may be unnecessary; for complex, high-impact, or high-uncertainty issues, review the brief before execution.

## Terminology and naming

- **Issue:** the report or concern (not necessarily a confirmed defect).
- **Investigation brief:** objective, observations, evidence, hypotheses, scope, constraints, and expected deliverables.
- **Investigation:** diagnostic activity, not authorization to implement a fix.
- **Findings:** verified observations, hypothesis assessments, limitations and next steps.
- **Resolution:** a separate implementation/decision process when warranted.

Default location: `docs/investigations/<short-hyphenated-issue-slug>/{brief.md,findings.md}`. Follow existing repository conventions when they differ.

## Example prompts

**Create:**

> Use `create-investigation-brief` to create `docs/investigations/site-identity-mismatch/brief.md` from GitHub issue #438 and its comments. Focus first on site identities introduced by committed submissions; Sqitch change ordering is a suspected cause.

**Review:**

> Use `review-investigation-brief` to critically review `docs/investigations/site-identity-mismatch/brief.md`. Challenge unsupported assumptions, contradictory evidence, feasibility, investigation scope, priorities and deliverables. Report prioritized changes and readiness; do not modify the brief.

**Revise (explicit permission):**

> Apply the accepted review findings to `brief.md` without starting the investigation.

**Investigate:**

> Use `investigate-issue` with `docs/investigations/site-identity-mismatch/brief.md`. Write `findings.md`, citing concrete evidence. Stop before implementing repairs.

## Installation

Place these three skill directories under `.github/skills/` at the repository root. Each folder contains its own `SKILL.md` and agent metadata; the create/investigate skills also bundle a Markdown output template in `assets/`. See `docs/investigations/README.md` for the authoring workflow and usage example.

To upload to ChatGPT's Skills library, package each skill folder separately. The repository ZIP containing all three skills is not a single importable skill.
