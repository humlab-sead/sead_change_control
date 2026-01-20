# AI Agent Guidelines for SEAD Change Control System

**Version:** 1.0  
**Last Updated:** January 20, 2026  
**Repository:** humlab-sead/sead_change_control

---

## Quick Start for AI Agents

This document provides essential guidelines for AI agents working autonomously with the SEAD Change Control System. Read this first before making any changes.

---

## Critical Constraints

### ❌ NEVER Do This

1. **Never modify deployed change requests** - Create new CRs instead
2. **Never bypass bin/add-change-request** - Always use the proper workflow
3. **Never commit credentials** - Use .pgpass or ~/vault/
4. **Never deploy directly to production** - Use staging first
5. **Never delete data without backup confirmation**
6. **Never modify sqitch.plan manually** - Use Sqitch commands or bin/ scripts
7. **Never skip GitHub issue creation** - Every CR must have an issue
8. **Never create changes without testing** - Test on staging first

### ✅ ALWAYS Do This

1. **Always follow naming convention:** `YYYYMMDD_[DDL|DML|UDF]_DESCRIPTION`
2. **Always link CRs to GitHub issues**
3. **Always use bin/add-change-request for new changes**
4. **Always add proper SQL headers** (see templates below)
5. **Always test on staging before production**
6. **Always update verify scripts for DDL changes**
7. **Always use transactions in SQL scripts**
8. **Always document deployment dependencies**

---

## System Architecture (Essential Knowledge)

### Deployment Order (CRITICAL)
```
utility → sead_model → security → general → 
mal → archaeobotany → dendrochronology → adna → bugs → isotope → 
ceramics → radiocarbon → subsystem → sead_api → facet
```

**Do NOT change this order without explicit approval.**

### Forward-Only Philosophy

- **No rollback capability** - Changes are permanent
- Mistakes require new CRs to fix
- Rollback = restore from backup (manual process)
- Plan carefully, test thoroughly

### Project Selection Guide

| Change Type | Project | Example |
|-------------|---------|---------|
| Schema (DDL) | general | Add table, alter column |
| Lookup data (DML) | general or specific | Update reference data |
| Utility functions | utility | Generic SQL functions |
| Security/roles | security | GRANT, CREATE ROLE |
| API changes | sead_api | External API modifications |
| Bugs data | bugs | BugsCEP integration |
| MAL lab data | mal | Umeå lab data |
| Archaeobotany | archaeobotany | Plant remains |
| Dendro data | dendrochronology | Tree-ring data |
| Ancient DNA | adna | aDNA analysis |
| Isotopes | isotope | Isotopic analysis |
| Ceramics | ceramics | Pottery data |
| Radiocarbon | radiocarbon | C14 dating |
| Subsystems | subsystem | System components |
| Facet system | facet | REST query storage |

---

## Standard Workflows

### Creating a New Change Request

```bash
# Standard CR with new issue
bin/add-change-request \
  --project general \
  --change 20260120_DDL_ADD_EXAMPLE_TABLE \
  --note "Add table for storing example data" \
  --create-issue

# CR with existing issue
bin/add-change-request \
  --project general \
  --change 20260120_DML_UPDATE_LOOKUPS \
  --note "Update lookup values" \
  --issue-id 405
```

### Deploying to Staging

```bash
# Deploy all projects to latest
./bin/deploy-staging \
  --create-database \
  --source-type empty \
  --target-db-name sead_test_$(date +%Y%m%d) \
  --deploy-to-tag latest

# Deploy specific project
./bin/deploy-staging \
  --target-db-name sead_staging \
  --deploy-to-tag latest \
  --sqitch-project general
```

### Checking Status

```bash
# Check deployment status
make status target_databases=staging

# Check specific project
sqitch status --target staging -C general
```

---

## SQL Standards

### Required Header Template

```sql
-- Deploy project:change_name
/****************************************************************************************************************
  Author        Your Name
  Date          YYYY-MM-DD
  Description   Brief description of change
  Issue         https://github.com/humlab-sead/sead_change_control/issues/NNN
  Prerequisites List any required prior changes
  Reviewer      Name (if applicable)
  Approver      Name (if applicable)
  Idempotent    Yes/No
  Notes         Additional context
*****************************************************************************************************************/

set client_encoding = 'UTF8';
set client_min_messages = error;

BEGIN;

-- Your changes here

COMMIT;
```

