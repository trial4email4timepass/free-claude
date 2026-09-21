---
name: jev-ultrafast
description: Drive a fast, natural-language browser agent via the jev-ultrafast library (browser-use/jev-ultrafast) — a Chrome-based agent that picks an indexed CLICK/TYPE_TEXT/SELECT/SCROLL/WAIT/DONE action per step instead of generating selectors or scripts. Use when the user wants to automate a browser task from a plain-language goal (form fills, search flows, flight/hotel lookups, "go to this site and find/click/verify X"), or explicitly mentions jev-ultrafast, TypeSafe's Jev, or Browser Harness. Not a general Playwright/Selenium replacement for scripted, deterministic test suites — see the webapp-testing skill for that.
---

# jev-ultrafast

Wraps [browser-use/jev-ultrafast](https://github.com/browser-use/jev-ultrafast) (MIT), a browser agent that
gives one natural-language goal per task and lets TypeSafe's Jev model choose an operation
(`CLICK`, `TYPE_TEXT`, `SELECT`, `SCROLL_UP`, `SCROLL_DOWN`, `WAIT`, `DONE`, `BLOCKED`) and a target from an
indexed element table on each step. A small text LLM only fires when the operation is `TYPE_TEXT`. No
site-specific scripts, no selectors, no generated code executes in the browser.

## When to use it

- The task is "open this URL and accomplish this goal in plain language" — flight/hotel search, filling a
  form, finding and clicking through to a specific piece of content, verifying an outcome is visible.
- Speed matters and the target sites are ordinary web UIs (buttons, comboboxes, textboxes, native selects).

## When not to use it

- Deterministic, selector-based test assertions for a codebase already under test — use the
  `webapp-testing` skill (Playwright) instead.
- Shadow DOM-heavy apps, canvas UIs, file uploads, pop-up tabs, nested scroll containers, or arbitrary
  keyboard-driven widgets — explicitly out of scope for this MVP per upstream's README.
- Anything requiring the agent to run injected JavaScript, coordinates, or raw selectors — this library
  never lets the model emit those; don't try to route around that design.

## Setup

Not installed globally — clone it fresh into a scratch location and run with `uv`:

```bash
git clone https://github.com/browser-use/jev-ultrafast.git
cd jev-ultrafast
uv sync
cp .env.example .env
# Fill in TYPESAFE_API_KEY and TEXT_MODEL_API_KEY (an OpenRouter key works out of the box).
```

Required env vars (`.env`):

| Var | Purpose |
| --- | --- |
| `TYPESAFE_API_KEY` | Auth for TypeSafe's Jev operation/target model |
| `TYPESAFE_MODEL` | Defaults to `jev-latest` |
| `TEXT_MODEL_API_KEY` | OpenAI-compatible key for the `TYPE_TEXT` text helper |
| `TEXT_MODEL_BASE_URL` | e.g. `https://openrouter.ai/api/v1` |
| `TEXT_MODEL` | e.g. `inception/mercury-2.5` |
| `TEXT_MODEL_REASONING` | `none` in the example config |

Chrome connects through [Browser Harness](https://github.com/browser-use/browser-harness) (installed
transitively by `uv sync`). If it can't connect, run `uv run browser-harness --doctor` and allow remote
debugging in Chrome when prompted.

Without both API keys set, don't attempt to run the agent — tell the user what's missing rather than
guessing at a config.

## Usage

**Interactive inspector** (numbered elements, operation/target probabilities, step-through):

```bash
uv run jev
# open http://127.0.0.1:8766, click "Start demo → Run automatically"
```

**As a library**, one goal (or an ordered list of goals) against a URL:

```python
from jev_ultrafast import Agent

with Agent(
    "https://www.google.com/travel/flights?hl=en",
    "Find one-way flights from Zurich to London on <date>, for one adult in economy. "
    "Stop when matching flight options are visible.",
) as agent:
    for state in agent.run():
        print(state["elapsed_ms"], state["status"])
    print(state["page"]["url"])
```

Run any such script with `uv run --env-file .env python your_script.py` from inside the cloned repo. Pass
multiple goals as an ordered list (`Agent(url, [goal_1, goal_2, ...])`) to chain steps.

`examples/run.py` is a ready-made CLI:

```bash
uv run --env-file .env python examples/run.py --url <URL> --goal '<goal>'
```

## Verifying results

A `DONE` state from the agent is **not** proof of success — it only means the model believes the goal is
satisfied. Independently verify the outcome (read `state["page"]`, re-query the DOM, or assert on visible
text) before reporting the task complete, the same way `examples/flights.py` checks the actual
route/date/results after the agent stops rather than trusting `DONE` alone.

## Reference

- [README](https://github.com/browser-use/jev-ultrafast/blob/main/README.md) — action space, architecture
  diagram, performance numbers, file-by-file guide (`jev_ultrafast/agent.py` is the full loop).
- [AGENTS.md](https://github.com/browser-use/jev-ultrafast/blob/main/AGENTS.md) — upstream's own contributor
  rules: no site-specific plans/hardcoded fields, never let the model emit selectors/code, cache a
  `TYPE_TEXT` retry only while its entire helper input is unchanged, never retry a browser mutation, keep
  `.env` ignored, tests must not call paid APIs.
- `docs/performance.md` in the repo — timing methodology and raw measurement traces.
