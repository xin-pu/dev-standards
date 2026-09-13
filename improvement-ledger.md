# Development Standards Improvement Ledger

This ledger is the only intake and decision record for proposed additions or
changes to this knowledge base. A proposal is not a standard until its status
is **Accepted** and the linked rule has been implemented.

## Decision authority

Codex is the final reviewer for whether a proposal belongs in this knowledge
base. The decision is based on cross-project applicability, evidence, risk,
maintainability, and whether the rule can be followed or verified in practice.
User instructions always take precedence for a specific task; they do not turn
an unreviewed proposal into a general rule.

## Statuses

| Status | Meaning |
| --- | --- |
| Proposed | Recorded but not yet assessed. |
| Under Review | Evidence and impact are being evaluated. |
| Accepted | Approved for this knowledge base; the linked rule change must be implemented before closing the entry. |
| Rejected | Not suitable as a reusable standard; retain the rationale to avoid reopening the same question without new evidence. |
| Deferred | Potentially useful, but missing evidence, prerequisites, or an appropriate scope. |
| Implemented | The accepted rule is present in the knowledge base and linked below. |

## Intake template

Copy this section for every new proposal. Do not remove rejected or deferred
entries; supersede them with a new entry when materially new evidence appears.

```markdown
### DS-YYYY-NNN — Short, outcome-oriented title

- **Status:** Proposed
- **Proposed on:** YYYY-MM-DD
- **Scope:** .NET | cross-technology | a named future technology
- **Proposal:** What should change, stated as an observable rule or capability.
- **Evidence:** Project examples, incident, user need, dependency change, or external requirement.
- **Expected benefit:** What becomes safer, clearer, faster, or more consistent.
- **Costs and risks:** Adoption effort, false positives, tool constraints, compatibility, and exceptions.
- **Affected standards:** Links to existing files, or `new`.
- **Decision:** Pending final review.
- **Decision rationale:** Pending final review.
- **Implementation link:** Not applicable until accepted.
- **Review again:** YYYY-MM-DD or `not needed`.
```

## Entries

### DS-2026-001 — Record the Shouldly assertion-mapping pitfalls observed during a full xUnit migration

- **Status:** Proposed
- **Proposed on:** 2026-09-13
- **Scope:** .NET
- **Proposal:** Add a mapping/exception table to the testing standard: `bool?` receivers must use `ShouldBe(true/false)` (no `ShouldBeTrue()`); Shouldly is type-strict so byte receivers need explicit `(byte)` casts on int literals; xUnit `Assert.Equal(double, double)` rounds to 5 decimals while Shouldly compares exactly, so port with an explicit tolerance; `Assert.ThrowsAnyAsync<T>` maps to `Should.ThrowAsync<T>` (matches derived types, verified); `Assert.Collection` has no direct equivalent; `Assert.All` maps to `ShouldAllBe`.
- **Evidence:** OpenCMIS migrated 396 `Assert.*` sites; ~30 needed hand conversion and each pitfall above produced a compile error or silent semantic change.
- **Expected benefit:** Future migrations avoid the silent-failure traps; reviewers know which conversions are not mechanical.
- **Costs and risks:** Table duplicates library docs; may age with Shouldly versions.
- **Affected standards:** [dotnet/testing.md](dotnet/testing.md) (Preferred Shouldly bullet).
- **Decision:** Pending final review.
- **Decision rationale:** Pending final review.
- **Implementation link:** Not applicable until accepted.
- **Review again:** not needed

### DS-2026-002 — Define a build-time style gate as the CI-free minimum quality gate

