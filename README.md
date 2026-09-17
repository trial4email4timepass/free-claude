# Agent Reach — Repo Overview

Notes on [Panniantong/Agent-Reach](https://github.com/Panniantong/Agent-Reach), based on its GitHub repository page and README (source README is in Chinese; this is a summary/translation).

## What it is

Agent Reach is an open-source **capability layer** (not a wrapper) that gives AI coding agents (Claude Code, OpenClaw, Cursor, Windsurf, etc.) one-command internet access — reading, searching, and browsing across 16 platforms. It doesn't reimplement readers itself: it selects, installs, and health-checks the current best upstream tool/CLI/MCP server for each platform, and lets the agent call that tool directly.

- License: MIT
- Language: Python 3.10+
- Version: 1.5.0 (kept in sync across `pyproject.toml`, `__init__.py`, `tests/test_cli.py`)
- Contact: pnt01@foxmail.com · [@Neo_Reidlab](https://x.com/Neo_Reidlab)

**Important — PyPI name collision:** `pip install agent-reach` resolves to an unrelated package (`jgalea/agent-reach`) that squats the name on PyPI. Always install from the real project's GitHub source (see below).

## Why it exists

Agents are generally good at coding/writing/project work but hit a wall the moment they need to read the live internet: no YouTube captions, no free Twitter search, 403s from Reddit's anonymous API, login walls on Xiaohongshu, anti-scraping blocks on Bilibili, noisy raw HTML instead of clean text, paid-or-mediocre web search, etc. Each platform needs its own tool, its own auth, its own workaround — Agent Reach turns "get an agent internet-capable" into a single sentence handed to the agent.

## Supported platforms

| Platform | Works out of the box | Unlocked after config |
|---|---|---|
| Web | Read any page (Jina Reader) | — |
| YouTube | Caption extraction + video search (yt-dlp) | — |
| RSS/Atom | Read any feed (feedparser) | — |
| Full-web search | — | Semantic search via Exa (auto-configured over MCP, free, no key) |
| GitHub | Read public repos + search (gh CLI) | Private repos, open Issues/PRs, fork |
| Twitter/X | Read a single tweet | Search, timeline, long-form posts |
| Bilibili | Search + video details (bili-cli, no login) | Captions (via OpenCLI) |
| Reddit | — (no zero-config path; anonymous API is blocked) | Search + read posts/comments (OpenCLI browser session, or rdt-cli + cookies) |
| Facebook | — | Search, pages, feed, groups (OpenCLI, reuses desktop Chrome session) |
| Instagram | — | User search, profiles, recent posts, Explore (OpenCLI) |
| Xiaohongshu (RedNote) | — | Search, read, comment (OpenCLI reuses existing Chrome session; MCP/legacy tools use Cookie-Editor export) |
| LinkedIn | Public pages via Jina Reader | Profile details, company pages, job search |
| Boss Zhipin (招聘) | Connectivity check (CDP) | Job search + full JD text (dedicated Chrome, manual login) |
| V2EX | Hot posts, node posts, post detail + replies, user info | — |
| Xueqiu (雪球) | Stock quotes, search, hot posts/rankings | — |
| Xiaoyuzhou podcast | — | Audio-to-text via Whisper transcription (free key) |

Users don't need to memorize configuration steps — telling the agent "help me configure X" walks through what's needed.

## Design philosophy

Each channel (`agent_reach/channels/*.py`) is an ordered list of **primary + fallback backends** that are *actually probed* at runtime (not just checked for existence on `$PATH`); the first fully-working one is selected, and `agent-reach doctor` reports which backend is currently active for every platform, with a fix suggestion if something's broken. When an upstream tool gets rate-limited or blocked (e.g. Bilibili's anti-scraping killed yt-dlp in June 2026 → switched to bili-cli), Agent Reach swaps the backend without the user touching anything.

Current backend choices per channel: Jina Reader (web), twitter-cli → OpenCLI (Twitter), OpenCLI → rdt-cli (Reddit), OpenCLI (Facebook/Instagram/Xiaohongshu), yt-dlp (YouTube), bili-cli → OpenCLI → search API (Bilibili), Exa via mcporter (search), gh CLI (GitHub), feedparser (RSS), mcp-server-linkedin → Jina Reader (LinkedIn).

## Installing

Hand the agent this one-liner and it does the rest:

```
Help me install Agent Reach: https://raw.githubusercontent.com/Panniantong/agent-reach/main/docs/install.md
```

To update an existing install:

```
Help me update Agent Reach: https://raw.githubusercontent.com/Panniantong/agent-reach/main/docs/update.md
```

`agent-reach install` defaults to a **read-only environment check** — it does not install system packages or write config unless `--system` is explicitly passed. `--dry-run` previews every action with no changes.

```bash
# Dev install
pip install -e .

# From the real GitHub source (never PyPI's `agent-reach`)
pipx install https://github.com/Panniantong/agent-reach/archive/main.zip

# Safe, read-only check
agent-reach install --env=auto
agent-reach doctor
```

Only run `agent-reach install --env=auto --system` (installs system tools like `gh`/`mcporter`, writes config) after explicit user approval in the current conversation — same for any `agent-reach configure ...` command that stores cookies/API keys.

Uninstall: `agent-reach uninstall` (clears `~/.agent-reach/`, agent skill files, and mcporter's MCP config); `--dry-run` to preview, `--keep-config` to remove skill files only.

## Security notes

- Credentials (cookies, tokens) live only in `~/.agent-reach/config.yaml`, mode 600, never uploaded.
- Cookie-based platforms (Twitter, Xiaohongshu, Reddit, Facebook, Instagram) carry ban risk from automated access — the project recommends using a **dedicated secondary account**, never a primary one.
- Twitter only accepts cookies the user manually exports via Cookie-Editor; Agent Reach does not perform Xiaohongshu login or read its browser cookies. OpenCLI only reuses a Chrome session the user already has and controls.
- Fully open source; `--dry-run` previews all install/uninstall actions.

## Repo layout (upstream project)

```
agent_reach/
├── cli.py            # CLI entry point (argparse)
├── core.py           # Core read/search routing logic
├── config.py         # Config management (YAML, env vars)
├── doctor.py         # Diagnostics engine
├── channels/         # One file per platform, each extends BaseChannel
├── integrations/mcp_server.py
├── skill/            # OpenClaw skill files
└── guides/           # Usage guides
tests/                 # pytest suite
config/mcporter.json   # MCP tool config
```

Conventions: Python 3.10+ with type hints; each channel implements `can_handle(url)`, `read(url)`, `search(query)`, `check()`; never modify upstream open-source tools' internals — only route/call them; version string must match across `pyproject.toml`, `__init__.py`, and `tests/test_cli.py`.

Links: [github.com/Panniantong/Agent-Reach](https://github.com/Panniantong/Agent-Reach) · [Agent Skills Hub](https://agentskillshub.top/) · [AtomGit mirror](https://atomgit.com/qq_51337814/Agent-Reach)
