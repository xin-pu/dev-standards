# .NET Coding Style

## Required

- Enable nullable reference types in new .NET projects and treat nullability at
  public boundaries as part of the contract.
- Keep project dependencies directed: contracts and domain abstractions must
  not depend on UI, infrastructure, or composition roots.
- Store formatting and analyzer choices in versioned repository configuration,
  not only an individual IDE profile.
- Run the repository's documented style and build checks before completing a
  change.

## Preferred

- Use clear, domain-oriented names and small focused types. Expose interfaces
  at meaningful plugin, device, storage, transport, or application boundaries.
- Prefer behavior-preserving refactors with targeted tests over broad cleanup
  unrelated to the requested change.
- Use collection expressions and modern C# syntax only when they make the
  intent clearer for the target framework and team toolchain.

## Observed: Pulse baseline

Pulse targets .NET 10 and `net10.0-windows` where appropriate, enables
nullable references per project, and uses ReSharper shared settings plus a
repository style-verification script. It has explicit application, contracts,
runtime, UI, integration, and architecture-test boundaries.
