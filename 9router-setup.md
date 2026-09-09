# 9Router Setup

Steps to install and run [9Router](https://github.com/decolua/9router) (FREE AI router & token saver) locally, verified against v0.5.69 on Node.js v22.

## Requirements

- Node.js 20+

## Install

```bash
npm install -g 9router
```

## Run

```bash
9router --no-browser --skip-update --log
```

- `--no-browser` — required on headless machines/containers with no display; without it, 9Router tries to open a browser window and exits immediately instead of starting the server.
- `--skip-update` — skips the auto-update check on startup.
- `--log` — prints server logs to stdout (hidden by default).

By default it binds `0.0.0.0:20128` and prints a "Network-exposed" warning. To bind local-only, add `--host 127.0.0.1` (note: on some setups this flag causes the process to exit right after printing the warning instead of starting — if that happens, drop `--host` and rely on your own firewall/network isolation instead).

Once running:

- Dashboard: `http://localhost:20128/dashboard`
- OpenAI-compatible API: `http://localhost:20128/v1`

## Verify it's up

```bash
curl -s http://127.0.0.1:20128/v1/models -H "Authorization: Bearer test"
```

Should return a JSON list of available models (providers still need to be connected via the dashboard for real routing).

## Next steps

1. Open the dashboard and connect at least one provider (e.g. Kiro AI or OpenCode Free for a $0 setup).
2. Point your CLI tool (Claude Code, Cursor, Codex, etc.) at `http://localhost:20128/v1` with the API key shown in the dashboard.

See the [9Router README](https://github.com/decolua/9router) for full provider list, combo configs, and deployment options (Docker, VPS, Cloudflare Workers).
