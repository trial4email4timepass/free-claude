# free-claude

A collection of publicly available [Claude Code skills](https://code.claude.com/docs/en/skills), gathered from the [Skillselion](https://skillselion.com/skills) directory and downloaded directly from each skill's own upstream GitHub repository.

Skills live under [`.claude/skills/`](.claude/skills/) and are auto-discovered by Claude Code. See [`CATALOG.md`](CATALOG.md) for the full list, grouped by source repo, with descriptions, licenses, and the exact commit each skill was pulled from.

## Provenance

For every skill:

1. Skillselion's public API (`GET https://skillselion.com/api/v1/listings`) was used only to discover *which* skills exist and *where* their real source repo is — its own hosted copy of skill content was never trusted or used.
2. The skill's actual `SKILL.md` (and any supporting files) was pulled from the skill's real upstream GitHub repository at the commit recorded in `CATALOG.md`.
3. Each source repo was scanned for common red flags (piped-curl-to-shell installers, `eval`/`exec` on untrusted input, base64-obfuscated payloads, destructive `rm -rf`) before its skills were added. None were found.

Skills from small or unverified individual authors, and a duplicate Lark skill set with no fetchable GitHub source, were intentionally left out — see the "Not imported" section of `CATALOG.md`.

Automated scanning is not a substitute for reading a skill yourself before trusting it with real tool access — skills are instructions (and sometimes scripts) that execute with whatever permissions the agent running them has.
