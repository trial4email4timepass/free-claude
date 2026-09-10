# MCP servers

`.mcp.json` at the repo root registers four MCP servers, loaded automatically
whenever Claude Code opens this repo:

| Server | Package / Endpoint | Purpose |
|---|---|---|
| `firecrawl` | [`firecrawl-mcp`](https://github.com/firecrawl/firecrawl-mcp-server) | Web scraping / search |
| `playwright` | [`@playwright/mcp`](https://github.com/microsoft/playwright-mcp) | Browser automation |
| `perplexity` | `@perplexity-ai/mcp-server` | Perplexity search (see the `perplexity-search` skill) |
| `composio` | [Composio Connect](https://docs.composio.dev/docs/composio-connect) (`https://connect.composio.dev/mcp`) | Access to 1000+ third-party app integrations |

## Setup

Export the required API keys before starting Claude Code — `.mcp.json`
references them via `${VAR}` expansion, so no secrets are stored in the repo:

```bash
export FIRECRAWL_API_KEY="..."     # https://www.firecrawl.dev
export PERPLEXITY_API_KEY="..."    # https://docs.perplexity.ai/docs/getting-started/integrations/mcp-server
export COMPOSIO_API_KEY="..."      # https://app.composio.dev
```

`playwright` needs no API key — it drives a local/managed browser.

Verify the servers are picked up with `claude mcp list` or the `/mcp` command
inside a Claude Code session.
