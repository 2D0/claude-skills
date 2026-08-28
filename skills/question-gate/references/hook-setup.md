# Installing the Stop hook

The `check-pending-questions.sh` hook is the deterministic backstop behind the
pending-decision ledger. It runs every time the model tries to end a turn, reads
`.claude/question-gate/pending.md` in the project, and blocks the turn while any
`- [ ]` item remains open — handing those items back to the model.

## 1. Place the script

Copy the script somewhere stable and make it executable:

```bash
mkdir -p ~/.claude/hooks
cp hooks/check-pending-questions.sh ~/.claude/hooks/check-pending-questions.sh
chmod +x ~/.claude/hooks/check-pending-questions.sh
```

## 2. Register the Stop hook

Add this to `~/.claude/settings.json` (user level, so every project inherits it).
Merge into an existing `hooks` block rather than overwriting it.

```jsonc
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/check-pending-questions.sh"
          }
        ]
      }
    ]
  }
}
```

## 3. How the block is signaled

A `Stop` hook that prints a JSON object with `"decision": "block"` prevents the
turn from ending; the `reason` string is shown back to the model so it knows what
to resolve:

```json
{ "decision": "block", "reason": "question-gate: 2 unresolved decision(s) remain ..." }
```

Printing nothing and exiting `0` lets the turn end normally — which is what the
script does whenever the ledger is missing or has no open items.

## Notes

- The hook resolves the project directory from `CLAUDE_PROJECT_DIR` when present,
  falling back to `cwd` in the event payload, then `PWD`.
- It only ever *blocks*; it never edits the ledger. Checking items off is the
  model's job, done only after a human answers or explicitly delegates.
- If you want the guard off temporarily, remove the Stop entry (or empty the
  ledger). The in-prompt gate in `SKILL.md` still applies.
