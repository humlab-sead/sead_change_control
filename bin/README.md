# Deploy Clearinghouse System Bash Script

This repository contains a Bash script designed for deploying the Clearinghouse System. The script automates the generation and deployment of SQL change requests and integrates with the SEAD Change Control System.

## Features
- Supports different deployment modes: `dryrun`, `update`, and `new`.
- Automatically generates SQL deploy scripts based on provided SQL files.
- Handles schema creation with options to drop, update, or abort if the schema already exists.
- Creates and updates issues in GitHub when specified.

## Usage

### Command-line options
```bash
usage: deploy-clearinghouse [--mode update|new|dryrun] [--sql-folder FOLDER] [--force]

       --mode dryrun|update|new  Whether to update an existing change request or add a new one to the SEAD Control System
               dryrun           Generate a change request in the target folder but do not update or add to the SEAD Control System
               update           Update the deploy script in an existing change request in the SEAD Control System
               new              Add a new change request to the SEAD Control System (mandatory)
       --note                   Note added to the change request and issue
       --related-issue-id       Related issue GitHub ID
       --no-create-issue        Do not create a new GitHub issue
       --sql-folder FOLDER      Folder containing Clearinghouse SQL scripts (mandatory)
       --force                  Force overwrite of existing temporary folder
       --work-folder FOLDER     Override default temporary directory (not recommended)
       --change                 Override the default change request name
       --on-schema-exists       Action to take if the schema already exists: drop, abort, or update (default: drop)
```

### Example usage
#### 1. Dry-run mode
```bash
deploy-clearinghouse --mode dryrun --sql-folder ./sql_scripts
```
This command generates a deploy script in the specified folder but does not update or add it to the SEAD Control System.

#### 2. Adding a new change request
```bash
deploy-clearinghouse --mode new --sql-folder ./sql_scripts --note "Initial deployment of Clearinghouse System"
```
This command adds a new change request to the SEAD Control System with an optional note.

#### 3. Updating an existing change request
```bash
deploy-clearinghouse --mode update --sql-folder ./sql_scripts --force
```
This command updates an existing change request and forces the overwrite of the existing deploy script.

## How it works
1. **Modes:**
   - `new`: Generates a new change request and adds it to the SEAD Change Control System.
   - `update`: Updates an existing change request.
   - `dryrun`: Generates a deploy script without updating or adding it.

2. **Schema Handling:**
   - The script supports actions for existing schemas: `drop`, `abort`, or `update`.

3. **Change Request Generation:**
   - The script generates a deploy script with headers containing metadata such as author, date, description, and issue ID.

4. **GitHub Integration:**
   - Optionally creates or links related issues on GitHub using the provided `--related-issue-id` or `--no-create-issue` option.

## Requirements
- Bash shell (`/bin/bash`)
- Access to the SEAD Control System for adding or updating change requests
- Properly structured SQL files in the specified folder

## License
This script is licensed under the MIT License. See `LICENSE` for more details.

## Contribution
Contributions are welcome! Please fork the repository and submit a pull request.

## Author
This script was authored by the SEAD Change Control System team.

