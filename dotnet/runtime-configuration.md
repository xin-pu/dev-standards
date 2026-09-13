# .NET Runtime and Configuration Policy

## Required

- Keep configuration outside compiled code and distinguish safe example values
  from deployment secrets. Validate required configuration at startup or at
  the boundary where it first becomes necessary.
- Bind related settings to typed Options classes and validate ranges, required
  values, and cross-field invariants.
- Accept and propagate `CancellationToken` through asynchronous operations that
  can wait on I/O, hardware, processes, or external services.
- Give external calls explicit timeouts. Retries must be bounded, selective,
  observable, and safe for the operation's idempotency semantics.
- Dispose streams, connections, subscriptions, cancellation sources, and
  hardware handles at the component that owns their lifecycle.

## Preferred

- Layer configuration in this order: versioned defaults, environment-specific
  deployment values, then secret injection. Document all keys and their safe
  defaults near the owning Options type.
- Make retry/backoff and concurrency limits configurable when operating
  conditions differ across benches, services, or deployments.
- Separate transient transport errors from permanent validation or contract
  errors so callers do not retry known-invalid work.

## Observed: Pulse baseline

Pulse integrates device drivers, MES-style systems, messaging, plugins, WPF,
and web hosts. Timeout, cancellation, ownership, and configuration validation
are therefore cross-cutting contract concerns rather than host-only details.
