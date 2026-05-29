# ATL-003 Plan

## Architecture Notes

- Keep Cloud ID setup inside `make init-jira-account` because `JIRA_CLOUD_ID` is part of a usable Jira profile.
- Reuse the current profile file update helper so all Jira env keys are written consistently.
- Use the Jira site tenant info endpoint to discover Cloud ID for the configured site.

## Implementation Breakdown

- Add `JIRA_CLOUD_ID=replace_me` to `.envs/jira/example.env`.
- Add Cloud ID discovery logic to `scripts/init_jira_account.sh`.
- Extend safe summary output to include `JIRA_CLOUD_ID` when present.
- Update `README.md` first-time setup section to explain that init stores Cloud ID.
- Update relevant tests/checks for the new key.

## Milestones

- Example env contains `JIRA_CLOUD_ID`.
- Init retrieves Cloud ID for the configured site.
- Init writes Cloud ID to the named profile.
- Safe summaries include Cloud ID and continue to hide the token.
- README describes the updated first-time setup result.

## Dependencies

- `curl`
- `base64`
- Existing Jira profile scripts from `ATL-002`
- Jira Cloud tenant info endpoint

## Rollout Notes

- Existing profiles can be refreshed by rerunning `make init-jira-account` for the same env name.
- After this increment, GraphQL-focused increments can assume `JIRA_CLOUD_ID` is available in Jira profiles.
