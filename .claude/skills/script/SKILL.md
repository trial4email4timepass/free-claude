---
name: script
description: Create an engaging script for a video, Reel, or presentation. Use when the user needs full spoken/written script content, not just an outline.
metadata:
  short-description: Write a script for video, Reel, or presentation
---

# Script

## Goal
Write a complete, speakable script — real sentences the user (or a presenter) can read aloud, not bullet notes.

## Inputs to gather (ask only if truly missing)
- Topic/purpose of the script
- Format (Reel/short video, long-form video, live presentation) and target length
- Tone/voice (casual, authoritative, funny, urgent)
- Call to action, if any

## Workflow
1. Open with a hook (see the `hooks` skill's patterns if useful) — the first line must earn attention.
2. Structure the body around one clear throughline: a single problem/promise, not several competing ideas.
3. Write in spoken language — short sentences, contractions, natural rhythm. Read it back mentally for awkward phrasing.
4. Mark pacing/delivery notes inline where useful (pause, emphasis, on-screen text cue) without cluttering the read.
5. End with a clear, specific CTA — not a generic "let me know what you think."

## Output template
```markdown
# Script: <title>
**Format:** <platform> · **Target length:** <time>

[HOOK]
<line>

[BODY]
<script text, broken into short paragraphs or numbered beats>

[CTA]
<closing line>
```

## Avoid
- Written-for-reading prose instead of spoken language
- Burying the point in throat-clearing before the hook
- Multiple CTAs diluting the ask
