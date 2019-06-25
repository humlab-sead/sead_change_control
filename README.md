# SEAD Change Control System

Sane SEAD change control using [Sqitch](https://sqitch.org/).

## Install Sqitch

```bash
docker pull sqitch/sqitch
mkdir -p ~/bin && curl -L https://git.io/fAX6Z -o ~/bin/sqitch && chmod +x ~/bin/sqitch
```

Sample `sqitch.conf`:

```bash
[core]
    engine = pg

[engine "pg"]
    client = psql

[user]
    name = Your Name
    email = your.name@umu.se

[target "staging"]
    uri = db:pg://user@server/sead_staging

[target "staging-ch"]
    uri = db:pg://user@server/sead_staging_clearinghouse

[target "staging-bugs"]
    uri = db:pg://user@server/sead_staging_bugs
```

Locations of `sqitch.conf`:

- Project: ./sqitch.conf
- User: `~/.sqitch/sqitch.conf`
- Global: `sqitch --etc-path/sqitch.conf`

## Projects

| Project       | Description   |
| ------------- | ------------- |
| ./general     | Main repository for schema and data change requests (CR) |
| ./utility     | Repository for generic utility objects      |
| ./sead_api    | Repository for CR related to external API
| ./bugs        | CRs related to Bugs import |
| ./report      | Report related CRs  (e.g. Clearinghouse, SuperSEAD) |

Use `sqitch init` to create a new project:

```bash
sqitch init xyz --uri https://github.com/humlab-sead/xyz --engine pg -C xyz
```

## Naming Conventions

yyyymmdd_[DML|DDL]_ENTITY_DESCRIPTION

## Add a New SEAD CCS Task

sqitch add --change-name xyz --note "a note" --chdir ./project-path

Task templates locations:

sqitch --etc-path
cat `sqitch --etc-path`/templates/deploy/pg.tmpl

## Add a New SEAD CCS Tag

sqitch tag --tag v0.1 --note "tag description" --plan-file ./project-path/sqitch.plan

## Deploy Tasks up to Tag or Change

```bash
sqitch deploy --target staging --to @v0.1 [--mode change] --no-verify -C ./project-path/
sqitch deploy --target staging --to-change @v0.1 [--mode change] --no-verify -C ./project-path/
```

## Deploy Single Task

```bash
sqitch deploy --target staging  -C ./project-path/ change
```

## Fix inconsistency between plan and database

Use this only if plan actually reflects current state of the database. It will log a revert of all current changes in the database,
without actually doing a revert, and then log deploy of changes according to plan (without acutuall doing the deploy).

```bash
sqitch rebase --log-only --target staging-tng -C ./general
```

## More

sqitch status
sqitch plan
sqitch --help
