---
name: matraix
description: Set up and run MatrAIx (github.com/MatrAIx-ai/MatrAIx-Persona-8B), a persona-driven framework that runs sampled simulated-user personas as LLM agents through Survey, AI Chatbot, Web and OS-app tasks to evaluate AI systems and products. Use when the user mentions MatrAIx, MatrAIx-Persona-8B, Persona 1M, simulated users / persona agents for product or chatbot evaluation, the MatrAIx Playground, or wants to create or run a MatrAIx task or job.
---

# MatrAIx

[MatrAIx](https://github.com/MatrAIx-ai/MatrAIx-Persona-8B) (MIT) instantiates
persona records — built on a 1,290-dimension schema — as LLM agents and runs them
through reproducible tasks in four environments: **Survey**, **AI Chatbot**,
**Web**, and **App** (desktop/mobile). Verification and reporting roll individual
trajectories up to subgroup and population findings.

Simulated personas are for exploration, stress-testing and hypothesis
generation — **not a replacement for evidence from real people**. Say so when
presenting results.

## Requirements

- Python 3.12 and [uv](https://docs.astral.sh/uv/)
- Docker — only for Web and OS-app tasks
- Node.js 20+ — only for the Playground / viewer frontends
- A model API key for real runs (`ANTHROPIC_API_KEY` for `anthropic/claude-*`,
  `OPENAI_API_KEY` for `openai/gpt-*`; full matrix in `docs/environment/agents.md`).
  Smoke tests need no key.
- Windows: run everything inside WSL2, with the repo on the WSL filesystem.

## Install

```bash
git clone https://github.com/MatrAIx-ai/MatrAIx-Persona-8B MatrAIx && cd MatrAIx
uv venv --python 3.12
uv pip install -e .
uv pip install pytest pytest-asyncio httpx
uv pip install -e packages/playground
uv pip install -e packages/harbor-langsmith
uv pip install -e packages/rewardkit
```

## Personas

The in-repo `matraix-persona-dev-sample` (~200 personas) is for smoke only. For
real cohorts, import the public 1M coreset:

```bash
huggingface-cli download MatrAIx2026/MatrAIx_Persona_1M_Public_Release \
  --repo-type dataset \
  --local-dir persona/datasets/matraix-persona-1m/release
```

Then use `--dataset persona/datasets/matraix-persona-1m` on the CLI, or pick
`matraix-persona-1m` as the Playground dataset.

## Smoke tests (no API key)

```bash
# Survey + Chat, no Docker — should print "Smoke: ok"
uv run matraix smoke application/tasks/example-survey_product-feedback
# Web + OS-app, needs Docker — writes under jobs/harbor-smoke-local/
uv run matraix run -c configs/jobs/example-job-recipe/harbor-smoke-local.yaml
```

## Create a task

Copy the reference task for the type you need, then edit `task.toml`,
`instruction.md`, `input/` and the verifier (see `docs/application/task-guide.md`):

| Type | Reference task |
|------|----------------|
| Survey | `application/tasks/example-survey_product-feedback` |
| Chat | `application/tasks/example-chat-api_support_chatbot` |
| Web | `application/tasks/example-web-playwright_quote-choice` |
| OS-app | `application/tasks/example-computer-use-linux_note-to-csv` |

```bash
cp -R application/tasks/example-survey_product-feedback application/tasks/<your-task-name>
```

## Run a job

Generate a job recipe (pins agent + model), then run the recipe path the script
prints, applying any `export` lines it also prints:

```bash
uv run python application/scripts/generate_application_job.py \
  --task application/tasks/example-survey_product-feedback \
  --execution-mode auto \
  --persona-ids 0042 \
  --model-name anthropic/claude-sonnet-4-6
uv run matraix run -c configs/jobs/application-task-job-recipe/<printed-recipe>.yaml
uv run matraix results <job>      # summarize a finished job
```

Use `--sample-size N` for batches; filters and chat/web/os-app examples are in
`docs/quickstart.md`. Outputs land in `jobs/` (gitignored). Lower-level runtime
tools live under `uv run harbor …`.

## Playground (visual runner)

```bash
# Terminal A — API
VENV=.venv bash application/playground/backend/run_dev.sh
# Terminal B — frontend
cd application/playground/frontend && npm ci && npm run dev
```

Open http://localhost:5173 → pick a persona cohort → pick tasks →
**Lock pipeline** → **Run eval**. Keys can also go in
`application/playground/.env.local`.

## Related

- `persona-extraction-quality-check` skill (vendored alongside this one) scores
  extracted personas against their source profiles with MatrAIx's M1–M7 rubric.
  It must be run from inside a MatrAIx checkout.
- Handbook: `docs/README.md`. Paper: arXiv:2608.04205.
