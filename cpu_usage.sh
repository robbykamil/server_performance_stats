#!/bin/bash

#interval in seconds between checks
INTERVAL=7

#output log file
LOGFILE="cpu_usage_log.txt"


echo "CPU monitoring every $INTERVAL seconds. Logging to $LOGFILE"
echo "Timestamp - CPU Usage (%)" > "$LOGFILE"

#loop monitoring process until interrupted
while true
do
    #get current timestamp
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

    #get cpu usage
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')

    #write the information to log
    echo "$TIMESTAMP - CPU Usage: $CPU_USAGE%" | tee -a "$LOGFILE"

    #wait for interval
    sleep $INTERVAL

done