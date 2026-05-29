# atlassianx

## Introduction

`atlassianx` is a Make-centric workspace for local Jira and Atlassian automation. It keeps Jira account/project settings in ignored local env profiles so you can switch between projects without committing credentials.

## First Time Setup

Initialize a Jira profile:

```bash
make init-jira-account
```

The setup prompts for:

- Jira env name, for example `maklabs`
- Jira project URL, for example `https://maklabs.atlassian.net/jira/software/projects/MZJ2026`
- Jira registered email
- Whether a Jira API token already exists
- Jira API token, entered silently

The profile is saved to:

```text
.envs/jira/<name>.env
```

The selected profile name is saved to ignored local file `.jira-env`. There should be no root `.env` required for normal use.

Verify the active Jira profile:

```bash
make show-jira-env
```

Test Jira connectivity:

```bash
make test-jira-account
```

## Toggling Envs

List available Jira profiles:

```bash
make list-jira-envs
```

Select an existing profile:

```bash
make set-jira-env ENV=maklabs
```

This updates `.jira-env` only. It does not copy or overwrite the saved profile file.

Create a profile manually from the example:

```bash
cp .envs/jira/example.env .envs/jira/work.env
```

Edit values:

```env
JIRA_PROJECT_URL=...
JIRA_EMAIL=...
JIRA_API_TOKEN=...
JIRA_SITE_URL=...
JIRA_PROJECT_KEY=...
```

Security notes:

- `.jira-env` is local-only and ignored by git.
- `.envs/jira/*.env` is ignored by git.
- Never commit API tokens.
- `example.env` is safe to commit.

## Increments

Engineering work is tracked in `_increments/`.

- `_increments/_templates/` contains the reusable increment document templates.
- `_increments/ATL-001-initialise-jira-api-access/` captures the first increment for Jira API account initialization.
- `_increments/ATL-002-jira-env-profiles/` captures Jira environment profile switching.
