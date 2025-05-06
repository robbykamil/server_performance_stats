#!/bin/bash

#interval in seconds
INTERVAL=3

#logfile
LOGFILE="top_cpu_usage.txt"

while true
do
	#get current time
	TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
	#execute the command
	cpu_usage=$(ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | head -n 6)

	#write to log
	echo "$TIMESTAMP \n $cpu_usage" | tee -a "$LOGFILE"

	#interval
	sleep "$INTERVAL"
done
