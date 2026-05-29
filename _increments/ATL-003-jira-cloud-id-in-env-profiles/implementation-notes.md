# ATL-003 Implementation Notes

## Reality deviations from spec

- Cloud ID is retrieved from `${JIRA_SITE_URL}/_edge/tenant_info` instead of the accessible resources API. This keeps discovery tied directly to the selected Jira site.
- `scripts/test_jira_account.sh` supports `REQUIRE_CLOUD_ID=0` so init can validate REST credentials before Cloud ID has been fetched.

## Tradeoffs made

- The lookup uses simple shell parsing for the `cloudId` field to avoid adding a JSON parser dependency.

## Technical debt introduced

- The tenant info JSON parser handles the expected compact `cloudId` field shape and is not a general JSON parser.

## Future improvements

- Add a non-interactive refresh target later if profiles need Cloud ID updates without re-entering tokens.
