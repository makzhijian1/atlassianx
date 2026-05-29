# ATL-003 Test Plan

## Happy Path Tests

- Run `make init-jira-account` for a new env and verify `.envs/jira/<name>.env` contains exactly one `JIRA_CLOUD_ID`.
- Run `make show-jira-env` and verify it prints `JIRA_CLOUD_ID` but not `JIRA_API_TOKEN`.
- Run `make show-jira-env` against an old profile without `JIRA_CLOUD_ID` and verify it prints a missing marker rather than failing.
- Run `make test-jira-account` and verify existing Jira auth/project checks still pass.

## Invalid Input Tests

- Invalid credentials fail without printing `JIRA_API_TOKEN`.
- A tenant info response without `cloudId` fails clearly.
- Old profiles without `JIRA_CLOUD_ID` fail `make test-jira-account` with a refresh instruction.

## Partial Failure Tests

- Simulate failed Cloud ID lookup and verify no duplicate keys are written on retry.

## Retry / Idempotency Tests

- Rerun init for the same env and verify `JIRA_CLOUD_ID` is updated in place.
- Rerun init after an old incorrect `JIRA_CLOUD_ID` exists and verify it is replaced.

## Concurrency Tests

- No explicit concurrency support; `.envs/jira/<name>.env` is a local profile file.

## Regression Coverage

- `make list-jira-envs`, `make set-jira-env ENV=<name>`, and `make show-jira-env` still work.
- Root `.env` is not created.
- `JIRA_API_TOKEN` is not printed.
