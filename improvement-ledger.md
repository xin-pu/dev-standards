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

### DS-2026-017 — Clean up merged pull-request branches safely

- **Status:** Implemented
- **Proposed on:** 2026-09-14
- **Scope:** cross-technology
- **Proposal:** Require deletion of local and remote feature branches after a
  pull request is merged, with an ancestry check before deletion and pruning
  when the forge has already removed the remote branch.
- **Evidence:** In OpenCMIS, GitHub had automatically deleted the merged PR
  branch while its local remote-tracking reference persisted. A separate local
  branch contained unmerged work and had to be preserved during cleanup.
- **Expected benefit:** Removes stale branch clutter without discarding work
  that has not reached the target branch.
- **Costs and risks:** Requires a short Git ancestry check and may retain a
  closed-but-unmerged branch until its owner resolves it.
- **Affected standards:** [github-workflow/pull-request-policy.md](github-workflow/pull-request-policy.md).
- **Decision:** Accepted and implemented.
- **Decision rationale:** The rule is technology-agnostic, directly verifiable
  with Git, and distinguishes cleanup from destructive loss of unmerged work.
- **Implementation link:** [branch cleanup policy](github-workflow/pull-request-policy.md#branch-cleanup).
- **Review again:** not needed.

### DS-2026-001 — Record the Shouldly assertion-mapping pitfalls observed during a full xUnit migration

- **Status:** Accepted
- **Proposed on:** 2026-09-13
- **Scope:** .NET
- **Proposal:** Add a mapping/exception table to the testing standard: `bool?` receivers must use `ShouldBe(true/false)` (no `ShouldBeTrue()`); Shouldly is type-strict so byte receivers need explicit `(byte)` casts on int literals; xUnit `Assert.Equal(double, double)` rounds to 5 decimals while Shouldly compares exactly, so port with an explicit tolerance; `Assert.ThrowsAnyAsync<T>` maps to `Should.ThrowAsync<T>` (matches derived types, verified); `Assert.Collection` has no direct equivalent; `Assert.All` maps to `ShouldAllBe`.
- **Evidence:** OpenCMIS migrated 396 `Assert.*` sites; ~30 needed hand conversion and each pitfall above produced a compile error or silent semantic change.
- **Expected benefit:** Future migrations avoid the silent-failure traps; reviewers know which conversions are not mechanical.
- **Costs and risks:** Table duplicates library docs; may age with Shouldly versions.
- **Affected standards:** [dotnet/testing.md](dotnet/testing.md) (Preferred Shouldly bullet).
- **Decision:** Accepted as a version-aware migration appendix.
- **Decision rationale:** The migration evidence is concrete and protects against semantic assertion changes. Keep the mapping separate from the core test policy, pin its Shouldly version context, and compile or test every non-mechanical conversion.
- **Implementation link:** Pending `dotnet/shouldly-migration.md`.
- **Review again:** not needed

### DS-2026-002 — Define a build-time style gate as the CI-free minimum quality gate

- **Status:** Rejected
- **Proposed on:** 2026-09-13
- **Scope:** .NET
- **Proposal:** When a repository cannot run CI (for example, dependencies resolve only from machine-local feeds), require `EnforceCodeStyleInBuild` plus versioned `.editorconfig` severities as the enforced gate, and `dotnet format --verify-no-changes` as the verification command.
- **Evidence:** OpenCMIS has no CI workflows (removed; DevExpress 25.2.4 exists only in machine-local NuGet sources), so build-time enforcement was the only place style rules could fail a change; it caught IDE0130/IDE0161/IDE0300/IDE0290 regressions during the cleanup.
- **Expected benefit:** The Required CI rule gets an auditable local fallback instead of being silently unmet.
- **Costs and risks:** EnforceCodeStyleInBuild slows builds slightly; severities must be curated to stay at zero noise.
- **Affected standards:** [dotnet/toolchain-quality.md](dotnet/toolchain-quality.md).
- **Decision:** Rejected as written; a replacement proposal may define a local verification fallback.
- **Decision rationale:** `EnforceCodeStyleInBuild` exposes IDE diagnostics but warning severity alone does not fail builds. Missing CI must be recorded as an operational constraint, not normalized as a replacement for CI.
- **Implementation link:** Not applicable.
- **Review again:** when a CI-capable repository setup exists

### DS-2026-003 — Make namespace-equals-project-plus-folder the preferred layout with an IDE0130 gate

- **Status:** Implemented
- **Proposed on:** 2026-09-13
- **Scope:** .NET
- **Proposal:** Prefer namespaces that mirror the project name plus the file's subfolder path, enforced by `dotnet_diagnostic.IDE0130.severity = warning`; document the migration mechanics: script namespace rewrites from folder paths, repair using directives from compiler CS0246 output, exempt `Properties/AssemblyInfo.cs`.
- **Evidence:** OpenCMIS inverted its old flat-namespace convention: 39 src files renamed, 77 files needed using updates, and the repo now gates IDE0130 at build time with zero violations.
- **Expected benefit:** One widely understood convention instead of per-project choice; the scripted migration is reusable.
- **Costs and risks:** Big one-time diff; public-API consumers see new namespaces (acceptable pre-distribution); same-project sibling types start needing using directives they did not need before.
- **Affected standards:** [dotnet/coding-style.md](dotnet/coding-style.md).
- **Decision:** Accepted and implemented as a Required rule for new or moved non-generated C# files.
- **Decision rationale:** Pulse's written standard provides a precise project-root-plus-folder model. Existing source that omits intermediate folders is a migration backlog, and public contract migrations remain deliberate compatibility work.
- **Implementation link:** [namespace policy](dotnet/coding-style.md), [build template](dotnet/templates/Directory.Build.props), and [IDE0130 template](dotnet/templates/.editorconfig).
- **Review again:** not needed

### DS-2026-004 — Document collection-expression limits when enforcing IDE0300

- **Status:** Accepted
- **Proposed on:** 2026-09-13
- **Scope:** .NET
- **Proposal:** Alongside the existing collection-expression preference, record two non-convertible shapes: `var x = new byte[] { … }` has no target type (CS9176, needs an explicit type), and `ReadOnlyMemory<T>` parameters cannot be initialized by collection expressions (CS9174); such sites legitimately keep `new T[] { }`.
- **Evidence:** 23 literals in OpenCMIS: 3 needed explicit-type edits and 20 must stay array-creation because the callee takes `ReadOnlyMemory<byte>`.
- **Expected benefit:** Reviewers stop flagging the residual literals; gate adoption isn't blocked by them.
- **Costs and risks:** Trivial; may be fixed by future C# versions.
- **Affected standards:** [dotnet/coding-style.md](dotnet/coding-style.md).
- **Decision:** Accepted as a concise exception rule.
- **Decision rationale:** The durable rule is target-typing based: retain an explicit array when a collection expression cannot compile or obscures the required target type. Do not encode compiler error numbers as permanent policy.
- **Implementation link:** Pending `dotnet/coding-style.md` update.
- **Review again:** next LangVersion upgrade

### DS-2026-005 — Adopt primary constructors (IDE0290) selectively with a fixer-plus-review procedure

- **Status:** Rejected
- **Proposed on:** 2026-09-13
- **Scope:** .NET
- **Proposal:** Standardize on converting trivial `ctor-assigns-get-only-properties` classes to primary constructors via `dotnet format --diagnostics IDE0290` followed by readability review; keep validation-plus-defaulting constructors as conversions (field initializers preserve the throw) or explicit suppressions; note that XML `<param>` docs move onto the type declaration.
- **Evidence:** OpenCMIS converted 9 classes net −52 lines with zero test changes and the IDE0290 gate at warning; the fixer's indentation needed one follow-up format pass.
- **Expected benefit:** Less ceremony for data-carrying classes; consistent decision procedure.
- **Costs and risks:** Primary-constructor capture semantics can surprise with optional parameters or logging; diff noise for reviewers.
- **Affected standards:** [dotnet/coding-style.md](dotnet/coding-style.md) (modern-syntax preference).
- **Decision:** Rejected as a new global standard.
- **Decision rationale:** The existing modern-syntax rule already permits primary constructors when they improve clarity. A fixer-driven conversion procedure would introduce broad diff noise and does not generalize safely across constructor semantics.
- **Implementation link:** Not applicable.
- **Review again:** not needed

### DS-2026-006 — Pair Central Package Management adoption with package source mapping in the same change

- **Status:** Rejected
- **Proposed on:** 2026-09-13
- **Scope:** .NET
- **Proposal:** When enabling CPM in a repository whose NuGet configuration has more than one package source, add `nuget.config` `packageSourceMapping` in the same change, including explicit keys for machine-local vendor feeds.
- **Evidence:** OpenCMIS's CPM switch surfaced NU1507 immediately (nuget.org + a GitHub feed); the fix was a repo-level `nuget.config` mapping `DevExpress.*` to the local folder and `*` to nuget.org.
- **Expected benefit:** No broken/dirty restore on the first CPM build; package origins become explicit.
- **Costs and risks:** Local-folder paths differ per machine; mapping needs maintenance when feeds change.
- **Affected standards:** [dotnet/packages.md](dotnet/packages.md).
- **Decision:** Rejected as redundant; repair the source project configuration separately.
- **Decision rationale:** `dotnet/packages.md` already requires valid source mappings. The cited OpenCMIS configuration uses invalid `packageSourceMapping` element names, so it cannot justify a new rule until repaired and independently validated.
- **Implementation link:** Not applicable.
- **Review again:** not needed

### DS-2026-007 — Require a CS1591 gap audit before promoting the missing-docs warning

- **Status:** Accepted
- **Proposed on:** 2026-09-13
- **Scope:** .NET
- **Proposal:** When turning on `GenerateDocumentationFile`, keep CS1591 off the build until the unique-missing-member count is measured and either closed or triaged; exempt test assemblies unconditionally via `tests/Directory.Build.props`.
- **Evidence:** OpenCMIS measured 356 unique public members lacking docs at gate-on time; wholesale promotion would have buried real diagnostics, so the repo suppressed it with a recorded follow-up and the count is tracked in its verification doc.
- **Expected benefit:** Doc gates land on real numbers, not wishful severity flips; the tests exemption matches the "document where callers need semantics" rule.
- **Costs and risks:** Suppression can persist if no owner follows up; requires the ledger-style expiry note already required by toolchain-quality.
- **Affected standards:** [dotnet/comments.md](dotnet/comments.md).
- **Decision:** Accepted with a scoped test-project exception.
- **Decision rationale:** Measuring and triaging documentation debt before promoting CS1591 avoids a noisy, unmaintainable gate. Test assemblies are normally exempt, except when they are published or consumed as public contracts.
- **Implementation link:** Pending `dotnet/comments.md` update.
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

### DS-2026-011 — Keep coding-tool plans and specifications out of version control

- **Status:** Implemented
- **Proposed on:** 2026-09-13
- **Scope:** cross-technology
- **Proposal:** Treat `docs/superpowers/plans/` and `docs/superpowers/specs/` as local coding-tool artifacts; exclude them from Git and promote only reviewed, durable outcomes to tracked standards or ledger entries.
- **Evidence:** The repository contained tool-generated implementation plans and design specifications that are transient working context rather than normative knowledge.
- **Expected benefit:** The tracked history remains focused on durable standards, decisions, and verifiable maintenance evidence.
- **Costs and risks:** Local artifacts can be lost or differ between workstations; any enduring decision must therefore be explicitly promoted before the local artifact is discarded.
- **Affected standards:** [SKILL.md](SKILL.md), [README.md](README.md), `.gitignore`.
- **Decision:** Accepted and implemented.
- **Decision rationale:** The boundary is explicit, narrow, and preserves durable outcomes through the ledger and standards documents while preventing coding-tool working notes from becoming repository obligations.
- **Implementation link:** [.gitignore](.gitignore), [repository operations rule](SKILL.md), and [local-artifact policy](README.md).
- **Review again:** not needed.

### DS-2026-014 — Separate project documentation from shared development standards

- **Status:** Implemented
- **Proposed on:** 2026-09-13
- **Scope:** cross-technology
- **Proposal:** Give every solution its own tracked README, design documents, project ledger, ADRs, and standards-deviation record while keeping reusable engineering rules exclusively in this knowledge base.
- **Evidence:** Solution repositories need local context and decision history, but copying cross-project rules into them causes version drift and ambiguous ownership.
- **Expected benefit:** Projects retain their own operational history while shared standards have one authoritative, reviewable location.
- **Costs and risks:** Project templates require adoption discipline; stale standards revisions or undocumented deviations weaken the boundary.
- **Affected standards:** [project-adoption Skill](project-adoption/SKILL.md), [documentation policy](project-adoption/documentation.md), and `project-adoption/templates/`.
- **Decision:** Accepted and implemented.
- **Decision rationale:** The split preserves project autonomy without fragmenting reusable policy. Recording the adopted revision and explicit deviations makes the relationship auditable.
- **Implementation link:** [project-adoption Skill](project-adoption/SKILL.md) and [project templates](project-adoption/templates/).
- **Review again:** not needed.

### DS-2026-016 — Standardize the GitHub Issue-to-PR delivery lifecycle

- **Status:** Implemented
- **Proposed on:** 2026-09-13
- **Scope:** cross-technology
- **Proposal:** Require material work to flow through a GitHub Issue, an issue-named branch, verified pull request, protected merge, and linked Issue closure; promote reusable lessons to the shared ledger.
- **Evidence:** Future projects will be developed on GitHub and need one auditable lifecycle from problem intake through merged outcome.
- **Expected benefit:** Work, verification, review, merge, and Issue closure remain linked and searchable across projects.
- **Costs and risks:** GitHub settings and permissions vary by repository; branch protection and automatic Issue closure must be configured during project adoption.
- **Affected standards:** [GitHub workflow Skill](github-workflow/SKILL.md), [Issue lifecycle](github-workflow/issue-lifecycle.md), and [PR policy](github-workflow/pull-request-policy.md).
- **Decision:** Accepted and implemented.
- **Decision rationale:** GitHub provides native Issue, branch, PR, review, status-check, and closing-keyword capabilities. The workflow adds consistent evidence and standards-promotion boundaries without duplicating project-specific process.
- **Implementation link:** [GitHub workflow templates](github-workflow/templates/) and [project adoption routing](project-adoption/SKILL.md).
- **Review again:** not needed.

### DS-2026-009 — Standardize the MVVM folder layout for WPF projects

- **Status:** Deferred
- **Proposed on:** 2026-09-13
- **Scope:** .NET
- **Proposal:** For WPF/MVVM projects, prefer a fixed top-level folder layout — `Views/`, `ViewModels/`, `Models/`, `Services/`, `Converters/`, `Resources/` — with only `App.xaml` at the project root, `MainWindow` under `Views/`, one `Views/<Feature>View.xaml(.cs)` paired with `ViewModels/<Feature>ViewModel.cs` per screen, reusable controls suffixed `Control`, and converters/templates never scattered outside their folders; new files must land in one of the six folders, and feature subfolders only when a folder outgrows flat browsing.
- **Evidence:** OpenCMIS.UI.WPF converged on exactly this layout organically (12 views, 8 view models, all converters centralized); the project recorded it as its written preference alongside the namespace-mirrors-folder gate.
- **Expected benefit:** New WPF files have an obvious home; navigation and pairing are predictable; the folder layout stops drifting per author.
- **Costs and risks:** Layout is convention, not enforced by tooling beyond namespace checks; teams with feature-first (vertical slice) WPF layouts may disagree — the rule is Preferred, not Required.
- **Affected standards:** [dotnet/coding-style.md](dotnet/coding-style.md).
- **Decision:** Deferred pending a WPF-specific standards scope and evidence from more than one maintained project.
- **Decision rationale:** A fixed six-folder layout is a valid local preference but is not a broadly superior architecture to feature-first WPF organization. It should not enter the general .NET standard before a WPF specialization exists.
- **Implementation link:** Not applicable.
- **Review again:** when a `dotnet/wpf` specialization is proposed.

### DS-2026-010 — Do not nest projects in virtual solution folders when IDE0130 is enabled

- **Status:** Rejected
- **Proposed on:** 2026-09-13
- **Scope:** .NET
- **Proposal:** When a repository gates namespace-equals-folder (IDE0130 or equivalent), do not organize projects with Visual Studio solution folders; express architecture via project naming (and, if grouping display is required, physical directories that also participate in the namespace rule). State this where the CI-free style-gate guidance lives so the combination is chosen deliberately.
- **Evidence:** OpenCMIS kept 7 virtual solution folders (01_Shared…06_UI, Tests) purely for solution-explorer display; after enabling IDE0130 at warning, the IDE generated namespace expectations that included the display-only layer names, which the SDK compiler never sees — resolved by removing the solution folders (17 projects unchanged, build/tests still green).
- **Expected benefit:** One source of truth for structure; no false reminders; the sln diff stays reviewable.
- **Costs and risks:** Solution explorer shows a flat list for large solutions; sorting by name replaces manual grouping.
- **Affected standards:** [dotnet/toolchain-quality.md](dotnet/toolchain-quality.md).
- **Decision:** Rejected as written.
- **Decision rationale:** IDE0130 is based on project and physical file paths, not Visual Studio virtual solution folders. Removing solution folders may be a local display preference, but it is not a general namespace-correctness requirement.
- **Implementation link:** Not applicable.
- **Review again:** not needed

### DS-2026-012 — Align IDE namespace-provider settings with the folder-aligned namespace rule

- **Status:** Implemented
- **Proposed on:** 2026-09-13
- **Scope:** .NET
- **Proposal:** When a repository adopts namespace-equals-folder (IDE0130 or equivalent), also clear the IDE layer's per-folder opt-outs: delete `NamespaceFoldersToSkip` entries from `[Project].csproj.DotSettings` (ReSharper's "Namespace Provider = False") and any `#pragma warning disable IDE0130`, because they keep the old expected namespace alive in the editor while the build reports the opposite. State in the repository rule that no folder may be exempted from namespace contribution without a documented exception.
- **Evidence:** OpenCMIS switched to folder-aligned namespaces (39 files renamed, IDE0130 at warning) but six projects still carried `NamespaceFoldersToSkip` entries for `enums/`, `constants/`, `utilities/`, `implementations/`, `interfaces/`, `models/`, `eventargs/`, `attributes/`: the build gate reported zero violations while the IDE kept proposing the previous flat namespaces. The entries and their `<None Remove>` stubs were deleted, so both layers now derive the expectation from the folder tree. An earlier session misattributed the same reminders to virtual solution folders, removed all of them, and that proposal was rejected here as DS-2026-010; the reverting change records the corrected root cause.
- **Expected benefit:** One namespace expectation instead of two contradictory ones, no hidden per-project overrides, and a known first thing to grep for (`NamespaceFoldersToSkip`) when editor and build disagree.
- **Costs and risks:** Removes a legitimate ReSharper escape hatch, so genuine exceptions need an explicit documented form; tool settings file names and storage format may change between analyzer versions.
- **Affected standards:** [dotnet/toolchain-quality.md](dotnet/toolchain-quality.md) (version analyzer configuration, suppression decisions, and editor settings with the repository).
- **Decision:** Accepted and implemented.
- **Decision rationale:** Conflicting namespace expectations create needless
  churn for a solo maintainer and coding tools alike. The rule preserves a
  documented exception path rather than banning legitimate edge cases.
