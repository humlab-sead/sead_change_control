# AI Assistant Instructions for SEAD Change Control System

## Project Overview

The SEAD (Strategic Environmental Archaeology Database) Change Control System is a sophisticated database change management framework using Sqitch to manage schema and data changes across 15 distinct projects. This system coordinates complex, multi-source archaeological and environmental data using a **forward-only deployment model**.

**Critical Context:** This is a production system managing scientific data. Changes must be carefully tracked, tested, and documented.

---

## Core Principles

### 1. Forward-Only Philosophy
- **No general rollback capability** - Changes are designed to be permanent
- Rollback requires restore from backup
- All changes must be carefully considered before deployment
- Use tags (@YYYY.MM) for release points

### 2. Change Tracking
- **Every change must be linked to a GitHub issue**
- All changes tracked in sqitch.plan files
- Comprehensive audit trail required
- Monthly release cycle with coordinated tags

### 3. Multi-Project Architecture
- 15 Sqitch projects with specific purposes
- Strict deployment order defined in `projects.txt`
- Clear separation between schema, data, and subsystems

---

## Project Structure

### Sqitch Projects (in deployment order)

```
utility          → Generic utility functions (foundation)
sead_model       → Core SEAD schema and lookups
security         → Database roles and privileges
general          → Main schema and general data (66 changes)
mal              → MAL laboratory data (Umeå University)
archaeobotany    → Archaeobotany data type
dendrochronology → Dendrochronology data type
adna             → Ancient DNA data
bugs             → BugsCEP data integration
isotope          → Isotope analysis data
ceramics         → Ceramics data type
radiocarbon      → Radiocarbon dating data
subsystem        → Subsystem components
sead_api         → External API changes
facet            → REST query system storage
```

### Directory Structure

```
/bin/                   - Workflow automation scripts
  add-change-request    - Create new CR (PRIMARY TOOL)
  deploy-staging        - Deploy database (COMPLEX - 841 lines)
  commit-submission     - Clearinghouse data integration
  utility.sh            - Common functions library
  
/[project]/            - Individual Sqitch projects
  deploy/              - Forward migration SQL scripts
  revert/              - Rollback scripts (minimal/unused)
  verify/              - Verification scripts (mostly stubs)
  archive/             - Historical/deprecated changes
  sqitch.plan          - Change registry with metadata
  
/resources/
  tables_and_columns.csv - Schema documentation (808 lines)
  
/starting_point/       - Legacy snapshot files (no longer used)
/docs/                 - Project documentation
/logs/                 - Deployment logs
/.vscode/              - VS Code configuration
  mcp.json             - Model Context Protocol servers
```

---

## Change Request (CR) Conventions

### Naming Pattern

**Format:** `YYYYMMDD_[TYPE]_DESCRIPTION`

**Types:**
- `DDL` - Data Definition Language (schema changes)
- `DML` - Data Manipulation Language (data changes)
- `UDF` - User-Defined Functions

**Examples:**
```
20260120_DDL_ADD_SITE_LOCATION_TABLE
20260115_DML_UPDATE_TAXONOMY_LOOKUPS
20251220_DDL_ALTER_SAMPLE_DIMENSIONS
```

### CR Lifecycle

1. **Create GitHub Issue** (required)
2. **Add CR using bin/add-change-request**
3. **Write SQL in deploy/ folder**
4. **Test on staging database**
5. **Update verify script** (if applicable)
6. **Link to issue in sqitch.plan**
7. **Include in monthly release**

---

## Key Workflows

### Creating a New Change Request

```bash
# Standard CR creation with automatic issue creation
bin/add-change-request \
  --project general \
  --change 20260120_DDL_ADD_EXAMPLE_TABLE \
  --note "Add new table for storing example data" \
  --create-issue

# CR with existing issue
bin/add-change-request \
  --project sead_model \
  --change 20260120_DML_UPDATE_LOOKUPS \
  --note "Update lookup values for new data type" \
  --issue-id 405
```

### Deploying to Staging

```bash
# Deploy from empty database to latest
./bin/deploy-staging \
  --create-database \
  --source-type empty \
  --target-db-name sead_staging_test \
  --deploy-to-tag latest

# Deploy to specific tag
./bin/deploy-staging \
  --create-database \
  --source-type empty \
  --target-db-name sead_test_202412 \
  --deploy-to-tag @2024.12

# Deploy only one project
./bin/deploy-staging \
  --target-db-name sead_staging \
  --deploy-to-tag latest \
  --sqitch-project general
```

### Committing Clearinghouse Submissions

