# ATL-005 Plan

## Architecture Notes

- Treat `setup/` as the repository-owned setup and tooling boundary.
- Treat `projects/` as the ignored local-state boundary.
- Prefer one Jira `.env` file per project workspace because `projects/<project-name>/` is already the selected container.
- Do not preserve root-level env compatibility; this is a greenfield boundary change.
- Move existing repository-owned scripts and request templates rather than rewriting them.
- Convert existing request templates from `.http` to Bruno `.bru` files.
- Keep the canonical Bruno collection template under setup and copy it into project workspaces during initialization.
- Generate a per-project Bruno environment file from values collected during Jira initialization.
- Keep the root Makefile as the user entry point. It can call scripts under `setup/scripts/`.

## Implementation Breakdown

- Create `setup/` repository-owned structure:
  - `setup/scripts/`
  - `setup/requests/bruno-jira-template/`
  - `setup/docs/`
  - `setup/templates/`
- Move existing scripts from `scripts/` to `setup/scripts/`.
- Convert existing request templates from `requests/templates/*.http` to a Bruno collection under `setup/requests/bruno-jira-template/`.
- Include the Bruno collection files:
  - `bruno.json`
  - `collection.bru`
  - `environments/project.bru`
  - REST request `.bru` files
  - GraphQL request `.bru` files
- Remove the old committed `.http` request templates after the Bruno equivalents are in place.
- Add `setup/templates/project.env.example` with safe placeholder Jira variables:
  - `JIRA_PROJECT_URL`
  - `JIRA_EMAIL`
  - `JIRA_API_TOKEN`
  - `JIRA_SITE_URL`
  - `JIRA_PROJECT_KEY`
  - `JIRA_CLOUD_ID`
- Add `projects/` as the local workspace root.
- Update `.gitignore` so `projects/` is ignored.
- Add `make init-project PROJECT=<project-name>`:
  - validate `PROJECT`
  - create the project directory tree
  - create `.env` from `setup/templates/project.env.example` only if absent
  - copy the Bruno Jira template collection to `projects/<project-name>/requests/jira/` without overwriting existing local files
  - rename or generate the Bruno environment file as `projects/<project-name>/requests/jira/environments/<project-name>.bru`
  - print a success summary
- Refactor Jira targets to require `PROJECT`:
  - `init-jira-account`
  - `show-jira-env`
  - `test-jira-account`
- Update `init-jira-account` so values collected during initialization are written to:
  - `projects/<project-name>/.env`
  - `projects/<project-name>/requests/jira/environments/<project-name>.bru`
- Add a helper script or Make function for Bruno environment generation:
  - read known Jira keys from project `.env`
  - write Bruno `.bru` environment variable entries
  - preserve local files unless the user is explicitly re-running Jira account initialization
  - never print `JIRA_API_TOKEN`
- Remove active-env profile selection from the Make contract:
  - remove or deprecate `set-jira-env`
  - remove or deprecate `list-jira-envs`
  - remove or replace `require-active-jira-env`
- Update scripts so they operate on `projects/<project-name>/.env`.
- Update the root README to include:
  - short project overview
  - architecture overview
  - quick start commands
  - link to `setup/docs/setup.md`
- Add `setup/docs/setup.md` documenting:
  - local-first workspace philosophy
  - expected repository structure
  - expected project workspace structure
  - Bruno collection location and how to open it
  - `make init-project PROJECT=maklabs`
  - `make init-jira-account PROJECT=maklabs`
  - `make show-jira-env PROJECT=maklabs`
  - `make test-jira-account PROJECT=maklabs`

## Milestones

- Increment package reviewed and approved.
- Setup/workspace directory contract implemented.
- Project initialization target implemented and verified.
- Bruno `.bru` collection template added and old `.http` files removed.
- Project initialization copies the Bruno collection and creates the project Bruno environment.
- Jira commands refactored to project-scoped `.env`.
- Jira account initialization updates both project `.env` and Bruno environment values.
- Documentation updated and reviewed.
- Git ignore behavior verified.

## Dependencies

- GNU Make or compatible Make.
- POSIX shell scripts.
- Bruno desktop app or Bruno CLI.
- Jira Cloud API credentials for manual account validation.
- Existing request templates from `ATL-004`.

## Rollout Notes

- This is a breaking local workflow change.
- Existing root-level `.jira-env` and `.envs/jira/*.env` files are intentionally not supported after this increment.
- Users should initialize a project workspace and place credentials in `projects/<project-name>/.env`.
- Users can open `projects/<project-name>/requests/jira/` in Bruno after initialization.
- Users can select the generated project environment in Bruno.
- No automatic credential migration is planned because credentials are local state and should remain under user control.
