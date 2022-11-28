from jinja2 import Environment, FileSystemLoader
import psycopg2
from collections import defaultdict
import click

TEMPLATE = """
{
    "development": {
        "sourceClient": {
            "host": "{{ source.get("host") }}",
            "port": "{{ source.get("port", 5432) }}",
            "database": "{{ source.get("database", None) }}",
            "user": "{{ source.get("user", None) }}",
            "applicationName": "pg-diff-cli"
        },
        "targetClient": {
            "host": "{{ target.get("host") }}",
            "port": "{{ target.get("port", 5432) }}",
            "database": "{{ target.get("database", None) }}",
            "user": "{{ target.get("user", None) }}",
            "applicationName": "pg-diff-cli"
        },
        "compareOptions": {
            "author": "{{ author or "Roger Mähler" }}",
            "outputDirectory": "{{ outputDirectory or "./output" }}",
            "getAuthorFromGit": false,
            "schemaCompare": {
                "namespaces": [
                    {% for namespace in namespaces %}"{{ namespace }}"{{ ", " if not loop.last else "" }}{% endfor %}
                ],
                "dropMissingTable": false,
                "dropMissingView": false,
                "dropMissingFunction": false,
                "dropMissingAggregate": false,
                "roles": [{% for role in roles %}"{{ role }}"{{ ", " if not loop.last else "" }}{% endfor %}]
            },
            "dataCompare": {
                "enable": {{ "true" if data_compare > 0 else "false" }},
                "tables": [
                    {% for schema, tables in data_tables.items() %}
                        {% for table in tables %}{
                            "tableSchema": "{{ schema }}", "tableName": "{{ table['table_name'] }}", "tableKeyFields": [ "{{ table['primary_key'] }}" ]
                        }{{ "," if not loop.last else "" }}
                        {% endfor %}{{ "," if not loop.last else "" }}
                    {% endfor %}
                ]
            }
        },
        "migrationOptions": {
            "patchesDirectory": "db_migration",
            "historyTableName": "migrations",
            "historyTableSchema": "public"
        }
    }
}
"""
def get_schema_tables( host: str, user: str, database: str, schemas: list[str] ) -> dict:

    snuttify = lambda l: [f"'{x}'" for x in l]
    connection = psycopg2.connect( host=host, user=user, database=database)
    where_clause: str = f"where tc.table_schema in ({', '.join(snuttify(schemas))})" if len(schemas or []) > 0 else ""
    sql: str = f"""
        select tc.table_schema, tc.table_name, string_agg(kc.column_name, ','), count(*)
        from information_schema.table_constraints tc
        join information_schema.key_column_usage kc
          on tc.constraint_type = 'PRIMARY KEY'
         and kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
         and kc.constraint_name = tc.constraint_name
        { where_clause}
        group by tc.table_schema, tc.table_name
        order by 1, 2;
    """
    cursor = connection.cursor()
    cursor.execute(sql)
    rows = cursor.fetchall()
    data = defaultdict(list)

    for row in rows:

        if row[3] != 1:
            print(f"info: skipping {row[0]}.{row[1]} key count {row[3]}")
            continue

        data[row[0]].append(dict(
            table_name=row[1],
            primary_key=row[2],
            key_count=row[3])
        )

    return dict(data)

@click.command()
@click.argument('filename', type=click.STRING)
@click.option('-h', '--host', type=click.STRING, help='Database server', default="")
@click.option('-u', '--user', type=click.STRING, help='Username', default="")
@click.option('-sd', '--source-database', type=click.STRING, help='Source database')
@click.option('-td', '--target-database', type=click.STRING, help='Target database')
@click.option('-s', '--schema', type=click.STRING, multiple=True, help='Schema')
@click.option('-o', '--output-dir', type=click.STRING, help='Output directory')
@click.option('-dc', '--data-compare', type=click.BOOL, is_flag=True, help='Compare data', default=False)
@click.option('-ds', '--data-schema', type=click.STRING, multiple=True, help='Compare data schemas')
@click.option('-r', '--roles', type=click.STRING, multiple=True, help='Roles')
def generate(
    filename: str,
    host: str,
    user: str,
    source_database: str,
    target_database: str,
    schema: list[str],
    output_dir: str="./output",
    data_compare: bool=False,
    data_schema: list[str]=None,
    roles: list[str]=None,
):
    data_tables = None
    if data_compare:
        data_tables = get_schema_tables(host=host, user=user, database=source_database, schemas=data_schema if data_schema else schema)

    config = {
        "source": {
            "host": host,
            "database": source_database,
            "user": user,
        },
        "target": {
            "host": host,
            "database": target_database,
            "user": user,
        },
        "author": "Roger Mähler",
        "outputDirectory": output_dir,
        "namespaces": schema,
        "roles": roles or [],
        "data_compare": len(data_tables or {}) > 0,
        "data_tables": data_tables or {},
    }

    content: str = Environment().from_string(TEMPLATE).render(config)
    with open(filename, mode="w", encoding="utf-8") as fp:
        fp.write(content)
        print(f"info: wrote {filename}")

if __name__ == '__main__':

    generate()

    # generate(
    #     host="humlabseadserv.srv.its.umu.se",
    #     user="humlab_admin",
    #     source_database="sead_staging",
    #     target_database="sead_staging_test",
    #     schemas=[
    #         "bugs_import",
    #         "clearing_house",
    #         "clearing_house_commit",
    #         "facet",
    #         "postgrest_api",
    #         "postgrest_default_api",
    #         "public",
    #         "sead_utility"
    #     ],
    #     roles=["humlab_admin"],
    #     data_schema=["public", "facet"],
    #     filename="compare_output.json"
    # )
