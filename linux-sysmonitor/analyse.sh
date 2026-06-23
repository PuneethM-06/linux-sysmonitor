#!/bin/bash 
set -euo pipefail
# Script: analyse.sh
# Purpose: Analyse Linux SysMonitor log files and provide filtered views, summaries, and insights
# Usage: ./analyse.sh [OPTIONS]
# Default Input: Latest log file from logs/
# Supported Flags:
#   --file <path>
#   --level <INFO|WARNING|CRITICAL>
#   --top <count>
#   --summary
#   --since <timestamp>
#   --help
