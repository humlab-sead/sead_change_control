# Phase 1 record: Bugs site-ID crosswalk

- **Related:** [realignment-plan.md](./realignment-plan.md), [findings.md](./findings.md), [brief.md](./brief.md)
- **Status:** Complete. Every check passes and the artifact is independently verified against `sead_staging_validation`. No payload or database row was modified.
- **Baseline:** `humlab-sead/sead_change_control`, branch `site-identity-mismatch-realignment`
- **Date:** 2026-10-29

This record covers Phase 1 of [realignment-plan.md](./realignment-plan.md): build the Bugs source-key to SEAD site-ID crosswalk and freeze it as a reviewable artifact. Phase 2 rewrites the payloads from this artifact, so the crosswalk is the reference the rest of the plan depends on.

## Deliverables

| File                | Purpose                                                                   |
|---------------------|---------------------------------------------------------------------------|
| `build-site-id-map` | Bash entry point. Runs the generator.                                     |
| `site_id_map.py`    | Parsers, crosswalk rules, and 39 checks. Python 3, standard library only. |
| `site_id_map.tsv`   | Generated crosswalk. 1,415 rows, 6 columns, tracked as audit evidence.    |

```bash
λ ./build-site-id-map
λ ./build-site-id-map --output /tmp/site_id_map.tsv
```

The generator reads files only. It opens no database, writes no payload, and writes the TSV only when every check passes, so a failed run leaves the previous artifact in place.

## Why Python

The 2019 snapshot is a PostgreSQL `COPY` stream with one tab-separated record per line, which line-oriented tools can read. The 2023 payload is not: it holds 530 `INSERT` statements averaging about 1,330 tuples each, using `E'...'` strings and 7,826 doubled quotes. Splitting those tuples needs a scanner that tracks quoting across line boundaries, so the generator uses a small state machine in Python rather than a shell pipeline. Only the standard library is used; `csv` writes the TSV.

## Source keys

A site link requires both `bugs_table = 'TSite'` and `sead_table = 'tbl_sites'`.

| Snapshot               | Artefact form                | Rows read | `TSite` → `tbl_sites` links |
|------------------------|------------------------------|----------:|----------------------------:|
| 2019 full import       | `COPY` stream, tab separated |   627,666 |                       1,302 |
| 2020 incremental trace | `INSERT` tuples              |     9,575 |                          17 |
| 2023 full import       | `INSERT` tuples              |   703,750 |                       1,410 |

The 2020 source was added to the plan's original scope because `id_2020` is a crosswalk column. It also independently confirms the shift the findings describe: the 17 keys assigned `3816–3832` in 2020 appear at `5532–5548` in 2023.

## Crosswalk composition

| `provenance` |      Rows | `new_id`                                                         |
|--------------|----------:|------------------------------------------------------------------|
| `2019`       |     1,297 | The 2019 assignment, in `2101–3402`                              |
| `2023`       |       113 | The current 2023 assignment, in `5532–5644`                      |
| `2019-only`  |         5 | Empty. The key has left the source data and is not reintroduced. |
| **total**    | **1,415** | 1,410 distinct target IDs                                        |

`SITE000234` (Glanllynnau) resolves `2278 → 4412 → 2278`. The five dropped keys are `SITE000988`, `SITE001012`, `SITE001481`, `SITE001493`, and `SITE001494`, at `2891, 2914, 3369, 3381, 3382`. Their old IDs sit inside `2101–3402` and stay vacant rather than being reassigned.

The 1,297 vacated 2023 IDs span `4235–5531` and never collide with a realigned ID, so the renumbering has no swap hazard.

## Checks

The run performs 39 checks and exits non-zero on any failure:

- **Trace sizes:** 627,666 / 9,575 / 703,750 rows, plus 530 `bugs_trace` statements and 1,238 `bugs_errors` rows in the 2023 payload.
- **Link counts:** 1,302 / 17 / 1,410, with the `TSite` target tables and their non-site row counts asserted for both 2019 and 2023.
- **Key sets:** 1,297 shared, 113 2023-only, 5 2019-only, and every shared key changed its target ID.
- **Crosswalk:** 1,415 rows, 1,410 with a target ID, all target IDs unique, restored range `2101–3402`, kept range `5532–5644`, no overlap between them, no collision with a vacated ID, vacated range `4235–5531`.
- **Payload agreement:** `public.tbl_sites` holds 1,410 unique IDs matching the trace links, and every child-table `site_id` in all four dependent tables is a current 2023 site row.

## Independent verification

The crosswalk was loaded into `sead_staging_validation` and compared with the live ledger and site table. Every comparison returned zero:

| Check                                                                   | Result |
|-------------------------------------------------------------------------|-------:|
| `map.id_2023` differing from `bugs_import.bugs_trace.sead_reference_id` |      0 |
| Ledger `TSite` → `tbl_sites` keys missing from the map                  |      0 |
| `map.id_2023` values without a `tbl_sites` row                          |      0 |
| `new_id` values already used by another data provider's site            |      0 |
| `new_id` values occupied by a different current site row                |      0 |

Re-running the generator reproduces the file byte for byte:

```
8a6430e0d6c849f4f0aa0eda16697dec28dbec1e6653c7f785770e242a6f312b  site_id_map.tsv
711bc46a9a75bc01d97228905f3aa0a0ecfe1929682c356a0b48428c3eef599f  site_id_map.py
a0d0de80a1445d21dd34e88d5d564575c274b93bcb1dd7e702b105a3b25857ef  build-site-id-map
```

`ruff check` and `shellcheck -S style` both pass.

## Findings that affect later phases

**Most `TSite` ledger rows are not site links.** The 2019 snapshot holds 2,604 `tbl_site_locations` and 298 `tbl_locations` references; the 2023 payload holds 2,820 and 337. Those reference IDs are location primary keys. A rewrite that filters on `bugs_table = 'TSite'` alone would corrupt 3,157 values in the 2023 file. Phase 2.2 now states those counts explicitly and requires the `sead_table` condition.

**The `2019-only` keys must not receive a target ID.** Giving them their 2019 ID would reintroduce sites that the source data no longer contains, and would contradict the plan's statement that those rows were removed from the deployed sequence.

**The crosswalk is a superset of the current site set, not a replacement for it.** It holds 1,410 target IDs for 1,410 current sites. Five audit rows carry no target ID, which is why the file has 1,415 data rows.

## Reproducing

```bash
cd docs/investigations/site-identity-mismatch
./build-site-id-map
sha256sum -c <<< '8a6430e0d6c849f4f0aa0eda16697dec28dbec1e6653c7f785770e242a6f312b  site_id_map.tsv'
```

The generator locates the repository root from its own path, so it works from any directory.

## Next

Phase 2 rewrites `public.sql.gz` and `bugs_import.sql.gz` using `new_id` from this crosswalk. It replaces only the ID token and leaves row order, `change_date` values, `bugs_trace_id` values, numeric formatting, and quoted text untouched. Steps 2.1–2.5 are unchanged except for the filter warning recorded above.
