# ATL-005 Test Plan

## Happy Path Tests

- Run `make init-project PROJECT=maklabs`.
- Verify it creates:
  - `projects/maklabs/`
  - `projects/maklabs/.env`
  - `projects/maklabs/issues/local/`
  - `projects/maklabs/issues/remote/`
  - `projects/maklabs/requests/`
  - `projects/maklabs/requests/jira/bruno.json`
  - `projects/maklabs/requests/jira/collection.bru`
  - `projects/maklabs/requests/jira/environments/maklabs.bru`
  - REST and GraphQL `.bru` request files under `projects/maklabs/requests/jira/`
- Verify `.env` is copied from `setup/templates/project.env.example`.
- Verify the Bruno collection is copied from `setup/requests/bruno-jira-template/`.
- Verify the generated Bruno environment file uses the project name.
- Run `make show-jira-env PROJECT=maklabs` with placeholder values and confirm token values are not printed.
- Run `make init-jira-account PROJECT=maklabs` and confirm `projects/maklabs/.env` and `projects/maklabs/requests/jira/environments/maklabs.bru` are initialized with matching Jira values.
- Run `make test-jira-account PROJECT=maklabs` with valid Jira credentials and confirm the account test succeeds.
- Open `projects/maklabs/requests/jira/` in Bruno and verify the collection is recognized.
- Select the generated Bruno environment and verify Jira variables are available to requests.

## Invalid Input Tests

- Run `make init-project` without `PROJECT` and verify the required error message.
- Run `make show-jira-env` without `PROJECT` and verify the required error message.
- Run `make test-jira-account` without `PROJECT` and verify the required error message.
- Run `make init-project PROJECT=../outside` and verify it fails before writing files.
- Run `make init-project PROJECT=` and verify it fails.
- Run `make show-jira-env PROJECT=missing` and verify it fails clearly when `.env` is absent.
- Run Jira commands with missing required `.env` values and verify failures do not expose `JIRA_API_TOKEN`.
- Remove `setup/requests/bruno-jira-template/` and verify `make init-project PROJECT=maklabs` fails clearly.
- Corrupt a generated Bruno environment file and verify account initialization can regenerate it without printing secrets.

## Partial Failure Tests

- Create only `projects/maklabs/issues/local/`, then rerun `make init-project PROJECT=maklabs` and verify missing paths are created.
- Create `projects/maklabs/.env` with custom content, then rerun `make init-project PROJECT=maklabs` and verify `.env` is unchanged.
- Create `projects/maklabs/requests/jira/rest/get-issue.bru` with custom content, then rerun `make init-project PROJECT=maklabs` and verify the file is unchanged.
- Temporarily move `setup/templates/project.env.example` away and verify `init-project` fails clearly without creating a misleading empty `.env`.

## Retry / Idempotency Tests

- Run `make init-project PROJECT=maklabs` twice and verify the second run succeeds without overwriting files.
- Run `make show-jira-env PROJECT=maklabs` repeatedly and verify output remains stable and non-secret.
- Run `make test-jira-account PROJECT=maklabs` repeatedly with valid credentials and verify it does not mutate workspace files.
- Run `make init-jira-account PROJECT=maklabs` twice and verify the Bruno environment reflects the latest entered values without duplicating variable entries.

## Concurrency Tests

- Run `make init-project PROJECT=maklabs` in two terminals and verify no existing `.env` is truncated or overwritten.
- Run `make init-project PROJECT=maklabs` in two terminals and verify no existing Bruno request file is truncated or overwritten.
- Run `make init-project PROJECT=maklabs` and `make init-project PROJECT=work` and verify separate workspaces are independent.

## Regression Coverage

- Verify committed request templates are tracked as `.bru` files under `setup/requests/bruno-jira-template/`.
- Verify no committed `.http` request templates remain.
- Verify scripts remain executable after moving under `setup/scripts/`.
- Verify root README points to `setup/docs/setup.md`.
- Verify `git status --short --ignored` shows real project workspace contents as ignored.
- Verify old root-level `.jira-env` and `.envs/jira/*.env` are not read by Jira commands.
