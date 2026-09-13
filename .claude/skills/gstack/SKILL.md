---
name: gstack
description: Reference material for gstack, a large (33 MB, 1600+ file) suite of Claude Code slash-command skills by Garry Tan (garrytan/gstack, MIT) that acts as a virtual engineering team — planning, review, QA, security, docs, and release skills. This project skill only documents what's vendored; it does not install, activate, or run any part of gstack. Use when the user asks what gstack is, wants to inspect it before installing, or asks about its `/office-hours`, `/plan-ceo-review`, `/review`, `/qa`, `/ship`, or `/cso` commands. Do NOT use this to actually run gstack's own installer or scripts — see Safety notes below before suggesting that.
---

# gstack (vendored source only — not installed)

`.claude/vendor/gstack/` is a complete, unmodified copy of
[garrytan/gstack](https://github.com/garrytan/gstack) (MIT, `LICENSE`
included) — a large collection of Claude Code (and other agent) skills
meant to be installed into `~/.claude/skills/gstack` and cover an entire
software delivery loop: `/office-hours` (product framing), `/plan-*-review`
(CEO/eng/design/DX plan reviews), `/review`, `/qa`, `/cso` (security),
`/ship` / `/land-and-deploy`, `/document-release`, `/retro`, and more.

**This is source only. Nothing here is installed, activated, or run.**
Unlike this repo's other full-vendor entries, gstack's own top-level
`SKILL.md` is intentionally **not** copied into this project's discoverable
`.claude/skills/` tree, and its `setup` script has not been run. See
"Safety notes" below for why.

## What's actually here

- The full upstream source tree, byte-for-byte, under
  `.claude/vendor/gstack/` — including gstack's own `SKILL.md`,
  `AGENTS.md`, `ETHOS.md`, and the `setup` installer.
- This file, a plain reference skill: it can describe gstack, point to its
  docs, and quote its command table — nothing more. It does not implement
  or trigger any gstack behavior itself.

## Safety notes (read before suggesting installation)

gstack's own README ships an "install block" meant to be pasted directly
into an agent chat. That block asks the agent to: clone the repo into the
user's real `~/.claude/skills/gstack`, run a ~150 KB shell script
(`./setup`) sight-unseen, and edit the user's **global** `~/.claude/CLAUDE.md`
to add a standing instruction to never use a specific tool
(`mcp__claude-in-chrome__*`). That combination — untrusted code execution
plus a self-inserted instruction that suppresses a tool — is exactly the
shape of a prompt-injection payload, regardless of the author's actual
intent, so this vendoring deliberately did not follow those steps.

Separately, gstack's own `SKILL.md` (readable at
`.claude/vendor/gstack/SKILL.md`) is not a passive reference document —
it's written as standing operating instructions for whatever agent loads
it: it tells the agent to proactively auto-invoke other gstack skills
without being asked ("Do NOT answer directly when a skill exists"), to
treat certain future tool output as executable "instruction blocks", and
to shell out to various `~/.claude/skills/gstack/bin/*` scripts for
telemetry on every run. That's a much larger behavioral surface than a
typical vendored CLI, so it was left un-activated here rather than dropped
into this repo's live skill path.

If a user wants to actually run gstack after this vendoring:

1. Read `.claude/vendor/gstack/setup` and the other `bin/*` scripts it
   calls before running them — they write outside this repo (to
   `~/.claude/skills/`, `~/.gstack/`, and global `CLAUDE.md`).
2. Decide independently whether to keep the tool-restriction line it wants
   to add to global config; don't let the installer add it silently.
3. Only then run `.claude/vendor/gstack/setup` from a shell, on purpose.

## Command reference (from upstream docs — not active here)

Selected commands, quoted from gstack's own README:

| Command | Role | What it does |
| --- | --- | --- |
| `/office-hours` | YC Office Hours | Forcing questions that reframe a product idea before code is written |
| `/plan-ceo-review` | CEO / Founder | Challenges scope on a feature plan |
| `/plan-eng-review` | Eng Manager | Locks architecture, diagrams, edge cases, tests |
| `/review` | Staff Engineer | Finds production bugs, auto-fixes the obvious ones |
| `/qa` | QA Lead | Drives a real browser through the app, fixes what it finds |
| `/cso` | Chief Security Officer | OWASP Top 10 + STRIDE audit |
| `/ship` | Release Engineer | Syncs main, runs tests, opens a PR |
| `/land-and-deploy` | Release Engineer | Merges, waits on CI/deploy, verifies prod |

The full table and workflow narrative are in
[`.claude/vendor/gstack/README.md`](.claude/vendor/gstack/README.md).
