# Development Standards Repository Design

## Goal

Create a versioned, multi-technology development-standards repository. Its
first implemented technology is .NET, derived from the Pulse project at
`D:\Code Pulse\pulse`; later technologies remain isolated extensions.

## Decisions

### Source of truth

The repository is the source of truth for rules, templates, and decision
records. A Codex Skill is an entry point that routes work to the relevant
standards; it does not duplicate the rules or act as an unversioned memory.

### Repository layout

```text
dev-standards/
├── SKILL.md
├── dotnet/
│   ├── SKILL.md
│   ├── packages.md
│   ├── coding-style.md
│   ├── comments.md
│   ├── testing.md
│   └── templates/
├── decisions/
└── technology/
```

`technology/` is intentionally empty in the first release. Each later
technology gets a self-contained folder and its own routing instructions,
without weakening or generalising .NET-specific rules.

### Rule categories

Every rule is labeled as one of:

- **Required**: enforced by a project setting, CI, test, or review gate.
- **Preferred**: the default choice; deviations need a short local rationale.
- **Observed**: a Pulse convention that needs more evidence before becoming a
  standard.

This distinction prevents legacy implementation details from becoming global
requirements merely because they exist in Pulse.

### .NET baseline extracted from Pulse

- .NET 10 (`net10.0` / `net10.0-windows`) and nullable reference types
  enabled.
- Central Package Management and transitive dependency pinning via
  `Directory.Packages.props`.
- xUnit, Shouldly, and `Microsoft.NET.Test.Sdk`; unit, integration, and
  architecture test projects are separate.
- ReSharper shared settings and `eng/verify-style.ps1` provide the current
  formatting gate.
- Public interfaces and meaningful types commonly use XML documentation;
  test fixture classes use concise XML summaries.

### First-release optimization policies

- Package references have no inline versions; package version changes are
  centralized and reviewed with their source and compatibility impact.
- `nuget.config` source mappings must name existing sources. The current Pulse
  mapping for source `Pulse` is a validation finding, not a copied rule.
- Tests express observable behaviour in `Method_condition_expected_result`
  style, use `[Theory]` for equivalent data variations, and use Shouldly for
  assertions unless a framework assertion is materially clearer.
- Architecture rules are protected by automated architecture tests when a
  project boundary is important to build or runtime behaviour.
- XML documentation explains contracts, units, ownership, and non-obvious
  behaviour; it does not restate an obvious identifier. Implementation notes
  and temporary work items use the issue tracker rather than durable comments.
- Formatting configuration must be executable. The reusable templates favour
  `.editorconfig` and MSBuild settings; IDE-only settings remain optional
  project overlays.

## Skill behavior

The top-level Skill identifies the technology involved, loads only the needed
technology rules, and directs requests such as adding a package, writing a
test, reviewing C# code, or changing an architecture boundary to the
corresponding reference. It preserves user instructions over standards and
flags conflicts rather than silently applying a rule.

The `.NET` Skill adds a mandatory pre-change check for package source mapping,
central package management, test tier, and build/style verification appropriate
to the affected project.

## Validation

The implementation will validate Skill metadata and links, validate the
provided XML/configuration templates, and add a small repository-level test or
script that detects dangling NuGet source mappings in a consuming project.

The first release will not modify Pulse. Adoption into Pulse is a separate,
explicit change after the standards have been reviewed.
