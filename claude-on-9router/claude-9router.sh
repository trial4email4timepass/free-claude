#!/usr/bin/env bash
# Launch Claude Code through a running 9Router gateway (github.com/decolua/9router).
# 9Router serves the Anthropic Messages API at /v1/messages and routes each request
# to whichever provider you connected in its dashboard (Kiro, OpenCode Free, ...).
# Usage: NINEROUTER_KEY=sk-... ./claude-9router.sh [claude args...]
#   Pick a model:  NINEROUTER_MODEL=kr/glm-5 ./claude-9router.sh
#   Remote/VPS:    NINEROUTER_URL=https://my-router.example.com ./claude-9router.sh
set -euo pipefail

: "${NINEROUTER_KEY:?set NINEROUTER_KEY (9Router dashboard -> Keys)}"
URL="${NINEROUTER_URL:-http://localhost:20128}"
MODEL="${NINEROUTER_MODEL:-kr/claude-sonnet-4.5}"
FAST_MODEL="${NINEROUTER_FAST_MODEL:-kr/claude-haiku-4.5}"

if ! curl -fsS -m 5 "$URL/api/health" >/dev/null; then
  echo "9Router is not answering at $URL. Start it with: 9router -n -H 127.0.0.1" >&2
  exit 1
fi

export ANTHROPIC_BASE_URL="$URL"
export ANTHROPIC_AUTH_TOKEN="$NINEROUTER_KEY"
export ANTHROPIC_API_KEY=""
export ANTHROPIC_MODEL="$MODEL"
export ANTHROPIC_DEFAULT_OPUS_MODEL="$MODEL"
export ANTHROPIC_DEFAULT_SONNET_MODEL="$MODEL"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="$FAST_MODEL"
export CLAUDE_CODE_SUBAGENT_MODEL="$MODEL"
# Skip telemetry/update traffic that would otherwise go to Anthropic.
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
exec claude "$@"
