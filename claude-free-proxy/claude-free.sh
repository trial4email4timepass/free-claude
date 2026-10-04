#!/usr/bin/env bash
# Start the LiteLLM proxy (if not running) and launch Claude Code against it.
# Usage: GROQ_API_KEY=gsk_... [GEMINI_API_KEY=...] ./claude-free.sh [claude args...]
set -euo pipefail
cd "$(dirname "$0")"

: "${GROQ_API_KEY:?set GROQ_API_KEY (get one at console.groq.com/keys)}"
if [[ -z "${GEMINI_API_KEY:-}" ]]; then
  echo "note: GEMINI_API_KEY not set; requests Groq rejects won't fall back (key: aistudio.google.com/app/apikey)" >&2
fi
PORT="${LITELLM_PORT:-4000}"

# The proxy refuses to start without a master key; generate one once and reuse it.
KEY_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/claude-free/master_key"
if [[ -z "${LITELLM_MASTER_KEY:-}" ]]; then
  if [[ ! -s "$KEY_FILE" ]]; then
    mkdir -p "$(dirname "$KEY_FILE")"
    (umask 077; echo "sk-$(openssl rand -hex 32)" >"$KEY_FILE")
  fi
  LITELLM_MASTER_KEY="$(cat "$KEY_FILE")"
fi
export LITELLM_MASTER_KEY

if ! curl -sf "http://localhost:$PORT/health/liveliness" >/dev/null; then
  command -v litellm >/dev/null || { echo "install: pip install 'litellm[proxy]'" >&2; exit 1; }
  litellm --config litellm.yaml --host 127.0.0.1 --port "$PORT" >litellm.log 2>&1 &
  for _ in $(seq 1 60); do
    curl -sf "http://localhost:$PORT/health/liveliness" >/dev/null && break
    sleep 1
  done
  curl -sf "http://localhost:$PORT/health/liveliness" >/dev/null \
    || { echo "proxy failed to start; see litellm.log" >&2; exit 1; }
fi

export ANTHROPIC_BASE_URL="http://localhost:$PORT"
export ANTHROPIC_AUTH_TOKEN="$LITELLM_MASTER_KEY"
export ANTHROPIC_API_KEY=""
export ANTHROPIC_MODEL="free-main"
export ANTHROPIC_DEFAULT_OPUS_MODEL="free-main"
export ANTHROPIC_DEFAULT_SONNET_MODEL="free-main"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="free-fast"
exec claude "$@"