### Idempotent Patterns

**For DDL:**
```sql
-- Create table safely
CREATE TABLE IF NOT EXISTS tbl_example (
    example_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Add column safely
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'tbl_example' 
        AND column_name = 'new_column'
    ) THEN
        ALTER TABLE tbl_example ADD COLUMN new_column TEXT;
    END IF;
END $$;
```

**For DML:**
```sql
-- Upsert pattern
INSERT INTO tbl_lookup (id, name, description)
VALUES 
    (1, 'Example', 'Description')
ON CONFLICT (id) 
DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description;
```

### Transaction Guidelines

```sql
-- Use transactions for data safety
BEGIN;

-- Multiple related changes
INSERT INTO tbl_parent (parent_id, name) VALUES (1, 'Parent');
INSERT INTO tbl_child (child_id, parent_id, name) VALUES (1, 1, 'Child');

COMMIT;
```

**Exception:** DDL that cannot be in transactions (e.g., CREATE DATABASE)

---

## Common Tasks

### Add a Table

```bash
# 1. Create CR
bin/add-change-request \
  --project general \
  --change $(date +%Y%m%d)_DDL_ADD_XYZ_TABLE \
  --note "Add table for XYZ data" \
  --create-issue

# 2. Edit SQL
vim general/deploy/$(date +%Y%m%d)_DDL_ADD_XYZ_TABLE.sql
```

```sql
-- Deploy general:20260120_DDL_ADD_XYZ_TABLE

-- [Header as above]

BEGIN;

CREATE TABLE IF NOT EXISTS tbl_xyz (
    xyz_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE tbl_xyz IS 
'Stores XYZ data (issue #405)';

COMMENT ON COLUMN tbl_xyz.xyz_id IS 
'Primary key (automatically incremented).';

COMMIT;
```

### Update Lookup Data

```sql
-- Use UPSERT for idempotency
INSERT INTO tbl_lookups (lookup_id, name, description)
VALUES 
    (1, 'New Value', 'Description'),
    (2, 'Another Value', 'Another description')
ON CONFLICT (lookup_id) 
DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    updated_at = CURRENT_TIMESTAMP;
```

### Alter Column

```sql
-- Safe column modification
ALTER TABLE tbl_example 
ALTER COLUMN description TYPE VARCHAR(1000);

-- Add comment explaining change
COMMENT ON COLUMN tbl_example.description IS 
'Extended to 1000 chars for detailed descriptions (issue #405)';
```

---

## Error Handling Patterns

### Bash Scripts

**Required header:**
```bash
#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
```

**Function pattern:**
```bash
function do_something() {
    local param="$1"
    
    if [[ -z "$param" ]]; then
        echo "Error: param is required" >&2
        return 1
    fi
    
    # Implementation
    
    return 0
}
```

### SQL Error Handling

```sql
-- Check prerequisites
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_name = 'required_table'
    ) THEN
        RAISE EXCEPTION 'Required table does not exist';
    END IF;
END $$;
```

---

## Security Guidelines

### Credentials

**DO:**
- Use `~/.pgpass` (chmod 0600)
- Store in `~/vault/` directory
- Use environment variables

**DON'T:**
- Hardcode passwords
- Commit .env files
- Use PGPASSWORD in scripts

### SQL Injection Prevention

**DO:**
```bash
# Use psql -v for variable substitution
psql -v table_name="'tbl_example'" -f script.sql
```

**DON'T:**
```bash
# Never concatenate user input
psql -c "SELECT * FROM $USER_INPUT"
```

---

## Verification Scripts

### Basic Template

```sql
-- Verify project:change_name

BEGIN;

-- Check table exists
SELECT 1/COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name = 'tbl_example';

-- Check columns
SELECT 1/COUNT(*) FROM information_schema.columns 
WHERE table_name = 'tbl_example' 
  AND column_name = 'example_id';

-- Verify constraints
SELECT 1/COUNT(*) FROM information_schema.table_constraints
WHERE table_name = 'tbl_example'
  AND constraint_type = 'PRIMARY KEY';

ROLLBACK;
```

