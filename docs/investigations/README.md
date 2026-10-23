# Investigations

Use investigations to establish **what happened, why, and what to do next** before authorizing implementation. An issue need not be a confirmed defect.

## Workflow

1. **Create a brief:** Use `create-investigation-brief` to turn an issue, logs, observations, or rough notes into `brief.md` with an objective, evidence, competing hypotheses, scoped priorities, constraints, and expected findings.
2. **Review the brief:** Use `review-investigation-brief` to challenge unsupported assertions, causal assumptions, missing evidence, feasibility, scope, safety, and vague deliverables. The reviewer reports `Ready`, `Ready with minor revisions`, or `Needs revision`. Revise the brief when needed; review again for material changes. For trivial issues this step can be skipped.
3. **Investigate:** Use `investigate-issue` with the reviewed brief. Record verified evidence, tested hypotheses, uncertainties, impact, and remediation options in `findings.md`.
4. **Decide:** Close the issue, investigate further, or initiate a separately authorized proposal or implementation task. **Investigation does not imply permission to fix.**

## Example: SEAD site identity mismatch

The input can be rough. For example, ask the coding agent:

> `/create-investigation-brief` Create `docs/investigations/site-identity-mismatch/brief.md` using [SEAD issue #438](https://github.com/humlab-sead/sead_change_control/issues/438) and its comments.
>
> A site's ID was reported to change from `2278` to `4412`, but an August 2025 export already contained `4412`. Persistent IDs matter for reproducibility and published references. I suspect the ordering/removal of Sqitch change requests or PostgreSQL sequence-generated IDs, but **this is unconfirmed**.
>
> Focus first on determining historical site identity assignments for committed submission CRs (`*_COMMIT`). Relevant starting points: `projects.txt`, `bin/deploy-staging`, `sqitch.plan`, and Git history. Other entity types are secondary.

Then ask for an **independent critical review**:

> Use `review-investigation-brief` to review `docs/investigations/site-identity-mismatch/brief.md`. Look for unsupported claims, contradictory evidence, ambiguous objectives, untestable hypotheses, excessive scope, unavailable historical evidence, and vague findings. Give prioritized comments and a readiness assessment. Do not edit the brief or begin the investigation.

To incorporate feedback, explicitly instruct the agent to update `brief.md` with the accepted revisions. Review again when significant assumptions or scope changed, then invoke `investigate-issue`.

A useful brief makes these answers clear: **What must be established? Which observations are verified or only reported? What alternative causes will be tested? What is out of scope? What evidence and findings are required?** Unknown historical facts may remain questions for the investigation rather than blockers to drafting the brief.

## Document naming

```text
docs/investigations/
├── README.md
└── <issue-slug>/
    ├── brief.md
    └── findings.md
```

Choose a short lowercase hyphenated slug (for example, `site-identity-mismatch`). Reviews normally stay in the agent conversation; do not create a mandatory `review.md`. Keep subsequent resolutions in the appropriate proposal or implementation workflow.
