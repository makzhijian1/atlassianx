# ATL-003 Specification

## Behaviour

- `make init-jira-account` prompts for Jira env name, project URL, email, and API token as in `ATL-002`.
- After validating account auth and project access, init retrieves tenant info from `JIRA_SITE_URL`.
- Init writes `JIRA_CLOUD_ID=<cloud-id>` into `.envs/jira/<name>.env`.
- Init updates an existing `JIRA_CLOUD_ID` key instead of appending duplicates.
- `make show-jira-env` includes `JIRA_CLOUD_ID` when present, marks it missing for old profiles, and continues to omit `JIRA_API_TOKEN`.
- `make test-jira-account` fails clearly when `JIRA_CLOUD_ID` is missing so old profiles are refreshed before GraphQL-dependent work.

## Contracts

- The Jira profile contract becomes:
  - `JIRA_PROJECT_URL`
  - `JIRA_EMAIL`
  - `JIRA_API_TOKEN`
  - `JIRA_SITE_URL`
  - `JIRA_PROJECT_KEY`
  - `JIRA_CLOUD_ID`
- `JIRA_CLOUD_ID` is not secret, but it is profile-specific and should remain in ignored `.envs/jira/<name>.env` files.
- Cloud ID discovery must not print `JIRA_API_TOKEN`.
- Cloud ID discovery must fail clearly if the tenant info endpoint cannot be read or does not contain `cloudId`.

## Inputs / Outputs

- Inputs:
  - Active Jira env name supplied to `make init-jira-account`.
  - Jira site URL derived from the project URL.
  - Jira email and API token.
- Outputs:
  - Updated `.envs/jira/<name>.env` with `JIRA_CLOUD_ID`.
  - Safe terminal confirmation showing env name, `JIRA_SITE_URL`, `JIRA_PROJECT_KEY`, `JIRA_EMAIL`, and `JIRA_CLOUD_ID`.

## Invariants

- `JIRA_API_TOKEN` is never printed.
- Root `.env` is not used or created.
- `.jira-env` remains the active profile pointer.
- Re-running init for the same env updates existing keys in place without duplicates.

## Edge Cases

- Jira tenant info endpoint returns a non-200 response.
- Jira tenant info endpoint response does not contain `cloudId`.
- Credentials authenticate but accessible resources API fails.
- Existing profile has an old or incorrect `JIRA_CLOUD_ID`.

## Failure Semantics

- If Cloud ID discovery fails, init exits non-zero after explaining the failed lookup.
- The profile may contain the previously entered Jira values when Cloud ID discovery fails, so rerunning init should update the same file cleanly.
- Failed discovery must not corrupt the profile file or duplicate keys.
