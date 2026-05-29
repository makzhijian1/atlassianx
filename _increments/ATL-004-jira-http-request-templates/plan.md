# ATL-004 Plan

## Architecture Notes

- Use `.http` files as the primary interface because the intended user workflow is VS Code REST Client.
- Keep committed examples under `requests/templates/`.
- Treat all other `requests/` content as local user workspace by default.
- Prefer REST Client variables and active Jira profile values over hardcoded project/account data.
- Assume `JIRA_CLOUD_ID` is available from `ATL-003`; this increment does not persist it.
- Use Make only for local template copying. Request execution remains VS Code REST Client.

## Implementation Breakdown

- Add `requests/templates/` with safe `.http` templates:
  - `rest-get-issue.http`
  - `rest-get-epic-issues.http`
  - `rest-search-jql.http`
  - `rest-create-issue.http`
  - `rest-update-issue.http`
  - `graphql-get-cloud-id.http`
  - `graphql-get-issue.http`
  - `graphql-get-epic-issues.http`
  - `graphql-search-jql.http`
- Use an order processing system as the sample create/update issue domain:
  - Summary example: `Order processing system should validate payment before fulfillment`.
  - `Background`: orders can currently move toward fulfillment before payment state is confirmed.
  - `Requirements`: validate payment status, block fulfillment for unpaid orders, expose a clear failure reason.
  - `Acceptance Criteria`: paid orders proceed, unpaid orders are blocked, and operators can see the reason.
- Add Make target:
  - `copy-request-templates`
- Add Make-level validation for `copy-request-templates`:
  - `DEST` is required.
  - `DEST` must start with `requests/`.
  - `DEST` must not be `requests/templates`.
- Update `.gitignore` to ignore local request folders while preserving committed templates.
- Update `README.md` with:
  - REST Client extension prerequisite.
  - `JIRA_CLOUD_ID` prerequisite from `ATL-003`.
  - `make copy-request-templates DEST=requests/local`.
  - Custom ignored request folder guidance.
- Update increment implementation notes after implementation choices are finalized.

## Milestones

- Request template layout agreed.
- Make target contract agreed.
- `.http` templates added and manually runnable.
- REST create and update issue templates added with order processing sample content.
- GraphQL templates verified against a profile with `JIRA_CLOUD_ID`.
- Git ignore behavior verified.
- README workflow documented.

## Dependencies

- VS Code REST Client extension.
- Active Jira profile from `ATL-002`.
- `JIRA_CLOUD_ID` support from `ATL-003`.
- Jira Cloud and Atlassian GraphQL API availability.

## Rollout Notes

- Users start by selecting a Jira env with `make set-jira-env ENV=<name>`.
- Users complete `ATL-003` Cloud ID setup before running GraphQL templates.
- Users run `make copy-request-templates DEST=requests/local` when they want editable local request collections.
