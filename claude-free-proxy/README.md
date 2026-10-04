# Claude Code on free models (Groq now, NVIDIA NIM when you have a key)

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
Run it from your project folder (Claude Code starts in your current directory). Extra
arguments go to `claude`. Proxy logs go to `litellm.log` next to the script.

## Switching models

Type `/model` in Claude Code. The script loads a menu of just the free models (from
`picker-nim.json` or `picker-groq.json`, depending on which key is set), each with a label and
note. Move with the arrow keys, then:

- **`s`**: switch for this session only. Use this one.
- **Enter**: also saves the pick as your default in `~/.claude/settings.json`, which plain
  `claude` (on your Anthropic account) would then try to use. Avoid it, or switch back later.

Each session starts on **Auto** (main model plus fallbacks). To start on another model, set e.g.
`CLAUDE_FREE_MODEL=nim/kimi-k3`. The menu also keeps Claude Code's built-in "Default" row; the
proxy routes any Claude model name to the main free model, so it works too. Untested NVIDIA rows
fall back to GLM 5.3 if the model errors. Claude Code prints a one-line "isn't described by this
version's model catalog" notice for these names; it's harmless.

To add a model: add a `model_name` entry in the matching `litellm*.yaml`, then a row with the same
`model` in the picker file and in its `availableModels` list.

- **Models** (in `litellm.yaml`, Oct 2026 snapshot; check ids with the `curl`s there):
  `free-main` = Groq `moonshotai/kimi-k2-instruct-0905`, `free-fast` = Groq
  `llama-3.1-8b-instant`, `free-backup` = Gemini `gemini-3.6-flash`.
- **Why the Gemini fallback**: Groq's free tier caps tokens per minute, and Claude Code
  sends a large system prompt and tool list with every request, so some requests can be
  rejected as too large or rate-limited. LiteLLM then retries them on Gemini. Gemini's
  free tier may use prompts for training; leave `GEMINI_API_KEY` unset to opt out.
- **Switching to NVIDIA NIM**: once you have a key (build.nvidia.com/settings/api-keys, phone
  verification), just add `NVIDIA_NIM_API_KEY=nvapi-...` to the command. The script then uses
  `litellm-nim.yaml`: NIM `z-ai/glm-5.3` as main, NIM `moonshotai/kimi-k3` then Groq and Gemini
  as fallbacks. Tested end to end with a free NIM key (Oct 2026): Claude Code wrote and ran a
  file through `glm-5.3`. Some listed NIM models (e.g. `moonshotai/kimi-k2.6`) return 404 for
  free accounts and `z-ai/glm-5.3-flash` timed out, so test before swapping models. A proxy already running with the other config is restarted.
- **Without the script**: run `litellm --config litellm.yaml --host 127.0.0.1 --port 4000` (or `litellm-nim.yaml`)
  with `LITELLM_MASTER_KEY` and the provider keys set, and merge `settings-env.json` into
  `~/.claude/settings.json`, using the master key as `ANTHROPIC_AUTH_TOKEN`.
- Free models make more tool-call and edit mistakes than Claude.
