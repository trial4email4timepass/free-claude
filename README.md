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

## Superpowers skills framework

This repo also vendors the [Superpowers](https://github.com/obra/superpowers)
skills framework for Claude Code (v6.3.0), so any Claude Code session opened
against this repo has the full skills library available:

- `.claude/skills/` — the Superpowers skill library (TDD, systematic
  debugging, brainstorming, subagent-driven development, code review, and
  more), vendored as project-level skills alongside this repo's other
  skills (e.g. `perplexity-search`). Discoverable via the `Skill` tool.
- `.claude/hooks/session-start` — bootstrap hook (adapted from Superpowers'
  own plugin hook) that injects the `using-superpowers` skill as context at
  the start of every session. Wired up in `.claude/settings.json` alongside
  the existing `session-start.sh` hook — both run.
- `.claude/THIRD_PARTY_NOTICE_superpowers_LICENSE` — the upstream MIT
  license.

To pick up upstream updates, re-sync `.claude/skills/` (excluding
`perplexity-search`, which is this repo's own) from the [upstream `skills/`
directory](https://github.com/obra/superpowers/tree/main/skills).

## frontend-design skill

`.claude/skills/frontend-design/` vendors the `frontend-design` skill from
[anthropics/skills](https://github.com/anthropics/skills/tree/main/skills/frontend-design)
(Apache 2.0, `LICENSE.txt` included) — guidance for distinctive, intentional
visual design when building or reshaping a UI, so Claude Code reaches for it
on frontend/design work instead of defaulting to templated layouts.

## Additional anthropics/skills vendored

Beyond `frontend-design`, three more skills from
[anthropics/skills](https://github.com/anthropics/skills/tree/main/skills)
(Apache 2.0, each with its own `LICENSE.txt`) are vendored under
`.claude/skills/`, chosen for coding/dev relevance:

- **`mcp-builder`** — guide for building high-quality MCP servers (Python
  FastMCP or Node/TypeScript MCP SDK), with reference docs and evaluation
  scripts. Relevant since this repo already wires up an MCP server
  (`perplexity` in `.mcp.json`).
- **`webapp-testing`** — Playwright-based toolkit for testing local web
  apps: verifying frontend behavior, capturing screenshots, reading
  browser/console logs.
- **`claude-api`** — reference for the Claude API / Anthropic SDK (model
  IDs, pricing, streaming, tool use, MCP, agents, caching, token counting,
  model migration), with per-language examples (Python, TypeScript, Go,
  Java, Ruby, PHP, C#, curl).

## claude-plugins-official (full vendor)

This repo also vendors the plugins physically bundled in
[anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official)
(Apache 2.0, `.claude/THIRD_PARTY_NOTICE_claude-plugins-official_LICENSE`) —
the 39 first-party plugins under `plugins/` plus 14 `external_plugins/`
wrappers (Playwright, GitHub, Linear, Discord, etc.). Note: that repo's
`marketplace.json` actually lists ~290 plugins total, but all but these ~53
are just pointers to *separate* third-party repositories — only the ones
physically present in `plugins/`/`external_plugins/` are vendored here.

- `.claude/vendor/claude-plugins-official/{plugins,external_plugins}/<name>/`
  — a complete, unmodified copy of every bundled plugin (manifest, skills,
  commands, agents, hooks, scripts, `.mcp.json`, its own `LICENSE`/`README`
  where present). This is the source of truth; everything below is derived
  from it.
- **Skills** — each plugin's `skills/<name>/` surfaced into
  `.claude/skills/<name>/` (flattened, skipping `frontend-design`'s copy
  since it's identical to the one already vendored separately above).
  Examples: `skill-creator`, `claude-security`, `plugin-dev`'s
  skill-authoring set, `mcp-server-dev`'s MCP-building skills.
- **Commands** — each plugin's `commands/*.md` surfaced into
  `.claude/commands/<plugin-name>/`, giving namespaced slash commands like
  `/code-review:code-review`, `/commit-commands:commit`,
  `/ralph-loop:ralph-loop`.
- **Agents** — each plugin's `agents/*.md` surfaced into
  `.claude/agents/<plugin-name>-<agent-name>.md` (flattened to avoid name
  collisions), e.g. the `pr-review-toolkit` and `code-modernization` agent
  sets.

### Hooks are vendored but intentionally NOT wired up

Six plugins ship a `hooks/hooks.json` (`claude-security`, `hookify`,
`learning-output-style`, `explanatory-output-style`, `ralph-loop`,
`security-guidance`). Those files are vendored as-is under
`.claude/vendor/.../hooks/`, but **not** merged into `.claude/settings.json`,
so they don't run automatically. Reasons:

- `security-guidance` runs on every `SessionStart`/`PostToolUse`/`Stop` and
  calls out to an LLM API for git-diff review, plus a 180s dependency-install
  step at session start.
- `hookify` and `claude-security` execute Python/shell on tool-use events.
- `learning-output-style` and `explanatory-output-style` are mutually
  exclusive alternate "output style" modes, not both-on-by-default hooks.
- `ralph-loop`'s `Stop` hook drives a self-referential loop — high blast
  radius if enabled unintentionally in a shared repo.

To turn one on deliberately, add its hook entry from
`.claude/vendor/claude-plugins-official/plugins/<name>/hooks/hooks.json`
into `.claude/settings.json`, replacing `${CLAUDE_PLUGIN_ROOT}` with the
vendored path (e.g.
`.claude/vendor/claude-plugins-official/plugins/<name>`). The cleaner
alternative is installing the plugin for real via
`/plugin install <name>@claude-plugins-official`, which sets
`CLAUDE_PLUGIN_ROOT` correctly and keeps it updated.

### external_plugins `.mcp.json` files

Each `external_plugins/<name>/.mcp.json` is vendored inside that plugin's
own directory (not at the repo root), so none of them are auto-loaded —
Claude Code only reads a root-level `.mcp.json`. They're there for
reference/copy-in if you want to wire one up.

## trending-claude-skills marketplace

`.claude-plugin/marketplace.json` at the repo root lists every entry
currently in the [`linny006/trending-claude-skills`](https://github.com/linny006/trending-claude-skills)
leaderboard as an installable Claude Code plugin marketplace.

**⚠️ Unlike the vendored plugins above, this is a mechanical listing, not a
curated or reviewed one.** Each entry points at its original external GitHub
repo via the plugin `source` field — nothing from any of these repos has
been vendored, cloned, or audited here. The upstream leaderboard ranks repos
by recency/momentum in GitHub search results, not by quality or
trustworthiness: many entries have zero stars, unknown authors, and
generic/auto-generated-looking descriptions. A skill's instructions are
executed as trusted input by whatever agent installs it, so installing one
from this list means running unaudited third-party instructions and code
with your agent's permissions.

Before installing any plugin from this marketplace:

- Open its source repo and read the actual skill/plugin files yourself.
- Check who the author is and whether the repo has any real history/activity.
- Prefer entries with meaningful star counts and identifiable maintainers.
- Assume nothing here has been vetted for correctness, safety, or intent.

To use it:

```
/plugin marketplace add trial4email4timepass/free-claude
/plugin install <plugin-name>@free-claude
```

See [`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json) for
the full list of plugin names and source repos. Because these are
third-party repos with no guaranteed structure, not every entry is
guaranteed to install cleanly as a Claude Code plugin. This list was built
once from a snapshot of the upstream leaderboard's README (which itself
refreshes every 15 minutes); this repo does not auto-sync with it, so
entries here may drift from the live leaderboard over time.
