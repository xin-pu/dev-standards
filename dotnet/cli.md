# .NET Command-Line and CLI Tool Policy

## Required

- Define and document a stable exit-code contract. `0` means success; each
  non-zero code names a failure class (for example command-line usage, invalid
  or non-contract input, or partial failure). Scripts and CI branch on these
  codes, so a code's meaning must not change across patch versions.
- Separate human output from machine output. Machine-readable output must be
  versioned and stable; human-facing text and layout may change freely. Never
  interleave color, progress, or prompts into the machine channel.
- Write primary data to standard output and diagnostics, progress, and warnings
  to standard error, so a pipeline can consume the data independently of logs.
- Make `--help` and `--version` side-effect free and exit `0`.
- Default to non-interactive operation. Prompt only when standard input is an
  interactive terminal, and never in machine-output mode.
- Keep command actions testable without a console: inject `TextReader` and
  `TextWriter` (or an equivalent environment abstraction) instead of reading or
  writing the static `Console` from command logic.
- Accept cancellation for long-running work through a `CancellationToken`
  (Ctrl+C, SIGINT/SIGTERM), and do not write credentials, tokens, complete
  connection strings, or unredacted device payloads to output or logs.
- Format machine-readable numbers, dates, and identifiers with the invariant
  culture so output is stable across workstations and CI agents.
- Apply `packages.md` and `security-dependency.md` to every added dependency:
  central version management, license and maintenance review, vulnerability
  audit, and a recorded reason for any boundary-defining package.

## Preferred

- Use `System.CommandLine` for argument parsing, subcommands, validation, and
  generated help instead of hand-rolled parsing once the tool exceeds a trivial
  fixed command set. It is the maintained, stable Microsoft parser.
- Use `Spectre.Console` for human-facing tables, progress, prompts, and color.
  Keep it off the machine-output path: when output is redirected or
  non-interactive, emit plain stable text or JSON instead.
- Keep the tool thin. Parsing, mapping, and presentation live in the executable;
  calculation, validation, and domain contracts live in referenced libraries.
- Provide `-` for standard input and an explicit output path for standard output
  where the tool reads or writes files, so it composes in pipelines.
- Make machine output independent of the terminal: emit the versioned machine
  format by default when output is redirected, and let interactive use opt into
  human output rather than making the contract depend on a TTY.
- Publish the tool as a .NET tool with a stable `PackAsTool` command name and an
  explicit `RollForward` policy, and state the supported runtime.
- Cover the exit-code contract, machine output, and representative failures with
  tests. Use snapshot testing only after the license review required by
  `security-dependency.md`.

## Observed: OpenTest.Algorithms CLI baseline

The OpenTest.Algorithms CLI exposes a versioned JSON request/result contract,
injects input and output streams, and returns documented exit codes (`0`
success, `1` unexpected failure, `2` usage error, `3` contract error, `4`
algorithm error, `5` comparison difference). Its first release used only
framework `System.Text.Json` and hand-rolled parsing; as the command surface
grows it adopts `System.CommandLine` for parsing and `Spectre.Console` for human
rendering. This is evidence, not a mandate for every CLI.

## Review checklist

Confirm the exit-code contract is documented; data and diagnostics use separate
streams; machine output is versioned and invariant-culture; `--help` and
`--version` are side-effect free; interactive prompts are gated on a terminal;
command logic is testable without `Console`; cancellation is wired; packages are
centrally pinned and license reviewed; and the tool publishes under a stable
command name.
