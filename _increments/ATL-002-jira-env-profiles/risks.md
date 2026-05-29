# ATL-002 Risks

## Unsafe Assumptions

- Existing `.envs/jira/<name>.env` values are compatible with Make `include`.
- Local env files use simple `KEY=value` lines.
- Profile names map directly to local filenames under `.envs/jira/`.

## Failure Modes

- A selected profile file is missing or has incomplete values.
- A developer accidentally commits a real profile if ignore rules are changed later.
- A token could leak if future commands print the full environment.

## Operational Risks

- Switching profiles changes `.env` for all existing Make commands in the checkout.
- Multiple terminals may run commands against different assumptions about the active `.env`.

## Security Concerns

- `.envs/jira/*.env` may contain `JIRA_API_TOKEN`.
- Summary commands must never print `JIRA_API_TOKEN`.

## Recovery / Mitigation

- Keep `.jira-env` and non-example profile envs ignored.
- Keep `example.env` token value as `replace_me`.
- Re-run `make set-jira-env ENV=<name>` to restore the intended active profile selection.
- Use `make show-jira-env` to verify the active non-secret selection.
