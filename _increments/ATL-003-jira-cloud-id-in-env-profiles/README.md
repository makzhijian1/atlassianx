# ATL-003 Jira Cloud ID In Env Profiles

## Status

- Implemented

## Objective

- Ensure Jira env initialization also discovers and stores the Atlassian `JIRA_CLOUD_ID` needed for GraphQL requests.

## Scope

- Extend `make init-jira-account` so it writes `JIRA_CLOUD_ID` into `.envs/jira/<name>.env`.
- Add Cloud ID discovery after Jira credentials and project access are validated.
- Retrieve the Cloud ID from the active Jira site's tenant info endpoint.
- Keep the selected Jira env model from `ATL-002`: credentials live in `.envs/jira/<name>.env`, and `.jira-env` stores only the active profile name.
- Update `README.md` so first-time setup states that Cloud ID is captured during init.
- Update `.envs/jira/example.env` to include a placeholder `JIRA_CLOUD_ID`.

## Non-goals

- Add request template collections.
- Add VS Code REST Client `.http` files.
- Add a standalone Cloud ID switching workflow separate from Jira env initialization.
- Add GraphQL issue query templates.

## Dependencies

- `ATL-002` Jira env profile switching.
- `curl`.
- Active Jira Cloud credentials with access to the configured Jira site.
- Jira Cloud tenant info endpoint.

## Deliverables

- `Makefile`
- `scripts/init_jira_account.sh`
- `scripts/test_jira_account.sh`
- `.envs/jira/example.env`
- `README.md`
- `_increments/ATL-003-jira-cloud-id-in-env-profiles/`
