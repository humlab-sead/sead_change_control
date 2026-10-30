#!/usr/bin/env python3
"""Build the Bugs site-ID crosswalk used by the site-ID realignment plan.

This implements Phase 1 of ``realignment-plan.md``. It reads the Bugs import
artefacts committed in this repository and writes ``site_id_map.tsv``: one row
per Bugs site source key, with the SEAD site ID that each snapshot assigned and
the ID the realignment will apply.

Inputs, all read-only:

===================================  ==========================
2019 full-import snapshot            ``COPY`` stream, tab separated
2020 incremental trace change request  ``INSERT`` tuples
2023 full-import trace payload       ``INSERT`` tuples
2023 full-import public payload      ``INSERT`` tuples, child tables
===================================  ==========================

The run opens no database and modifies no payload. It fails with a non-zero
exit status if any expected fact about the artefacts does not hold, so the
crosswalk cannot be produced from a payload that differs from the one the plan
describes.

``provenance`` values:

``2019``
    The key appears in both the 2019 and 2023 snapshots. ``new_id`` is the 2019
    assignment.
``2023``
    The key appears only in the 2023 payload. ``new_id`` is the current 2023
    assignment, because no earlier assignment is available to restore.
``2019-only``
    The key appears only in the 2019 snapshot and has dropped out of the source
    data. ``new_id`` is empty and the key is not reintroduced.
"""

from __future__ import annotations

import argparse
import csv
import gzip
import re
import sys
from collections import Counter
from collections.abc import Iterable, Iterator
from dataclasses import dataclass
from pathlib import Path

TRACE_2019 = "bugs/archive/deploy/20191221_DML_SUBMISSION_BUGS_20190303_COMMIT/bugs_import_schema.sql.gz"
TRACE_2020 = "bugs/archive/deploy/20200313_DML_BUGS_IMPORT_TRACE_20200219.sql"
TRACE_2023 = "bugs/deploy/20231211_DML_SUBMISSION_BUGS_20231219_COMMIT/bugs_import.sql.gz"
PUBLIC_2023 = "bugs/deploy/20231211_DML_SUBMISSION_BUGS_20231219_COMMIT/public.sql.gz"

TRACE_TABLE = "bugs_import.bugs_trace"
PUBLIC_SCHEMA = "public"

SITE_TABLE = "tbl_sites"
BUGS_SITE_TABLE = "TSite"

# Position of each column this script needs, counting from 0, in the
# bugs_import.bugs_trace projection used by all three trace artefacts.
TRACE_COLUMNS = (
    "bugs_trace_id",
    "bugs_table",
    "bugs_data",
    "bugs_identifier",
    "sead_table",
    "sead_reference_id",
    "change_date",
    "manipulation_type",
    "translated_compressed_data",
)
TRACE_BUGS_TABLE = TRACE_COLUMNS.index("bugs_table")
TRACE_BUGS_IDENTIFIER = TRACE_COLUMNS.index("bugs_identifier")
TRACE_SEAD_TABLE = TRACE_COLUMNS.index("sead_table")
TRACE_SEAD_REFERENCE_ID = TRACE_COLUMNS.index("sead_reference_id")

# Position of site_id, counting from 0, in each 2023 public payload table that
# carries the column. Taken from realignment-plan.md.
PUBLIC_SITE_ID_POSITION = {
    "tbl_sites": 0,
    "tbl_site_locations": 2,
    "tbl_site_references": 1,
    "tbl_site_other_records": 1,
    "tbl_sample_groups": 1,
}
PUBLIC_CHILD_TABLES = tuple(name for name in PUBLIC_SITE_ID_POSITION if name != SITE_TABLE)

# Facts the plan records as verified. Each one is re-checked so that the
# crosswalk cannot be built silently from a changed payload.
EXPECTED_SHARED_KEYS = 1297
EXPECTED_2023_ONLY_KEYS = 113
EXPECTED_2019_ONLY_SITE_IDS = (2891, 2914, 3369, 3381, 3382)

