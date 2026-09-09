# free-claude

Project-level MCP server configuration for Claude Code.

## MCP servers

`.mcp.json` registers four MCP servers, loaded automatically whenever Claude Code
is run inside this repo:

| Server | Package / Endpoint | Purpose |
|---|---|---|
| `firecrawl` | [`firecrawl-mcp`](https://github.com/firecrawl/firecrawl-mcp-server) | Web scraping / search |
| `playwright` | [`@playwright/mcp`](https://github.com/microsoft/playwright-mcp) | Browser automation |
| `perplexity-ask` | [`server-perplexity-ask`](https://github.com/perplexityai/modelcontextprotocol) | Perplexity Sonar search |
| `composio` | [Composio Connect](https://docs.composio.dev/docs/composio-connect) (`https://connect.composio.dev/mcp`) | Access to 1000+ third-party app integrations |

## Setup

Export the required API keys before starting Claude Code (`.mcp.json` references
them via `${VAR}` expansion, so no secrets are stored in the repo):

```bash
export FIRECRAWL_API_KEY="..."     # https://www.firecrawl.dev
export PERPLEXITY_API_KEY="..."    # https://www.perplexity.ai/settings/api
export COMPOSIO_API_KEY="..."      # https://app.composio.dev
```

`playwright` needs no API key — it drives a local/managed browser.

Verify the servers are picked up with `claude mcp list` or the `/mcp` command inside
a Claude Code session.
