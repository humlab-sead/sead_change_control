#!/usr/bin/env python3
"""Read the SEAD comment catalog, export SQL, and compare it with a database schema."""

from __future__ import annotations

import argparse
import csv
import fnmatch
import io
import os
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Optional, Sequence

SCRIPT_DIR: Path = Path(__file__).resolve().parent
REPOSITORY_ROOT: Path = SCRIPT_DIR.parents[1]
DEFAULT_CATALOG: Path = REPOSITORY_ROOT / "resources" / "tables_and_columns.csv"
CATALOG_FIELDS = (
    "schema_name",
    "entity_name",
    "table_name",
    "column_name",
    "comment",
    "is_pk",
    "is_fk",
)
REQUIRED_FIELDS: set[str] = set(CATALOG_FIELDS)

# pylint: disable=missing-class-docstring,missing-function-docstring,line-too-long

class CatalogError(Exception):
    """Raised when the comment catalog is invalid."""


@dataclass(frozen=True)
class CatalogEntry:
    schema_name: str
    entity_name: str
    table_name: str
    column_name: str
    comment: str
    is_pk: str = ""
    is_fk: str = ""

    @property
    def object_type(self) -> str:
        return "column" if self.column_name else "table"

    @property
    def key(self) -> tuple[str, str, str, str]:
        return (self.object_type, self.schema_name, self.table_name, self.column_name)


@dataclass(frozen=True)
class DatabaseObject:
    object_type: str
    schema_name: str
    table_name: str
    column_name: str
    comment: str
    is_pk: str = ""
    is_fk: str = ""

    @property
    def key(self) -> tuple[str, str, str, str]:
        return (self.object_type, self.schema_name, self.table_name, self.column_name)


@dataclass(frozen=True)
class ExclusionPattern:
    table_expression: str
    column_expression: Optional[str] = None

    def matches(self, item: CatalogEntry | DatabaseObject) -> bool:
        if not fnmatch.fnmatchcase(item.table_name, self.table_expression):
            return False
        if self.column_expression is None:
            return True
        return bool(item.column_name) and fnmatch.fnmatchcase(item.column_name, self.column_expression)


@dataclass(frozen=True)
class Reconciliation:
    missing_from_catalog: list[DatabaseObject]
    missing_from_database: list[CatalogEntry]
    differing_comments: list[tuple[CatalogEntry, DatabaseObject]]
    blank_catalog_comments: list[tuple[CatalogEntry, DatabaseObject]]


def load_catalog(path: Path, schema: Optional[str] = None) -> list[CatalogEntry]:
    """Reads and validates catalog rows, optionally selecting one schema."""
    entries: list[CatalogEntry] = []
    seen: set[tuple[str, str, str, str]] = set()

    try:
        catalog_file = path.open(newline="", encoding="utf-8-sig")
    except OSError as error:
        raise CatalogError(f"Cannot read catalog {path}: {error}") from error

    with catalog_file:
        reader = csv.DictReader(catalog_file, delimiter=";")
        if reader.fieldnames is None:
            raise CatalogError(f"Catalog is empty: {path}")
        if len(reader.fieldnames) != len(set(reader.fieldnames)):
            raise CatalogError("Catalog header contains duplicate column names")

        missing_fields: set[str] = REQUIRED_FIELDS - set(reader.fieldnames)
        if missing_fields:
            missing = ", ".join(sorted(missing_fields))
            raise CatalogError(f"Catalog is missing required columns: {missing}")

        for row in reader:
            line_number = reader.line_num
            if row.get(None) is not None:
                raise CatalogError(f"Catalog row ending at line {line_number} has extra fields")
            if all(not (value or "").strip() for value in row.values()):
                continue

            schema_name = (row.get("schema_name") or "").strip()
            entity_name = (row.get("entity_name") or "").strip()
            table_name = (row.get("table_name") or "").strip()
            column_name = (row.get("column_name") or "").strip()
            comment = (row.get("comment") or "").strip()
            is_pk = (row.get("is_pk") or "").strip()
            is_fk = (row.get("is_fk") or "").strip()

            if not schema_name or not table_name:
                raise CatalogError(f"Catalog row ending at line {line_number} needs a schema and table name")
            if column_name and entity_name:
                raise CatalogError(
                    f"Catalog row ending at line {line_number} cannot describe both a table and a column"
                )
            if not column_name and not entity_name:
                raise CatalogError(
                    f"Catalog row ending at line {line_number} needs an entity name for a table comment"
                )

            entry = CatalogEntry(schema_name, entity_name, table_name, column_name, comment, is_pk, is_fk)
            if schema is not None and schema_name != schema:
                continue
            if entry.key in seen:
                raise CatalogError(
                    f"Duplicate {entry.object_type} entry at line {line_number}: "
                    f"{schema_name}.{table_name}{'.' + column_name if column_name else ''}"
                )
            seen.add(entry.key)
            entries.append(entry)

    return entries


