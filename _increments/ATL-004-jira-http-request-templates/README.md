# ATL-004 Jira HTTP Request Templates

## Status

- Implemented

## Objective

- Add VS Code REST Client `.http` templates for common Jira issue lookup and basic issue write workflows, covering Jira REST API and Atlassian GraphQL API where suitable.

## Scope

- Add a committed `requests/templates/` directory containing reusable `.http` files.
- Add `make copy-request-templates DEST=requests/local` to copy safe templates into an ignored local request folder for editing.
- Provide templates for:
  - Get a specific issue in the active project.
  - Get all issues for an epic.
  - Get issues by a specific JQL query.
  - Create a basic issue.
  - Update a basic issue.
  - Retrieve the Atlassian Cloud ID for troubleshooting or inspection.
- Support both REST and GraphQL request examples for each issue lookup workflow.
- Use an order processing system as the safe sample domain for create/update issue payloads, with sections for Background, Requirements, and Acceptance Criteria.
- Depend on `ATL-003` for `JIRA_CLOUD_ID` being present in active Jira env profiles.
- Update `.gitignore` so user-created request folders under `requests/` are ignored while committed templates remain tracked.
- Update `README.md` with request template usage and guidance for custom local requests.

## Non-goals

- Build a custom request runner.
- Replace the VS Code REST Client extension.
- Add sprint, board, workflow, transition, comment, attachment, or admin request templates.
- Add Cloud ID persistence to Jira env profiles; that belongs to `ATL-003`.
- Commit user-specific request files or real Jira credentials.

## Dependencies

- `ATL-002` Jira env profile switching.
- `ATL-003` Cloud ID in Jira env profiles.
- VS Code REST Client extension support for `.http` files.
- Jira Cloud REST API access using `JIRA_SITE_URL`, `JIRA_EMAIL`, `JIRA_API_TOKEN`, and `JIRA_PROJECT_KEY`.
- Atlassian GraphQL API access using `JIRA_EMAIL`, `JIRA_API_TOKEN`, and `JIRA_CLOUD_ID`.

## Deliverables

- Increment package under `_increments/ATL-004-jira-http-request-templates/`.
- Planned implementation artifacts:
  - `requests/templates/rest-get-issue.http`
  - `requests/templates/rest-get-epic-issues.http`
  - `requests/templates/rest-search-jql.http`
  - `requests/templates/rest-create-issue.http`
  - `requests/templates/rest-update-issue.http`
  - `requests/templates/graphql-get-cloud-id.http`
  - `requests/templates/graphql-get-issue.http`
  - `requests/templates/graphql-get-epic-issues.http`
  - `requests/templates/graphql-search-jql.http`
  - `.gitignore`
  - `Makefile`
  - `README.md`
