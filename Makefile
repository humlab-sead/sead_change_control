SHELL := /bin/bash

RED=\033[0;31m
NO_COLOR=\033[0m

TARGET_DATABASES_ALL := $(shell grep "\[target" sqitch.conf | grep -oP "\".*\"")

ifeq ($(projects),)
projects := $(shell find . -type d -exec test -e {}/deploy \; -print)
endif

ifeq ($(target_databases),)
target_databases := production
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
	@echo "    make status projects=general    Show deploy status for project general"
	@echo
	@echo "  make show-config                        Show sqitch config"
	@echo

.PHONY: deploy-staging-to-production
create-staging-from-scratch: are-you-sure
	@echo "Create sead_staging based on sead_master_9_public..."
	@echo ./bin/deploy-staging.sh ....not impemented...
	@echo "Done!"

.PHONY: deploy-staging-to-production
deploy-staging-to-production: are-you-really-sure
	@echo "Deploying sead_staging to sead_production..."
	@echo ./bin/copy-database --source sead_staging --target sead_production --force --allow-production
	@echo "Done!"

# @2020.02
.PHONY: tag-all
tag-all: are-you-really-sure
	@if [[ "$(tag)" == "" || "$(description)" == "" ]] ; then \
		echo "usage: make tag-all tag=tag description=\"description\"" ; \
		exit 64 ; \
	fi
	@for project in $(projects); do \
		echo sqitch tag --tag \"$(tag)\" --plan-file $${project}/sqitch.plan --note \"$(description)\" ; \
	 done

.PHONY: status
.ONESHELL: status
status:
	@for database in $(target_databases); do \
		for project in $(projects); do \
			sqitch status --target $$database -C $$project ; \
			echo ; \
		done \
	done
# --show-changes
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

psql:
	psql -h humlabseadserv.srv.its.umu.se -d sead_staging -U humlab_admin

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