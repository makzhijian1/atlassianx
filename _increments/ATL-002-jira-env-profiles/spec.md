# ATL-002 Specification

## Behaviour

- `.envs/jira/*.env` stores named Jira environments.
- `.envs/jira/example.env` is a committed safe template.
- `.envs/jira/<name>.env` files are the credential source of truth.
- `.jira-env` stores the active Jira env name for this checkout.
- `make list-jira-envs` prints available Jira env names without the `.env` suffix and marks `example` as an example profile.
- `make set-jira-env ENV=<name>` requires `ENV`, resolves `.envs/jira/<name>.env`, fails if it is missing, writes `.jira-env`, and prints a safe summary.
- `make show-jira-env` reads the active profile selected by `.jira-env`, fails if no profile is selected or the selected file is missing, and prints a safe summary.
- `make init-jira-account` prompts for a Jira env name and writes settings to `.envs/jira/<name>.env`.
- Safe summaries include `JIRA_SITE_URL`, `JIRA_PROJECT_KEY`, and `JIRA_EMAIL`.
- Safe summaries never print `JIRA_API_TOKEN`.

## Contracts

- Commands are exposed through `make`.
- Named Jira profile files use this path contract: `.envs/jira/<name>.env`.
- `.jira-env` is the active env selector consumed by Make targets.
- `.jira-env` and `.envs/jira/*.env` are ignored by git except `.envs/jira/example.env`.
- Existing Jira targets consume the selected `.envs/jira/<name>.env` file.

## Inputs / Outputs

- Inputs:
  - `ENV=<name>` for `make set-jira-env`.
  - Local Jira profile files in `.envs/jira/`.
- Outputs:
  - `.jira-env` updated with the selected profile name.
  - Safe terminal summaries that omit API tokens.

## Invariants

- Jira API tokens are never printed by profile management targets.
- Missing inputs or files produce clear non-zero failures.
- The example profile remains safe to commit.

## Edge Cases

- `ENV` is omitted.
- The selected `.envs/jira/<name>.env` file does not exist.
- `.jira-env` does not exist when showing the active env.
- No local Jira profile files exist except `example.env`.
- A profile is missing a non-secret summary key.

## Failure Semantics

- `make set-jira-env` exits non-zero before copying if `ENV` is missing or the source profile does not exist.
- `make show-jira-env` exits non-zero if no active profile is selected or the active profile file does not exist.
- Safe summary generation exits non-zero if required display keys are missing.
