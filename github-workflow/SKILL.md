---
name: github-development-workflow
description: Run a GitHub-based development lifecycle from Issue triage through branch, pull request, review, merge, automatic Issue closure, and promotion of reusable lessons into the shared standards ledger.
---

# GitHub Development Workflow

Read [issue-lifecycle.md](issue-lifecycle.md) for Issue intake, triage, and
branch creation. Read [pull-request-policy.md](pull-request-policy.md) before
opening, reviewing, merging, or closing a pull request.

For a personally maintained repository, read and use the default
[solo-maintainer.md](solo-maintainer.md) profile. It relaxes collaboration-only
controls while retaining verification, traceability, and self-review.

Use [templates](templates/) when bootstrapping a GitHub repository. Preserve
the repository's existing templates when they are more specific; merge only the
shared fields that do not conflict.

Do not create, merge, close, or modify a remote GitHub object without the user
authorization applicable to that operation. A merged PR closes a linked Issue
only when it targets the repository default branch and uses a supported closing
keyword.
