#!/bin/bash
set -uo pipefail

# Persist tools that live outside the repo across sessions in this ephemeral
# environment. Runs on every SessionStart; every step is idempotent so
# re-running is safe, and a failure in one step never blocks the others.

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# Graphify (graphifyy CLI + its /graphify Claude Code skill).
install_graphify() {
  if ! command -v uv >/dev/null 2>&1; then
    echo "uv not found; skipping graphify install" >&2
    return
  fi

  uv tool install --upgrade graphifyy -q || uv tool install graphifyy -q || {
    echo "graphifyy install failed; skipping" >&2
    return
  }

  if command -v graphify >/dev/null 2>&1; then
    graphify install || echo "graphify install (skill registration) failed" >&2
  fi
}

# gstack (garrytan/gstack): clones into ~/.claude/skills/gstack and runs its
# non-interactive setup, which builds the browse binary and links ~50 skills
# (/review, /qa, /ship, /office-hours, ...) into ~/.claude/skills. ~30s cold.
install_gstack() {
  local dir="$HOME/.claude/skills/gstack"

  if ! command -v bun >/dev/null 2>&1; then
    echo "bun not found; skipping gstack install" >&2
    return
  fi

  if [ -e "$HOME/.claude/skills/office-hours" ]; then
    return  # already set up this session
  fi

  if [ ! -d "$dir/.git" ]; then
    git clone -q --single-branch --depth 1 https://github.com/garrytan/gstack.git "$dir" || {
      echo "gstack clone failed; skipping" >&2
      return
    }
  fi

  (cd "$dir" && timeout 300 ./setup -q --no-team --no-prefix \
      --no-plan-tune-hooks --no-timeline-stop-hook </dev/null >/dev/null 2>&1) \
    || echo "gstack setup failed; run ~/.claude/skills/gstack/setup manually" >&2
}

install_graphify
install_gstack

exit 0
