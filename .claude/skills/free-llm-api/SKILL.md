---
name: free-llm-api
description: Recommend and wire up free-tier or completely free AI model APIs (LLM chat, coding, embeddings, speech-to-text, text-to-speech, image generation) with their daily/minute limits, signup requirements, and OpenAI-compatible endpoints. Use when the user asks for a free LLM API, a no-cost alternative to a paid model, which free provider fits a use case (high volume, coding agent, STT, embeddings, images), how to get around rate limits with fallback across free providers, or how to call Groq, Google AI Studio, OpenRouter, Cerebras, Mistral, Cloudflare Workers AI, NVIDIA NIM, GitHub Models, Cohere, Hugging Face, ModelScope, Kilo Code, OpenCode Zen, SambaNova, Z AI, or other free providers, or how to point Claude Code, Codex CLI, Cursor, or Aider at a free model backend.
metadata:
  short-description: Pick and call free LLM/AI APIs
  source: https://github.com/RealTask/free-llm-api (MIT, snapshot f2bb6dd, data researched June 2026); https://github.com/open-free-llm-api/awesome-freellm-apis (MIT, snapshot c2bd37c, data 2026-10-03)
---

# Free LLM API catalog

Pick a free AI API that fits the user's job, tell them the real limits and
signup cost, and give them a working call. Based on the
[RealTask/free-llm-api](https://github.com/RealTask/free-llm-api) catalog
(MIT, see `LICENSE.txt`), with endpoints corrected (see "Upstream code
caveats" below).

## Ground rules

- **Limits are a June 2026 snapshot.** Free tiers change without notice. Say
  so when quoting numbers, and point the user at the provider's limits page
  (`references/providers.md`) before they build on one. If live web access
  is available and the decision matters, check the current page.
- **Limits are per account, not per key.** Making more keys doesn't add
  quota; multi-account abuse breaks most providers' terms. Don't suggest it.
- **Data policy differs.** Some free tiers (notably Google AI Studio's free
  tier and some OpenRouter `:free` routes) may use prompts for training. Flag
  this for anything sensitive or proprietary.
- **Keys go in env vars**, never in code or commits. Use the env var names in
  the table below.
- Most providers below speak the **OpenAI Chat Completions format**, so the
  `openai` SDK (or any OpenAI-compatible client) works by swapping
  `base_url` + key + model. Prefer that over the upstream Python package.

## Quick picks by use case

| Use case | Best free pick | Free limit (snapshot) | Why |
|---|---|---|---|
| General chat, highest volume | Google AI Studio — Gemma 3 27B | 14,400 req/day, 30 req/min | Most generous; Apache-licensed open models |
| Speed / coding agent loop | Groq — `llama-3.1-8b-instant` | 14,400 req/day, 6K tok/min | Very fast inference |
| Bigger open model, fast | Cerebras — `gpt-oss-120b` / `llama3.1-8b` | 14,400 req/day, 30 req/min, 1M tok/day | High throughput |
| Bulk / batch processing | Groq — `allam-2-7b` | 7,000 req/day | High daily cap |
| Many models behind one key | OpenRouter — `:free` models | 20 req/min, 50 req/day (1,000/day after $10 lifetime top-up) | 20+ free models, one API |
| Large monthly token budget | Mistral La Plateforme | ~1M tokens/mo free (upstream also cites up to 1B), 1 req/s | Needs phone verification |
| Edge / serverless | Cloudflare Workers AI | daily neuron allowance | Runs next to Workers; also embeddings |
| Speech-to-text | Groq — `whisper-large-v3` / `-turbo` | 2,000 req/day | Production-grade Whisper |
| Text-to-speech | Google AI Studio — `gemini-2.5-flash-tts` | ~3 req/min, ~10 req/day | Small but free |
| Embeddings | Cloudflare `@cf/baai/bge-*` or local `sentence-transformers` | Cloudflare allowance / unlimited locally | Local is free and private |
| Image generation | Stable Diffusion 3.5 / FLUX.1-dev locally | Unlimited (your hardware) | No platform cap |
| Enterprise prototyping | Cohere trial key | 20 req/min, 1,000 req/month | Not for production use |

Full per-provider details, model lists, and env vars: `references/providers.md`.
Trial-credit (not free forever) providers: `references/trial-credits.md`.
Wider, newer directory (30 providers, Oct 2026, from freellm.net) plus how to
point Claude Code / Codex / Cursor at a free backend:
`references/freellm-directory.md`. Note Claude Code needs an
Anthropic-compatible endpoint or a translating proxy, not a plain
OpenAI-compatible base URL.

## Workflow

1. **Pin down the job**: modality (chat, code, embeddings, STT, TTS, image),
   expected volume (requests/day, tokens/min), latency needs, whether data
   is sensitive, and whether they can do phone verification or add a card.
2. **Recommend one primary + one fallback** from the table, with the limit
   that will bite first (usually tokens/min, not requests/day) and the
   signup requirement.
3. **Give a working call** using the OpenAI-compatible pattern below, with
   the right `base_url`, env var, and a current model id. Tell them to check
   `GET {base_url}/models` for the live model list, since free model ids
   rotate.
4. **If volume exceeds one free tier**, give them the fallback chain pattern
   below instead of suggesting extra accounts.

## OpenAI-compatible call (Python)

```python
import os
from openai import OpenAI

# Swap these three for any provider in references/providers.md
client = OpenAI(
    base_url="https://api.groq.com/openai/v1",
    api_key=os.environ["GROQ_API_KEY"],
)
resp = client.chat.completions.create(
    model="llama-3.1-8b-instant",
    messages=[{"role": "user", "content": "Explain recursion in one paragraph."}],
)
print(resp.choices[0].message.content)
```

Same shape with `curl`:

```bash
curl -s https://api.groq.com/openai/v1/chat/completions \
  -H "Authorization: Bearer $GROQ_API_KEY" -H "Content-Type: application/json" \
  -d '{"model":"llama-3.1-8b-instant","messages":[{"role":"user","content":"hi"}]}'
```

## Fallback across free providers

When one free tier is rate-limited (HTTP 429) or down (5xx), move to the
next instead of hammering it:

```python
import os
from openai import OpenAI, RateLimitError, APIStatusError, APIConnectionError

CHAIN = [  # (base_url, env var, model) — order by preference
    ("https://api.groq.com/openai/v1", "GROQ_API_KEY", "llama-3.1-8b-instant"),
    ("https://api.cerebras.ai/v1", "CEREBRAS_API_KEY", "llama3.1-8b"),
    ("https://generativelanguage.googleapis.com/v1beta/openai/", "GOOGLE_AI_STUDIO_API_KEY", "gemma-3-27b-it"),
    ("https://openrouter.ai/api/v1", "OPENROUTER_API_KEY", "openai/gpt-oss-20b:free"),
]

def chat(messages):
    last = None
    for base_url, key_env, model in CHAIN:
        key = os.environ.get(key_env)
        if not key:
            continue
        try:
            client = OpenAI(base_url=base_url, api_key=key, max_retries=1)
            r = client.chat.completions.create(model=model, messages=messages)
            return r.choices[0].message.content
        except RateLimitError as e:
            last = e
        except APIStatusError as e:
            if e.status_code < 500:
                raise  # bad request / auth: fix it, don't fall through
            last = e
        except APIConnectionError as e:
            last = e
    raise RuntimeError(f"all free providers failed: {last}")
```

Respect `Retry-After` on 429s if you retry the same provider, and cache
identical prompts to stretch daily caps.

## Upstream code caveats

The RealTask repo also ships a Python package (`FreeLLMAPI`, `llmapi` CLI,
`llmapi-server` FastAPI app). Prefer direct OpenAI-compatible calls over it:
several of its hard-coded base URLs don't match the providers' documented
endpoints (e.g. Groq `https://api.groq.com/v1` instead of
`/openai/v1`, Cerebras `api.cerebras.net` instead of `api.cerebras.ai`,
NVIDIA `api.nvidia.com` instead of `integrate.api.nvidia.com`, GitHub Models
pointing at a Copilot path), and some listed services (Midjourney, Imagen,
Adobe Firefly "free tier") have no free public API in the form shown.
`references/providers.md` uses the corrected endpoints. If the user wants to
use the package anyway, tell them to verify each provider's `BASE_URL`
first.
