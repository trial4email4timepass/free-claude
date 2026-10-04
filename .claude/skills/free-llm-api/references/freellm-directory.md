# freellm.net directory (Oct 2026 snapshot)

Distilled from [open-free-llm-api/awesome-freellm-apis](https://github.com/open-free-llm-api/awesome-freellm-apis)
(MIT, snapshot `c2bd37c`, data dated 2026-10-03; see `../LICENSE-awesome-freellm-apis.txt`). Upstream
regenerates its README daily from [freellm.net](https://freellm.net), which has the full ~495-model
dataset, a playground, and a config generator (`freellm.net/config/`). This file is newer and wider
(30 providers) than `providers.md` (June 2026, 10 providers); prefer it for "which providers exist",
and `providers.md` for per-provider env vars and limits detail.

## Caveats before quoting anything

- **Model ids in upstream's tables are partly freellm.net slugs**, not API ids (e.g.
  `qwen-qwen3-5-35b-a3b`, `deepseek-chat-v3-2`, `grok-4-3`). Always confirm with
  `GET {base_url}/models` before putting an id in code.
- **Some listed base URLs are native, not OpenAI-compatible.** Corrected below where it matters:
  Google Gemini → `https://generativelanguage.googleapis.com/v1beta/openai/`,
  Cohere → `https://api.cohere.ai/compatibility/v1`, Ollama Cloud → `https://ollama.com/v1`.
  Cloudflare's OpenAI-compatible path is `.../accounts/{account_id}/ai/v1`.
- **"Free" varies**: xAI/Grok and Hugging Face are credit-metered; OVHcloud's quoted limit is
  anonymous use; Cerebras flags `zai-glm-4.7` as deprecated Aug 2026; Z AI's GLM-4.5-Flash has a
  retirement notice. Treat limits as a snapshot.
- Upstream lists Cline with no base URL; omitted here.

## Permanent free tiers

| Provider | OpenAI-compatible base URL | Signup | Free models | Max ctx | Notable free models (verify ids) | Limit (snapshot) |
|---|---|---|---|---|---|---|
| NVIDIA NIM | `https://integrate.api.nvidia.com/v1` | Phone verification | 132 | 1M | `z-ai/glm-5.2`, `moonshotai/kimi-k2.6`, `z-ai/glm-5.1` | up to 40 RPM |
| ModelScope | `https://api-inference.modelscope.cn/v1` | Registration | 61 | 1M | `MiniMax/MiniMax-M2.5`, Qwen3.5-35B-A3B, Qwen3.5-27B | 2,000 RPD total |
| Cloudflare Workers AI | `https://api.cloudflare.com/client/v4/accounts/{account_id}/ai/v1` | None | 40 | 262K | `@cf/meta/llama-3.3-70b-instruct-fp8-fast` | 10K neurons/day |
| OpenCode Zen | `https://opencode.ai/zen/v1` | Registration | 33 | 1M | `big-pickle`, `deepseek-v4-flash-free`, `mimo-v2.5-free` | — |
| LLM7.io | `https://api.llm7.io/v1` | None | 20 | 1M | `gpt-oss-20b`, `minimax-m2.7` | 10 RPM, 60 req/hr anon |
| Google Gemini | `https://generativelanguage.googleapis.com/v1beta/openai/` | None | 19 | 1M | `gemini-3.7-flash`, `gemini-3.6-flash`, `gemini-3.5-flash` | 15 RPM, 1,500 RPD |
| Ollama Cloud | `https://ollama.com/v1` | Registration | 17 | 1M | `deepseek-v4-pro`, `deepseek-v4-flash`, `minimax-m3` | session/weekly caps |
| Mistral AI | `https://api.mistral.ai/v1` | None | 15 | 256K | `mistral-medium-3-5-128b`, `open-mixtral-8x7b` | ~1 RPS, 500K TPM |
| Kilo Code | `https://api.kilo.ai/api/gateway` | None | 15 | 1M | `nvidia/nemotron-3-ultra-550b-a55b:free`, `stepfun/step-3.7-flash:free` | 200 req/hr |
| OVHcloud AI Endpoints | `https://oai.endpoints.kepler.ai.cloud.ovh.net/v1` | Registration | 14 | 262K | `qwen3.5-397b-a17b`, Llama 3.3 70B | 2 RPM anon |
| Groq | `https://api.groq.com/openai/v1` | None | 12 | 262K | `moonshotai/kimi-k2-instruct-0905`, `groq/compound`, `llama-3.3-70b-versatile` | 30 RPM; 14,400 RPD on small models |
| Cohere | `https://api.cohere.ai/compatibility/v1` | None | 12 | 256K | Command A / A+ / R+ | 20 RPM |
| Aion Labs | `https://api.aionlabs.ai/v1` | Registration | 11 | 131K | aion-2.0, aion-3.0 | 15 RPM, 20K TPD |
| Hugging Face | `https://router.huggingface.co/v1` | None | 9 | 131K | Llama 3.1 8B, `google/gemma-3-4b-it`, phi-4 | credit-metered |
| Z AI (Zhipu) | `https://open.bigmodel.cn/api/paas/v4` | None | 8 | 200K | `glm-4.7-flash`, `glm-4.6v-flash` | 1 concurrent request |
| Cerebras | `https://api.cerebras.ai/v1` | None | 6 | 131K | `zai-glm-4.7`, Llama 3.1 70B | 10 RPM, 100 RPD, 1M TPD |
| Agnes AI | `https://apihub.agnes-ai.com/v1` | Registration | 5 | 256K | `agnes-2.0-flash`, `agnes-image-2.0-flash` | 30 RPM |
| Alibaba Model Studio | `https://dashscope-intl.aliyuncs.com/compatible-mode/v1` | Registration | 5 | 1M | `qwen3-max`, `qwen3-plus`, `qwen3-vl-plus` | by region |
| SambaNova | `https://api.sambanova.ai/v1` | Registration | 4 | 128K | DeepSeek-V3.1/V3.2, MiniMax-M2.7 | 20 RPM, 20 RPD, 200K TPD |
| SiliconFlow | `https://api.siliconflow.cn/v1` | Registration | 3 | 131K | DeepSeek-R1-Distill-Qwen-7B, DeepSeek-OCR | 30 RPM, 60K TPM |
| xAI | `https://api.x.ai/v1` | Registration | 3 | 2M | grok-4.3, grok-4.1-fast, grok-3-mini | credit-based |
| Chutes.ai | `https://api.chutes.ai/v1` | Registration | 2 | 131K | `deepseek-ai/DeepSeek-R1` | community-powered |
| Glhf.chat | `https://glhf.chat/api/openai/v1` | Registration | 2 | 131K | Llama 3.1 70B, Mixtral 8x7B | "unlimited" free models |
| AI21 Labs | `https://api.ai21.com/studio/v1` | Registration | 2 | 256K | Jamba Large 1.7, Jamba Mini 2 | 200 RPM |
| DeepSeek | `https://api.deepseek.com/v1` | Registration | 2 | 128K | `deepseek-chat`, `deepseek-reasoner` | dynamic |
| Nscale | `https://inference.api.nscale.com/v1` | Registration | 2 | 128K | Llama 3.3 70B, R1-Distill-Llama-70B | fair-use |
| Nebius | `https://api.studio.nebius.com/v1` | Registration | 1 | 128K | Qwen3-235B-A22B | tier-based |

Renewable credits: **OpenRouter** (`https://openrouter.ai/api/v1`) — 34 `:free` models, 50 RPD, rising
to 1,000 RPD after a one-time $10 top-up. Top free models by weekly usage on 2026-10-03 were mostly
OpenRouter routes (`nvidia/nemotron-3-ultra-550b-a55b:free`, `poolside/laguna-s-2.1:free`, a
`stealth/*` model) plus NVIDIA NIM's `z-ai/glm-5.2` and `moonshotai/kimi-k2.6`. Stealth models are
usually logged for training — flag that for sensitive data.

Local, unlimited, private: Ollama, LM Studio, llama.cpp, GPT4All, Jan.ai, KoboldCpp (all can expose an
OpenAI-compatible server).

## Pointing coding tools at a free provider

**Codex CLI / Aider / Cline / Open WebUI / Cursor** speak OpenAI Chat Completions, so any row above
works: set `OPENAI_BASE_URL` + `OPENAI_API_KEY` (Codex), or Base URL + key + model in the tool's
custom-provider settings (Cursor: Settings → Models).

**Claude Code is different — it speaks the Anthropic Messages API**, not OpenAI's. Upstream's
`code-examples/claude-code.md` sets `ANTHROPIC_BASE_URL` to Groq / NVIDIA / Cloudflare / SiliconFlow
OpenAI endpoints; that does not work. Use one of:

1. A provider with an **Anthropic-compatible endpoint**, e.g. OpenRouter:
   ```bash
   export ANTHROPIC_BASE_URL="https://openrouter.ai/api"   # no /v1
   export ANTHROPIC_AUTH_TOKEN="$OPENROUTER_API_KEY"
   export ANTHROPIC_API_KEY=""                             # must be empty
   export ANTHROPIC_MODEL="<a :free model id from openrouter.ai/models>"
   ```
   Z AI, DeepSeek, and Ollama also document Anthropic-compatible endpoints; check each provider's
   current docs for the exact path before using them.
2. A **local translating proxy** (e.g. LiteLLM proxy or claude-code-router) that accepts Anthropic
   requests and forwards to any OpenAI-compatible row above.

Expect weaker tool-use than Claude itself: pick a large model with solid function calling, and know
the model name Claude Code displays may not reflect what's actually serving.