---

## Release Management

### Monthly Tags

```bash
# Tag all projects (use with caution)
bin/tag-projects \
  --tag "@2026.02" \
  --note "February 2026 release"

# Tag single project
sqitch tag @2026.02 -C general -n "February 2026 release"
```

### Pre-Release Checklist

- [ ] All CRs tested on staging
- [ ] Verify scripts updated (for DDL)
- [ ] GitHub issues linked
- [ ] Dependencies documented
- [ ] Backup created
- [ ] Team notified

---

## Troubleshooting

### Common Issues

**Issue:** Change fails to deploy
```bash
# Check what's deployed
sqitch status --target staging -C general

# Check logs
tail -f logs/deploy-staging/*.log
```

**Issue:** Sqitch plan syntax error
```bash
# Validate plan
sqitch plan -C general
```

**Issue:** Dependency not met
```bash
# Check deployment order
cat projects.txt

# Deploy prerequisite project first
sqitch deploy --target staging -C utility
```

---

## Agent-Specific Guidelines

### When Invoked as Subagent

1. **Understand the task scope** - Don't expand beyond request
2. **Report back clearly** - Summarize what was done
3. **Document decisions** - Explain why choices were made
4. **Note blockers** - Report issues that prevent completion
5. **Test changes** - Verify work before reporting success

### Response Format

```
TASK: [Brief description of what was requested]

ACTIONS TAKEN:
1. [Action 1]
2. [Action 2]
3. [Action 3]

FILES MODIFIED:
- path/to/file1.sql (created CR)
- path/to/file2.sql (updated deploy)

TESTING:
- [How changes were verified]

ISSUES/BLOCKERS:
- [Any problems encountered]

NEXT STEPS:
- [What should be done next, if anything]
```

---

## Quick Reference

### Key Commands

```bash
# Add CR
bin/add-change-request --project PROJECT --change YYYYMMDD_TYPE_DESC --note "..." --create-issue

# Deploy staging
./bin/deploy-staging --create-database --source-type empty --target-db-name NAME --deploy-to-tag latest

# Check status
sqitch status --target staging -C PROJECT

# List CRs
bin/ls-cr --project PROJECT

# Test deploy
sqitch deploy --dry-run --target staging -C PROJECT
```

### Key Files

- `projects.txt` - Deployment order
- `sqitch.plan` - Change registry (per project)
- `.env` - Local environment (gitignored)
- `~/vault/` - Credentials storage
- `~/.pgpass` - PostgreSQL passwords

### Key Directories

- `bin/` - Workflow scripts
- `[project]/deploy/` - Forward migrations
- `[project]/verify/` - Verification scripts
- `logs/` - Deployment logs
- `docs/` - Documentation

---

## Decision Trees

### Should I create a new CR or modify existing?

```
Is the change already deployed?
├─ Yes → Create new CR to modify
└─ No → Can modify existing if not merged
```

### Which project should I use?

```
What type of change?
├─ Schema (DDL) → general (unless domain-specific)
├─ Lookup data → general (unless domain-specific)
├─ Utility function → utility
├─ Security/roles → security
├─ API → sead_api
├─ Domain data → specific project (bugs, mal, etc.)
└─ Facet system → facet
```

### Should I use a transaction?

```
What am I doing?
├─ Multiple related DML → Yes, use BEGIN/COMMIT
├─ DDL + DML → Yes (PostgreSQL supports this)
├─ CREATE DATABASE → No (cannot be in transaction)
└─ Single idempotent DML → Optional but recommended
```

---

## Contact & Escalation

**When to escalate to human:**
- Production deployment decisions
- Security-related changes
- Breaking changes
- Multi-project coordination
- Rollback scenarios
- Unclear requirements

**Issue Tracker:** https://github.com/humlab-sead/sead_change_control/issues

**Maintainer:** Roger Mähler (roger.mahler@umu.se)

---

## Version History

- **1.0** (2026-01-20): Initial agent guidelines

---

**Remember:** This is a production system managing scientific data. When in doubt, ask before acting. Test on staging. Document everything. Safety over speed.
