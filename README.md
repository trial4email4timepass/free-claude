# Playwright Skill — Repo Overview

Notes on [lackeyjb/playwright-skill](https://github.com/lackeyjb/playwright-skill), based on its GitHub repository page and README.

## What it is

Playwright Skill is a general-purpose **Agent Skill** that lets coding agents (Claude Code, Cursor, GitHub Copilot, Codex, Gemini CLI, OpenCode, etc.) write and execute Playwright automation on the fly — from a quick page check to a multi-step browser flow. It's also packaged as a Claude Code Plugin for easy installation.

- License: MIT
- Stack: JavaScript (100%)
- ~3.1k stars / ~240 forks, 1 branch, 9 tags at time of writing
- Made using Claude Code

The agent decides on its own when to invoke the skill, based on the automation task at hand, and loads only the documentation it needs for that task (progressive disclosure).

## Why this skill (vs. alternatives)

- Use **this skill** when the agent needs to write a real Playwright *program*: loops, assertions, multiple browser contexts, network interception, screenshots/video, or a script worth keeping and rerunning.
- For simple interactive browsing, prefer Microsoft's official `@playwright/cli` (`playwright-cli install --skills`).
- For tool-based browser control via accessibility snapshots, prefer `playwright-mcp`.
- This project is the code-first option for when the generated automation script is itself the useful artifact.

## Features

- **Any automation task** — Claude writes custom code per request rather than running from a fixed script library
- **Visible browser by default** — `headless: false` so automation is watchable in real time
- **Portable executor** (`run.js`) — runs file and inline scripts with stable module resolution
- **Progressive disclosure** — a concise `SKILL.md`, with the full API reference loaded only when needed
- **Safe cleanup** — temp file management without race conditions
- **Comprehensive helpers** — optional utility functions for common tasks

## Repository layout

This repo uses the **plugin** format, with the skill nested inside it:

```
playwright-skill/                 # Plugin root
├── .claude-plugin/
│   ├── plugin.json               # Plugin metadata for distribution
│   └── marketplace.json          # Marketplace configuration
├── skills/
│   └── playwright-skill/         # The actual skill (Claude discovers this)
│       ├── SKILL.md              # What Claude reads
│       ├── run.js                # Universal executor (module resolution)
│       ├── package.json          # Dependencies & setup scripts
│       ├── lib/helpers.js        # Optional utility functions
│       └── API_REFERENCE.md      # Full Playwright API reference
├── tests/
├── README.md
├── CONTRIBUTING.md
└── LICENSE
```

Installers handle the nested `skills/playwright-skill/` layout automatically; manually copying that subdirectory is only a fallback for clients without an installer.

## Installation

### Option 1 (recommended): the `skills` CLI

```bash
# Global, all supported agents
npx skills add lackeyjb/playwright-skill --skill playwright-skill --global --yes

# Project-only (omit --global)
npx skills add lackeyjb/playwright-skill --skill playwright-skill --yes

# Target specific agents
npx skills add lackeyjb/playwright-skill --skill playwright-skill --agent claude-code cursor --global --yes
```

After installing, run setup from the installed skill directory: `npm run setup`.

### Option 2: Claude Code Plugin

```bash
/plugin marketplace add lackeyjb/playwright-skill
/plugin install playwright-skill@playwright-skill
cd ~/.claude/plugins/marketplaces/playwright-skill/skills/playwright-skill
npm run setup
```

Verify with `/help`.

### Option 3: other Agent Skill clients

Agent Skills are supported by Claude Code, Cursor, GitHub Copilot, Codex, Gemini CLI, OpenCode, and others. Copy `skills/playwright-skill/` into the client's documented skill directory and run `npm run setup` there.

### Option 4: download a release

Copy `skills/playwright-skill/` from a GitHub Release into:
- Global: `~/.claude/skills/playwright-skill`
- Project: `/path/to/project/.claude/skills/playwright-skill`

Then `cd` into it and run `npm run setup`.

Verify any install by asking the agent to perform a simple browser task, e.g. "Test if google.com loads".

## Usage examples

- **Test any page** — "Test the homepage", "Check if the contact form works", "Verify the signup flow"
- **Visual testing** — "Take screenshots of the dashboard in mobile and desktop", "Test responsive design across viewports"
- **Interaction testing** — "Fill out the registration form and submit it", "Click through the main navigation", "Test the search functionality"
- **Validation** — "Check for broken links", "Verify all images load", "Test form validation"

## How it works

1. Describe what you want to test or automate.
2. The agent writes custom Playwright code for the task.
3. The universal executor (`run.js`) runs it with proper module resolution.
4. The browser opens (visible by default) and the automation executes.
5. Results — console output and screenshots — are returned.

## Configuration defaults

- `headless: false` — browser is visible unless explicitly requested otherwise
- Slow motion: `0ms` by default; set `SLOW_MO` when useful
- Screenshots: helper screenshots default to the OS temp directory; set `PW_ARTIFACT_DIR` to change it

## Advanced usage

Claude automatically loads `API_REFERENCE.md` when it needs details on selectors, network interception, authentication, visual regression testing, mobile emulation, performance testing, or debugging.

## Dependencies

- Node.js
- Playwright (installed via `npm run setup`)
- Chromium (installed via `npm run setup`; `npm run install-all-browsers` for all browsers)

## Troubleshooting

- **Playwright not installed** — run `npm run setup` from the skill directory.
- **Module not found** — make sure automation runs via `run.js`, which handles module resolution.
- **Browser doesn't open** — confirm `headless: false`; the skill defaults to a visible browser unless headless mode is requested.

## Contributing

Fork, branch, make changes, submit a PR. See `CONTRIBUTING.md` in the repo for details.

## Links

- Repo: https://github.com/lackeyjb/playwright-skill
- Agent Skills specification: https://github.com (open spec referenced from the repo)
- Full API reference: `skills/playwright-skill/API_REFERENCE.md` in the repo
- Contributors: lackeyjb, claude, dependabot[bot], cderv, luantaraschi
