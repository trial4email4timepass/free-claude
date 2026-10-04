# Claude Code on NVIDIA NIM (free)

Runs Claude Code against NVIDIA NIM's free models through a local LiteLLM proxy,
which translates Claude Code's Anthropic-format requests to NIM's OpenAI format.

1. Get a free key at <https://build.nvidia.com/settings/api-keys> (phone verification; ~40 req/min).
2. `pip install 'litellm[proxy]'`
3. `NVIDIA_NIM_API_KEY=nvapi-... ./claude-nim.sh`

`claude-nim.sh` starts the proxy on `127.0.0.1:4000` if it isn't running, generates a
proxy master key once (`~/.config/claude-nim/master_key`, mode 600; current LiteLLM
refuses to start without one), and launches `claude` with the right env vars.
Extra arguments go to `claude`. Proxy logs go to `litellm.log`.

- **Models**: `free-main` (`moonshotai/kimi-k2.6`) and `free-fast` (`z-ai/glm-5.1`) in
  `litellm.yaml`, from an Oct 2026 snapshot. Check current ids with the `curl` in that file.
- **Rate limits**: uncomment the Groq `free-backup` block and `fallbacks` line in
  `litellm.yaml` and set `GROQ_API_KEY`.
- **Without the script**: run `litellm --config litellm.yaml --host 127.0.0.1 --port 4000`
  with `LITELLM_MASTER_KEY` set, and merge `settings-env.json` into `~/.claude/settings.json`,
  using that key as `ANTHROPIC_AUTH_TOKEN`.
- Free models make more tool-call and edit mistakes than Claude; use a large model.