EXPECTED_TRACE_2019_ROWS = 627_666
EXPECTED_TRACE_2023_ROWS = 703_750
EXPECTED_ERRORS_2023_ROWS = 1_238
EXPECTED_TRACE_2023_STATEMENTS = 530
EXPECTED_SITE_LINKS_2019 = 1_302
EXPECTED_SITE_LINKS_2020 = 17
EXPECTED_SITE_LINKS_2023 = 1_410
EXPECTED_CURRENT_SITE_IDS = 1_410

# TSite rows that map to something other than a site row. They are reported so
# the exclusion is visible rather than implied. Phase 2.2 must leave these
# reference ids untouched because they are location primary keys.
EXPECTED_TRACE_2019_NON_SITE_LINKS = {"tbl_site_locations": 2_604, "tbl_locations": 298}
EXPECTED_TRACE_2023_NON_SITE_LINKS = {"tbl_site_locations": 2_820, "tbl_locations": 337}
EXPECTED_TRACE_2020_SITE_ID_RANGE = (3_816, 3_832)
EXPECTED_RESTORED_RANGE = (2_101, 3_402)
EXPECTED_KEPT_RANGE = (5_532, 5_644)
EXPECTED_VACATED_RANGE = (4_235, 5_531)
GLANLLYNNAU_KEY = "SITE000234"
GLANLLYNNAU_EXPECTED_SITE_ID = 2_278

STATEMENT_HEADER = re.compile(
    r"INSERT\s+INTO\s+([A-Za-z_][A-Za-z0-9_.]*)\s*\(([^)]*)\)\s*VALUES",
    re.IGNORECASE,
)
COPY_HEADER = re.compile(r"^COPY\s+([A-Za-z_][A-Za-z0-9_.]*)\s*\(", re.IGNORECASE)


class Report:
    """Collects pass and fail results and prints a summary."""

    def __init__(self) -> None:
        self.failures: list[str] = []

    def expect(self, condition: object, label: str, detail: str = "") -> bool:
        if condition:
            print(f"  ok    {label}")
            return True
        message = f"{label}{f' ({detail})' if detail else ''}"
        self.failures.append(message)
        print(f"  FAIL  {message}")
        return False

    def finish(self) -> int:
        if self.failures:
            print(f"\n{len(self.failures)} check(s) failed:", file=sys.stderr)
            for failure in self.failures:
                print(f"  - {failure}", file=sys.stderr)
            return 1
        print("\nAll checks passed.")
        return 0


class TupleScanner:
    """Splits PostgreSQL ``INSERT ... VALUES`` tuples into decoded fields.

    Handles the two quoting forms that appear in these payloads: standard
    strings with doubled quotes, and ``E'...'`` strings with backslash escapes.
    Values are returned with their string delimiters removed and escapes left
    as written, which is enough for the identifier and integer columns this
    script reads.
    """

    __slots__ = (
        "current",
        "escape_string",
        "fields",
        "finished",
        "in_string",
        "pending_escape",
        "quote_pending",
    )

    def __init__(self) -> None:
        self.fields: list[str] | None = None
        self.current: list[str] = []
        self.in_string = False
        self.escape_string = False
        self.quote_pending = False
        self.pending_escape = False
        self.finished = False

    def feed(self, text: str) -> list[list[str]]:
        completed: list[list[str]] = []
        index = 0
        length = len(text)
        while index < length and not self.finished:
            char = text[index]

            if self.pending_escape:
                self.current.append(char)
                self.pending_escape = False
                index += 1
                continue

            if self.quote_pending:
                self.quote_pending = False
                if char == "'":
                    self.current.append("''")
                    index += 1
                    continue
                self.in_string = False
                self.escape_string = False
                continue

            if self.in_string:
                if self.escape_string and char == "\\":
                    self.current.append(char)
                    self.pending_escape = True
                    index += 1
                    continue
                if char == "'":
                    self.quote_pending = True
                    index += 1
                    continue
                self.current.append(char)
                index += 1
                continue

            if char == "'":
                prefix = "".join(self.current).strip()
                if prefix in ("E", "e"):
                    self.current = []
                    self.escape_string = True
                else:
                    self.escape_string = False
                self.in_string = True
                index += 1
                continue
            if char == "(":
                if self.fields is not None:
                    raise ValueError("nested VALUES tuple")
                self.fields = []
                self.current = []
                index += 1
                continue
            if char == ",":
                if self.fields is not None:
                    self.fields.append("".join(self.current))
                    self.current = []
                index += 1
                continue
            if char == ")":
                if self.fields is not None:
                    self.fields.append("".join(self.current))
                    completed.append(self.fields)
                    self.fields = None
                    self.current = []
                index += 1
                continue
            if char == ";" and self.fields is None:
                self.finished = True
                index += 1
                continue
            if self.fields is not None:
                self.current.append(char)
            index += 1

        return completed


