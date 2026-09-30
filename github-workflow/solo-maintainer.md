# Solo Maintainer Profile

Use this profile by default for a repository maintained by one person. It
preserves evidence and safe delivery without requiring a second human,
CODEOWNERS, or hosted CI before the repository is ready for them.

## Maintainer identity

The authenticated GitHub identity for `gh` operations is `xin-pu`, confirmed on
2026-09-30 with `gh api user --jq .login`. Verify that command before the first
remote GitHub operation of a session; when it reports a different account,
re-confirm with the user before creating, assigning, or merging anything.
GitHub Issues created under this profile are assigned to that identity
([issue lifecycle](issue-lifecycle.md)).

## Non-negotiable baseline

- Never commit secrets, credentials, or production-only configuration.
- Before merging material work, run the relevant local restore, build, test,
  formatting, and analyzer commands that the repository can run; record the
  command and result in the Issue, PR, or commit message.
- Keep material work traceable: use a GitHub Issue, project ledger entry, or
  ADR when it records a defect, feature outcome, durable decision, dependency
  change, security concern, or meaningful risk.
- Do a self-review of the final diff. Do not merge work known to fail its
  declared checks or leave an unexplained standards deviation.

## Default delivery path

For a feature, bug fix, dependency update, migration, security change, or
material design/configuration change:

1. Create or identify an Issue and state the intended outcome and verification.
   Assign the new Issue to the maintainer identity above
   (`gh issue create --assignee xin-pu`).
2. Work on a named branch and open a pull request, including `Closes #<number>`
   when the Issue should close on merge.
3. Complete the PR checklist yourself and record local verification evidence.
4. Merge with a merge commit only after self-review; confirm the linked Issue
   closed and remove the merged branch safely.

## Deliberate shortcuts

Direct commits to the default branch are allowed for a typo, formatting-only
edit, or similarly trivial change with no behavior, dependency, security,
configuration, or data impact. Use a clear commit message and run any check
that the small change can affect. When uncertain, use the default delivery
path.

GitHub Actions, required status checks, branch protection, human approvals,
and CODEOWNERS are **Preferred** safeguards for this profile, not prerequisites.
Add CI when the project can run its checks in a reproducible hosted environment;
until then, retain local command evidence and record the CI limitation in the
project ledger or README.
