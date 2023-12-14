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
| ./bugs        | CRs related to Bugs data type |
| ./archaeobotany | CRs related to archaeobotany data type (and MAL data) |
| ./isotope | CRs related to isotope data type |
| ./ceramics | CRs related to ceramics data type |
| ./dendrochronology | CRs related to dendrochronology data type |
| ./general     | Main repository for schema and data change requests (CR) |
| ./sead_api    | Repository for CR related to external API |
| ./security    | Changes related to roles and privileges |
| ./submissions | Deprecated: Commited Clearinghouse submissions |
| ./subsystem   | Changes related to subsystems |
| ./utility     | Repository for generic utility objects |
| (./report)    | Report related CRs (e.g. Clearinghouse, SuperSEAD) |

Use `sqitch init` to create a new project:

```bash
sqitch init xyz --uri https://github.com/humlab-sead/xyz --engine pg -C xyz
```

Each projects must also be added to `projects.txt`,

## Add a New SEAD CCS Task

Use `bin/add-change-request` to add new CRs:

```man
Usage: bin/add-change-request --change|-c <change> --project|-f|-C|--plan-file <project> --note|-n <note> [--issue-id <issue-id>]

Add new change-request to sqitch plan file, and optionally create a new Github issue.

  --change|-c <change>                   Name of change to add to sqitch plan file.
  --project|-f|-C|--plan-file <project>  Path to sqitch project directory.
  --note|-n <note>                       Note to add to change.
  --issue-id <issue-id>                  Add URL to issue in CR's comment in plan files.
  --create-issue                         Create a new Github issue.
  --help|-h                              Show this help.

Most of sqitch options can also be used.
```

Example:

```man
bin/add-change-request --project dendrochronolgy --change 20231206_DDL_UPDATE_OF_DENDRO_RELATED_LOOKUPS --note "Lookup data related to the dendrochronological project needs updating." --issue-id 153
bin/add-change-request --project bugs --change 20231211_DML_SUBMISSION_BUGS_20230705_COMMIT --update-plan --create-issue --note "Full (inital) non-incremental import of BugsCEP data version 20230705."
bin/add-change-request --project bugs --change 20231211_DML_SUBMISSION_BUGS_20230705_COMMIT --create-issue --note "Full (inital) non-incremental import of BugsCEP data version 20230705."
bin/add-change-request --project bugs --change 20231212_DML_BUGS_ADD_ANALYSIS_ENTITY_AGES --note "Add modelled "official" ages for 889 bugs samples" --create-issue
 ```

Task templates locations:

```man
sqitch --etc-path
cat `sqitch --etc-path`/templates/deploy/pg.tmpl
```

Please use the naming convention `yyyymmdd_[DML|DDL]_ENTITY_DESCRIPTION`

## Add a New SEAD CCS Tag

Add a new (release) tag to a specific plan file:

```man
usage: tag-projects OPTIONS...

    --ignore-git             Continue even if sqitch tag is missing in git.
    --tag TAG                Add TAG to end of each plan.
    --note NOTE              Add NOTE to sqitch tag.

Examples:

bin/tag-projects --tag "@2023.12" --note "2023 December release"
bin/tag-projects --tag "@2023.12" --note "2023 December release" --ignore-git
bin/tag-projects--help
```

## Deploy Tasks up to Tag or Change

```man
usage: deploy-staging OPTIONS...

    --host SERVERNAME               Target server (humlabseadserv.srv.its.umu.se)
    --user USERNAME                 User on target server (humlab_admin)
    --target-db-name DBNAME         Target database name. Mandatory.
    --create-database               Create a fresh database from given source.
    --create-snapshot               Create snapshot of database.
    --dry-run                       Create snapshot of database.
    --sync-sequences                Sync all sequences when deploy is done.
    --ignore-git-tags               Continue even if sqitch tag is missing in git.
    --source-type [db|dump]         Source type i.e. a database name or a dump filename.
                                    Mandatory if "--create" is specified, else ignored.
    --source [DBNAME|FILE]          Name of source database or dump file depending on source type
                                    Optional if "--create" is specified, else ignored.
                                    Default "sead_master_9" if "source_type" is "db"
                                    Default "./starting_point/sead_master_9_public.sql.gz" if "source_type" is "dump"
    --on-conflict [drop|rename]     What to do if target database exists (rename)
                                    Optional if "--create" is specified, else ignored. Default rename.
    --deploy-to-tag TAG             Sqitch deploy to tag. Optional. Set tag to "latest" for full deploy.
    --deploy-chain-to-tag TAG       Sqitch deploy entire chain of databases up to tag. Optional. Set tag to "latest" for full deploy.
    --sqitch-project PROJECT        Sqitch project to deploy

examples

Deploy changes to a new database based on sead_production_202401 and to tag @2024.03:

λ ./bin/deploy-staging --create-database --source-type db --source sead_production_202401 --deploy-to-tag @2024.03

Deploy changes to a new database from starting point (sead_master_9) to tag @2024.03:

λ ./bin/deploy-staging --create-database --source-type dump --target-db-name sead_test_202403 --deploy-to-tag @2024.03


Deploy entire sequence of monthly databases starting from sead_master_9 equal du (--source ./starting_point/sead_master_9_public.sql.gz ) and ending at tag @2022.12.
The databases will be named sead_test_yyymmm based on tag. I a database already exists then it will be renamed to sead_test_yyymmm_YYYYMMDDHHMMSS.

λ ./bin/deploy-staging --create-database --source-type dump --target-db-name sead_test --deploy-chain-to-tag @2022.12
```

## Move a change between projects

```man
usage: rm-cr OPTIONS...

Move a change from one project to another project. 
If change is not found, no action is taken.

    --change                Change to remove.
    --from-project NAME     Project change belongs to.
    --to-project NAME       Project change should be moved to.
    --tag TAG               Move change to TAG in destination plan.
    --no-update-plan        Do not update Sqitch plans.

Example:

bin/mv-cr --from-project general --to-project bugs --change "20231201_XYZ" --tag @2023.12
```

# Add and relate a Github issue to a CR

```man
usage: add-issue --change CR --body BODY OPTIONS...

Uses Github CLI tool "gh" to a add new issue to Github. The issue will be named after the change and will have a text BODY added to it.
You can optionally add a label (defaults to "change-request") and assignee (defaults to "@me").
A URL link to the Github issue will be added to the Sqitch project plan.
A URL link to the CRs SQL deploy file will be added to the issue body.

If an existing issue is specified (--issue-id), then this issue will be related to the CR instead of creating a new one.

If change is not found, no action is taken.

    --change CR             Change that new issue will belong to.
    --project NAME          Project change belongs to.
    --body BODY             Text that will be added to issue.
    --label LABEL           Labels (comma seperated) that will added to issue.
    --assignee USER         Github user issue will be assigned to (default @me).
    --issue-id ISSUE        Use issue ISSUE instead of creating a new one.
    --no-update-plan        Do not add URL link to ISSUE in Sqitch project plan.
    --use-plan-co           Add CR's comment in Sqitch plan to issue body.
    --close-issue           Close issue when done.

Example:

bin/add-issue --change YYYYMMDD_XYZ --project general --label bugs --body "Some text" --close-issue

```