@dataclass(frozen=True)
class TraceRow:
    """One row of ``bugs_import.bugs_trace``."""

    bugs_table: str
    bugs_identifier: str
    sead_table: str
    sead_reference_id: int | None


def find_repo_root(start: Path) -> Path:
    """Return the repository root that contains ``projects.txt`` and ``bugs/``."""
    for candidate in (start, *start.parents):
        if (candidate / "projects.txt").is_file() and (candidate / "bugs" / "sqitch.plan").is_file():
            return candidate
    raise SystemExit(f"error: could not locate the repository root from {start}")


def open_text(path: Path) -> Iterator[str]:
    """Yield decoded lines from a plain or gzip-compressed file."""
    if path.suffix == ".gz":
        with gzip.open(path, "rt", encoding="utf-8", newline="") as handle:
            yield from handle
        return
    with path.open("rt", encoding="utf-8", newline="") as handle:
        yield from handle


def scan_insert_dump(path: Path, wanted_table: str) -> tuple[list[list[str]], Counter[str], Counter[str]]:
    """Return one table's tuples plus per-table statement and row counts.

    Every ``INSERT`` statement in these payloads starts on its own line, so the
    dump is read line by line and each statement is handed to a scanner. A
    statement can hold many rows, so statement and row counts are tracked
    separately.
    """
    tuples: list[list[str]] = []
    statements: Counter[str] = Counter()
    row_counts: Counter[str] = Counter()
    table: str | None = None
    scanner: TupleScanner | None = None

    for line in open_text(path):
        if scanner is None:
            match = STATEMENT_HEADER.search(line)
            if match is None:
                continue
            table = match.group(1).lower()
            statements[table] += 1
            scanner = TupleScanner()
            remainder = line[match.end() :]
            if remainder:
                for fields in scanner.feed(remainder):
                    row_counts[table] += 1
                    if table == wanted_table:
                        tuples.append(fields)
            if scanner.finished:
                scanner = None
            continue

        for fields in scanner.feed(line):
            row_counts[table] += 1
            if table == wanted_table:
                tuples.append(fields)
        if scanner.finished:
            scanner = None

    return tuples, statements, row_counts


def scan_copy_block(path: Path, wanted_table: str) -> Iterator[list[str]]:
    """Yield the rows of one ``COPY ... FROM stdin`` block."""
    header = re.compile(rf"^COPY\s+{re.escape(wanted_table)}\s*\(", re.IGNORECASE)
    inside = False
    for line in open_text(path):
        if not inside:
            if header.match(line):
                inside = True
            continue
        stripped = line.rstrip("\r\n")
        if stripped == "\\.":
            return
        yield stripped.split("\t")


def copy_value(raw: str) -> str | None:
    """Convert one ``COPY`` text field to text, treating ``\\N`` as null."""
    return None if raw == "\\N" else raw


