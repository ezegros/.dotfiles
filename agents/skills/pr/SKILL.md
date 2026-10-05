---
name: pr
description: Ship the current work as a GitHub pull request — commit, branch off main, rebase onto origin/main resolving conflicts, tests green, audit every added code comment, then open the PR with every section of the repo's template filled in. Use before typing `gh pr create` by hand; when the user says "open a PR" or "/pr"; or when a multi-step plan reaches its ship step.
---

# Open a pull request

Take the current work — wherever it sits: uncommitted, still on `main`, behind origin — to an
open pull request. This skill only runs when explicitly invoked; it never opens a PR on its own,
and it stops at the open PR. Merging is the user's call.

Read the repo's `CLAUDE.md` / `AGENTS.md` first. Its base branch, test command, labels and PR
conventions override every default below.

## Rebase and verify

1. **Commit what's uncommitted.** Read `git status` first: everything belonging to this work
   becomes a commit; a stray scratch file or an unrelated edit stays put and gets named in the
   final report.

2. **Branch, if HEAD is still on `main`.** Name it after the work in this thread —
   `feat/<slug>` or `fix/<slug>`, or the branch name Linear gave the issue if the thread started
   from one.
   ```sh
   git checkout -b <branch>
   ```

3. **Rebase onto the trunk.**
   ```sh
   git fetch origin
   git rebase origin/main
   ```
   `origin/main` unless the branch tracks something else (`git rev-parse --abbrev-ref @{u}`) —
   a few repos ship from `dev`.

   **Conflicts are yours to resolve.** Read both sides, keep what each was doing, then `git add`
   the file and `git rebase --continue`. Where the two changes are genuinely incompatible and
   the thread gives no basis to pick, `git rebase --abort` and ask which side wins: a guessed
   resolution silently drops someone's work and looks like a clean rebase.

4. **Green.** Run `pnpm test` (or whatever the repo runs). A red suite ends the skill here —
   fix it and re-run until green, or hand back what's failing. A PR opened on a red branch
   wastes a reviewer.

5. **Audit every added comment line.** This is the step reviewers most often reject, so do it
   mechanically, never by skimming the diff:
   ```sh
   git diff origin/main...HEAD | grep -nE '^\+\s*(//|///|//!|#|--|/\*|\*)' | grep -vE '^\S+:\+\s*(#!|#\[|--\s*$)'
   ```
   The default is no comment. A comment survives only when it states a hidden constraint or a
   workaround that would surprise a future reader, and says *why*, not *what*. Delete every hit
   that narrates the line below it, restates a name, banners a section, or names this task,
   thread, ticket or PR. Commit the deletions and re-run the command until every survivor is one
   you can defend in a sentence. Paste the surviving lines into the final report so the user sees
   the list, not a claim that it was checked. If the branch also carries debug logs, throwaway
   harnesses or unrequested helpers, call the Skill tool with "cleanup" before pushing.

## Pull request

6. **Push.**
   ```sh
   git push -u origin HEAD
   ```
   Use `--force-with-lease` when the rebase rewrote commits already on origin.

7. **Write the body from the repo's template.** Read `.github/pull_request_template.md` and fill
   in **every** section from the branch's commits and diff (`git log origin/main..HEAD`,
   `git diff origin/main...HEAD --stat`) — no placeholder left standing, no "N/A" where reading
   the diff would have answered it. If this thread references an issue, add `Closes #<N>` so the
   merge closes it.

   Then edit the body for a human reader before it goes anywhere near `gh`:
   - No em dashes, en dashes or parentheses as separators; end the sentence or use a comma.
   - No colon as a mid-sentence connector; colons only before a list or an example.
   - No bold label followed by a colon that restates the line. Bold lead-ins end in a period
     and are followed by new detail.
   - No "not just X, but Y", no forced groups of three, no "serves as" / "boasts" / "features"
     for "is" / "has".
   - No AI vocabulary or metaphor nouns: additionally, crucial, delve, enhance, ensure,
     leverage, robust, seamless, showcase, underscore, surface, primitive, harness, substrate,
     north star, flywheel. Use the plain word.
   - No chatbot phrases ("Let me know if", "I hope this helps") and no closing summary that
     restates the sections above.
   - Active voice with a named actor. Say what the code does and the number you measured,
     not how the change feels. Cut a sentence that could sit unchanged in another repo's PR.
   - Sentence-case headings, straight quotes, no emojis.

   When the user asks for `/unslop` on the body, or the body is longer than a screen, call the
   Skill tool with "unslop" instead of relying on this list.

8. **Title** in the repo's convention — `type(scope): summary` where it uses conventional
   commits. If the repo has a PR-title check (`.github/workflows/pr-title.yml`, a
   semantic-pull-request action), read its regex and conform to it; a title that fails the check
   is a red PR on arrival. On squash-merge repos the title becomes the commit subject on the
   trunk and drives release automation, so `!` means a major version and `hotfix` means an
   expedited deploy — reach for them only when that's the truth.

9. **Create, self-assigned and labeled.** Run `gh label list` and pick the label by change type
   (`feat`→`feature`/`enhancement`, `fix`→`bug`, `chore`/`ci`/`docs` to their own labels where
   the repo has them). A PR without a label is not done: when nothing matches, stop and ask
   which label to use rather than creating the PR unlabeled and moving on.
   ```sh
   gh pr create --base main --assignee @me --label <label> --title "<title>" --body-file <file>
   ```
   `--body-file`, not `--template`: `gh` expands a template only when it can prompt a human, and
   rejects `--template` alongside a body — so write the filled-in body to a file and pass that.
   `--fill` would throw the template away and paste the commit log instead.

10. **Report** the PR URL, its base, the label, the mergeable state from
    `gh pr view <n> --json mergeable,mergeStateStatus` (`CONFLICTING`/`DIRTY` is a real conflict,
    `BEHIND` is only the branch-up-to-date requirement), and the comment lines that survived
    step 5. Finding a conflict yourself beats the user finding it. The branch and PR drive the
    Linear In-Review transition — leave it to the automation, and leave the merge to the user.