- **Status:** Proposed
- **Proposed on:** 2026-09-13
- **Scope:** .NET
- **Proposal:** When a repository cannot run CI (for example, dependencies resolve only from machine-local feeds), require `EnforceCodeStyleInBuild` plus versioned `.editorconfig` severities as the enforced gate, and `dotnet format --verify-no-changes` as the verification command.
- **Evidence:** OpenCMIS has no CI workflows (removed; DevExpress 25.2.4 exists only in machine-local NuGet sources), so build-time enforcement was the only place style rules could fail a change; it caught IDE0130/IDE0161/IDE0300/IDE0290 regressions during the cleanup.
- **Expected benefit:** The Required CI rule gets an auditable local fallback instead of being silently unmet.
- **Costs and risks:** EnforceCodeStyleInBuild slows builds slightly; severities must be curated to stay at zero noise.
- **Affected standards:** [dotnet/toolchain-quality.md](dotnet/toolchain-quality.md).
- **Decision:** Pending final review.
- **Decision rationale:** Pending final review.
- **Implementation link:** Not applicable until accepted.
- **Review again:** when a CI-capable repository setup exists

### DS-2026-003 — Make namespace-equals-project-plus-folder the preferred layout with an IDE0130 gate

- **Status:** Proposed
- **Proposed on:** 2026-09-13
- **Scope:** .NET
- **Proposal:** Prefer namespaces that mirror the project name plus the file's subfolder path, enforced by `dotnet_diagnostic.IDE0130.severity = warning`; document the migration mechanics: script namespace rewrites from folder paths, repair using directives from compiler CS0246 output, exempt `Properties/AssemblyInfo.cs`.
- **Evidence:** OpenCMIS inverted its old flat-namespace convention: 39 src files renamed, 77 files needed using updates, and the repo now gates IDE0130 at build time with zero violations.
- **Expected benefit:** One widely understood convention instead of per-project choice; the scripted migration is reusable.
- **Costs and risks:** Big one-time diff; public-API consumers see new namespaces (acceptable pre-distribution); same-project sibling types start needing using directives they did not need before.
- **Affected standards:** [dotnet/coding-style.md](dotnet/coding-style.md).
- **Decision:** Pending final review.
- **Decision rationale:** Pending final review.
- **Implementation link:** Not applicable until accepted.
- **Review again:** not needed

### DS-2026-004 — Document collection-expression limits when enforcing IDE0300

- **Status:** Proposed
- **Proposed on:** 2026-09-13
- **Scope:** .NET
- **Proposal:** Alongside the existing collection-expression preference, record two non-convertible shapes: `var x = new byte[] { … }` has no target type (CS9176, needs an explicit type), and `ReadOnlyMemory<T>` parameters cannot be initialized by collection expressions (CS9174); such sites legitimately keep `new T[] { }`.
- **Evidence:** 23 literals in OpenCMIS: 3 needed explicit-type edits and 20 must stay array-creation because the callee takes `ReadOnlyMemory<byte>`.
- **Expected benefit:** Reviewers stop flagging the residual literals; gate adoption isn't blocked by them.
- **Costs and risks:** Trivial; may be fixed by future C# versions.
- **Affected standards:** [dotnet/coding-style.md](dotnet/coding-style.md).
- **Decision:** Pending final review.
- **Decision rationale:** Pending final review.
- **Implementation link:** Not applicable until accepted.
- **Review again:** next LangVersion upgrade

### DS-2026-005 — Adopt primary constructors (IDE0290) selectively with a fixer-plus-review procedure

- **Status:** Proposed
- **Proposed on:** 2026-09-13
- **Scope:** .NET
- **Proposal:** Standardize on converting trivial `ctor-assigns-get-only-properties` classes to primary constructors via `dotnet format --diagnostics IDE0290` followed by readability review; keep validation-plus-defaulting constructors as conversions (field initializers preserve the throw) or explicit suppressions; note that XML `<param>` docs move onto the type declaration.
- **Evidence:** OpenCMIS converted 9 classes net −52 lines with zero test changes and the IDE0290 gate at warning; the fixer's indentation needed one follow-up format pass.
- **Expected benefit:** Less ceremony for data-carrying classes; consistent decision procedure.
- **Costs and risks:** Primary-constructor capture semantics can surprise with optional parameters or logging; diff noise for reviewers.
- **Affected standards:** [dotnet/coding-style.md](dotnet/coding-style.md) (modern-syntax preference).
- **Decision:** Pending final review.
- **Decision rationale:** Pending final review.
- **Implementation link:** Not applicable until accepted.
- **Review again:** not needed

