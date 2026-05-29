# ATL-005 Implementation Notes

## Reality deviations from spec

- Implemented with `projects/<project-name>/.env` as the only Jira env contract.
- Implemented the canonical Bruno template collection under `setup/requests/bruno-jira-template/`.
- Implemented project-local Bruno collection initialization under `projects/<project-name>/requests/jira/`.
- Left existing ignored local `.envs/` files untouched; they are no longer read by Make targets.

## Tradeoffs made

- The draft chooses `projects/<project-name>/.env` instead of `projects/<project-name>/.jira-env` plus `.envs/jira/*.env`.
- The reason is that the project workspace is already the active container, so a second active-profile selector adds complexity without a current workflow requirement.
- Multi-profile support can be reintroduced later if a project needs multiple Jira accounts or sites.
- The draft now includes Bruno integration and conversion from `.http` to `.bru`.
- The Bruno collection is initialized inside the ignored project workspace because request execution state and generated environment values belong with local user work.
- The canonical Bruno template collection remains under `setup/requests/bruno-jira-template/`.
- The generated Bruno environment file duplicates values from `projects/<project-name>/.env`; this is accepted because both files are ignored local state and Bruno expects environment files in its own collection structure.

## Technical debt introduced

- Bruno request files are converted manually from the existing `.http` templates. They should be opened in Bruno for an application-level smoke test before relying on them for production Jira writes.

## Future improvements

- Add optional migration guidance for users with old root-level `.envs/jira/*.env` files.
- Add multi-account support inside a project if a concrete workflow requires it.
- Add future issue export/import behavior under `projects/<project-name>/issues/`.
- Add future request definitions under `projects/<project-name>/requests/`.
- Evaluate Bruno OpenCollection YAML as a later migration target if it becomes more useful than classic `.bru`.
