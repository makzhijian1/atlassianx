# ATL-004 Implementation Notes

## Reality deviations from spec

- GraphQL templates are intentionally editable starter templates because Atlassian GraphQL Jira schema fields can vary by tenant and API evolution.

## Tradeoffs made

- Planned Make targets are intentionally limited to copying templates.
- Request execution remains in VS Code REST Client rather than a custom CLI.

## Technical debt introduced

- The copy target copies placeholder templates as-is; it does not hydrate local copies from the active Jira profile.

## Future improvements

- Add pagination examples for large JQL or epic result sets.
- Add richer mutation templates for transitions, comments, labels, and assignees if needed later.
- Add GraphQL schema notes once the final query shapes are verified.
