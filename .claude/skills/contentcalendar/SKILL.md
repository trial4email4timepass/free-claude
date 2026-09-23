---
name: contentcalendar
description: Create a strategic content calendar for consistent publishing. Use when the user wants a scheduled publishing plan across dates/weeks, not just a list of content ideas.
metadata:
  short-description: Build a dated content publishing calendar
---

# Content Calendar

## Goal
Produce a dated, sequenced publishing schedule that balances content pillars and cadence — not just a bucket of ideas with no timeline.

## Inputs to gather (ask only if truly missing)
- Time horizon (e.g. 4 weeks, 1 month) and posting cadence (posts/week)
- Content pillars or themes (reuse output from `contentplan` if available)
- Key dates to plan around (launches, events, holidays)
- Platform(s)

## Workflow
1. Confirm cadence and horizon; compute the total number of slots to fill.
2. Distribute pillars across slots so no single pillar dominates and variety is maintained week to week.
3. Slot in any key dates first (launches/events), then fill the rest.
4. For each slot, give a specific content idea and format — not just "pillar name" repeated.
5. Flag any week that's thin or overloaded relative to the plan.

## Output template
```markdown
# Content Calendar: <horizon>
**Cadence:** <N posts/week> · **Platform(s):** <platforms>

## Week 1
- <Day> — <format> — <idea> *(Pillar: <name>)*
- <Day> — <format> — <idea> *(Pillar: <name>)*

## Week 2
...

## Notes
- Key dates covered: <list>
- Pillar balance: <summary>
```

## Avoid
- A calendar that's just the content plan with dates slapped on, unbalanced across pillars
- Vague slots ("post something about X") instead of a real idea
