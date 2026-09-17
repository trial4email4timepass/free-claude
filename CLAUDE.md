# Agent Reach — Project Notes

This is reference context on [Panniantong/Agent-Reach](https://github.com/Panniantong/Agent-Reach) so it's loaded automatically when Claude Code opens this repo. See `README.md` for the full write-up; summary below.

## What it is

Agent Reach (MIT license, Python 3.10+) is an installer/doctor/config **capability layer**, not a wrapper: it selects, installs, and health-checks the best current upstream tool for reading/searching 16 internet platforms, then lets the agent call that tool directly — no wrapping layer at read time.

**PyPI name collision:** `pip install agent-reach` resolves to an unrelated squatted package. Always install from GitHub, never PyPI, per the instructions below.

## Zero-config vs. configured platforms

- **Works immediately:** web pages (Jina Reader), YouTube captions/search (yt-dlp), RSS/Atom (feedparser), GitHub public repos (gh CLI), Bilibili search/details (bili-cli), V2EX, Xueqiu (雪球) stock data, full-web semantic search (Exa via mcporter, auto-configured, no key).
- **Needs login/config:** Twitter/X, Reddit, Facebook, Instagram, Xiaohongshu, LinkedIn (profile/company/jobs), Boss Zhipin, Xiaoyuzhou podcast transcription. The agent walks the user through "help me configure X" rather than requiring docs.

## Design

Each platform is an ordered **primary + fallback backend list** in `agent_reach/channels/*.py`, probed for real (not just checked on `$PATH`). `agent-reach doctor` reports which backend is active per platform. When an upstream tool breaks (e.g. anti-scraping), the fallback swaps in without user action.

## Installing (agent-run, one-liner)

```
Help me install Agent Reach: https://raw.githubusercontent.com/Panniantong/agent-reach/main/docs/install.md
```

```bash
# Preferred, from real GitHub source
pipx install https://github.com/Panniantong/agent-reach/archive/main.zip

# Safe, read-only check (no system changes)
agent-reach install --env=auto
agent-reach doctor
```

`agent-reach install` defaults to a **read-only check** — it does not install system packages (`gh`, `mcporter`) or write config/skill files unless `--system` is explicitly passed. `--dry-run` previews everything with no changes.

## Rules for this session

- Only run `agent-reach install --env=auto --system` or any `agent-reach configure ...` (cookie/API-key) command after the user in the current conversation has explicitly approved it.
- For platforms needing login cookies (Twitter, Xiaohongshu, Reddit, Facebook, Instagram), the project recommends a **dedicated/secondary account** — never the user's primary — due to automated-access ban risk. Surface this before helping configure one.
- Credentials live only in `~/.agent-reach/config.yaml` (mode 600), never uploaded; the codebase is fully open source and auditable.
- Never modify upstream open-source tools' internals — Agent Reach only routes/calls them.

Full install docs: https://raw.githubusercontent.com/Panniantong/agent-reach/main/docs/install.md

Links: [github.com/Panniantong/Agent-Reach](https://github.com/Panniantong/Agent-Reach)
