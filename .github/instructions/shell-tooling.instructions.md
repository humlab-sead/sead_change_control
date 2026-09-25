---
description: "Use when editing repository shell tooling, including extensionless scripts in bin/, helper scripts under project bin/ folders, and deploy hook files."
applyTo: "bin/**,bugs/bin/**,*/@????.??-pre-deploy-hook,*/@????.??-post-deploy-hook"
---
# Shell Tooling Guidelines

- Treat repository scripts as operational tooling. Prefer small, targeted edits over broad refactors.
- Preserve the existing executable style: most scripts are extensionless and invoked directly from `bin/`.
- For new scripts, or when materially refactoring a script, use `#!/bin/bash` and `set -euo pipefail`.
- For small edits in older scripts, do not force unrelated strict-mode cleanup unless it is needed for correctness.
- Validate inputs early, quote variable expansions, and use `local` inside functions.
- Prefer functions for non-trivial steps and keep argument parsing explicit.
- Reuse shared helpers from `bin/utility.sh` or nearby script utilities before adding duplicate logic.
- Treat `bin/deploy-staging` as the central SEAD deploy script. Be especially conservative when changing it because many deployment and release workflows depend on it.
- Avoid destructive database actions unless the workflow explicitly requires them and the user asked for them.
- Keep help text, examples, and option names aligned with real workflow commands such as `bin/add-change-request`, `bin/deploy-staging`, and `bin/tag-projects`.
- When changing deploy hooks, keep them tag-specific, lightweight, and safe to rerun.