# ATL-004 Risks

## Unsafe Assumptions

- VS Code REST Client can load or reference the active Jira profile values cleanly.
- Atlassian GraphQL supports the required Jira issue search workflows with the available token auth.
- `JIRA_CLOUD_ID` has already been populated by `ATL-003`.

## Failure Modes

- GraphQL examples drift from Atlassian's current schema.
- REST Client variable loading behaves differently from Make/script env loading.
- A user accidentally places custom requests inside `requests/templates/` and commits sensitive data.
- `make copy-request-templates` could overwrite a user's edited local request copy.

## Operational Risks

- Local request files may encode project-specific issue keys, account IDs, or JQL queries.
- GraphQL requests may require different permissions or endpoint behavior than REST.
- Query examples may need pagination handling for larger epics or JQL result sets.
- Create issue templates may need project-specific required fields beyond project, issue type, summary, and description.

## Security Concerns

- `.http` files can include Authorization headers and must not commit real credentials.
- Request outputs may contain sensitive issue data.
- Create/update requests can mutate Jira data and should be copied to a local folder before project-specific customization.
- `JIRA_API_TOKEN` must never be printed by Make targets or committed into templates.
- Custom request folders should be ignored by default.

## Recovery / Mitigation

- Keep templates placeholder-based and safe to commit.
- Add clear README guidance to copy templates into ignored local folders for customization.
- Add gitignore exceptions only for committed templates.
- Validate `DEST` for `make copy-request-templates` so templates are only copied under ignored `requests/` folders.
- Document that users should treat copied local requests as editable working files.
- Validate git ignore rules before commit.
