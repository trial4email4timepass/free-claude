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

## Additional anthropics/skills vendored

Beyond `frontend-design`, three more skills from
[anthropics/skills](https://github.com/anthropics/skills/tree/main/skills)
(Apache 2.0, each with its own `LICENSE.txt`) are vendored under
`.claude/skills/`, chosen for coding/dev relevance:

- **`mcp-builder`** — guide for building high-quality MCP servers (Python
  FastMCP or Node/TypeScript MCP SDK), with reference docs and evaluation
  scripts. Relevant since this repo already wires up an MCP server
  (`perplexity` in `.mcp.json`).
- **`webapp-testing`** — Playwright-based toolkit for testing local web
  apps: verifying frontend behavior, capturing screenshots, reading
  browser/console logs.
- **`claude-api`** — reference for the Claude API / Anthropic SDK (model
  IDs, pricing, streaming, tool use, MCP, agents, caching, token counting,
  model migration), with per-language examples (Python, TypeScript, Go,
  Java, Ruby, PHP, C#, curl).

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

## rtk-plugin (full vendor, hooks NOT wired)

This repo also vendors [enixCode/rtk-plugin](https://github.com/enixCode/rtk-plugin)
(MIT, `.claude/THIRD_PARTY_NOTICE_rtk-plugin_LICENSE`) under
`.claude/vendor/rtk-plugin/` — a plugin that transparently compresses the
output of every `Bash` tool call (`git status`, `pnpm install`, etc.) by
wrapping commands with the [RTK](https://github.com/rtk-ai/rtk) binary, to
cut context-window usage on noisy shell output. Its one slash command is
surfaced live at `.claude/commands/rtk-plugin/gain.md` (`/rtk-plugin:gain`,
a token-savings dashboard).

**This one is not wired up, and for a stronger reason than the hooks left
unwired elsewhere in this repo.** `hooks/hooks.json` (vendored, not merged
into `.claude/settings.json`) declares:

- A `SessionStart` hook that **downloads and executes a third-party binary**
  (the pinned RTK release, ~5 MB) into `${CLAUDE_PLUGIN_DATA}/rtk/` and runs
  `rtk init -g`, automatically, on every session start.
- A `PreToolUse` hook on every `Bash` call that **rewrites the command**
  before it runs, prefixing recognized programs (`git`, `cargo`, `pnpm`, …)
  with the downloaded `rtk` binary.

That's a materially larger trust boundary than an instructional skill or a
review hook: it fetches and runs an external binary and transparently alters
what command actually executes. Vendored here for reference/audit only. To
use it for real, install it as an actual plugin (which is also the only way
to get pinned-version updates and the upstream maintainer's release process
behind it, rather than a static snapshot):

```
/plugin marketplace add enixCode/plugins
/plugin install rtk-plugin@enix
```

## security-audit-skill (full vendor)

This repo also vendors [cloudflare/security-audit-skill](https://github.com/cloudflare/security-audit-skill)
(MIT, `.claude/THIRD_PARTY_NOTICE_security-audit-skill_LICENSE`) — the
single-repo skill that seeded Cloudflare's fleet-wide vulnerability
discovery harness (see [Build your own vulnerability
harness](https://blog.cloudflare.com/build-your-own-vulnerability-harness)).
It turns a coding agent into a security auditor: isolated hunter agents work
a deterministic coverage ledger across a large library of attack-class
references (memory safety, AI/LLM, web protocol & auth, client-side, supply
chain, cloud/deployment, RPC/messaging, resource exhaustion, data isolation,
desktop/mobile/IPC), every candidate finding goes through independent
validation and record verification, and the run ends in a target-neutral
`REPORT.md`/`FINDINGS-DETAIL.md`/`NEEDS-VALIDATION.md`. Guidance mode (ad
hoc security questions/reviews) is used by default; the full six-phase audit
workflow only runs on an explicit audit/pen-test/full-review request.

- `.claude/vendor/security-audit-skill/` — source-of-truth copy (`README.md`,
  `LICENSE`, `skills/security-audit/`).
- `.claude/skills/security-audit/` — the skill surfaced live: `SKILL.md`
  plus its phase/attack-class reference docs and the two zero-dependency
  Node validators (`validate-findings.cjs`, `validate-coverage-ledger.cjs`,
  with their `.test.cjs` files) that check `findings.json` and
  `coverage-ledger.json` during a run.

No hooks or `.mcp.json` ship with this plugin, so there's no wiring decision
to make here — it's pure skill guidance, discoverable via the `Skill` tool.

## ui-ux-pro-max-skill (full vendor)

This repo also vendors [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill)
(MIT, `.claude/THIRD_PARTY_NOTICE_ui-ux-pro-max-skill_LICENSE`) — a UI/UX
design-intelligence skill set backed by local searchable data (79 UI styles,
192 color palettes, 74 font pairings, 119 UX guidelines, 25 chart types,
across 22 tech stacks: React, Next.js, Vue, Svelte, SwiftUI, Flutter,
Tailwind/shadcn-ui, Angular, and more). Upstream is a large multi-tool repo
(a CLI, a Next.js gallery site, docs); only the Claude Code plugin surface —
`.claude-plugin/`, `skill.json`, and the `.claude/skills/` tree — is vendored
here, matching how this repo already handles multi-target upstream repos.

- `.claude/vendor/ui-ux-pro-max-skill/` — source-of-truth copy (~11 MB: the
  seven skills' `SKILL.md` files plus their `data/` (CSV/JSON palettes,
  fonts, styles), `scripts/` (Python), `references/`, `templates/`, and font
  assets under `ui-styling/canvas-fonts/`).
- `.claude/skills/{banner-design,brand,design,design-system,slides,
  ui-styling,ui-ux-pro-max}/` — all seven skills surfaced and live, complete
  with their data/scripts/assets (not flattened to just `SKILL.md`, since
  several of them read local data files and run local scripts at use time).

No hooks ship with this plugin, so there's no wiring decision to make here.

## ponytail (full vendor)

This repo also vendors [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail)
(MIT, `.claude/THIRD_PARTY_NOTICE_ponytail_LICENSE`) — a "lazy senior dev"
skill set that pushes Claude toward the simplest, shortest solution that
actually works (YAGNI, stdlib/native first, no unrequested abstractions),
plus tooling to review, audit, and track the deliberate shortcuts it leaves
behind.

- `.claude/vendor/ponytail/` — a complete, unmodified copy of the
  Claude-Code-relevant parts of the upstream repo (it's a multi-agent plugin;
  the Cursor/Windsurf/Codex/Gemini/etc. integrations aren't vendored here):
  `.claude-plugin/` manifest, `hooks/` (the three lifecycle hook scripts plus
  their shared config/instructions/runtime modules), and `skills/`. This is
  the source of truth; everything below is derived from it.
- **Skills** — all six skills surfaced into `.claude/skills/<name>/`:
  `ponytail` (the mode itself, `/ponytail lite|full|ultra`), `ponytail-review`
  (over-engineering-focused diff review), `ponytail-audit` (same, whole-repo),
  `ponytail-debt` (harvests `ponytail:` shortcut comments into a ledger), and
  `ponytail-gain`/`ponytail-help` (scoreboard and reference card).

### Hooks are vendored but intentionally NOT wired up

`hooks/claude-codex-hooks.json` declares a `SessionStart` hook (fires on every
session start/resume/clear/compact), a `SubagentStart` hook, and a
`UserPromptSubmit` hook — each shelling out to a Node script. Vendored as-is
under `.claude/vendor/ponytail/hooks/`, but **not** merged into
`.claude/settings.json`, for the same reason the `claude-plugins-official`
hooks above are left unwired: a hook that runs unconditionally on every
session/prompt is high blast radius to enable silently in a shared repo, and
`node` needs to be on `PATH` for it to work at all.

To turn it on deliberately, merge `.claude/vendor/ponytail/hooks/claude-codex-hooks.json`'s
`hooks` block into `.claude/settings.json`, replacing `${CLAUDE_PLUGIN_ROOT}`
with `.claude/vendor/ponytail`. The cleaner alternative — and the only way to
get auto-updates — is installing it for real:

```
/plugin marketplace add DietrichGebert/ponytail
/plugin install ponytail@ponytail
```

(Two separate prompts, per upstream's install notes.)

## awesome-llm-apps agent_skills (partial vendor)

This repo also vendors the `agent_skills/` directory of
[Shubhamsaboo/awesome-llm-apps](https://github.com/Shubhamsaboo/awesome-llm-apps)
(Apache-2.0, `.claude/THIRD_PARTY_NOTICE_awesome-llm-apps-agent-skills_LICENSE`)
— a collection of genuine `SKILL.md`-format skills for coding agents (Claude
Code, Codex, Cursor, and others), distinct from the rest of that repository,
which is ~100 standalone example AI agent/RAG applications (see the
reference note below) rather than installable skills.

- `.claude/vendor/awesome-llm-apps-agent-skills/` — an unmodified copy of the
  upstream `agent_skills/` directory: its `README.md`, `LICENSE`, the seven
  skills below, and their shared `evals/` (each skill ships an executable
  eval upstream; kept here for reference/audit rather than run automatically).
  This is the source of truth; everything below is derived from it.
- **Skills** — surfaced live (with their own `references/`/`scripts/`, not
  flattened to just `SKILL.md`) into `.claude/skills/<name>/`:
  - `project-graveyard` — scans local git history for abandoned side
    projects, autopsies why each died, and recommends one to resurrect
  - `commit-archaeologist` — reconstructs why a piece of code exists from its
    introducing commit, later edits, and companion files
  - `dependency-doctor` — audits `requirements.txt`/`pyproject.toml`/
    `package.json` for stdlib-shadowing pins, abandoned backports, and
    unpinned/conflicting entries (offline by default; PyPI yanked-release
    checks are opt-in via an explicit `--online` flag)
  - `first-reader` — simulates real readers moving through a draft to report
    where attention breaks, without rewriting anything
  - `scope-creep-detector` — checks a git diff against its stated intent and
    flags unrelated files, oversized hunks, or scope growth
  - `thinking-out-loud` — turns a rambling voice-dictated brief into an
    echoed, verifiable summary before the agent acts on it
  - `advisor-orchestrator-worker` — orchestrates a cheap-worker /
    expensive-advisor model team with budget and verification gates

  Not surfaced: `self-improving-agent-skills`, which upstream lists in the
  same table but is a backend+frontend web app (Gemini/ADK-based skill
  optimizer), not itself a `SKILL.md` skill.

Per upstream's own note, skills run with the installing agent's permissions;
each of the seven above declares its network use up front (most are fully
offline) and none has install-time execution — no hooks, no `.mcp.json`, no
`curl | bash`. Same install path as this repo's other vendored skills: they
are Claude Code project skills the moment they exist under `.claude/skills/`,
discoverable via the `Skill` tool. To pick up upstream updates, re-run the
copy from `agent_skills/` at a newer commit of the upstream repo.

## awesome-llm-apps (reference note, rest not vendored)

Beyond `agent_skills/` (vendored above), the rest of
[Shubhamsaboo/awesome-llm-apps](https://github.com/Shubhamsaboo/awesome-llm-apps)
is a large (100+) collection of standalone, hand-built example AI
agent/RAG/LLM applications — not Claude Code plugins or skills, so there's
nothing to install into `.claude/`. Noted here rather than vendored, for the
same reason as the DeerFlow notes at the top of this README/`CLAUDE.md` and
the Octop note below: a big standalone project, useful as reference, not
something that folds into this repo's skill set.

- License: Apache-2.0. Site/tutorials: [theunwindai.com](https://www.theunwindai.com).
- Layout: `starter_ai_agents/` (single-file agents, API key only),
  `advanced_ai_agents/` (single- and multi-agent apps), `advanced_llm_apps/`,
  `rag_tutorials/`, `mcp_ai_agents/`, `voice_ai_agents/`,
  `generative_ui_agents/`, `always_on_agents/`, and
  `ai_agent_framework_crash_course/`. Each example is its own directory with
  a `requirements.txt`/`pyproject.toml` and a README; most run with
  `pip install -r requirements.txt && streamlit run <script>.py` plus an API
  key for whichever model provider the example targets (Claude, Gemini, GPT,
  DeepSeek, Llama, Qwen, or a local/open-source model).
- Quick start for any one example:
  ```bash
  git clone https://github.com/Shubhamsaboo/awesome-llm-apps.git
  cd awesome-llm-apps/starter_ai_agents/ai_travel_agent
  pip install -r requirements.txt
  streamlit run travel_agent.py
  ```

## Octop (reference note, not vendored)

[TencentCloud/Octop](https://github.com/TencentCloud/Octop) (MIT) is a
self-hosted, multi-user, multi-agent AI assistant platform — a FastAPI
backend + React dashboard + Go/Electron desktop client, distributed as one
Python wheel. It's a full standalone application, not a Claude Code
plugin/skill: the repo has no `.claude-plugin/` manifest and no
`.claude/skills/` — its only "skill" file
(`.cursor/skills/publish/SKILL.md`) is a Cursor-specific release-automation
script for Octop's own maintainers, not something useful to a Claude Code
user.

It's noted here (rather than vendored like the entries above) because it
does integrate *with* Claude Code: its `octop acp` mode is a bidirectional
[ACP](https://agentclientprotocol.com/) bridge that can delegate terminal/IDE
AI work to Claude Code (or OpenCode) under permission gates. That makes it
something to run *alongside* Claude Code, not something to fold into this
repo's skill set — same reasoning as the DeerFlow notes at the top of this
README/`CLAUDE.md`, which document a similarly large standalone platform
rather than vendor it.

- Highlights: multi-user "expert" personas (MBTI-templated), a connector
  ecosystem (OAuth + MCP gateway), pluggable storage backends (local disk,
  Docker, Postgres, COS/S3), portable memory, RAG knowledge base, IM
  integrations (Feishu, DingTalk, QQ, Discord, WeCom), and a browser-AI+
  mode (headless Chromium automation).
- Install: `pip install octop` (PyPI) or Docker/desktop builds — see
  upstream README for `octop` CLI usage and the `octop acp` integration.

## OpenManus (reference note, not vendored)

[FoundationAgents/OpenManus](https://github.com/FoundationAgents/OpenManus)
(MIT) is a standalone, open-source general-purpose AI agent framework in
Python, from ex-MetaGPT contributors — an open alternative to the (closed,
invite-only) Manus agent product. Like the DeerFlow and Octop notes above,
it's a full application you run and configure yourself, not a Claude Code
plugin or skill: no `.claude-plugin/` manifest and no `SKILL.md` anywhere in
the repo, so there's nothing here to vendor into `.claude/`.

- Single generalist `OpenManus` agent (`python main.py`), plus a
  `DataAnalysis` agent for data-analysis/visualization tasks, an MCP-tool
  entrypoint (`python run_mcp.py`), and an experimental multi-agent flow
  runner (`python run_flow.py`).
- Any OpenAI-compatible LLM API via `config/config.toml` (model, base URL,
  API key; a separate `[llm.vision]` block for vision calls).
- Browser automation defaults to Browser Use's CLI 3.0 as an MCP server
  (`uvx browser-use --cli-mcp`, isolated via `uvx`), attaching to local
  Chrome/Chromium with no API key needed; a Browser Use Cloud remote browser
  is opt-in via `BROWSER_USE_API_KEY`. BrowserGym support needs its own
  `playwright install`.
- Install: conda or `uv` (recommended) + `pip install -r requirements.txt`
  (or `uv pip install -r requirements.txt`), then set up `config/config.toml`
  from `config/config.example.toml`.

```bash
git clone https://github.com/FoundationAgents/OpenManus.git
cd OpenManus
uv venv --python 3.12 && source .venv/bin/activate
uv pip install -r requirements.txt
cp config/config.example.toml config/config.toml   # then add your API key
python main.py
```

## OpenDesign (reference note, not vendored)

[nexu-io/open-design](https://github.com/nexu-io/open-design) (Apache-2.0)
is a large, local-first design application (pnpm monorepo, ~13k files) that
exposes its projects, files, preview, and a big skill/design-system library
to coding agents over MCP. Unlike the DeerFlow/Octop/OpenManus notes above,
it *does* ship a genuine Claude Code plugin — but that plugin is an MCP
server, not a set of copy-in skills, so the right way to "add it to Claude"
is to install the plugin and run its daemon, not to vendor anything here.

Why it's referenced rather than vendored:

- **The skills are runtime content, not standalone `SKILL.md` files.** Its
  `skills/` tree (~163 `SKILL.md`s across `prototype`, `design-system`,
  `image`, `video`, `template`, `deck`, `audio`, `utility` modes), plus 154
  `design-systems/` and 115 `design-templates/`, are served by the local
  `od` daemon over MCP and carry `od:`-namespaced metadata; many are
  themselves curated from other upstreams (Anthropic's skills, `taste-skill`,
  etc.). They aren't meant to be dropped into `.claude/skills/` individually,
  and copying them would strip the daemon they depend on.
- **The one true Claude Code project skill in the repo,
  `.claude/skills/od-contribute`, is hard-locked to `nexu-io/open-design`**
  (a first-contribution/PR flow for that repo), so it has no use inside this
  repo.

How to actually add it to your agent (requires the `od` daemon on PATH —
`brew` / `npm` / DMG per upstream):

```
/plugin marketplace add nexu-io/open-design
/plugin install open-design@open-design
```

The plugin (`plugins/open-design`) wires a single stdio MCP server that runs
`od mcp --daemon-url http://127.0.0.1:7456`, so the local OpenDesign daemon
must be installed and running for the tools to resolve. OpenDesign also has
its own plugin spec + registry (`plugins/spec/`, `plugins/registry/`) for
authoring and publishing OD plugins, separate from Claude Code's.

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

## GitHub Tools & Projects Resource (reference note, not vendored)

A curated list of notable projects from four GitHub developers —
[grqz](https://github.com/grqz), [WitherOrNot](https://github.com/WitherOrNot),
[yuliskov](https://github.com/yuliskov), and [stevietv](https://github.com/stevietv)
— kept here as reference reading, not as vendored Claude Code skills/plugins:
none of these repos ship a `.claude-plugin/` manifest or `SKILL.md`, so
there's nothing to install into `.claude/`. They're worth knowing about for
the engineering problems they solve (media/extraction tooling, TLS
fingerprinting, Windows internals reverse engineering, Android TV apps, and
production-scale .NET software).

### grqz — low-level web & media tooling

A contributor/maintainer in the `yt-dlp` ecosystem (listed as a triage
maintainer on `yt-dlp` itself), focused on YouTube extraction, JS challenge
handling, Apple WebKit, and TLS behavior.

- **[yt-dlp-apple-webkit-jsi](https://github.com/grqz/yt-dlp-apple-webkit-jsi)**
  — a `yt-dlp` plugin that uses Apple's WebKit framework as a JavaScript
  challenge provider for YouTube extraction on modern Apple devices. Good
  example of solving a narrow compatibility problem by bridging a
  media-downloading tool with a platform-native browser engine.
  Python; yt-dlp plugins; Apple WebKit.
- **[bgutil-ytdlp-pot-provider](https://github.com/grqz/bgutil-ytdlp-pot-provider)**
  — generates the proof-of-origin tokens YouTube's anti-abuse/request
  validation requires. Shows how open-source media tooling needs constant
  protocol research and browser-behavior emulation as the target site
  changes. Python/JavaScript; yt-dlp; YouTube extraction infra.
- **[ssl_imp](https://github.com/grqz/ssl_imp)** — a C/OpenSSL project that
  reproduces Chrome's TLS fingerprint. Useful for studying TLS handshakes
  and how clients can look different at the network layer even when making
  similar HTTP requests. C; OpenSSL; CMake; TLS fingerprinting.

### WitherOrNot — Windows internals & reverse engineering

Repos focused on Component-Based Servicing (CBS), licensing mechanisms,
obfuscation research, and low-level Windows system behavior.

- **[TSforge](https://github.com/massgravel/TSforge)** — activation/
  evaluation extension methods spanning Windows Vista through 11. A strong
  example of understanding how a large OS's licensing/evaluation mechanisms
  work at a low level. C#; Windows internals; licensing research.
- **[UMSKT](https://github.com/UMSKT/UMSKT)** — an open-source toolkit for
  researching Microsoft's pre-Vista licensing mechanisms; reverse engineering
  turned into a reusable tool. C++; reverse engineering; Windows licensing.
- **[cbs-docs](https://github.com/WitherOrNot/cbs-docs)** — documentation of
  Windows Component-Based Servicing (architecture, internals, image
  deployment behavior), valuable where official docs are thin and the
  authors relied on reverse engineering.
- **[cbsexploder](https://github.com/WitherOrNot/cbsexploder)** — a CBS
  client for offline Windows servicing (stage/install/uninstall/enumerate
  packages in an offline image); turns that reverse-engineering knowledge
  into an actual systems tool. C#; Windows servicing; offline images.

### yuliskov — Android TV & media software

Long-running work on Android TV apps and media experiences.

- **[SmartTube](https://github.com/yuliskov/SmartTube)** — the standout
  entry: a free, open-source media client for Android TVs/TV boxes with
  SponsorBlock integration, adjustable playback speed, 8K/60fps/HDR
  playback, live chat, customizable controls, and no dependency on Google
  Services. A large user-facing app combining media playback, TV UX,
  networking, device compatibility, and a substantial community.
  Java/Kotlin; Android TV; Retrofit/RxJava.
- **[LeanKeyboard](https://github.com/yuliskov/LeanKeyboard)** — a keyboard
  built for Android TVs/set-top boxes: remote-controller support, multiple
  languages, no Google Services or root required. Solves the deceptively
  hard problem of text input on a TV via remote. Java; Android TV; input
  methods.
- **[SmartTubeLegacy](https://github.com/yuliskov/SmartTubeLegacy)** — the
  archived predecessor of SmartTube; useful for seeing how a long-running
  open-source project evolves into a larger successor. JavaScript; Android
  TV; media.

### stevietv — C#/.NET & open-source contributions

A broad profile (100+ repos) centered on C#, JavaScript, SQL, React, and
TypeScript. Since most of the profile is contributions rather than
from-scratch projects, the most useful approach is exploring the profile
for where meaningful contributions were made rather than assuming sole
authorship.

- **[Sonarr](https://github.com/Sonarr/Sonarr)** — a smart PVR-style app
  for automatically managing/downloading TV series from supported sources.
  A mature, production-scale open-source app showing how backend
  automation, scheduling, metadata, media management, and a web UI come
  together in one product. C#/.NET; automation; media management.

### What these teach

Media tooling (handling changing websites/extraction challenges), networking
(TLS fingerprints below the HTTP layer), reverse engineering (documenting
undocumented OS internals), systems engineering (turning low-level findings
into practical tools), Android TV design (remote-control-constrained UX),
and open-source product evolution (personal tool → ecosystem). Mature
projects like these are generally more instructive than small tutorial repos
because they expose real engineering trade-offs.

Repo names, technologies, and capabilities can drift as these projects
change — recheck before relying on any of it.
