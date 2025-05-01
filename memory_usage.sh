#!/bin/bash


#interval in seconds between checks
INTERVAL=3
#logfile
LOGFILE=memory_usage_log.txt


echo "Memory monitoring every $INTERVAL seconds. Logging to $LOGFILE"
echo "Timestamp - Total(MB) Used(MB) FREE(MB)" > "$LOGFILE"


#loop
while true
do
    #get current timestamp
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

    #get memory info
    read TOTAL USED FREE <<< $(free -m | awk '/^Mem:/ {print $2, $3, $4}')

    #write the information to log
    echo "$TIMESTAMP - $TOTAL $USED $FREE" | tee -a "$LOGFILE"

    #wait for interval
    sleep "$INTERVAL"
    
done