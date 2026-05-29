# ATL-001 Initialise Jira API Access

## Status

- Implemented

## Objective

- Establish the first Make-centric setup flow for authenticating the current Jira project session.

## Scope

- Add `make init` to create a local `.env` file from `.env.example`.
- Add `make init-jira-account` to prompt for Jira project URL, registered email, and API token.
- Parse the Jira site URL and project key from the project URL.
- Add `make test-jira-account` to verify Jira account authentication and project access.
- Open the Atlassian API token management page when the user does not already have a token.
- Persist Jira settings to `.env`, which is git ignored.
- Document setup instructions in `README.md`.

## Non-goals

- Add issue, project, sprint, or board automation.
- Store secrets outside the local repository `.env` file.
- Support multiple saved Jira project profiles or toggling between projects.

## Dependencies

- A Jira Cloud project URL.
- A Jira registered email address.
- A Jira API token from Atlassian account settings.
- macOS `open` is used when available to open the token management page.

## Deliverables

- `Makefile`
- `scripts/init_jira_account.sh`
- `scripts/test_jira_account.sh`
- `.env.example`
- `.gitignore`
- `README.md`
- `_increments/ATL-001-initialise-jira-api-access/`
