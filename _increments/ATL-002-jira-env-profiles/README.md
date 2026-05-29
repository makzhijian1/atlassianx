# ATL-002 Jira Env Profiles

## Status

- Implemented

## Objective

- Add Make-centric support for switching between multiple named Jira account and project environment files.

## Scope

- Add `.envs/jira/example.env` as the committed template for Jira env profiles.
- Add `make list-jira-envs` to show available Jira profile names.
- Add `make set-jira-env ENV=<name>` to select a named Jira env profile without copying credentials.
- Add `make show-jira-env` to print a safe summary of the active Jira env.
- Ensure `.env` and non-example Jira env profiles are git ignored.
- Document the workflow in `README.md`.

## Non-goals

- Encrypt local env files.
- Validate Jira credentials when switching profiles.
- Introduce a dependency or profile manager outside Make and portable shell.

## Dependencies

- Prior Jira setup from `ATL-001`.
- Local Jira profile files under `.envs/jira/`.
- Standard shell utilities available on the developer machine.

## Deliverables

- `Makefile`
- `scripts/jira_env_summary.sh`
- `.envs/jira/example.env`
- `.gitignore`
- `README.md`
- `_increments/ATL-002-jira-env-profiles/`
