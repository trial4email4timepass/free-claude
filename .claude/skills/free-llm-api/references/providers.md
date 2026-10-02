# Free provider reference

Limits and model lists come from the RealTask/free-llm-api catalog (researched
June 2026); base URLs are the providers' documented OpenAI-compatible
endpoints (corrected where upstream code differed). Free model ids rotate, so
list live models with `GET {base_url}/models` before hard-coding one.

## LLM / chat

### Google AI Studio (Gemini API)
- Base URL (OpenAI-compatible): `https://generativelanguage.googleapis.com/v1beta/openai/`
- Env var: `GOOGLE_AI_STUDIO_API_KEY` (key from aistudio.google.com)
- Limits: Gemma 3 up to 14,400 req/day, 30 req/min, 15K tok/min. Gemini Flash models have much lower free caps.
- Models: `gemma-3-27b-it`, `gemma-3-12b-it`, `gemma-3-4b-it`, `gemma-3-1b-it`; Gemini Flash / Flash-Lite family (e.g. `gemini-2.5-flash`, `gemini-2.5-flash-lite`); TTS `gemini-2.5-flash-tts`.
- Notes: free-tier prompts may be used to improve Google products; not for sensitive data. Best for high-volume prototyping.

### Groq
- Base URL: `https://api.groq.com/openai/v1`
- Env var: `GROQ_API_KEY`
- Limits (per model): `llama-3.1-8b-instant` 14,400 req/day, 6K tok/min; `allam-2-7b` 7,000 req/day; larger models ~1,000 req/day with higher tok/min; Whisper 2,000 req/day.
- Models: `llama-3.1-8b-instant`, `llama-3.3-70b-versatile`, `allam-2-7b`, `openai/gpt-oss-120b`, `openai/gpt-oss-20b`, `qwen/qwen3-32b`, `groq/compound`, `groq/compound-mini`, Llama 4 Scout; STT `whisper-large-v3`, `whisper-large-v3-turbo`.
- Best for: speed-critical apps, agent loops, bulk processing.

### Cerebras
- Base URL: `https://api.cerebras.ai/v1`
- Env var: `CEREBRAS_API_KEY`
- Limits: 30 req/min, 900 req/hr, 14,400 req/day, 60K tok/min, 1M tok/day.
- Models: `gpt-oss-120b`, `llama3.1-8b`.
- Best for: high-volume, high-throughput workloads.

### OpenRouter
- Base URL: `https://openrouter.ai/api/v1`
- Env var: `OPENROUTER_API_KEY`
- Limits: 20 req/min; 50 req/day baseline, 1,000 req/day after a one-time $10 credit purchase. Free models end in `:free`.
- Free models (snapshot): gpt-oss-120b/20b, Gemma 4 26B/31B, Nemotron 3 (nano/mini/120B), Qwen3 Coder, Qwen3 Next 80B, Hermes 3 405B, Dolphin Mistral 24B, and others.
- Notes: some free routes log/train on prompts per the upstream host's policy; check the model page.
- Best for: trying many models behind one key; also offers embeddings.

### Mistral La Plateforme
- Base URL: `https://api.mistral.ai/v1`
- Env var: `MISTRAL_API_KEY`
- Limits: free "Experiment" tier, ~1 req/s, 500K tok/min, ~1M tokens/month (upstream README also cites up to 1B tokens/month; verify). Requires phone verification.
- Models: Mistral Small/Medium/Large, `codestral-*`, `ministral-3b`.
- Best for: European users, enterprise prototyping, code (Codestral).

### Cloudflare Workers AI
- Base URL: `https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/ai/v1`
- Env vars: `CLOUDFLARE_API_KEY` (API token with Workers AI permission), `CLOUDFLARE_ACCOUNT_ID`
- Limits: daily free "neuron" allowance shared across models.
- Models (snapshot): `@cf/openai/gpt-oss-120b`, `@cf/openai/gpt-oss-20b`, `@cf/google/gemma-4-*`, `@cf/qwen/qwen3-30b-a3b-fp8`, `@cf/meta/llama-3.3-70b-instruct-fp8-fast`, `@cf/meta/llama-4-scout-17b-16e-instruct`, Mistral Small 3.1, Qwen 2.5 Coder 32B, Kimi, GLM, Nemotron, and more.
- Best for: edge/serverless apps already on Cloudflare.

### NVIDIA NIM (build.nvidia.com)
- Base URL: `https://integrate.api.nvidia.com/v1`
- Env var: `NVIDIA_API_KEY`
- Limits: ~40 req/min on the free developer tier.
- Models: Llama 3.x, Mistral/Mixtral, Qwen 2.5 (incl. coder), Gemma 2, and many more in the catalog.
- Best for: evaluating NVIDIA-optimized open models.

