# ATL-001 Risks

## Unsafe Assumptions

- Assuming the provided Jira project URL belongs to a Jira Cloud site.
- Assuming the entered email matches the Atlassian account that owns the token.
- Assuming the account currently logged into the browser matches the intended project session.

## Failure Modes

- A token can be copied incorrectly.
- Browser opening can fail in a non-GUI environment.
- Interrupted setup can leave `.env` only partially populated.
- API authentication can succeed while project access fails.
- The project URL parser can reject valid Jira URLs that do not use the expected `/projects/{projectKey}` shape.

## Operational Risks

- Users may rotate or revoke the token without updating `.env`.
- Future automation may need more granular Jira project identifiers beyond the project URL.
- Users with multiple Jira projects or accounts can overwrite the active session by rerunning init.

## Security Concerns

- Jira API tokens are secrets and must stay out of Git.
- Terminal scrollback may still reveal non-token values such as email and project URL.

## Recovery / Mitigation

- `.env` is git ignored.
- Token entry is silent.
- The setup can be rerun to replace existing `.env` values.
- Token creation guidance points to Atlassian account-managed tokens.
- `make test-jira-account` verifies both account authentication and project access.
- Multi-project switching is explicitly deferred to a future profile/session increment.
