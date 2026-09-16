# Orchestrated Mode — the Driver Loop

Orchestrated mode is for plans whose leaves own disjoint files (see
`templates/PLAN.md`): that disjointness is what makes concurrent dispatch
safe, and this loop is how to use it. If the plan is small (a handful of
one-file leaves) or the leaves aren't really independent, don't reach for
this — dispatch them yourself inline. See "When Not To Use" in `SKILL.md`.

## The naive version, and why it's slow

The obvious driver loop reads: dispatch leaf 1, wait, verify leaf 1 fully,
dispatch leaf 2, wait, verify leaf 2 fully, and so on. Two costs stack on
every leaf:

1. **Lockstep dispatch.** Leaf 2 waits for leaf 1's subagent to return even
   when leaf 2's `Needs` don't mention leaf 1 — the two own disjoint files,
   so nothing stops them running at the same time.
2. **Whole-tree verify.** A bare `gate-check.mjs` globs `gates/*.md` —
   every leaf gate in the plan, not just the one that just landed.
   "Verifying leaf 1" this way silently re-runs leaf 7's gate too, and does
   it again for leaf 2, leaf 3, ... N times over by the time N leaves are
   done.

Neither cost is necessary. Rolling dispatch below replaces both.

## Rolling dispatch

State: `done` (leaf ids, gate-passed), `in_flight` (leaf ids, subagent
dispatched, not yet returned), `ready` (leaf ids whose `Needs ⊆ done`, not
yet in `done` or `in_flight`).

1. **Load the plan.** Parse every leaf's `Owns`, `Needs`, `Tier`, `Gate`
   from `PLAN.md`. Confirm `Owns` sets are pairwise disjoint across all
   leaves — if two leaves claim the same file, that's a plan defect, not
   something this loop can arbitrate; fix the plan before dispatching
   anything.
2. **Seed `ready`** with every leaf whose `Needs` is empty.
3. **Drain `ready` into `in_flight`.** Dispatch every leaf currently in
   `ready` in the same turn — one subagent per leaf, on its `Tier` (see
   Model Selection below). This is the same "issue every dispatch in one
   response" rule as dispatching-parallel-agents: nothing here waits for a
   sibling leaf it doesn't `Need`.
4. **On each return** (handle them in whatever order they actually come
   back — do not wait for the rest of the current `in_flight` batch):
   - Run `node gate-check.mjs gates/<leaf-id>.md` — that leaf's file
     alone, never the bare glob.
   - **Pass:** move the leaf from `in_flight` to `done`. Recompute `ready`
     from the leaves not yet in `done` or `in_flight` whose `Needs ⊆ done`,
     and go straight back to step 3 for whatever just became ready — don't
     wait to batch it with the next return.
   - **Fail:** run this leaf's fix loop (below) before moving it to
     `done`. Other leaves already `in_flight` keep running unaffected;
     this leaf's failure only blocks whatever `Needs` it.
5. **When `done` covers every leaf**, run the branch gates exactly once —
   `node gate-check.mjs gates/_branch.md` (or `--jobs N` across several
   branch-gate files). This is the one whole-project check the whole plan
   pays for; every leaf gate before it was scoped and cheap.

Steps 3 and 4 interleave in real execution: by the time the first wave's
slowest leaf returns, later waves may already be several leaves deep. The
`Dispatch Log` table in `PLAN.md` is where you record what actually
happened — it's a log of this loop's real timeline, filled in as you go,
not a schedule fixed before dispatch begins.

## Fix loop (per leaf, on gate failure)

Scoped to the one leaf that failed, same shape as subagent-driven-
development's fix loop but run against this leaf's own gate only:

1. Resume the leaf's implementer with the gate's failing command(s) and
   their output.
2. Re-run `node gate-check.mjs gates/<leaf-id>.md` — still scoped, still
   never the bare glob.
3. Three rounds on the same subagent; round 4 escalates to a fresh
   implementer one tier above this leaf's `Tier`. A leaf still failing
   past round 5 is a plan defect (its `Owns`/`Needs` most likely don't
   match what the code actually requires) — stop dispatching leaves that
   `Need` it, surface the block, and don't let it silently starve the rest
   of the graph.

A failing leaf never re-triggers another leaf's gate — gates are scoped
precisely so one leaf's churn can't force redundant re-verification
elsewhere in the tree.

## Model Selection (Tier)

Tiering is model-router's call, not this document's: when writing a plan's
`Tier` column, route it through model-router if it's installed. Expect it
to bail on a small plan and say to just dispatch the leaves with ordinary
judgment — a handful of one-file leaves doesn't need a routing pass any
more than five inline edits need five subagents. Without model-router
installed, fall back to the shape used elsewhere in this skills
collection (see subagent-driven-development's Model Selection): cheap for
mechanical single-file leaves with a complete spec, standard for
multi-file integration leaves, capable for anything needing design
judgment. Always pass the resolved tier explicitly when dispatching — an
omitted model inherits the session's, usually the most expensive one
available.
