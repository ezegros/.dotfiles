---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea — one round of numbered questions at a time. Use for "grill me", "/grill-me", "grill this", "poke holes in", "stress-test my thinking", "challenge this design", "what am I missing", or before committing to any non-obvious design.
---

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

Format a round like so:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>

---

❓ **Q2** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (the filesystem, git history, a Linear issue, how a service actually behaves), go and get it: read it yourself, or spawn a subagent with the Agent tool (`subagent_type: "general-purpose"`) when the search is wide. Don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the subagent to report; ask the rest of the frontier now. The _decisions_ are the user's: put each to them and wait.

Facts about this environment — which repo owns which layer, the contract flow between them, how a change is actually verified locally — live in `~/.agents/context/r2.md`. Read the section you need before asking the user something it already answers.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.

Inside a repo there is almost always something worth writing down, so capture decisions as they land rather than at the end: fold each settled decision into the artefact that will outlive the session, the Linear issue or its comments, the repo's `CLAUDE.md`/`AGENTS.md`, or an ADR or design doc. A decision that only exists in this transcript is a decision you will re-litigate. When the agreed shape needs to become trackable work, split it into Linear sub-issues that each declare their blocking edges, following the way the project already splits work.
