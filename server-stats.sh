#!/bin/bash


#LOGFILE
LOGFILE=stats-log.txt

#interval in seconds between checks
INTERVAL=6


echo "Monitoring health check server 'A' every $INTERVAL seconds"
echo "Logging to $LOGFILE"


#loop monitoring process until interrupted
while true
do
	#get current timestamp
	TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"
	echo "$TIMESTAMP"
	echo " "

	#get cpu usage
	echo "===========================CPU USAGE==========================="	
	CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100-$8}')
	#write the cpu information to log
	echo "CPU Usage: $CPU_USAGE%" | tee -a "$LOGFILE"

	#get memory usage
	echo "=========================MEMORY USAGE=========================="
	read TOTAL USED FREE <<< $(free -m | awk '/^Mem:/ {print $2, $3, $4}')
	#write the memory information to log
	echo "Total: $TOTAL MB | Used: $USED MB | Free: $FREE MB" | tee -a "$LOGFILE"

	#get disk usage
	echo "==========================DISK USAGE==========================="
	df -hP | grep -vE '^tmpfs|^udev' | while read -r line; do
		echo "$line" | tee -a "$LOGFILE"
	done

	#get top 5 processes by CPU Usage
	echo "============Top 5 Processes by CPU & Memory Usage=============="
	cpu_usage=$(ps -eo pid,user,%cpu,comm --sort=-%cpu | head -n 6)
	mem_usage=$(ps -eo pid,user,%mem,comm --sort=-%mem | head -n 6)
	#write the top processes information to log
	echo "$cpu_usage" | tee -a "$LOGFILE"
	echo "$mem_usage" | tee -a "$LOGFILE"


	echo "_end_"
	#internal set
	sleep "$INTERVAL"

done


