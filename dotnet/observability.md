# .NET Errors, Logging, and Observability

## Required

- Throw exceptions for exceptional failures; return an explicit result or
  validation response for expected business outcomes. Do not use exceptions as
  ordinary control flow.
- Preserve the original exception as `InnerException` when translating an
  infrastructure failure at a boundary, and add context without exposing
  secrets.
- Use structured logging. Log stable named fields instead of only interpolated
  prose, and include an operation or correlation identifier at asynchronous or
  cross-process boundaries.
- Log failures once at the boundary responsible for handling or reporting
  them; do not repeatedly log and rethrow the same exception through every
  layer.
- Never log credentials, tokens, complete connection strings, private customer
  data, or unredacted device payloads.

## Preferred

- Use `Trace`/`Debug` for diagnostics, `Information` for significant normal
  operations, `Warning` for recoverable abnormal conditions, and `Error` for
  failed operations that require attention.
- Define domain error codes for caller-visible failures where UI, API, plugin,
  or equipment integrations need a stable contract.
- For test and hardware workflows, include non-sensitive identifiers such as
  operation ID, bench, device type, test-plan revision, and attempt number.

## Observed: Pulse baseline

Pulse has a domain error-code model and uses Serilog in several host projects.
Its hardware and integration boundaries make correlation and redaction rules
more valuable than generic log-volume targets.
