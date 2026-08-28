# Pending-decision ledger — example

This is an illustrative copy of what lives at `.claude/question-gate/pending.md` in a
project. The real file is created and maintained during work; this example just shows
the format the Stop hook reads.

Open items use `- [ ]`; the hook blocks the turn while any remain. Resolved items are
either checked off (`- [x]`, keeping the audit trail) or deleted.

```markdown
- [x] Datastore for milestone 1: Postgres vs SQLite — raised spec #1 R2 — answered: Postgres
- [ ] course.json schema fields beyond id/title — raised spec #1 R3 (spec gap)
- [ ] basePath value if repo is renamed — raised implementation, un-specced
```

In this snapshot two items are still open, so the hook would block a turn from ending
and hand both back to be asked (one at a time) or explicitly delegated.
