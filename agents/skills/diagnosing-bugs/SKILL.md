---
name: diagnosing-bugs
description: Diagnosis loop for hard bugs, production incidents, flakes and performance regressions — build a red-capable feedback loop first, trace the failure across every service to where it really originates, state the diagnosis, then lock it down with a regression test and a minimal fix. Use when the user says "diagnose", "debug this", "root cause", "RCA", "why is this failing", or reports something broken, throwing, erroring, 500ing, timing out, intermittent, flaky or slow.
---

# Diagnosing bugs

A discipline for hard bugs. Six phases, each gated. Skip a phase only by saying out loud which one and why.

Read `~/.agents/context/r2.md` for the repos, the contract flow between them, the local-verification realities and the recurring defect classes. The active repo's `CLAUDE.md` / `AGENTS.md` overrides anything there.

The evidence bar for every claim in this skill is *Prove it works* in `~/.agents/context/r2.md` § *Working principles*: a phase is done when you can show the command and its output, not when it feels done.

## Redact

This skill has you show commands, outputs and captured artifacts. **Redact every secret first**: write `<REDACTED>` in its place. JWTs, `client-id` values, signing key ids, Datadog API keys and DB URLs all count. Build loops against env vars so the credential stays in the environment rather than in what you paste. Captured artifacts carry auth headers: quote only the lines that carry the signal.

If the redacted output is not enough to diagnose the bug, say so and ask the user.

## Phase 1: Build a feedback loop

**This is the skill.** Everything else is mechanical. If you have a **tight** pass/fail signal for the bug — one that goes red on _this_ bug — you will find the cause; bisection, hypothesis-testing and instrumentation all just consume it. If you don't have one, no amount of staring at code will save you.

Spend disproportionate effort here. **Be aggressive. Be creative. Refuse to give up.**

**If the symptom comes from production, start with the Datadog MCP** — logs, traces, metrics, LLM Observability — before theorising. It tells you the shape of the failure, the affected service, and often the exact span where it originates. Treat it as *evidence*, not as the loop: it is not agent-runnable against a candidate fix. You still need a red-capable command locally.

### Ways to construct one, in roughly this order

1. **A failing Go or Rust test at the seam that reaches the bug.** `go test -run '^TestX$' ./core/<domain>/...` against the single package is the tightest loop available here — seconds, deterministic, agent-runnable. Widen to `EARTHLY="True" go test ./...` only to confirm you broke nothing else. Rust: `cargo nextest run -p <crate> -E 'test(<name>)'`.
2. **A bare `curl` against a port-forwarded BFF**, with the hand-minted JWT in an env var. When it answers the question it beats a browser every time, and it isolates the HTTP layer from the UI.
3. **`grpcurl` with a `client-id` header** straight at the gen-ai service. This takes the BFF out of the picture and tells you which side of the contract is actually wrong — the single most valuable split in a three-repo slice.
4. **browser-use against the already-logged-in admin Chrome** (call the Skill tool with "browser-use"). Assert on DOM, console and network, not on a screenshot: a screenshot is not a pass/fail signal.
5. **Replay a captured payload.** Save the real gRPC response, SDUI payload or request body to disk and drive the code path in isolation. A `go-snaps` snapshot of the SDUI/form output is a ready-made differential loop — the `.snap` diff *is* the signal.
6. **Throwaway harness.** bufconn for an in-process gRPC server, testcontainers for the DB: the bug's code path behind a single function call, with everything else mocked or absent.
7. **Repeat / property / fuzz loop.** For "sometimes wrong", `go test -run X -count=200 -race` (or `cargo nextest run --retries 0 -j N`) until the failure rate is high enough to debug against.
8. **Bisection harness.** If the bug appeared between two known states (commit, client version, dataset), automate "boot at state X, check, repeat" so you can `git bisect run` it. Mind the squash-merge ancestry trap in `r2.md`: compare content, not ancestry.
9. **Differential loop.** Same input through two states and diff: old `pkg/client` pin vs new, feature flag on vs off, one partner vs another. The version pin between layers is a recurring failure point, so make it a variable you can flip.
10. **HITL bash script.** Last resort. If a human genuinely must click, drive _them_ with `scripts/hitl-loop.template.sh` so the loop is still structured and its output still feeds back to you.

Build the right feedback loop and the bug is 90% fixed.

### Tighten the loop

Treat the loop as a product. Once you have _a_ loop, **tighten** it:

