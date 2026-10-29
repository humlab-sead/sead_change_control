# Summary: why a SEAD site number changed between data imports

**Related:** [brief.md](./brief.md), [findings.md](./findings.md), [realignment-plan.md](./realignment-plan.md)  
**Status:** Summary for readers who work with the data rather than the code. Cause established at the level of the import files; live database state not checked. No data was changed.  
**Baseline:** `humlab-sead/sead_change_control`, branch `dev`, inspected at `ddc2aad722912db002711823ea783c1bbbf08573`.  
**Date written:** 2026-10-28

## What was reported

The same archaeological site, Glanllynnau, was reachable at one SEAD address in 2019 and a different one in 2023: `site/2278` versus `site/4412`.

## What is not wrong

The site records themselves are consistent. For Glanllynnau, name, county, national grid reference, latitude, longitude, and description are identical in both versions of the data. Nothing about the archaeology changed.

The number of sites also changed for a second, unrelated reason: five sites present in the 2019 source data no longer appear in the newer BugsCEP data. That is a change in the source dataset, not a numbering fault.

## What did change

The SEAD site number. In SEAD, `site_id` is not a property of the site. It is the order in which the record was written into the database when the data was imported.

The 2023 BugsCEP import ran against an empty import ledger. The ledger is the import's own record of what it has already written, for example "Bugs site `SITE000234` was stored as SEAD site 2278". With that record empty, every Bugs site looked new. Instead of recognising a site it had seen before, the import inserted it again and the database handed out a new number. The site-number counter also started from a different point, because it had not been reset.

The consequence is systematic rather than isolated:

- No site was matched to its earlier record. All 1,297 sites carried over from 2019 received a new number.
- The 2023 import also added 113 sites that were not in the 2019 data, so the total grew from 1,302 to 1,410.
- Every site number in the 2019 import falls between 2101 and 3402. Every site number in the 2023 import falls between 4235 and 5644.

The import's log entries run in one continuous block from 2 to 703,751. They do not resume after entry 627,683, which is where the 2019 and 2020 imports had stopped. That gap is the direct evidence that the ledger was empty.

## Why it matters

A SEAD site number has been used in citations, bookmarks, and pasted into publications. A number that is reassigned by a re-import cannot serve as a permanent identifier, even when the underlying data is unchanged.

## How it can be resolved

The Bugs source data carries its own stable site code. Glanllynnau is `SITE000234` in every version. Each import also kept a cross-reference table recording which SEAD row each Bugs site code was written to, so a reliable and verifiable link exists between the old and new numbers.

1. Use the Bugs site code as the matching key and build a one-off lookup: `SITE000234` maps to `2278` in the 2019 records and to `4412` in the 2023 records.
2. Apply that lookup to the 2023 import files, so the import reuses the original 2019 numbers.
3. Leave the 113 sites that first appear after 2019 with their current numbers, because they have no earlier identity to restore.
4. Before deployment, confirm in the live database that the original number range is free, and check the supplementary site tables that the import does not itself fill.
5. Afterwards, decide how to handle older published links that already point at the 2023 numbers. A redirect is the usual answer.
6. Add a check to the import routine that flags any site whose number changes between imports, so this cannot recur silently.

## Caveat

This restores consistency between two versions of the import data. Three things still require a database check before anyone relies on it:

- Whether the live database has been affected the same way.
- Whether the earlier site rows still exist. If they were never removed, the database may now hold **two records for the same site**, one at the 2019 number and one at the 2023 number. That is a different problem from a renumbering, and it changes the fix.
- Whether either number is currently assigned to another site.

That check is the first step, not an afterthought.

## Basis

The statements above come from comparing the two committed import files in the change-control repository: the 2019 archived submission and the 2023 full import. No database query was run, and no data was modified. Detailed steps for a correction are in [realignment-plan.md](./realignment-plan.md).
