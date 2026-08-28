---
name: question-gate
description: >-
  Enforces disciplined clarifying questions so decisions that belong to the human
  never get silently guessed. Use this whenever you are about to ask the user more
  than one thing, whenever you are about to pick a default under ambiguity, and —
  above all — during spec-driven work: surface open decisions at spec-definition
  time, and if an un-specced decision appears mid-implementation, stop and route it
  back to the spec instead of drifting. Trigger it even when the user did not name
  it — if you feel the pull to "just proceed" past an unresolved decision because
  the context is long or another agent is waiting, that pull is exactly the signal
  to load this skill.
---

# Question Gate

## Why this exists

The failure this skill prevents is **silent drift**: a decision that was the human's
to make gets quietly resolved by the model — usually not out of carelessness, but
because the context has grown long, or an upstream agent is waiting, or the "obvious"
default felt safe enough to skip asking. Under that pressure the cheapest-looking move
is to guess and move on. That is precisely when a decision most needs to surface.

This skill makes asking **cheap, structured, and hard to skip**. It does not turn you
into a nag — most questions concentrate at one point (spec definition). Everywhere
else it does something narrower: it forbids *silent* resolution. You may still be
efficient; you may not be quiet about a choice that wasn't yours.

## The three asking rules

When you do ask, ask well. These three rules are non-negotiable because a badly-formed
question is itself a way of pushing the decision back onto a human who now has to do
extra work to answer it.

### Rule 1 — One decision per question

Never bundle several open decisions into one message. Ask the first, get the answer,
then ask the next. Batched questions force the human to hold several threads at once
and invite half-answers. One at a time keeps each decision crisp and lets each answer
inform the next question.

### Rule 2 — Always give choices

Frame every question as a small set of concrete options (use the `AskUserQuestion`
tool). Open-ended "what do you want here?" prompts offload the design work onto the
user. Doing the work of enumerating 2–4 real options — with a recommendation first —
is how you keep the human *deciding* rather than *authoring*.

### Rule 3 — Explain before you offer

Before the options appear, write a short plain-language message that covers, in order:

1. **What the problem is** — why a decision is even needed here.
2. **What each option actually does** — the concrete handling behind each choice, so
   the labels aren't guesses.
3. **A code snippet, when the decision is about UX or DX** — show the shape of what
   each option produces (config, component, API surface) so the user compares real
   artifacts, not abstractions.

Only after that do you present the choices. The point: a person should be able to
decide from your message alone, without having to ask you what the options mean.

See `references/asking-well.md` for worked before/after examples of these three rules.

## Where the gate fires (spec-driven model)

This skill assumes a spec-driven workflow. Questions are not spread evenly across the
work — they concentrate where the human is the decider, and elsewhere collapse into a
single guard.

**At spec definition — the primary trigger.** When a spec is being written or refined,
enumerate every open decision it still contains and walk them one at a time (Rules
1–3). This is where the bulk of asking belongs, because the spec is the artifact the
human approves.

**During implementation — the thin drift guard.** Do not open new lines of questioning
here. But if you hit a decision the spec does not cover, treat it as a **spec gap, not
a detail to fill in.** An un-specced decision means the spec was incomplete — so stop,
surface it as "the spec doesn't decide X," and loop back to the spec to resolve it.
The one thing you may never do is resolve it silently and keep coding. That silent
resolution is the exact failure this skill exists to stop.

## The pending-decision ledger

Rules and good intentions live in the prompt — and the prompt is what gets buried when
context grows. So the gate also keeps state **outside** the prompt, in a small ledger
file, backed by a Stop hook that refuses to end a turn while the ledger has open items.

Ledger path: `.claude/question-gate/pending.md` (relative to the project root).

Whenever you identify a decision that is the human's to make, **append it to the ledger
before you do anything else** — before implementing, committing, or moving on:

```markdown
- [ ] <one-line decision that needs the human> — raised <context, e.g. spec #1 R3>
```

Resolve an item only when the human has actually answered it, or has explicitly
delegated it to you ("you decide"). To resolve, either check it off (`- [x]`, keeping
the record) or remove the line. Recording an assumption you made **without** asking is
not resolution — if you must proceed on an assumption, the item stays open so the human
sees it.

The Stop hook (below) reads this file. If any `- [ ]` remains when you try to end the
turn, the hook blocks and hands the open items back to you. This is the part that
survives a long context: even if these instructions have scrolled far out of view, the
hook still fires.

## Installing the enforcement hook

The hook is the deterministic backstop for the ledger. Install it once at the user
level so every project inherits it.

1. Copy `hooks/check-pending-questions.sh` somewhere stable (e.g.
   `~/.claude/hooks/check-pending-questions.sh`) and make it executable
   (`chmod +x`).
2. Add the Stop hook to `~/.claude/settings.json` — see
   `references/hook-setup.md` for the exact JSON block and how the script
   signals a block.

If the hook is not installed, the skill still works through the in-prompt gate and
ledger — you just lose the out-of-context backstop. On a hard-enforcement setup, keep
the hook installed.

## What "done" looks like

Before you end a turn or hand off to another agent, the ledger has no open `- [ ]`
items — every decision in it was either answered by the human, explicitly delegated,
or is still open and visibly surfaced (never silently resolved). If you ever notice
yourself about to proceed past an unresolved decision because stopping to ask feels
expensive, that is the signal to add it to the ledger and ask — not to skip it.