def as_int(raw: str | None, label: str) -> int | None:
    """Convert a payload field to an integer, allowing ``NULL`` and empty values."""
    if raw is None or raw == "" or raw.upper() == "NULL":
        return None
    try:
        return int(raw)
    except ValueError as error:
        raise SystemExit(f"error: expected an integer for {label}, found {raw!r}") from error


def trace_row_from_insert(fields: list[str], label: str) -> TraceRow:
    if len(fields) != len(TRACE_COLUMNS):
        raise SystemExit(f"error: {label}: expected {len(TRACE_COLUMNS)} fields, found {len(fields)}")
    return TraceRow(
        bugs_table=fields[TRACE_BUGS_TABLE],
        bugs_identifier=fields[TRACE_BUGS_IDENTIFIER],
        sead_table=fields[TRACE_SEAD_TABLE],
        sead_reference_id=as_int(fields[TRACE_SEAD_REFERENCE_ID], f"{label} sead_reference_id"),
    )


def trace_row_from_copy(fields: list[str], label: str) -> TraceRow:
    if len(fields) != len(TRACE_COLUMNS):
        raise SystemExit(f"error: {label}: expected {len(TRACE_COLUMNS)} fields, found {len(fields)}")
    return TraceRow(
        bugs_table=copy_value(fields[TRACE_BUGS_TABLE]) or "",
        bugs_identifier=copy_value(fields[TRACE_BUGS_IDENTIFIER]) or "",
        sead_table=copy_value(fields[TRACE_SEAD_TABLE]) or "",
        sead_reference_id=as_int(copy_value(fields[TRACE_SEAD_REFERENCE_ID]), f"{label} sead_reference_id"),
    )


def site_links(rows: Iterable[TraceRow]) -> tuple[dict[str, int], Counter[str]]:
    """Return ``bugs_identifier -> sead_reference_id`` for Bugs site rows.

    Only rows whose Bugs table is a site and whose target table is the site
    table are links to a site row. In the 2019 snapshot most ``TSite`` rows
    point at location tables, so both conditions are required.
    """
    links: dict[str, int] = {}
    target_tables: Counter[str] = Counter()
    for row in rows:
        if row.bugs_table != BUGS_SITE_TABLE:
            continue
        target_tables[row.sead_table] += 1
        if row.sead_table != SITE_TABLE:
            continue
        if row.sead_reference_id is None:
            raise SystemExit(f"error: site link for {row.bugs_identifier} has no target id")
        if row.bugs_identifier in links:
            raise SystemExit(f"error: duplicate site link for {row.bugs_identifier}")
        links[row.bugs_identifier] = row.sead_reference_id
    return links, target_tables


def public_site_ids(path: Path) -> dict[str, list[int | None]]:
    """Return ``table -> site_id`` values from the 2023 public payload."""
    collected: dict[str, list[int | None]] = {name: [] for name in PUBLIC_SITE_ID_POSITION}
    table: str | None = None
    scanner: TupleScanner | None = None

    for line in open_text(path):
        if scanner is None:
            match = STATEMENT_HEADER.search(line)
            if match is None:
                continue
            qualified = match.group(1).lower()
            schema, _, name = qualified.rpartition(".")
            table = name if schema == PUBLIC_SCHEMA and name in PUBLIC_SITE_ID_POSITION else None
            scanner = TupleScanner()
            remainder = line[match.end() :]
            if remainder:
                _absorb_public(scanner.feed(remainder), table, collected)
            if scanner.finished:
                scanner = None
                table = None
            continue

        _absorb_public(scanner.feed(line), table, collected)
        if scanner.finished:
            scanner = None
            table = None

    return collected


def _absorb_public(rows: Iterable[list[str]], table: str | None, collected: dict[str, list[int | None]]) -> None:
    if table is None:
        return
    position = PUBLIC_SITE_ID_POSITION[table]
    for fields in rows:
        if len(fields) <= position:
            raise SystemExit(f"error: public.{table}: expected at least {position + 1} fields, found {len(fields)}")
        collected[table].append(as_int(fields[position], f"public.{table}.site_id"))


