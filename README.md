# PraisonAI — Repo Overview

Notes on [MervinPraison/PraisonAI](https://github.com/MervinPraison/PraisonAI), based on its GitHub repository page and README.

## What it is

PraisonAI is an open-source framework for building autonomous, self-improving AI agents — single agents or full multi-agent workforces — with built-in memory, RAG/knowledge, guardrails, and support for 100+ LLM providers. It's pitched as "Hire a 24/7 AI Workforce": agents that research, plan, code, and execute tasks, deployable in as little as 5 lines of Python or a no-code YAML file.

- License: MIT
- Docs: [praison.ai/docs](https://praison.ai/docs)
- Stack: Python 81.8%, TypeScript 13.7%, Rust 2.7%, JavaScript 1.1% (plus HTML/Shell)
- ~9.0k stars / ~1.4k forks, 76 watchers, 873 tags, 848 releases at time of writing (latest: v4.7.7)
- Publicly highlighted by Elon Musk (X) for its Grok 3 customer-support tutorial

## The five-layer agent stack

PraisonAI frames agent-building as five composable layers, each answering a different question, plus an outer "where does it run" layer:

| Layer | Question | PraisonAI mechanism |
|---|---|---|
| 1 · Prompt | Did I say it clearly? | `instructions=`, role/goal/backstory, `output=`, templates |
| 2 · Context | Is the right thing in the window? | `memory=`, `knowledge=`, `context=`, handoff `ContextPolicy` |
| 3 · Harness | Can it act, and be checked? | `tools=`, `MCP()`, `guardrails=`, `approval=`, `hooks=`, `sandbox=` |
| 4 · Loop | When do we stop? | `execution=ExecutionConfig(...)`, `reflection=`, `autonomy=`, doom-loop detection |
| 5 · Graph | Who runs when, and who checks whom? | `AgentFlow`, `route()`, `parallel()`, `loop()`, `repeat()` |
| ⬡ Managed | Where does it actually run? | `tools_run_on="docker"` (shared sandbox for tools) or `run_on="anthropic"` (whole agent hosted) |

## Getting started

```bash
pip install praisonaiagents
export OPENAI_API_KEY="your-api-key"
```

```python
from praisonaiagents import Agent

agent = Agent(instructions="You are a senior data analyst.")
agent.start("Analyze the top 3 tech trends of 2026 and format as a markdown table.")
```

No-code YAML is also supported (`praisonai agents.yaml`) for defining and running multi-agent teams without writing Python.

## Ecosystem

| Package | Purpose | Install |
|---|---|---|
| `praisonaiagents` | Core SDK, pure Python | `pip install praisonaiagents` |
| `praisonai` | CLI for terminal-based workflows | `pip install praisonai` |
| Claw Dashboard 🦞 | Connect agents to Telegram/Slack/Discord/WhatsApp | `pip install "praisonai[claw]"` |
| Flow Visual Builder | Drag-and-drop workflow creation (Langflow-based) | `pip install "praisonai[flow]"` |
| PraisonAI UI | Lightweight chat interface | `pip install "praisonai[ui]"` |
| JS SDK | JavaScript/Node agents | `npm install praisonai` |

## Key features

- **MCP protocol** — stdio, HTTP, WebSocket, SSE transports via `MCP(...)`
- **Planning mode** — plan → execute → reason (`planning=True`)
- **Deep research** — multi-step autonomous research
- **External agent orchestration** — Claude Code, Gemini CLI, Codex
- **Agent handoffs** — `handoffs=[other_agent]`, inherits limited context/tools rather than the full transcript
- **Guardrails** — input/output validation
- **Web search + fetch** — native browsing (`web=True`)
- **Self reflection** — agent reviews its own output
- **Workflow patterns** — route, parallel, loop, repeat (`AgentFlow`)
- **Zero-dependency memory** — works out of the box, or backed by Postgres/MySQL/SQLite/MongoDB/Redis/20+ more via `db(...)`
- 100+ supported LLM providers (OpenAI, Anthropic, Gemini, DeepSeek, Azure, Ollama, Groq, Mistral, Bedrock, Vertex AI, and more)

## Managed / sandboxed execution

Beyond the five layers, PraisonAI can run tools or whole agents in a remote sandbox instead of the local machine:

```python
# Only the TOOLS move (thinking stays local)
agent = Agent(name="builder", tools_run_on="docker")   # docker | e2b | modal | daytona | flyio | tenki | sandlock | ssh | novita

# The WHOLE agent moves (model calls, loop, and tools)
agent = Agent(name="teacher", run_on="anthropic")       # hosted
```

`praisonai managed ps` / `praisonai managed stop --all` list and reclaim running sandboxes; a `.praisonai/environment.yaml` file lets an environment travel with the repo.

## CLI quick reference

Execution, research, planning, workflows, memory, knowledge, sessions, tools, MCP, development (`commit`, `docs`, `checkpoint`, `hooks`), and 24/7 `schedule` commands are all exposed via the `praisonai` CLI — see the docs for the full reference.

## Performance

Agent instantiation is reported at ~14 μs on average.

## Links

- Docs: https://praison.ai/docs
- Repo: https://github.com/MervinPraison/PraisonAI
- Contributing guide, Security policy, and Code of Conduct are published in the repo

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
