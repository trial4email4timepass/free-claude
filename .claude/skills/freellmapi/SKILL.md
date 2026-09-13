---
name: freellmapi
description: Set up and use FreeLLMAPI, a self-hosted OpenAI-compatible router that aggregates free tiers from 34+ LLM providers (Google, Groq, Cerebras, Mistral, OpenRouter, Cloudflare, Cohere, Z.ai, NVIDIA, HuggingFace, and more) behind one `/v1` endpoint, with automatic fallover and per-key rate tracking. Use when the user wants to run Claude Code (or another coding agent) against free-tier model capacity instead of a paid API key, wants to point an OpenAI-compatible client at a local router, or asks about FreeLLMAPI, "free LLM API", or aggregating free provider tiers. Requires Node.js 20+ and the user's own provider API keys — nothing here supplies keys or runs the server automatically.
---

# FreeLLMAPI

`.claude/vendor/freellmapi/` is a complete, unmodified copy of
[tashfeenahmed/freellmapi](https://github.com/tashfeenahmed/freellmapi)
(MIT license, `LICENSE` included) — a local server + dashboard that stacks
free tiers from dozens of LLM providers behind a single OpenAI-compatible
`/v1` API (plus a native Anthropic Messages surface at `/v1/messages`, which
is what lets Claude Code use it directly).

It is a router, not a wrapper: it holds the user's own encrypted provider
keys, decides which upstream model/key serves each request, retries the
next one in the fallback chain on 429/5xx, and tracks per-key usage against
each provider's free-tier caps.

## When to use it

- The user wants to run Claude Code, Codex CLI, Cline, Aider, or another
  OpenAI-compatible coding agent against pooled free-tier model capacity.
- The user wants one unified API key/endpoint instead of juggling
  provider-specific keys and SDKs by hand.
- The user asks about FreeLLMAPI, "free LLM router", or stacking free
  tiers from multiple LLM providers.

## When not to use it

- The user already has a working paid API key and isn't asking to change
  that — don't suggest ripping out a working setup.
- The task needs frontier-model quality/latency guarantees. Free tiers have
  no SLA, rate limits are real, and effective quality dips as providers'
  daily caps get hit later in the day (reset at UTC midnight). See
  `.claude/vendor/freellmapi/docs/en/architecture/00-high-level-index.md#limitations`.

## Running it

This vendors the source only — nothing starts automatically. From
`.claude/vendor/freellmapi/`:

```bash
npm install
npm run dev     # server on :3001, dashboard on :5173, both with HMR
```

Or via Docker (`docker-compose.yml` in the same directory), or the one-line
installer documented in the vendored `README.md`. Full instructions:
`.claude/vendor/freellmapi/docs/en/install/01-install.md`.

Once running, open `http://localhost:3001`, add provider keys on the
**Keys** page, and grab the unified `freellmapi-…` key from the same page.

## Pointing Claude Code at it

```bash
npx freellmapi setup-claude --url http://localhost:3001 --dry-run   # preview the diff
npx freellmapi setup-claude --url http://localhost:3001             # apply it
```

This merges into the user's existing Claude Code configuration and writes a
timestamped backup first — it never clobbers what's already there. For a
credential-free-on-disk alternative, `npx freellmapi launch` injects the
unified key into the child process only, without touching config files.

Note the root-vs-`/v1` distinction: Claude Code expects the server **root**
(`http://localhost:3001`) because it speaks the Anthropic Messages wire
format; most other OpenAI-compatible clients in this ecosystem expect
`http://localhost:3001/v1`. The full per-agent table lives in
`.claude/vendor/freellmapi/docs/en/clients/01-agent-clients.md`.

## Credentials and safety

- All provider keys are the user's own — this skill and the vendored code
  never supply, request, or transmit credentials on the user's behalf.
- Keys are AES-256-GCM encrypted at rest in a local SQLite database;
  decrypted in memory only for the duration of a request.
- The router is local-first and single-user by design: requests go from
  the user's machine straight to the upstream providers they've enabled.
