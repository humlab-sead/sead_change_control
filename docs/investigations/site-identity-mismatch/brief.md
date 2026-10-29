# Investigation brief: historical SEAD site identity mismatches

## Objective

Establish whether SEAD sites have received different persistent `site_id` values across database versions or applications, when and why any changes occurred, and which historical assignments can be substantiated. Prioritize reconstructing identity assignments for sites inserted by committed Sqitch submission change requests (CRs), particularly changes ending in `_COMMIT`.

The outcome is an evidence-backed account of the discrepancy, its extent, and safe remediation options -- **not** an immediate renumbering of records.

**Mode:** Investigation only. No implementation or database repair is authorized by this brief.

## Issue description

**Observed / reported behavior:** [Issue #438](https://github.com/humlab-sead/sead_change_control/issues/438) reports that a site shown with ID `2278` in a 2025 screenshot is accessible at `https://super.sead.se/site/4412`. A commenter identifies the site as *Glanllynnau*. This is a reported correspondence, not yet an independently verified database identity change.

**Expected behavior / invariant:** A persistent site identifier should continue to identify the same site across relevant versions and interfaces. Previously published links and citations should remain resolvable or have an explicit compatibility mechanism. The intended authority for historical IDs remains to be established.

**Impact:** If confirmed, changed or unresolvable IDs threaten reproducibility and links in publications or presentations. The actual number of affected sites, the number of published references, and any identifier reuse are **unknown -- to investigate**.

### Known evidence and timeline

| Observation or artifact | Source / location | Date or version | Status / qualification |
| --- | --- | --- | --- |
| A screenshot reportedly associates one site with `2278`, while its SuperSEAD link uses `4412` | [Issue #438](https://github.com/humlab-sead/sead_change_control/issues/438) | Screenshot described as 2025; exact date unknown | Reporter claim; image and underlying source records not independently verified in this brief |
| An export reportedly lists Glanllynnau as `site_id = 4412` and shows no differences from the then-current data | [Issue comment and linked export](https://github.com/humlab-sead/sead_change_control/issues/438#issuecomment-5127857143) | Export dated **2025-08-28** | Commenter report; linked spreadsheet contents not inspected |
| Earlier SEAD-versus-SuperSEAD ID differences reportedly existed and may have been corrected | [Issue comment](https://github.com/humlab-sead/sead_change_control/issues/438#issuecomment-5127857186) | Exact dates unknown | Retrospective recollection, not confirmed |
| Spot checks reportedly found matching IDs across SEAD and SuperSEAD, but a large `site_id` gap and no current record with ID `2278` | [Issue comment](https://github.com/humlab-sead/sead_change_control/issues/438#issuecomment-5127857222) | Date/version of checks not independently established | Limited spot checks; not proof of database history |
| Historical backups may exist; published references may use different generations of IDs | [Issue discussion](https://github.com/humlab-sead/sead_change_control/issues/438#issuecomment-5127857278) | Unknown | Potential evidence and risk, not verified |

**Important ambiguity:** The issue does not yet establish that the *same database record* was assigned a different ID. A difference in application mapping, snapshots, datasets, or cross-system synchronization could produce a similar symptom. The August 2025 export limits what can be inferred from the undated screenshot. Sequence gaps alone do not prove reassignment.

## Working hypotheses

Treat all proposed causes as unconfirmed. Seek evidence that distinguishes them, rather than looking only for support.

- **H1 -- Changed Sqitch execution history:** Reordered, removed, edited, or differently interleaved CRs caused sequence-backed inserts to receive different IDs on rebuilt databases. Compare relevant Git revisions, actual execution order, and reproducible site mappings.
- **H2 -- Different starting or sequence states:** Even nominally empty-database rebuilds can produce different allocations if sequence operations, explicit IDs, failed inserts, or other insertions differ. The deployment tool also permits dump/database starting points; examine those modes if deployment records indicate they were used. Compare actual initial state, sequence behavior, and deployment records, not just `sqitch.plan` ordering.
- **H3 -- Cross-application/version discrepancy:** SEAD and SuperSEAD, or historical interface/data releases, used different databases or site mappings. Compare site natural identifiers, database snapshots, application routes, and archival exports.
- **H4 -- Another data transformation:** Later import/migration logic or manual corrections changed IDs or mappings outside the suspected submission CRs. Look for targeted evidence only if H1-H3 do not explain the example.

## System context

SEAD maintains schema and data through multiple Sqitch projects. The current [`projects.txt`](https://github.com/humlab-sead/sead_change_control/blob/main/projects.txt) defines a project ordering; each project's `sqitch.plan` controls its planned changes. The current [`bin/deploy-staging`](https://github.com/humlab-sead/sead_change_control/blob/main/bin/deploy-staging) supports deployment to tags and deployment chains.

**Typical staging rebuild (user-provided practice):** The normal workflow creates the staging database from an empty starting point and deploys to a chosen release tag:

```bash
# Reference command only: DO NOT EXECUTE as part of this investigation.
# --on-conflict drop may destroy an existing database.
./bin/deploy-staging --create-database --source-type empty \
  --target-db-name sead_staging --deploy-to-tag @YYYY.MM \
  --on-conflict drop --port <port> --ignore-git-tags
```

Treat **empty-database, tag-targeted rebuilds as the primary deployment scenario**. The script also supports alternative starting-point modes (`db`, `dump`) and sequence synchronization; consider those where historical records indicate their use. The `--ignore-git-tags` option bypasses the Git tag-existence check, so a Sqitch release tag alone cannot establish which Git revision was deployed.

The user's description gives the following intended high-level traversal; verify it against the relevant historical script versions before treating it as the actual execution order:

```text
for each deploy tag T:
    for each project P in projects.txt:
        deploy pending changes for P up to T
```

The reported working practice is forward-only deployment, with CR removal sometimes performed by editing `sqitch.plan` instead of using Sqitch reverts. This practice is **user-supplied context**, not yet verified for any particular historical build.

**Relevant entry points:** `projects.txt`, `bin/deploy-staging`, helper scripts invoked by deployment, project-specific `sqitch.plan` files, submission CRs ending in `_COMMIT` (e.g. `mal/deploy/20100101_DML_SUBMISSION_MAL_000_COMMIT`), and Git history. Investigate actual filename extensions and dependencies rather than assuming them.

**Historical baseline:** Which SEAD build, reference database, snapshot, or external publication defines the authoritative assignment is **unknown -- to investigate**. Availability of backups, archival screenshots, exports, deployment logs, and corresponding Git revisions is also unknown.

## Investigation priorities

### 1. Verify the example and establish a timeline

- Resolve the reported `2278` / `4412` example using stable site attributes beyond the numeric ID (such as site name, coordinates, and source provenance). Determine whether the two IDs ever represented the same logical site, or whether one belongs to a different system/version.
- Date the 2025 screenshot as precisely as possible. Inspect the 2025-08-28 export and identify the database/application version behind each artifact, if accessible.
- Find the earliest independently supported `2278` and `4412` assignments and identify the earliest confirmed divergence. Check whether `2278` is absent, reused, or redirected in the relevant snapshots.
- If the reported pair cannot be confirmed, document the evidence gap and investigate interface/version mappings as an alternative explanation. **Continue a bounded reconstruction of committed-submission site IDs** rather than making that work contingent on validating this one example.

### 2. Reconstruct relevant committed submission allocations

**Primary technical priority, independent of whether the `2278` / `4412` correspondence can be confirmed.** Start with CRs that inserted the example site if identifiable; otherwise select the smallest representative set of `_COMMIT` CRs that insert sites. Expand only when dependencies or evidence justify it.

- Identify relevant `_COMMIT` CRs and all site insertions or ID assignments they depend on. Distinguish explicit IDs from PostgreSQL sequence-generated IDs.
- Reconstruct effective deployment order using the appropriate historical versions of `projects.txt`, `sqitch.plan`, deployment scripts, tags, and relevant Git commits. For each historical/reconstructed build, record the **exact Git revision, starting database state, Sqitch target tag, deployment command and options (including `--ignore-git-tags`), and relevant initial/final sequence state**. Record changes that could alter ordering or inclusion.
- Account for initial database contents and sequence values, failed or rolled-back inserts, explicit key assignments, `setval`/sequence resets, and inserts outside the selected CRs where they affect the same sequence.
- Where safe and authorized, compare historical snapshots/exports with reconstructed mappings; use isolated test databases for experiments only if necessary and allowed. Git plans alone do not prove the IDs produced by a particular historical deployment.
- Produce an evidence-linked table of submission/CR, site identity or stable matching attributes, earlier ID, later ID, time/version, and confidence. Do not infer a complete mapping from a small sample.

### 3. Determine mechanism, timing, and extent

- Test H1-H4 against the collected data. Identify the minimum change(s) and conditions necessary to explain confirmed divergences; distinguish a correlation in Git history from a causal explanation.
- Determine how many sites and releases are demonstrably affected, whether IDs were reused, and whether existing external references use either ID generation.
- Check other sequence-backed entity classes (including taxa) only if the identified mechanism warrants expansion; describe broader risk without claiming unverified impact.

### 4. Evaluate remediation and prevention

- Compare possible responses: restoring historical IDs, preserving current IDs with historical aliases/redirects, or another migration/compatibility strategy. Identify evidence needed to choose an authoritative mapping, and risks for foreign keys, dependent records, published URLs, and newer references.
- Recommend tests/checks to detect unexpected identity drift between deployments and safeguards for future submissions.
- Treat the planned SEAD Identity Management System as a future architectural direction, not a substitute for resolving the historical mapping.

## Scope and constraints

**In scope:** Verification of the reported site mismatch; authoritative historical baseline; the smallest relevant committed submission CRs; Sqitch execution/deployment history; provenance of sequence assignments; extent of verified site ID drift; analysis of remediation options.

**Secondary scope:** Other entities that use sequence-generated identifiers, but only if evidence demonstrates the same relevant failure mechanism.

**Out of scope:** Production data repair, editing or deleting CRs, Sqitch history rewriting, application redirects, implementation of the identity authority, and an exhaustive audit of every table or commit unrelated to the diagnosed discrepancy.

**Permissions / safety:** Default to read-only repository and authorized read-only database inspection. Do not deploy, run destructive commands, write to production, change schema/data, alter Git history, commit/push fixes, or implement remediation without explicit approval. Use isolated experiments only in a suitably authorized non-production environment; do not assume backups or production credentials are available.

## Expected deliverables

Write `docs/investigations/site-identity-mismatch/findings.md` with:

1. **Executive summary:** whether identity drift was substantiated, current impact, confidence, and unresolved blockers.
2. **Evidence and timeline:** sourced historical examples, dates/versions, contradictions, and records that cannot be accessed.
3. **Identity mapping:** a table showing confirmed and uncertain old/new `site_id` pairs linked to stable site attributes and submission CRs where possible.
4. **Reconstruction:** relevant Sqitch plans and scripts; for each build examined, its Git revision, database starting state, target tag, exact deployment command/options, and sequence state; plus reproducible steps (or reasons reproduction is unavailable). Do not infer a Git revision from `--ignore-git-tags` deployments without independent evidence.
5. **Root-cause assessment:** confirmed, supported-but-unproven, ruled-out, and unresolved hypotheses with evidence for each.
6. **Impact and options:** documented blast radius, risks of historical/new IDs, remediation alternatives, validation requirements, and prevention proposals.
7. **Next steps:** decisions and specific additional artifacts or approvals required to advance.

Use specific file paths, lines, commit hashes, queries, snapshot identifiers, and issue/comment links where available. Record negative evidence and uncertainty; do not invent missing historical IDs or claim a cause without corroboration.

## Completion criteria

- The `2278` / `4412` claim has been corroborated, rejected, or clearly bounded by a documented evidence gap.
- The relevant ID allocation history has been reconstructed as far as the available evidence permits, or remaining sources and blockers have been identified precisely.
- Confirmed affected sites are distinguishable from suspected ones; causal claims have evidence or are explicitly provisional.
- At least one viable remediation/compatibility strategy and its main risks are evaluated without unapproved changes.

## References

- [GitHub issue #438: SITE ID's HAVE CHANGED!](https://github.com/humlab-sead/sead_change_control/issues/438) and its linked comments and screenshots.
- [2025-08-28 export mentioned in issue comment](https://github.com/humlab-sead/sead_change_control/issues/438#issuecomment-5127857143) (linked SharePoint file not inspected in preparation).
- [Sqitch project list](https://github.com/humlab-sead/sead_change_control/blob/main/projects.txt).
- [Deployment script](https://github.com/humlab-sead/sead_change_control/blob/main/bin/deploy-staging).
- Original reporter-provided technical background in the request that prompted this brief (Sqitch forward-only practice, CR removal, candidate sequence mechanism).
