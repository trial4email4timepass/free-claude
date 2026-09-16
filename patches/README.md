# Patches for bytedance/deer-flow

This repo (`trial4email4timepass/free-claude`) is reference notes about
[bytedance/deer-flow](https://github.com/bytedance/deer-flow), not a copy of
its application code (see the root `README.md`). This session had no push
access to `bytedance/deer-flow` itself, so a requested code change to that
project is delivered here as a patch file instead of a direct commit/PR
against the upstream repo.

## `0001-deer-flow-multi-provider-fallback.patch`

Adds opt-in cross-provider LLM fallback to DeerFlow: a `models[]` entry can
declare `fallback_models: [other-model-name, ...]`, and if a request to that
model exhausts its own retry budget (sustained rate limit, busy provider,
burst-rate throttle) or is rejected for a quota/billing or authentication
reason, `LLMErrorHandlingMiddleware` retries the same request against each
fallback model in turn — e.g. pointing a Claude model at an OpenAI model so a
run survives a Claude-side rate limit instead of failing outright.

Built and fully tested (`uv sync` + `pytest` + `ruff`) against a fresh shallow
clone of `bytedance/deer-flow` at commit `0efdf8e7d8d2c4f976abd2f4c05fd012e6c317c4`
(2026, `2.0`/main branch). See the patch's own commit message for the full
design writeup, or `backend/docs/CONFIGURATION.md`'s new "Model fallback"
section and `config.example.yaml`'s worked example once applied.

### Applying it

From a clone of `bytedance/deer-flow`, on the commit above (or a nearby one —
the patch only touches `config.example.yaml`, `backend/docs/CONFIGURATION.md`,
and a handful of files under `backend/packages/harness/deerflow/` and
`backend/tests/`):

```bash
git am patches/0001-deer-flow-multi-provider-fallback.patch
# or, without creating a commit:
git apply patches/0001-deer-flow-multi-provider-fallback.patch
```

Then run the backend test suite (`cd backend && uv sync && uv run pytest`) to
confirm it still applies cleanly against the current `main`.
