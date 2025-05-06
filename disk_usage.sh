#!/bin/bash

#THRESHOLD=81
LOGFILE="disk_usage_log.txt"

echo "Disk Usage Report - $(date)"
echo "---------------------------"


#get disk usage (excluding tmpfs and udev)
df -hP | grep -vE '^tmpfs|^udev' | while read -r line; do
	echo "$line" | tee -a "$LOGFILE"

	#extract filesystem and usage percentage for alerting
	#usage=$(echo $line | awk '{print $5}' | sed 's/%/ /')
	#filsys=$(echo $line | awk '{print $1}')

	#if [ "$usage" -ge "$THRESHOLD" ]; then
		#echo "ALERT: $filsys is ${usage}% full!" >&2
	#fi

done
