# GitHub Issue Lifecycle

## Material-work baseline

- In a solo-maintainer repository, create or identify a GitHub Issue before
  starting a material code, behavior, dependency, configuration, or
  documentation change. A project ledger or ADR may carry the record when it
  is the more appropriate durable home.
- The Issue must state the problem or outcome, acceptance criteria, scope,
  risk, and verification expectations.
- Classify the Issue as one of `bug`, `feature`, `maintenance`, `security`, or
  `standards-improvement`; apply an appropriate GitHub label.
- Prefer a branch from the current default branch using
  `<type>/<issue-number>-<short-kebab-title>`, for example
  `fix/123-null-device-state`.
- Keep one Issue focused on one independently reviewable outcome. Split or use
  sub-issues when the acceptance criteria cannot be reviewed together.

Read [solo-maintainer.md](solo-maintainer.md) for the allowed direct-commit
exception and the default personal-development path.

## Decision routing

- Keep project-specific work in the project Issue and project documentation.
- If the completed work reveals a reusable rule, open or update an entry in the
  shared development-standards improvement ledger; do not copy a general rule
  into only one project.
- If the project must diverge from a shared Required rule, record the exception
  in the project's standards-deviation ledger before requesting merge.

## Issue completion

The PR description must use `Closes #<issue-number>` for an Issue in the same
repository, or `Closes owner/repository#<issue-number>` for a cross-repository
Issue. Do not manually close a still-unresolved Issue merely because a branch
or draft PR exists.
