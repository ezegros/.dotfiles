# Skill mechanics

The skill-specific branch of [`writing-for-agents`](SKILL.md): what changes when the document is a skill — frontmatter, the invocation choice, and router skills. Everything else about writing it is the universal reference in `SKILL.md`.

## Shape and frontmatter

A skill is a directory whose name *is* the skill's name: `~/.agents/skills/<name>/SKILL.md`, with any auxiliary files beside it (a `references/` subdirectory is the usual home for disclosed reference). Frontmatter carries three fields, and no others are needed:

```yaml
---
name: <must equal the directory name>
description: <one line>
disable-model-invocation: true   # only for user-invoked skills
---
```

The `name` mismatching its directory is the one error that silently breaks the skill.

Auxiliary files are reached by an in-body context pointer — a relative link and the condition for reading it. A file nothing points at is a file nothing loads.

Cross-skill calls are written as a sentence, not a path: **Call the Skill tool with "\<name\>".** Give it the branch that makes it fire ("before drafting the edit, call the Skill tool with \"writing-for-agents\""), since a bare pointer with no condition is a pointer that fires at random.

## Invocation

Two choices, trading the two loads:

- A **model-invoked** skill keeps a `description`, so the agent can fire it autonomously and other skills can reach it. The human can still type its name: model-invocation always _includes_ user reach; a description only adds agent discovery, never removes the human's. That description is the skill's top-level context pointer, forced to stay loaded at all times: permanent context load in exchange for discoverability. A model-invoked skill whose content is all reference is also one home for shared reference, since another skill can invoke it. Mechanics: omit `disable-model-invocation`, and write a model-facing description carrying the trigger branches (the pointer-writing rules in `SKILL.md` apply in full).
- A **user-invoked** skill strips the description from the agent's reach: only the human typing `/<name>` can invoke it, and no other skill can. Zero context load, but it spends cognitive load — you are the index that must remember it exists. Mechanics: set `disable-model-invocation: true`; the `description` becomes human-facing, a one-line summary with the trigger list stripped.

Pick model-invocation only when the agent must reach the skill on its own, or another skill must. If it only ever fires by hand, make it user-invoked and pay no context load.

Shared reference that two user-invoked skills both need can live in neither: with no descriptions, neither can fire the other. Push it to a plain file outside the skill system — external reference any skill can point at, the way the repo conventions in `~/.agents/context/r2.md` are pointed at rather than restated.

## Splitting by invocation

The invocation cut of splitting (the sequence cut lives in `SKILL.md`): split off a model-invoked skill when you have a distinct leading word that should trigger it on its own — a trigger word you actually use in your prompts — or when another skill must reach it. You pay context load for the new always-loaded description, so that independent reach has to be worth it.

## Router skills

When user-invoked skills multiply past what you can remember, that piled-up cognitive load is cured by a **router skill**: one user-invoked skill that names the others and when to reach for each, so the human has one skill to remember instead of many. It can only hint, never fire them: user-invoked skills have no description, so nothing but the human can reach them.
