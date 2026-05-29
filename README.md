# atlassianx

`atlassianx` is a local-first Atlassian setup and tooling repository.

Clone it once, use the committed tooling under `setup/`, and keep Jira credentials, drafts, request experiments, fetched issues, generated files, and future agent outputs inside ignored local project workspaces under `projects/`.

## Architecture

```text
atlassianx/
├── setup/
│   ├── docs/
│   ├── requests/
│   ├── scripts/
│   └── templates/
└── projects/
    └── <project-name>/
```

`setup/` is repository-owned. `projects/` is local user state and is ignored by git.

Each project workspace uses a single `.env` file for Jira settings and a local Bruno collection for Jira API requests:

```text
projects/
└── maklabs/
    ├── .env
    ├── issues/
    │   ├── local/
    │   └── remote/
    └── requests/
        └── jira/
```

## Quick Start

Create a local project workspace:

```bash
make init-project PROJECT=maklabs
```

Initialize Jira credentials for that project:

```bash
make init-jira-account PROJECT=maklabs
```

Show the non-secret Jira settings:

```bash
make show-jira-env PROJECT=maklabs
```

Test Jira connectivity:

```bash
make test-jira-account PROJECT=maklabs
```

Open the project Bruno collection from:

```text
projects/maklabs/requests/jira/
```

## Setup Docs

Detailed setup and workspace notes live in [setup/docs/setup.md](setup/docs/setup.md).

## Increments

Engineering work is tracked in `_increments/`.

- `_increments/_templates/` contains the reusable increment document templates.
- `_increments/ATL-001-initialise-jira-api-access/` captures the first Jira API setup increment.
- `_increments/ATL-002-jira-env-profiles/` captures the old Jira env profile workflow.
- `_increments/ATL-003-jira-cloud-id-in-env-profiles/` captures Jira Cloud ID setup.
- `_increments/ATL-004-jira-http-request-templates/` captures the old REST Client template workflow.
- `_increments/ATL-005-separate-setup-from-project-workspaces/` captures the setup/project workspace separation.
