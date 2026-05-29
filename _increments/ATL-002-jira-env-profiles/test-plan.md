# ATL-002 Test Plan

## Happy Path Tests

- `make list-jira-envs` lists available `.envs/jira/*.env` profiles.
- `make set-jira-env ENV=maklabs` writes `maklabs` to `.jira-env`.
- `make show-jira-env` prints `JIRA_SITE_URL`, `JIRA_PROJECT_KEY`, and `JIRA_EMAIL` from the selected `.envs/jira/maklabs.env`.

## Invalid Input Tests

- `make set-jira-env` without `ENV` fails with a usage-oriented error.
- `make set-jira-env ENV=missing` fails with a missing file error.
- `make show-jira-env` fails clearly when `.jira-env` does not exist.

## Partial Failure Tests

- Missing required safe summary keys fail without printing `JIRA_API_TOKEN`.

## Retry / Idempotency Tests

- Re-running `make set-jira-env ENV=<name>` updates `.jira-env` with the selected profile and prints the same safe summary.

## Concurrency Tests

- No explicit concurrency support; `.jira-env` is a single checkout-level selection.

## Regression Coverage

- Existing Jira targets continue to read the selected profile.
- `.jira-env` and non-example profile files remain ignored by git.
