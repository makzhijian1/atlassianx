# Agent Instructions

## Make-Centric Workflow

This repository should expose project workflows through `make` targets first.

- Prefer adding or updating `Makefile` targets for repeatable local tasks.
- Keep credentials in ignored local env files; never commit `.env`, `.envs/jira/*.env`, or real Jira API tokens.
- Document new user-facing targets in `README.md`.

## Increment Structure

This project uses `_increments/` for spec-driven engineering work.

- `_increments/_templates/` contains the canonical document templates for new increments.
- Each real increment should live in `_increments/<ID>-<short-slug>/`.
- Each increment package should include:
  - `README.md`
  - `spec.md`
  - `plan.md`
  - `risks.md`
  - `test-plan.md`
  - `implementation-notes.md`

## Required Workflow

All feature-related changes in this repository must be packaged as an increment and adhere to this structure unless the user explicitly states otherwise.

Before implementing a feature, create or update the relevant increment package. Keep the spec, plan, risks, test plan, and implementation notes aligned with the actual change.

## Commit Convention

Commit messages should use the relevant increment ID as a prefix.

Format:

```text
(002) One-line summary

- Intent: Explain why this change exists.
- Intent: Explain the user-facing or operational outcome.
```

Use the increment number without the `ATL-` prefix, for example `(001)`, `(002)`, or `(003)`.
