---
name: cleanup
description: Closing pass over a finished change — collect the leftovers other skills marked for removal (tagged debug logs, throwaway harnesses, verification scaffolding), strip narrating comments and issue references, delete unrequested helpers and dead code, check the diff shape, and re-verify. Use before opening a PR/MR, when the user says "clean this up", "tidy the diff", or when a task is otherwise done.
---

# Closing cleanup pass

Tighten a finished change into a minimal, convention-clean diff. Read the active repo's
`CLAUDE.md` / `AGENTS.md` first: its comment and style rules win over anything here. Repo
layout, the standing PR rules and the test commands are in `~/.agents/context/r2.md`.

**This is the closing pass.** Do not run it while a debugging loop, harness or prototype is
still in use, because step 2 deletes exactly those things.

## Steps

1. **Get the full picture.** Staged, unstaged, *and* untracked, because scaffolding,
   screenshots and harness scripts are usually untracked and invisible to `git diff`:
   ```sh
   git diff
   git diff --cached
   git status --porcelain
   ```

2. **Collect the marked leftovers.** Other skills deliberately tag their debris for this pass
   and hand it over. Sweep each:
   - **Tagged instrumentation.** `diagnosing-bugs` prefixes every debug log it adds, e.g.
     `[DEBUG-a4f2]`. Grep the prefix across the repo and delete every hit. Untagged logging
     that predates the change stays.
     ```sh
     grep -rn '\[DEBUG-' --exclude-dir=.git .
     ```
   - **Throwaway harnesses and prototypes.** Scratch scripts, one-off `main.go`/`bin` probes,
     replay drivers, single-file HTML prototypes. Delete them, or move them somewhere clearly
     marked as throwaway if they are worth keeping. They never ship inside the change.
   - **Verification scaffolding.** Local config files, seed rows, static dirs or fixtures
     created only to make something start, which `create-verification-skill` marks as
     scaffolding. Remove them unless the generated verify skill owns them.

3. **Audit every added comment line.** Reading the diff is not enough; list them:
   ```sh
   git diff origin/main...HEAD | grep -nE '^\+\s*(//|///|//!|#|--|/\*|\*)' | grep -vE '^\S+:\+\s*(#!|#\[|--\s*$)'
   ```
   Delete every hit that narrates or summarizes what the code does, is a section banner, or
   references an issue, thread or PR (`R2C-XXX`, `ENG-XXX`, `PLAT-XXX`). Keep only comments
   that state a constraint the code cannot show, and brief doc comments on public items. Re-run
   the command until each survivor is one you can defend in one sentence.

4. **Remove over-engineering introduced by the change.** Anything the task did not ask for:
   - **Go** — single-use nil-guards and deref helpers (`derefTime`), no-op stubs and
     `ErrNotImplemented` sentinels, an interface added for one implementation, unused struct
     fields. Inline helpers referenced once.
   - **Rust** — `dbg!` and stray `eprintln!`, an `unwrap()`/`expect()` added for expedience
     where a real error path exists, `#[allow(dead_code)]` masking a leftover, unused `use`.
   - **TypeScript** — `console.log`, an `any` or `as` added to quiet the compiler,
     `@ts-ignore` / `@ts-expect-error`, unused imports, commented-out JSX.

5. **Restore scope discipline.** Leave shared packages (`core/`, `pkg/`, a workspace crate)
   untouched unless changing them was the actual task. Revert incidental dependency,
   toolchain or language-version bumps that were not part of the request, including a stray
   `go.mod` Go-version change or a lockfile churned by an unrelated install.

6. **Check the snapshots.** They are the easiest place for an unintended contract change to
   ride along unnoticed.
   - Read the `.snap` diff as a semantic API change, not as noise. Every added or changed
     snapshot must be one you meant to record.
   - Prune orphans by hand. Nothing calls `snaps.Clean`, so snapshots for deleted or renamed
     tests survive forever once written.
   - Rust: no `.snap.new` files left behind, and every accepted `insta` snapshot is intended.

7. **Check the shape of the diff.** Two standing rules, both answerable from one command:
   ```sh
   git diff --stat
   ```
   - **Never a test-only diff.** If the change touches only tests, fold that coverage into the
     functional change that introduces the behavior. If there is no functional change, this is
     not a PR.
   - **No committed images or captures.** Screenshots and recordings belong in the PR
     description, never in the repo. Remove any `.png`, `.jpg`, `.gif` or `.mp4` the change
     added and keep the file out of the tree for pasting later.

8. **Re-verify against the pre-pass baseline.** Note which checks were green before you
   started deleting, then run the same ones after, so a regression is attributable to this
   pass. Use the repo's real commands: `EARTHLY="True" go test ./...` for Go (package-scoped
   `go test ./<pkg>/...` while iterating), `cargo nextest run` plus the repo's lint script for
   Rust, jest plus `tsc --noEmit` for the admin console. Run the formatter and linter too.

   Green tests do not prove a deletion was safe when nothing covered the removed path. For
   every helper, guard or branch you deleted, check its callers directly.

9. **Report** file by file: what was removed, and separately what you **deliberately kept**
   and why. The second list is the one that stops a reviewer re-litigating a judgment call.