def build_map(links_2019: dict[str, int], links_2020: dict[str, int], links_2023: dict[str, int]):
    """Return the crosswalk rows sorted by Bugs source key.

    Only keys that are still present in the 2023 payload receive a target id.
    Keys that appear only in the 2019 snapshot have left the source data, so
    they are listed for audit but are not reintroduced.
    """
    rows: list[dict[str, str]] = []
    for key in sorted(set(links_2019) | set(links_2023)):
        id_2019 = links_2019.get(key)
        id_2023 = links_2023.get(key)
        if id_2023 is None:
            new_id: int | None = None
            provenance = "2019-only"
        elif id_2019 is not None:
            new_id = id_2019
            provenance = "2019"
        else:
            new_id = id_2023
            provenance = "2023"
        rows.append(
            {
                "bugs_identifier": key,
                "id_2019": "" if id_2019 is None else str(id_2019),
                "id_2020": "" if key not in links_2020 else str(links_2020[key]),
                "id_2023": "" if id_2023 is None else str(id_2023),
                "new_id": "" if new_id is None else str(new_id),
                "provenance": provenance,
            }
        )
    return rows


def write_map(path: Path, rows: list[dict[str, str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fieldnames = ["bugs_identifier", "id_2019", "id_2020", "id_2023", "new_id", "provenance"]
    with path.open("wt", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, delimiter="\t", lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument(
        "--output",
        type=Path,
        help="path for the generated crosswalk (default: site_id_map.tsv beside this investigation folder)",
    )
    args = parser.parse_args(argv)

    root = find_repo_root(Path(__file__).resolve().parent)
    investigation = Path(__file__).resolve().parent
    output = args.output or investigation / "site_id_map.tsv"

    report = Report()
    print(f"repository root: {root}")
    print(f"output:          {output}")

    print("\n[1/4] reading the 2019 full-import snapshot")
    rows_2019 = [trace_row_from_copy(fields, f"{TRACE_2019} row") for fields in scan_copy_block(root / TRACE_2019, TRACE_TABLE)]
    links_2019, targets_2019 = site_links(rows_2019)
    print(f"       {len(rows_2019):,} trace rows, {len(links_2019):,} site links")

    print("[2/4] reading the 2020 incremental trace change request")
    tuples_2020, _, _ = scan_insert_dump(root / TRACE_2020, TRACE_TABLE)
    links_2020, targets_2020 = site_links(trace_row_from_insert(f, f"{TRACE_2020} tuple") for f in tuples_2020)
    print(f"       {len(tuples_2020):,} trace tuples, {len(links_2020):,} site links")

    print("[3/4] reading the 2023 full-import payload")
    tuples_2023, statements_2023, row_counts_2023 = scan_insert_dump(root / TRACE_2023, TRACE_TABLE)
    links_2023, targets_2023 = site_links(trace_row_from_insert(f, f"{TRACE_2023} tuple") for f in tuples_2023)
    errors_2023 = row_counts_2023.get("bugs_import.bugs_errors", 0)
    print(f"       {len(tuples_2023):,} trace tuples, {len(links_2023):,} site links")

    print("[4/4] reading the 2023 public payload")
    public_ids = public_site_ids(root / PUBLIC_2023)
    for name in PUBLIC_SITE_ID_POSITION:
        print(f"       public.{name}: {len(public_ids[name]):,} rows")

    print("\nchecks")
    report.expect(len(rows_2019) == EXPECTED_TRACE_2019_ROWS, "2019 trace row count", f"{len(rows_2019):,} != {EXPECTED_TRACE_2019_ROWS:,}")
    report.expect(len(links_2019) == EXPECTED_SITE_LINKS_2019, "2019 site link count", f"{len(links_2019):,} != {EXPECTED_SITE_LINKS_2019:,}")
    report.expect(len(links_2020) == EXPECTED_SITE_LINKS_2020, "2020 site link count", f"{len(links_2020):,} != {EXPECTED_SITE_LINKS_2020:,}")
    report.expect(len(tuples_2023) == EXPECTED_TRACE_2023_ROWS, "2023 trace tuple count", f"{len(tuples_2023):,} != {EXPECTED_TRACE_2023_ROWS:,}")
    report.expect(len(links_2023) == EXPECTED_SITE_LINKS_2023, "2023 site link count", f"{len(links_2023):,} != {EXPECTED_SITE_LINKS_2023:,}")
    report.expect(
        statements_2023.get(TRACE_TABLE, 0) == EXPECTED_TRACE_2023_STATEMENTS,
        "2023 bugs_trace statement count",
        f"{statements_2023.get(TRACE_TABLE, 0):,} != {EXPECTED_TRACE_2023_STATEMENTS:,}",
    )
    report.expect(errors_2023 == EXPECTED_ERRORS_2023_ROWS, "2023 bugs_errors row count", f"{errors_2023:,} != {EXPECTED_ERRORS_2023_ROWS:,}")

    for table, expected in EXPECTED_TRACE_2019_NON_SITE_LINKS.items():
        report.expect(
            targets_2019[table] == expected,
            f"2019 TSite -> {table} rows excluded",
            f"{targets_2019[table]:,} != {expected:,}",
        )
    report.expect(
        sorted(targets_2019) == sorted([SITE_TABLE, *EXPECTED_TRACE_2019_NON_SITE_LINKS]),
        "2019 TSite target tables",
        f"found {sorted(targets_2019)}",
    )
    for table, expected in EXPECTED_TRACE_2023_NON_SITE_LINKS.items():
        report.expect(
            targets_2023[table] == expected,
            f"2023 TSite -> {table} rows excluded",
            f"{targets_2023[table]:,} != {expected:,}",
        )
    report.expect(
        sorted(targets_2023) == sorted([SITE_TABLE, *EXPECTED_TRACE_2023_NON_SITE_LINKS]),
        "2023 TSite target tables",
        f"found {sorted(targets_2023)}",
    )

    if links_2020:
        report.expect(
            (min(links_2020.values()), max(links_2020.values())) == EXPECTED_TRACE_2020_SITE_ID_RANGE,
            "2020 site id range",
            f"{min(links_2020.values())}-{max(links_2020.values())}",
        )
    report.expect(
        not (set(links_2020) & set(links_2019)),
        "no 2020 key appears in the 2019 snapshot",
    )
    report.expect(
        targets_2020.get(SITE_TABLE, 0) == len(links_2020),
        "2020 TSite rows all target tbl_sites",
        f"{targets_2020.get(SITE_TABLE, 0):,} of {len(links_2020):,}",
    )

    shared = set(links_2019) & set(links_2023)
    only_2023 = set(links_2023) - set(links_2019)
    only_2019 = set(links_2019) - set(links_2023)
    report.expect(len(shared) == EXPECTED_SHARED_KEYS, "shared key count", f"{len(shared):,} != {EXPECTED_SHARED_KEYS:,}")
    report.expect(len(only_2023) == EXPECTED_2023_ONLY_KEYS, "2023-only key count", f"{len(only_2023):,} != {EXPECTED_2023_ONLY_KEYS:,}")
    report.expect(
        tuple(sorted(links_2019[key] for key in only_2019)) == EXPECTED_2019_ONLY_SITE_IDS,
        "2019-only key site ids",
        f"{sorted(links_2019[key] for key in only_2019)}",
    )
    report.expect(
        all(links_2019[key] != links_2023[key] for key in shared),
        "every shared key changed its site id between 2019 and 2023",
    )

    rows = build_map(links_2019, links_2020, links_2023)
    mapped = [row for row in rows if row["new_id"]]
    new_ids = [int(row["new_id"]) for row in mapped]
    restored = [int(row["new_id"]) for row in mapped if row["provenance"] == "2019"]
    kept = [int(row["new_id"]) for row in mapped if row["provenance"] == "2023"]
    dropped = [row["bugs_identifier"] for row in rows if row["provenance"] == "2019-only"]
    vacated = [links_2023[key] for key in sorted(shared)]

    report.expect(len(rows) == EXPECTED_SITE_LINKS_2023 + len(only_2019), "crosswalk row count", f"{len(rows):,}")
    report.expect(len(mapped) == EXPECTED_CURRENT_SITE_IDS, "crosswalk rows with a target id", f"{len(mapped):,}")
    report.expect(len(dropped) == len(only_2019), "crosswalk rows without a target id", f"{len(dropped):,}")
    report.expect(len(set(new_ids)) == len(new_ids), "crosswalk target ids are unique")
    report.expect(len(restored) == EXPECTED_SHARED_KEYS, "restored id count", f"{len(restored):,}")
    report.expect(len(kept) == EXPECTED_2023_ONLY_KEYS, "kept id count", f"{len(kept):,}")

    restored_range = (min(restored), max(restored)) if restored else (0, 0)
    kept_range = (min(kept), max(kept)) if kept else (0, 0)
    report.expect(restored_range == EXPECTED_RESTORED_RANGE, "restored id range", f"{restored_range[0]}-{restored_range[1]}")
    report.expect(kept_range == EXPECTED_KEPT_RANGE, "kept id range", f"{kept_range[0]}-{kept_range[1]}")
    report.expect(not (set(restored) & set(kept)), "restored and kept id ranges do not intersect")
    report.expect(
        not (set(new_ids) & set(vacated)),
        "no realigned id collides with an id it vacates",
        f"{len(set(new_ids) & set(vacated))} collisions",
    )
    report.expect(
        (min(vacated), max(vacated)) == EXPECTED_VACATED_RANGE,
        "vacated id range",
        f"{min(vacated)}-{max(vacated)}",
    )

    glanllynnau = next((row for row in rows if row["bugs_identifier"] == GLANLLYNNAU_KEY), None)
    report.expect(
        glanllynnau is not None and glanllynnau["new_id"] == str(GLANLLYNNAU_EXPECTED_SITE_ID),
        f"{GLANLLYNNAU_KEY} maps to {GLANLLYNNAU_EXPECTED_SITE_ID}",
        f"found {glanllynnau['new_id'] if glanllynnau else 'nothing'}",
    )

    payload_sites = public_ids[SITE_TABLE]
    payload_site_set = set(payload_sites)
    report.expect(
        len(payload_sites) == EXPECTED_CURRENT_SITE_IDS,
        "2023 payload tbl_sites row count",
        f"{len(payload_sites):,} != {EXPECTED_CURRENT_SITE_IDS:,}",
    )
    report.expect(
        len(payload_site_set) == len(payload_sites),
        "2023 payload tbl_sites.site_id is unique",
    )
    report.expect(
        payload_site_set == set(links_2023.values()),
        "2023 payload tbl_sites.site_id matches the trace site links",
        f"{len(payload_site_set - set(links_2023.values()))} payload ids without a trace link",
    )

    for table in PUBLIC_CHILD_TABLES:
        child_ids = {value for value in public_ids[table] if value is not None}
        # The payload carries the current 2023 ids. The crosswalk covers them in
        # the id_2023 column, which is what Phase 2 rewrites from.
        missing = child_ids - payload_site_set
        report.expect(
            not missing,
            f"every public.{table}.site_id is a current 2023 site row",
            f"{len(missing)} missing: {sorted(missing)[:5]}",
        )

    status = report.finish()
    if status != 0:
        return status

    write_map(output, rows)
    print(f"Wrote {output} ({len(rows):,} rows).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
