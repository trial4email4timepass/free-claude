#!/usr/bin/env node
// gate-check.mjs — runs the CHECK commands declared in one or more gate
// files (see references/gates.md for the format) and reports PASS/FAIL.
//
// Usage:
//   node gate-check.mjs [gate-file-or-glob ...] [--jobs N]
//
// No positional args defaults to the bare glob "gates/*.md" (relative to
// the current working directory) — the whole tree. Pass explicit gate
// file paths to scope a run to just those files (e.g. one leaf's gate,
// right after its dispatch returns) — that scoped call is what orchestrated
// mode uses per leaf; the bare glob is for the one whole-tree sanity sweep.
//
// Exit codes (stop-hook compatible — see references/gates.md):
//   0  every check in every file given passed
//   2  at least one check failed (stderr names the file/command; a Stop
//      hook feeds that back to Claude as the block reason)
//   1  usage error — bad args, no gate files matched, malformed gate file

import { readFileSync, readdirSync, existsSync, statSync } from "node:fs";
import { spawn } from "node:child_process";
import { dirname, join, basename } from "node:path";

function usageError(message) {
  process.stderr.write(`gate-check: ${message}\n`);
  process.exit(1);
}

function parseArgs(argv) {
  const files = [];
  let jobs = 1;
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    if (arg === "--jobs") {
      const value = argv[++i];
      jobs = Number.parseInt(value, 10);
      if (!Number.isInteger(jobs) || jobs < 1) {
        usageError(`--jobs expects a positive integer, got ${JSON.stringify(value)}`);
      }
    } else if (arg.startsWith("--jobs=")) {
      const value = arg.slice("--jobs=".length);
      jobs = Number.parseInt(value, 10);
      if (!Number.isInteger(jobs) || jobs < 1) {
        usageError(`--jobs expects a positive integer, got ${JSON.stringify(value)}`);
      }
    } else if (arg.startsWith("--")) {
      usageError(`unrecognized flag ${arg}`);
    } else {
      files.push(arg);
    }
  }
  return { files, jobs };
}

// Minimal single-segment glob (only "*"/"?" wildcards) — enough for
// "gates/*.md" and similar; no "**" support, no dependency needed.
//
// "_shared.md" is a library of named checks (see loadSharedChecks), not a
// runnable gate itself, so a wildcard match excludes it — the same way it
// would if gate files lived one directory below a "_shared.md" that
// documented the leaf/branch split for humans. An explicit, non-wildcard
// path to it is left alone; that's a caller mistake to surface, not paper
// over.
function globDir(pattern) {
  const dir = dirname(pattern) || ".";
  const namePattern = basename(pattern);
  if (!existsSync(dir) || !statSync(dir).isDirectory()) return [];
  const regex = new RegExp(
    "^" +
      namePattern
        .replace(/[.+^${}()|[\]\\]/g, "\\$&")
        .replace(/\*/g, ".*")
        .replace(/\?/g, ".") +
      "$"
  );
  return readdirSync(dir)
    .filter((name) => regex.test(name) && name !== "_shared.md")
    .sort()
    .map((name) => join(dir, name));
}

function resolveTargets(positional) {
  if (positional.length === 0) {
    return globDir("gates/*.md");
  }
  const targets = [];
  for (const arg of positional) {
    if (arg.includes("*") || arg.includes("?")) {
      targets.push(...globDir(arg));
    } else {
      targets.push(arg);
    }
  }
  return targets;
}

