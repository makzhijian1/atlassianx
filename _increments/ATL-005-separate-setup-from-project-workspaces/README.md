# ATL-005 Separate Setup From Local Project Workspaces

## Status

- Implemented

## Objective

- Reshape AtlassianX into a setup and tooling repository while moving all user-specific Jira work into ignored local project workspaces.
- Establish `setup/` as the repository-owned tooling area and `projects/` as the ignored user workspace root.

## Scope

- Introduce a repository-owned `setup/` layout for scripts, request templates, docs, and supporting templates.
- Introduce ignored local project workspaces under `projects/<project-name>/`.
- Add `make init-project PROJECT=<project-name>` to create a project workspace.
- Refactor Jira Make targets and scripts so they read Jira configuration only from `projects/<project-name>/.env`.
- Convert committed Jira request examples from VS Code REST Client `.http` files to a Bruno `.bru` template collection.
- Initialize a local Bruno Jira collection for each project workspace.
- Generate the project Bruno environment file from values entered during Jira account initialization.
- Remove root-level Jira env contracts:
  - `.jira-env`
  - `.envs/jira/*.env`
- Replace the setup-heavy root README with a concise overview and quick start.
- Add detailed setup documentation under `setup/docs/setup.md`.

## Non-goals

- Do not implement Jira issue fetching.
- Do not implement Jira issue export.
- Do not implement ADF or Markdown conversion.
- Do not implement request template generation.
- Do not implement remote synchronization.
- Do not add multi-profile Jira env switching inside a project.

## Dependencies

- Existing Jira setup scripts and Make targets from earlier increments.
- Existing request templates from `ATL-004`.
- Bruno desktop app or Bruno CLI for opening/running initialized collections.
- Jira Cloud credentials supplied by the user in local ignored files.

## Deliverables

- Increment package under `_increments/ATL-005-separate-setup-from-project-workspaces/`.
- Planned implementation artifacts:
  - `setup/scripts/`
  - `setup/requests/bruno-jira-template/`
  - `setup/docs/setup.md`
  - `setup/templates/project.env.example`
  - `projects/` as an ignored local workspace root
  - `Makefile` updates for project-scoped commands
  - `.gitignore` updates to ignore `projects/`
  - Concise root `README.md`
