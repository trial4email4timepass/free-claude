# <Plan Name> — Orchestration Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `unlazy` in orchestrated
> mode (`references/orchestration.md`) to execute this plan. Each leaf below
> owns a disjoint set of files; gates live under `gates/` — one file per
> leaf id, plus `gates/_branch.md` for whole-project checks that run once
> at the end.

**Goal:** <one sentence describing what this plan builds>

**Mode:** orchestrated

---

## Leaves

Each leaf is a self-contained unit of work. `Owns` lists the files this
leaf may create or modify — no two leaves may own the same file, and a leaf
never touches a file it doesn't own. `Needs` lists leaf ids that must be
done-and-gated before this leaf may dispatch; leave it empty for a leaf
that's ready immediately. `Tier` is the model/agent capability this leaf
dispatches on — decide it with model-router (or your own judgment if that
skill isn't installed; see `references/orchestration.md` § Model
Selection), not here.

### Leaf: <leaf-id>
- **Owns:** `path/to/file-a.ts`, `path/to/file-b.ts`
- **Needs:** (none)
- **Tier:** cheap
- **Gate:** `gates/<leaf-id>.md`

<Task-specific instructions for this leaf, or a pointer to a separate task
brief. No placeholders — a worker dispatched on this leaf alone should be
able to start from this block plus the files it names.>

### Leaf: <leaf-id>
- **Owns:** `path/to/file-c.ts`
- **Needs:** `<leaf-id>`
- **Tier:** standard
- **Gate:** `gates/<leaf-id>.md`

<...>

<!-- Add one "### Leaf: <leaf-id>" block per unit of work. -->

---

## Branch Gates

Whole-project checks that only make sense once every leaf has landed (full
build, full test suite, cross-file lint). List them here; their commands
live in `gates/_branch.md` (split into `gates/_branch-*.md` if some are
much slower than others), run exactly once after the last leaf's gate
passes — never per leaf.

- <name> — <one line on what it checks>

---

## Dispatch Log

Rolling dispatch, not fixed waves: the ready set is every leaf whose
`Needs` are all done-and-gated. Launch the whole ready set at once; the
moment a leaf's gate passes, recompute the ready set and launch whatever it
just unblocked — don't wait for sibling leaves still in flight (see
`references/orchestration.md`). This table is a log of what actually
happened, filled in as you go; it is not a schedule fixed in advance.

| # | Leaves launched together | Unblocked by | Gate result |
|---|---------------------------|--------------|-------------|
| 1 | | (plan start — `Needs` empty) | |