### GitHub Models
- Base URL: `https://models.github.ai/inference`
- Env var: a GitHub token with `models:read` (upstream used `GITHUB_COPILOT_API_KEY`; `GITHUB_TOKEN` is the common choice)
- Limits: low per-day caps that depend on your Copilot plan (upstream estimate ~100 req/day, ~30 req/min); input/output token caps per request.
- Models (snapshot): GPT-4.1 / 4.1-mini, o-series, DeepSeek R1/V3, Llama 3.x/4, Mistral, Phi-4, Codestral, Cohere Command A.
- Best for: prototyping inside GitHub workflows with frontier models.

### Cohere
- Base URL (OpenAI-compatible): `https://api.cohere.ai/compatibility/v1`
- Env var: `COHERE_API_KEY` (trial key)
- Limits: 20 req/min, 1,000 req/month; trial keys are not for production.
- Models: Command A (incl. reasoning, vision, translate), Command R / R+ / R7B, Aya Expanse / Aya Vision.
- Best for: enterprise prototyping, multilingual (Aya), vision.

### Hugging Face Inference Providers
- Base URL (OpenAI-compatible router): `https://router.huggingface.co/v1`
- Env var: `HUGGINGFACE_API_KEY` (HF token)
- Limits: small monthly credit (upstream: $0.10/month free); serverless models <10GB.
- Models: Llama 3.x, Mistral/Mixtral, Qwen 2.5 (incl. coder), Gemma 2, Phi-3.
- Best for: testing and model evaluation, not volume.

### Vercel AI Gateway
- Base URL: `https://ai-gateway.vercel.sh/v1`
- Env var: `AI_GATEWAY_API_KEY` (upstream used `VERCEL_AI_API_KEY`)
- Limits: small monthly free credit (upstream estimate ~$5).
- Best for: apps already hosted on Vercel.

## Speech

| Provider | Kind | Model | Free limit | Env var |
|---|---|---|---|---|
| Groq | STT | `whisper-large-v3`, `whisper-large-v3-turbo` | 2,000 req/day | `GROQ_API_KEY` |
| Google AI Studio | TTS | `gemini-2.5-flash-tts` | ~3 req/min, ~10 req/day | `GOOGLE_AI_STUDIO_API_KEY` |
| Local Whisper | STT | `whisper-large-v3(-turbo)` | Unlimited (hardware) | none; `WHISPER_BASE_URL` for a local server |

Groq STT: `POST https://api.groq.com/openai/v1/audio/transcriptions` (multipart, `model`, `file`).

## Embeddings

| Provider | Models | Free limit | Notes |
|---|---|---|---|
| Local (sentence-transformers / TEI) | `all-MiniLM-L6-v2`, `all-mpnet-base-v2`, `BAAI/bge-*-en-v1.5`, `intfloat/e5-*-v2`, `thenlper/gte-*` | Unlimited | Free and private; best default |
| Cloudflare Workers AI | `@cf/baai/bge-small/base/large-en-v1.5`, plus others | Daily neuron allowance | Same account/env vars as chat |
| OpenRouter | Various | Shares the LLM quota | One key for chat + embeddings |

## Image generation

| Option | Models | Free limit | Notes |
|---|---|---|---|
| Stable Diffusion 3.5 (local, ComfyUI/A1111) | SD 3.5, SDXL | Unlimited (hardware) | Check the Stability community license for commercial use |
| FLUX (local, ComfyUI) | `FLUX.1-dev`, `FLUX.1-schnell` | Unlimited (hardware) | schnell is Apache-2.0; dev is non-commercial |
| Google AI Studio | Gemini image models | Low free caps, region-dependent | Uses `GOOGLE_AI_STUDIO_API_KEY` |
| Cloudflare Workers AI | `@cf/black-forest-labs/flux-1-schnell`, SDXL variants | Neuron allowance | Hosted, no GPU needed |

Upstream also lists Midjourney, GPT Image, Imagen, and Adobe Firefly; these
are paid or trial-only, and Midjourney has no public API.

## Where to check current limits

- Google: ai.google.dev/gemini-api/docs/rate-limits
- Groq: console.groq.com/docs/rate-limits
- Cerebras: inference-docs.cerebras.ai (rate limits)
- OpenRouter: openrouter.ai/docs/api-reference/limits
- Mistral: admin.mistral.ai (workspace limits)
- Cloudflare: developers.cloudflare.com/workers-ai/platform/pricing
- NVIDIA: build.nvidia.com
- GitHub Models: docs.github.com/github-models (rate limits)
- Cohere: docs.cohere.com/docs/rate-limits
- Hugging Face: huggingface.co/docs/inference-providers (pricing)
