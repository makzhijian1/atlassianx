# ATL-001 Implementation Notes

## Reality deviations from spec

- None.

## Tradeoffs made

- The script updates `.env` with simple shell tooling instead of introducing a language runtime dependency.
- `.env` stores one active Jira project session instead of a profile list.

## Technical debt introduced

- Jira project URL parsing supports the expected Jira Software `/projects/{projectKey}` URL shape.
- Multi-project account switching is not implemented yet.

## Future improvements

- Add project profiles, for example `.jira-sessions/`, and a Make target for switching the active project.
- Add token rotation guidance.
