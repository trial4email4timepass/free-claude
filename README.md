# free-claude

## Installed skills

- **create-plan** (`.claude/skills/create-plan/`) — turns a coding request into a single, read-only, actionable plan. Ported from [openai/skills](https://github.com/openai/skills)'s `skills/.experimental/create-plan` (as of commit `a511969`, the last commit before it was removed upstream in [`ea6b206`](https://github.com/openai/skills/commit/ea6b206c683087da5b503f5ac9d7202b326ac6bb)). Licensed under Apache License 2.0; see `.claude/skills/create-plan/LICENSE.txt`.

- **mattpocock-skills** (Claude Code plugin, enabled in `.claude/settings.json` via the `mattpocock` marketplace → [mattpocock/skills](https://github.com/mattpocock/skills), MIT) — 27 engineering/productivity skills, namespaced as `mattpocock-skills:<name>`: grilling (`grill-me`, `grill-with-docs`), `to-spec` / `to-tickets` / `implement`, `tdd`, `diagnosing-bugs`, `code-review`, `domain-modeling`, `codebase-design`, `improve-codebase-architecture`, `prototype`, `research`, `handoff`, `teach`, `writing-for-agents`, and more. Run `/mattpocock-skills:setup-matt-pocock-skills` once per repo before using the tracker-based flows.

## Agent Reach (reference note, not vendored)

Notes on [Panniantong/Agent-Reach](https://github.com/Panniantong/Agent-Reach), based on its GitHub repository page and README (source README is in Chinese; this is a summary/translation).

### What it is

Agent Reach is an open-source **capability layer** (not a wrapper) that gives AI coding agents (Claude Code, OpenClaw, Cursor, Windsurf, etc.) one-command internet access — reading, searching, and browsing across 16 platforms. It doesn't reimplement readers itself: it selects, installs, and health-checks the current best upstream tool/CLI/MCP server for each platform, and lets the agent call that tool directly.

- License: MIT
- Language: Python 3.10+
- Version: 1.5.0 (kept in sync across `pyproject.toml`, `__init__.py`, `tests/test_cli.py`)
- Contact: pnt01@foxmail.com · [@Neo_Reidlab](https://x.com/Neo_Reidlab)

**Important — PyPI name collision:** `pip install agent-reach` resolves to an unrelated package (`jgalea/agent-reach`) that squats the name on PyPI. Always install from the real project's GitHub source (see below).

### Why it exists

Agents are generally good at coding/writing/project work but hit a wall the moment they need to read the live internet: no YouTube captions, no free Twitter search, 403s from Reddit's anonymous API, login walls on Xiaohongshu, anti-scraping blocks on Bilibili, noisy raw HTML instead of clean text, paid-or-mediocre web search, etc. Each platform needs its own tool, its own auth, its own workaround — Agent Reach turns "get an agent internet-capable" into a single sentence handed to the agent.

### Supported platforms

| Platform | Works out of the box | Unlocked after config |
|---|---|---|
| Web | Read any page (Jina Reader) | — |
| YouTube | Caption extraction + video search (yt-dlp) | — |
| RSS/Atom | Read any feed (feedparser) | — |
| Full-web search | — | Semantic search via Exa (auto-configured over MCP, free, no key) |
| GitHub | Read public repos + search (gh CLI) | Private repos, open Issues/PRs, fork |
| Twitter/X | Read a single tweet | Search, timeline, long-form posts |
| Bilibili | Search + video details (bili-cli, no login) | Captions (via OpenCLI) |
| Reddit | — (no zero-config path; anonymous API is blocked) | Search + read posts/comments (OpenCLI browser session, or rdt-cli + cookies) |
| Facebook | — | Search, pages, feed, groups (OpenCLI, reuses desktop Chrome session) |
| Instagram | — | User search, profiles, recent posts, Explore (OpenCLI) |
| Xiaohongshu (RedNote) | — | Search, read, comment (OpenCLI reuses existing Chrome session; MCP/legacy tools use Cookie-Editor export) |
| LinkedIn | Public pages via Jina Reader | Profile details, company pages, job search |
| Boss Zhipin (招聘) | Connectivity check (CDP) | Job search + full JD text (dedicated Chrome, manual login) |
| V2EX | Hot posts, node posts, post detail + replies, user info | — |
| Xueqiu (雪球) | Stock quotes, search, hot posts/rankings | — |
| Xiaoyuzhou podcast | — | Audio-to-text via Whisper transcription (free key) |

Users don't need to memorize configuration steps — telling the agent "help me configure X" walks through what's needed.

### Design philosophy

Each channel (`agent_reach/channels/*.py`) is an ordered list of **primary + fallback backends** that are *actually probed* at runtime (not just checked for existence on `$PATH`); the first fully-working one is selected, and `agent-reach doctor` reports which backend is currently active for every platform, with a fix suggestion if something's broken. When an upstream tool gets rate-limited or blocked (e.g. Bilibili's anti-scraping killed yt-dlp in June 2026 → switched to bili-cli), Agent Reach swaps the backend without the user touching anything.

Current backend choices per channel: Jina Reader (web), twitter-cli → OpenCLI (Twitter), OpenCLI → rdt-cli (Reddit), OpenCLI (Facebook/Instagram/Xiaohongshu), yt-dlp (YouTube), bili-cli → OpenCLI → search API (Bilibili), Exa via mcporter (search), gh CLI (GitHub), feedparser (RSS), mcp-server-linkedin → Jina Reader (LinkedIn).

### Installing

Hand the agent this one-liner and it does the rest:

```
Help me install Agent Reach: https://raw.githubusercontent.com/Panniantong/agent-reach/main/docs/install.md
```

To update an existing install:

```
Help me update Agent Reach: https://raw.githubusercontent.com/Panniantong/agent-reach/main/docs/update.md
```

`agent-reach install` defaults to a **read-only environment check** — it does not install system packages or write config unless `--system` is explicitly passed. `--dry-run` previews every action with no changes.

```bash
# Dev install
pip install -e .

# From the real GitHub source (never PyPI's `agent-reach`)
pipx install https://github.com/Panniantong/agent-reach/archive/main.zip

# Safe, read-only check
agent-reach install --env=auto
agent-reach doctor
```

Only run `agent-reach install --env=auto --system` (installs system tools like `gh`/`mcporter`, writes config) after explicit user approval in the current conversation — same for any `agent-reach configure ...` command that stores cookies/API keys.

Uninstall: `agent-reach uninstall` (clears `~/.agent-reach/`, agent skill files, and mcporter's MCP config); `--dry-run` to preview, `--keep-config` to remove skill files only.

### Security notes

- Credentials (cookies, tokens) live only in `~/.agent-reach/config.yaml`, mode 600, never uploaded.
- Cookie-based platforms (Twitter, Xiaohongshu, Reddit, Facebook, Instagram) carry ban risk from automated access — the project recommends using a **dedicated secondary account**, never a primary one.
- Twitter only accepts cookies the user manually exports via Cookie-Editor; Agent Reach does not perform Xiaohongshu login or read its browser cookies. OpenCLI only reuses a Chrome session the user already has and controls.
- Fully open source; `--dry-run` previews all install/uninstall actions.

### Repo layout (upstream project)

```
agent_reach/
├── cli.py            # CLI entry point (argparse)
├── core.py           # Core read/search routing logic
├── config.py         # Config management (YAML, env vars)
├── doctor.py         # Diagnostics engine
├── channels/         # One file per platform, each extends BaseChannel
├── integrations/mcp_server.py
├── skill/            # OpenClaw skill files
└── guides/           # Usage guides
tests/                 # pytest suite
config/mcporter.json   # MCP tool config
```

Conventions: Python 3.10+ with type hints; each channel implements `can_handle(url)`, `read(url)`, `search(query)`, `check()`; never modify upstream open-source tools' internals — only route/call them; version string must match across `pyproject.toml`, `__init__.py`, and `tests/test_cli.py`.

Links: [github.com/Panniantong/Agent-Reach](https://github.com/Panniantong/Agent-Reach) · [Agent Skills Hub](https://agentskillshub.top/) · [AtomGit mirror](https://atomgit.com/qq_51337814/Agent-Reach)

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

## Eleven domain agents (adapted from a LangGraph prompt library)

`.claude/agents/eleven-agents-*.md` — 11 Claude Code subagents, one per file,
adapted from the *"Eleven AI Agents for Beginners to Advance Level
Developers"* prompt library (an uploaded archive of `guide/agents/*.md`
LangGraph specs; no upstream repo URL or license file was included with the
source archive, so treat provenance as informal). Each source spec is an
11-section, framework-specific design (state schema, LangGraph node/edge
graph, per-node prompts, `Send`/`interrupt` mechanics) for a *separate*
Python/LangGraph application — none of that is runnable here. What's ported
is each agent's **persona, objective, workflow, and guardrails**, rewritten
as a single-pass Claude Code subagent system prompt that uses this repo's
own tools (`Bash`, `Read`, `Grep`, `Glob`, `Edit`/`Write`, `WebFetch`) in
place of the original's custom Python tools:

| Agent | File | Domain |
|---|---|---|
| SQL Data Analyst | `eleven-agents-sql-data-analyst.md` | Read-only SQL Q&A with self-correction |
| CSV/Excel Data Analyst | `eleven-agents-csv-excel-data-analyst.md` | pandas-based spreadsheet analysis |
| BI Dashboard Insights | `eleven-agents-bi-dashboard-insights.md` | Metric-movement driver analysis |
| Customer Support | `eleven-agents-customer-support.md` | Intent routing + grounded replies |
| HR Resume Screener | `eleven-agents-hr-resume-screener.md` | Bias-free rubric scoring + shortlist |
| Finance Expense Auditor | `eleven-agents-finance-expense-auditor.md` | Policy checks + human review gate |
| Marketing Content | `eleven-agents-marketing-content.md` | Write → critique → revise loop |
| Legal Document Reviewer | `eleven-agents-legal-document-reviewer.md` | Citation-anchored contract review |
| Healthcare Intake | `eleven-agents-healthcare-intake.md` | Guarded intake + emergency escalation |
| DevOps Incident Triage | `eleven-agents-devops-incident-triage.md` | Evidence-cited triage, propose-not-execute |
| E-commerce Recommender | `eleven-agents-ecommerce-recommender.md` | Recommendations + file-based cross-session memory |

Two adaptation notes worth knowing if you compare against the source specs:

- Patterns that relied on LangGraph's `interrupt()`/human-in-the-loop
  (finance auditor, devops triage) become "propose, never execute" agents:
  they always stop short of any write action and hand a clearly-labelled
  proposal back for a human to act on, rather than pausing a live graph.
- The e-commerce recommender's LangGraph cross-thread `Store` becomes an
  optional shopper-profile file the agent reads/writes with `Edit`/`Write`,
  so preferences still persist across sessions without a separate memory
  service.

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

## claude-osint skills (defensive subset)

Four skills from [`elementalsouls/Claude-OSINT`](https://github.com/elementalsouls/Claude-OSINT)
(MIT, by Sachin Sharma; `.claude/THIRD_PARTY_NOTICE_claude-osint_LICENSE`)
are vendored under `.claude/skills/`. `claude-osint` is a library of
structured `SKILL.md` files for the recon phase of **authorized** red-team
and bug-bounty engagements. Only the **analysis / defensive-leaning** subset
is vendored here — the ones that reason about exposure from already-collected
or passively-read data, rather than driving active intrusion:

| Skill | What it does |
|---|---|
| `osint-methodology` | The strategic "how to think" backbone — asset-graph discipline, severity rubric, confidence workflows, time budgeting, deliverable templates. |
| `email-domain-security` | Composite email-spoofability verdict + SPF supply-chain analysis, computed from published DNS alone (passive TXT reads, no mail sent). |
| `exposure-risk-quantification` | FAIR-aligned 0–100 + A–F risk score and $-denominated loss model over findings already collected (passive analysis only). |
| `continuous-exposure-monitoring` | Re-scan/diff loop, finding-lifecycle state machine, and public-feed CTI chatter monitoring (passive OSINT + analysis). |

**Deliberately not vendored:** the upstream repo's active-recon skills
(`offensive-osint`, `osint-autopilot` and its `recon_pipeline.sh` /
`host_enum.workflow.js` / secret-scanner scripts, `org-attack-surface`,
`identity-provider-recon`, `cloud-saas-exposure`). Those carry offensive
tooling that doesn't belong committed into a general-purpose skills repo; if
you need them for an authorized engagement, install the full upstream repo
into `~/.claude/skills/` locally per its README instead. As with any
third-party skill, read the `SKILL.md` files before relying on them — a
skill's instructions are executed as trusted input by whatever agent loads
them.

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

## REA — Reverse Engineer Anything (MCP server + skill)

[morluto/rea](https://github.com/morluto/rea) (MIT) lets Claude investigate apps without their source:
native binaries via Hopper or bring-your-own Ghidra, Electron/JavaScript bundles, managed PE assemblies,
and user-owned browser pages, with evidence records for each conclusion.

- **MCP server** — `rea` in `.mcp.json`, run as `npx -y rea-agents@3.2.1 mcp` (stdio, 114 tools).
  Needs Node.js 22.19+ or 24.11+. To update, review the upstream changelog and change the pinned version.
- **Skill** — `.claude/skills/reverse-engineer-anything/`, copied from upstream `skills/` at commit
  `405732a` (release 3.2.1); `LICENSE.txt` included. It routes each target type to the right REA tool.

Analysis runs locally. Native-binary analysis needs Hopper or Ghidra installed on your machine
(`npx rea-agents setup` can configure Hopper); JavaScript, Electron and browser tools work without them.

## Run Claude Code on free models

- [`claude-on-openrouter/`](claude-on-openrouter) — OpenRouter `:free` models (Nemotron, Laguna, Qwen, …), no proxy needed.
- [`claude-on-nim/`](claude-on-nim) — NVIDIA NIM free models through a local LiteLLM proxy.

## free-llm-api (authored skill)

`.claude/skills/free-llm-api/` is an authored skill (upstream ships no `SKILL.md`) distilled from
[RealTask/free-llm-api](https://github.com/RealTask/free-llm-api) (MIT, snapshot `f2bb6dd`; `LICENSE.txt`
included): a catalog of free-tier AI APIs (Google AI Studio, Groq, Cerebras, OpenRouter, Mistral,
Cloudflare Workers AI, NVIDIA NIM, GitHub Models, Cohere, Hugging Face) for chat, coding, embeddings,
speech, and images, with per-provider limits, env vars, and OpenAI-compatible base URLs. It recommends a
primary + fallback provider for a use case and gives a working `openai`-SDK call plus a fallback chain.

Only the catalog is used, not the upstream Python package: several of the package's hard-coded base URLs
don't match the providers' documented endpoints (Groq, Cerebras, NVIDIA, GitHub Models), so the skill's
`references/providers.md` uses corrected ones. Limits are a June 2026 snapshot and change without notice.

`references/freellm-directory.md` adds a wider, newer directory distilled from
[open-free-llm-api/awesome-freellm-apis](https://github.com/open-free-llm-api/awesome-freellm-apis) (MIT,
snapshot `c2bd37c`, data 2026-10-03; `LICENSE-awesome-freellm-apis.txt` included), which mirrors
[freellm.net](https://freellm.net): 30 providers with base URLs, signup requirements, notable free models, and
limits, plus coding-tool config. Native-only base URLs (Gemini, Cohere, Ollama Cloud) are swapped for their
OpenAI-compatible ones, and upstream's Claude Code example (pointing `ANTHROPIC_BASE_URL` at OpenAI-compatible
endpoints, which Claude Code can't speak) is replaced with Anthropic-compatible-endpoint and proxy options.

## jev-ultrafast (authored skill)

`.claude/skills/jev-ultrafast/` is an authored skill (not vendored — upstream ships no `SKILL.md` or
`.claude-plugin/`) wrapping [browser-use/jev-ultrafast](https://github.com/browser-use/jev-ultrafast) (MIT):
a fast browser agent that picks an indexed `CLICK`/`TYPE_TEXT`/`SELECT`/`SCROLL`/`WAIT`/`DONE` action per
step from one natural-language goal, instead of generating selectors or scripts. A small text LLM only
runs for `TYPE_TEXT`; model output never becomes selectors, coordinates, or executable JavaScript.

Unlike this repo's own `webapp-testing` skill (Playwright, deterministic selector-based test scripts),
jev-ultrafast is for "give it a URL and a plain-language goal" automation — flight/hotel search, form
fills, find-and-click flows — and is out of scope for shadow DOM, canvas UIs, file uploads, and other cases
the upstream README calls out as unsupported in its current MVP.

The skill documents setup (`git clone` + `uv sync` + `TYPESAFE_API_KEY`/`TEXT_MODEL_API_KEY` in `.env`,
Chrome via Browser Harness), the CLI inspector (`uv run jev`), the library usage pattern (`Agent(url,
goal)`), and the point upstream itself makes: a `DONE` state is not proof of success and must be
independently verified.

## OmniRoute (reference note, not vendored)

[diegosouzapw/OmniRoute](https://github.com/diegosouzapw/OmniRoute) (MIT) is
a self-hosted AI gateway: one OpenAI-compatible endpoint
(`http://localhost:20128/v1`) in front of hundreds of LLM providers, with
quota-aware fallback, routing strategies, and prompt compression. Like the
notes above, it's a full Node.js application you run yourself, not a Claude
Code plugin, so there's nothing here to vendor into `.claude/`.

- There's no official hosted gateway — `gateway.omniroute.dev` does not
  resolve. You run your own instance (laptop, VPS, Fly/Docker); the project
  site is [omniroute.online](https://omniroute.online/).
- Install: `npm install -g omniroute` (then `omniroute` serves gateway +
  dashboard on port 20128) or the multi-arch Docker image
  `diegosouzapw/omniroute`. `omniroute doctor` diagnoses providers/ports.
- Also exposes an MCP server (`omniroute --mcp` over stdio, or HTTP at
  `/api/mcp/stream`), A2A, webhooks, and a remote CLI
  (`omniroute connect <host>`) with scoped `read`/`write`/`admin` tokens.
- **Not wired into this repo on purpose.** Pointing Claude Code at it means
  every prompt and file you send goes through that gateway, and a dead
  `ANTHROPIC_BASE_URL` in the committed `.claude/settings.json` would break
  every session here. Set it per-machine instead, only for an instance you
  run or trust. Cloud (claude.ai/code) sessions can't reach your
  `localhost`; they'd need a public HTTPS URL allowed by the environment's
  network policy.

```bash
docker run -d --name omniroute --restart unless-stopped \
  -p 127.0.0.1:20128:20128 -v omniroute-data:/app/data \
  diegosouzapw/omniroute:latest

# Route Claude Code through it (your machine only):
export ANTHROPIC_BASE_URL=http://localhost:20128/v1
export ANTHROPIC_API_KEY=<your OmniRoute key>

# Or just give Claude Code OmniRoute's management tools over MCP:
claude mcp add --transport http omniroute http://localhost:20128/api/mcp/stream
```

## agent-scripts (full vendor, skills only)

This repo also vendors [steipete/agent-scripts](https://github.com/steipete/agent-scripts)
(MIT, `.claude/THIRD_PARTY_NOTICE_agent-scripts_LICENSE`) — Peter
Steinberger's shared agent instructions (`AGENTS.MD`), workflow skills, and
small helper scripts, snapshot of upstream `d15557c`.

- `.claude/vendor/agent-scripts/` — an unmodified copy of the upstream repo
  (minus `.git`). This is the source of truth.
- **Skills** — 52 of the upstream skills are surfaced into
  `.claude/skills/<name>/` as plain copies. Many are tuned to Peter's own
  setup (macOS, Swift/Xcode, OpenClaw, Codex, 1Password, his Mac fleet) and
  call CLIs that aren't installed here; they only trigger when a task
  matches their description, so unused ones are inert.
- **Not surfaced:**
  - `frontend-design` — this repo already ships Anthropic's `frontend-design`
    skill; the upstream copy is kept in the vendor dir only.
  - `codex-first` — its description routes *all* Claude Code implementation,
    fixing, rebasing and PR landing to Codex CLI (OpenAI). That's a global
    behavior change, not a task skill, so it's vendored but deliberately not
    loaded. Copy it into `.claude/skills/` yourself if you want that.
  - 15 skills upstream are symlinks into sibling repos on Peter's machine
    (`../../agent-skills/…`, `../../wacli/…`, etc.: `autoreview`,
    `behavior-validator`, `birdclaw`, `crabbox`, `discrawl`, `gitcrawl`,
    `gog`, `graincrawl`, `handoff`, `imsg`, `peekaboo`, `session-viewer`,
    `slacrawl`, `wacli`, `wacrawl`). They dangle outside his workspace, so
    they're omitted.
- `hooks/pre-commit` (runs upstream's `scripts/validate-skills`) is vendored
  but not wired into this repo's git hooks or `.claude/settings.json`.

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

## "21 things to install in Claude" checklist

Status of each item from the "21 things to install in Claude" graphic,
with the verified upstream source and the command to install it.

### Already in this repo

| Item | Where |
|---|---|
| superpowers | `.claude/skills/` (see *Superpowers skills framework* above) |
| frontend-design | `.claude/skills/frontend-design/` |
| skill-creator | `.claude/skills/skill-creator/` |
| mcp-builder | `.claude/skills/mcp-builder/` |
| find-skills | `.claude/skills/find-skills/`, vendored from [vercel-labs/skills](https://github.com/vercel-labs/skills/tree/main/skills/find-skills) (MIT, `LICENSE.txt` included) |

### Plugins (install via `/plugin`)

All of these are pre-registered in `.claude/settings.json`
(`extraKnownMarketplaces` + `enabledPlugins`), so Claude Code offers to
install them when you trust this project folder. To install by hand, or
into a different project:

```
# codex-plugin-cc: OpenAI's Codex plugin
/plugin marketplace add openai/codex-plugin-cc
/plugin install codex@openai-codex

# financial-services: all 19 plugins are enabled in settings.json
/plugin marketplace add anthropics/financial-services
/plugin install financial-analysis@claude-for-financial-services
# also: investment-banking, equity-research, private-equity, fund-admin, operations,
# pitch-agent, market-researcher, earnings-reviewer, meeting-prep-agent, model-builder,
# gl-reconciler, kyc-screener, valuation-reviewer, month-end-closer, statement-auditor,
# lseg, sp-global, claude-for-msft-365-install

# claude-for-legal: all 13 plugins are enabled in settings.json
/plugin marketplace add anthropics/claude-for-legal
/plugin install commercial-legal@claude-for-legal
# also: privacy-, product-, corporate-, employment-, regulatory-, ai-governance-,
# litigation-, ip-legal, law-student, legal-clinic, legal-builder-hub, cocounsel-legal

# marketingskills
/plugin marketplace add coreyhaines31/marketingskills
/plugin install marketing-skills@marketingskills

# hyperframes: write HTML, render video
/plugin marketplace add heygen-com/hyperframes
/plugin install hyperframes@hyperframes

# claude-seo
/plugin marketplace add AgriciDaniel/claude-seo
/plugin install claude-seo@agricidaniel-claude-seo
```

The `lseg`, `sp-global` and `cocounsel-legal` plugins pull from LSEG,
S&P Global and Westlaw/Practical Law, so they need an account with that
provider to return data. `claude-for-msft-365-install` is an admin setup
tool for the Claude Microsoft 365 add-in, not a day-to-day skill.

**gstack** ([garrytan/gstack](https://github.com/garrytan/gstack)) is not a
plugin. It is a skills bundle with a build step (needs Bun). In Claude Code
on the web, `.claude/hooks/session-start.sh` installs it automatically at
session start (~15-30s cold, skipped once installed; skipped if `bun` is
missing). Anywhere else, install it by hand:

```bash
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack
cd ~/.claude/skills/gstack && ./setup
```

### MCP servers (remote HTTP, OAuth in the browser)

All six are in the root `.mcp.json`, so Claude Code prompts you to approve
them when it opens this project, then asks you to sign in to each one
(`/mcp`). Each URL comes from the vendor's own setup docs. To add them to
another project or globally:

```bash
claude mcp add --transport http granola    https://mcp.granola.ai/mcp
claude mcp add --transport http notion     https://mcp.notion.com/mcp
claude mcp add --transport http kondo      https://relay.trykondo.com/mcp   # Kondo Business tier+
claude mcp add --transport http zapier     https://mcp.zapier.com/api/v1/connect
claude mcp add --transport http higgsfield https://mcp.higgsfield.ai/mcp
/plugin install slack    # Slack's official plugin; bundles https://mcp.slack.com/mcp with its OAuth client
```

On claude.ai or Claude Desktop, add the same URLs under
Customize → Connectors → Add custom connector.

## Cua computer-use skills (trycua/cua)

Two skills vendored from [trycua/cua](https://github.com/trycua/cua) (MIT,
`.claude/THIRD_PARTY_NOTICE_cua_LICENSE`; a copy also sits in each skill
dir), snapshot of upstream commit `681bc44`:

- **`cua-driver`** (`.claude/skills/cua-driver/`, from
  `libs/cua-driver/rust/Skills/cua-driver/`, skill v0.28.2) — drive native
  macOS/Windows/Linux GUI apps through the `cua-driver` CLI or MCP server:
  accessibility-tree snapshots, element tokens, verify-after-act. Platform
  and browser/recording/embedding guides load on demand.
- **`gui-automation`** (`.claude/skills/gui-automation/`, from `skills/`) —
  screenshot → click/type → verify loops via the `cua` Python CLI
  (`pip install cua`) against cloud VMs, Docker, Lume, or the local host.

Upstream's `jev-use` skill was left out: it's a recipe for the
`libs/cua-driver/examples/jev-use/` code inside the cua repo and has
nothing to run here.

These skills only *describe* the tools; the binaries aren't installed by
this repo. To actually use them on your machine:

```bash
# Cua Driver (macOS / Linux) — read the script before piping it to bash
/bin/bash -c "$(curl -fsSL https://cua.ai/driver/install.sh)"
claude mcp add --transport stdio cua-driver -- cua-driver mcp
# or: cua-driver mcp-config --client claude   (prints an absolute-path command)

# cua CLI for gui-automation
pip install cua
```

The `cua-driver` MCP server is intentionally **not** added to the root
`.mcp.json`: it needs a locally installed binary (plus Accessibility /
Screen Recording permission on macOS), so it would fail to start in any
session — including cloud ones — that doesn't have it.

Heads-up: `gui-automation` tells the agent to run `cua trajectory share`
at the end of every session, which uploads the recorded screenshots/actions
to cua.ai and returns a public link. Skip that step (or use
`cua do --no-record`) when the screen shows anything private.

## awesome-claude-skills roundup

The same `.claude-plugin/marketplace.json` also carries eight entries added
from a separate "AWESOME-CLAUDE-SKILLS: 12 must-have Claude skills" roundup
graphic (a hand-picked list, not the trending-claude-skills leaderboard
above). Same caveat as above: these are unvendored, unaudited pointers at
external repos — read the source before installing.

Four of the twelve skills in that roundup are already covered elsewhere in
this repo rather than duplicated in the marketplace:

- **Superpowers** — the whole framework is vendored under `.claude/skills/`
  (see the "Superpowers skills framework" section above), not just listed.
- **Brainstorming** and **TDD** (`test-driven-development`) — both ship as
  part of that same vendored Superpowers skill set.
- **UI/UX Pro Max** — fully vendored under `.claude/skills/ui-ux-pro-max/`
  and friends (see the "ui-ux-pro-max-skill (full vendor)" section above),
  not just listed.

The remaining eight were added as marketplace entries:

| Skill | Source repo |
|---|---|
| Matt Pocock Skills | [`mattpocock/skills`](https://github.com/mattpocock/skills) |
| Caveman | [`Shawnchee/caveman-skill`](https://github.com/Shawnchee/caveman-skill) |
| Humanizer | [`blader/humanizer`](https://github.com/blader/humanizer) |
| Find Skills | [`vercel-labs/skills`](https://github.com/vercel-labs/skills/tree/main/skills/find-skills) (`skills/find-skills`) |
| Deploy to Vercel | [`vercel-labs/agent-skills`](https://github.com/vercel-labs/agent-skills/tree/main/skills/deploy-to-vercel) (`skills/deploy-to-vercel`) |
| Excalidraw | [`coleam00/excalidraw-diagram-skill`](https://github.com/coleam00/excalidraw-diagram-skill) |
| Remotion | [`remotion-dev/skills`](https://github.com/remotion-dev/skills) |
| Web Quality | [`addyosmani/web-quality-skills`](https://github.com/addyosmani/web-quality-skills) |

Install any of them the same way as the trending-list entries:

```
/plugin marketplace add trial4email4timepass/free-claude
/plugin install <plugin-name>@free-claude
```

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

## khoj skill

`.claude/skills/khoj/` connects Claude Code to a self-hosted
[Khoj](https://github.com/khoj-ai/khoj) server (the "AI second brain" that
indexes your notes/docs). Khoj itself is AGPL-3.0 and is **not** vendored
here — the skill is original to this repo and just calls Khoj's HTTP API
(checked against upstream commit `ae229ca`):

- `scripts/khoj.sh search|chat|upload|files|health` — semantic search
  (`GET /api/search`), grounded Q&A (`POST /api/chat`), add files
  (`PATCH /api/content`), list indexed files.
- Configure with `KHOJ_URL` (default `http://localhost:42110`) and
  `KHOJ_API_KEY` (Khoj web app → Settings → API Keys).

Khoj Cloud (`app.khoj.dev`) has been shut down, so you need to run Khoj
yourself (`pip install 'khoj[local]'` or upstream's `docker-compose.yml`; see
<https://docs.khoj.dev/get-started/setup>).

## openviking-memory plugin (pinned)

`.claude-plugin/marketplace.json` also lists **`openviking-memory`**, the
Claude Code plugin that [volcengine/OpenViking](https://github.com/volcengine/OpenViking)
ships in `examples/claude-code-memory-plugin`. Nothing is vendored: the entry
is a `git-subdir` source **pinned to commit
`276dfffc801716c9a2abf9129ace5681fe4941a0`** (plugin v0.6.4), so upstream
changes don't reach you until the `sha` here is bumped deliberately. The
plugin's manifest declares Apache-2.0; the OpenViking repo as a whole is
AGPL-3.0.

```
/plugin marketplace add trial4email4timepass/free-claude
/plugin install openviking-memory@free-claude
```

It needs an OpenViking server you run (default `http://localhost:1933`, no
auth in local mode) or a remote one configured in `~/.openviking/ovcli.conf`
— see the plugin's
[README](https://github.com/volcengine/OpenViking/tree/276dfffc801716c9a2abf9129ace5681fe4941a0/examples/claude-code-memory-plugin).

**Know what it runs before enabling it.** It registers Node hooks on nine
events, including:

- `UserPromptSubmit` — searches the server and injects recalled memories
  into every prompt.
- `Stop` / `SubagentStop` / `PreCompact` / `SessionEnd` — **sends
  conversation turns to the OpenViking server** to be stored as memories
  (turn off with `OPENVIKING_AUTO_CAPTURE=false`).
- `PreToolUse` on `Read|Glob|Grep|Edit|Write|Bash` — a guard for
  `viking://` URIs.

It also starts a stdio MCP server (`servers/mcp-proxy.mjs`). Point it only at
a server you trust with your conversation contents. To update, review the
upstream diff for `examples/claude-code-memory-plugin`, then change the `sha`.
