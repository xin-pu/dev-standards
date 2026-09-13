# .NET Package Policy

## Required

- Use Central Package Management when a solution has more than one project:
  declare versions in `Directory.Packages.props` and omit `Version` from each
  `PackageReference`.
- Keep `ManagePackageVersionsCentrally` enabled and use transitive pinning only
  when the solution needs reproducible transitive versions.
- Every `packageSourceMapping/packageSource` key in `nuget.config` must name a
  configured `packageSources/add` key.
- Never commit package-feed credentials. Store them in the developer or CI
  credential mechanism provided by the feed.

## Preferred

- Add a dependency only when framework capabilities or an existing approved
  dependency cannot meet the need.
- Record why a non-obvious package was selected, especially one that defines a
  project boundary (ORM, messaging, UI framework, serialization, or plugin
  loader).
- Upgrade related package families together and run restore, build, and the
  affected tests before merging.

## Observed: Pulse baseline

Pulse uses `Directory.Packages.props` with central management and transitive
pinning. Its current ecosystem includes CommunityToolkit.Mvvm, DevExpress,
Serilog, SqlSugar, RabbitMQ.Client, xUnit, and Shouldly. These packages are
evidence, not a cross-project allowlist.

## Review checklist

Confirm the source is mapped, the package version is centralized, licenses and
support posture are acceptable, and tests cover the integration boundary.
