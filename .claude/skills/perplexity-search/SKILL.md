---
name: perplexity-search
description: Use Perplexity AI's search API (via the `perplexity` MCP server) to answer questions that need current, cited, real-world information — news, prices, releases, docs, or anything past the model's knowledge cutoff. Use when the user asks to "search the web", "look up", "check the latest", or asks a factual question whose answer could have changed recently. Requires the `perplexity` MCP server (see `.mcp.json`) and a `PERPLEXITY_API_KEY` environment variable.
---

# Perplexity Search

Gives Claude Code a web-search tool backed by Perplexity's API, for
questions that need up-to-date or cited information rather than what's
already known from training data or the local codebase.

## When to use it

- The user asks about current events, prices, releases, or anything
  time-sensitive ("what's the latest version of X", "is Y still true").
- A question needs a citable source rather than a best-guess answer.
- Local context (code, docs already in the repo) doesn't have the answer —
  check the codebase first; don't reach for web search when the answer is
  already in the project.

## When not to use it

- The answer is stable, well-known, or already available from the
  codebase/CLAUDE.md — searching adds latency and cost for no benefit.
  Every call hits the paid Perplexity API.
- The task is about code in this repo, not general knowledge.

## Setup

Requires the `perplexity` entry in this repo's `.mcp.json` (added
alongside this skill) and a `PERPLEXITY_API_KEY` environment variable set
before Claude Code starts:

```bash
export PERPLEXITY_API_KEY="your_key_here"
```

Get a key from the [Perplexity API dashboard](https://docs.perplexity.ai/docs/getting-started/integrations/mcp-server).
Verify the server is connected with `claude mcp list`.

## Usage notes

- Prefer a specific, narrow query over a broad one — Perplexity's search
  quality (and the citations it returns) is better for concrete questions
  than vague ones.
- Always surface the citations/sources Perplexity returns back to the
  user rather than stripping them out — that's the main value over a
  plain model answer.
- If the `perplexity` tool isn't available, it likely means
  `PERPLEXITY_API_KEY` isn't set in the environment — tell the user
  rather than silently falling back to an uncited answer.
