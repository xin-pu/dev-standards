# .NET Toolchain and Quality Gates

## Required

- Pin the supported .NET SDK in `global.json` for repositories that build in
  CI or are maintained by more than one developer. State the intended
  `rollForward` policy explicitly.
- Run restore, build, tests, formatting, and configured analyzers in CI for
  every pull request. A build is not a substitute for tests or formatting.
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

## Observed: Pulse baseline

Pulse already centralizes ReSharper settings and runs a style-verification
script. Its current projects target .NET 10, but a repository-wide
`global.json` policy should be adopted deliberately rather than copied with an
assumed SDK patch version.
