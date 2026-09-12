---
name: perplexity
description: Use Perplexity AI search (via the `perplexity` MCP server, backed by the vendored `helallao/perplexity-ai` client) to answer questions that need current, real-world information — news, prices, releases, docs, or anything past the model's knowledge cutoff. Use when the user asks to "search the web", "look up", "check the latest", or asks a factual question whose answer could have changed recently. Works with no API key (free `auto` mode); set `PERPLEXITY_COOKIES` for `pro`/`reasoning`/`deep research` modes. See `.mcp.json` and `.claude/vendor/perplexity-ai/README.md`.
---

# Perplexity Search (free, keyless)

Gives Claude Code a web-search tool backed by Perplexity, using the
vendored `.claude/vendor/perplexity-ai` client (an unofficial,
reverse-engineered Perplexity API) instead of the official paid
`@perplexity-ai/mcp-server`. No API key is required for basic use.

## When to use it

- The user asks about current events, prices, releases, or anything
  time-sensitive ("what's the latest version of X", "is Y still true").
- A question needs a real-world answer rather than a best-guess from
  training data.
- Local context (code, docs already in the repo) doesn't have the answer —
  check the codebase first; don't reach for web search when the answer is
  already in the project.

## When not to use it

- The answer is stable, well-known, or already available from the
  codebase/CLAUDE.md — searching adds latency for no benefit.
- The task is about code in this repo, not general knowledge.

## Available tools

| Tool | Mode | Description |
|------|------|-------------|
| `perplexity_ask` | `auto` | General-purpose question answering (works with no cookies) |
| `perplexity_search` | `pro` + web sources | Web search |
| `perplexity_reason` | `reasoning` | Step-by-step reasoning through a problem |
| `perplexity_research` | `deep research` | In-depth research on a topic |

`perplexity_ask` runs anonymously with no setup. `perplexity_search`,
`perplexity_reason`, and `perplexity_research` need an authenticated
account — set `PERPLEXITY_COOKIES` (see Setup) or they'll fall back to
auto/limited behavior.

## Setup

Configured in this repo's `.mcp.json` under the `perplexity` server,
which runs `uv run --project .claude/vendor/perplexity-ai --extra mcp
perplexity-mcp`. `uv` fetches the server's own dependencies
(`mcp`, `curl_cffi`, `websocket-client`) into an isolated environment on
first run — no manual `uv sync` needed, and nothing is installed into
the host Python.

Optional, for pro/reasoning/deep-research modes:

```bash
export PERPLEXITY_COOKIES='{"next-auth.session-token": "..."}'
```

See `.claude/vendor/perplexity-ai/README.md` ("How To Get Cookies") for
how to obtain these from a logged-in Perplexity session. Verify the
server is connected with `claude mcp list`.

## Usage notes

- Prefer a specific, narrow query over a broad one.
- `perplexity_search` returns citations/sources — surface them back to
  the user rather than stripping them out.
- Compared to the official API-key-based MCP server, this one only takes
  a single `query` string (no `messages` array, recency/domain filters,
  or structured citations) — see the "Differences from the Official MCP"
  table in the vendored README for the full list.
- If the `perplexity` tool isn't available, check that `uv` is installed
  and that the vendored project at `.claude/vendor/perplexity-ai` is
  intact.