### DS-2026-006 — Pair Central Package Management adoption with package source mapping in the same change

- **Status:** Proposed
- **Proposed on:** 2026-09-13
- **Scope:** .NET
- **Proposal:** When enabling CPM in a repository whose NuGet configuration has more than one package source, add `nuget.config` `packageSourceMapping` in the same change, including explicit keys for machine-local vendor feeds.
- **Evidence:** OpenCMIS's CPM switch surfaced NU1507 immediately (nuget.org + a GitHub feed); the fix was a repo-level `nuget.config` mapping `DevExpress.*` to the local folder and `*` to nuget.org.
- **Expected benefit:** No broken/dirty restore on the first CPM build; package origins become explicit.
- **Costs and risks:** Local-folder paths differ per machine; mapping needs maintenance when feeds change.
- **Affected standards:** [dotnet/packages.md](dotnet/packages.md).
- **Decision:** Pending final review.
- **Decision rationale:** Pending final review.
- **Implementation link:** Not applicable until accepted.
- **Review again:** not needed

### DS-2026-007 — Require a CS1591 gap audit before promoting the missing-docs warning

- **Status:** Proposed
- **Proposed on:** 2026-09-13
- **Scope:** .NET
- **Proposal:** When turning on `GenerateDocumentationFile`, keep CS1591 off the build until the unique-missing-member count is measured and either closed or triaged; exempt test assemblies unconditionally via `tests/Directory.Build.props`.
- **Evidence:** OpenCMIS measured 356 unique public members lacking docs at gate-on time; wholesale promotion would have buried real diagnostics, so the repo suppressed it with a recorded follow-up and the count is tracked in its verification doc.
- **Expected benefit:** Doc gates land on real numbers, not wishful severity flips; the tests exemption matches the "document where callers need semantics" rule.
- **Costs and risks:** Suppression can persist if no owner follows up; requires the ledger-style expiry note already required by toolchain-quality.
- **Affected standards:** [dotnet/comments.md](dotnet/comments.md).
- **Decision:** Pending final review.
- **Decision rationale:** Pending final review.
- **Implementation link:** Not applicable until accepted.
- **Review again:** when the OpenCMIS doc pass lands

### DS-2026-008 — Make PowerShell the default knowledge-base validation toolchain

- **Status:** Implemented
- **Proposed on:** 2026-09-13
- **Scope:** cross-technology
- **Proposal:** Provide a repository-owned PowerShell validator for Skill metadata, local Markdown links, ledger statuses, and .NET templates; do not require Python for routine knowledge-base validation.
- **Evidence:** Existing plan commands referenced a user-specific Python path, while the repository already uses PowerShell for template validation and its first supported ecosystem is .NET.
- **Expected benefit:** Consumers have a stable, versioned validation command without a Python runtime or a machine-specific Codex installation path.
- **Costs and risks:** The validator intentionally covers only repository invariants; it does not replace specialized Codex authoring tools when those are available.
- **Affected standards:** [README.md](README.md), [SKILL.md](SKILL.md), `scripts/Test-StandardsRepository.ps1`.
- **Decision:** Accepted and implemented.
- **Decision rationale:** The validation concerns are repository invariants, and PowerShell is already the repository-owned scripting tool. A machine-specific Python path is unsuitable as a consumer prerequisite. Specialized Codex authoring tools remain optional maintainer tools.
- **Implementation link:** [repository validator](scripts/Test-StandardsRepository.ps1), [validator test](tests/Test-StandardsRepository.Tests.ps1), and [adoption command](README.md).
- **Review again:** not needed.
