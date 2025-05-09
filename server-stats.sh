#!/bin/bash


CURRENT_DATE=$(date '+%Y-%m-%d')
LOGFILE="stats-log-$CURRENT_DATE.txt"

#interval in seconds between checks
INTERVAL=6


if [ ! -f "$LOGFILE" ]; then
    echo "Server Stats Log - Started at $(date)" > "$LOGFILE"
    echo "=============================================================" >> "$LOGFILE"
fi

trap "echo -e '\nMonitoring stopped by user.'; exit" SIGINT


#function for read performance
log_cpu_usage() {
    echo "===========================CPU USAGE==========================="	
    local usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
    echo "CPU Usage: $usage%" | tee -a "$LOGFILE"
}

log_memory_usage() {
    echo "=========================MEMORY USAGE=========================="
    read total used free <<< $(free -m | awk '/^Mem:/ {print $2, $3, $4}')
    echo "Total(MB): $total | Used(MB): $used | Free(MB): $free" | tee -a "$LOGFILE"
}

log_disk_usage() {
    echo "==========================DISK USAGE==========================="
    df -hP | grep -vE '^tmpfs|^udev' | tee -a "$LOGFILE"
}

log_top_processes() {
    echo "============Top 5 Processes by CPU & Memory Usage=============="
    echo "Top by CPU:" | tee -a "$LOGFILE"
    ps -eo pid,user,%cpu,comm --sort=-%cpu | head -n 6 | tee -a "$LOGFILE"
    echo "Top by Memory:" | tee -a "$LOGFILE"
    ps -eo pid,user,%mem,comm --sort=-%mem | head -n 6 | tee -a "$LOGFILE"
}


#loop monitoring process until interrupted
while true; do
    NEW_DATE=$(date '+%Y-%m-%d')
    if [ "$NEW_DATE" != "$CURRENT_DATE" ]; then
        CURRENT_DATE="$NEW_DATE"
        LOGFILE="stats-log-$CURRENT_DATE.txt"
        echo "===Starting New Log $LOGFILE==="
    fi

    TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "$TIMESTAMP" | tee -a "$LOGFILE"
    echo " " | tee -a "$LOGFILE"

    log_cpu_usage
    log_memory_usage
    log_disk_usage
    log_top_processes

    sleep "$INTERVAL"
done

