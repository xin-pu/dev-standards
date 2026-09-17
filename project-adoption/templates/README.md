# Project Name

One paragraph: purpose, primary users, and the system boundary.

## Quick start

Document prerequisites, restore/build/test commands, and the safe local run
path. Do not put credentials or production connection strings here.

## Documentation

- `docs/standards-reference.md` — adopted knowledge-base revision and deviations
- `docs/design/` — project-specific design decisions for material changes
- `docs/ledger/` — project risks, improvements, and standards deviations
- `docs/adr/` — durable architecture decisions

## Standards

This repository adopts the shared development-standards knowledge base. The
exact revision and approved deviations are recorded in
`docs/standards-reference.md`.

Run `powershell -NoProfile -ExecutionPolicy Bypass -File
scripts/Test-ProjectDocuments.ps1` before merging a material documentation
change. The script checks the adopted revision, local documentation links, ADR
and deviation structure, and that local coding-tool artifacts are untracked.
