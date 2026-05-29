# ATL-005 Specification

## Behaviour

- AtlassianX is treated as a setup and tooling repository, not as the place where user Jira work is stored.
- Repository-owned assets live under `setup/`.
- User workspaces live under `projects/<project-name>/`.
- Everything under `projects/` is local user state and is ignored by git.
- A project workspace is the single active Jira container for that project.
- Jira configuration for a project lives in `projects/<project-name>/.env`.
- Root-level `.jira-env` and `.envs/jira/*.env` are no longer used.
- `make init-project PROJECT=<project-name>` creates an idempotent local project workspace.
- `make init-project PROJECT=<project-name>` also initializes a local Bruno Jira collection for that project.
- Committed Jira request examples are converted from `.http` files to Bruno `.bru` request files.
- `make init-jira-account PROJECT=<project-name>` writes Jira values to both the project `.env` file and the project's Bruno environment file.
- Jira commands require `PROJECT=<project-name>` and fail clearly when it is missing.
- Jira commands do not print `JIRA_API_TOKEN`.

## Target Repository Structure

The implementation should move toward this committed repository structure:

```text
atlassianx/
├── AGENTS.md
├── Makefile
├── README.md
├── _increments/
│   ├── _templates/
│   ├── ATL-001-initialise-jira-api-access/
│   ├── ATL-002-jira-env-profiles/
│   ├── ATL-003-jira-cloud-id-in-env-profiles/
│   ├── ATL-004-jira-http-request-templates/
│   └── ATL-005-separate-setup-from-project-workspaces/
├── setup/
│   ├── docs/
│   │   └── setup.md
│   ├── requests/
│   │   └── bruno-jira-template/
│   │       ├── bruno.json
│   │       ├── collection.bru
│   │       ├── environments/
│   │       │   └── project.bru
│   │       ├── graphql/
│   │       │   ├── folder.bru
│   │       │   ├── get-cloud-id.bru
│   │       │   ├── get-epic-issues.bru
│   │       │   ├── get-issue.bru
│   │       │   └── search-jql.bru
│   │       └── rest/
│   │           ├── folder.bru
│   │           ├── create-issue.bru
│   │           ├── get-epic-issues.bru
│   │           ├── get-issue.bru
│   │           ├── search-jql.bru
│   │           └── update-issue.bru
│   ├── scripts/
│   │   ├── init_jira_account.sh
│   │   ├── jira_env_summary.sh
│   │   └── test_jira_account.sh
│   └── templates/
│       └── project.env.example
└── projects/
    └── .gitkeep
```

`projects/.gitkeep` is optional. If present, it exists only to make the workspace root visible; all real project contents remain ignored.

## Target Local Workspace Structure

After running `make init-project PROJECT=maklabs`, the local workspace should be:

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
            │   ├── folder.bru
            │   ├── get-cloud-id.bru
            │   ├── get-epic-issues.bru
            │   ├── get-issue.bru
            │   └── search-jql.bru
            └── rest/
                ├── folder.bru
                ├── create-issue.bru
                ├── get-epic-issues.bru
                ├── get-issue.bru
                ├── search-jql.bru
                └── update-issue.bru
```

Purpose:

- `projects/maklabs/.env` stores Jira credentials and project configuration for the `maklabs` workspace.
- `projects/maklabs/issues/local/` stores user-authored issue drafts.
- `projects/maklabs/issues/remote/` is reserved for future Jira issue exports.
- `projects/maklabs/requests/jira/` stores the local Bruno Jira collection initialized from the committed template collection.
- `projects/maklabs/requests/jira/environments/maklabs.bru` stores Bruno environment variables derived from `projects/maklabs/.env`.

The project workspace intentionally does not contain `.jira-env` or `.envs/jira/`. The project directory itself is the selected workspace, so a separate active-profile file is unnecessary in this increment.

## Contracts

- New Make target:
  - `make init-project PROJECT=maklabs`
- Updated Jira Make targets:
  - `make init-jira-account PROJECT=maklabs`
  - `make show-jira-env PROJECT=maklabs`
  - `make test-jira-account PROJECT=maklabs`
- Removed or deprecated Make targets:
  - `make set-jira-env`
  - `make list-jira-envs`
  - `make require-active-jira-env`
- `PROJECT` is required for all project-scoped Jira operations.
- When `PROJECT` is missing, commands fail with:

```text
PROJECT is required.

