# ATL-002 Plan

## Architecture Notes

- Keep `.envs/jira/<name>.env` files as the single credential source of truth.
- Store the active profile name in ignored `.jira-env`.
- Use Make targets for user-facing workflow and a small shell helper for safe summary parsing.
- Parse env files as data instead of sourcing them for display, avoiding secret leakage or shell execution.

## Implementation Breakdown

- Create the increment package documents.
- Add `.envs/jira/example.env`.
- Update `.gitignore` for `.env`, profile env files, and the committed example exception.
- Add Make targets for listing, selecting, and showing Jira envs.
- Add a shell helper that prints only non-secret summary keys.
- Document the Jira environment workflow in `README.md`.

## Milestones

- Increment package exists.
- Profile files and ignore rules are in place.
- Make targets operate on local profile files.
- README explains setup, selection, verification, listing, and security notes.

## Dependencies

- `make`
- POSIX shell utilities
- Existing `.env`-based Jira scripts

## Rollout Notes

- Existing users can keep their current `.env`.
- Users can run `make init-jira-account` to create `.envs/jira/<name>.env`, or copy `.envs/jira/example.env` to `.envs/jira/<name>.env`, fill in credentials, then activate it with `make set-jira-env ENV=<name>`.
