# ATL-006 Rework Bruno Request Templates

## Status

- Draft

## Objective

- Simplify the Bruno Jira request template collection so shared connection and authentication settings are centralized at the collection/environment level, while request-specific sample inputs live with the request that uses them.

## Scope

- Rework the committed Bruno template collection under `setup/requests/bruno-jira-template/`.
- Move authentication to collection settings so individual request files inherit auth.
- Reduce environment variables to shared Jira connection/auth values only.
- Move issue keys, epic keys, issue types, and JQL samples into request-local pre-request variables.
- Update project initialization so generated Bruno environments contain only shared connection/auth values.
- Update setup docs to explain the new variable split.

## Non-goals

- Do not change the project workspace architecture from `ATL-005`.
- Do not implement Jira issue fetching or syncing.
- Do not add request generation.
- Do not add new Jira API workflows beyond reorganizing the existing request templates.
- Do not introduce multiple Jira environments per project.

## Dependencies

- `ATL-005` Bruno collection template and project workspace initialization.
- Bruno `.bru` collection support.

## Deliverables

- Increment package under `_increments/ATL-006-rework-bruno-request-templates/`.
- Planned implementation artifacts:
  - Updated `setup/requests/bruno-jira-template/collection.bru`
  - Updated `setup/requests/bruno-jira-template/environments/project.bru`
  - Updated REST request `.bru` files
  - Updated GraphQL request `.bru` files
  - Updated `setup/scripts/sync_bruno_env.sh`
  - Updated `setup/docs/setup.md`
