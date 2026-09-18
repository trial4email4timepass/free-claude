#!/usr/bin/env bash
# SessionStart hook that runs context_mode_doctor.py against this repo and
# surfaces any warnings/failures as additional context, so a session starts
# already aware of context-config issues (stale CLAUDE.md, missing
# .gitignore, oversized always-loaded files, etc.) instead of finding them
# only if someone thinks to run the script by hand.
#
# Silent when the repo is clean (0 warnings, 0 failures) to avoid adding
# needless tokens to every session — the whole point of the doctor script
# is keeping always-loaded context lean.

set -uo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
DOCTOR="${PROJECT_DIR}/context_mode_doctor.py"

if ! command -v python3 >/dev/null 2>&1; then
  exit 0
fi

if [ ! -f "$DOCTOR" ]; then
  exit 0
fi

report="$(python3 "$DOCTOR" "$PROJECT_DIR" 2>&1)"

# Only surface it when there's something to act on.
if printf '%s' "$report" | grep -qE '^0 passed|, 0 warnings, 0 failed$'; then
  exit 0
fi

escape_for_json() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    s="${s//$'\n'/\\n}"
    s="${s//$'\r'/\\r}"
    s="${s//$'\t'/\\t}"
    printf '%s' "$s"
}

escaped="$(escape_for_json "$report")"
context="context-mode doctor found issues worth knowing about this session:\n\n${escaped}\n\nRun \`python3 context_mode_doctor.py .\` for details."

printf '{\n  "hookSpecificOutput": {\n    "hookEventName": "SessionStart",\n    "additionalContext": "%s"\n  }\n}\n' "$context"

exit 0
