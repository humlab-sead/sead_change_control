import argparse
import csv
import io
import sys
import tempfile
import unittest
from contextlib import redirect_stdout
from pathlib import Path
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from comments_catalog import (  # noqa: E402
    CatalogError,
    CatalogEntry,
    DatabaseObject,
    build_candidate_rows,
    comment_sql,
    load_catalog,
    load_database_objects,
    load_exclusions,
    is_excluded,
    reconcile,
    sync_comments,
    write_candidate_catalog,
)


FIELDS = [
    "schema_name",
    "entity_name",
    "table_name",
    "column_name",
    "comment",
    "is_pk",
    "is_fk",
]


class CatalogTests(unittest.TestCase):
    def write_catalog(self, rows):
        temporary_file = tempfile.NamedTemporaryFile(mode="w", newline="", encoding="utf-8", delete=False)
        self.addCleanup(Path(temporary_file.name).unlink, missing_ok=True)
        with temporary_file:
            writer = csv.DictWriter(temporary_file, fieldnames=FIELDS, delimiter=";")
            writer.writeheader()
            writer.writerows(rows)
        return Path(temporary_file.name)

    def write_exclusions(self, content):
        temporary_file = tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", delete=False)
        self.addCleanup(Path(temporary_file.name).unlink, missing_ok=True)
        with temporary_file:
            temporary_file.write(content)
        return Path(temporary_file.name)

    def test_reads_quoted_semicolons_apostrophes_and_newlines(self):
        path = self.write_catalog(
            [
                {
                    "schema_name": "public",
                    "entity_name": "Example table",
                    "table_name": "example",
                    "column_name": "",
                    "comment": "A table; with an apostrophe: SEAD's.\nSecond line.",
                    "is_pk": "",
                    "is_fk": "",
                }
            ]
        )

        entries = load_catalog(path, "public")

        self.assertEqual(len(entries), 1)
        self.assertEqual(entries[0].comment, "A table; with an apostrophe: SEAD's.\nSecond line.")

    def test_reads_blank_comments_as_uncurated_entries(self):
        path = self.write_catalog(
            [
                {
                    "schema_name": "public",
                    "entity_name": "",
                    "table_name": "example",
                    "column_name": "description",
                    "comment": "",
                    "is_pk": "NO",
                    "is_fk": "NO",
                }
            ]
        )

        entries = load_catalog(path, "public")

        self.assertEqual(len(entries), 1)
        self.assertEqual(entries[0].comment, "")

    @patch("comments_catalog.run_psql")
    def test_reads_database_inventory_as_csv(self, run_psql):
        run_psql.side_effect = [
            "t",
            '"table","public","example","","Table, with comma","",""\n'
            '"column","public","example","description","Contains a semicolon; and comma,","YES","NO"\n',
        ]
        args = argparse.Namespace(database="sead_staging", schema="odd'schema")

        objects = load_database_objects(args)

        self.assertEqual(len(objects), 2)
        self.assertEqual(objects[0].comment, "Table, with comma")
        self.assertEqual(objects[1].comment, "Contains a semicolon; and comma,")
        self.assertEqual((objects[1].is_pk, objects[1].is_fk), ("YES", "NO"))
        self.assertIn("nspname = 'odd''schema'", run_psql.call_args_list[0].args[1])
        self.assertEqual(run_psql.call_args_list[1].args[1].count("nspname = 'odd''schema'"), 2)
        self.assertIn("primary_key.conkey", run_psql.call_args_list[1].args[1])
        self.assertIn("foreign_key.conkey", run_psql.call_args_list[1].args[1])

    def test_exclusion_patterns_match_table_and_column_objects(self):
        path = self.write_exclusions(
            "*.date_updated\n"
            "tbl_isotopes*\n"
            "view_*\n"
            "tbl_specific.*\n"
        )
        patterns = load_exclusions(path)

        self.assertTrue(is_excluded(CatalogEntry("public", "Isotopes", "tbl_isotopes", "", "Table."), patterns))
        self.assertTrue(
            is_excluded(
                DatabaseObject("column", "public", "tbl_isotopes_samples", "sample_id", "", "YES", "NO"),
                patterns,
            )
        )
        self.assertTrue(
            is_excluded(DatabaseObject("column", "public", "tbl_sites", "date_updated", ""), patterns)
        )
        self.assertTrue(is_excluded(DatabaseObject("table", "public", "view_samples", "", ""), patterns))
        self.assertFalse(is_excluded(DatabaseObject("table", "public", "tbl_specific", "", ""), patterns))
        self.assertTrue(
            is_excluded(DatabaseObject("column", "public", "tbl_specific", "id", ""), patterns)
        )
        self.assertFalse(is_excluded(DatabaseObject("column", "public", "tbl_sites", "date_created", ""), patterns))

    def test_exclusion_file_rejects_invalid_expression_or_wildcard(self):
        for expression in (".column", "table.", "one.two.three", "table.?", "table.[id]"):
            with self.subTest(expression=expression):
                path = self.write_exclusions(expression + "\n")
                with self.assertRaisesRegex(CatalogError, "Invalid exclusion expression"):
                    load_exclusions(path)

    def test_rejects_duplicate_object_rows(self):
        row = {
            "schema_name": "public",
            "entity_name": "",
            "table_name": "example",
            "column_name": "id",
            "comment": "Identifier.",
            "is_pk": "YES",
            "is_fk": "NO",
        }
        path = self.write_catalog([row, row])

        with self.assertRaisesRegex(CatalogError, "Duplicate column"):
            load_catalog(path)

    def test_reconciliation_finds_missing_stale_and_different_comments(self):
        catalog = [
            CatalogEntry("public", "Example", "example", "", "Catalog table."),
            CatalogEntry("public", "", "example", "id", "Catalog identifier."),
            CatalogEntry("public", "", "example", "removed", "Stale column."),
            CatalogEntry("public", "", "example", "needs-description", ""),
        ]
        database = [
            DatabaseObject("table", "public", "example", "", "Database table."),
            DatabaseObject("column", "public", "example", "id", "Catalog identifier."),
            DatabaseObject("column", "public", "example", "new", "Database-only description."),
            DatabaseObject("column", "public", "example", "undocumented", ""),
            DatabaseObject("column", "public", "example", "needs-description", "Database suggestion."),
        ]

        result = reconcile(catalog, database)

        self.assertEqual([item.column_name for item in result.missing_from_catalog], ["new", "undocumented"])
        self.assertEqual([item.column_name for item in result.missing_from_database], ["removed"])
        self.assertEqual(len(result.differing_comments), 1)
        self.assertEqual(result.differing_comments[0][0].object_type, "table")
        self.assertEqual(len(result.blank_catalog_comments), 1)
        self.assertEqual(result.blank_catalog_comments[0][1].comment, "Database suggestion.")

    def test_sql_quotes_identifiers_and_comment_text(self):
        entry = CatalogEntry("odd schema", "", 'odd"table', 'odd"column', "SEAD's; description")

        statement = comment_sql(entry)

        self.assertEqual(
            statement,
            'COMMENT ON COLUMN "odd schema"."odd""table"."odd""column" IS \'SEAD\'\'s; description\';',
        )

    def test_sql_export_rejects_empty_comments(self):
        entry = CatalogEntry("public", "", "example", "description", "")

        with self.assertRaisesRegex(CatalogError, "comment is empty"):
            comment_sql(entry)

    def test_candidate_rows_preserve_catalog_and_add_database_objects(self):
        source_path = self.write_catalog(
            [
                {
                    "schema_name": "public",
                    "entity_name": "Example table",
                    "table_name": "example",
                    "column_name": "",
                    "comment": "Curated table comment.",
                    "is_pk": "",
                    "is_fk": "",
                },
                {
                    "schema_name": "public",
                    "entity_name": "",
                    "table_name": "example",
                    "column_name": "id",
                    "comment": "",
                    "is_pk": "YES",
                    "is_fk": "NO",
                },
                {
                    "schema_name": "public",
                    "entity_name": "Old table",
                    "table_name": "old_table",
                    "column_name": "",
                    "comment": "Keep stale row for review.",
                    "is_pk": "",
                    "is_fk": "",
                },
            ]
        )
        source_contents = source_path.read_bytes()
        catalog = load_catalog(source_path)
        database = [
            DatabaseObject("table", "public", "example", "", "Database table comment."),
            DatabaseObject("column", "public", "example", "id", "Database identifier.", "NO", "YES"),
            DatabaseObject("column", "public", "example", "name", "Database name.", "NO", "NO"),
            DatabaseObject("column", "public", "example", "undocumented", "", "NO", "NO"),
            DatabaseObject("table", "public", "new_table", "", ""),
            DatabaseObject("column", "public", "new_table", "new_id", "New identifier.", "YES", "NO"),
        ]
        rows = build_candidate_rows(catalog, database)

        with tempfile.TemporaryDirectory() as temporary_directory:
            candidate_path = Path(temporary_directory) / "candidate.csv"
            write_candidate_catalog(candidate_path, source_path, rows)

            with candidate_path.open(newline="", encoding="utf-8") as candidate_file:
                reader = csv.DictReader(candidate_file, delimiter=";")
                candidate_rows = list(reader)
                self.assertEqual(reader.fieldnames, FIELDS)

        by_key = {
            (row["schema_name"], row["table_name"], row["column_name"]): row
            for row in candidate_rows
        }
        self.assertEqual(by_key[("public", "example", "")]["comment"], "Curated table comment.")
        self.assertEqual(by_key[("public", "example", "id")]["comment"], "Database identifier.")
        self.assertEqual(by_key[("public", "example", "id")]["is_pk"], "YES")
        self.assertEqual(by_key[("public", "example", "id")]["is_fk"], "NO")
        self.assertEqual(by_key[("public", "example", "name")]["comment"], "Database name.")
        self.assertEqual(by_key[("public", "example", "name")]["is_pk"], "NO")
        self.assertEqual(by_key[("public", "example", "undocumented")]["comment"], "")
        self.assertEqual(by_key[("public", "new_table", "")]["entity_name"], "new_table")
        self.assertEqual(by_key[("public", "new_table", "")]["comment"], "")
        self.assertEqual(by_key[("public", "new_table", "new_id")]["is_pk"], "YES")
        self.assertEqual(by_key[("public", "old_table", "")]["comment"], "Keep stale row for review.")
        self.assertEqual(source_path.read_bytes(), source_contents)

    def test_candidate_writer_refuses_source_and_existing_paths(self):
        source_path = self.write_catalog([])

        with self.assertRaisesRegex(CatalogError, "different from the source catalog"):
            write_candidate_catalog(source_path, source_path, [])

        with tempfile.TemporaryDirectory() as temporary_directory:
            candidate_path = Path(temporary_directory) / "candidate.csv"
            candidate_path.write_text("Existing content", encoding="utf-8")
            with self.assertRaisesRegex(CatalogError, "already exists"):
                write_candidate_catalog(candidate_path, source_path, [])
            self.assertEqual(candidate_path.read_text(encoding="utf-8"), "Existing content")

    @patch("comments_catalog.run_psql")
    def test_sync_reports_by_default_without_applying_updates(self, run_psql):
        catalog = [CatalogEntry("public", "", "example", "id", "Catalog description.")]
        database = [DatabaseObject("column", "public", "example", "id", "Old description.")]
        args = argparse.Namespace(catalog=Path("catalog.csv"), schema="public", database="sead_staging", apply=False)

        with patch("comments_catalog.load_catalog", return_value=catalog), patch(
            "comments_catalog.load_database_objects", return_value=database
        ), redirect_stdout(io.StringIO()):
            sync_comments(args)

        run_psql.assert_not_called()

    @patch("comments_catalog.run_psql")
    def test_sync_applies_only_different_catalog_comments(self, run_psql):
        catalog = [
            CatalogEntry("public", "", "example", "id", "Catalog description."),
            CatalogEntry("public", "", "example", "name", "Already current."),
            CatalogEntry("public", "", "example", "empty", ""),
        ]
        database = [
            DatabaseObject("column", "public", "example", "id", "Old description."),
            DatabaseObject("column", "public", "example", "name", "Already current."),
            DatabaseObject("column", "public", "example", "empty", "Leave this database comment."),
        ]
        args = argparse.Namespace(catalog=Path("catalog.csv"), schema="public", database="sead_staging", apply=True)

        with patch("comments_catalog.load_catalog", return_value=catalog), patch(
            "comments_catalog.load_database_objects", return_value=database
        ), redirect_stdout(io.StringIO()):
            sync_comments(args)

        sql = run_psql.call_args.args[1]
        self.assertIn("BEGIN;", sql)
        self.assertIn('COMMENT ON COLUMN "public"."example"."id" IS \'Catalog description.\';', sql)
        self.assertNotIn('"name"', sql)
        self.assertNotIn('"empty"', sql)
        self.assertIn("COMMIT;", sql)

    @patch("comments_catalog.run_psql")
    def test_sync_excludes_matching_objects_from_apply(self, run_psql):
        catalog = [
            CatalogEntry("public", "Public table", "tbl_public", "", "Public table."),
            CatalogEntry("public", "Private table", "tbl_private", "", "Private table."),
            CatalogEntry("public", "", "tbl_public", "date_updated", "Update date."),
            CatalogEntry("public", "", "tbl_public", "name", "Catalog name."),
        ]
        database = [
            DatabaseObject("table", "public", "tbl_public", "", "Public table."),
            DatabaseObject("table", "public", "tbl_private", "", "Old private table."),
            DatabaseObject("column", "public", "tbl_public", "date_updated", "Old update date."),
            DatabaseObject("column", "public", "tbl_public", "name", "Old name."),
        ]
        excludes_path = self.write_exclusions("tbl_private*\n*.date_updated\n")
        args = argparse.Namespace(
            catalog=Path("catalog.csv"),
            schema="public",
            database="sead_staging",
            apply=True,
            excludes=excludes_path,
        )

        with patch("comments_catalog.load_catalog", return_value=catalog), patch(
            "comments_catalog.load_database_objects", return_value=database
        ), redirect_stdout(io.StringIO()):
            sync_comments(args)

        sql = run_psql.call_args.args[1]
        self.assertIn('COMMENT ON COLUMN "public"."tbl_public"."name" IS \'Catalog name.\';', sql)
        self.assertNotIn("tbl_private", sql)
        self.assertNotIn("date_updated", sql)

    @patch("comments_catalog.run_psql")
    def test_sync_exports_candidate_without_database_writes(self, run_psql):
        catalog = [CatalogEntry("public", "Example", "example", "", "Catalog table.")]
        database = [
            DatabaseObject("table", "public", "example", "", "Database table."),
            DatabaseObject("column", "public", "example", "id", "Identifier.", "YES", "NO"),
        ]
        with tempfile.TemporaryDirectory() as temporary_directory:
            candidate_path = Path(temporary_directory) / "candidate.csv"
            args = argparse.Namespace(
                catalog=Path("catalog.csv"),
                schema="public",
                database="sead_staging",
                apply=False,
                export_candidate=candidate_path,
            )
            with patch("comments_catalog.load_catalog", side_effect=[catalog, catalog]), patch(
                "comments_catalog.load_database_objects", return_value=database
            ), redirect_stdout(io.StringIO()):
                sync_comments(args)

            with candidate_path.open(newline="", encoding="utf-8") as candidate_file:
                rows = list(csv.DictReader(candidate_file, delimiter=";"))

        run_psql.assert_not_called()
        self.assertEqual(len(rows), 2)
        self.assertEqual(rows[1]["column_name"], "id")
        self.assertEqual(rows[1]["is_pk"], "YES")

    @patch("comments_catalog.run_psql")
    def test_candidate_export_does_not_add_excluded_database_objects(self, run_psql):
        catalog = [CatalogEntry("public", "Private table", "tbl_private", "", "Existing description.")]
        database = [
            DatabaseObject("table", "public", "tbl_private", "", "Existing description."),
            DatabaseObject("column", "public", "tbl_private", "new_column", "Private column."),
            DatabaseObject("table", "public", "tbl_public_new", "", "New public table."),
            DatabaseObject("column", "public", "tbl_public_new", "id", "Public identifier.", "YES", "NO"),
        ]
        excludes_path = self.write_exclusions("tbl_private*\n")
        with tempfile.TemporaryDirectory() as temporary_directory:
            candidate_path = Path(temporary_directory) / "candidate.csv"
            args = argparse.Namespace(
                catalog=Path("catalog.csv"),
                schema="public",
                database="sead_staging",
                apply=False,
                export_candidate=candidate_path,
                excludes=excludes_path,
            )
            with patch("comments_catalog.load_catalog", side_effect=[catalog, catalog]), patch(
                "comments_catalog.load_database_objects", return_value=database
            ), redirect_stdout(io.StringIO()):
                sync_comments(args)

            with candidate_path.open(newline="", encoding="utf-8") as candidate_file:
                rows = list(csv.DictReader(candidate_file, delimiter=";"))

        run_psql.assert_not_called()
        self.assertEqual(
            [(row["table_name"], row["column_name"]) for row in rows],
            [("tbl_private", ""), ("tbl_public_new", ""), ("tbl_public_new", "id")],
        )


if __name__ == "__main__":
    unittest.main()
