# Gate Format

A gate is a markdown file `gate-check.mjs` can run. Two kinds, told apart by
where they live:

- **Leaf gates** — `gates/<leaf-id>.md`, one per leaf. Covers only the
  checks that verify *that leaf's* owned files: its own tests, its own
  typecheck scoped to its files, nothing whole-project. Verified once,
  right after that leaf's dispatch returns.
- **Branch gates** — `gates/_branch.md` (or several `gates/_branch-*.md`
  files, e.g. split by check duration). Whole-project checks: full build,
  full suite, repo-wide lint. Verified exactly once, after every leaf is
  done-and-gated — never per leaf. A branch-wide check living inside a leaf
  gate is a plan defect; move it out.

## File shape

````markdown
# Gate: <id>

Scope: leaf | branch

## Checks

```sh
<shell command>
<shell command>
USE: <shared-check-name>
```
````

- The `## Checks` heading is required; `gate-check.mjs` reads the first
  fenced code block after it and treats each non-blank, non-`#`-comment
  line as one command, run in order, in the repo root, stopping at the
  first failure within this file — later commands in a gate often assume
  earlier ones' side effects, so a fail-fast build-then-test gate is normal
  and expected.
- `Scope:` is documentation, not parsed — it tells a human (or the next
  editor of the plan) what class of check they're looking at. What actually
  decides whether a check runs per-leaf or once-per-branch is which file it
  lives in and when the driver loop invokes that file (see
  `orchestration.md`).
- A `USE: <name>` line pulls in a **shared check** instead of writing a
  literal command — see below. Order still matters: put the `USE:` line
  where its side effect needs to happen relative to the file's other
  commands.

## Shared checks

Checks repeated across leaves (typecheck, a lint command, a shared build
step) belong in `gates/_shared.md` once, not copy-pasted into every leaf
gate:

````markdown
# Shared Checks

### typecheck
```sh
npm run typecheck
```

### lint
```sh
npm run lint
```
````

A leaf gate pulls one in with `USE: typecheck` on its own line inside its
`## Checks` block. `gate-check.mjs` resolves it against `gates/_shared.md`
in the same gates directory and inlines that named block's commands at that
point in the sequence. `_shared.md` is a library, not a gate itself: it has
no `## Checks` heading, and `gate-check.mjs` never runs it directly — the
default bare glob (`gates/*.md`) skips it for exactly that reason. Naming
it explicitly and literally (no wildcard) on the command line is a caller
mistake and surfaces as a usage error, not a silent no-op.

## Running gates

```sh
# One leaf, right after its dispatch returns — fast, scoped:
node gate-check.mjs gates/leaf-2-auth.md

# Several gate files at once, run concurrently (across files only — each
# file's own commands still run in order):
node gate-check.mjs gates/leaf-2-auth.md gates/leaf-3-api.md --jobs 2

# Branch gates, once, after every leaf is done:
node gate-check.mjs gates/_branch.md

# Bare: globs gates/*.md — the whole tree except _shared.md. Reserve this
# for a final human/CI sanity sweep, not per-leaf verification; use --jobs
# to keep it fast when there are many gate files.
node gate-check.mjs --jobs 4
```

## Exit codes (stop-hook compatible)

| Code | Meaning | Stop-hook effect |
|------|---------|-------------------|
| `0` | every check in every file given passed | hook allows the stop |
| `2` | at least one check failed | hook blocks the stop; stderr names the failing file(s), and stdout carries the failing command and its output tail — read together they're the reason fed back to Claude |
| `1` | usage error (no gate files matched, a file is missing its `## Checks` block, an unresolved `USE:` name, a bad `--jobs` value) | not a gate failure — fix the invocation or the gate file; the driver loop's fix loop (`orchestration.md`) doesn't apply here |

Wire it into a project's own `.claude/settings.json` as a Stop hook so a
session can't claim a plan is done while a gate is red:

```json
{
  "Stop": [
    {
      "matcher": "*",
      "hooks": [
        { "type": "command", "command": "node .claude/skills/unlazy/gate-check.mjs" }
      ]
    }
  ]
}
```

The bare invocation is intentional here: a Stop hook is exactly the
whole-tree sanity sweep this format reserves the bare glob for, not a
per-leaf check.
