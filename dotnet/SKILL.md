---
name: dotnet-development-standards
description: Apply .NET and C# standards for NuGet dependency changes, project configuration, implementation, code review, XML documentation, and xUnit testing. Use after the repository-level development-standards Skill selects .NET.
---

# .NET Development Standards

Read only the reference needed for the request:

- Package addition, removal, upgrade, feed, or restore problem: [packages.md](packages.md).
- C# implementation, refactor, project structure, or review: [coding-style.md](coding-style.md).
- XML documentation or code comments: [comments.md](comments.md).
- Unit, integration, architecture tests, or test review: [testing.md](testing.md).
- SDK selection, analyzers, CI gates, pull requests, or commit quality: [toolchain-quality.md](toolchain-quality.md).
- Secrets, NuGet vulnerability or license review, and dependency risk: [security-dependency.md](security-dependency.md).
- Exceptions, structured logging, correlation, or production diagnostics: [observability.md](observability.md).
- `appsettings`, Options, cancellation, timeout, retry, concurrency, or external calls: [runtime-configuration.md](runtime-configuration.md).

Before changing a project, identify its target framework, nullable setting,
package-management method, and applicable test tier. Preserve explicit user
decisions when they conflict with a Preferred rule; surface a conflict with a
Required rule before proceeding.
