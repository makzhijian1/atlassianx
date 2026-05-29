# ATL-005 Risks

## Unsafe Assumptions

- Assuming one Jira account/profile per project is sufficient for the next workflow stage.
- Assuming users prefer manual credential movement over an automated migration.
- Assuming existing request templates can move from `.http` to Bruno `.bru` without breaking preferred local workflows.
- Assuming Bruno's classic `.bru` collection format is the right target instead of Bruno's newer OpenCollection YAML format.
- Assuming no current user relies on root-level `.jira-env` or `.envs/jira/*.env` after this increment lands.

## Failure Modes

- A Jira command accidentally reads old root-level env files.
- `init-project` overwrites an existing project `.env`.
- A path traversal bug allows `PROJECT` to create files outside `projects/`.
- `.gitignore` ignores too much and hides committed setup templates.
- `.gitignore` ignores too little and allows user workspace files to be staged.
- Bruno environment generation writes incomplete values after account initialization.
- Bruno request conversion changes request semantics compared with the existing `.http` files.
- Local Bruno files are overwritten on repeated project initialization.
- Documentation still references removed root-level env workflows.

## Operational Risks

- This change breaks previously documented commands that did not require `PROJECT`.
- Local users with existing credentials must recreate or manually move their env values into `projects/<project-name>/.env`.
- External tooling or editor bookmarks pointing at `requests/templates/` may need to be updated.
- Users who prefer VS Code REST Client lose the committed `.http` workflow after conversion.
- Bruno environment files duplicate secrets already stored in the project `.env`, increasing local secret sprawl inside the ignored project workspace.

## Security Concerns

- Jira API tokens must never be printed by `show-jira-env`, setup scripts, or validation scripts.
- `projects/` must remain ignored so credentials, drafts, fetched issues, generated files, and future agent outputs stay out of git.
- Example env templates must contain placeholders only.
- Committed Bruno environment templates must contain placeholders only.
- Generated Bruno environment files may contain tokens but must remain under ignored `projects/`.
- Failure output must avoid dumping the full `.env` file.

## Recovery / Mitigation

- Keep the change small and focused on directory boundaries, Make targets, scripts, ignore rules, and documentation.
- Validate git ignore behavior before completion.
- Make `init-project` idempotent and non-destructive.
- Compare converted `.bru` request bodies, headers, auth, and variables against the old `.http` templates before removing them.
- Document that the project Bruno collection is local user state.
- Document the breaking workflow change clearly in the root README and setup docs.
- Leave old local files untouched; do not delete user credentials.
