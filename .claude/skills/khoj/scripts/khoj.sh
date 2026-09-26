#!/usr/bin/env bash
# Thin CLI over the Khoj HTTP API. See ../SKILL.md.
set -euo pipefail

KHOJ_URL="${KHOJ_URL:-http://localhost:42110}"
KHOJ_URL="${KHOJ_URL%/}"

usage() {
  cat >&2 <<USAGE
usage: khoj.sh health
       khoj.sh search <query> [n] [type]
       khoj.sh chat <question> [conversation_id]
       khoj.sh upload <file>...
       khoj.sh files
USAGE
  exit 2
}

need_key() {
  if [[ -z "${KHOJ_API_KEY:-}" ]]; then
    echo "KHOJ_API_KEY is not set. Create one in the Khoj web app under Settings -> API Keys." >&2
    exit 1
  fi
}

api() { curl -sS --fail-with-body -H "Authorization: Bearer ${KHOJ_API_KEY}" "$@"; }

cmd="${1:-}"; shift || true
case "$cmd" in
  health)
    curl -sS --fail-with-body "${KHOJ_URL}/api/health"; echo ;;
  search)
    need_key; [[ $# -ge 1 ]] || usage
    api -G "${KHOJ_URL}/api/search" \
      --data-urlencode "q=$1" --data-urlencode "n=${2:-5}" --data-urlencode "t=${3:-all}"
    echo ;;
  chat)
    need_key; [[ $# -ge 1 ]] || usage
    body=$(python3 -c 'import json,sys
d={"q":sys.argv[1],"stream":False}
if len(sys.argv)>2 and sys.argv[2]: d["conversation_id"]=sys.argv[2]
print(json.dumps(d))' "$1" "${2:-}")
    api -X POST "${KHOJ_URL}/api/chat?client=claude-code" \
      -H "Content-Type: application/json" --data "$body" --max-time 300
    echo ;;
  upload)
    need_key; [[ $# -ge 1 ]] || usage
    args=()
    for f in "$@"; do args+=(-F "files=@${f}"); done
    api -X PATCH "${KHOJ_URL}/api/content?client=claude-code" "${args[@]}"
    echo ;;
  files)
    need_key
    api "${KHOJ_URL}/api/content/files"; echo ;;
  *) usage ;;
esac
