# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

`free-claude` is not an application — it's a personal Claude Code
configuration repo: a bundle of vendored skills/agents/commands plus a
`.claude-plugin/marketplace.json` pointing at third-party plugin repos.
Opening this repo in Claude Code loads all of it (agents, commands, skills,
the `.mcp.json` server, the SessionStart hooks) as project-level config.

There is no `main`/`master` branch — the repo's default branch is
periodically repointed at whatever feature branch was merged most recently
(currently `claude/agent-reach-install-walkj4`). Branch off the current
default, not off an assumption of `main`.

## Commands

- **Audit context-mode health**: `python3 context_mode_doctor.py .` — checks
  `CLAUDE.md` size/presence, `.claude/settings*.json` and `.mcp.json`
  validity, context-window bloat from always-loaded files, and stray
  secrets in tracked config. This is the only CI job
  (`.github/workflows/context-mode-doctor.yml`, runs on every push/PR).
  Exit code is 1 if any check FAILs.
- No build step, package manager, or test suite — this repo has no source
  code of its own beyond `context_mode_doctor.py`.

## Structure

- `.claude-plugin/marketplace.json` — a mechanical, **unvetted** listing of
  external plugin repos scraped from the `linny006/trending-claude-skills`
  leaderboard. Nothing in it is vendored, reviewed, or audited; it's just
  pointers via `source.repo`. Don't add entries here casually or treat them
  as trusted — see the warnings in `README.md` before installing any of
  them.
- `.claude/vendor/claude-plugins-official/{plugins,external_plugins}/<name>/`
  — unmodified, complete copies of the plugins bundled in
  `anthropics/claude-plugins-official` (Apache 2.0). This is the source of
  truth; everything below is derived/flattened from it:
  - `.claude/skills/<name>/` — each plugin's `skills/<name>/`, flattened.
  - `.claude/commands/<plugin-name>/*.md` — each plugin's commands,
    giving namespaced slash commands like `/code-review:code-review`.
  - `.claude/agents/<plugin-name>-<agent-name>.md` — each plugin's agents,
    flattened into one directory to avoid name collisions.
- `.claude/skills/` also holds the vendored **Superpowers** framework (TDD,
  systematic debugging, brainstorming, subagent-driven development, etc.,
  v6.3.0 from `obra/superpowers`) and the `frontend-design` skill from
  `anthropics/skills`, plus this repo's own `perplexity-search` skill.
- `.claude/hooks/` — two independent `SessionStart` hooks, both wired up in
  `.claude/settings.json` and both run every session:
  - `session-start.sh` — installs/updates the `graphifyy` CLI and registers
    its `/graphify` skill, but only when `CLAUDE_CODE_REMOTE=true`; a no-op
    everywhere else.
  - `session-start` — injects the full `using-superpowers` skill content as
    session context so Superpowers skills are discoverable without an
    explicit first read.
- Six plugins under `.claude/vendor/` ship a `hooks/hooks.json`
  (`claude-security`, `hookify`, `learning-output-style`,
  `explanatory-output-style`, `ralph-loop`, `security-guidance`) that are
  **intentionally not** merged into `.claude/settings.json` — they run
  LLM calls, shell/Python on tool-use events, or a self-referential loop,
  which is too high blast-radius to enable by default in a shared repo. To
  turn one on deliberately, either copy its hook entry into
  `.claude/settings.json` (replacing `${CLAUDE_PLUGIN_ROOT}` with the
  vendored path) or install the plugin for real with
  `/plugin install <name>@claude-plugins-official`.
- `.mcp.json` — only the `perplexity` MCP server is wired up at the repo
  root. `external_plugins/<name>/.mcp.json` files live inside their own
  plugin directories and are reference-only; Claude Code doesn't auto-load
  them from there.

## Working in this repo

- When adding a new vendored plugin, keep the flattening convention:
  skills go under `.claude/skills/<name>/`, commands under
  `.claude/commands/<plugin-name>/`, agents flattened as
  `.claude/agents/<plugin-name>-<agent-name>.md`.
- `context_mode_doctor.py` treats any `CLAUDE.md` (root or nested) as
  always-loaded context — keep this file lean, since the doctor WARNs past
  ~8k tokens and FAILs past ~25k.
