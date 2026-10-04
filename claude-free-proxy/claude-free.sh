#!/usr/bin/env bash
# Start the LiteLLM proxy (if not running) and launch Claude Code against it.
# Usage: GROQ_API_KEY=gsk_... [GEMINI_API_KEY=...] ./claude-free.sh [claude args...]
# With NVIDIA_NIM_API_KEY set, NVIDIA NIM becomes the main provider and Groq
# (if set) and Gemini (if set) become fallbacks.
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"   # config lives here; claude runs in the caller's cwd

if [[ -n "${NVIDIA_NIM_API_KEY:-}" ]]; then
  CONFIG="$DIR/litellm-nim.yaml"
  PICKER="$DIR/picker-nim.json"
  echo "provider: NVIDIA NIM (fallbacks: Groq, Gemini if their keys are set)" >&2
else
  : "${GROQ_API_KEY:?set GROQ_API_KEY (console.groq.com/keys) or NVIDIA_NIM_API_KEY}"
  CONFIG="$DIR/litellm.yaml"
  PICKER="$DIR/picker-groq.json"
  echo "provider: Groq (set NVIDIA_NIM_API_KEY to switch to NVIDIA NIM)" >&2
fi
if [[ -z "${GEMINI_API_KEY:-}" ]]; then
  echo "note: GEMINI_API_KEY not set; no Gemini fallback (key: aistudio.google.com/app/apikey)" >&2
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

STATE="${KEY_FILE%/*}/config"
mkdir -p "${STATE%/*}"
if curl -sf "http://localhost:$PORT/health/liveliness" >/dev/null \
   && [[ "$(cat "$STATE" 2>/dev/null)" != "$CONFIG" ]]; then
  echo "restarting proxy with ${CONFIG##*/}" >&2
  pkill -f "[l]itellm --config $DIR/litellm" || true
  sleep 2
fi

if ! curl -sf "http://localhost:$PORT/health/liveliness" >/dev/null; then
  command -v litellm >/dev/null || { echo "install: pip install 'litellm[proxy]'" >&2; exit 1; }
  echo "$CONFIG" >"$STATE"
  litellm --config "$CONFIG" --host 127.0.0.1 --port "$PORT" >"$DIR/litellm.log" 2>&1 &
  for _ in $(seq 1 60); do
    curl -sf "http://localhost:$PORT/health/liveliness" >/dev/null && break
    sleep 1
  done
  curl -sf "http://localhost:$PORT/health/liveliness" >/dev/null \
    || { echo "proxy failed to start; see $DIR/litellm.log" >&2; exit 1; }
fi

export ANTHROPIC_BASE_URL="http://localhost:$PORT"
export ANTHROPIC_AUTH_TOKEN="$LITELLM_MASTER_KEY"
export ANTHROPIC_API_KEY=""
export ANTHROPIC_MODEL="${CLAUDE_FREE_MODEL:-free-main}"   # starting model; switch in /model with s
export ANTHROPIC_DEFAULT_OPUS_MODEL="free-main"
export ANTHROPIC_DEFAULT_SONNET_MODEL="free-main"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="free-fast"
# --settings adds the free models to the /model menu (arrows + Enter to switch)
exec claude --settings "$PICKER" "$@"
