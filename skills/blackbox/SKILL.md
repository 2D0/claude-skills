---
name: blackbox
description: >-
  Flight recorder for decisions. Use when modifying anything whose directory (or
  repo root) holds blackbox/README.md; when the owner asks to adopt blackbox
  records ("블랙박스 적용", "블랙박스 넣어줘"); when investigating a rule's
  provenance ("이 규칙 왜 있어", "why does this rule exist", "what did the owner
  originally ask for"); when the owner says they are approving something they do
  not fully understand; and — once per repo — when you first edit a spec,
  convention, or design document in a repo with no blackbox/ marker, to offer
  adoption (never bootstrap without an explicit yes).
---

# blackbox

## Overview

A blackbox is an item's flight recorder: one non-summarized decision record per
owner-approved unit of change — what the owner actually said (verbatim), what it
meant in context, what the assistant recommended and built, why, the evidence
that drove each choice, and what the assistant got wrong along the way — pinned
to the content it explains and read only on demand. It exists so a future
session audits a rule's origin instead of re-litigating it.

Two things it is not:

- **Not a transcript.** Selecting is not summarizing. The entry is written from
  the *decision trail*, not the chat log: teaching, analogies, and detours that
  helped the owner understand but changed no decision are left out. What is
  kept is kept in full.
- **Not a diary about the owner.** It records what was said and decided, not who
  the owner is. Working-style observations belong in the assistant's memory,
  never here.

## Does this item have a blackbox?

- **`blackbox/README.md` sits next to the item (or at the repo root)** → the
  convention applies. Read that README AND the most recent entry before writing
  yours — the schema comes from them, never from your head.
- **No marker, and the owner asks to adopt one** → bootstrap: copy
  `blackbox/README.md` from *this skill's directory* into the item, changing
  nothing but the item name, then record the adoption itself as the first entry.
- **No marker, and you are about to edit a spec / convention / design document
  for the first time this session** → check for the marker. If absent, **offer
  adoption once**, in one sentence, then continue the owner's task. Adoption is
  the owner's call; if they decline, note it in memory so the repo is not asked
  again.

The unit of adoption is the directory holding the marker — a skill, a package,
or a whole repo. Any repo, any merge method.

## Unit and timing

- **One entry per owner-approved unit**: a spec confirmed, a PR merged, a
  convention revised. Not per commit, not per conversation turn. A unit that
  produced several commits gets one entry.
- **Written in the session where the decisions happened.** The raw exchange
  lives only in the current context; once the session ends, only summaries
  survive and verbatim quotes are gone. If a unit runs long or spans sessions,
  **save a draft early** — `Refs: pending`, owner quotes and the index filled
  in — and finalize (pin blobs, complete the body) at approval. A draft beats a
  reconstructed memory.

## The recipe (per owner-approved unit)

1. **Make the change.**
2. **Pin the results by content.** For each changed file, `git hash-object
   <path>` on the working tree. Blob SHAs are content-addressed — the same bytes
   hash the same forever, so the pin survives squash, rebase, and any history
   rewrite, and it exists before any commit does.
3. **Write the entry** `blackbox/YYYY-MM-DD-<slug>.md` in the shape below: an
   **index** that points into the body, then the **raw body**.
4. **Land the entry with the change** — same commit or same PR, merged however
   the repo normally merges.

Verify a pin: `git hash-object <path>` and compare. Retrieve a pinned state:
`git log --find-object=<sha>` or the GitHub blobs API.

Reading rule: never load `blackbox/` during normal work on the item. Read it
only for provenance questions.

## Entry shape

```
# YYYY-MM-DD — <title>

Refs:           <path> @ blob <sha>            (one line per changed file)
Decisions:      <decision> <weight> [→ <new weight>, see §…] · …
Reversals:      §… · §…   (or: none)
Owner caught:   §… · …    (or: none)
Declined:       §… · …    (or: none)
Evidence:       <command / number / link> · …
Understanding:  §…        (or: n/a)
---
<raw body, with § headings the index points to>
```

**Index lines point into the body; they never replace it.**

- **Decisions** — every decision the unit contains, with the weight the
  assistant assigned when asking (🔴 must decide now · 🟡 decide, revisable ·
  🟢 take the recommendation). If a weight was later changed, say so and point
  to why. Over time this line is how the owner audits their own deliberation
  against the weight the decision deserved.
- **Reversals** — anything the assistant asserted and later withdrew or
  corrected: a wrong claim, a recommendation reversed by measurement, a decision
  it made without asking. `none` is a valid value and must be written
  explicitly.
- **Owner caught** — inconsistencies or flaws the owner spotted (a wrong count,
  a missing item, a structural bug). The owner's audit, not only the
  assistant's.
- **Declined** — options, tool defaults, or external recommendations
  deliberately not taken, with the reason in the body.
- **Evidence** — what was actually looked at when deciding: the command run,
  the numbers it produced, the page or file shown. Record the *reproduction*,
  not the picture — a diagram is regenerated from its command; a screenshot is
  not.
- **Understanding** — when the owner approved while saying they did not fully
  understand, their statement and what must be re-explained later.

## Language

- **Body: English**, regardless of the repo's document language.
- **Owner input: the original verbatim, then an English rewrite.** Verbatim
  first, in a `>` quote, exactly as typed — typos, abbreviations, `ㅇ` and all.
  Then the rewrite: complete in content, natural in form, self-contained (a
  reader with no other context understands it). The verbatim is the evidence —
  a typo that changed a decision can only be found there. The rewrite is the
  assistant's reading at the time — if the two disagree, the entry has already
  recorded the fault.
- Assistant responses, rationale, and internal processing: English, in full
  form for anything that bears on a decision. `> ㅇ` followed by
  `Owner approved option (a).` is a complete record; do not pad it.

## Hard forms

| Rule | Not this |
|---|---|
| Owner input = verbatim quote **and** English rewrite | Verbatim alone (unreadable without context), rewrite alone (evidence lost), or a one-line summary |
| Index at the top, raw body below, index lines pointing to `§` headings | An index that summarizes instead of pointing; a body with no index; sections filled with one-liners |
| Body drawn from the decision trail | Teaching, analogies, or detours that changed no decision |
| `Reversals:` present, even as `none` | An entry that lists only what went right |
| `Refs:` = per-file blob SHAs (`git hash-object`) | A commit or PR number as the anchor — history rewrites kill those |
| Entry lands in the same commit or PR as the change | A follow-up PR "later" |
| Written in the session where the decisions happened | Reconstructed next session from memory |
| Entry schema from the README and the latest entry | An invented format |

## Red flags

- An entry with no `Refs:` line, or a `Refs:` naming a commit or PR instead of blobs
- An owner input with no `>` verbatim quote, or a quote with no rewrite after it
- No `Reversals:` line at all
- Index lines that read as summaries rather than pointers
- A body that explains concepts to the reader instead of recording what was decided
- A change merged without its entry
- An entry written the session *after* the decisions it records (say so in the entry if unavoidable)

## Provenance

`blackbox/` holds the full decision record for this item — owner inputs
(verbatim + English rewrites), assistant reasoning, evidence, and reversals,
content-pinned per approved change. Read it only when investigating why a rule
exists or what the owner originally asked for. Never load it during normal use.
