# DeerFlow — Project Notes

This is reference context on [bytedance/deer-flow](https://github.com/bytedance/deer-flow) so it's loaded automatically when Claude Code opens this repo. See `README.md` for the full write-up; summary below.

## What it is

DeerFlow (Deep Exploration and Efficient Research Flow) is an open-source, long-horizon "super agent" harness (MIT license, Python backend + Node.js frontend). It orchestrates sub-agents, memory, and sandboxes via tools and extensible skills to research, code, and create over tasks lasting minutes to hours. v2.0 is a ground-up rewrite sharing no code with v1 (v1 lives on the `1.x` branch).

## Core capabilities

- Sub-agents for decomposing long-horizon tasks
- Sandbox execution (Docker/container, provisioner, or E2B-backed)
- Long-term memory
- Skills & tools (`.agent/skills`) plus MCP server integration
- A Gateway service owning the agent runtime, SSE streaming, and run lifecycle
- IM channel integrations and Claude Code (OAuth) provider support

## Getting started

```bash
git clone https://github.com/bytedance/deer-flow.git
cd deer-flow
make setup   # interactive wizard -> config.yaml + .env
make dev     # or: make docker-start / make up (prod)
```

Default local URL: `http://localhost:2026`. Use `make doctor` to validate setup and `make support-bundle` when filing issues.

## Sizing quick reference

- Local eval: 4 vCPU/8GB min, 8 vCPU/16GB recommended
- Docker dev: 4 vCPU/8GB min, 8 vCPU/16GB recommended
- Long-running server: 8 vCPU/16GB min, 16 vCPU/32GB recommended

## Production notes

- Gateway defaults to a single worker; multi-worker needs Postgres + Redis stream bridge + run-ownership heartbeats + DB-backed event store.
- Login uses HttpOnly cookies; passwords are never stored client-side.
- Split-origin browser clients need `GATEWAY_CORS_ORIGINS` set explicitly (same-origin nginx has no CORS headers by default).

Links: [deerflow.tech](https://deerflow.tech) · [github.com/bytedance/deer-flow](https://github.com/bytedance/deer-flow)
