# AtlassianX Setup

AtlassianX separates repository-owned tooling from local user work.

```text
atlassianx/
├── setup/
│   ├── docs/
│   ├── requests/
│   │   └── bruno-jira-template/
│   ├── scripts/
│   └── templates/
└── projects/
    └── <project-name>/
```

`setup/` contains committed scripts, docs, templates, and the canonical Bruno Jira collection template.

`projects/` contains ignored local workspaces. Credentials, drafts, local request changes, fetched issues, generated files, and future agent outputs belong there.

## Initialize A Project

```bash
make init-project PROJECT=maklabs
```

This creates or verifies:

```text
projects/
└── maklabs/
    ├── .env
    ├── issues/
    │   ├── local/
    │   └── remote/
    └── requests/
        └── jira/
            ├── bruno.json
            ├── collection.bru
            ├── environments/
            │   └── maklabs.bru
            ├── graphql/
            └── rest/
```

The command is idempotent and does not overwrite existing files.

## Initialize Jira Access

```bash
make init-jira-account PROJECT=maklabs
```

The setup prompts for:

- Jira project URL, for example `https://maklabs.atlassian.net/jira/software/projects/MZJ2026`
- Jira registered email
- Whether a Jira API token already exists
- Jira API token, entered silently

The command derives `JIRA_SITE_URL` and `JIRA_PROJECT_KEY`, tests Jira access, retrieves `JIRA_CLOUD_ID`, and writes values to:

```text
projects/maklabs/.env
projects/maklabs/requests/jira/environments/maklabs.bru
```

API tokens are not printed to stdout.

## Inspect Jira Settings

```bash
make show-jira-env PROJECT=maklabs
```

This prints non-secret values only:

- `JIRA_SITE_URL`
- `JIRA_PROJECT_KEY`
- `JIRA_EMAIL`
- `JIRA_CLOUD_ID`

## Test Jira Connectivity

```bash
make test-jira-account PROJECT=maklabs
```

This verifies the saved Jira account can authenticate and access the configured project.

## Bruno Requests

Each initialized project gets a local Bruno collection at:

```text
projects/maklabs/requests/jira/
```

Open that folder in Bruno and select the generated environment:

```text
maklabs
```

The committed template collection lives at:

```text
setup/requests/bruno-jira-template/
```

Do not edit the setup template for project-specific values. Edit the project-local collection under `projects/<project-name>/requests/jira/` if needed.

## Workspace Rules

- Everything under `projects/` is local user state.
- Real Jira credentials belong only in ignored project workspaces.
- Root-level `.jira-env` and `.envs/jira/*.env` are no longer used.
- Old local root-level env files are not migrated automatically.
- Committed files should be tooling, docs, templates, examples, and increment records only.
