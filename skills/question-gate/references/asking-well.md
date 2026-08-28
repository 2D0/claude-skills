# Asking well — worked examples

Concrete before/after for the three asking rules in `SKILL.md`. The shape matters:
a well-formed question lets the human decide from your message alone.

## Rule 1 — One decision per question

**Bad (batched):**
> Should I use Postgres or SQLite, and do you want auth in this milestone, and
> should the API be REST or GraphQL?

Three decisions in one breath. The human has to untangle them and will likely answer
one and forget the others.

**Good (sequential):**
> Ask about the datastore first. Once that's answered, the auth question can be framed
> in terms of the datastore that was chosen, and the API-style question after that.

## Rule 2 — Always give choices

**Bad (open-ended):**
> How do you want to handle image uploads?

This makes the user design the feature.

**Good (enumerated, recommendation first):**
> - **Direct-to-blob upload (recommended)** — client uploads straight to storage via a
>   signed URL; the API only issues the URL. Cheapest, scales, no large bodies through
>   the function.
> - **Through the API** — client posts the file to the function, which forwards it.
>   Simpler to reason about; bounded by request-body limits.

## Rule 3 — Explain before you offer (with a code snippet for UX/DX)

When the decision shapes an interface or developer experience, show the artifact each
option produces so the comparison is concrete.

**Problem:** the export button can either block the UI while the file builds, or build
in the background and notify when ready. This changes the component's contract.

**Option A — synchronous (blocks, simplest):**
```tsx
async function onExport() {
  setBusy(true);
  const blob = await buildReport();   // UI is frozen until this resolves
  download(blob);
  setBusy(false);
}
```

**Option B — background job + toast:**
```tsx
function onExport() {
  const jobId = startReportJob();     // returns immediately
  toast("Building your report…");
  // a subscription resolves the job later and swaps the toast for a download link
}
```

Only after the problem statement and these snippets do the choices get presented. The
user is now comparing two real component contracts, not two adjectives.