def load_exclusions(path: Path) -> list[ExclusionPattern]:
    """Reads newline-delimited table or table-and-column exclusion expressions."""
    patterns: list[ExclusionPattern] = []
    try:
        with path.open(encoding="utf-8-sig") as exclusions_file:
            for line_number, line in enumerate(exclusions_file, start=1):
                expression = line.strip()
                if not expression:
                    continue

                parts = expression.split(".")
                if (
                    len(parts) > 2
                    or not parts[0]
                    or (len(parts) == 2 and not parts[1])
                    or any(character in expression for character in "?[]")
                ):
                    raise CatalogError(
                        f"Invalid exclusion expression at {path}:{line_number}: {expression!r}; "
                        "use <table-expr>[.column-expr] and '*' as the only wildcard"
                    )

                patterns.append(ExclusionPattern(parts[0], parts[1] if len(parts) == 2 else None))
    except OSError as error:
        raise CatalogError(f"Cannot read exclusions file {path}: {error}") from error
    return patterns


def is_excluded(item: CatalogEntry | DatabaseObject, patterns: Sequence[ExclusionPattern]) -> bool:
    return any(pattern.matches(item) for pattern in patterns)


def reconcile(
    catalog: Sequence[CatalogEntry], database_objects: Sequence[DatabaseObject]
) -> Reconciliation:
    """Compares catalog identities and comments with one database schema."""
    catalog_by_key = {entry.key: entry for entry in catalog}
    database_by_key = {item.key: item for item in database_objects}

    missing_from_catalog = [
        item for key, item in database_by_key.items() if key not in catalog_by_key
    ]
    missing_from_database = [
        entry for key, entry in catalog_by_key.items() if key not in database_by_key
    ]
    differing_comments = [
        (catalog_by_key[key], item)
        for key, item in database_by_key.items()
        if key in catalog_by_key and catalog_by_key[key].comment and catalog_by_key[key].comment != item.comment
    ]
    blank_catalog_comments = [
        (catalog_by_key[key], item)
        for key, item in database_by_key.items()
        if key in catalog_by_key and not catalog_by_key[key].comment
    ]

    return Reconciliation(
        sorted(missing_from_catalog, key=lambda item: item.key),
        sorted(missing_from_database, key=lambda entry: entry.key),
        sorted(differing_comments, key=lambda pair: pair[0].key),
        sorted(blank_catalog_comments, key=lambda pair: pair[0].key),
    )


def quote_identifier(value: str) -> str:
    return '"' + value.replace('"', '""') + '"'


def quote_literal(value: str) -> str:
    return "'" + value.replace("'", "''") + "'"


def comment_sql(entry: CatalogEntry) -> str:
    """Returns one safely quoted PostgreSQL COMMENT statement."""
    if not entry.comment:
        raise CatalogError(f"Cannot export a comment for {display_name(entry)} because its catalog comment is empty")
    object_name = f"{quote_identifier(entry.schema_name)}.{quote_identifier(entry.table_name)}"
    if entry.column_name:
        object_name += f".{quote_identifier(entry.column_name)}"
        target = "COLUMN"
    else:
        target = "TABLE"
    return f"COMMENT ON {target} {object_name} IS {quote_literal(entry.comment)};"


