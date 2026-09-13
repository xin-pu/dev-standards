# .NET Comments and XML Documentation

## Required

- Document public contracts when callers need semantics not conveyed by the
  signature: ownership, nullability assumptions, units, ranges, threading,
  ordering, side effects, errors, or lifecycle.
- Keep XML documentation synchronized with the declared contract; remove it
  when it becomes false.
- Do not put credentials, private endpoints, customer data, or operational
  secrets in comments or XML documentation.

## Preferred

- Use `<summary>`, `<param>`, `<returns>`, and `<exception>` only where they
  add caller-relevant information.
- Use `inheritdoc` for a faithful inherited contract; add local remarks only
  for behaviour that differs or requires extra context.
- Explain why and constraints, not an obvious restatement of a type or member
  name. Track temporary work in the issue tracker rather than durable TODO
  comments.

## Observed: Pulse baseline

Pulse commonly gives public interfaces, meaningful data types, and test
fixtures concise XML summaries. Existing documentation is mostly English even
when user-facing test data is bilingual.
