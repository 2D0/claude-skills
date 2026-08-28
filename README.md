# claude-skills

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

## Installing a skill at the user level

Symlink the skill into your user skills directory so every project can use it:

```bash
ln -s "$(pwd)/skills/question-gate" ~/.claude/skills/question-gate
```

For `question-gate`'s optional enforcement hook, see
[`skills/question-gate/references/hook-setup.md`](skills/question-gate/references/hook-setup.md).
