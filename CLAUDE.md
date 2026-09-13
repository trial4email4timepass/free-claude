# PraisonAI — Project Notes

This is reference context on [MervinPraison/PraisonAI](https://github.com/MervinPraison/PraisonAI) so it's loaded automatically when Claude Code opens this repo. See `README.md` for the full write-up; summary below.

## What it is

PraisonAI is an open-source framework (MIT license, mostly Python with a TypeScript/Rust footprint) for building autonomous, self-improving AI agents — single agents or full multi-agent teams — with built-in memory, knowledge/RAG, guardrails, and 100+ LLM provider support. Deployable in ~5 lines of Python or no-code YAML.

## The five-layer agent stack

1. **Prompt** — `instructions=`, role/goal/backstory, `output=`
2. **Context** — `memory=`, `knowledge=`, `context=`, handoffs
3. **Harness** — `tools=`, `MCP()`, `guardrails=`, `approval=`, `hooks=`, `sandbox=`
4. **Loop** — `execution=ExecutionConfig(...)`, `reflection=`, `autonomy=`, doom-loop detection
5. **Graph** — `AgentFlow`, `route()`, `parallel()`, `loop()`, `repeat()`

Plus an outer **Managed** layer for where it runs: `tools_run_on="docker"` (only tools move) or `run_on="anthropic"` (whole agent hosted).

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

## Ecosystem

- `praisonaiagents` — core SDK (`pip install praisonaiagents`)
- `praisonai` — CLI (`pip install praisonai`)
- Claw Dashboard 🦞 — Telegram/Slack/Discord/WhatsApp bots (`praisonai[claw]`)
- Flow Visual Builder — drag-and-drop workflows (`praisonai[flow]`)
- PraisonAI UI — chat interface (`praisonai[ui]`)
- JS SDK — `npm install praisonai`

## Key features

MCP protocol, planning mode, deep research, external agent orchestration (Claude Code/Gemini CLI/Codex), agent handoffs, guardrails, web search+fetch, self reflection, workflow patterns (route/parallel/loop/repeat), zero-dependency memory (or Postgres/MySQL/SQLite/MongoDB/Redis-backed), 100+ LLM providers.

## Performance

~14 μs average agent instantiation time.

Links: [praison.ai/docs](https://praison.ai/docs) · [github.com/MervinPraison/PraisonAI](https://github.com/MervinPraison/PraisonAI)