- **Implementation link:** [namespace-provider alignment](dotnet/toolchain-quality.md#namespace-provider-alignment).
- **Review again:** not needed.

### DS-2026-013 — Prove a build-time style gate with a deliberate violation

- **Status:** Implemented
- **Proposed on:** 2026-09-13
- **Scope:** .NET
- **Proposal:** Before relying on a build-time style gate (IDE0130, IDE0300, IDE1006, ...), plant one deliberate violation in a scratch file, confirm the build reports that rule, then delete the file. For IDE0130 also expose `RootNamespace` and `ProjectDir` through `CompilerVisibleProperty`, as the rule's documentation requires for command-line builds, so the gate does not depend on implicit SDK behavior. Build the solution after editing solution or project structure, not just the touched project.
- **Evidence:** OpenCMIS documented its namespace gate as build-time enforced but had never proven it; a probe file under `Enums/` declaring the parent namespace produced `warning IDE0130: ... should be OpenCMIS.Shared.Enums` on SDK 10 both before and after the properties were added (so the properties are robustness, not a fix), while a clean solution-wide rebuild reports zero. In the same session MSBuild rejected a hand-written `NestedProjects` entry whose left-hand GUID lacked braces (`MSB5023`), which only surfaced because the whole solution was built after the edit.
- **Expected benefit:** Distinguishes a working gate from a decorative one; the probe output also names the expected namespace, which doubles as a migration aid; structure edits are proven loadable by the build rather than by inspection.
- **Costs and risks:** A few minutes per rule, and a leftover probe is itself a violation, so it must be deleted in the same step.
- **Affected standards:** [dotnet/toolchain-quality.md](dotnet/toolchain-quality.md); complements DS-2026-002.
- **Decision:** Accepted and implemented as a preferred adoption practice.
- **Decision rationale:** A deliberate probe is strong evidence when a gate is
  introduced or changed, but requiring it for every personal change would add
  ceremony without comparable benefit. The template also exposes the two
  compiler-visible properties needed by command-line `IDE0130` implementations.
- **Implementation link:** [gate proof guidance](dotnet/toolchain-quality.md#gate-proof) and [build template](dotnet/templates/Directory.Build.props).
- **Review again:** not needed.

### DS-2026-015 — Validate adopted project documentation with a repository script

- **Status:** Implemented
- **Proposed on:** 2026-09-13
- **Scope:** cross-technology
- **Proposal:** Ship a PowerShell validator with the adoption templates that a project copies alongside the layout: required paths (`README.md`, `docs/standards-reference.md`, `docs/design/`, `docs/ledger/`, `docs/adr/`), the pinned knowledge-base revision and review date, ledger entry fields and statuses, deviation entry fields and resolutions, ADR status/sections, resolving local Markdown links, and that local coding-tool artifacts are not tracked.
- **Evidence:** OpenCMIS wrote `scripts/Test-ProjectDocuments.ps1` while adopting the templates. On its first run it caught two defects that the build, test, and formatting gates cannot see: two README links still pointing at the pre-move design-document path, and the `docs/superpowers/` plans still being tracked. Both were fixed before the adoption commit. The knowledge base already validates its own repository with PowerShell (DS-2026-008) and `project-adoption/templates/` asks projects to run a mapping validator. Related portability detail: `scripts/Test-StandardsRepository.ps1` fails under Windows PowerShell 5.1 because its default parameter value calls `Split-Path -Parent $PSScriptRoot`, and 5.1 does not populate `$PSScriptRoot` during parameter binding; passing `-RepositoryRoot` explicitly works. A shipped validator should use `$PSScriptRoot` in the body only, or require PowerShell 7.
- **Expected benefit:** Adoption compliance becomes checkable rather than aspirational: the layout, the pinned revision, and the entry fields can be verified locally, and the two failure modes found in practice (stale links, re-tracked local artifacts) fail a script instead of relying on review.
- **Costs and risks:** The checker encodes template structure and must be updated when templates change; field checks are label-based, so labels can be present without substance and review is still required; projects with extra documentation directories need explicit exclusions.
- **Affected standards:** [project-adoption/documentation.md](project-adoption/documentation.md), `project-adoption/templates/`.
- **Decision:** Accepted and implemented.
- **Decision rationale:** The check is portable PowerShell, intentionally
  label-based, and catches the structural documentation failures observed in
  practice without replacing human review of the actual decisions.
- **Implementation link:** [project-document validator](project-adoption/templates/scripts/Test-ProjectDocuments.ps1) and [its template test](tests/Test-ProjectDocumentsTemplate.Tests.ps1).
- **Review again:** when a second solution adopts the project-adoption templates.

### DS-2026-018 — Default to one top-level .NET type per source file

- **Status:** Implemented
- **Proposed on:** 2026-09-16
- **Scope:** .NET
- **Proposal:** New or materially touched C# source should declare one non-`partial` top-level `class`, `interface`, `record`, `struct`, or `enum` per file, and the file name should match the type name. Exempt `partial` type slices, WPF XAML code-behind, compilation-unit files (`GlobalUsings.cs`, `AssemblyInfo.cs`), generated/vendor code, and private nested types. Projects with pre-existing aggregate files may retain a reviewed baseline while a verifier prevents new violations.
- **Evidence:** Pulse.Instruments Issue #157 identified 61 violating files and 110 extractable top-level types. The completed low-risk migration normalized Contracts, Drivers, Share.Host, Share.Manager, Share.Scenarios, and tests without changing namespaces or public APIs. It left 77 historic Share DTO/contract declarations as an explicit baseline to avoid an excessively broad behavioral-neutral diff, with `tools/Verify-SourceStructure.ps1` and Pester coverage enforcing that no new violations are introduced. Pulse.Algorithms independently adopted the layout after a readability review of its public calculation contracts.
- **Expected benefit:** Type discovery, code review, rename refactors, ownership, and merge conflict resolution become more predictable while migration remains incremental rather than forcing large mechanical rewrites.
- **Costs and risks:** More files increase navigation overhead; an over-broad rule can fragment intentionally cohesive models. Baselines must remain visible and be reduced only when a related change makes the extraction worthwhile.
- **Affected standards:** [dotnet/coding-style.md](dotnet/coding-style.md) (if accepted); project-local verifier and baseline policy.
- **Decision:** Accepted and implemented.
- **Decision rationale:** Two maintained .NET solutions now provide adoption evidence. Restricting the default to public types preserves discoverability and reviewability without splitting private implementation details that read better together. The entry was renumbered from DS-2026-017 to avoid duplicating the existing branch-cleanup decision identifier.
- **Implementation link:** [public type file-layout rule](dotnet/coding-style.md), Pulse.Instruments [Issue #157](https://github.com/pulse-atlas/pulse.instruments/issues/157), and Pulse.Algorithms adoption work.
- **Review again:** not needed.

### DS-2026-019 — Standardize multiline XML documentation formatting

- **Status:** Implemented
- **Proposed on:** 2026-09-17
- **Scope:** .NET
- **Proposal:** Require XML documentation tags on dedicated lines with four-space-indented content, using the same block form for one-line and wrapped summaries; retain single-line `inheritdoc` and generated-code exemptions.
- **Evidence:** Pulse consistently uses `summary` blocks with a dedicated opening/closing tag and four-space content indentation, but the shared comments standard previously defined content scope without formatting.
- **Expected benefit:** Tool-generated and hand-authored XML documentation has one predictable, readable style while still allowing long descriptions to wrap.
- **Costs and risks:** Existing XML documentation may need format-only edits; the rule intentionally does not prescribe a rigid line width.
- **Affected standards:** [XML documentation policy](dotnet/comments.md).
- **Decision:** Accepted and implemented.
- **Decision rationale:** The format is already proven in Pulse, is readable for both short and long documentation, and removes ambiguity for coding tools without changing documentation semantics.
- **Implementation link:** [XML documentation formatting rule](dotnet/comments.md).
- **Review again:** not needed.

### DS-2026-020 — Use a lightweight GitHub workflow for solo-maintained repositories

- **Status:** Implemented
- **Proposed on:** 2026-09-17
- **Scope:** cross-technology
- **Proposal:** Preserve verification, traceability, self-review, safe branch
  cleanup, and no-secret rules, while treating human approvals, CODEOWNERS,
  branch protection, and hosted CI as preferred safeguards for a personal
  repository. Permit direct default-branch commits only for clearly trivial,
  non-behavioral changes.
- **Evidence:** The initial GitHub workflow correctly described team controls
  but required two-party safeguards that a personal maintainer cannot satisfy
  without artificial process.
- **Expected benefit:** Projects remain auditable and safe without turning
  small personal changes into unnecessary GitHub administration.
- **Costs and risks:** Self-review is weaker than independent review; CI can
  catch environment-specific failures that local verification misses.
- **Affected standards:** [solo-maintainer profile](github-workflow/solo-maintainer.md), [Issue lifecycle](github-workflow/issue-lifecycle.md), and [PR policy](github-workflow/pull-request-policy.md).
- **Decision:** Accepted and implemented.
- **Decision rationale:** The split keeps hard engineering outcomes while
  scaling collaboration controls to the actual number of collaborators.
- **Implementation link:** [solo-maintainer profile](github-workflow/solo-maintainer.md).
- **Review again:** when a repository gains a regular second contributor.
