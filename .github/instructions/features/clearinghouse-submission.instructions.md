---
description: "Use only when the task is specifically about bin/commit-submission, a ready-to-commit Clearinghouse submission, or turning prepared submission data into a change request."
---
# Clearinghouse Submission Workflow

- Use `bin/commit-submission` for the Clearinghouse-to-CR workflow.
- Treat this workflow as integration work: validate project, submission identity, and target database before running commands.
- Keep generated CRs traceable to the submission source and issue.

## Typical Flow

1. Confirm the submission is in a ready-to-commit state.
2. Choose the target project.
3. Run `bin/commit-submission` with explicit mode, date, database, submission id, and note.
4. Inspect the generated SQL before treating it as ready.
5. Validate on staging.

## Command Pattern

```bash
bin/commit-submission \
  --mode new \
  --date 20260527 \
  --database sead_staging \
  --id submission_name \
  --project archaeobotany \
  --note "Import of dataset XYZ from Clearinghouse"
```

## Guardrails

- Do not treat generated SQL as automatically correct.
- Keep workflow notes explicit enough to trace the submission origin later.
- If the submission impacts multiple projects, stop and resolve project boundaries before proceeding.
