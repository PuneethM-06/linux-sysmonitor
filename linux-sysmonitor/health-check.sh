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
    USED_MEM=$(free | grep "Mem" | awk '{print $3}')
    TOTAL_MEM=$(free | grep "Mem" | awk '{print $2}')
    USED_MEM_PCT=$(awk "BEGIN{print ($USED_MEM / $TOTAL_MEM) * 100}")
    USED_MEM_INT=$(awk "BEGIN{print int($USED_MEM_PCT)}")
    if [ $USED_MEM_INT -lt 70 ]; then 
        write_log "INFO" "Memory usage is $USED_MEM_INT% — healthy"
    elif [[ $USED_MEM_INT -ge 70 && $USED_MEM_INT -lt 90 ]]; then 
        write_log "WARNING" "Memory usage is $USED_MEM_INT% — above threshold"
    else
        write_log "CRITICAL" "Memory usage is $USED_MEM_INT% — immediate attention"
    fi
}
check_memory

disk_check() {
    DISK_MEM_VALUE=$(df -h /| grep "overlay" | awk '{print $5}' | sed 's/%//')
    if [ $DISK_MEM_VALUE -lt 80 ]; then 
        write_log "INFO" "Disk usage is $DISK_MEM_VALUE% — healthy"
    elif [[ $DISK_MEM_VALUE -ge 80 && $DISK_MEM_VALUE -lt 95 ]]; then 
        write_log "WARNING" "Disk usage is $DISK_MEM_VALUE% — above threshold"
    else
        write_log "CRITICAL" "Disk usage is $DISK_MEM_VALUE% — immediate attention"
    fi
}
disk_check

check_process () {
    if  pgrep -x sshd ; then
        write_log "INFO" "sshd is running"
    else
        write_log "WARNING" "sshd is not running"
    fi

}
check_process