def psql_command(args: argparse.Namespace, output_format: Optional[str] = None) -> list[str]:
    command = ["psql", "-X", "-w", "-v", "ON_ERROR_STOP=1"]
    host = args.host or os.environ.get("PGHOST") or read_vault_value(".default.sead.server")
    user = args.user or os.environ.get("PGUSER") or read_vault_value(".default.sead.username")
    port = args.port or os.environ.get("PGPORT") or "5433"

    if host:
        command.extend(["-h", host])
    if user:
        command.extend(["-U", user])
    if port:
        command.extend(["-p", str(port)])
    command.extend(["-d", args.database])
    if output_format == "csv":
        command.extend(["--csv", "-t"])
    elif output_format == "plain":
        command.extend(["-A", "-t"])
    return command


def read_vault_value(filename: str) -> Optional[str]:
    path = Path.home() / "vault" / filename
    try:
        value = path.read_text(encoding="utf-8").strip()
    except OSError:
        return None
    return value or None


def run_psql(args: argparse.Namespace, sql: str, output_format: Optional[str] = None) -> str:
    command = psql_command(args, output_format)
    if output_format is not None:
        command.extend(["-c", sql])
        input_sql = None
    else:
        input_sql = sql

    try:
        result = subprocess.run(
            command,
            input=input_sql,
            text=True,
            capture_output=True,
            check=False,
        )
    except FileNotFoundError as error:
        raise RuntimeError("psql was not found; install PostgreSQL command-line tools") from error

    if result.returncode:
        detail = result.stderr.strip() or result.stdout.strip()
        raise RuntimeError(f"psql failed: {detail}")
    return result.stdout


DATABASE_OBJECTS_SQL = """
SELECT 'table', namespace.nspname, relation.relname, '',
       COALESCE(obj_description(relation.oid, 'pg_class'), ''), '', ''
FROM pg_catalog.pg_class AS relation
JOIN pg_catalog.pg_namespace AS namespace ON namespace.oid = relation.relnamespace
WHERE namespace.nspname = {schema}
  AND relation.relkind IN ('r', 'p', 'v', 'm', 'f')
UNION ALL
SELECT 'column', namespace.nspname, relation.relname, attribute.attname,
       COALESCE(col_description(relation.oid, attribute.attnum), ''),
       CASE WHEN EXISTS (
           SELECT 1
           FROM pg_catalog.pg_constraint AS primary_key
           WHERE primary_key.conrelid = relation.oid
             AND primary_key.contype = 'p'
             AND attribute.attnum = ANY(primary_key.conkey)
       ) THEN 'YES' ELSE 'NO' END,
       CASE WHEN EXISTS (
           SELECT 1
           FROM pg_catalog.pg_constraint AS foreign_key
           WHERE foreign_key.conrelid = relation.oid
             AND foreign_key.contype = 'f'
             AND attribute.attnum = ANY(foreign_key.conkey)
       ) THEN 'YES' ELSE 'NO' END
FROM pg_catalog.pg_class AS relation
JOIN pg_catalog.pg_namespace AS namespace ON namespace.oid = relation.relnamespace
JOIN pg_catalog.pg_attribute AS attribute ON attribute.attrelid = relation.oid
WHERE namespace.nspname = {schema}
  AND relation.relkind IN ('r', 'p', 'v', 'm', 'f')
  AND attribute.attnum > 0
  AND NOT attribute.attisdropped
ORDER BY 2, 3, 1, 4
"""


def load_database_objects(args: argparse.Namespace) -> list[DatabaseObject]:
    """Reads table, view, and column comments from the selected database schema."""
    schema_literal = quote_literal(args.schema)
    schema_exists = run_psql(
        args,
        "SELECT EXISTS (SELECT 1 FROM pg_catalog.pg_namespace "
        f"WHERE nspname = {schema_literal});",
        "plain",
    ).strip()
    if schema_exists != "t":
        raise RuntimeError(f"Schema does not exist in database {args.database}: {args.schema}")

    output = run_psql(args, DATABASE_OBJECTS_SQL.format(schema=schema_literal), "csv")
    objects: list[DatabaseObject] = []
    for row in csv.reader(io.StringIO(output)):
        if len(row) != 7:
            raise RuntimeError("psql returned an unexpected database inventory row")
        object_type, schema_name, table_name, column_name, comment, is_pk, is_fk = row
        objects.append(DatabaseObject(object_type, schema_name, table_name, column_name, comment, is_pk, is_fk))
    return objects


