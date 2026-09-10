# Claude-Mem — Persistent Memory for Claude Code

Notes on [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem), based on the maker's write-up.

## What it is

Claude-Mem is a persistent-memory layer for Claude Code. Without it, every new session starts cold — Claude re-reads the project to get back up to speed, which is slow and burns tokens. Claude-Mem quietly captures what happens during a session, compresses it with AI into semantic summaries, and injects the relevant bits back into future sessions, so context survives across restarts.

- License: Apache-2.0
- Install: `npx claude-mem install`
- ~77k+ stars, Trendshift-listed, listed in Awesome Claude Code
- Also works with Gemini CLI, OpenCode, and OpenClaw — not just Claude Code
- By Alex Newman ([@thedotmack](https://github.com/thedotmack))

## Core capabilities

- **Persistent memory** — context survives across sessions automatically, no manual saving
- **Local web viewer** at `http://localhost:37777` — watch the memory stream in real time
- **`mem-search`** — query project history in natural language
- **Smart Explore** — AST-based code navigation (`smart_search`, `smart_outline`, `smart_unfold`) that returns exact symbols instead of whole files; this is where most of the token savings come from
- **Privacy control** — wrap anything in `<private>` tags and it's never stored

## How it works

- Lifecycle hooks (`SessionStart`, `UserPromptSubmit`, `PostToolUse`, `Stop`, `SessionEnd`) watch the session and record what Claude does
- A worker service + SQLite store sessions, observations, and summaries; a Chroma vector DB powers hybrid semantic + keyword search
- On session start, relevant past context is injected back in with progressive disclosure, loading only what's needed
- Search uses a 3-layer flow — `search` → `timeline` → `get_observations` — fetching full detail only for the IDs actually needed (~10x savings over dumping everything)

## Quick start

```bash
# Install (registers the memory hooks + worker service)
npx claude-mem install
```

Or as a Claude Code plugin:

```bash
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem
```

Restart Claude Code afterward; context from previous sessions then shows up automatically in new ones.

Requires Node 18+, plus Bun, uv, and SQLite (auto-installed if missing).

**Not set up in this repo.** `npx claude-mem install` registers global session hooks and starts a persistent background worker on port 37777 — a system-wide, hard-to-reverse change beyond what this notes-only setup should do unattended. Run it yourself locally if you want the memory layer active.

## The Smart Explore benchmark

From the maker's benchmark — Smart Explore vs. the standard Explore agent, same codebase (Claude-Mem's own 194-file repo), same model (Opus 4.6):

| Task | Smart Explore | Explore agent | Advantage |
|---|---|---|---|
| Find code across the repo | ~14,200 tokens | ~252,500 tokens | 17.8x cheaper |
| Read specific functions | ~5,650 tokens | ~109,400 tokens | 19.4x cheaper |
| Find + read (end to end) | ~4,200 tokens | ~45,000 tokens | 10-12x cheaper |
| Speed | Under 2s/call | 5-66s/call | 10-30x faster |

That's where the "up to ~95% fewer tokens" figure comes from (17.8x cheaper ≈ 94% less). Smart Explore was also more complete — the standard agent truncated the longest function; Smart Explore returned it in full.

**Caveat:** these numbers are from one benchmark — code-navigation tools vs. a standard Explore agent — not "every session is 95% cheaper." Results depend on the codebase and how it's searched.

## Gotchas

- `npm install -g claude-mem` only installs the SDK — it does **not** wire up the memory hooks. Use `npx claude-mem install`.
- Installed but no memory appears → reinstall with `npx claude-mem install`, then restart Claude Code.
- Nothing on `localhost:37777` → the worker didn't start; restart Claude Code so the hooks boot it.
- Windows `npm` not recognized → install Node from nodejs.org and restart the terminal.
- Unrelated to the tool itself: there's a 3rd-party `$CMEM` Solana memecoin the creator has "embraced." It isn't needed to use Claude-Mem — the tool is free and open-source.

## Links

- Repo: https://github.com/thedotmack/claude-mem
- License: Apache-2.0

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
