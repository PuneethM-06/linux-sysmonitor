#!/bin/bash 
# Script: health-check.sh
# Purpose: Collect system health data and write structured logs
# Usage: ./health-check.sh
# Output: logs/health-YYYY-MM-DD-HH-MM.log

set -euo pipefail
LOGFILE="logs/$(date +"%Y-%m-%d-%H-%M").log"

if [ -d logs ]; then
    :
else
    mkdir -p logs
fi 

write_log() {

    level="$1"
    message="$2"
    timestamp="$(date +"%Y-%m-%d %H:%M:%S")"
    echo "$timestamp | $level | $message" >> $LOGFILE
}
write_log "INFO" "TEST MESSAGE" 

check_cpu() {
    CPUIDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')
    TOTAL=100
    CPUUSAGE=$(awk "BEGIN{print $TOTAL - $CPUIDLE}")

}
check_cpu