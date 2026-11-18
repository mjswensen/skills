---
name: implicit-state-machines
description: Find an app's explicit and implicit state machines, document their states, invariants, and transition tables in one file, then hunt down reachable invalid states or transitions (including through retries and concurrency), and present the confirmed bugs so the user can choose to fix them with regression tests or log them as issues. Use when the user wants to audit app state, find state-related bugs, or map implicit state machines.
---

# implicit-state-machines

Find the app's explicit and implicit state machines and document their states, invariants, and transition tables in one file. Identify invalid states or transitions the code can actually reach, with evidence, including through retries and concurrency. Prioritize confirmed bugs by impact, group related fixes, and present them to the user, who chooses whether to fix them now with regression tests or log them as issues. Keep the document updated either way.

## When to use

Use this skill when the user wants to audit how an app manages state, map its implicit state machines, or find bugs caused by invalid states or transitions.

## Instructions

Follow repository documentation and relevant available skills throughout. If the user scopes the request to a feature, module, or flow, limit the audit to it.

1. **Find the state machines.**
    - Explicit: enums, status/phase fields, reducers, workflow or state-machine libraries, database status columns.
    - Implicit: combinations of booleans and nullable fields (`isLoading` + `error` + `data`), lifecycle flags, records whose meaning depends on which fields are set, multi-step flows (signup, checkout, sync, uploads, jobs), UI modes, connection/session lifecycles, caches, and anything driven by timers, queues, webhooks, or retries.
    - Follow state across boundaries: client, server, database, background jobs, and external services often each hold part of the same machine.
2. **Document them in one file.** Use an existing state-machine document if the repository has one; otherwise create one where the repository keeps documentation (for example, `docs/state-machines.md`). For each machine, record:
    - Where it lives (file and line references) and what owns or mutates it.
    - Its states, including implicit states encoded by field combinations.
    - Its invariants: what must always be true in each state and across states.
    - A transition table: from-state, event or trigger, guard, to-state, side effects, and source location.
3. **Hunt for reachable invalid states and transitions.** Look for:
    - States that violate an invariant or represent impossible field combinations.
    - Transitions missing from the table that the code nonetheless performs, and transitions from states where they should be rejected.
    - Retries and replays: duplicate requests, double submits, at-least-once job or webhook delivery, partial failures between multiple writes, and non-idempotent side effects.
    - Concurrency: races between requests, tabs, devices, workers, or async callbacks; stale reads; out-of-order responses; check-then-act without locks or conditional writes; cancellation and unmount mid-flight.
    - Timeouts, crashes, and restarts that strand state mid-transition.
4. **Confirm with evidence.** Treat a bug as confirmed only when you can show how it is reached: a concrete sequence of events with code references, and ideally a failing test or reproduction. Keep unconfirmed suspicions in a separate list in the document instead of presenting them as bugs.
5. **Prioritize and group.** Rank confirmed bugs by impact, such as data loss or corruption, security or billing errors, user-visible breakage, then cosmetic issues, weighed against likelihood. Group bugs that share a root cause or fix. Record the groups in the document, each with the affected machine, the invalid state or transition, the reproduction sequence, impact, and proposed fix.
6. **Present the list and stop.** Do not start fixing anything yet. Show the user the prioritized groups with a short summary of each (impact, how it is reached, proposed fix), the path to the document, and any unconfirmed suspicions. Ask the user what to do with each group:
    - **Fix now:** implement the fix in this session.
    - **Log as an issue:** create an issue in the repository's issue tracker.
    - **Skip:** leave it recorded in the document only.

    The user may choose different actions for different groups. If no issue tracker is available, say so and offer to keep the issues in the document instead.
7. **Log the chosen issues.** For each group the user wants logged, check for an existing matching issue, then create one issue containing the details from step 5 and a reference to the document.
8. **Fix the chosen groups.** Work through them in priority order. For each:
    - Write a regression test that reproduces the bug and fails before the fix. For retry and concurrency bugs, control ordering deterministically (fake timers, controlled promises, injected delays, or explicit interleavings) rather than relying on timing.
    - Implement the simplest fix that makes the invalid state unrepresentable or the transition rejected, such as replacing boolean combinations with a discriminated union, adding guards, idempotency keys, conditional updates, or transactions.
    - Run the repository's standard checks and fix any failures you introduced.
9. **Keep the document updated.** After each fix, update the affected states, invariants, and transition tables. Mark each group as fixed (with a reference to the commit or test), logged (with a link to the issue), or skipped.
10. **Report a summary.** Include the fixes made with their regression tests, the issues created, and anything left unaddressed.
