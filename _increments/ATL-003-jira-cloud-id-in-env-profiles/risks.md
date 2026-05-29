# ATL-003 Risks

## Unsafe Assumptions

- The Jira site tenant info endpoint remains available for Cloud ID lookup.
- Tenant info returns a single `cloudId` for `JIRA_SITE_URL`.

## Failure Modes

- Cloud ID lookup fails due to Atlassian endpoint behavior.
- A stale Cloud ID remains if discovery fails after partial profile writes.

## Operational Risks

- Existing profiles without `JIRA_CLOUD_ID` will need to be refreshed before GraphQL requests work.
- Users may need clearer diagnostics if tenant info lookup fails despite Jira REST auth succeeding.

## Security Concerns

- `JIRA_API_TOKEN` must not be printed in lookup diagnostics.
- Failed HTTP responses may contain account or site metadata and should be summarized carefully.

## Recovery / Mitigation

- Keep lookup output limited to site URL, project key, email, and Cloud ID.
- Allow rerunning `make init-jira-account` for the same env to update all keys in place.
- Write `JIRA_CLOUD_ID` only after a `cloudId` value is parsed.
