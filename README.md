# free-claude

A Claude Code workspace bootstrapped with [Context Mode](https://github.com/mksglu/context-mode) — an MCP server that keeps raw tool output out of the model's context window (sandboxed execution, session continuity across compaction, and an indexed knowledge base for search) instead of dumping it inline.

## What's configured

`.claude/settings.json` registers the Context Mode plugin marketplace and enables the plugin at the project level:

```json
{
  "extraKnownMarketplaces": {
    "context-mode": {
      "source": { "source": "github", "repo": "mksglu/context-mode" }
    }
  },
  "enabledPlugins": {
    "context-mode@context-mode": true
  }
}
```

Because this lives in version control, anyone who opens this repo in Claude Code (v1.0.33+) gets the marketplace and plugin installed automatically after accepting the workspace trust dialog — no manual `/plugin` commands needed.

## Verifying the install

Open this repo in Claude Code and run:

```
/context-mode:ctx-doctor
```

All checks should show `[x]`. This validates runtimes, hooks, FTS5, and plugin registration.

## Useful commands

| Command | Purpose |
| --- | --- |
| `/context-mode:ctx-stats` | Context savings — per-tool breakdown, tokens consumed, savings ratio |
| `/context-mode:ctx-doctor` | Diagnostics — runtimes, hooks, FTS5, plugin registration, versions |
| `/context-mode:ctx-index` | Index a local file or directory into the persistent FTS5 knowledge base |
| `/context-mode:ctx-search` | Search previously indexed content |
| `/context-mode:ctx-upgrade` | Pull latest, rebuild, migrate cache, fix hooks |
| `/context-mode:ctx-purge` | Permanently delete all indexed content from the knowledge base |

## Optional: status line

To see live savings (`$ saved this session · $ saved across sessions · % efficient`) in the Claude Code status bar, add this to `~/.claude/settings.json` (global, not committed here since it's a personal preference):

```json
{
  "statusLine": {
    "type": "command",
    "command": "context-mode statusline"
  }
}
```

Restart Claude Code after saving.

## Security

Context Mode enforces the same `permissions.deny` / `permissions.allow` rules already used by Claude Code, extended to its sandbox tools (`ctx_execute`, `ctx_execute_file`, `ctx_batch_execute`). If you add rules like:

```json
{
  "permissions": {
    "deny": ["Bash(sudo *)", "Read(**/.env*)"],
    "allow": ["Bash(git:*)", "Bash(npm:*)"]
  }
}
```

to `.claude/settings.json`, they apply inside the sandbox too. Nothing is enforced by default beyond what you configure.

## License note

Context Mode itself is licensed under the Elastic License 2.0 (source-available); see the [upstream repository](https://github.com/mksglu/context-mode) for details. This repo only references it as a dependency via the Claude Code plugin marketplace mechanism — no context-mode source is vendored here.
