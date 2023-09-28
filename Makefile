SHELL := /bin/bash

RED=\033[0;31m
NO_COLOR=\033[0m

DEFAULT_SERVER := humlabseadserv.srv.its.umu.se
TARGET_DATABASES_ALL := $(shell grep "\[target" sqitch.conf | grep -oP "\".*\"")
SOURCE_STARTING_POINT := ./starting_point/sead_master_9_public.sql.gz
TARGET_RELEASE := @2020.03

known_release_tags=$(shell grep --no-filename -E "^@" */sqitch.plan | cut --delimiter=' ' --fields=1 | sort | uniq)

default_projects := utility security general sead_api subsystem submissions

ifeq ($(projects),)
projects := $(shell find . -maxdepth 1 -mindepth 1 -type d -exec test -e {}/deploy \; -print)
endif

ifeq ($(target_databases),)
target_databases := staging production
endif

ifeq ($(target_databases),ALL)
target_databases := staging production
endif

include .env
export SQITCH_PASSWORD

ifndef SQITCH_PASSWORD
	$(error SQITCH_PASSWORD is not set)
endif


.PHONY: help
help:
	@echo "SEAD Change Control recepis:"
	@echo
	@echo "  make create-staging-from-scratch        Create staging from starting point (sead_master_9)"
	@echo
	@echo "  make deploy-staging-to-production       $(RED)DANGER ZONE$(NO_COLOR) Deploy staging to production"
	@echo
	@echo "  make status                             Show deploy status for production database and all sqitch projects"
	@echo "    make status target_databases=ALL      Show deploy status for all databases"
	@echo "    make status target_databases=staging  Show deploy status for database staging"
	@echo "    make status projects=general    		 Show deploy status for project general"
	@echo
	@echo "  make show-config                        Show sqitch config"
	@echo

.PHONY: create-staging-from-scratch
create-staging-from-scratch: are-you-sure
	@echo "Create sead_staging based on sead_master_9_public..."
	@./bin/deploy-staging ....not impemented...
	@echo "Done!"

.PHONY: deploy-staging-to-production
deploy-staging-to-production: are-you-really-sure
	@echo "Deploying sead_staging to sead_production..."
	@echo ./bin/copy-database --source sead_staging --target sead_production --force --allow-production
	@echo "Done!"

.PHONY: tag-all
tag-all: are-you-really-sure
	@if [[ "$(tag)" == "" || "$(description)" == "" ]] ; then \
		echo "usage: make tag-all tag=tag description=\"description\"" ; \
		exit 64 ; \
	fi
	@for project in $(projects); do \
		echo sqitch tag --tag \"$(tag)\" --plan-file $${project}/sqitch.plan --note \"$(description)\" ; \
	 done

apa:
	@echo $(warning $(sort $(projects))) ;

.PHONY: status
.ONESHELL: status
status:
	@for target_database in $(target_databases); do \
		echo "Changes not deployed in \"$$target_database\":" ; \
		for project in $(sort $(projects)); do \
			echo "  $$project: " ; \
			sqitch status --target $$target_database -C $$project \
				| grep -v "^#" \
				| grep -v '^[[:space:]]*$$' \
				| grep -v "^Undeployed change" \
				| grep -v "^No changes deployed" \
				| grep -v "^Nothing to deploy"; \
			echo ; \
		done \
	done

show-config:
	@sqitch config -l

.PHONY: are-you-sure
are-you-sure:
	@echo -n "Are you sure? [yes/N] " && read yes_no && [ $${yes_no:-N} = yes ]

.PHONY: are-you-really-sure
are-you-really-sure: are-you-sure
	@echo -n "Are you $(RED)really$(NO_COLOR) sure? [yes/N] " && read yes_no && [ $${yes_no:-N} = yes ]

.ONESHELL: clean-repository-guard
clean-repository-guard:
	@status="$$(git status --porcelain)"
	@if [[ "$$status" != "" ]]; then
		echo "error: changes exists, please commit or stash them: "
		echo "$$status"
		exit 65
	fi

psql-staging:
	psql -h $(DEFAULT_SERVER) -d sead_staging -U humlab_admin

# .PHONY: ask-for-password
# .ONESHELL: ask-for-password
# ask-for-password:
# 	@if [[ "$$SQITCH_PASSWORD" == "" ]] ; then \
# 		read -s -p "Password: " pwd ; \
# 		if [[ "$$pwd" == "" ]] ; then \
# 			exit 65 ; \
# 		fi ; \
# 		export SQITCH_PASSWORD=$$pwd ; \
# 	fi

# | grep -v 'Change:\|By:\|Name:'


SQITCH_TARGET := staging-test
deploy-@2020.03-staging-test:
	@bin/copy-database --source sead_production --target sead_staging_test --force
	@sqitch deploy --target $(SQITCH_TARGET) -C ./utility --to @2020.03 --no-verify
	@sqitch deploy --target $(SQITCH_TARGET) -C ./security --to @2020.03 --no-verify
	@sqitch deploy --target $(SQITCH_TARGET) -C ./general --to @2020.03 --no-verify
	@sqitch deploy --target $(SQITCH_TARGET) -C ./sead_api --to @2020.03 --no-verify
	@sqitch deploy --target $(SQITCH_TARGET) -C ./subsystem --to @2020.03 --no-verify
	@sqitch deploy --target $(SQITCH_TARGET) -C ./submissions --to @2020.03 --no-verify
	@pg-diff -f compare/config.json -c development @2020.03-staging-vs-staging-test


deploy-@2022.12-staging-test: deploy-@2020.03-staging-test
	@for project in $(default_projects); do \
		echo sqitch deploy --target $(SQITCH_TARGET) -C ./utility --to @2022.12 --no-verify ; \
	done


install-pg-diff:
	@mkdir -p ~/.npm/lib/bin \
		&& npm config set prefix "~/.npm/lib" \
		&& npm install --global pg-diff-cli \
		&& echo "please make sure ~/.npm/lib/bin is added to path"

TARGET_STAGING_DATABASE=sead_staging_incremental_deploy

# staging_@2019.12:
# 	@./bin/deploy-staging --create-database --on-conflict drop \
# 		--source-type dump --source $(ST) \
# 			--target-db-name $(TARGET_STAGING_DATABASE) --deploy-to-tag @2019.12

# staging_@2020.01: staging_@2019.12
# 	@./bin/deploy-staging --target-db-name $(TARGET_STAGING_DATABASE) --deploy-to-tag @2020.01

# staging_@2020.02: staging_@2020.01
# 	@./bin/deploy-staging --target-db-name $(TARGET_STAGING_DATABASE) --deploy-to-tag @2020.02

# staging_@2020.03: staging_@2020.02
# 	@./bin/deploy-staging --target-db-name $(TARGET_STAGING_DATABASE) --deploy-to-tag @2020.03

# psql-@2020.02:
# 	psql -h $(DEFAULT_SERVER) -d $(TARGET_STAGING_DATABASE) -U humlab_admin

repos:
	@sead_repositories="$(shell gh repo list humlab-sead --json "name" --jq '["name"],(.[] | [.name]) | @tsv')" \
		&& echo $$sead_repositories

issues:
	@gh issue list --state all --limit 999 \
		--repo humlab-sead/sead_change_control \
		--json number,title,state,author,assignees,projectCards,body,comments,labels,body \
		--jq '["number","title","state","author","assignees","project","body"], (.[] | [.number,.title,.state,.author.login,(.projectCards | map(.project) | map(.name) | join(",")),(.labels | map(.name) | join(",")),.body]) | @tsv'

all-issues:
	@sead_repositories="$(shell gh repo list humlab-sead --json "name" --jq '(.[] | [.name]) | @tsv')" \
	 && filename=issue_list_$(shell date "+%Y%m%d").csv \
	 && echo $$'repo\tnumber\ttitle\tstate\tauthor\tassignees\tproject\tbody' > $$filename \
	 && for repo in $$sead_repositories ; do \
	 	gh issue list --state all --limit 9999 \
		--repo humlab-sead/$$repo \
		--json number,title,state,author,assignees,projectCards,body,comments,labels,body \
		--jq '(.[] | ["'$$repo'", .number,.title,.state,.author.login,(.projectCards | map(.project) | map(.name) | join(",")),(.labels | map(.name) | join(",")),.body]) | @tsv' >> $$filename; \
	done

TARGET_RELEASE := @2022.12

target_prefix="sead_staging_test"

# pg_dump -h humlabseadserv.srv.its.umu.se -U humlab_admin -d sead_production_202002 --schema=clearing_house --data-only --blobs --format=p --encoding=UTF8 -f

clearinghouse-initial-data-snapshot:
	pg_dump -h humlabseadserv.srv.its.umu.se -U humlab_admin -d sead_production_202002 --schema=clearing_house --data-only --blobs --format=p --encoding=UTF8 -f 2020190115_DML_CLEARINGHOUSE_DATA.sql

pgc_diff:
	@./pgc compare -x sead_staging_test_202001.snap --schemaX public -y sead_production_202001.snap --schemaY public -o sead_202001_public.compare --summarize

staging_databases: staging_databases_prepare staging_databases_create staging_databases_cleanup
	@echo "Done!"

staging_databases_prepare:
	@gunzip -f -k submissions/deploy/20191221_DML_SUBMISSION_BUGS_20190303_COMMIT/*.gz

staging_databases_cleanup:
	@rm -f submissions/deploy/20191221_DML_SUBMISSION_BUGS_20190303_COMMIT/*.sql

staging_databases_create:
	@source_type=dump; \
	 source_db_name=$(SOURCE_STARTING_POINT); \
	 for current_tag in $(known_release_tags); do \
		target_db_name="$(target_prefix)_`echo $$current_tag | sed 's/\.//g' | sed 's/\@//g'`"; \
		./bin/deploy-staging --create-database --on-conflict drop \
				--source-type $$source_type --source $$source_db_name \
					--target-db-name $$target_db_name --deploy-to-tag $$current_tag; \
		source_db_name="$$target_db_name"; \
		source_type="db";\
	 	if [ "$$current_tag" == "$(TARGET_RELEASE)" ]; then \
			break; \
		fi; \
	done

db-diff:
	@pushd . \
	 && cd src/sead_utility \
	 && poetry run python compare_options.py public.json -h $(DEFAULT_SERVER) -u humlab_admin \
		-s public -sd sead_staging -td sead_staging_test_202002 -o ./output -r humlab_admin -dc \
	 && popd \

deploy-log:
	@sqitch log \
		--event deploy \
		--target staging-test \
		--format oneline \
		--abbrev 6 \


