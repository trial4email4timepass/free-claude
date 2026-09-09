# Claude-Mem — Project Notes

This is reference context on [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem) so it's loaded automatically when Claude Code opens this repo. See `README.md` for the full write-up; summary below.

## What it is

Claude-Mem is a persistent-memory layer for Claude Code (Apache-2.0). It captures what happens in a session, compresses it into semantic summaries, and injects relevant context back into future sessions — so Claude doesn't re-read the project from scratch each time. Also works with Gemini CLI, OpenCode, and OpenClaw.

## Core capabilities

- Persistent memory across sessions, no manual saving
- Local web viewer at `http://localhost:37777`
- `mem-search` — natural-language query over project history
- Smart Explore (`smart_search`, `smart_outline`, `smart_unfold`) — AST-based code navigation returning exact symbols instead of whole files; the main source of token savings
- `<private>` tags exclude content from storage

## Install

```bash
npx claude-mem install       # registers hooks + worker service
```

or as a plugin: `/plugin marketplace add thedotmack/claude-mem` then `/plugin install claude-mem`. Restart Claude Code afterward. Requires Node 18+, Bun, uv, SQLite (auto-installed if missing). `npm install -g claude-mem` alone does **not** wire up the hooks.

**Not installed in this repo** — the installer starts a persistent background worker and registers global session hooks, which is a system-wide change out of scope for this notes-only setup.

## Benchmark headline

Maker's benchmark (Smart Explore vs. standard Explore agent, same 194-file codebase, Opus 4.6): ~17.8x cheaper to find code, ~19.4x cheaper to read specific functions, 10-30x faster overall — the source of the "~95% fewer tokens" claim. Scoped to one benchmark; not a universal per-session savings figure.

Links: [github.com/thedotmack/claude-mem](https://github.com/thedotmack/claude-mem)
