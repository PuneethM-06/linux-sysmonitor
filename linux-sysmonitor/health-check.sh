#!/bin/bash 
# Script: health-check.sh
# Purpose: Collect system health data and write structured logs
# Usage: ./health-check.sh
# Output: logs/health-YYYY-MM-DD-HH-MM.log

set -euo pipefail

LOGFILE=$(date +"%Y-%m-%d-%H-%M").log
echo "$LOGFILE"
