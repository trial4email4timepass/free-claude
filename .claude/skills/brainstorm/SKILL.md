---
name: brainstorm
description: Generate creative and original ideas for any topic. Use when the user asks to brainstorm, wants a list of ideas, or is stuck looking for a starting point.
metadata:
  short-description: Generate original ideas for any topic
---

# Brainstorm

## Goal
Produce a wide, varied set of original ideas for the user's topic — not a narrow, obvious list.

## Inputs to gather (ask only if truly missing)
- Topic or problem statement
- Any constraints (budget, audience, format, tone, platform)
- How many ideas / how wild they can be (safe vs. bold)

## Workflow
1. Restate the topic in one line to confirm understanding.
2. Generate ideas across multiple angles: obvious, adjacent, and unconventional. Don't stop at the first batch that comes to mind — actively vary the angle (functional, emotional, contrarian, low-cost, high-effort).
3. Group ideas loosely by theme or angle so the list is scannable, not a flat wall.
4. For each idea, give a one-line gist — enough to evaluate, not a full spec.
5. Flag the 2-3 ideas you'd personally pursue first, with a one-line reason why.

## Output template
```markdown
# Brainstorm: <topic>

## <Theme A>
- **Idea 1** — one-line gist
- **Idea 2** — one-line gist

## <Theme B>
- **Idea 3** — one-line gist
...

## Worth pursuing first
1. <idea> — why
2. <idea> — why
```

## Avoid
- Listing only safe, expected ideas
- Padding with near-duplicates
- Over-explaining each idea before the user has picked a direction
