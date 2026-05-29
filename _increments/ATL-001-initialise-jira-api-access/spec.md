# ATL-001 Specification

## Behaviour

- `make init` creates `.env` from `.env.example` if `.env` does not exist.
- `make init` preserves an existing `.env`.
- `make init-jira-account` ensures `.env` exists first.
- `make init-jira-account` prompts for a Jira project URL, Jira registered email, and whether an API token already exists.
- `make init-jira-account` treats the entered Jira project URL as the active Jira project session for this repository checkout.
- `make init-jira-account` derives `JIRA_SITE_URL` and `JIRA_PROJECT_KEY` from the entered project URL.
- When the user answers `Y`, the command asks for the token and writes it to `.env`.
- When the user answers `N`, the command opens the Atlassian API token management page, prints concise token creation steps, then asks for the token and writes it to `.env`.
- After saving `.env`, `make init-jira-account` verifies connectivity for the current Jira project session.
- `make test-jira-account` verifies the saved Jira account without changing `.env`.

## Success Criteria

- `.env` exists and contains all required Jira session keys.
- The Jira account API call to `/rest/api/3/myself` succeeds using `JIRA_EMAIL` and `JIRA_API_TOKEN`.
- The Jira project API call to `/rest/api/3/project/{JIRA_PROJECT_KEY}` succeeds on `JIRA_SITE_URL`.
- The command prints a success message naming the email, site URL, and project key.

## Contracts

- Commands are exposed through `make`.
- `.env` is the local persistence file for Jira setup values.
- `.env` contains:
  - `JIRA_PROJECT_URL`
  - `JIRA_SITE_URL`
  - `JIRA_PROJECT_KEY`
  - `JIRA_EMAIL`
  - `JIRA_API_TOKEN`
- `.env` must be git ignored.
- `JIRA_PROJECT_URL` is the active project session. Re-running init replaces that active session.
- This increment supports one active Jira project session at a time.

## Inputs / Outputs

- Inputs:
  - Jira project URL, for example `https://maklabs.atlassian.net/jira/software/projects/MZJ2026`
  - Jira registered email
  - Jira API token existence answer, `Y` or `N`
  - Jira API token
- Outputs:
  - A local `.env` file populated with Jira access settings.
  - Derived Jira site URL and project key.
  - Connectivity verification result.
  - Terminal guidance for token creation when required.

## Invariants

- Existing `.env` values are updated in place instead of appending duplicate keys.
- Jira API tokens are not committed.
- The token prompt does not echo the typed token.
- Browser login state is only used to help the user create or access the right token page; API verification uses the saved email and token.

## Edge Cases

- User enters an empty project URL, email, or token.
- User enters a Jira URL that does not include `/projects/{projectKey}`.
- User enters an answer other than `Y` or `N` for token existence.
- macOS `open` is unavailable or fails.
- The token authenticates but cannot access the selected project.
- The user is logged into a different Atlassian account in the browser than the email entered for API authentication.
- The user wants to work with multiple Jira projects or accounts.

## Failure Semantics

- If `.env` does not exist, the setup creates it before prompting.
- If the token page cannot be opened, the command still prints the URL.
- If the command is interrupted before saving, rerunning it should prompt again and update `.env`.
- If verification fails, the command exits non-zero and leaves the saved `.env` values available for correction or retry.
- Multi-project or multi-account switching is out of scope for this increment and should be handled by a later profile-oriented increment.
