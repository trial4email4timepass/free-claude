#!/usr/bin/env bash
# Launch Claude Code against OpenRouter's free models. OpenRouter speaks the
# Anthropic Messages API natively, so no local proxy is needed.
# Usage: OPENROUTER_API_KEY=sk-or-v1-... ./claude-openrouter.sh [claude args...]
#   Pick a model:  OPENROUTER_MODEL=poolside/laguna-s-2.1:free ./claude-openrouter.sh
set -euo pipefail

: "${OPENROUTER_API_KEY:?set OPENROUTER_API_KEY (get one at openrouter.ai/keys)}"
MODEL="${OPENROUTER_MODEL:-nvidia/nemotron-3-ultra-550b-a55b:free}"
FAST_MODEL="${OPENROUTER_FAST_MODEL:-$MODEL}"

export ANTHROPIC_BASE_URL="https://openrouter.ai/api"
export ANTHROPIC_AUTH_TOKEN="$OPENROUTER_API_KEY"
export ANTHROPIC_API_KEY=""
export ANTHROPIC_MODEL="$MODEL"
export ANTHROPIC_DEFAULT_OPUS_MODEL="$MODEL"
export ANTHROPIC_DEFAULT_SONNET_MODEL="$MODEL"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="$FAST_MODEL"
export CLAUDE_CODE_SUBAGENT_MODEL="$MODEL"
# Skip telemetry/update traffic that would otherwise go to Anthropic.
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
exec claude "$@"
