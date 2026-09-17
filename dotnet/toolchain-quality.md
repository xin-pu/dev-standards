# .NET Toolchain and Quality Gates

## Required

- Pin the supported .NET SDK in `global.json` for repositories that build in
  CI or are maintained by more than one developer. State the intended
  `rollForward` policy explicitly.
- Run restore, build, tests, formatting, and configured analyzers in CI for
  every pull request when CI is available. For a personal repository without
  reproducible hosted CI, run and record the relevant local commands instead;
  record the CI limitation as a project operational constraint.
- Version analyzer configuration, suppression decisions, and editor settings
  with the repository. Do not rely on workstation-only IDE settings.
- Treat compiler errors and security findings as merge blockers. Any temporary
  warning suppression must state its scope, reason, owner, and expiry/removal
  condition.
- Pull requests must identify behavior changes, configuration or data changes,
  risk, and commands/tests run.

## Preferred

- Start with a small, consistently enforced analyzer set; promote noisy rules
  only after the codebase can meet them without broad unrelated cleanup.
- Use conventional, intent-revealing commit messages such as `feat:`, `fix:`,
  `refactor:`, `test:`, `docs:`, and `chore:`.
- Make the local verification command match CI as closely as practical.

## Namespace-provider alignment

When a repository enforces the folder-aligned namespace rule with `IDE0130`,
keep the IDE namespace provider aligned with it. Do not leave ReSharper
`NamespaceFoldersToSkip` settings or `#pragma warning disable IDE0130` in a
project unless the project documents the exception and its review date. Check
these settings first when the editor and build suggest different namespaces.

## Gate proof

When introducing or materially changing a build-time analyzer gate, prefer one
deliberate, throwaway violation to prove the intended build reports the rule;
delete the probe in the same change. For a command-line `IDE0130` gate, expose
`RootNamespace` and `ProjectDir` through `CompilerVisibleProperty` when the
SDK/analyzer combination requires it. Build the solution after solution or
project structure changes, not only the touched project.

## Observed: Pulse baseline

Pulse already centralizes ReSharper settings and runs a style-verification
script. Its current projects target .NET 10, but a repository-wide
`global.json` policy should be adopted deliberately rather than copied with an
assumed SDK patch version.
