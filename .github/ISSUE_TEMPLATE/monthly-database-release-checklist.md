---
name: Monthly database release checklist
about: Consolidating issue and checklist for monthly database releases
title: SEAD @YYYY.MM release (DATABASE)
labels: monthly-release
assignees: ''

---

### Included change requests

20191222_DML_DATASET_SUBMISSION_UPDATE
20200422_DML_MAL_QOS_UPDATE_02
20200422_DML_MAL_TAXA_SP_SPP_QOS_UPDATE
20200422_UPDATE_BUGS_REFERENCES_YEAR

20200120_DML_ADD_DOMAIN_FACETS
20200203_DML_ADD_DOMAIN_ASSOCS
20200203_DDL_ADD_DOMAIN_TABLE
20200422_DML_FACET_GRAPH_REROUTE

### Other things to note

No `BugsCEP` import this month.

### Checklist

 - [ ] Update/lock current version of SEAD change control system
 - [ ] Archive current SEAD production database
 - [ ] Add release tag to Sqitch database versioning plan
 - [ ] Create a new staging database
 - [ ] Deploy pending changes to staging
 - [ ] Add release tag to SEAD change control repository
 - [ ] Acceptance testing GO/NOGO
 - [ ] Deploy to production
 - [ ] Prepare next months release:
    - [ ] Add new milestone
    - [ ] Add new release project
    - [ ] Add database release issue (use this issue as a template)
