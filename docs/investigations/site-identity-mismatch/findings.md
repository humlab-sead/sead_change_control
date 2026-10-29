# Investigation findings: historical SEAD site identity mismatches

**Brief:** [brief.md](./brief.md)  
**Status:** Partially conclusive  
**Environment / baseline:** `humlab-sead/sead_change_control`, branch `dev`, inspected at `ddc2aad722912db002711823ea783c1bbbf08573`. No live database was available.  
**Plain-language summary:** [summary.md](./summary.md)

## Executive summary

The repository artifacts verify that the Bugs source key `SITE000234`, with the stable attributes for Glanllynnau, maps to `site_id = 2278` in the 2019 full-import snapshot and `site_id = 4412` in the 2023 full-import artifact. The older `bugs_trace` snapshot is preserved in the archived 2019 submission. The 2020 trace CR is an incremental change: it adds 17 new site links and does not replace or delete existing trace rows.

The 2019, 2020, and 2023 artifacts record separate consecutive `tbl_sites.site_id` ranges: `2101–3402`, `3816–3832`, and `4235–5644`. Every 2019/2023 shared source key has a different ID, and each of the 17 site keys added in 2020 also has a different ID in the 2023 full-import artifact.

The cause of the reassignment is established at artifact level: the 2023 import ran against an empty `bugs_import.bugs_trace`. Its trace IDs form one contiguous block from 2 to 703,751, and its `bugs_errors` IDs from 2 to 1,239, so neither table carried rows forward from the 2019 import (which ended at trace ID 627,666) or the 2020 increment (627,667–627,683). With no recorded `bugs_identifier` → `sead_reference_id` links, the importer treated every Bugs site as new and inserted it again, so every site received a freshly allocated `site_id`. That explains why all 1,297 shared keys changed rather than a subset.

What remains unexplained is the value `4235` as the starting point for the new range. That depends on the state of the `public.tbl_sites` sequence in the generation database, which is not recorded in the repository.

The artifact evidence still does **not** establish that production records were renumbered. If the earlier site rows were never removed, the deployed database may instead hold two records per site. Only a database check distinguishes those two states.

The issue screenshot has no independently verified capture date, the reported 2025 export was not available for inspection, the old artifact's production deployment is not established by the repository history, and no production database or deployment log could be checked.

The 2023 import was prepared from a copy of `sead_staging_202212` with sequence synchronization. That makes starting database and sequence state a plausible contributor to the newer generated mapping, but the Bugs importer source, relevant sequence values, and exact artifact-generation revision are unavailable here. Do not renumber records based on this investigation. First establish the current authoritative mapping and whether either ID is in use.

## Verified observations and reconstruction

The two import artifacts use the same Bugs key and matching name, national site identifier, and coordinates:

| Bugs source key | Site | Stable attributes | Earlier import artifact | Later import artifact | Assessment |
| --- | --- | --- | --- | --- | --- |
| `TSite` / `SITE000234` | Glanllynnau | `SH455373`; `52.91083, -4.2988887` | `site_id = 2278`; row timestamp `2019-12-20 23:11:05.9419+00` | `site_id = 4412`; row timestamp `2024-01-21 14:21:25.6295960+01` | **Verified artifact mapping change.** Whether this was the same production row across deployments is unverified. |

The earlier mapping appears in the archived 2019 Bugs mapping dump at decompressed line 553, and the corresponding public-data insert assigns `site_id = 2278` at decompressed lines 614721–614722. The later mapping appears in the 2023 full-import mapping at decompressed line 1436, and its public-data insert assigns `site_id = 4412` at decompressed line 341750. The row data in both imports agrees on the listed stable attributes.

A comparison of all `TSite` source-key mappings in these two repository artifacts found:

- 1,302 unique keys in the 2019 mapping and 1,410 in the later mapping.
- 1,297 keys shared between the artifacts; all 1,297 have different target IDs.
- Five keys occur only in the earlier artifact and 113 only in the later artifact.
- No duplicate target mappings per source key were found within either artifact.

This count describes **only the two Bugs import artifacts**. It is not a count of production sites that changed IDs, deployed records, broken URLs, or published references.

### Reconstruction limits