- Faster? (Cache setup, skip unrelated init, narrow to one package or one `-run` pattern.)
- Sharper signal? (Assert on the exact symptom — this field, this status code, this ordering — not "didn't crash", not "200 OK".)
- More deterministic? (Pin time, seed RNG, fix the fixture partner, isolate the DB with testcontainers, freeze the network.)

A 30-second flaky loop is barely better than no loop; a 2-second deterministic one is a debugging superpower.

### Non-deterministic bugs

The goal is not a clean repro but a **higher reproduction rate**. Loop the trigger 100×, run with `-race`, parallelise, add stress, narrow timing windows, inject sleeps at the suspected interleaving. A 50%-flake bug is debuggable; a 1% one is not, so keep raising the rate until it is.

### When you genuinely cannot build a loop

Stop and say so explicitly. List what you tried. Ask the user for (a) access to whatever environment reproduces it, (b) a redacted captured artifact — Datadog trace id, log dump, HAR, request/response pair, screen recording with timestamps — or (c) permission to add temporary instrumentation to a deployed environment. Do **not** proceed to hypothesise without a loop.

### Completion criterion: a tight loop that goes red

Phase 1 is done when the loop is **tight** and **red-capable**: you can name **one command** — a test invocation, a script path, a `curl`, a `grpcurl` — that you have **already run at least once** (show the invocation and its output, redacted), and that is:

- [ ] **Red-capable**: it drives the actual bug code path and asserts the **user's exact symptom**, so it can go red on this bug and green once fixed. Not "runs without erroring"; it must be able to _catch this specific bug_.
- [ ] **Deterministic**: same verdict every run (for flaky bugs, a pinned and high reproduction rate, per above).
- [ ] **Fast**: seconds, not minutes.
- [ ] **Agent-runnable**: you can run it unattended; a human enters the loop only via `scripts/hitl-loop.template.sh`.

If you catch yourself reading code to build a theory before this command exists, **stop: jumping straight to a hypothesis is the exact failure this skill prevents.** No red-capable command, no Phase 2.

## Phase 2: Reproduce + minimise

Run the loop. Watch it go red as the bug appears.

Confirm:

- [ ] The loop produces the failure mode the **user** described, not a different failure that happens to live nearby. Wrong bug, wrong fix.
- [ ] It is reproducible across multiple runs (or, for non-deterministic bugs, at a rate high enough to debug against).
- [ ] You have captured the exact symptom — error message, wrong field, wrong ordering, timing — so later phases can verify the fix addresses *that*.

### Traps that fake a red

Before you believe the red, rule out the local-environment failures that make working code look broken. Each of these has cost real hours here:

- **`partner_id` skip list.** A new BFF route 4xxs until it is added to the skip list in `common/rest/middleware/auth.go`. That is not your bug.
- **Empty local trace and annotation stores.** A feature that reads them renders empty and looks broken when it is fine.
- **SNS is unavailable locally.** Publishes fail in ways production does not.
- **Off-screen Chrome.** Uniformly grey screenshots mean the window is off-screen, not that the app broke. A default-profile Chrome means no logged-in session at all.
- **`key_id` is not `partner_id`.** A mis-minted JWT reads exactly like an auth bug.
- **Stale pin.** The consumer not re-pinned to the released `pkg/client` version reads exactly like a missing field.

If the red is one of these, the bug is in the environment: say so, fix the environment, rebuild the loop, and start Phase 2 again.

### Minimise

Once it's red for the right reason, shrink the repro to the **smallest scenario that still goes red**. Cut inputs, callers, config, data and steps **one at a time**, re-running the loop after each cut, keeping only what is load-bearing.

Why bother: a minimal repro shrinks the hypothesis space in Phase 3 and becomes the clean regression test in Phase 5.

Done when **every remaining element is load-bearing** — removing any one of them turns the loop green.

Do not proceed until you have reproduced **and** minimised.

## Phase 3: Hypothesise

Generate **3–5 ranked hypotheses** before testing any of them. Single-hypothesis generation anchors you on the first plausible idea and it is usually the wrong one.

Each hypothesis must be **falsifiable**: state the prediction it makes.

> Format: "If &lt;X&gt; is the cause, then &lt;changing Y&gt; will make the bug disappear / &lt;changing Z&gt; will make it worse."

If you cannot state the prediction, the hypothesis is a vibe: discard or sharpen it.

Use the recurring defect classes in `r2.md` — session and concurrency races, idempotency and duplicate keys, resource exhaustion, flaky-test causes — as a **prior for generating candidates, never as a conclusion**. Naming the family is not diagnosing the bug.

**Show the ranked list to the user before testing any of them.** They often re-rank it instantly ("we deployed a change to #3 yesterday") or have already ruled one out. Cheap checkpoint, big time saver. Don't block on it; proceed with your own ranking if the user is away.

