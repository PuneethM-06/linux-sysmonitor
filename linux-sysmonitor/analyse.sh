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

SUMMARY=false
LEVEL=""
TOP=0
SINCE=""

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
    exit 1
fi

while [[ $# -gt 0 ]]
do
    case "$1" in
    --file)
    if [ $# -lt 2 ]; then 
        echo "Error: --file requires file name"
        exit 1
    fi
    FILE=$2
    shift 2
    ;;
    --level)
    if [ $# -lt 2 ]; then 
        echo "Error: --level requires "level""
        exit 1
    fi
    LEVEL=$2
    shift 2
    ;;
    --top)
    if [ $# -lt 2 ]; then 
        echo "Error: --top requires number of lines"
        exit 1
    fi
    TOP=$2
    shift 2
    ;;
    --since)
    if [ $# -lt 2 ]; then 
        echo "Error: --since requires HH:MM"
        exit 1
    fi
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

if [[ $LEVEL != "" && $LEVEL == INFO ]]; then
    INFO_LOGS=$(grep "INFO" $DEFAULT_FILE)
    echo -e "${GREEN}$INFO_LOGS${NC}"

elif [[ $LEVEL != "" && $LEVEL == WARNING ]]; then
    INFO_LOGS=$(grep "WARNING" $DEFAULT_FILE)
    echo -e "${YELLOW}$INFO_LOGS${NC}"

elif [[ $LEVEL != "" && $LEVEL == CRITICAL ]]; then 
    INFO_LOGS=$(grep "CRITICAL" $DEFAULT_FILE)
    echo -e "${RED}$INFO_LOGS${NC}"
fi

if [ $TOP -ne 0 ]; then 
   awk -F '|' '{print $3}' $DEFAULT_FILE| sort | uniq -c | sort -rn | head -n $TOP
fi

SINCE_SECONDS=$(echo "$SINCE" | awk -F ':' '{print ($1 * 3600) + ($2 * 60)}')
while read line
do
    TIME=$(echo "$line" | awk -F '|' '{print $1}' | awk '{print $2}')
    TIME_SECONDS=$(echo "$TIME" | awk -F ':' '{print ($1 * 3600) + ($2 * 60)}')

    if [[ $TIME_SECONDS -gt $SINCE_SECONDS ]]; then
        echo "$line"
    fi
done < $DEFAULT_FILE