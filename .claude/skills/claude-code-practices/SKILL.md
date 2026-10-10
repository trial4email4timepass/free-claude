---
name: claude-code-practices
description: Practical playbook for getting more out of Claude Code across a project's lifecycle — context and memory management, MCP server setup, automation/scraping workflows, cost and token optimization, deployment, and client/project workflow. Use when the user asks how to work more effectively with Claude Code, set up CLAUDE.md, reduce token spend, wire up MCP servers, automate recurring tasks, or structure client/agency work done with Claude Code.
---

# Claude Code Practices

A practical reference covering the recurring problem areas teams hit when
building with Claude Code day to day: keeping context lean, wiring up
integrations, automating repeat work, controlling cost, shipping safely,
and running client engagements. Each section is self-contained — jump to
whichever applies.

## 1. Memory & context optimization

- **CLAUDE.md is the project's standing memory.** Put things here that are
  true on every session: build/test/lint commands, directory conventions,
  things Claude keeps getting wrong. Don't paste transient state (current
  bug, today's TODO) — that belongs in the conversation, not the file.
- **Keep CLAUDE.md short.** It's loaded into every session's context
  whether needed or not. A few dense bullet points beat a long prose doc.
  Prefer pointers ("see `docs/architecture.md`") over inlining large docs.
- **Use subagents to protect the main context window.** Delegate
  broad, read-heavy exploration (searching an unfamiliar codebase,
  running a big test suite and summarizing failures) to a subagent so
  only the summary — not every file it read — lands in the main
  conversation.
- **Compact or clear deliberately.** When a task is done and the next one
  is unrelated, start fresh rather than letting old context linger and
  compete for attention with what actually matters right now.
- **Scope instructions to where they apply.** A monorepo with different
  conventions per package should use a `CLAUDE.md` per directory rather
  than one giant root file trying to cover everything.

## 2. MCP servers

- MCP (Model Context Protocol) servers give Claude Code access to external
  systems — databases, design tools, ticket trackers, deploy platforms —
  as callable tools instead of copy-pasted context.
- Only add servers you'll actually use in a given project; each one adds
  tool-definition overhead to every request.
- Treat MCP servers as part of the trust boundary: a server can execute
  actions on your behalf, so only install ones from sources you trust, and
  scope credentials (API keys, tokens) as narrowly as the server allows.
- Prefer read-only/least-privilege access when the task is exploratory,
  and only grant write/push access once you're actually ready to have
  Claude make changes to that system.

## 3. Automation & recurring workflows

- Anything you find yourself asking for on a schedule (a daily status
  check, a recurring scrape, a PR watch) is a candidate for a scheduled
  trigger rather than a manual re-ask.
- For scraping/automation tasks, prefer structured fetch/API access over
  scraping raw HTML when a source offers it — it's more reliable and
  survives site redesigns.
- Keep automations narrowly scoped and idempotent: a job that re-runs
  safely on partial failure is much easier to trust unattended than one
  that isn't.

## 4. Cost & token optimization

- **Match model to task.** Larger/slower models earn their cost on
  ambiguous, multi-step, or high-stakes work; lighter/faster models are
  often enough for narrow, well-specified tasks (formatting, simple
  lookups, boilerplate).
- **Cache what's reusable.** Long-lived context (a large codebase primer,
  a style guide) benefits from prompt caching — structure requests so
  the stable part comes first and the changing part comes last.
- **Avoid re-deriving known facts.** Don't have Claude re-read files or
  re-run searches for information already established earlier in the
  conversation — that's pure token waste.
- **Batch and parallelize independent work** (parallel tool calls,
  background agents) instead of serial back-and-forth turns, which both
  saves wall-clock time and reduces redundant context re-transmission.

## 5. Deployment & shipping safely

- Keep changes small and reviewable; large, sprawling diffs are harder to
  verify and more likely to hide a real bug.
- Run the project's actual checks (lint, typecheck, tests) before calling
  something done — passing tests verify correctness, "looks right" does
  not.
- For anything hard to reverse (force-push, prod deploy, infra change),
  treat it as a checkpoint: confirm scope and intent before acting, don't
  bundle it silently into an unrelated change.

## 6. Client & project workflow

- Scope work item by item — a clear, narrow ask ("fix X", "add Y") gets a
  better result than an open-ended "improve this" and is easier to
  estimate and bill.
- Use a real branch/PR per unit of work rather than one long-lived branch
  accumulating unrelated changes — it keeps history reviewable and makes
  it easy to back out one piece without losing the rest.
- Document decisions in the PR description, not just the code — the
  "why" behind a nontrivial choice is what a reviewer (or future you)
  actually needs, since well-named code already shows the "what".
