# .NET Security and Dependency Governance

## Required

- Never commit credentials, access tokens, certificates, connection strings
  containing secrets, or private feed credentials. Provide non-secret example
  configuration only.
- Keep NuGet audit enabled by default. A temporary audit disablement requires a
  documented reachability or tooling reason, owner, and removal condition.
- Review direct dependency additions for maintained status, compatible license,
  supported target framework, vulnerability advisories, and transitive impact.
- Use package source mapping to constrain private or organization packages to
  their approved feeds. Every mapping must name an existing source.
- Treat secrets exposed in source control or logs as an incident: revoke or
  rotate the secret, then remove it from reachable history according to the
  organization incident process.

## Preferred

- Prefer platform APIs and existing approved dependencies over a new package.
- Pin dependency versions centrally and upgrade related package families in one
  reviewed change.
- Generate an SBOM or equivalent dependency inventory for released products
  when customer, regulatory, or supply-chain requirements apply.

## Observed: Pulse baseline

Pulse centralizes dependency versions and source mappings. Its `NuGetAudit`
setting is temporarily disabled because of an unreachable private feed; this
is an exception pattern to track and close, not a default for new repositories.
