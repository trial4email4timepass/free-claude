# Claude Code on OpenRouter (free models)

Runs Claude Code against OpenRouter's `:free` models. OpenRouter accepts the
Anthropic Messages API directly, so unlike [`../claude-on-nim`](../claude-on-nim)
no LiteLLM proxy is needed.

1. Get a key at <https://openrouter.ai/keys>.
2. `OPENROUTER_API_KEY=sk-or-v1-... ./claude-openrouter.sh`

Extra arguments go to `claude`. Pick a model with `OPENROUTER_MODEL`, and optionally a
cheaper one for background tasks with `OPENROUTER_FAST_MODEL`:

```bash
OPENROUTER_MODEL=poolside/laguna-s-2.1:free ./claude-openrouter.sh
```

To skip the script, put the same `ANTHROPIC_*` variables from `claude-openrouter.sh`
under `"env"` in `~/.claude/settings.json`. Keep the key out of any file you commit.

## Models

Free models that support tool calls, tested with Claude Code 2.1.289 in October 2026.

| Model | Fix a one-line bug (Read + Edit) | Write a module until its pytest suite passes (Read, Write, Bash) |
| --- | --- | --- |
| `nvidia/nemotron-3-ultra-550b-a55b:free` (default) | pass, 11s | pass, 61s |
| `nvidia/nemotron-3-super-120b-a12b:free` | pass | not run (hit the daily cap) |
| `nvidia/nemotron-3.5-lightning:free` | pass, 7s | not run (hit the daily cap) |
| `poolside/laguna-s-2.1:free` | pass, 14s | not run (hit the daily cap) |
| `poolside/laguna-xs-2.1:free` | pass, 22s | not run |
| `cohere/north-mini-code:free` | pass, 4s | not run |
| `qwen/qwen3.8-27b:free` | pass, 24s | not run |
| `apodex/apodex-1.1-mini:free` | pass, 11s | not run |
| `inclusionai/ling-3.0-flash-sante:free` | pass, 6s | not run |
| `thinkingmachines/inkling:free` | pass, 4s | not run |

- `thinkingmachines/inkling*:free` only accept requests from agent tools such as
  Claude Code. Plain API calls to them get a `permission_error`.
- `dots-studio/dots-3-note-preview:free` and `google/gemma-4-31b-it:free` returned
  errors on tool calls.
- List the current free models with
  `curl -s https://openrouter.ai/api/v1/models | jq -r '.data[].id | select(endswith(":free"))'`.

## Limits

- **Without credits: 50 free-model requests per day.** Each Claude Code turn makes
  several requests, so a single session can use up the allowance. Adding 10 credits
  raises the cap to 1000 requests per day, and `:free` models still cost nothing.
- Claude Code prints a notice that the model "isn't described by this version's model
  catalog" and assumes a 200k context window. The notice is harmless. If the model's
  window is smaller, set `CLAUDE_CODE_MAX_CONTEXT_TOKENS` to it.
- Free models make more tool-call and edit mistakes than Claude, and some free
  endpoints log prompts for training. Don't send code you can't share.
