#!/bin/bash
set -uo pipefail

# Persist Graphify (graphifyy CLI + its /graphify Claude Code skill) across
# sessions in this ephemeral environment. Runs on every SessionStart; both
# steps are idempotent so re-running is safe.

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

if ! command -v uv >/dev/null 2>&1; then
  echo "uv not found; skipping graphify install" >&2
  exit 0
fi

uv tool install --upgrade graphifyy -q || uv tool install graphifyy -q || {
  echo "graphifyy install failed; skipping" >&2
  exit 0
}

if command -v graphify >/dev/null 2>&1; then
  graphify install || echo "graphify install (skill registration) failed" >&2
fi

exit 0
