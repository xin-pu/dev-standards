# .NET Coding Style

## Required

- Enable nullable reference types in new .NET projects and treat nullability at
  public boundaries as part of the contract.
- Keep project dependencies directed: contracts and domain abstractions must
  not depend on UI, infrastructure, or composition roots.
- Declare stable public diagnostic codes and method identifiers in
  domain-scoped static identifier types. Production code and consumers must
  reference those identifiers rather than duplicate contract strings.
- Store formatting and analyzer choices in versioned repository configuration,
  not only an individual IDE profile.
- Format conditionals for readability: every `if`, `else if`, and `else` body
  uses braces; each statement occupies its own line; and `else` begins after
  the preceding closing brace. Keep short conditions on one line. When a
  condition wraps, retain its first clause after `if (` and indent each
  following Boolean clause on its own line.
- Run the repository's documented style and build checks before completing a
  change.
- For every non-generated `.cs` file, declare its namespace as the owning
  project's `RootNamespace` plus every folder segment relative to that
  project's `.csproj` directory. If `RootNamespace` is not explicitly set,
  use `MSBuildProjectName`.
- Declare each public, non-`partial` top-level `class`, `record`, `struct`,
  `interface`, and `enum` in a same-named source file. Private nested types
  and internal helper models used by one public host may remain co-located
  when that is clearer; explain other exceptions in the review.
- Treat a namespace mismatch as a build failure by enabling
  `EnforceCodeStyleInBuild` and configuring `IDE0130` as `error`. Do not claim
  a warning-only diagnostic is an enforced gate.

```csharp
if (hasValidReferencePlane &&
    sampleCount >= minimumSamples)
{
    return result;
}
else
{
    return fallback;
}
```

## Preferred

- Use clear, domain-oriented names and small focused types. Expose interfaces
  at meaningful plugin, device, storage, transport, or application boundaries.
- Prefer behavior-preserving refactors with targeted tests over broad cleanup
  unrelated to the requested change.
- Use collection expressions and modern C# syntax only when they make the
  intent clearer for the target framework and team toolchain.
- Retain explicit array creation when a collection expression has no usable
  target type or would obscure a required target type such as
  `ReadOnlyMemory<T>`; verify the conversion by compiling the affected code.

## Namespace examples

Assume a project named `Pulse.Application` whose project root namespace is
`Pulse.Application`:

| File relative to the project directory | Required namespace |
| --- | --- |
| `MappingProfile.cs` | `Pulse.Application` |
| `Benches/IBenchRepository.cs` | `Pulse.Application.Benches` |
| `Composition/Catalog/ProjectCatalog.cs` | `Pulse.Application.Composition.Catalog` |

`src`, `test`, and Visual Studio virtual solution folders are not project
folders and do not contribute namespace segments. Neither do generated files
under `bin` or `obj`. Every real folder inside the project directory does;
folders such as `Domains`, `Dtos`, `Interfaces`, and `TestPlan` cannot be
silently omitted.

Historical code that omits folder segments is a migration backlog, not an
exception for new work. Namespace changes in a published contract can be
breaking; make that migration deliberately rather than as incidental cleanup.

## Observed: Pulse baseline

Pulse targets .NET 10 and `net10.0-windows` where appropriate, enables
nullable references per project, and uses ReSharper shared settings plus a
repository style-verification script. It has explicit application, contracts,
runtime, UI, integration, and architecture-test boundaries.

Pulse's written namespace standard is the basis for the Required rule above.
Some legacy source files omit intermediate folders; those examples must not be
used to choose a namespace for new or moved code.
