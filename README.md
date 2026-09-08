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
