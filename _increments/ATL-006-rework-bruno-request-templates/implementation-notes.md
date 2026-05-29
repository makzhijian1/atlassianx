# ATL-006 Implementation Notes

## Reality deviations from spec

- None yet. This increment is drafted for review before implementation.

## Tradeoffs made

- The draft treats `JIRA_PROJECT_KEY` as request-local because it is mainly used by issue create/search examples, not by every request.
- `JIRA_CLOUD_ID` remains shared because GraphQL requests need the tenant identity across multiple request examples.

## Technical debt introduced

- None yet.

## Future improvements

- Evaluate whether Bruno OpenCollection YAML would make inherited auth and request variables easier to inspect.
- Add Bruno CLI validation if `bru` becomes available in the local environment.
