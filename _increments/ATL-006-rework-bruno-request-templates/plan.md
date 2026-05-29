# ATL-006 Plan

## Architecture Notes

- Treat Bruno environment variables as shared collection configuration.
- Treat request pre-request variables as editable examples for that individual request.
- Use collection-level Basic Auth to avoid duplicating auth blocks in each request.
- Keep the project `.env` as the source for generated Bruno shared values.

## Implementation Breakdown

- Update `setup/requests/bruno-jira-template/collection.bru`:
  - add collection-level Basic Auth
  - reference `{{JIRA_EMAIL}}` and `{{JIRA_API_TOKEN}}`
- Update all request `.bru` files:
  - remove request-level `auth: basic`
  - remove duplicated `auth:basic` blocks
  - leave requests to inherit collection auth
- Update request files with pre-request variables:
  - `get-issue.bru`: `ISSUE_KEY`
  - `get-epic-issues.bru`: `EPIC_KEY`
  - `search-jql.bru`: `JQL`
  - `create-issue.bru`: `JIRA_PROJECT_KEY` and `ISSUE_TYPE`
  - `update-issue.bru`: `ISSUE_KEY`
  - GraphQL equivalents for issue, epic, and JQL samples
- Set the search JQL sample to:

```text
summary ~ "found by JQL" ORDER BY updated DESC
```

- Update `setup/requests/bruno-jira-template/environments/project.bru` to contain only:
  - `JIRA_SITE_URL`
  - `JIRA_EMAIL`
  - `JIRA_API_TOKEN`
  - `JIRA_CLOUD_ID`
  - `GRAPHQL_URL`
- Update `setup/scripts/sync_bruno_env.sh` to generate only those shared values.
- Update setup documentation with:
  - collection inherited auth
  - shared environment values
  - request-local pre-request variables

## Milestones

- Increment package reviewed and approved.
- Collection-level auth implemented.
- Request-level auth removed from all templates.
- Request-local pre-request variables added.
- Generated Bruno env trimmed.
- Documentation updated.
- Initialization and syntax checks rerun.

## Dependencies

- `ATL-005` project workspace and Bruno template layout.
- Bruno `.bru` format support for collection auth and request variables.

## Rollout Notes

- This is a breaking cleanup for generated Bruno environment shape.
- Existing project-local Bruno collections are local state and are not overwritten by `init-project`.
- Users can refresh generated environment values by rerunning `make init-jira-account PROJECT=<project>`.
