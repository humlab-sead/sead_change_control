# SEAD Change Control System

Sensible SEAD change control system (CCS) using [Sqitch](https://sqitch.org/).

## Install (or update) Sqitch

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
| ./utility     | Repository for generic utility objects |
| ./sead_api    | Repository for CR related to external API |
| ./bugs        | CRs related to Bugs import |
| ./report      | Report related CRs (e.g. Clearinghouse, SuperSEAD) |
| ./security    | Changes related to roles and privileges |
| ./subsystem   | Changes related to subsystems |
| ./submissions | Commited Clearinghouse submissions |

Use `sqitch init` to create a new project:

```bash
sqitch init xyz --uri https://github.com/humlab-sead/xyz --engine pg -C xyz
```

## Add a New SEAD CCS Task

Use `sqitch add` (or possibly `docker-sqitch.sh` depending on install) with task naming convention `yyyymmdd_[DML|DDL]_ENTITY_DESCRIPTION`:

```bash
docker-sqitch.sh add --change-name yyyymmdd_DXL_ENTITY_DESCRIPTION --note "a note" --chdir ./project-path
```

Example:

```bash
./docker-sqitch.sh add --change-name 20191125_DML_CERAMICS_LOOKUP --note "Ceramics lookup data" --chdir ./general
```

Task templates locations:

```bash
sqitch --etc-path
cat `sqitch --etc-path`/templates/deploy/pg.tmpl
```

## Add a New SEAD CCS Tag

Add a new (release) tag to a specific plan file:

```bash
sqitch tag --tag v0.1 --note "tag description" --plan-file ./project-path/sqitch.plan
```

Example:

```bash
$ sqitch tag @v0.2 20190624_DML_SUBMISSION_DENDRO_ARKEO_002_COMMIT --plan-file ./general/sqitch.plan --note "Dendro archeology dataset commit"
Tagged "20190624_DML_SUBMISSION_DENDRO_ARKEO_002_COMMIT" with @v0.2 in general/sqitch.plan
```

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
sqitch rebase --log-only --target "a-target" --chdir "a-sub-project"
sqitch rebase --upto "some-point" --log-only --target "a-target" --chdir "a-sub-project"
```

## Troubleshooting

If squitch says `fe_sendauth: no password supplied` then you need to set SQITCH_PASSWORD or properly configure .pgpass.

 ```bash
 $ ./docker-sqitch.sh status --target my-targetg -C ./my-project
fe_sendauth: no password supplied

export SQITCH_PASSWORD=password
```

## More

sqitch status
sqitch plan
sqitch --help
