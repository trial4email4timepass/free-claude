# StarRocks — Project Notes

This is reference context on [StarRocks/starrocks](https://github.com/StarRocks/starrocks) so it's loaded automatically when Claude Code opens this repo. See `README.md` for the full write-up; summary below.

## What it is

StarRocks is an open-source, high-performance analytical database (Apache-2.0, Java + C++) built for sub-second, ad-hoc analytics on and off the data lakehouse — a native vectorized SQL engine, ANSI SQL + MySQL-protocol compatibility, a cost-based optimizer, real-time upsert/delete via a primary-key model, auto-refreshed materialized views, and direct queries against Hive/Iceberg/Delta Lake/Hudi without importing. A Linux Foundation project.

## Architecture

- **Frontend (FE)** — metadata, query parsing/planning, coordination
- **Backend (BE)** — query execution and storage
- Both scale horizontally with replication (no single point of failure)
- v3.0+ adds an optional shared-data (storage/compute separation) architecture alongside the original shared-nothing mode

## Getting started

- Quick Starts / Deploy docs, plus a Docker-based compile guide and manual deployment guide, are linked from the project README
- Contribution flow: `Contributing.md`, a documented GitHub workflow, and a PR template; "good first issue" label for newcomers

Links: [starrocks.io](https://starrocks.io) · [github.com/StarRocks/starrocks](https://github.com/StarRocks/starrocks)
