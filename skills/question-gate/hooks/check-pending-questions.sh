#!/usr/bin/env bash
# question-gate Stop hook.
#
# Blocks a turn from ending while the pending-decision ledger still has open items
# (lines matching "- [ ]"). This is the out-of-context backstop: even when the
# skill's instructions have scrolled out of the model's working context, this hook
# still fires on every Stop and forces unresolved decisions back into view.
#
# Wire it up as a Stop hook in settings.json — see references/hook-setup.md.
#
# Protocol: a Stop hook that emits {"decision":"block","reason":"..."} on stdout
# prevents the turn from ending and shows `reason` back to the model. Emitting
# nothing (exit 0) lets the turn end normally.

set -euo pipefail

# Stop hooks receive a JSON event on stdin. We read it to find the project dir but
# do not require any specific field — fall back to the current directory.
input="$(cat || true)"

project_dir="${CLAUDE_PROJECT_DIR:-}"
if [ -z "$project_dir" ]; then
  # Best-effort: pull cwd from the event payload if present, else use PWD.
  project_dir="$(printf '%s' "$input" | sed -n 's/.*"cwd"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n1)"
  project_dir="${project_dir:-$PWD}"
fi

ledger="$project_dir/.claude/question-gate/pending.md"

# No ledger, or no open items -> nothing to block on.
if [ ! -f "$ledger" ]; then
  exit 0
fi

open_items="$(grep -nE '^[[:space:]]*-[[:space:]]*\[[[:space:]]\]' "$ledger" || true)"

if [ -z "$open_items" ]; then
  exit 0
fi

# Build a human-readable reason and hand the open decisions back to the model.
count="$(printf '%s\n' "$open_items" | grep -c '' || true)"
reason="question-gate: ${count} unresolved decision(s) remain in ${ledger}. Do not end the turn or hand off while decisions that belong to the human are open. For each item below, either ask the human (one at a time, with concrete choices) or confirm they explicitly delegated it, then check it off. Open items:
${open_items}"

# Emit the block decision as JSON. Use a heredoc-free printf to keep quoting sane;
# escape the reason for JSON embedding.
esc_reason="$(printf '%s' "$reason" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')"
printf '{"decision":"block","reason":%s}\n' "$esc_reason"
exit 0
