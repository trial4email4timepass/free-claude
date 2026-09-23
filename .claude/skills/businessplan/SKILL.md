---
name: businessplan
description: Create a structured business plan for a specific idea. Use when the user wants a business plan document covering the idea, market, model, and execution.
metadata:
  short-description: Create a structured business plan
---

# Business Plan

## Goal
Produce a structured, honest business plan — including risks — for a specific business idea, sized to what the user actually needs (a one-pager vs. a full plan).

## Inputs to gather (ask only if truly missing)
- The business idea/concept
- Target market (if known)
- Purpose of the plan (internal clarity, pitching investors, a lean canvas, a bank loan) — this changes depth and tone
- Any known constraints (budget, timeline, solo vs. team)

## Workflow
1. Clarify the plan's purpose before writing — an investor plan and a personal clarity doc look different.
2. Cover, at minimum: problem, solution, target market, business model (how it makes money), competitive landscape (brief; use `competitor` skill for depth), go-to-market, and key risks.
3. Be concrete about the revenue model and unit economics if enough info is available — don't hand-wave "the business will monetize through X" without a mechanism.
4. Include a risks/open-questions section — a plan that hides its weak points is less useful, not more persuasive.

## Output template
```markdown
# Business Plan: <name>

## Problem
<what pain point exists>

## Solution
<what the business does about it>

## Target market
<who, size if known>

## Business model
<how it makes money>

## Go-to-market
<how first customers are acquired>

## Competitive landscape
<brief — key players and differentiation>

## Risks & open questions
- <risk 1>
- <risk 2>
```

## Avoid
- Vague monetization ("ads and premium features") with no mechanism
- Skipping risks to make the plan sound more confident
- Writing a 10-page plan when the user wanted a one-pager
