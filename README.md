# free-claude

A Claude Code plugin marketplace aggregating every entry currently listed by the
[`linny006/trending-claude-skills`](https://github.com/linny006/trending-claude-skills)
leaderboard.

## ⚠️ Read before installing anything

This marketplace is a **mechanical listing**, not a curated or reviewed one. Each
entry below simply points at its original external GitHub repository via the
plugin `source` field — nothing from any of these repos has been vendored,
cloned, or audited here.

The upstream leaderboard ranks repos by recency/momentum in GitHub search
results, not by quality or trustworthiness. Many entries have zero stars,
unknown authors, and generic/auto-generated-looking descriptions. A skill's
instructions are executed as trusted input by whatever agent installs it, so
installing one from this list means running unaudited third-party
instructions and code with your agent's permissions.

Before installing any plugin from this marketplace:

- Open its source repo and read the actual skill/plugin files yourself.
- Check who the author is and whether the repo has any real history/activity.
- Prefer entries with meaningful star counts and identifiable maintainers.
- Assume nothing here has been vetted for correctness, safety, or intent.

## Using this marketplace

```
/plugin marketplace add trial4email4timepass/free-claude
/plugin install <plugin-name>@free-claude
```

See [`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json) for
the full list of plugin names and their source repos. Because these are
third-party repos with no guaranteed structure, not every entry is
guaranteed to install cleanly as a Claude Code plugin.

## How this list is generated

This file and the manifest were built once from a snapshot of the upstream
leaderboard's README. The upstream tracker refreshes every 15 minutes; this
repo does not currently auto-sync with it, so entries here may drift from
the live leaderboard over time.
