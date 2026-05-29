# ATL-006 Risks

## Unsafe Assumptions

- Assuming collection-level Basic Auth inheritance behaves consistently across Bruno desktop and CLI.
- Assuming request pre-request variables are the best home for editable sample inputs.
- Assuming `JIRA_PROJECT_KEY` is better as a request-local sample for create issue than a shared environment variable.

## Failure Modes

- Requests stop authenticating if collection auth syntax is wrong.
- Request-local variables are not available when the request body or URL is evaluated.
- Existing local project collections keep old environment variables and diverge from the new template.
- The sample JQL syntax does not match a tenant's text search behavior.

## Operational Risks

- Users may need to reopen or refresh the Bruno collection to see inherited auth changes.
- Users may need to inspect pre-request variables instead of environment variables when changing issue keys or JQL.

## Security Concerns

- `JIRA_API_TOKEN` remains a generated local project value and must not be committed.
- Removing request-level auth must not lead to hardcoded Authorization headers.
- Debug output must not print token values.

## Recovery / Mitigation

- Keep changes limited to Bruno collection structure, env generation, and docs.
- Verify no request file contains request-level auth after implementation.
- Verify generated environment files contain only shared values.
- Document where users edit request-specific samples.