def build_candidate_rows(
    catalog: Sequence[CatalogEntry], database_objects: Sequence[DatabaseObject]
) -> list[dict[str, str]]:
    """Keeps catalog rows and appends database objects that are not in the catalog."""
    catalog_by_key = {entry.key: entry for entry in catalog}
    database_by_key = {item.key: item for item in database_objects}
    rows = [
        {
            "schema_name": entry.schema_name,
            "entity_name": entry.entity_name,
            "table_name": entry.table_name,
            "column_name": entry.column_name,
            "comment": entry.comment or (
                database_by_key[entry.key].comment if entry.key in database_by_key else ""
            ),
            "is_pk": entry.is_pk,
            "is_fk": entry.is_fk,
        }
        for entry in catalog
    ]

    new_objects = sorted(
        (item for item in database_objects if item.key not in catalog_by_key),
        key=lambda item: (item.schema_name, item.table_name, item.object_type != "table", item.column_name),
    )
    for item in new_objects:
        rows.append(
            {
                "schema_name": item.schema_name,
                "entity_name": item.table_name if item.object_type == "table" else "",
                "table_name": item.table_name,
                "column_name": item.column_name,
                "comment": item.comment,
                "is_pk": item.is_pk if item.object_type == "column" else "",
                "is_fk": item.is_fk if item.object_type == "column" else "",
            }
        )
    return rows


def write_candidate_catalog(path: Path, source_path: Path, rows: Sequence[dict[str, str]]) -> None:
    """Writes a candidate CSV without replacing the source catalog or an existing file."""
    if path.resolve() == source_path.resolve():
        raise CatalogError("Candidate path must be different from the source catalog path")
    try:
        with path.open("x", newline="", encoding="utf-8") as candidate_file:
            writer = csv.DictWriter(candidate_file, fieldnames=CATALOG_FIELDS, delimiter=";")
            writer.writeheader()
            writer.writerows(rows)  # type: ignore
    except FileExistsError as error:
        raise CatalogError(f"Candidate file already exists: {path}") from error
    except OSError as error:
        raise CatalogError(f"Cannot write candidate catalog {path}: {error}") from error


def display_name(item: CatalogEntry | DatabaseObject) -> str:
    suffix = f".{item.column_name}" if item.column_name else ""
    return f"{item.object_type.upper()} {item.schema_name}.{item.table_name}{suffix}"


def print_report(result: Reconciliation, database: str, schema: str) -> None:
    print(f"Database comment report: {database}.{schema}")

    print(f"\nObjects missing from catalog: {len(result.missing_from_catalog)}")
    for item in result.missing_from_catalog:
        print(f"- {display_name(item)}")
        if item.comment:
            if item.object_type == "table":
                print("  Database comment:", repr(item.comment))
                print(
                    "  Suggested catalog fields: "
                    f"schema_name={item.schema_name!r}; entity_name=<add display name>; "
                    f"table_name={item.table_name!r}; column_name=''; comment={item.comment!r}"
                )
            else:
                print("  Database comment:", repr(item.comment))
                print(
                    "  Suggested catalog fields: "
                    f"schema_name={item.schema_name!r}; entity_name=''; "
                    f"table_name={item.table_name!r}; column_name={item.column_name!r}; "
                    f"comment={item.comment!r}"
                )
        else:
            print("  No database comment; add a description to the catalog.")

    print(f"\nCatalog objects missing from database: {len(result.missing_from_database)}")
    for entry in result.missing_from_database:
        print(f"- {display_name(entry)} (review as stale or unavailable in this database)")

    print(f"\nComments needing update: {len(result.differing_comments)}")
    for entry, item in result.differing_comments:
        print(f"- {display_name(entry)}")
        print("  Catalog:", repr(entry.comment))
        print("  Database:", repr(item.comment) if item.comment else "(no comment)")

    print(f"\nCatalog entries with blank comments: {len(result.blank_catalog_comments)}")
    for entry, item in result.blank_catalog_comments:
        print(f"- {display_name(entry)}")
        if item.comment:
            print("  Database comment available for review:", repr(item.comment))
        else:
            print("  No database comment; add a description to the catalog.")


def export_sql(args: argparse.Namespace) -> None:
    for entry in load_catalog(args.catalog, args.schema):
        if entry.comment:
            print(comment_sql(entry))


