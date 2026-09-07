# context-mode doctor

A zero-dependency diagnostic CLI that audits a project's Claude Code context
configuration and reports on its health — similar in spirit to `claude doctor`,
but focused on what actually gets loaded into the model's context window.

## What it checks

- **CLAUDE.md** — present, non-empty, not oversized, no duplicate/conflicting copies
- **`.claude/settings.json` / `.claude/settings.local.json`** — valid JSON, no
  permission rules that appear in both `allow` and `deny`
- **`.mcp.json`** — valid JSON, defines at least one MCP server
- **`.gitignore`** — exists and excludes local settings/env files
- **Secrets** — scans always-loaded context files (CLAUDE.md, settings, MCP
  config) for patterns that look like API keys or private keys
- **Context budget** — estimates the total token cost of everything that gets
  loaded on every turn, and warns/fails if it's crowding out real context

## Usage

```bash
python3 context_mode_doctor.py [PATH]
```

`PATH` defaults to the current directory. Exits `0` if there are no failures,
`1` otherwise (useful in CI).

Example output:

```
context-mode doctor — auditing /path/to/project

[✓] PASS  CLAUDE.md present (~340 tokens)
[!] WARN  No .claude/settings.json found
        Optional, but useful for pinning permissions and hooks instead of relying on ad-hoc approvals.
[✓] PASS  No obvious secrets in context files
[✓] PASS  Always-loaded context is reasonable (~340 tokens)

3 passed, 1 warnings, 0 failed
```

No external dependencies — just Python 3.9+.
