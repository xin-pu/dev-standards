---
name: development-standards
description: Apply this repository's development standards when creating, changing, reviewing, or testing code, selecting dependencies, or adopting shared project configuration. Use the technology-specific guidance for implementation; do not use for unrelated general programming questions.
---

# Development Standards

Use this repository as the versioned source of truth. User instructions take
precedence over these standards.

## Routing

- For .NET/C#, NuGet, MSBuild, xUnit, Shouldly, or C# code review work, read
  [the .NET standards Skill](dotnet/SKILL.md).
- For a technology with no directory under `technology/`, report that no local
  standard exists and do not infer .NET rules for it.
- For a proposal to add, remove, or materially change a standard, read
  [the improvement ledger](improvement-ledger.md). Record the proposal before
  treating it as a reusable rule, then make and document a final decision.
- For a new solution, project README, project design, local decision record,
  or standards deviation, read [the project-adoption Skill](project-adoption/SKILL.md).
- For GitHub Issue triage, work branches, pull requests, review, merge, or
  issue closure, read [the GitHub workflow Skill](github-workflow/SKILL.md).

Rules are labeled **Required**, **Preferred**, or **Observed**. Apply Required
rules unless the user explicitly overrides them; explain a Preferred-rule
deviation briefly; treat Observed entries as context rather than requirements.

An accepted ledger item must link to its implemented rule before its status is
changed to **Implemented**. Do not silently promote a project-specific practice
or a one-off request into the knowledge base.

## Repository operations

Keep `docs/superpowers/plans/` and `docs/superpowers/specs/` local and
untracked. They are coding-tool working artifacts, not knowledge-base records.
Move only a reviewed, enduring decision into a tracked standard, decision
record, or improvement-ledger entry.
