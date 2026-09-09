# Claude-Mem — Persistent Memory for Claude Code

Notes on [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem), based on the maker's write-up.

## What it is

Claude-Mem is a persistent-memory layer for Claude Code. Without it, every new session starts cold — Claude re-reads the project to get back up to speed, which is slow and burns tokens. Claude-Mem quietly captures what happens during a session, compresses it with AI into semantic summaries, and injects the relevant bits back into future sessions, so context survives across restarts.

- License: Apache-2.0
- Install: `npx claude-mem install`
- ~77k+ stars, Trendshift-listed, listed in Awesome Claude Code
- Also works with Gemini CLI, OpenCode, and OpenClaw — not just Claude Code
- By Alex Newman ([@thedotmack](https://github.com/thedotmack))

## Core capabilities

- **Persistent memory** — context survives across sessions automatically, no manual saving
- **Local web viewer** at `http://localhost:37777` — watch the memory stream in real time
- **`mem-search`** — query project history in natural language
- **Smart Explore** — AST-based code navigation (`smart_search`, `smart_outline`, `smart_unfold`) that returns exact symbols instead of whole files; this is where most of the token savings come from
- **Privacy control** — wrap anything in `<private>` tags and it's never stored

## How it works

- Lifecycle hooks (`SessionStart`, `UserPromptSubmit`, `PostToolUse`, `Stop`, `SessionEnd`) watch the session and record what Claude does
- A worker service + SQLite store sessions, observations, and summaries; a Chroma vector DB powers hybrid semantic + keyword search
- On session start, relevant past context is injected back in with progressive disclosure, loading only what's needed
- Search uses a 3-layer flow — `search` → `timeline` → `get_observations` — fetching full detail only for the IDs actually needed (~10x savings over dumping everything)

## Quick start

```bash
# Install (registers the memory hooks + worker service)
npx claude-mem install
```

Or as a Claude Code plugin:

```bash
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem
```

Restart Claude Code afterward; context from previous sessions then shows up automatically in new ones.

Requires Node 18+, plus Bun, uv, and SQLite (auto-installed if missing).

**Not set up in this repo.** `npx claude-mem install` registers global session hooks and starts a persistent background worker on port 37777 — a system-wide, hard-to-reverse change beyond what this notes-only setup should do unattended. Run it yourself locally if you want the memory layer active.

## The Smart Explore benchmark

From the maker's benchmark — Smart Explore vs. the standard Explore agent, same codebase (Claude-Mem's own 194-file repo), same model (Opus 4.6):

| Task | Smart Explore | Explore agent | Advantage |
|---|---|---|---|
| Find code across the repo | ~14,200 tokens | ~252,500 tokens | 17.8x cheaper |
| Read specific functions | ~5,650 tokens | ~109,400 tokens | 19.4x cheaper |
| Find + read (end to end) | ~4,200 tokens | ~45,000 tokens | 10-12x cheaper |
| Speed | Under 2s/call | 5-66s/call | 10-30x faster |

That's where the "up to ~95% fewer tokens" figure comes from (17.8x cheaper ≈ 94% less). Smart Explore was also more complete — the standard agent truncated the longest function; Smart Explore returned it in full.

**Caveat:** these numbers are from one benchmark — code-navigation tools vs. a standard Explore agent — not "every session is 95% cheaper." Results depend on the codebase and how it's searched.

## Gotchas

- `npm install -g claude-mem` only installs the SDK — it does **not** wire up the memory hooks. Use `npx claude-mem install`.
- Installed but no memory appears → reinstall with `npx claude-mem install`, then restart Claude Code.
- Nothing on `localhost:37777` → the worker didn't start; restart Claude Code so the hooks boot it.
- Windows `npm` not recognized → install Node from nodejs.org and restart the terminal.
- Unrelated to the tool itself: there's a 3rd-party `$CMEM` Solana memecoin the creator has "embraced." It isn't needed to use Claude-Mem — the tool is free and open-source.

## Links

- Repo: https://github.com/thedotmack/claude-mem
- License: Apache-2.0
