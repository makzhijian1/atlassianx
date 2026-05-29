# ATL-004 Specification

## Behaviour

- The repository exposes reusable Jira API request templates under `requests/templates/`.
- Each template is a `.http` file usable with the VS Code REST Client extension.
- Templates read Jira settings from the active Jira profile where possible.
- REST templates use Jira Cloud REST API endpoints rooted at `JIRA_SITE_URL`.
- GraphQL templates use Atlassian GraphQL API endpoints and require `JIRA_CLOUD_ID` from `ATL-003`.
- REST write templates create and update a basic Jira issue using safe sample content.
- `make copy-request-templates DEST=requests/local` copies committed templates into an ignored local folder for user customization.
- User-created request files and folders under `requests/` are ignored by git unless explicitly committed as templates.
- README explains how to copy or create custom request files under `requests/` and keep them local.

## Contracts

- Committed templates live under `requests/templates/`.
- The committed template files are:
  - `requests/templates/rest-get-issue.http`
  - `requests/templates/rest-get-epic-issues.http`
  - `requests/templates/rest-search-jql.http`
  - `requests/templates/rest-create-issue.http`
  - `requests/templates/rest-update-issue.http`
  - `requests/templates/graphql-get-cloud-id.http`
  - `requests/templates/graphql-get-issue.http`
  - `requests/templates/graphql-get-epic-issues.http`
  - `requests/templates/graphql-search-jql.http`
- `rest-create-issue.http` uses an order processing system sample issue.
- `rest-update-issue.http` uses the same order processing system sample issue and updates the description fields.
- Create/update sample descriptions include:
  - `Background`
  - `Requirements`
  - `Acceptance Criteria`
- User local request files live under any other desired folder under `requests/`.
- Git ignore rules keep local request files out of version control while allowing `requests/templates/**/*.http`.
- `.http` templates must not contain real emails, API tokens, account IDs, issue keys, epic keys, JQL values, or Cloud IDs.
- Templates must not print or echo `JIRA_API_TOKEN`.
- New Make target:
  - `make copy-request-templates DEST=requests/local`
- `make copy-request-templates` fails if `DEST` is empty, `DEST` is `requests/templates`, or `DEST` is outside `requests/`.
- `make copy-request-templates` creates `DEST` if needed and copies `.http` templates there.

## Inputs / Outputs

- Inputs:
  - Active Jira profile.
  - User-provided issue key, epic key, issue type, summary, or JQL query in copied local request files or REST Client variables.
  - Jira API token with permission to read the target project.
  - `JIRA_CLOUD_ID` already set by `ATL-003`.
  - `DEST` value for `make copy-request-templates`.
- Outputs:
  - HTTP responses rendered by the VS Code REST Client extension.
  - Local ignored request files under `DEST` when templates are copied.

## Invariants

- Real credentials and personal request files are not committed.
- Template files are safe to commit.
- REST and GraphQL variants are available for every requested issue lookup workflow.
- REST create/update templates are basic examples and must be easy to customize after copying.
- GraphQL templates clearly depend on `JIRA_CLOUD_ID`.
- Make targets do not print `JIRA_API_TOKEN`.
- Existing Jira env switching and Cloud ID behavior from `ATL-002` and `ATL-003` must not regress.

## Edge Cases

- No active Jira profile is selected.
- `JIRA_CLOUD_ID` is missing when running GraphQL templates.
- `make copy-request-templates` is run without `DEST`.
- `make copy-request-templates` is pointed at `requests/templates`.
- `make copy-request-templates` is pointed outside `requests/`.
- The issue key is not in `JIRA_PROJECT_KEY`.
- The epic has no child issues.
- The JQL query returns no issues.
- The target project does not allow the issue type used by the create template.
- A required custom field is missing from the create template payload.
- The update template targets a missing or inaccessible issue.
- The API token authenticates but cannot access the selected project.

## Failure Semantics

- REST Client requests fail visibly through HTTP status and response body when env values are missing or invalid.
- Create/update templates fail visibly through Jira validation errors when required fields or permissions are missing.
- Cloud ID retrieval template fails with a clear HTTP response if credentials are invalid.
- `make copy-request-templates` fails before copying when `DEST` is invalid.
- Git ignore changes must not hide committed request templates.