| Artifact/build | What is established | What remains unknown |
| --- | --- | --- |
| 2019 submission `20191221_DML_SUBMISSION_BUGS_20190303_COMMIT` | Its committed data assigns Glanllynnau ID 2278. The original commit [`e1a88919e970a15c420074217d49bcaa1927bca5`](https://github.com/humlab-sead/sead_change_control/commit/e1a88919e970a15c420074217d49bcaa1927bca5) added it under `submissions/deploy/`. | The original `bugs/sqitch.plan` at that revision did not include this change. In December 2023 it appeared only as a commented entry marked “Disabled ahead of 202312 release,” then was removed. The actual target database, deployment command, starting data and sequences, deployed revision, and whether the old submission ran in production were not established. |
| 2023 full import `20231211_DML_SUBMISSION_BUGS_20231219_COMMIT` | The current [Bugs Sqitch plan](../../../bugs/sqitch.plan#L23) places the change before `@2023.12` at line 29. Its SQL includes the prebuilt `public.sql` and `bugs_import.sql`, then synchronizes sequences after import ([change script](../../../bugs/deploy/20231211_DML_SUBMISSION_BUGS_20231219_COMMIT.sql#L29), lines 34–38). Issue [#162](https://github.com/humlab-sead/sead_change_control/issues/162) documents preparing the import database by copying `sead_staging_202212` with `--sync-sequence`; a comment says “Deployed to staging” on 2024-01-25. | The importer source and exact generation revision are not present in this checkout. The issue does not record the target deployment command, deployed Git revision, or production deployment. No initial/final sequence values are available. |

The current [deployment script](../../../bin/deploy-staging#L609) iterates release tags and then projects in the order from [projects.txt](../../../projects.txt#L1). Project ordering changed in commits `e07ee3b2f28051a9bc73f870887898af85e1c664` (2024-01-22) and `93240862825ddad5fac12dd3eba616b9bc140559` (2025-04-11). These commits establish that deployment order changed; they do not establish which revision or command was used for any production deployment, nor explain the explicit `4412` in the import artifact.

The model declares `tbl_sites.site_id` as a serial primary key ([tables.sql](../../../sead_model/deploy/SEAD_DATABASE_MODEL/tables.sql#L894)). However, the 2023 change loads a `public.sql` artifact that already contains the `site_id` values and only synchronizes the sequence afterward. Therefore, sequence state may have affected **generation of the import artifact**, but the sequence does not generate `4412` when this change script replays that row.

### Mapping ranges and trace history

The archived 2019 full-import snapshot is the oldest committed Bugs-to-SEAD link set found in the repository. It was first added in commit [`e1a88919e970a15c420074217d49bcaa1927bca5`](https://github.com/humlab-sead/sead_change_control/commit/e1a88919e970a15c420074217d49bcaa1927bca5) under `submissions/deploy/`, moved into the Bugs project in December 2023, then archived when the 2019 import was deprecated. The original mapping dump is still present at `bugs/archive/deploy/20191221_DML_SUBMISSION_BUGS_20190303_COMMIT/bugs_import_schema.sql.gz`.

| Artifact | `TSite` links to `tbl_sites` | `bugs_trace_id` range | Assigned `site_id` range | What it shows |
| --- | ---: | ---: | ---: | --- |
| 2019 initial full-import snapshot; row timestamps 2019-12-20 | 1,302 inserts | 1–1,302 | 2,101–3,402 | The 1,302 assigned site IDs are consecutive in this artifact. `SITE000234` is trace row 178 → site 2278. |
| 2020 incremental trace CR; generated 2020-03-16 for a staging-to-production comparison | 17 inserts | 627,667–627,683 | 3,816–3,832 | These are 17 new source keys, none shared with the 2019 TSite set. The companion public-data CR inserts the same 17 sites with these IDs. |
| 2023 full-import artifact; row timestamps 2024-01-21 | 1,410 inserts | 2–1,411 | 4,235–5,644 | The 1,410 assigned site IDs are consecutive in this artifact. `SITE000234` is trace row 179 → site 4412. |

These ranges describe values in the committed artifacts, not observed database sequence states or proven deployments. They do not mean that every ID in a range was reserved for a Bugs site in a live database.

For each artifact, the comparison selected `bugs_trace` records with `bugs_table = 'TSite'` and `sead_table = 'tbl_sites'`, grouped them by `bugs_identifier`, and compared `sead_reference_id`. The 2019 dump stores these fields in the `COPY` column order; the 2020 and 2023 files use explicit `INSERT` values.

All 1,297 source keys shared between the 2019 and 2023 snapshots have different `site_id` values. Of those changed IDs, 790 increased by 2,134 and 454 increased by 2,132; the other 53 have smaller differences. The 17 keys introduced in the 2020 trace CR all appear in the 2023 full-import artifact with a `site_id` increase of exactly 1,716:

| Bugs source keys | 2020 `site_id` range | 2023 `site_id` range | Difference |
| --- | ---: | ---: | ---: |
| `SITE001515`–`SITE001532`, excluding `SITE001522` | 3,816–3,832 | 5,532–5,548 | +1,716 for each of 17 keys |

The 2020 trace CR was first committed in March 2020 as a data-comparison change and was moved to `bugs/archive/` on 2023-12-18 by commit [`702c4a45144b3989cee4fd98ef321d5c3c99f684`](https://github.com/humlab-sead/sead_change_control/commit/702c4a45144b3989cee4fd98ef321d5c3c99f684), alongside the other incremental Bugs import CRs. Its header says it was generated by comparing `sead_staging_bugs` to `sead_production`. Its SQL inserts 17 new `TSite` links, with trace IDs 627667–627683 and target IDs 3816–3832; it contains no `DELETE` or `TRUNCATE` of `bugs_import.bugs_trace`. It does not contain `SITE000234`, so it cannot be the direct change to Glanllynnau's mapping.

The 2023 change wrapper imports the committed `public.sql` and `bugs_import.sql` data, then synchronizes sequences. The payload contains explicit trace and site IDs, with no explicit `DELETE` or `TRUNCATE` of `bugs_import.bugs_trace` or `public.tbl_sites`. The trace IDs in the payload do, however, establish that the generation database's trace table held no rows when the import ran (see E13). Whether that table was emptied deliberately, or whether it was simply never populated in that database lineage, is not recorded in the repository.

### CRs that load rows into `public.tbl_sites`

I searched the checked-in deployment SQL and compressed SQL payloads for direct `INSERT`, `COPY`, and `\copy` operations targeting `public.tbl_sites`, then checked the surrounding CRs and historical file versions. This found the following 13 distinct CRs with a retained active or historical site-row load:

| CR | Load represented in the CR artifact | Status and notes |
| --- | --- | --- |
| [`20100101_DML_SUBMISSION_MAL_000_LOOKUPS`](../../../mal/deploy/20100101_DML_SUBMISSION_MAL_000_LOOKUPS.sql#L44) | 378 rows; IDs 1–400 (gaps in the ID range). | In the current MAL plan. |
| [`20191220_DML_SUBMISSION_CERAMICS_001_COMMIT`](../../../ceramics/archive/deploy/20191220_DML_SUBMISSION_CERAMICS_001_COMMIT.sql#L35) | 413 rows; IDs 1,567–1,979. | The original [`e2b0c34`](https://github.com/humlab-sead/sead_change_control/commit/e2b0c34fbeae0fc17883813b84b89e560f1bde9d) version had an executable site load; its current archived deploy file comments out that block. Commit [`5b455ca`](https://github.com/humlab-sead/sead_change_control/commit/5b455cac40310946f083dfacc68083b3f2647145) describes the CR as faulty and adds a revert script. |
| [`20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT`](../../../dendrochronology/archive/deploy/20191220_DML_SUBMISSION_DENDRO_BUILDING_002_COMMIT.sql#L30) | 54 rows; IDs 1,980–2,033. | Archived submission CR; its deploy SQL loads a compressed site payload. |
| [`20191220_DML_SUBMISSION_DENDRO_ARCHEOLOGY_003_COMMIT`](../../../dendrochronology/archive/deploy/20191220_DML_SUBMISSION_DENDRO_ARCHEOLOGY_003_COMMIT.sql#L31) | 18 rows; IDs 2,034–2,051. | Archived submission CR; its deploy SQL loads a compressed site payload. |
| [`20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT`](../../../isotope/archive/deploy/20191220_DML_SUBMISSION_ISOTOPE_004_COMMIT.sql#L61) | 49 rows; IDs 2,052–2,100. | Archived submission CR; its deploy SQL loads a compressed site payload. |
| [`20191221_DML_SUBMISSION_BUGS_20190303_COMMIT`](../../../bugs/archive/deploy/20191221_DML_SUBMISSION_BUGS_20190303_COMMIT.sql#L56) | 1,302 rows; IDs 2,101–3,402. | Archived full import. The companion `bugs_trace` snapshot maps the same 1,302 Bugs site keys. |
| [`20200109_DML_SUBMISSION_CERAMICS_COMMIT`](../../../ceramics/deploy/20200109_DML_SUBMISSION_CERAMICS_COMMIT.sql#L36) | 413 rows; IDs 3,403–3,815. | In the current Ceramics plan. |
| [`20200313_DML_BUGS_IMPORT_PUBLIC_20200219`](../../../bugs/archive/deploy/20200313_DML_BUGS_IMPORT_PUBLIC_20200219.sql#L3949) | 17 rows; IDs 3,816–3,832. | Archived incremental public-data CR. Its companion trace CR records links but does not itself insert public site rows. |
| [`20231211_DML_SUBMISSION_BUGS_20231219_COMMIT`](../../../bugs/deploy/20231211_DML_SUBMISSION_BUGS_20231219_COMMIT.sql#L29) | 1,410 rows; IDs 4,235–5,644. | Full-import CR; its compressed `public.sql` contains the site inserts. |
| [`20240119_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT`](../../../dendrochronology/deploy/20240119_DML_SUBMISSION_DENDROCHRONOLOGY_COMMIT.sql#L456) | 419 rows; IDs 3,816–4,234. | Submission CR in the Dendrochronology plan. Its artifact range overlaps the 2020 Bugs range 3,816–3,832; these payloads do not prove those rows coexisted in one database. |
| [`20241023_DML_NEW_DENDRO_LOOKUPS`](../../../dendrochronology/deploy/20241023_DML_NEW_DENDRO_LOOKUPS.sql#L1789) | 841 rows in the `new_data` list; IDs are assigned by `sead_utility.allocate_system_id` at deployment, not fixed in the CR. | In the current Dendrochronology plan. |
| [`20241029_DML_ADNA_LOOKUPS`](../../../adna/archive/deploy/20241029_DML_ADNA_LOOKUPS.sql#L170) | One row; ID is assigned by `sead_utility.allocate_system_id` at deployment. | Archived lookup CR. |
| [`20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT`](../../../adna/deploy/20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT.sql#L619) | One row; payload site ID 6,486. | Submission CR in the current aDNA plan. |

There is one historical precursor to the MAL entry above: the initial version of `20100101_DML_SUBMISSION_MAL_000_COMMIT` also copied the same MAL site payload (378 rows, IDs 1–400). Commit [`6e5c14224a91a81e612b0a8726d290a16d881db9`](https://github.com/humlab-sead/sead_change_control/commit/6e5c14224a91a81e612b0a8726d290a16d881db9) moved the site load out of that CR and into `20100101_DML_SUBMISSION_MAL_000_LOOKUPS`. Do not count the two CR versions as 756 distinct MAL sites.

The ranges above are the IDs carried in the files, not proof of deployment, insertion order, or simultaneous presence. They are not globally unique across artifacts: the 2020 Bugs CR and 2024 Dendro submission both carry IDs 3,816–3,832. The 2023 Bugs artifact starts at 4,235, immediately after the Dendro payload range, but that alone does not establish the database state used to generate either payload.

## Evidence ledger

| ID | Observation or test | Source | Result | Assessment |
| --- | --- | --- | --- | --- |
| E1 | Issue screenshot and links associate the site with 2278 and 4412 | [Issue #438](https://github.com/humlab-sead/sead_change_control/issues/438) | Screenshot shows Glanllynnau at `browser.sead.se/site/2278`; issue discussion links to `super.sead.se/site/4412`. Screenshot capture time and database versions were not verified. | Reported correspondence; not proof of a production identity transition. |
| E2 | Earlier Bugs mapping and public row | `bugs/archive/deploy/20191221_DML_SUBMISSION_BUGS_20190303_COMMIT/bugs_import_schema.sql.gz` (decompressed line 553); `public_data_diff.sql.gz` (decompressed lines 614721–614722) | `SITE000234`, `SH455373`, and the matching coordinates map to `site_id = 2278`. | Verified in the committed artifact. |
| E3 | Later Bugs mapping and public row | `bugs/deploy/20231211_DML_SUBMISSION_BUGS_20231219_COMMIT/bugs_import.sql.gz` (decompressed line 1436); `public.sql.gz` (decompressed line 341750) | The same source key and attributes map to `site_id = 4412`. | Verified in the committed artifact. |
| E4 | Cross-artifact mapping comparison | The two mapping dumps cited in E2 and E3 | All 1,297 shared `TSite` keys have different IDs; 5 earlier-only and 113 later-only keys. | Verified artifact comparison; production extent unknown. |
| E5 | 2023 import preparation | [Issue #162](https://github.com/humlab-sead/sead_change_control/issues/162), including the [staging deployment comment](https://github.com/humlab-sead/sead_change_control/issues/162#issuecomment-1910928596) | Procedure copies `sead_staging_202212` to `sead_staging_bugs` with `--sync-sequence`, builds and runs the Bugs import application, and a later comment records a staging deployment on 2024-01-25. | Verified as documented preparation and a reported staging deployment; not a production deployment record. |
| E6 | Historical plan status for the 2019 submission | Commits [`6dae0442b6ce8f0b5e1c803447a8113b28acc066`](https://github.com/humlab-sead/sead_change_control/commit/6dae0442b6ce8f0b5e1c803447a8113b28acc066) and [`63cb311229e656d93a618709df1d64ece3b14263`](https://github.com/humlab-sead/sead_change_control/commit/63cb311229e656d93a618709df1d64ece3b14263) | The entry was added to the plan as a comment saying it was disabled ahead of the 202312 release, then removed. The 2019 commit itself placed the data under `submissions/deploy/`, not the Bugs project's active plan. | Verified repository history; deployment of the old data is unverified. |
| E7 | Live-database verification attempt | Local read-only PostgreSQL connection and PostgreSQL MCP profile lookup | The local connection was refused; the MCP profile lookup failed to initialize. No database query ran. | Blocked; no current or historical database state is established. |
| E8 | Newer export and screenshot timing | [Issue comment about the 2025-08-28 export](https://github.com/humlab-sead/sead_change_control/issues/438#issuecomment-5127857143) | The commenter reports the export contains 4412 and no differences from then-current data. The linked spreadsheet was not inspected; the screenshot's capture date remains unknown. | Unverified report. |
| E9 | 2019 full-import trace snapshot | `bugs/archive/deploy/20191221_DML_SUBMISSION_BUGS_20190303_COMMIT/bugs_import_schema.sql.gz` (decompressed `COPY bugs_import.bugs_trace` starts at line 369; Glanllynnau row at line 553) | Contains 1,302 `TSite` → `tbl_sites` insert links with trace IDs 1–1,302 and site IDs 2,101–3,402; `SITE000234` maps via trace row 178 to site 2278. | Verified in the artifact; production application is unverified. |
| E10 | 2020 incremental trace and public-data changes | `bugs/archive/deploy/20200313_DML_BUGS_IMPORT_TRACE_20200219.sql` (trace insert begins at line 546); `bugs/archive/deploy/20200313_DML_BUGS_IMPORT_PUBLIC_20200219.sql` (site insert begins at line 3949) | The trace CR adds 17 new site links, trace IDs 627667–627683 → site IDs 3816–3832. The companion public CR inserts those site rows. No Glanllynnau key or trace-table delete/truncate appears in the trace CR. | Verified artifact content; execution against production is not proven. |
| E11 | 2023 full-import trace mapping range | `bugs/deploy/20231211_DML_SUBMISSION_BUGS_20231219_COMMIT/bugs_import.sql.gz` and `public.sql.gz` | Contains 1,410 `TSite` → `tbl_sites` inserts, trace IDs 2–1,411 and site IDs 4,235–5,644. All 1,297 keys shared with 2019 and all 17 site keys from 2020 have different target IDs. | Verified artifact comparison; does not establish a table reset or production impact. |
| E12 | Repository-wide CR insert scan for site rows | Tracked CR SQL and compressed payloads in the checked-out repository, plus reachable Git history for earlier file versions | Found 13 CR identities with site-row loads, plus the earlier MAL commit version whose site payload was moved to the MAL lookup CR. Also found non-CR starting-point dumps and helper scripts, excluded from the CR list. | Verified repository inventory within the inspected revision and available history; not a claim that every CR ran on a live database. |
| E13 | Trace-ID continuity test on the 2023 payload | `bugs/deploy/20231211_DML_SUBMISSION_BUGS_20231219_COMMIT/bugs_import.sql.gz`, parsed by target table | `bugs_import.bugs_trace` holds 703,750 rows, IDs 2–703,751, fully contiguous with no gaps. `bugs_import.bugs_errors` holds 1,238 rows, IDs 2–1,239, also contiguous. Neither continues from the 2019 maximum of 627,666 or the 2020 range 627,667–627,683. | **Verified.** The generation database's trace table was empty when the import ran. Causes the all-keys reassignment. Does not by itself show how the table became empty, nor whether old `tbl_sites` rows survived. |

## Timeline

| Date | Event | What the date establishes |
| --- | --- | --- |
| 2019-12-20 | Earlier mapping row timestamp in the archived import artifact | The artifact records Glanllynnau as 2278. It does not establish a deployment date. |
| 2019-12-23 | Commit `e1a88919e970a15c420074217d49bcaa1927bca5` adds the Bugs submission files | Establishes when the artifact entered the repository, not when it reached a database. |
| 2020-03-13 to 2020-03-16 | Data timestamps and generation date in the incremental trace CR | It adds 17 site links with IDs 3816–3832. Its header identifies a staging-to-production data comparison, not an execution record. |
| 2020-03-18 | Commit `83be3d8cb6b8cecf456081b85b8cf8db889bfaeb` adds the 2020 public and trace data-comparison CRs | Establishes the CRs were committed; not proof that the production target applied them. |
| 2023-12-11 | Later full-import change date and plan entry | Establishes the change artifact's recorded date. Its description calls it a full initial import of BugsCEP data version 20230705. |
| 2023-12-18 | Commit `702c4a45144b3989cee4fd98ef321d5c3c99f684` moves the 2020 public and trace CRs into `bugs/archive/` | The changes were archived to enable the 2023 full import; this does not show that trace rows were deleted from a database. |
| 2024-01-21 | Later mapping row timestamp | The generated artifact records Glanllynnau as 4412 by this timestamp. |
| 2024-01-25 | Issue #162 comment says the import was deployed to staging | Establishes a reported staging deployment, not a production deployment or exact deployed revision. |
| 2025 (exact date unknown) | Issue #438 screenshot is described as showing ID 2278 | The reported screenshot cannot be placed precisely relative to either import artifact. |
| 2025-08-28 | Date attributed to the export in an issue comment | The export's contents and source database were not independently checked. |

## Root-cause assessment

**Confirmed mechanism:** The 2023 import ran with an empty `bugs_import.bugs_trace`, verified from the trace and error ID ranges in its own payload (E13). With no prior site links recorded, the importer treated every Bugs site as new and inserted it again, so every site received a newly allocated `tbl_sites.site_id`. This explains why all 1,297 shared keys changed. The particular starting value `4235` remains attributed to sequence state in the generation database.

The mechanism is confirmed in the generation data. It does not establish what a given deployed database contains: renumbered rows and duplicated rows are both consistent with the artifact.

| Hypothesis | Supporting evidence | Contrary evidence / checks | Status |
| --- | --- | --- | --- |
| H1 — The 2020 trace CR changed existing site identities | The 2020 CR inserts explicit `tbl_sites` links. | It contains only 17 new `TSite` keys, none shared with the 2019 snapshot or `SITE000234`; it performs no trace-table delete/truncate. The 17 keys later appear in 2023 with a uniform +1,716 ID shift. | **Ruled out for the Glanllynnau change; the CR records new 2020 sites, not remapping of prior keys.** |
| H2 — Different starting database or sequence state changed allocation during import generation | The 2019 and 2023 artifacts have disjoint consecutive site-ID ranges, and the 2020 keys all shift by +1,716 in 2023. Issue #162 documents preparing the later import from a copy of `sead_staging_202212` with `--sync-sequence`. | The committed SQL carries the IDs explicitly; importer source, actual before/after sequence state, generation logs, and database snapshots are unavailable. No in-repository SQL proves that sequence state allocated the changed IDs. H3 now explains the reassignment itself, so sequence state is only needed to explain the starting value. | **Retained as the explanation for the starting value `4235`, not for the reassignment. Unproven.** |
| H3 — The full import replaced or regenerated the old `bugs_trace` links | The 2023 artifact contains a full set of 1,410 `TSite` links with trace IDs 2–1,411, versus 1,302 links with trace IDs 1–1,302 in 2019 and 17 incremental trace IDs 627,667–627,683 in 2020. Every shared 2019/2023 site mapping changed. The whole trace table is contiguous from 2 to 703,751 and `bugs_errors` from 2 to 1,239 (E13), so no rows carried forward from the earlier imports. | The 2023 wrapper and its data payloads contain no explicit delete/truncate of `bugs_trace`, so how the table became empty is not recorded. The trace ID itself is not the public `site_id`. | **Confirmed in the generation data: the trace table was empty when the import ran, and that empty state caused the reassignment of every site. Whether a deployed table was emptied by an explicit statement remains unrecorded.** |
| H4 — Different applications or database versions explain the reported URL mismatch | The issue refers to `browser.sead.se` and `super.sead.se`, and the issue's screenshot timing and database versions are unknown. The export is only described by a commenter. | Separate application/database versions were not independently established. The artifact-level mapping change exists regardless of the URL discrepancy. | **Unverified.** |
| H5 — A later transformation or manual correction changed the ID | The later full-import artifact contains the changed mapping; its row timestamp is 2024-01-21. | No importer source, generation logs, manual correction record, or other targeted change explaining the mapping was found. The SQL change itself does not calculate the new ID. | **The changed import artifact is verified; the process that produced its mapping is unresolved.** |

## Impact and extent

**Confirmed affected cases:** One source key, `SITE000234` / Glanllynnau, has different target IDs in the two repository artifacts. The issue screenshot and URL discussion report the same pair, but do not prove a database transition.

**Confirmed extent in the import data:** The same two artifact sets differ for all 1,297 shared `TSite` keys, because the 2023 import ran with an empty trace table and therefore recognised no existing site (E13). Any database that received this import as a fresh load will show the same wholesale reassignment.

**Not established:** which rows were deployed to staging or production, whether the earlier rows were removed or retained, which IDs are currently in use, whether any ID was reused for a different site, and how many external references are affected. The reported absence of a current record at ID 2278 is not independently verified. If old rows survived alongside the new ones, the deployed database would hold duplicate site records rather than reassigned ones.

## Remediation options

| Option | Benefits | Risks / compatibility | Prerequisites / validation |
| --- | --- | --- | --- |
| Preserve current IDs and add a verified historical alias or redirect for old links | Can keep current foreign-key values stable while resolving older published URLs. | ID 2278 might be in use for another site; an unconditional redirect could send users to the wrong record. Aliases do not fix inconsistent source mappings by themselves. | Read-only check of current and historical assignments; verify collisions and link behavior; derive aliases from stable identifiers and authoritative snapshots. |
| Restore earlier IDs across records | Could preserve older URLs if 2278 is authoritative. | High risk to current URLs, all referencing foreign keys, datasets, exports, and any references already using 4412. The available artifacts do not establish a safe baseline or complete migration map. | Authoritative baseline, complete old-to-new mapping, dependency inventory, collision checks, transactional migration plan, rollback plan, and validation across all references. |
| Defer data changes while establishing the authoritative mapping | Avoids irreversible changes based on incomplete history. | Leaves the reported link discrepancy unresolved until evidence and an identity policy are available. | Obtain database/export and deployment evidence listed below; decide whether existing IDs or a compatibility layer are authoritative. |

**Recommended next step:** Perform authorized read-only checks against the current authoritative database and obtain the referenced export. Confirm the records and any collision at both 2278 and 4412 before choosing an alias or migration. Do not renumber from the import artifacts alone.

A step-by-step candidate for the third option is in [realignment-plan.md](./realignment-plan.md). It is not authorized work.

**Prevention / regression detection:** The empty-trace condition is the specific failure to guard against. Before running a full import, assert that `bugs_import.bugs_trace` still holds the approved `bugs_identifier` → `sead_reference_id` links for the sites being loaded, and fail the run if it is empty or if any shared key resolves to a different `site_id`. Record the import application revision, source-data version/hash, starting database snapshot, sequence state, generated mapping, target tag, deployed Git revision, and exact deployment command/options. Validate foreign keys and uniqueness before deployment.

## Unresolved questions and blockers

1. Which production database and application version served the screenshot and the `super.sead.se/site/4412` link?
2. What is in the 2025-08-28 export, and which database/version produced it? Can the original screenshot's capture time and source be established?
3. Does the current authoritative database contain Glanllynnau at 2278, 4412, both, or neither? Is either ID assigned to another site?
4. Was the 2019 submission ever applied to the relevant production database? What were its target, starting snapshot, deployed Git revision, and command?
5. Why was `bugs_import.bugs_trace` empty when the 2023 import ran? Was it cleared deliberately, or was that database lineage never given the 2019 data? The trace ID ranges prove the emptiness but not its origin.
6. What `tbl_sites` sequence state produced the starting value `4235`? This is now the only part of the mapping that H3 does not explain.
7. What deployment record, if any, proves the 2023 full import reached production? The issue comment only records staging.
8. Do archived snapshots or published references show which mapping was used, and what is the complete production impact beyond the two repository artifacts?

The importer source and historical production records are not present in this checkout. The smallest next evidence request is the 2025 export plus read-only access to a database snapshot tied to a known version. If those confirm the current mapping, obtain the import-generation logs/source and deployment record to determine cause and scope.

## Verification record

- Inspected the issue #438 discussion and screenshot; the screenshot capture date was not established. The linked 2025-08-28 spreadsheet was not inspected.
- Read the old and new compressed SQL artifacts and compared their `TSite` source-key mappings by `bugs_identifier`, matching each key to its `sead_reference_id`. The 2019 mapping is in a PostgreSQL `COPY` stream; the later mapping is represented by `INSERT` statements. The counts above are limited to these two files.
- Parsed `TSite` → `tbl_sites` rows from the 2019 full-import snapshot, 2020 incremental trace CR, and 2023 full-import artifact. Compared row counts, trace-ID/site-ID ranges, source-key intersections, and target-ID changes. This analysis reads committed data artifacts only.
- Parsed the 2023 `bugs_import.sql.gz` by target table and checked `bugs_trace_id` and `bugs_error_id` continuity. `bugs_trace` holds 703,750 rows with IDs 2–703,751 and `bugs_errors` 1,238 rows with IDs 2–1,239, both contiguous, versus a 2019 maximum trace ID of 627,666 and the 2020 range 627,667–627,683. This is the basis for the empty-trace conclusion (E13).
- Searched tracked SQL and gzip-compressed SQL for `INSERT`, `COPY`, and `\copy` operations into `public.tbl_sites`; inspected corresponding payload row counts and explicit IDs, and checked reachable Git history for the earlier MAL and Ceramics CR versions.
- Inspected the 2020 trace CR header and SQL, its companion public-data insert block, the 2023 import wrapper, and the 2023 compressed data payloads for explicit trace/site table deletes or truncates. No such statement was found in those CR files; this does not establish how the import application prepared its generation database.
- Inspected the 2019 submission commit, the related plan-history commits, the current Bugs plan, the 2023 change script, the current deployment loop, and `projects.txt`. These establish repository contents and intended behavior, not historical production execution.
- Read issue #162 for the documented import preparation and its staging deployment comment.
- Attempted a read-only connection to local staging; the server refused the connection. The PostgreSQL MCP profile lookup failed to initialize. No database query was run.
- No source code, database, or deployment state was changed. No tests were run; this deliverable is an investigation report.

## References

- [Investigation brief](./brief.md)
- [Investigation workflow and document conventions](../README.md)
- [Issue #438: SITE ID's HAVE CHANGED!](https://github.com/humlab-sead/sead_change_control/issues/438)
- [Issue #162: 2023 Bugs full import](https://github.com/humlab-sead/sead_change_control/issues/162)
- [2019 Bugs submission artifact](../../../bugs/archive/deploy/20191221_DML_SUBMISSION_BUGS_20190303_COMMIT/)
- [2020 Bugs trace CR](../../../bugs/archive/deploy/20200313_DML_BUGS_IMPORT_TRACE_20200219.sql)
- [2020 Bugs public-data CR](../../../bugs/archive/deploy/20200313_DML_BUGS_IMPORT_PUBLIC_20200219.sql)
- [2023 Bugs submission artifact](../../../bugs/deploy/20231211_DML_SUBMISSION_BUGS_20231219_COMMIT/)
- [Bugs Sqitch plan](../../../bugs/sqitch.plan)
- [Deployment script](../../../bin/deploy-staging)
- [Project deployment order](../../../projects.txt)
- [SEAD model table definitions](../../../sead_model/deploy/SEAD_DATABASE_MODEL/tables.sql)
