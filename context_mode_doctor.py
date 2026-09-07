#!/usr/bin/env python3
"""context-mode doctor

Audits a project's Claude Code context configuration and reports on its
health: CLAUDE.md presence/size, .claude/settings*.json validity, MCP
config validity, context-window bloat, and stray secrets in tracked
config files.

Usage:
    python3 context_mode_doctor.py [PATH]

Exit code is 0 if there are no FAIL results, 1 otherwise.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path

# Rough heuristic: ~4 characters per token for English/code text.
CHARS_PER_TOKEN = 4

# Files that Claude Code loads into context on (almost) every turn.
ALWAYS_LOADED_GLOBS = [
    "CLAUDE.md",
    ".claude/CLAUDE.md",
    "**/CLAUDE.md",
]

SETTINGS_FILES = [
    ".claude/settings.json",
    ".claude/settings.local.json",
]

MCP_CONFIG_FILES = [
    ".mcp.json",
]

WARN_CONTEXT_CHARS = 8_000 * CHARS_PER_TOKEN   # ~8k tokens
FAIL_CONTEXT_CHARS = 25_000 * CHARS_PER_TOKEN  # ~25k tokens

SECRET_PATTERNS = [
    re.compile(r"sk-ant-[a-zA-Z0-9_-]{20,}"),
    re.compile(r"sk-[a-zA-Z0-9]{20,}"),
    re.compile(r"ghp_[a-zA-Z0-9]{20,}"),
    re.compile(r"AKIA[0-9A-Z]{16}"),
    re.compile(r"-----BEGIN (RSA|EC|OPENSSH|PRIVATE) KEY-----"),
]

Status = str  # "PASS" | "WARN" | "FAIL"


@dataclass
class Check:
    status: Status
    title: str
    detail: str = ""


@dataclass
class Report:
    checks: list = field(default_factory=list)

    def add(self, status: Status, title: str, detail: str = "") -> None:
        self.checks.append(Check(status, title, detail))

    @property
    def has_failures(self) -> bool:
        return any(c.status == "FAIL" for c in self.checks)


ICONS = {"PASS": "✓", "WARN": "!", "FAIL": "✗"}


def find_claude_md_files(root: Path) -> list[Path]:
    found = []
    for pattern in ("CLAUDE.md", "**/CLAUDE.md"):
        for p in root.glob(pattern):
            if p.is_file() and p not in found:
                if any(part in {".git", "node_modules", "venv", ".venv"} for part in p.parts):
                    continue
                found.append(p)
    return found


def check_claude_md(root: Path, report: Report) -> None:
    files = find_claude_md_files(root)
    if not files:
        report.add(
            "WARN",
            "No CLAUDE.md found",
            "Add a CLAUDE.md at the project root so Claude Code has "
            "durable project context (build steps, conventions, gotchas).",
        )
        return

    for f in files:
        try:
            text = f.read_text(errors="replace")
        except OSError as e:
            report.add("FAIL", f"Cannot read {f}", str(e))
            continue

        size = len(text)
        rel = f.relative_to(root)
        if size == 0:
            report.add("WARN", f"{rel} is empty", "Remove it or fill it in.")
        elif size > FAIL_CONTEXT_CHARS:
            report.add(
                "FAIL",
                f"{rel} is very large (~{size // CHARS_PER_TOKEN:,} tokens)",
                "This is loaded on every turn and will crowd out real "
                "context. Trim it to essentials and link out to docs "
                "for details.",
            )
        elif size > WARN_CONTEXT_CHARS:
            report.add(
                "WARN",
                f"{rel} is large (~{size // CHARS_PER_TOKEN:,} tokens)",
                "Consider trimming — everything here is loaded on every turn.",
            )
        else:
            report.add(
                "PASS",
                f"{rel} present (~{size // CHARS_PER_TOKEN:,} tokens)",
            )

    if len(files) > 1:
        report.add(
            "WARN",
            f"{len(files)} CLAUDE.md files found",
            "Multiple CLAUDE.md files can carry conflicting instructions. "
            "Confirm the nesting is intentional (repo root vs. subproject).",
        )


def check_json_file(path: Path, root: Path, report: Report, label: str) -> dict | None:
    if not path.exists():
        return None
    rel = path.relative_to(root)
    try:
        text = path.read_text()
        data = json.loads(text)
    except json.JSONDecodeError as e:
        report.add("FAIL", f"{rel} is not valid JSON", str(e))
        return None
    except OSError as e:
        report.add("FAIL", f"Cannot read {rel}", str(e))
        return None
    report.add("PASS", f"{rel} is valid JSON")
    return data


def check_settings(root: Path, report: Report) -> None:
    any_found = False
    for rel_path in SETTINGS_FILES:
        path = root / rel_path
        if path.exists():
            any_found = True
        data = check_json_file(path, root, report, "settings")
        if data is None:
            continue
        perms = data.get("permissions", {})
        if isinstance(perms, dict):
            deny = perms.get("deny", [])
            allow = perms.get("allow", [])
            if isinstance(deny, list) and isinstance(allow, list):
                overlap = set(deny) & set(allow)
                if overlap:
                    report.add(
                        "WARN",
                        f"{path.relative_to(root)} has rules in both allow and deny",
                        f"Conflicting entries: {sorted(overlap)}",
                    )
    if not any_found:
        report.add(
            "WARN",
            "No .claude/settings.json found",
            "Optional, but useful for pinning permissions and hooks "
            "instead of relying on ad-hoc approvals.",
        )


def check_mcp_config(root: Path, report: Report) -> None:
    for rel_path in MCP_CONFIG_FILES:
        path = root / rel_path
        if not path.exists():
            continue
        data = check_json_file(path, root, report, "mcp")
        if not isinstance(data, dict):
            continue
        servers = data.get("mcpServers", {})
        if not isinstance(servers, dict) or not servers:
            report.add(
                "WARN",
                f"{rel_path} defines no mcpServers",
                "Remove the file if it's unused, to avoid confusion.",
            )
        else:
            report.add(
                "PASS",
                f"{rel_path} defines {len(servers)} MCP server(s)",
            )


def check_secrets_in_tracked_config(root: Path, report: Report) -> None:
    candidates = []
    for rel_path in SETTINGS_FILES + MCP_CONFIG_FILES:
        p = root / rel_path
        if p.exists():
            candidates.append(p)
    candidates += find_claude_md_files(root)

    hits = []
    for path in candidates:
        try:
            text = path.read_text(errors="replace")
        except OSError:
            continue
        for pattern in SECRET_PATTERNS:
            if pattern.search(text):
                hits.append(path.relative_to(root))
                break

    if hits:
        report.add(
            "FAIL",
            f"Possible secret(s) found in {len(hits)} context file(s)",
            "Files: " + ", ".join(str(h) for h in hits) + ". "
            "Move credentials to environment variables / a gitignored "
            "file and rotate any leaked keys.",
        )
    else:
        report.add("PASS", "No obvious secrets in context files")


def check_gitignore(root: Path, report: Report) -> None:
    gitignore = root / ".gitignore"
    if not (root / ".git").exists():
        return  # not a git repo, skip
    if not gitignore.exists():
        report.add(
            "WARN",
            "No .gitignore found",
            "Add one so local settings, env files, and build output "
            "don't leak into context or version control.",
        )
        return
    text = gitignore.read_text(errors="replace")
    recommended = [".env", ".claude/settings.local.json"]
    missing = [pat for pat in recommended if pat not in text]
    if missing:
        report.add(
            "WARN",
            ".gitignore is missing some recommended entries",
            "Consider adding: " + ", ".join(missing),
        )
    else:
        report.add("PASS", ".gitignore covers local settings/env files")


def check_total_context_budget(root: Path, report: Report) -> None:
    total = 0
    for f in find_claude_md_files(root):
        try:
            total += len(f.read_text(errors="replace"))
        except OSError:
            continue
    for rel_path in SETTINGS_FILES + MCP_CONFIG_FILES:
        p = root / rel_path
        if p.exists():
            try:
                total += len(p.read_text(errors="replace"))
            except OSError:
                continue

    tokens = total // CHARS_PER_TOKEN
    if total == 0:
        return
    if total > FAIL_CONTEXT_CHARS:
        report.add(
            "FAIL",
            f"Always-loaded context is large (~{tokens:,} tokens)",
            "Combined CLAUDE.md + settings + MCP config eats into every "
            "turn's budget. Trim or move detail into on-demand docs.",
        )
    elif total > WARN_CONTEXT_CHARS:
        report.add(
            "WARN",
            f"Always-loaded context is getting large (~{tokens:,} tokens)",
        )
    else:
        report.add(
            "PASS",
            f"Always-loaded context is reasonable (~{tokens:,} tokens)",
        )


def run_checks(root: Path) -> Report:
    report = Report()
    check_claude_md(root, report)
    check_settings(root, report)
    check_mcp_config(root, report)
    check_gitignore(root, report)
    check_secrets_in_tracked_config(root, report)
    check_total_context_budget(root, report)
    return report


def print_report(report: Report) -> None:
    counts = {"PASS": 0, "WARN": 0, "FAIL": 0}
    for check in report.checks:
        counts[check.status] += 1
        icon = ICONS[check.status]
        print(f"[{icon}] {check.status:<4} {check.title}")
        if check.detail:
            for line in check.detail.splitlines():
                print(f"        {line}")

    print()
    print(f"{counts['PASS']} passed, {counts['WARN']} warnings, {counts['FAIL']} failed")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "path",
        nargs="?",
        default=".",
        help="Project directory to audit (default: current directory)",
    )
    args = parser.parse_args(argv)

    root = Path(args.path).resolve()
    if not root.is_dir():
        print(f"error: {root} is not a directory", file=sys.stderr)
        return 2

    print(f"context-mode doctor — auditing {root}\n")
    report = run_checks(root)
    print_report(report)
    return 1 if report.has_failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
