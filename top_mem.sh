#!/bin/bash

#interval
INTERVAL=3

#LOGFILE
LOGFILE="top_mem_log.txt"

while true
do
	#get current time
	TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

	#execute command
	mem_usage=$(ps -eo pid,user,%mem,comm --sort=-%mem | head -n 6)

	#write to the log
	echo "$TIMESTAMP /\n $mem_usage" | tee -a "$LOGFILE"

	#interval
	sleep "$INTERVAL"
done
