# atlassianx

Make-centric Atlassian and Jira automation workspace.

## Setup

Initialize local files:

```bash
make init
```

This creates `.env` from `.env.example` when `.env` does not already exist. `.env` is git ignored and is where local Jira credentials are stored.

Authenticate the current Jira project session:

```bash
make init-jira-account
```

The Jira setup prompts for:

- Jira project URL, for example `https://maklabs.atlassian.net/jira/software/projects/MZJ2026`
- Jira registered email
- Whether a Jira API token already exists
- The Jira API token, entered silently

If no API token exists yet, the setup opens the Atlassian API token page and prints concise creation steps before asking for the new token.

Successful init means:

- `.env` contains the current Jira project session settings.
- Jira API authentication succeeds for the registered email and API token.
- The authenticated account can access the project key parsed from the project URL.

You can re-run the connectivity check without changing credentials:

```bash
make test-jira-account
```

This first increment assumes the browser is already logged into the Jira project you want this repository session to target. Re-running `make init-jira-account` replaces the active project session in `.env`. Multi-project profiles and switching will be added as a later increment.

## Environment

Expected `.env` keys:

```bash
JIRA_PROJECT_URL=
JIRA_SITE_URL=
JIRA_PROJECT_KEY=
JIRA_EMAIL=
JIRA_API_TOKEN=
```

Do not commit `.env`.

## Increments

Engineering work is tracked in `_increments/`.

- `_increments/_templates/` contains the reusable increment document templates.
- `_increments/ATL-001-initialise-jira-api-access/` captures the first increment for Jira API account initialization.
