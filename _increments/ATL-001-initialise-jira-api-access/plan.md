# ATL-001 Plan

## Architecture Notes

- Keep repository workflows Make-centric.
- Keep credential handling local and simple by using `.env`.
- Keep browser opening opportunistic so setup still works in non-macOS shells.
- Treat `.env` as the active Jira project session for this checkout.
- Verify authentication and project access through Jira Cloud REST API calls.

## Implementation Breakdown

- Add `.gitignore` with `.env`.
- Add `.env.example` with the Jira keys.
- Add `Makefile` targets for `init` and `init-jira-account`.
- Add a shell script for the interactive Jira setup.
- Add a shell script for Jira connectivity verification.
- Add `make test-jira-account` for repeatable verification.
- Add README setup instructions.
- Add increment templates and this first Jira API access increment.

## Milestones

- Repository has Make targets.
- `.env` creation is idempotent.
- Jira credential prompt persists values to `.env`.
- Jira connectivity verification succeeds for account and project access.
- Increment documentation exists.

## Dependencies

- Local shell with `bash`, `awk`, `grep`, `mktemp`, `stty`, `sed`, and `curl`.
- Jira Cloud account access.
- Network access to the Jira Cloud site.
- GitHub repository write access for pushing.

## Rollout Notes

- Commit and push the repository baseline to `main`.
- Run `make init` to create `.env` locally.
- Run `make init-jira-account` when ready to enter real Jira credentials.
- Run `make test-jira-account` whenever credentials or project access need to be rechecked.
- Add a future increment for multiple saved Jira project sessions and switching.
