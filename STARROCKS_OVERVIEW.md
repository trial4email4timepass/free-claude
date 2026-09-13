# StarRocks — Repository Overview

Source: https://github.com/StarRocks/starrocks

## What it is

StarRocks is an open-source, high-performance analytical database designed
for sub-second, ad-hoc queries both on and off the data lakehouse. It is a
Linux Foundation project written primarily in Java (~55%) and C++ (~42%),
with smaller amounts of Python, C, Thrift, and CMake.

- License: Apache License 2.0
- Website: https://starrocks.io
- Latest release: 4.0.13
- Total releases: 192
- Contributors: 618+
- Stars: ~12.1k · Forks: ~2.6k · Watchers: 188
- Branches: ~1.4k · Tags: 307

## Key Features

- **Native vectorized SQL engine** — uses vectorization to exploit CPU
  parallelism, delivering sub-second responses on multi-dimensional
  analytical queries (5–10x faster than earlier-generation engines).
- **Standard SQL** — full ANSI SQL support (including TPC-H and TPC-DS
  benchmarks) and MySQL wire-protocol compatibility, so existing BI tools
  and clients work out of the box.
- **Cost-based optimizer (CBO)** — smart query optimization for complex
  queries, improving execution plans and analytical efficiency.
- **Real-time updates** — a primary-key model supports efficient
  upsert/delete operations with concurrent updates.
- **Intelligent materialized views** — automatically refreshed during data
  ingestion and automatically selected by the query optimizer.
- **Direct lakehouse queries** — reads data directly from Apache Hive,
  Apache Iceberg, Delta Lake, and Apache Hudi without needing to import it.
- **Resource management** — multi-tenant resource isolation and limits for
  queries running on the same cluster.
- **Operational simplicity** — a streamlined architecture that is easy to
  deploy, scale, and self-heal from node failures.

## Architecture

StarRocks has two main components:

- **Frontend (FE)** — handles metadata, query parsing/planning, and
  coordination.
- **Backend (BE)** — executes queries and stores data.

Both FE and BE scale horizontally and replicate metadata/data to avoid
single points of failure.

Since version 3.0, StarRocks also supports a **shared-data architecture**
(compute/storage separation) for better scalability and lower cost,
alongside its original shared-nothing deployment model.

## Resources

- Quick Starts — how-tos and tutorials
- Deploy — running and configuring StarRocks
- Full documentation: https://docs.starrocks.io (via the Docs link on the
  project site)
- Benchmarks and demo pages linked from the project README

## Community & Support

- Slack community for technical discussion
- YouTube channel for tutorials/webcasts
- GitHub Issues for bug reports
- Google Groups for feature/design discussion

## Contributing

- Guarded by `Contributing.md` in the repository
- Setup guides: IDE setup, compiling with Docker, manual deployment
- GitHub workflow docs and a PR template for submitting changes
- "Good first issue" labels available for new contributors
- Documented community membership/role model for contributors

## Notable Adopters

Companies publicly listed as StarRocks users include Airbnb, Airtable,
Alibaba, Amazon, Cisco, Coinbase, Grab, Pinterest, Shopee, Tencent,
Trip.com, and Xiaohongshu/RedNote, among others.

## Repository Stats Snapshot

| Metric | Value |
|---|---|
| Stars | ~12.1k |
| Forks | ~2.6k |
| Watchers | 188 |
| Open issues | 502 |
| Contributors | 618+ |
| Branches | ~1.4k |
| Tags | 307 |
| Latest release | 4.0.13 |
| License | Apache License 2.0 |
