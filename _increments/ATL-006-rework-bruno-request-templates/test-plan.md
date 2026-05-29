# ATL-006 Test Plan

## Happy Path Tests

- Run `make init-project PROJECT=atl006check`.
- Verify generated Bruno environment contains only:
  - `JIRA_SITE_URL`
  - `JIRA_EMAIL`
  - `JIRA_API_TOKEN`
  - `JIRA_CLOUD_ID`
  - `GRAPHQL_URL`
- Verify collection-level auth references `{{JIRA_EMAIL}}` and `{{JIRA_API_TOKEN}}`.
- Verify every request inherits auth from the collection.
- Verify request-specific sample inputs are request-local pre-request variables.
- Verify JQL search requests use `summary ~ "found by JQL" ORDER BY updated DESC`.

## Invalid Input Tests

- Run `make init-jira-account PROJECT=<project>` with incomplete Jira values and confirm existing failures still avoid printing tokens.
- Verify requests fail visibly in Bruno if shared env values are missing.

## Partial Failure Tests

- Rerun `make init-project PROJECT=<project>` after locally editing a request and confirm the request is not overwritten.
- Rerun Bruno env generation after an old generated env contains request-specific values and confirm the generated file is trimmed.

## Retry / Idempotency Tests

- Run `make init-project PROJECT=atl006check` twice.
- Run `setup/scripts/sync_bruno_env.sh atl006check` twice.
- Confirm no duplicate variables are introduced.

## Concurrency Tests

- Run `make init-project PROJECT=atl006check` in two terminals and verify local request files are not truncated.

## Regression Coverage

- Existing REST requests remain present.
- Existing GraphQL requests remain present.
- No committed `.http` files are reintroduced.
- No API token is printed to stdout.
- `projects/` remains ignored by git.
