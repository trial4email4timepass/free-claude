# Claude Code on 9Router

Runs Claude Code through [9Router](https://github.com/decolua/9router) (MIT), a
local AI gateway on port 20128. It serves the Anthropic Messages API, so Claude
Code talks to it directly, and it falls back across the providers you connect:
subscription, then cheap, then free (Kiro AI, OpenCode Free, ...). It also
compresses `tool_result` content ("RTK") to cut tokens.

Checked against 9Router v0.5.104 (GitHub `master` at `87a74e1`) in October 2026:
the server starts, `/api/health` returns `{"ok":true}`, `/v1/models` lists 824
models, and `/v1/messages` answers (and asks for a key). A full chat needs a
provider connected in the dashboard, which needs a browser login.

## Setup

1. Install and start it, bound to localhost:

   ```bash
   npm install -g 9router
   9router -n -H 127.0.0.1
   ```

   Or from source: `git clone https://github.com/decolua/9router && cd 9router && cp .env.example .env && npm install && PORT=20128 npm run dev`.

2. Open <http://localhost:20128>. Under **Providers**, connect **Kiro AI**
   (free monthly credits: Claude, GLM, MiniMax) or **OpenCode Free** (no login).
   Under **Keys**, copy an API key.

3. Launch Claude Code:

   ```bash
   NINEROUTER_KEY=sk-... ./claude-9router.sh
   ```

Extra arguments go to `claude`. Pick models with `NINEROUTER_MODEL` (default
`kr/claude-sonnet-4.5`) and `NINEROUTER_FAST_MODEL` (default
`kr/claude-haiku-4.5`). List the IDs with `curl -s localhost:20128/v1/models`.
For a remote instance, set `NINEROUTER_URL`, or run `npx 9router connect http://host:20128`,
which writes the Claude Code config for you.

To skip the script, put the same `ANTHROPIC_*` variables under `"env"` in
`~/.claude/settings.json`. Keep the key out of any file you commit.

## Skills

The nine skills from upstream `skills/` are vendored in `.claude/skills/9router*`
(`LICENSE` in each). They call a running 9Router over REST for chat, image, video,
TTS, STT, embeddings, web search and web fetch. Set `NINEROUTER_URL` and
`NINEROUTER_KEY` in your shell first.

## Notes

- 9Router binds `0.0.0.0` by default. Pass `-H 127.0.0.1` unless you mean to
  expose it, and keep **requireApiKey** on.
- It checks for updates and updates itself on start. Pass `--skip-update` to pin a version.
- Requests go to whichever third-party provider 9Router picks, and free tiers may
  log prompts. Don't send code you can't share.
- Routing Claude subscription accounts through a third-party proxy may break
  the provider's terms of service.
