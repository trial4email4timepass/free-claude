# free-claude

This repo exists to install and use [Agent Reach](https://github.com/Panniantong/agent-reach)
(web/Twitter/YouTube/Reddit/GitHub/etc. reading tools for AI agents) inside
Claude Code sessions.

## Installing Agent Reach

**Do not `pip install agent-reach`** — that name is squatted on PyPI by an
unrelated project (`jgalea/agent-reach`). Always install from the real
project's GitHub source:

```bash
# Preferred
pipx install https://github.com/Panniantong/agent-reach/archive/main.zip

# If pipx is unavailable / PEP 668 "externally-managed-environment" blocks pip:
pip3 install --user "agent-reach @ https://github.com/Panniantong/agent-reach/archive/main.zip"
```

Then run the safe, read-only check (makes no changes):

```bash
agent-reach install --env=auto
agent-reach doctor
```

Only run `agent-reach install --env=auto --system` (installs system
packages like `gh`, `mcporter`, writes config) after the user in the
current conversation has explicitly approved it. Same for any
`agent-reach configure ...` command that stores cookies/API keys — ask
first, and prefer a dedicated/secondary account for any platform that
needs login cookies (Twitter, Reddit, XiaoHongShu, etc.), per the
project's own security guidance.

Full instructions: https://raw.githubusercontent.com/Panniantong/agent-reach/main/docs/install.md
