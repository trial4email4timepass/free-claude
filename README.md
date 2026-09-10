# DeerFlow — Repo Overview

Notes on [bytedance/deer-flow](https://github.com/bytedance/deer-flow), based on its GitHub repository page and README.

## What it is

DeerFlow (**D**eep **E**xploration and **E**fficient **R**esearch **Flow**) is an open-source, long-horizon "super agent" harness. It orchestrates sub-agents, memory, and sandboxes — via tools and extensible skills — to research, code, and create over tasks that can run from minutes to hours.

- License: MIT
- Site: [deerflow.tech](https://deerflow.tech)
- Stack: Python (backend) + Node.js (frontend)
- ~81.8k stars / ~11.3k forks at time of writing; #1 on GitHub Trending following the v2 launch (Feb 28, 2026)

**Important:** v2.0 is a ground-up rewrite and shares no code with v1. The original Deep Research framework is preserved on the `1.x` branch (still open to contributions); active development is on `2.0`.

## Core capabilities

- **Sub-agents** — decomposes long-horizon tasks across coordinated agents
- **Sandbox execution** — Docker/container, provisioner, or E2B-backed sandboxes for isolated code/tool execution
- **Long-term memory** — persistent memory store surfaced in Settings
- **Skills & tools** — extensible skill system (`.agent/skills`) plus MCP server integration
- **Message gateway** — a Gateway service that owns the agent runtime, SSE streaming, and run lifecycle (including multi-worker coordination via Redis/Postgres)
- **IM channel integrations** and **Claude Code integration** (OAuth-backed CLI provider support)

## Sister projects

- **LLM Space** — a desktop tool for prototyping agent ideas, inspecting harness steps, replaying failures, and benchmarking performance.
- **InfoQuest** — an intelligent search/crawling toolset from BytePlus, newly integrated into DeerFlow (free online experience available).

## Getting started

### One-line agent setup

For coding agents (Claude Code, Codex, Cursor, Windsurf, etc.):

> Help me clone DeerFlow if needed, then bootstrap it for local development by following https://raw.githubusercontent.com/bytedance/deer-flow/main/Install.md

### Manual quick start

```bash
git clone https://github.com/bytedance/deer-flow.git
cd deer-flow
make setup   # interactive wizard: LLM provider, web search, sandbox/bash/file-write prefs
```

`make setup` writes a minimal `config.yaml` and `.env`. Use `make doctor` to validate the setup, and `make config` for the full config template (`config.example.yaml`) if you want to hand-edit things like CLI-backed providers, OpenRouter, or subagent runtime caps.

### Running it

Two supported paths, each with a dev and prod mode:

| | Local | Docker |
|---|---|---|
| Dev | `make dev` (hot-reload) | `make docker-start` |
| Prod | `make start` | `make up` |

- Docker is the recommended path, especially for a persistent server (Linux + Docker preferred over macOS/Windows for that use case).
- Local dev requires Node.js 22+, pnpm, uv, and nginx (`make check` verifies these) and a valid `config.yaml` (from `make setup`).
- Default access URL: `http://localhost:2026`.

## Deployment sizing

| Target | Starting point | Recommended |
|---|---|---|
| Local eval / `make dev` | 4 vCPU, 8 GB RAM, 20 GB SSD | 8 vCPU, 16 GB RAM |
| Docker dev / `make docker-start` | 4 vCPU, 8 GB RAM, 25 GB SSD | 8 vCPU, 16 GB RAM |
| Long-running server / `make up` | 8 vCPU, 16 GB RAM, 40 GB SSD | 16 vCPU, 32 GB RAM |

These cover DeerFlow itself; a self-hosted LLM needs its own sizing.

## Production notes worth knowing

- The Gateway keeps active runs in-process, so production defaults to a **single worker** (`GATEWAY_WORKERS=1`). Multi-worker setups require Postgres, a Redis stream bridge, run-ownership heartbeats, and a DB-backed event store.
- Persistent deployments configure `database.backend` as `sqlite` or `postgres`, shared across the LangGraph checkpointer/store and DeerFlow's own data.
- Login uses HttpOnly session cookies; "keep me signed in" only extends sessions over HTTPS or localhost HTTP. Passwords are never stored client-side.
- The bundled nginx endpoint is same-origin by default; split-origin browser clients need `GATEWAY_CORS_ORIGINS` set explicitly.

## Support & diagnostics

`make doctor` for setup checks; `make support-bundle` generates an issue summary, an AI-assist draft, and an optional redacted evidence zip for filing GitHub issues.

## Links

- Website: https://deerflow.tech
- Repo: https://github.com/bytedance/deer-flow
- Docs: see the repo's `docs/` directory
- Security policy and Code of Conduct are published in the repo

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