Example:
make show-jira-env PROJECT=maklabs
```

- Project names must resolve under `projects/` and must not escape the workspace root.
- `init-project` creates:
  - `projects/<project-name>/`
  - `projects/<project-name>/.env`
  - `projects/<project-name>/issues/local/`
  - `projects/<project-name>/issues/remote/`
  - `projects/<project-name>/requests/`
  - `projects/<project-name>/requests/jira/`
  - `projects/<project-name>/requests/jira/bruno.json`
  - `projects/<project-name>/requests/jira/collection.bru`
  - `projects/<project-name>/requests/jira/environments/<project-name>.bru`
  - Jira REST and GraphQL request `.bru` files under the local Bruno collection.
- `init-project` creates `.env` from `setup/templates/project.env.example` only when `.env` does not already exist.
- `init-project` copies the Bruno Jira template collection only when the destination files do not already exist.
- `init-project` must not overwrite existing files.
- `init-jira-account` edits or initializes `projects/<project-name>/.env`.
- `init-jira-account` also updates `projects/<project-name>/requests/jira/environments/<project-name>.bru` with the same Jira values.
- `show-jira-env` summarizes only non-secret values from `projects/<project-name>/.env`.
- `test-jira-account` loads only `projects/<project-name>/.env`.
- Bruno request templates remain committed under `setup/requests/bruno-jira-template/`.
- User request files under `projects/<project-name>/requests/` remain local and ignored.
- Bruno request files use `.bru`, not `.http`.
- The repository must not retain committed `.http` request templates after conversion.
- The Bruno collection should expose variables matching the project `.env` keys:
  - `JIRA_PROJECT_URL`
  - `JIRA_EMAIL`
  - `JIRA_API_TOKEN`
  - `JIRA_SITE_URL`
  - `JIRA_PROJECT_KEY`
  - `JIRA_CLOUD_ID`
- Bruno requests should reference environment variables rather than hardcoded Jira values.
- The project Bruno environment file may contain secrets because it is under ignored `projects/`; committed Bruno template environment files must contain placeholders only.

## Inputs / Outputs

- Inputs:
  - `PROJECT` Make variable.
  - Jira credentials entered by the user or stored in `projects/<project-name>/.env`.
  - Jira Cloud API availability.
- Outputs:
  - Local ignored project workspace directories.
  - Local ignored project `.env` file.
  - Local ignored Bruno Jira collection.
  - Local ignored Bruno environment file populated from project Jira settings.
  - Console summaries that do not reveal API tokens.
  - Documentation describing the new setup and workspace model.

## Invariants

- Everything under `projects/` is considered local user state.
- Real Jira credentials are never committed.
- Root-level Jira env files are no longer part of the contract.
- The repository tracks tooling, templates, docs, examples, and increment records.
- The repository does not track user drafts, fetched issues, generated artifacts, request customizations, or future agent outputs.
- Existing safe request templates are converted to committed Bruno `.bru` files under `setup/requests/bruno-jira-template/`.
- Local Bruno collections are generated inside ignored project workspaces.
- No API token is printed to stdout.

## Edge Cases

- `PROJECT` is missing.
- `PROJECT` is empty or whitespace.
- `PROJECT` contains path traversal such as `../`.
- `PROJECT` points to an existing file instead of a directory.
- `projects/<project-name>/.env` already exists.
- `projects/<project-name>/requests/jira/` already exists.
- `setup/templates/project.env.example` is missing.
- `setup/requests/bruno-jira-template/` is missing.
- `show-jira-env` runs before `.env` is configured.
- `test-jira-account` runs with missing required Jira values.
- Old root-level `.jira-env` or `.envs/jira/*.env` files remain on disk from previous local usage.
- Bruno environment generation runs before Jira values are complete.

## Failure Semantics

- Commands fail before modifying files when `PROJECT` is missing or invalid.
- `init-project` is idempotent and safe to rerun.
- `init-project` does not overwrite an existing `.env`.
- `init-project` does not overwrite an existing local Bruno request or environment file.
- Jira commands fail clearly when `projects/<project-name>/.env` is missing.
- If Bruno environment generation fails, the command reports the failed file path and does not print secret values.
- Legacy root-level env files are ignored rather than migrated automatically.
- If a partial workspace exists, rerunning `init-project` creates the missing directories and leaves existing files unchanged.
