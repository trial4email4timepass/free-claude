# Claude Code on free models (Groq, with Gemini fallback)

Runs Claude Code against free models through a local LiteLLM proxy, which
translates Claude Code's Anthropic-format requests to the OpenAI format these
providers accept.

1. Get a free Groq key at <https://console.groq.com/keys> (email signup, no card).
2. Optional but recommended: a free Gemini key at <https://aistudio.google.com/app/apikey>.
3. `pip install 'litellm[proxy]'`
4. `GROQ_API_KEY=gsk_... GEMINI_API_KEY=... ./claude-free.sh`

`claude-free.sh` starts the proxy on `127.0.0.1:4000` if it isn't running, generates a
proxy master key once (`~/.config/claude-free/master_key`, mode 600; current LiteLLM
refuses to start without one), and launches `claude` with the right env vars.
Extra arguments go to `claude`. Proxy logs go to `litellm.log`.

- **Models** (in `litellm.yaml`, Oct 2026 snapshot; check ids with the `curl`s there):
  `free-main` = Groq `moonshotai/kimi-k2-instruct-0905`, `free-fast` = Groq
  `llama-3.1-8b-instant`, `free-backup` = Gemini `gemini-3.6-flash`.
- **Why the Gemini fallback**: Groq's free tier caps tokens per minute, and Claude Code
  sends a large system prompt and tool list with every request, so some requests can be
  rejected as too large or rate-limited. LiteLLM then retries them on Gemini. Gemini's
  free tier may use prompts for training; leave `GEMINI_API_KEY` unset to opt out.
- **NVIDIA NIM instead**: a commented block in `litellm.yaml` swaps it in as `free-main`
  (needs phone verification and `NVIDIA_NIM_API_KEY`).
- **Without the script**: run `litellm --config litellm.yaml --host 127.0.0.1 --port 4000`
  with `LITELLM_MASTER_KEY` and the provider keys set, and merge `settings-env.json` into
  `~/.claude/settings.json`, using the master key as `ANTHROPIC_AUTH_TOKEN`.
- Free models make more tool-call and edit mistakes than Claude.
