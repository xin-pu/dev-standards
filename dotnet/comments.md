# .NET Comments and XML Documentation

## Required

- Document public contracts when callers need semantics not conveyed by the
  signature: ownership, nullability assumptions, units, ranges, threading,
  ordering, side effects, errors, or lifecycle.
- Keep XML documentation synchronized with the declared contract; remove it
  when it becomes false.
- Do not put credentials, private endpoints, customer data, or operational
  secrets in comments or XML documentation.
- Format XML documentation with tags on dedicated lines and content indented by
  four spaces. Use this form even for a one-line summary:

  ```csharp
  /// <summary>
  ///     Discovers and opens simulated I2C adapter endpoints.
  /// </summary>
  ```
- Wrap longer XML documentation text across multiple lines at a readable width;
  every continuation line keeps the same four-space content indentation. Apply
  the same layout to `<param>`, `<returns>`, `<exception>`, `<remarks>`, and
  other non-empty XML elements.
- Keep a faithful inherited contract as the single-line form
  `/// <inheritdoc />`. Generated files are exempt from XML documentation
  formatting rules.

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

Pulse's standard block style is the normative formatting baseline: XML tags on
their own lines with four spaces before non-empty content. It permits wrapped
content without changing that indentation.
