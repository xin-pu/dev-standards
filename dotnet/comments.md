# .NET Comments and XML Documentation

## Required

- Document public contracts when callers need semantics not conveyed by the
  signature: ownership, nullability assumptions, units, ranges, threading,
  ordering, side effects, errors, or lifecycle.
- Keep XML documentation synchronized with the declared contract; remove it
  when it becomes false.
- Do not put credentials, private endpoints, customer data, or operational
  secrets in comments or XML documentation.
- Format narrative XML documentation (`<summary>` and `<remarks>`) with tags on
  dedicated lines and content indented by four spaces. Use this form even for a
  one-line summary:

  ```csharp
  /// <summary>
  ///     Discovers and opens simulated I2C adapter endpoints.
  /// </summary>
  ```
- Keep a `<param>`, `<returns>`, or `<exception>` entry that fits one readable
  line on that single line, with its content directly after the opening tag:

  ```csharp
  /// <param name="endpoint">Adapter endpoint to open.</param>
  ```
- When such an entry must wrap, indent every continuation line by four spaces.
  Opening and closing tags may then share the first and last text lines (the
  compact form) or occupy dedicated lines (the block form); both are conforming,
  and existing entries keep the form they were authored in:

  ```csharp
  /// <param name="timeout">Overall open timeout; discovery retries below this
  ///     budget until the deadline expires.</param>
  /// <param name="retries">
  ///     Maximum retry count under the same budget; zero disables retries
  ///     entirely.
  /// </param>
  ```
- Wrap longer XML documentation text across multiple lines at a readable width;
  every continuation line keeps the same four-space content indentation.
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

Pulse's standard block style is the normative baseline for narrative
documentation (`<summary>` and `<remarks>`): XML tags on their own lines with
four spaces before non-empty content. It permits wrapped content without
changing that indentation.
