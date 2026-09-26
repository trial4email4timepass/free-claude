---
name: persona
description: Create detailed customer personas based on the target market. Use when the user needs specific, named personas to guide product, content, or marketing decisions.
metadata:
  short-description: Create detailed customer personas
---

# Persona

## Goal
Create one or more specific, usable customer personas — detailed enough to make decisions with, not generic archetypes.

## Inputs to gather (ask only if truly missing)
- Product/service and target market (reuse `audience` skill output if available)
- Number of personas wanted (default 1-3; more than 3 usually dilutes usefulness)
- B2C or B2B (B2B personas need role/seniority/buying-committee context)

## Workflow
1. Ground each persona in the real target audience — don't invent an idealized user disconnected from who'd actually buy/use this.
2. Give each persona a name and a one-line summary, then flesh out: goals, frustrations/pain points, what triggers them to seek a solution, objections/hesitations, where they spend time/get information.
3. Tie the persona back to the product: what specifically would make this persona choose (or reject) it.
4. Keep it realistic — include at least one real objection or friction point, not just a wish-list customer.

## Output template
```markdown
# Persona: <Name>, <one-line summary>

**Goals:** <what they want>
**Frustrations:** <what's in their way>
**Trigger:** <what makes them look for a solution now>
**Objections:** <why they might not buy/use it>
**Where they are:** <channels, communities, info sources>

**Why they'd choose this product:** <specific fit>
**Why they might not:** <specific friction>
```

## Avoid
- Personas with no flaws or objections (unrealistic and unusable)
- Personas that are just demographics with a stock photo description
- Too many personas diluting focus
