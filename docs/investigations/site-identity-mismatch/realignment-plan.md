# Tentative action list: realign 2023 Bugs site IDs to the 2019 assignments

**Related:** [brief.md](./brief.md), [findings.md](./findings.md), [summary.md](./summary.md)  
**Status:** Gates 0.1–0.3 closed. Delivery path decided (Track A, Track B, Track C). Not authorized for deployment, and no files, data, or databases were changed.  
**Baseline:** `humlab-sead/sead_change_control`, branch `dev`, inspected at `ddc2aad722912db002711823ea783c1bbbf08573`.  
**Date drafted:** 2026-10-28  
**Date updated:** 2026-10-29

This document turns the remediation note in [findings.md](./findings.md) into a concrete step list. It is a proposal to be approved before any deployment work, not permission to renumber records.

## Objective

Make the site IDs in the 2023 Bugs full-import change request match the site IDs committed in the 2019 Bugs full-import snapshot, for every site source key that exists in both. Sites introduced after 2019 keep their current 2023 IDs.

## Delivery path (0.3 decided)

All three deliverables are in scope:

| Track | Deliverable | Fixes | Applies to |
| --- | --- | --- | --- |
| A | Rewrite the two payloads of `20231211_DML_SUBMISSION_BUGS_20231219_COMMIT` | What a fresh deployment produces | Databases built from the plan |
| B | New corrective change request that renumbers existing rows | Rows already written with 2023 IDs | Databases that already applied the 2023 import |
| C | Corrected `bugs_import.bugs_trace` ledger, published as a repository artifact | The prior links the next Bugs import reads | Every future import generation |

Track A and Track B alone would fix the rows but leave the next full import free to repeat the 2023 mistake, because the mistake was an empty ledger rather than bad row values. Track C is what a future import generation starts from.

Consequences of the decision:

