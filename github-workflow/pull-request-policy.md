# GitHub Pull Request Policy

## Required before opening a PR

- Rebase or otherwise reconcile with the intended base branch as appropriate
  for the repository's merge strategy.
- Run the required local verification commands and record their results.
- Update project README, design, ADR, ledger, migration, or configuration
  records when the change affects them.
- Open a PR from the Issue branch to the repository default branch and include
  the Issue-closing line in its description.

## Required PR description

- `Closes #<issue-number>`
- Outcome and scope of the change
- Verification commands and results
- Configuration, data migration, compatibility, security, and rollback impact
- Links to project design/ADR/deviation records and any shared standards ledger
  item when applicable

## Merge gate

Merge only after required status checks pass, required reviewers approve, and
all review conversations are resolved. Configure GitHub branch protection to
enforce pull requests, approvals, and required status checks; do not rely on a
convention that allows direct pushes to the default branch.

When the PR targets the default branch, GitHub's enabled automatic issue-close
behavior closes an Issue referenced by `Closes`, `Fixes`, or `Resolves` after
merge. Confirm the Issue closed and the merged commit/PR is linked before
marking the work complete.

## Branch cleanup

- **Required:** After a PR is merged, delete its feature branch from both the
  remote and local repository, then prune stale remote-tracking references.
- **Required:** Before deleting a branch, verify that all of its commits are
  reachable from the intended target branch. Never delete a branch with
  unmerged commits merely because its PR is closed or a similarly named PR was
  merged.
- **Required:** If the forge has already deleted the remote branch, do not
  recreate or force-delete it; prune the local remote-tracking reference and
  delete the verified local branch instead.

## Exceptions

A PR that intentionally does not complete its Issue must link it without a
closing keyword and leave the Issue open. Close an Issue without a PR only when
it is duplicate, declined, or otherwise not planned; record the closure reason.
