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
    CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')
    TOTAL=100
    CPU_USAGE=$(awk "BEGIN{print $TOTAL - $CPU_IDLE}")
    int_CPU_USAGE=$(awk "BEGIN{print int($CPU_USAGE)}")

    if [ $int_CPU_USAGE -lt 70 ]; then 
        write_log "INFO" "CPU usage is $int_CPU_USAGE% — healthy"
    elif [[ $int_CPU_USAGE  -ge 70 && $int_CPU_USAGE  -lt 90 ]]; then
        write_log "WARNING" "CPU usage is $int_CPU_USAGE% — above threshold" 
    else
    write_log "CRITICAL" "CPU usage is $int_CPU_USAGE% — immediate attention"
    fi

}
check_cpu

check_memory() {
    MEM=$(free | grep "Mem" | awk '{print $3}')
    echo "$MEM"
}
check_memory