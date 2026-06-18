# linux-sysmonitor# linux-sysmonitor

> 🚧 Work in progress — being built as part of my DevOps learning journey

A Linux system monitoring tool built in pure Bash.
Two scripts that work together — one collects, one analyses.

---

## What this will do

**health-check.sh** — runs system checks and writes a structured log report
- CPU, memory, disk usage with WARNING and CRITICAL thresholds
- Top 5 processes by CPU
- Network connectivity check
- Open ports via ss -tlnp
- Process status checks
- System uptime and load average

**analyse.sh** — reads the report and lets you filter and query it
- Filter by log level — INFO, WARNING, CRITICAL
- Top N most common issues
- Clean summary of all checks
- Filter by time range

```bash
# Generate report
./health-check.sh

# Analyse it
./analyse.sh --summary
./analyse.sh --level CRITICAL
./analyse.sh --level WARNING --top 3
```

---

## Status

| Script | Status |
|---|---|
| health-check.sh | 🚧 In progress |
| analyse.sh | ⏳ Not started |
| README | ✍️ Being updated as I build |

---

## Why I built this

This is my Week 1 Linux project — built after 7 days of learning Linux
fundamentals in a GitHub Codespace. Every function written and understood
by me, not copied.

Covers: bash scripting · file permissions · process management ·
log parsing · text processing · networking commands

This script will later evolve — the same monitoring problem gets solved
again with Python, then Prometheus, then Grafana as I go deeper into
the DevOps stack. Same problem, better tools, visible growth.

---

