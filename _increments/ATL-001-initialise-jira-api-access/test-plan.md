# ATL-001 Test Plan

## Happy Path Tests

- Run `make init` and verify `.env` is created from `.env.example`.
- Run `make init-jira-account`, answer `Y`, enter values, and verify `.env` contains the expected Jira keys.
- Run `make init-jira-account`, answer `N`, verify token guidance is printed before token entry.
- Run `make test-jira-account` with valid credentials and verify it checks `/myself` and the selected project.

## Invalid Input Tests

- Submit an empty project URL and verify the prompt repeats.
- Submit a Jira URL without `/projects/{projectKey}` and verify setup exits with a clear error.
- Submit an empty email and verify the prompt repeats.
- Submit an answer other than `Y` or `N` and verify the prompt repeats.
- Submit an empty token and verify the prompt repeats.
- Run `make test-jira-account` with missing `.env` values and verify it exits non-zero.
- Run `make test-jira-account` with invalid credentials and verify Jira API failure exits non-zero.

## Partial Failure Tests

- Interrupt setup before token entry and verify rerunning still works.
- Simulate browser opening failure and verify the token URL remains available in terminal output.
- Simulate project access failure and verify `make test-jira-account` exits non-zero after account verification.

## Retry / Idempotency Tests

- Run `make init` twice and verify existing `.env` is preserved.
- Run `make init-jira-account` twice and verify keys are updated rather than duplicated.
- Run `make test-jira-account` repeatedly and verify it does not mutate `.env`.

## Concurrency Tests

- Avoid running multiple interactive setup commands against the same `.env` at once.

## Regression Coverage

- Verify `.env` remains ignored by Git.
- Verify templates remain available under `_increments/_templates/`.
- Verify single active project session behaviour is documented until multi-project switching exists.
