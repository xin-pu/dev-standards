# .NET Testing Policy

## Required

- Write tests for new or changed observable behavior before implementation
  where practical, and run them before merging.
- Use `[Fact]` for one scenario and `[Theory]` with data attributes for the
  same behavior over input variations.
- Name tests as `Member_condition_expected_result` so failures communicate
  behavior without reading the body.
- Choose the narrowest tier that proves the concern: unit for local behavior,
  integration for real component seams, and architecture tests for dependency
  or ownership rules.

## Preferred

- Use Shouldly for readable assertions; use a framework assertion when it is
  clearer or required by the test framework.
- Keep fixtures deterministic and isolate filesystem, database, clock,
  hardware, process, and network dependencies behind explicit seams.
- For a regression, add an assertion that would fail if the defect returned;
  test a public behavior rather than an implementation detail.
- When a test asserts a stable public diagnostic code or method identifier,
  reference the production identifier instead of repeating its string value.
  Keep one-off sample text and values local to the test unless meaningful
  reuse warrants a named fixture or builder.

## Observed: Pulse baseline

Pulse separates unit, integration, and architecture test projects. It uses
xUnit, Shouldly, `Microsoft.NET.Test.Sdk`, behavior-oriented names such as
`Missing_code_is_rejected_without_generating_one`, and architecture tests that
inspect project references and repository boundaries.