```bash
# Create new CR from Clearinghouse submission
bin/commit-submission \
  --mode new \
  --date 20260120 \
  --database sead_staging \
  --id submission_name \
  --project archaeobotany \
  --note "Import of dataset XYZ from Clearinghouse"
```

### Checking Deployment Status

```bash
# Check all projects on staging
make status target_databases=staging

# Check specific project
make status target_databases=staging projects=general

# Using sqitch directly
sqitch status --target staging -C general
```

---

## Important Scripts & Tools

### bin/add-change-request ✅ PRIMARY TOOL
- Creates new change requests
- Integrates with GitHub issues
- Updates sqitch.plan
- Calls update-cr-header for metadata

**Error Handling:** ✅ Uses `set -e`
**Complexity:** Low (119 lines)
**Safety:** High

### bin/deploy-staging ⚠️ COMPLEX
- Creates/deploys databases
- Multiple modes (empty, dump, db, chain)
- Executes pre/post-deploy hooks
- Comprehensive logging

**Error Handling:** ⚠️ Partial (has `set -e` but inconsistent propagation)
**Complexity:** High (841 lines, 20+ functions)
**Safety:** Medium (needs refactoring)

**CAUTION:** This script has many options. Always test on non-production first.

### bin/commit-submission ⚠️ MODERATE
- Integrates Clearinghouse data
- Generates compressed SQL scripts
- Multiple modes (new, update, only_data)

**Dependencies:** External transport system
**Error Handling:** ⚠️ Limited
**Complexity:** Medium (536 lines)

### bin/utility.sh - Common Functions
```bash
get_projects()        # Read projects.txt in order
get_change_tag()      # Find release tag for CR
find_project()        # Locate project containing CR
get_cr_issue_url()    # Extract GitHub issue URL
get_cr_issue_id()     # Extract issue number
```

---

## Code Quality Standards

### Bash Scripts

**Required in all new/modified scripts:**
```bash
#!/bin/bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures
IFS=$'\n\t'        # Safe word splitting
```

**Current state:** Only 19/40+ scripts have proper error handling

**Function Structure:**
```bash
function do_something() {
    local param1="$1"
    local param2="$2"
    
    # Validate inputs
    if [[ -z "$param1" ]]; then
        error "param1 is required"
        return 1
    fi
    
    # Implementation
    # ...
    
    return 0
}
```

### SQL Scripts

**Header Template:**
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

-- Your changes here

```

**Best Practices:**
- Use transactions where appropriate
- Comment complex logic
- Include rollback considerations in comments
- Test idempotency where possible

---

## Security Considerations

### Credentials Management

**DO:**
- ✅ Use `~/.pgpass` for passwords (chmod 0600)
- ✅ Store connection info in `~/vault/` directory
- ✅ Use environment variables for connection parameters
- ✅ Keep `.env` in `.gitignore` (already configured)

**DON'T:**
- ❌ Put passwords in scripts
- ❌ Commit `.env` files
- ❌ Use PGPASSWORD in process environment (visible in ps)
- ❌ Hard-code connection strings

**Files:**
```bash
~/.pgpass format:
hostname:port:database:username:password

~/vault/ files:
.default.sead.server     # hostname
.default.sead.username   # username
.sqitch.env              # Sqitch variables
```

### SQL Injection Prevention

**DO:**
- ✅ Use psql `-v` flag for variable substitution
- ✅ Use prepared statements where possible
- ✅ Validate all inputs in scripts

**AVOID:**
- ⚠️ String concatenation in SQL generation
- ⚠️ Unvalidated variable interpolation

---

## Testing & Validation

### Current State
- ❌ No automated test suite
- ❌ No CI/CD testing pipeline
- ⚠️ Verify scripts mostly empty (template stubs)
- ✅ Manual testing on staging before production

### What to Test

**Before committing CR:**
1. Syntax validation (SQL linting)
2. Dry run on test database
3. Verify idempotency if applicable
4. Check for dependency issues
5. Test on staging database

**Verify Script Template:**
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

-- Verify constraints/indexes as needed

ROLLBACK;
```

---

## Common Tasks & Examples

### Task 1: Add a New Table

```bash
# 1. Create issue on GitHub
gh issue create --title "Add table for XYZ" --body "Description"

# 2. Add CR
bin/add-change-request \
  --project general \
  --change 20260120_DDL_ADD_XYZ_TABLE \
  --note "Add table for storing XYZ data" \
  --issue-id 405

# 3. Edit deploy script
vim general/deploy/20260120_DDL_ADD_XYZ_TABLE.sql

# 4. Test on local/staging
./bin/deploy-staging --target-db-name test_db --deploy-to-tag latest

# 5. Commit and push
git add general/
git commit -m "feat: add XYZ table (resolves #405)"
git push
```

