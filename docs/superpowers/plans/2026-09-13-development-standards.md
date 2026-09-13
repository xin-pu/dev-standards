# Development Standards Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a versioned, multi-technology standards repository whose first usable implementation is a .NET standards Skill derived from Pulse.

**Architecture:** Authoritative rules live in versioned Markdown and executable templates. A compact root Skill routes work to a .NET Skill, which then loads only the policy relevant to packages, coding, documentation, testing, or review.

**Tech Stack:** Codex Skills (Markdown/YAML), .NET/MSBuild XML, NuGet configuration XML, PowerShell.

**Spec:** `docs/superpowers/specs/2026-09-13-development-standards-design.md`

## Global Constraints

- .NET is the only implemented technology in this release; other technologies are empty extension points.
- Every rule is marked Required, Preferred, or Observed.
- Package versions are centrally managed; test guidance uses xUnit and Shouldly.
- Source-mapping keys must correspond to configured NuGet sources.
- Pulse is evidence only; do not modify `D:\Code Pulse\pulse`.

---

### Task 1: Create Skill routing

**Files:**

- Create: `SKILL.md`
- Create: `dotnet/SKILL.md`
- Create: `technology/.gitkeep`

**Interfaces:** Root Skill identifies technology and loads the .NET Skill; the .NET Skill routes package, coding, comment, test, and review work to one focused policy document.

- [ ] **Step 1: Write root Skill frontmatter and routing**

Create `SKILL.md` with `name: development-standards`, a discriminating description, multi-technology routing, and a statement that user instructions win.

- [ ] **Step 2: Write .NET Skill frontmatter and focused reference routing**

Create `dotnet/SKILL.md` with `name: dotnet-development-standards`; route package changes to `packages.md`, code/review work to `coding-style.md`, documentation work to `comments.md`, and test work to `testing.md`.

- [ ] **Step 3: Validate Skill metadata**

Run: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/Test-StandardsRepository.ps1`

Expected: valid Skill frontmatter and no scaffold placeholders.

- [ ] **Step 4: Commit**

Run: `git add SKILL.md dotnet/SKILL.md technology/.gitkeep; git commit -m "feat: add development standards skill routing"`

### Task 2: Add .NET policy references

**Files:**

- Create: `dotnet/packages.md`
- Create: `dotnet/coding-style.md`
- Create: `dotnet/comments.md`
- Create: `dotnet/testing.md`

**Interfaces:** Policies provide the rule categories and decisions loaded by `dotnet/SKILL.md`.

- [ ] **Step 1: Define package policy**

Document central package management, version ownership in `Directory.Packages.props`, source-mapping validation, and Pulse packages only as Observed examples.

- [ ] **Step 2: Define coding and comment policies**

Document nullable enablement, boundary contracts, executable formatting, XML documentation scope, and why comments must not restate identifiers.

- [ ] **Step 3: Define testing policy**

Document xUnit Fact/Theory selection, Shouldly assertions, behavior-oriented names, and unit/integration/architecture tiers.

- [ ] **Step 4: Check policy labels and links**

Run: `rg -n 'Required|Preferred|Observed' dotnet; rg -n '\]\([^)]+' SKILL.md dotnet/SKILL.md`

Expected: all policies contain category labels; all Skill links resolve to files.

- [ ] **Step 5: Commit**

Run: `git add dotnet/*.md; git commit -m "docs: add .NET development standards"`

### Task 3: Add reusable configuration templates and validator

**Files:**

- Create: `dotnet/templates/Directory.Packages.props`
- Create: `dotnet/templates/Directory.Build.props`
- Create: `dotnet/templates/.editorconfig`
- Create: `dotnet/templates/nuget.config`
- Create: `dotnet/templates/README.md`
- Create: `scripts/Test-StandardsTemplates.ps1`

**Interfaces:** Templates are opt-in consumer baselines; the validator parses them and proves every NuGet mapping source key is declared.

- [ ] **Step 1: Create central-package, build, and formatting templates**

Use Central Package Management, transitive pinning, nullable enablement, UTF-8, and final newline. Do not add Pulse package names, private feed URLs, or credentials.

- [ ] **Step 2: Create safe NuGet template and adoption guide**

Use nuget.org only and identical source/mapping keys. Explain copy order and safe private-feed additions in the template README.

- [ ] **Step 3: Implement template validation**

Create `scripts/Test-StandardsTemplates.ps1`: load XML templates, collect configured source keys, find mapping keys, and throw an error containing each missing source key.

- [ ] **Step 4: Verify templates**

Run: `powershell -NoProfile -File scripts/Test-StandardsTemplates.ps1`

Expected: exit code 0 and a concise success message.

- [ ] **Step 5: Commit**

Run: `git add dotnet/templates scripts/Test-StandardsTemplates.ps1; git commit -m "feat: add .NET standards templates"`

### Task 4: Document adoption and perform final verification

**Files:**

- Create: `README.md`

**Interfaces:** The README tells a repository owner how to discover the Skill, adopt templates, validate changes, and distinguish Required/Preferred/Observed rules.

- [ ] **Step 1: Write adoption documentation**

Document the repository/Skill relationship, initial .NET scope, template copy process, and validation command.

- [ ] **Step 2: Validate final state**

Run: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/Test-StandardsRepository.ps1; git status --short`

Expected: valid Skills, valid template XML and mappings, and only intended files before the commit.

- [ ] **Step 3: Commit**

Run: `git add README.md; git commit -m "docs: document standards adoption"`
