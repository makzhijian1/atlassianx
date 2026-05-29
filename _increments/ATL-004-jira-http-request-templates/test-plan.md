# ATL-004 Test Plan

## Happy Path Tests

- Open each `.http` template in VS Code REST Client and confirm requests can be sent after filling required variables.
- REST specific issue template returns an issue in the active project.
- REST epic template returns issues for a supplied epic.
- REST JQL template returns issues for a supplied JQL query.
- REST create issue template creates a basic issue with order processing sample Background, Requirements, and Acceptance Criteria.
- REST update issue template updates a supplied issue with order processing sample Background, Requirements, and Acceptance Criteria.
- GraphQL specific issue template returns an issue when `JIRA_CLOUD_ID` is configured.
- GraphQL epic template returns issues for a supplied epic when `JIRA_CLOUD_ID` is configured.
- GraphQL JQL template returns issues for a supplied JQL query when `JIRA_CLOUD_ID` is configured.
- `make copy-request-templates DEST=requests/local` copies all nine `.http` templates into `requests/local`.
- Cloud ID retrieval request returns the Cloud ID for `JIRA_SITE_URL`.

## Invalid Input Tests

- Missing active Jira profile produces an obvious request failure or Make error.
- Missing `JIRA_CLOUD_ID` causes GraphQL templates to fail clearly.
- `make copy-request-templates` without `DEST` fails clearly.
- `make copy-request-templates DEST=requests/templates` fails clearly.
- `make copy-request-templates DEST=/tmp/foo` fails clearly.
- Invalid issue key returns a Jira not-found response.
- Invalid JQL returns a Jira validation error.
- Create issue template returns a Jira validation error when the sample issue type is not available in the active project.
- Update issue template returns a Jira not-found or permission response when the target issue is unavailable.

## Partial Failure Tests

- A failed template copy does not partially write outside `requests/`.

## Retry / Idempotency Tests

- Re-running `make copy-request-templates DEST=requests/local` overwrites template copies predictably.
- Re-running request templates has no repository side effects.

## Concurrency Tests

- Multiple local custom request folders can coexist under `requests/` without affecting committed templates.

## Regression Coverage

- `make list-jira-envs`, `make set-jira-env ENV=<name>`, and `make show-jira-env` still work.
- `.env`, `.jira-env`, `.envs/jira/*.env`, and custom `requests/` files remain ignored.
- `requests/templates/**/*.http` remains trackable.
