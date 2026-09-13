# Project Documentation and Standards Adoption

## Required

- Each maintained solution repository tracks a root `README.md`, a `docs/design/`
  directory, a `docs/ledger/` directory, and a `docs/adr/` directory.
- Project documentation records project-specific context: purpose, architecture,
  operational constraints, deployment, migrations, decisions, and local risks.
- The project must name the adopted development-standards repository and commit
  revision in `docs/standards-reference.md` or an equivalent README section.
- A project may not silently diverge from a Required knowledge-base rule. Record
  the affected rule, rationale, risk, owner, approval, and review date in a
  project-level standards-deviation ledger.
- Promote a reusable lesson from a project ledger to the knowledge-base
  improvement ledger; do not duplicate a cross-project rule in every solution.

## Preferred

- Use one design document per material change and one ADR per durable,
  architecture-significant decision.
- Keep project documents concise and link to source code, tests, deployment
  automation, and the knowledge-base rule rather than duplicating their text.
- Review standards references after a major dependency, architecture, platform,
  or release change.

## Local coding-tool artifacts

`docs/superpowers/plans/` and `docs/superpowers/specs/` are local working
artifacts when a repository follows this knowledge base. Do not track them as
formal project records. Promote the durable outcome into `docs/design/`,
`docs/adr/`, `docs/ledger/`, or the shared knowledge base.

## Minimum project layout

```text
README.md
docs/
├── standards-reference.md
├── design/
├── ledger/
└── adr/
```