function extractFencedBlock(lines, afterIndex, context) {
  let fenceStart = -1;
  for (let i = afterIndex; i < lines.length; i++) {
    if (/^```/.test(lines[i].trim())) {
      fenceStart = i;
      break;
    }
  }
  if (fenceStart === -1) return null;
  const fenceEnd = lines.findIndex((line, i) => i > fenceStart && /^```/.test(line.trim()));
  if (fenceEnd === -1) {
    usageError(`${context}: unterminated fenced code block`);
  }
  return lines.slice(fenceStart + 1, fenceEnd);
}

function extractChecksBlock(text, filePath) {
  const lines = text.split("\n");
  const headingIndex = lines.findIndex((line) => /^##\s+Checks\s*$/.test(line.trim()));
  if (headingIndex === -1) {
    usageError(`${filePath}: no "## Checks" heading found`);
  }
  const block = extractFencedBlock(lines, headingIndex + 1, filePath);
  if (block === null) {
    usageError(`${filePath}: "## Checks" heading has no fenced code block after it`);
  }
  return block;
}

// Parses gates/_shared.md: "### <name>" headings each followed by a fenced
// code block of commands, referenced from a gate file via "USE: <name>".
function extractNamedBlocks(text, filePath) {
  const lines = text.split("\n");
  const blocks = new Map();
  for (let i = 0; i < lines.length; i++) {
    const match = lines[i].match(/^###\s+(\S+)\s*$/);
    if (!match) continue;
    const block = extractFencedBlock(lines, i + 1, `${filePath} (### ${match[1]})`);
    if (block === null) continue;
    const commands = block.map((l) => l.trim()).filter((l) => l && !l.startsWith("#"));
    blocks.set(match[1], commands);
  }
  return blocks;
}

function loadSharedChecks(gateFilePath) {
  const sharedPath = join(dirname(gateFilePath), "_shared.md");
  if (!existsSync(sharedPath)) return new Map();
  return extractNamedBlocks(readFileSync(sharedPath, "utf8"), sharedPath);
}

function loadGateCommands(gateFilePath) {
  if (!existsSync(gateFilePath)) {
    usageError(`${gateFilePath}: no such file`);
  }
  const text = readFileSync(gateFilePath, "utf8");
  const rawLines = extractChecksBlock(text, gateFilePath)
    .map((l) => l.trim())
    .filter((l) => l && !l.startsWith("#"));

  let shared = null;
  const commands = [];
  for (const line of rawLines) {
    const useMatch = line.match(/^USE:\s*(\S+)$/);
    if (useMatch) {
      shared ??= loadSharedChecks(gateFilePath);
      const name = useMatch[1];
      if (!shared.has(name)) {
        usageError(
          `${gateFilePath}: USE: ${name} — no such shared check in ${join(dirname(gateFilePath), "_shared.md")}`
        );
      }
      commands.push(...shared.get(name));
    } else {
      commands.push(line);
    }
  }
  if (commands.length === 0) {
    usageError(`${gateFilePath}: "## Checks" block has no commands`);
  }
  return commands;
}

function runCommand(command) {
  return new Promise((resolve) => {
    const child = spawn(command, { shell: true, cwd: process.cwd() });
    let output = "";
    child.stdout.on("data", (d) => (output += d));
    child.stderr.on("data", (d) => (output += d));
    child.on("error", (err) => resolve({ command, code: 1, output: String(err) }));
    child.on("close", (code) => resolve({ command, code, output }));
  });
}

// Fail-fast within one gate file: a later command often assumes an
// earlier one's side effects (build, then test). Independent gate files
// keep running regardless of each other's outcome (see runPool).
async function runGateFile(filePath) {
  const commands = loadGateCommands(filePath);
  const results = [];
  let failed = false;
  for (const command of commands) {
    if (failed) {
      results.push({ command, skipped: true });
      continue;
    }
    const result = await runCommand(command);
    results.push(result);
    if (result.code !== 0) failed = true;
  }
  return { filePath, results, failed };
}

function formatFileReport(report) {
  const id = basename(report.filePath, ".md");
  const lines = [`== ${report.filePath} ==`];
  let passed = 0;
  for (const r of report.results) {
    if (r.skipped) {
      lines.push(`  SKIP  ${r.command}`);
      continue;
    }
    if (r.code === 0) {
      passed++;
      lines.push(`  PASS  ${r.command}`);
    } else {
      lines.push(`  FAIL  ${r.command} (exit ${r.code})`);
      const tail = r.output.trim().split("\n").slice(-20).join("\n");
      if (tail) lines.push(tail.replace(/^/gm, "    "));
    }
  }
  const total = report.results.filter((r) => !r.skipped).length;
  lines.push(
    report.failed
      ? `-- ${id}: ${passed}/${total} passed, stopped at first failure --`
      : `-- ${id}: ${passed}/${total} passed --`
  );
  return lines.join("\n");
}

// Runs up to `jobs` gate files concurrently. Each file's own commands
// still run in order (see runGateFile) — concurrency is across files,
// which is safe because leaves (and their gates) own disjoint files.
async function runPool(files, jobs) {
  const reports = new Array(files.length);
  let next = 0;
  async function worker() {
    while (next < files.length) {
      const i = next++;
      reports[i] = await runGateFile(files[i]);
    }
  }
  await Promise.all(Array.from({ length: Math.min(jobs, files.length) }, worker));
  return reports;
}

async function main() {
  const { files: positional, jobs } = parseArgs(process.argv.slice(2));
  const targets = resolveTargets(positional);
  if (targets.length === 0) {
    usageError(
      positional.length === 0
        ? `no gate files found (looked for gates/*.md under ${process.cwd()})`
        : `no gate files matched: ${positional.join(", ")}`
    );
  }

  process.stdout.write(`gate-check: ${targets.length} file(s), Jobs: ${jobs}\n`);
  const reports = await runPool(targets, jobs);
  for (const report of reports) {
    process.stdout.write(formatFileReport(report) + "\n");
  }

  const failedFiles = reports.filter((r) => r.failed);
  const totalPassed = reports.reduce(
    (sum, r) => sum + r.results.filter((c) => !c.skipped && c.code === 0).length,
    0
  );
  const totalChecked = reports.reduce(
    (sum, r) => sum + r.results.filter((c) => !c.skipped).length,
    0
  );
  process.stdout.write(
    `gate-check: ${targets.length} file(s), Jobs: ${jobs} — ${totalPassed}/${totalChecked} checks passed, ${failedFiles.length} file(s) failed\n`
  );

  if (failedFiles.length > 0) {
    process.stderr.write(
      `gate-check: FAILED — ${failedFiles.map((r) => basename(r.filePath)).join(", ")}\n`
    );
    process.exit(2);
  }
  process.exit(0);
}

main();
