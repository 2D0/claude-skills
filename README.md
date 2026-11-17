# claude-skills

> **Moved.** These skills now live, with their history, in the owner's private home repo (`skills/`), together with the rules and experience they work with. This repository is archived and no longer updated.

Personal collection of [Claude Code](https://claude.com/claude-code) skills, versioned here.
Each skill lives under `skills/<name>/`.

## Skills

### [`question-gate`](skills/question-gate/)

Enforces disciplined clarifying questions so decisions that belong to the human are
never silently guessed. Built for a spec-driven workflow: it concentrates questions at
spec-definition time (one decision at a time, always as concrete choices, with the
problem and per-option handling explained before the options), and adds a thin
"drift guard" during implementation — an un-specced decision is treated as a spec gap
and routed back, never resolved in silence. A pending-decision ledger plus an optional
Stop hook provide an out-of-context backstop so the discipline survives long sessions.

### [`blackbox`](skills/blackbox/)

A flight recorder for decisions. One non-summarized record per owner-approved
unit of change — the owner's words verbatim plus an English rewrite, what the
assistant recommended and built, the evidence behind each choice, and what the
assistant got wrong along the way — pinned to the changed files by content
(blob SHA, so it survives squash and rebase) and read only when someone asks
why a rule exists. Adapted from `dd-blackbox` (quickstart-now/agent-skills)
for global use: any repo adopts it by holding a `blackbox/README.md` marker;
the skill offers adoption once when a spec or convention is first edited in a
repo without one.

## Installing a skill at the user level

Symlink the skill into your user skills directory so every project can use it:

```bash
ln -s "$(pwd)/skills/question-gate" ~/.claude/skills/question-gate
ln -s "$(pwd)/skills/blackbox" ~/.claude/skills/blackbox
```

For `question-gate`'s optional enforcement hook, see
[`skills/question-gate/references/hook-setup.md`](skills/question-gate/references/hook-setup.md).