### Task 2: Update Lookup Data

```bash
# 1. Add DML change request
bin/add-change-request \
  --project general \
  --change 20260120_DML_UPDATE_LOOKUPS \
  --note "Update lookup values for season types" \
  --create-issue

# 2. Create SQL with data
vim general/deploy/20260120_DML_UPDATE_LOOKUPS.sql
```

```sql
-- Use UPSERT pattern for idempotency
INSERT INTO tbl_seasons (season_id, season_name, season_type)
VALUES 
  (1, 'Spring', 'Growing'),
  (2, 'Summer', 'Growing')
ON CONFLICT (season_id) 
DO UPDATE SET 
  season_name = EXCLUDED.season_name,
  season_type = EXCLUDED.season_type;
```

### Task 3: Modify Existing Column

```bash
bin/add-change-request \
  --project general \
  --change 20260120_DDL_ALTER_SAMPLE_DESCRIPTION \
  --note "Increase length of sample description field" \
  --create-issue
```

```sql
-- Safe column alteration
ALTER TABLE tbl_physical_samples 
ALTER COLUMN sample_description TYPE varchar(500);

-- Add comment explaining change
COMMENT ON COLUMN tbl_physical_samples.sample_description IS 
'Extended to 500 chars to accommodate detailed descriptions (issue #405)';
```

---

## Release Management

### Monthly Release Process

**Release Tags:** `@YYYY.MM` (e.g., @2025.02)

**Checklist:**
1. ✅ Update/lock change control system version
2. ✅ Archive current production database
3. ✅ Add release tag to all project sqitch.plans
4. ✅ Create new staging database
5. ✅ Deploy all pending changes to staging
6. ✅ Add release tag to Git repository
7. ✅ Acceptance testing (GO/NOGO decision)
8. ✅ Deploy to production
9. ✅ Prepare next month's release

**Tagging All Projects:**
```bash
# Use Makefile target (verify first!)
make tag-all tag=@2026.02 description="February 2026 release"

# Or manually for each project
sqitch tag @2026.02 -C utility -n "February 2026 release"
sqitch tag @2026.02 -C sead_model -n "February 2026 release"
# ... etc
```

### Version Control

**Branching:**
- `main` - Production-ready code
- Feature branches for major changes
- Hotfix branches for urgent fixes

**Commits:**
- Follow conventional commits format
- Reference issue numbers
- Clear, descriptive messages

**Examples:**
```
feat: add site location accuracy field (resolves #320)
fix: correct dendro lookup data (fixes #325)
docs: update deployment guide
refactor: simplify deploy-staging validation
```

---

## Database Schema Reference

### Key Tables (from resources/tables_and_columns.csv)

**Core Entities:**
- `tbl_sites` - Archaeological sites
- `tbl_physical_samples` - Physical samples from sites
- `tbl_analysis_entities` - Analytical units
- `tbl_datasets` - Dataset metadata
- `tbl_taxa_tree_master` - Taxonomic hierarchy

**Abundance Data:**
- `tbl_abundances` - Species abundance records
- `tbl_abundance_elements` - Types of elements counted
- `tbl_abundance_modifications` - Modification states

**Dating:**
- `tbl_dating_uncertainty` - Dating uncertainties
- `tbl_relative_ages` - Relative chronology
- `tbl_geochronology` - Absolute dates

**Bibliographic:**
- `tbl_biblio` - References and citations

**Total:** 808 documented tables/columns

---

## Known Issues & Limitations

### System Limitations

1. **No Automated Rollback**
   - Forward-only by design
   - Manual recovery requires backup restore
   - Plan changes carefully

2. **No Automated Testing**
   - Manual testing required
   - No CI/CD validation
   - Regression risk exists

3. **Complex Deployment Script**
   - `bin/deploy-staging` is 841 lines
   - Multiple failure modes
   - Needs refactoring (planned)

4. **Verify Scripts Empty**
   - Most contain only `-- XXX Add verifications here.`
   - No automated verification
   - Manual checks required

### Active Technical Debt

- **Error Handling:** Only 47% of scripts use `set -e`
- **Documentation:** Some bin/ scripts undocumented
- **Testing:** No automated test suite
- **Monitoring:** No deployment metrics/alerting

---

## When Working with AI/Copilot

### DO:

