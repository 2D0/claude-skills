# Blackbox — flight recorder for `blackbox`

Full decision records for `blackbox`: what the owner actually said, what the
assistant answered and built, why it was built that way, the evidence behind
each choice, and what the assistant got wrong along the way. This is the audit
trail a future session reads instead of re-litigating a rule's origin. The
convention is defined by the `blackbox` skill (2D0/claude-skills); this file is
its marker. To adopt elsewhere, copy this file changing only the item name.

## Conventions

- **One entry per owner-approved unit** (spec confirmed, PR merged, convention
  revised), `YYYY-MM-DD-<slug>.md`, landing in the same commit or PR as the
  change. Not per commit, not per conversation turn.
- **Non-summarized.** Selecting is not summarizing: the entry is drawn from the
  decision trail, not the transcript, and what is kept is kept in full.
- **Index + raw body.** The entry opens with an index — `Refs`, `Decisions`,
  `Reversals`, `Owner caught`, `Declined`, `Evidence`, `Understanding` — whose
  lines point to `§` headings in the body and never replace it. `Reversals:`
  is always present, `none` if so.
- **Language.** Body in English. Every owner input as the verbatim original
  (`>` quote, exactly as typed) followed by a self-contained English rewrite.
  The verbatim is evidence; the rewrite is the assistant's reading at the time.
- **Content-pinned.** `Refs:` names each changed file with its blob SHA
  (`git hash-object <path>`). Survives squash, rebase, any rewrite. Verify with
  `git hash-object`; retrieve with `git log --find-object=<sha>`.
- **Written in the session where the decisions happened.** A long unit gets an
  early draft (`Refs: pending`) finalized at approval.
- **Load only on demand.** Never read this directory during normal work. It
  exists for provenance questions and nothing else.
