# ATL-002 Implementation Notes

## Reality deviations from spec

- None.

## Tradeoffs made

- A small shell helper is used for safe summary printing to keep the Makefile readable.
- `.jira-env` is used as an active-profile pointer so switching does not overwrite saved profile credentials.
- `list-jira-envs` marks `example` as an example instead of excluding it, so users can discover the template.

## Technical debt introduced

- Env parsing supports simple `KEY=value` files and does not attempt full shell-compatible env parsing.

## Future improvements

- Add profile validation that checks required keys before activation.
- Add an optional target to create a new profile from the example template.