✅ **Ask about:**
- CR naming conventions
- Project structure and dependencies
- Sqitch commands and workflows
- SQL best practices for SEAD schema
- Deployment procedures and safety

✅ **Request help with:**
- Writing deploy scripts following templates
- Creating verify scripts
- Bash script improvements
- Documentation updates
- Finding relevant code/CRs

✅ **Always:**
- Reference GitHub issue numbers
- Follow naming conventions
- Include proper SQL headers
- Test on staging first
- Update related documentation

### DON'T:

❌ **Avoid:**
- Suggesting changes without GitHub issues
- Creating CRs outside the proper workflow
- Modifying sqitch.plan manually
- Bypassing bin/add-change-request
- Making production changes without testing
- Storing credentials in code

❌ **Never:**
- Deploy directly to production
- Delete data without backup
- Modify deployed CRs (create new ones instead)
- Commit `.env` files
- Skip verification steps

---

## AI Code Generation Guidelines

### When generating SQL:

```sql
-- ✅ GOOD: Clear, commented, safe
ALTER TABLE tbl_sites 
ADD COLUMN IF NOT EXISTS location_accuracy numeric(10,2);

COMMENT ON COLUMN tbl_sites.location_accuracy IS 
'Accuracy of site location in meters (added for issue #123)';

-- ❌ BAD: No comments, not idempotent
ALTER TABLE tbl_sites ADD COLUMN location_accuracy numeric(10,2);
```

### When generating Bash scripts:

```bash
# ✅ GOOD: Error handling, validation, clear
#!/bin/bash
set -euo pipefail

function process_data() {
    local input_file="$1"
    
    if [[ ! -f "$input_file" ]]; then
        echo "Error: File not found: $input_file" >&2
        return 1
    fi
    
    # Process...
}

# ❌ BAD: No error handling, no validation
#!/bin/bash
function process_data() {
    cat $1 | grep something
}
```

### When suggesting changes:

✅ **Include:**
- Rationale and context
- Impact assessment
- Testing recommendations
- Rollback considerations
- Documentation updates

❌ **Avoid:**
- Breaking changes without migration path
- Undocumented complexity
- Untested code
- Security vulnerabilities

---

## Useful Commands Reference

### Sqitch

```bash
# Show deployment status
sqitch status --target staging -C general

# Deploy to tag
sqitch deploy @2026.02 --target staging -C general

# Show deployment history
sqitch log --target staging -C general

# Revert last change (RARELY USED)
sqitch revert HEAD~1 --target staging -C general
```

### Database

```bash
# Connect to staging
psql -h humlabseadserv.srv.its.umu.se -p 5433 -U humlab_admin -d sead_staging

# Or using bin script
bin/psql.sh

# Check table counts
psql -c "SELECT schemaname, COUNT(*) FROM pg_tables WHERE schemaname = 'public' GROUP BY schemaname"
```

### Utility

```bash
# List all CRs in a project
bin/ls-cr --project general

# Find which project contains a CR
bin/utility.sh # then use find_project function

# Get CR issue URL
grep "20260120" general/sqitch.plan
```

---

## Resources

- **Main README:** [/README.md](../README.md)
- **Project Review:** [/docs/project-review-2026-01-20.md](../docs/project-review-2026-01-20.md)
- **Deployment Guide:** [/bin/deploy-staging.md](../bin/deploy-staging.md)
- **Sqitch Documentation:** https://sqitch.org/
- **Schema Documentation:** [/resources/tables_and_columns.csv](../resources/tables_and_columns.csv)
- **Issue Templates:** [/.github/ISSUE_TEMPLATE/](../.github/ISSUE_TEMPLATE/)

---

## Quick Decision Tree

```
Need to make a database change?
│
├─ Schema change (DDL)?
│  └─ Create CR in appropriate project (usually 'general' or 'sead_model')
│     └─ bin/add-change-request --project general --change YYYYMMDD_DDL_...
│
├─ Data change (DML)?
│  ├─ Lookup data?
│  │  └─ Add to appropriate project (general, or data-type specific)
│  └─ Scientific data from Clearinghouse?
│     └─ Use bin/commit-submission
│
├─ API change?
│  └─ Use 'sead_api' project
│
├─ Security change?
│  └─ Use 'security' project
│
└─ Utility function?
   └─ Use 'utility' project
```

---

## Contact & Support

- **Issues:** https://github.com/humlab-sead/sead_change_control/issues
- **Maintainer:** Roger Mähler (roger.mahler@umu.se)
- **Organization:** Humlab SEAD, Umeå University

---

**Last Updated:** January 20, 2026  
**AI Instructions Version:** 1.0
