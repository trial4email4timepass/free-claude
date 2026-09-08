# Playwright Skill — Project Notes

This is reference context on [lackeyjb/playwright-skill](https://github.com/lackeyjb/playwright-skill) so it's loaded automatically when Claude Code opens this repo. See `README.md` for the full write-up; summary below.

## What it is

Playwright Skill is a general-purpose Agent Skill (MIT license, JavaScript) that lets coding agents write and execute Playwright browser automation on the fly — from a simple page check to a multi-step flow — rather than relying on pre-built scripts. It's also packaged as a Claude Code Plugin. Claude decides on its own when to use it and loads only the docs needed for the task at hand.

## When to use it vs. alternatives

- This skill: real Playwright *programs* — loops, assertions, multiple contexts, network interception, screenshots/video, scripts worth keeping.
- `@playwright/cli` (Microsoft, official): simple interactive browsing (`playwright-cli install --skills`).
- `playwright-mcp`: tool-based control via accessibility snapshots.

## Repo layout (plugin format)

```
skills/playwright-skill/
├── SKILL.md          # concise entry point Claude reads
├── run.js            # universal executor, stable module resolution
├── package.json      # deps + `npm run setup`
├── lib/helpers.js     # optional utility functions
└── API_REFERENCE.md  # full Playwright API reference, loaded on demand
```

## Install (quick reference)

```bash
npx skills add lackeyjb/playwright-skill --skill playwright-skill --global --yes
# then, from the installed skill dir:
npm run setup
```

Claude Code plugin alternative: `/plugin marketplace add lackeyjb/playwright-skill` then `/plugin install playwright-skill@playwright-skill`.

## Defaults

- `headless: false` (visible browser by default)
- `SLOW_MO=0` unless set
- Screenshot helpers write to OS temp dir unless `PW_ARTIFACT_DIR` is set

## Troubleshooting

- Not installed → `npm run setup` in the skill directory.
- Module not found → ensure execution goes through `run.js`.
- Browser doesn't open → check `headless: false` is set.

Links: [github.com/lackeyjb/playwright-skill](https://github.com/lackeyjb/playwright-skill)
