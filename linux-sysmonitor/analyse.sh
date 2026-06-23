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

RED='\033[1;31m'
YELLOW='\033[33m'
GREEN='\033[0;32m'
NC='\033[0m'

LOG_DIR="logs/"
LATEST_LOG=$(ls -t logs| head -n 1)
DEFAULT_FILE="$LOG_DIR$LATEST_LOG"

usage() {
    echo "Usage: ./analyse.sh [OPTIONS]"

    echo "Options:
  --file <path>
  --level <INFO|WARNING|CRITICAL>
  --top <count>
  --summary
  --since <timestamp>
  --help"
}

if [ $# -eq 0 ]; then
    echo " There must be a flag defined"
    usage
fi

while [[ $# -gt 0 ]]
do
    case "$1" in
    --file)
    FILE=$2
    shift 2
    ;;
    --level)
    LEVEL=$2
    shift 2
    ;;
    --top)
    TOP=$2
    shift 2
    ;;
    --since)
    SINCE=$2
    shift 2
    ;;
    --summary)
    SUMMARY=true
    shift
    ;;
    --help)
    usage
    shift
    ;;
    *)
    echo "Invalid flag, $1"
    usage
    shift
    ;;
    esac
done

if [ $SUMMARY == true ]; then
    echo "================================="
    echo "Log Summary"
    echo "================================="
    echo "Total Entries:" $(wc -l $DEFAULT_FILE | awk '{print $1}')
    echo -e "${GREEN}INFO: $(grep "INFO" $DEFAULT_FILE | wc -l )${NC}"
    echo -e "${YELLOW}WARNING: $(grep "WARNING" $DEFAULT_FILE | wc -l )${NC}"
    echo -e "${RED}CRITICAL: $(grep "CRITICAL" $DEFAULT_FILE | wc -l )${NC}"
    echo "================================="
fi