## Phase 4: Instrument, and trace the chain to its origin

Each probe must map to a specific prediction from Phase 3. **Change one variable at a time.**

Tool preference:

1. **Debugger / REPL inspection** where the environment supports it. One breakpoint beats ten logs.
2. **Targeted logs at the boundaries that distinguish hypotheses** — and here that means the boundaries *between repos*: the gen-ai handler, the `pkg/client` call, the BFF `port.go` seam, the SDUI payload the admin receives.
3. Never "log everything and grep".

**Tag every debug log** with a unique prefix, e.g. `[DEBUG-a4f2]`. Cleanup then becomes a single grep. Untagged logs survive; tagged logs die.

**Trace the real chain across every affected service.** Most features here are one slice through three repos, so the place a failure is *observable* is usually not the place it *originates*: a blank admin table can be a UI renderer, a BFF `domain.go` mapping, a stale client pin, or a gen-ai query. Follow it — Go client → Rust or Go service → BFF → UI — until you can say **why** it happens, not just where. Stopping at the first observable point is how symptom patches get shipped. In production, the Datadog trace is the fastest way to walk that chain.

**Perf branch.** For performance regressions, logs are usually the wrong tool. Establish a baseline measurement first — timing harness, profiler, query plan, Datadog span durations — then bisect. Measure first, fix second.

### Gate: state the diagnosis and pause

Phase 4 ends with a written diagnosis, not with an edit:

- the root cause, in one or two sentences, naming the service and the code path where it originates;
- the evidence that confirmed it (the probe, its output) and which hypotheses it killed;
- the proposed fix approach, and its blast radius across the slice.

**Pause for the user's confirmation before changing any code.** If the fix touches more than the one repo you started in, say so here — call the Skill tool with "blast-radius" if the reach is unclear.

## Phase 5: Regression test, then fix

Write the regression test **before the fix**, but only if there is a **correct seam** for it.

A correct seam is one where the test exercises the **real bug pattern as it occurs at the call site**. If the only available seam is too shallow — a single-caller test when the bug needs two concurrent callers, a unit test that cannot replicate the cross-service chain that triggered it — a test there gives false confidence.

**If no correct seam exists, that itself is the finding.** Say so. The architecture is preventing the bug from being locked down; that is worth a line in the PR and possibly its own ticket.

If a correct seam exists:

1. Turn the minimised repro into a failing test at that seam, **matching the package's existing conventions** — testify suites, `t.Parallel()` and table-driven in Go, testcontainers for integration where that is the norm, bufconn for in-process gRPC, `go-snaps` for SDUI or form output (both feature-flag states, never hand-rolled field assertions), `insta` for Rust, Jest + RTL with a per-file jsdom docblock for admin components. The full idiom is in `r2.md`; for the red → green discipline itself, call the Skill tool with "tdd".
2. Run it and **show it fail for the right reason** — the user's symptom, not a compile error or a missing fixture.
3. Apply the **minimal** fix. Smallest change that addresses the root cause; no opportunistic refactors, no unrequested helpers. For concurrency and duplicate-key bugs, prefer an **idempotent** solution — `ON CONFLICT` upserts, optimistic locking, compare-and-swap — over a coarse lock.
4. Watch the test pass.
5. Re-run the Phase 1 loop against the **original, un-minimised** scenario, and run the surrounding suite plus the repo's linter.

**Never open a PR whose diff is only tests.** The regression test ships with the fix that makes it pass.

## Phase 6: Cleanup and hand-off

Required before declaring done:

- [ ] The original repro no longer reproduces — re-run the Phase 1 loop and show it green.
- [ ] The regression test passes, or the absence of a correct seam is documented.
- [ ] All `[DEBUG-...]` instrumentation is removed (grep the prefix).
- [ ] Throwaway harnesses and prototypes deleted, or moved somewhere clearly marked. Then call the Skill tool with "cleanup" over the touched files.
- [ ] The hypothesis that turned out correct is stated in the commit / PR body, so the next debugger learns something.

Then:

- **Create a Linear tracking ticket** describing the root cause and the fix, using the Linear MCP. **Never set the issue status by hand** — team automation transitions it from the branch and the PR.
- **Offer to hand off** by calling the Skill tool with "pr".
- **For any production action** — deploy, data backfill, manual remediation, flag flip — propose a plan with its safety checks and rollback, and **pause for approval** before doing any of it.
- If the loop you built is worth keeping — a harness the team will want to re-run — call the Skill tool with "create-verification-skill" rather than deleting it.
