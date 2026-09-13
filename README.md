# Development Standards

This repository is the versioned source of truth for cross-project development
standards. The top-level `SKILL.md` is the Codex entry point; it routes a task
to technology-specific rules instead of storing rules as undocumented memory.

The first implementation is .NET. Its policies are intentionally separated:

- `dotnet/packages.md` — NuGet selection, central version management, and feeds
- `dotnet/coding-style.md` — C# contracts, boundaries, and executable style
- `dotnet/comments.md` — XML documentation and comment decisions
- `dotnet/testing.md` — xUnit, Shouldly, and test-tier guidance
- `dotnet/toolchain-quality.md` — SDK pinning, CI gates, analyzers, and PR evidence
- `dotnet/security-dependency.md` — secret handling, NuGet audit, licensing, and feeds
- `dotnet/observability.md` — exception translation, structured logs, and redaction
- `dotnet/runtime-configuration.md` — Options, cancellation, timeouts, retries, and ownership

Each rule is marked **Required**, **Preferred**, or **Observed**. Required rules
are the reusable baseline, Preferred rules have a documented local rationale
when bypassed, and Observed rules record Pulse evidence without becoming a
universal mandate.

## Proposing an improvement

Record a candidate rule in [improvement-ledger.md](improvement-ledger.md).
Codex reviews the evidence, scope, benefit, cost, risk, and verifiability, then
records the final decision. Only an **Accepted** entry with a linked rule change
may become **Implemented**; a request or project-specific example alone never
changes the knowledge base.

## Adopt the .NET templates

Copy the files from `dotnet/templates/` to a solution root, then customize them
for the project's target frameworks and approved packages. Do not copy private
feed URLs or credentials from another project.

Validate the supplied templates with:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/Test-StandardsTemplates.ps1
```

Validate the whole knowledge base (Skill frontmatter, local Markdown links,
ledger statuses, and templates) with:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/Test-StandardsRepository.ps1
```

The repository's routine validation uses PowerShell and the .NET toolchain;
Python is not a prerequisite for consumers.
