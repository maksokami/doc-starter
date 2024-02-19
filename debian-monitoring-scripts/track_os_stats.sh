#!/bin/bash
# This script reports main OS stats: CPU, RAM, SWAP, Root FS utilization

REPORT_DIR=`pwd`
REPORT_NAME="report_os_stats"
REFRESH_INTERVAL=30


while getopts f:i:r:h flag
do
    case "${flag}" in
        f) REPORT_NAME=${OPTARG};;
        i) REFRESH_INTERVAL=${OPTARG};;
        r) REPORT_DIR=${OPTARG};;
        h) echo "Usage: script.sh [OPTIONS]

Options: 
  -f Resulting report filename. CSV extention is auto-added. (default: report_os_stats)
  -i Script run interval. Seconds (default: 30)
  -r Directory where resulting report will be saved (default: current dir)

  -----------------
  no sudo privileges required

  "
  exit 0;;
    esac
done

# Get first line with CSV column headers
headers="datetime,epoch,CPU_avg_1min,CPU_avg_5min,CPU_avg_15min,RAM,SWAP,ROOT_FS"

# Prepare the report file
echo $headers > $REPORT_DIR/$REPORT_NAME.csv

while :
do
    DATE_TIME=$(date +"%m-%d-%Y %H:%M")
    LINUX_TIME=$(date +%s)
    
    # RUN THE MAIN COMMAND
	cpu_1min=`top -bn1 | grep load | awk '{printf "%.2f%%", $(NF-2)}'`
	cpu_5min=`top -bn1 | grep load | awk '{printf "%.2f%%", $(NF-1)}'`
	cpu_15min=`top -bn1 | grep load | awk '{printf "%.2f%%", $(NF)}'`
	mem=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')
	swap=$(free -m | awk 'NR==3{printf "%.2f%%", $3*100/$2 }')
	root_fs=`df -h | grep \/$ | awk '{print $5}'`
    # Export the result
    data_row="$DATE_TIME,$LINUX_TIME,$cpu_1min,$cpu_5min,$cpu_15min,$mem,$swap,$root_fs"
    
    echo $data_row >> $REPORT_DIR/$REPORT_NAME.csv

  sleep $REFRESH_INTERVAL
done