def sync_comments(args: argparse.Namespace) -> None:
    exclusions_path = getattr(args, "excludes", None)
    exclusions = load_exclusions(exclusions_path) if exclusions_path is not None else []
    catalog_before_exclusions = load_catalog(args.catalog, args.schema)
    database_before_exclusions = load_database_objects(args)
    catalog = [entry for entry in catalog_before_exclusions if not is_excluded(entry, exclusions)]
    database_objects = [item for item in database_before_exclusions if not is_excluded(item, exclusions)]
    report = reconcile(catalog, database_objects)
    print_report(report, args.database, args.schema)

    if exclusions:
        excluded_catalog_count = len(catalog_before_exclusions) - len(catalog)
        excluded_database_count = len(database_before_exclusions) - len(database_objects)
        print(
            f"\nExclusions matched {excluded_catalog_count} catalog object(s) and "
            f"{excluded_database_count} database object(s) using {len(exclusions)} pattern(s)."
        )

    candidate_path = getattr(args, "export_candidate", None)
    if candidate_path is not None:
        all_catalog_entries = load_catalog(args.catalog)
        candidate_rows = build_candidate_rows(all_catalog_entries, database_objects)
        write_candidate_catalog(candidate_path, args.catalog, candidate_rows)
        added_count = len(candidate_rows) - len(all_catalog_entries)
        print(f"\nCandidate catalog exported to {candidate_path} ({added_count} database object(s) added).")
        if any(
            item.object_type == "table"
            and item.key not in {entry.key for entry in all_catalog_entries}
            for item in database_objects
        ):
            print("New table entity_name values use the table name as a placeholder; review these labels.")

    if not args.apply:
        if candidate_path is None:
            print("\nReport only; pass --apply to update comments from the catalog.")
        else:
            print("\nNo database changes were made.")
        return

    updates = [entry for entry, _ in report.differing_comments if entry.comment]
    if not updates:
        print("\nNo database comments need updating.")
        return

    sql = "BEGIN;\n" + "\n".join(comment_sql(entry) for entry in updates) + "\nCOMMIT;\n"
    run_psql(args, sql)
    print(f"\nApplied {len(updates)} catalog comment(s) to {args.database}.{args.schema}.")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Manage SEAD table and column comments.")
    commands = parser.add_subparsers(dest="command", required=True)

    sql_parser = commands.add_parser(
        "sql",
        prog="csv-to-sql",
        help="Export catalog entries as PostgreSQL COMMENT statements.",
    )
    sql_parser.add_argument("catalog", nargs="?", type=Path, default=DEFAULT_CATALOG)
    sql_parser.add_argument("--schema", help="Export entries for this schema only.")
    sql_parser.set_defaults(handler=export_sql)

    sync_parser = commands.add_parser(
        "sync",
        prog="sync-comments",
        help="Compare a catalog with a database and optionally apply it.",
    )
    sync_parser.add_argument("catalog", nargs="?", type=Path, default=DEFAULT_CATALOG)
    sync_parser.add_argument("--database", required=True, help="Target PostgreSQL database.")
    sync_parser.add_argument("--schema", default="public", help="Target schema (default: public).")
    sync_parser.add_argument("--host", help="PostgreSQL host; otherwise use PGHOST or the local vault setting.")
    sync_parser.add_argument("--port", help="PostgreSQL port; otherwise use PGPORT or 5433.")
    sync_parser.add_argument("--user", help="PostgreSQL user; otherwise use PGUSER or the local vault setting.")
    sync_parser.add_argument(
        "--excludes",
        type=Path,
        metavar="FILENAME",
        help="Skip tables and columns matching newline-delimited expressions in FILENAME.",
    )
    sync_actions = sync_parser.add_mutually_exclusive_group()
    sync_actions.add_argument(
        "--apply",
        action="store_true",
        help="Apply catalog comments that differ from comments on existing database objects.",
    )
    sync_actions.add_argument(
        "--export-candidate",
        type=Path,
        metavar="PATH",
        help="Write a separate candidate catalog CSV; never changes the source catalog or database.",
    )
    sync_parser.set_defaults(handler=sync_comments)
    return parser


def main(argv: Optional[Sequence[str]] = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    try:
        args.handler(args)
    except (CatalogError, RuntimeError) as error:
        print(f"error: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