- **Track A rewrites released history.** `20231211_...` is listed before the `@2023.12` tag, so its payload is released. The rewrite changes data values only; row order, row counts, `bugs_trace_id` values, and DDL stay the same. Record the correction in the change-request header, the issue, and the release notes. Databases that already applied the change request are unaffected by the rewrite and are handled by Track B.
- **Track B must be a no-op where Track A already applied.** A database built from the corrected payload already holds the realigned IDs, so the corrective change request must detect that state, change no IDs, and still pass its verification.
- **Track B and Track C are driven by the same artifact.** Both use `site_id_map.tsv` from [Phase 1](#phase-1--freeze-the-crosswalk-as-a-reviewable-artifact), so the live ledger and the published snapshot cannot drift apart.
- **The ledger is corrected, not rebuilt.** The 1,410 `TSite` → `tbl_sites` links change; every other ledger row and every `bugs_trace_id` value stays as it is. The 5 keys that exist only in 2019 are not reintroduced, because they are no longer in the source data.

## Cause this corrects

The 2023 import ran with an empty `bugs_import.bugs_trace`, so the importer recognised no existing site and inserted all of them again. Its trace IDs form one contiguous block from 2 to 703,751 and its `bugs_errors` IDs from 2 to 1,239, so neither table continued from the 2019 maximum of 627,666 or the 2020 range 627,667–627,683. Every site therefore received a newly allocated `site_id`. The plan below restores the earlier IDs from the record that the empty table should have provided.

## Verified inputs

The source key is `bugs_import.bugs_trace.bugs_identifier`; the target ID is `bugs_import.bugs_trace.sead_reference_id`. The companion `bugs_data` text holds the source row, not the link.

| Check | Result |
| --- | --- |
| `TSite` → `tbl_sites` links, 2019 archive vs 2023 payload | 1,302 vs 1,410 keys; 1,297 shared, and every shared key has a different target ID |
| Target ID ranges | 2019: `2101–3402`; 2023: `4235–5644` |
| Keys present only in 2023 | 113, starting at `SITE001515`; includes the 17 keys added by the 2020 trace CR |
| Keys present only in 2019 | 5 → `2891, 2914, 3369, 3381, 3382` |
| 2020 trace IDs for its 17 keys | `3816–3832`, which collides with the Dendrochronology 2024 payload (`site.gz`, 419 rows, `3816–4234`), so those IDs must not be reused |
| Columns carrying `site_id` in `public.sql.gz` | `tbl_sites`, `tbl_site_locations`, `tbl_site_references`, `tbl_site_other_records`, `tbl_sample_groups` |
| Referential closure | Every child-table `site_id` value (1,410 distinct) exists in the `tbl_sites` payload |
| `tbl_sites.site_preservation_status_id` | `NULL` in all 1,410 rows |
| `bugs_trace` ID range, 2023 payload | 703,750 rows, IDs 2–703,751, fully contiguous; `bugs_errors` 2–1,239. Neither resumes from the 2019 maximum of 627,666 or the 2020 range 627,667–627,683, so the generation database's trace table was empty |
| Other Bugs change requests touching `site_id` | Only the inactive 2019 and 2020 archived ones; no active Bugs change request after the 2023 import |
| `general/deploy/20241028_DML_UPDATE_INCORRECT_COORDINATES.sql` | Matches rows by `site_name`, so it survives renumbering |

### Remap rule

```text
for each bugs_identifier in the 2023 trace where sead_table = 'tbl_sites':
    if the key also appears in the 2019 trace  -> new_id = 2019 sead_reference_id
    else                                       -> new_id = current 2023 sead_reference_id
```

This produces 1,410 unique target IDs: 1,297 in `2101–3402` and 113 unchanged in `5532–5644`. The two sets do not overlap.

The 113 keys keep their 2023 IDs because their only alternative source, the 2020 trace, uses a range already taken by the Dendrochronology 2024 submission.

## Phase 0 — Gates and baseline

- [x] **0.1** Open [GitHub issue #460](https://github.com/humlab-sead/sead_change_control/issues/460) for the realignment and record the decision that the 2019 assignments are authoritative for the 1,297 shared keys.
- [x] **0.2** Run read-only checks against the target database (use `bin/psql.sh` or `psql -U sead_ro -w`; never write):
  - [x] **0.2.1** Confirm `2101–3402` is unoccupied.
    > ```sql
    > select count(*) from tbl_sites where site_id between 2101 and 3402;
    > --> Confirmed result: 0
    > ```
  - [x] Confirm `5532–5644` holds exactly the 113 kept sites and no foreign occupant.
    > ```sql
    > select count(*) from tbl_sites where site_id between 5532 and 5644;
    > --> Confirmed result: 113
    > ```
  - [x] Confirm that the child tables outside the payload hold no rows in `4235–5644`.
    > ```sql
    > select count(*) from tbl_site_natgridrefs where site_id between 4235 and 5644;
    > --> Confirmed result: 0
    > select count(*) from tbl_site_images where site_id between 4235 and 5644;
    > --> Confirmed result: 0
    > select count(*) from tbl_site_preservation_status where site_id between 4235 and 5644;
    > --> Confirmed result: 0
    > ```
  - [x] Confirm whether one site holds both `2278` and `4412`, or whether either ID is assigned to a different site.
    > ```sql
    > select * from tbl_sites where site_id in (2278, 4412);
    > --> Confirmed result: only 4412 returned
    > ```
  - [x] Establish whether the earlier site rows were **retained or removed**.  Confirmed since the 2019 was pulled from the Sqitch-managed deployment sequence.
    > ```sql
    > -- Identify data provider intervals for sites
    > with site_sequence as (
    >   select generate_series(min(site_id), max(site_id)) as site_id
    >   from tbl_sites
    >   order by 1
    > ), sample_groups as (
    >   select distinct sg.site_id, sg.sample_group_name, sg.method_id, m.method_name, rt.record_type_name
    >   from tbl_sample_groups sg
    >   join tbl_methods m using (method_id)
    >   left join tbl_record_types rt using (record_type_id)
    > ), samples as (
    >   select distinct physical_sample_id, sg.site_id, ps.sample_name, st.type_name
    >   from tbl_sample_groups sg
    >   join tbl_physical_samples ps using (sample_group_id)
    >   left join tbl_sample_types st using (sample_type_id)
    > ), datasets as (
    >   select distinct physical_sample_id, d.dataset_name, md.master_name, m.method_name, ts.data_type_name,
    >     case when md.master_set_id = 1  then 'BugsCEP'
    >         when md.master_set_id = 2  then 'MAL'
    >         when md.master_set_id = 3  then 'Lund/KFL'
    >         when md.master_set_id = 10 then 'Lund/Dendro'
    >         when md.master_set_id = 11 then 'Sth/KFL'
    >         when md.master_set_id = 12 then 'aDNA'
    >     end as master_abbrev
    >   from tbl_datasets d
    >   join tbl_dataset_masters md using  (master_set_id)
    >   join tbl_methods m using (method_id)
    >   join tbl_data_types ts using (data_type_id)
    >   join tbl_analysis_entities ae using (dataset_id)
    >   join tbl_physical_samples ps using (physical_sample_id)
    > ), sites_with_provider_data as (
    >   select sites.site_id, datasets.master_abbrev
    >   from tbl_sites sites
    >   join sample_groups using (site_id)
    >   join samples using (site_id)
    >   join datasets using (physical_sample_id)
    >   group by sites.site_id, datasets.master_abbrev
    >   order by sites.site_id
    > 
    > ), site_providers as (
    >   select site_sequence.site_id,
    >       case when sites.site_id is null then 'GAP'
    >             when sites_with_provider_data.site_id is null then 'NO_DATA'
    >             else sites_with_provider_data.master_abbrev end as master_abbrev
    >   from site_sequence
    >   left join tbl_sites as sites using (site_id)
    >   left join sites_with_provider_data using (site_id)
    >   order by site_sequence.site_id
    > ), changes as (
    >     select site_id, master_abbrev,
    >           case
    >           when master_abbrev is not distinct from lag(master_abbrev) over (order by site_id) then 0 else 1
    >       end as new_group
    >     from site_providers	
    >   -- comment out to show sites with no data
    >   where master_abbrev <> 'NO_DATA'
    > ), groups as (
    >     select site_id, master_abbrev, sum(new_group) over (order by site_id rows unbounded preceding) as group_id
    >     from changes
    > )
    >   select
    >     min(site_id) as interval_start,
    >     max(site_id) as interval_end,
    >     master_abbrev
    >   from groups
    >   group by group_id, master_abbrev
    >   order by interval_start;
    > ```

      | interval_start | interval_end | master_abbrev |
      |----------------|--------------|---------------|
      | 1              | 6            | MAL           |
      | 6              | 6            | Lund/KFL      |
      | 7              | 29           | MAL           |
      | 31             | 52           | __gap__       |
      | 53             | 400          | MAL           |
      | 401            | 3402         | __gap__       |
      | 3403           | 3815         | Lund/KFL      |
      | 3816           | 4234         | Lund/Dendro   |
      | 4235           | 5644         | BugsCEP       |
      | 6486           | 6486         | aDNA          |
    
- [x] **0.3** Delivery path decided: **Track A** (corrected 2023 payload), **Track B** (corrective change request), and **Track C** (corrected import ledger). See [Delivery path](#delivery-path-03-decided).
- [x] **0.4** Create branch `site-identity-mismatch-realignment`, and copy the current staging database to a scratch database for validation. Copy it twice more: one copy to build from the corrected payload, and one to restore the ledger snapshot into.

    - [x] Create script `./create-dbs` that sets up the staging databases for validation, corrected payload, and ledger snapshot restore.
    - [x] Create the branch `site-identity-mismatch-realignment`.
    - [x] Run script `./create-dbs`

    > The script reads `PGUSER` and `PGPORT` from `.env` in this folder, dumps `sead_staging` once into `data/sead_staging.sql.gz`, and restores that archive into three scratch databases. Both the archive and `.env` are excluded by `.gitignore`.

    | Scratch database | Purpose |
    | --- | --- |
    | `sead_staging_validation` | Replays the 2023 change request and the Track B change request |
    | `sead_staging_corrected_payload` | Holds a build from the corrected Track A payload |
    | `sead_staging_ledger_snapshot_restore` | Receives the Track C ledger snapshot |

    > The dump covers `public`, `bugs_import`, and `sead_utility`. `sead_utility` is required: the 2023 wrapper calls `sead_utility.sync_sequences` and `sead_utility.set_fk_is_deferrable`, and `bugs_import.post_import_updates()` calls `sync_sequences` as well.

    ```bash
    λ pg_dump --host=127.0.0.1 --dbname=sead_staging --file=data/sead_staging.sql \
            --format=p --lock-wait-timeout=30s \
            --no-tablespaces --no-owner --no-privileges --no-comments \
            --schema=public --schema=bugs_import --schema=sead_utility
    ```

    > Because the dump has no `--create` clause, it restores into an existing empty database rather than dropping one. `create-dbs` creates each scratch database, installs the extensions the dump depends on (`uuid-ossp`, `postgis`, `pgcrypto`, `tablefunc`), loads the archive, and then compares the result with `sead_staging`.

    > The comparison covers tables, foreign keys, extensions, `tbl_sites`, `bugs_trace`, and `bugs_errors` row counts, the `2278` and `4412` presence checks, `TSite` link counts, and both sequence values. All three scratch databases matched the source:

    | Value | `sead_staging` | Each scratch database |
    | --- | ---: | ---: |
    | Tables / foreign keys | 177 / 267 | 177 / 267 |
    | Functions / views | 894 / 18 | 894 / 18 |
    | Extensions | `pgcrypto, plpgsql, postgis, tablefunc, uuid-ossp` | same |
    | `tbl_sites` / `bugs_trace` / `bugs_errors` rows | 3,462 / 703,750 / 1,238 | same |
    | `site_id` `2278` / `4412` | 0 / 1 | 0 / 1 |
    | `site_id` in `2101–3402` | 0 | 0 |
    | `TSite` links / links resolving to a site | 1,410 / 1,410 | 1,410 / 1,410 |
    | `tbl_sites_site_id_seq` / `max(site_id)` | 6486 / 6486 | 6486 / 6486 |

    > `sead_utility.out_of_sync_sequences` raises `currval … is not yet defined` in both the source and the scratch databases, so that is existing behaviour, not a restore defect. `sead_utility.sead_comments` returns no rows because the dump uses `--no-comments`; the table exists but its comments are not copied. Neither affects the replay.


## Phase 1 — Freeze the crosswalk as a reviewable artifact

- [ ] **1.1** Write a one-off generator outside the change-request folder, for example under `tmp/`, that streams both trace sources:
  - 2019: `bugs/archive/deploy/20191221_DML_SUBMISSION_BUGS_20190303_COMMIT/bugs_import_schema.sql.gz`, stored as a PostgreSQL `COPY ... FROM stdin` stream with tab-separated fields.
  - 2023: `bugs/deploy/20231211_DML_SUBMISSION_BUGS_20231219_COMMIT/bugs_import.sql.gz`, stored as `INSERT` statement tuples.
- [ ] **1.2** Emit `site_id_map.tsv` with one row per site key and the columns `bugs_identifier`, `id_2019`, `id_2020`, `id_2023`, `new_id`, `provenance`. Include the 1,410 current keys and the 5 keys that exist only in 2019. Attach it to the issue as audit evidence.
- [ ] **1.3** Assert on the generated map before rewriting anything:
  - [ ] 1,410 rows with unique `new_id`.
  - [ ] `2101–3402` and `5532–5644` do not intersect.
  - [ ] Every child-table `site_id` value from `public.sql.gz` appears in the map.
  - [ ] `SITE000234` maps to `2278`.

## Phase 2 — Rewrite the payloads

Replace only the ID token. Leave row order, `change_date` values, `bugs_trace_id` values, numeric formatting, and all quoted text untouched.

- [ ] **2.1** Rewrite `public.sql.gz` with a parser that respects quoted strings and escaped quotes. The `site_id` position, counting from 1:

  | Table | `site_id` position |
  | --- | ---: |
  | `public.tbl_sites` | 1 |
  | `public.tbl_site_locations` | 3 |
  | `public.tbl_site_references` | 2 |
  | `public.tbl_site_other_records` | 2 |
  | `public.tbl_sample_groups` | 2 |

- [ ] **2.2** Rewrite `bugs_import.sql.gz`: change `sead_reference_id` only where `sead_table = 'tbl_sites'`. Leave the `tbl_site_locations` and `tbl_locations` reference IDs alone, since they are location primary keys, and leave `bugs_data` and `translated_compressed_data` alone, since they hold identifiers rather than target IDs.
- [ ] **2.3** Write the gzip output deterministically, with a fixed modification time and the original file name, so the repository diff shows content changes only.
- [ ] **2.4** Confirm the row counts are unchanged: `tbl_sites` 1,410, `tbl_site_locations` 2,820, `tbl_site_references` 2,165, `tbl_site_other_records` 2,583, `tbl_sample_groups` 1,585.
- [ ] **2.5** Decide what to do with the companion files `public.dcomp`, `bugs_import.dcomp`, `public.xls`, and `bugs_import.xls`. The `.dcomp` files name the source and target schemas used for the comparison, and the `.xls` files are comparison previews. Either regenerate them or state in the change-request notes that they are historical comparison output.

## Phase 3 — Validate before touching Sqitch

- [ ] **3.1** Check the rewritten payloads statically:
  - [ ] Every `tbl_sites.site_id` is unique.
  - [ ] Every child-table `site_id` resolves to a `tbl_sites` row.
  - [ ] `SITE000234` maps to `2278`.
  - [ ] The 113 kept keys keep their 2023 IDs.
  - [ ] No `site_id` falls outside `2101–3402` or `5532–5644`.
- [ ] **3.2** Replay the full 2023 change request against a scratch database:
  - [ ] The wrapper runs unchanged and foreign-key deferral works.
  - [ ] `sync_sequences('public')` leaves `tbl_sites_site_id_seq` at `max(site_id)`.
  - [ ] No orphan `site_id` remains in `tbl_site_locations`, `tbl_sample_groups`, `tbl_site_references`, or `tbl_site_other_records`.
  - [ ] `bugs_import.bugs_trace` rows with `sead_table = 'tbl_sites'` match `tbl_sites.site_id` exactly.
- [ ] **3.3** Replay the Track B change request in both starting states, using the copies from 0.4:
  - [ ] On a database that already holds 2023 IDs, every mapped row moves and `verify/` passes.
  - [ ] On a database built from the corrected payload, no ID changes and `verify/` still passes. This is the no-op case from the delivery decision.
  - [ ] `revert/` returns each database to its starting state, including the no-op case.
  - [ ] Sequence state is left at `max(site_id)` in both cases.
- [ ] **3.4** Restore the Track C ledger snapshot into the third copy and check it:
  - [ ] It holds 703,750 `bugs_trace` rows with the same `bugs_trace_id` values as the payload.
  - [ ] Its 1,410 `TSite` → `tbl_sites` links equal the realigned `tbl_sites.site_id` values.
  - [ ] It holds one `TSite` link per `bugs_identifier`, with no duplicates.

## Phase 4 — Wire into Sqitch

The three deliverables are separate reviewable changes, but they land in one branch and one issue, and they share the Phase 1 crosswalk.

- [ ] **4.1** Track A: replace the two `.gz` payloads in place under `bugs/deploy/20231211_DML_SUBMISSION_BUGS_20231219_COMMIT/`. The `\ir` lines in the wrapper need no change. Add a note to the change-request header recording the realignment, the source of the mapping, the `site_id_map.tsv` artifact, and the fact that the payload of a released change request was corrected.
- [ ] **4.2** Track B: create the corrective change request with `bin/add-change-request` in project `bugs`, for example `YYYYMMDD_DML_REALIGN_BUGS_SITE_IDS`. It must:
  - [ ] Carry the mapping as an embedded `VALUES` list generated from `site_id_map.tsv`, so the change request does not depend on a file outside its own folder.
  - [ ] Defer foreign keys the same way the 2023 wrapper does.
  - [ ] Update `tbl_sites.site_id` and every dependent `site_id` column, including the tables the payload does not cover but the model defines: `tbl_site_natgridrefs`, `tbl_site_images`, `tbl_site_preservation_status`. These are empty in the checked database, so these statements are defensive rather than load-bearing.
  - [ ] Update `bugs_import.bugs_trace.sead_reference_id` for `sead_table = 'tbl_sites'` by joining on `bugs_identifier`, so the statement also corrects a ledger whose links were written by a different database than the one being fixed.
  - [ ] Avoid swap collisions, for example by remapping through negative offsets or a staging column, because the old and new ranges can otherwise overwrite each other mid-update.
  - [ ] Detect the already-realigned state and do nothing in it, so the change request is safe on a database built from the corrected Track A payload.
  - [ ] Call `sync_sequences('public')` after the update.
  - [ ] Ship a real `verify/` script. The current 2023 verify script is an empty placeholder, so this is a good moment to make verification meaningful. It must pass both before and after the update, and state which of the two states it found.
  - [ ] Ship a `revert/` script that reverses the mapping, and that can run after a no-op apply.
- [ ] **4.3** Track C: publish the corrected ledger. It must:
  - [ ] Ship a snapshot of `bugs_import.bugs_trace` with the realigned links, for example `bugs_trace_ledger.sql.gz`, in the Track B change-request folder so the artifact and the change request that produces it stay together.
  - [ ] Derive the snapshot from the payload produced in Phase 2, and cross-check it against the ledger in the Track B scratch database from 3.3. The two must match byte-for-byte in the `TSite` links.
  - [ ] Record in the change-request header that a new Bugs import generation must start from this snapshot, or from a database that already carries the realigned ledger, and never from an empty `bugs_import.bugs_trace`.
  - [ ] Update the generation procedure used for the 2023 import, the copy-and-import steps recorded in issue #162, to name the ledger snapshot as an input.
- [ ] **4.4** Do not modify the 2020 archived change requests under `bugs/archive/deploy/20200313_*`. They are inactive and their IDs conflict with the Dendrochronology 2024 payload.

## Phase 5 — Staging and sign-off

- [ ] **5.1** Deploy to staging with `bin/deploy-staging`.
- [ ] **5.2** Verify on staging:
  - [ ] Glanllynnau is at `2278`.
  - [ ] `4412` is free or reassigned as decided.
  - [ ] Site, sample-group, and site-reference counts are unchanged.
  - [ ] Joins between `tbl_sites` and the dependent tables return no orphans.
  - [ ] A previously broken link such as `browser.sead.se/site/2278` resolves again.
  - [ ] `bugs_import.bugs_trace` holds 1,410 `TSite` → `tbl_sites` links, and each one matches a `tbl_sites.site_id`.
  - [ ] `tbl_sites_site_id_seq` is at `max(site_id)`.
- [ ] **5.3** Build one scratch database from the full plan with the corrected payload, and confirm it lands on the same IDs with no change from Track B. This is the check that Track A and Track B agree, and that a full rebuild does not need the corrective change request to do any work.
- [ ] **5.4** Record in the issue and release notes: the mapping artifact, the SHA-256 hashes of the rewritten `.gz` files and of the ledger snapshot, the correction to the released 2023 change request, and the validation queries used.

## Phase 6 — Follow-up

- [ ] **6.1** Handle external references. Renumbering alone breaks any published URL, export, or citation that still uses the 2023 IDs, so decide between an alias or redirect layer and a documented notice. The IDs vacated in `4235–5531` are part of this decision: reusing them for later sites would recreate the same citation problem, so the default should be to leave them unused.
- [ ] **6.2** Add a pre-import guard to the Bugs import process. The guard must compare `bugs_import.bugs_trace` against the published ledger snapshot before a full import runs, and fail if the table is empty, if a link is missing, or if any `bugs_identifier` resolves to a different `site_id` than the approved one. This is the actual prevention for a repeat of this mismatch, because an empty trace table is the specific condition that produced it.

## Decisions and remaining blockers

The database reads in 0.2 closed three of the four original blockers, and 0.3 closed the fourth for delivery purposes.

| Item | Status | Effect on the plan |
| --- | --- | --- |
| Occupancy of `2101–3402` in the target database | Resolved: 0 rows. The interval reports as `GAP` from `401` to `3402`, so no site row occupies it. | The remap writes the 2019 IDs directly. No alias, redirect, or merge strategy is needed for those 1,297 keys. |
| Whether the earlier site rows were retained or removed | Resolved: removed from the deployed sequence. `2101–3402` is empty and `4235–5644` is the BugsCEP interval. | The correction is a renumbering, not a de-duplication. Only one row exists per site. |
| Rows in `tbl_site_natgridrefs`, `tbl_site_images`, `tbl_site_preservation_status` | Resolved for the checked database: 0 rows in `4235–5644`. | Track B still covers these tables, but for another target database rather than this one. |
| Whether production already applied the 2023 import | Decided: both cases are covered. Track A handles fresh builds, Track B handles databases that already hold the 2023 IDs, and Track B is a no-op in the first case. | No longer gates any phase. |
| Whether `2278` or `4412` is referenced by records created after the 2023 import | Open. Requires the live database and an inventory of published links. | Affects only [Phase 6](#phase-6--follow-up): how much forwarding old links need. Does not block Phases 1–5. |
| Whether vacated IDs in `4235–5531` may be reused for later sites | Open. A release decision, recorded with 6.1. | Affects Phase 6 only. The plan itself leaves them unused. |

## Verification record

- Compared the 2019 and 2023 trace artifacts by parsing both stores: a `COPY` stream for 2019 and `INSERT` tuples for 2023. Counted shared and unique keys, compared target IDs, and computed the proposed target set.
- Parsed the 2023 payload by target table and checked `bugs_trace_id` and `bugs_error_id` continuity, establishing that the generation database's trace table was empty. This identifies the cause rather than only the symptom.
- Cross-checked the 2020 trace change request to confirm its 17 keys appear in 2023 with a uniform offset and are the only historical source for those keys.
- Read the Dendrochronology 2024 site payload to confirm the `3816–4234` range conflict.
- Confirmed that all child-table `site_id` values in the 2023 payload resolve to a `tbl_sites` row, and that `site_preservation_status_id` is `NULL` for all 1,410 site rows.
- Scanned change requests after the 2023 import for hardcoded site IDs. Only `general/deploy/20241028_DML_UPDATE_INCORRECT_COORDINATES.sql` touches site rows, and it matches by name.
- Ran the read-only checks listed in 0.2 against the target database and recorded their results there: `2101–3402` empty, `5532–5644` holding exactly 113 sites, the three uncovered child tables empty in `4235–5644`, and only `4412` present from the pair `2278` and `4412`.
- Built the three scratch databases in 0.4 and compared each one against `sead_staging`: identical table, foreign-key, function, view, and extension counts, identical `tbl_sites`, `bugs_trace`, and `bugs_errors` row counts, identical `TSite` link counts, and identical sequence values. The comparison runs inside `create-dbs`, so a failed or partial restore stops the script.
- No source, payload, or database row was modified.
