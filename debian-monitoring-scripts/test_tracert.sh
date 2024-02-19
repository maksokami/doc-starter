#!/bin/bash
# This script periodically does traceroute to a specified destination and outputs results to a text file
 
PING_DST="8.8.8.8"
HOP_NUMBER=17
REPORT_DIR=`pwd`
REPORT_FILE="report_test_tracert.txt"
RUN_INTERVAL=4


while getopts d:f:i:r:h flag
do
    case "${flag}" in
	d) PING_DST=${OPTARG};;
    f) REPORT_FILE=${OPTARG};;
    i) RUN_INTERVAL=${OPTARG};;
    r) REPORT_DIR=${OPTARG};;
    h) echo "Usage: script.sh [OPTIONS] 
		
Example: script.sh -d 1.1.1.1 -i 10  
		
Options: 
  -d Traceroute destination (default: 8.8.8.8) 
  -r Directory where resulting report will be saved (default: current dir) 
  -f Resulting report filename (default: report_test_tracert.txt) 
  -i Script run interval. Every X seconds (default: 4) 
  
  ----------------- 
  no sudo privileges required
  "
  exit 0;;
    esac
done

echo "" > $REPORT_DIR/$REPORT_FILE

while :
do
    echo "" >> $REPORT_DIR/$REPORT_FILE
    DATE_TIME=$(date +"%m-%d-%Y %H:%M:%S")
    LINUX_TIME=$(date +%s)
	echo "$DATE_TIME - $LINUX_TIME" >> $REPORT_DIR/$REPORT_FILE
	traceroute -m $HOP_NUMBER -n $PING_DST >> $REPORT_DIR/$REPORT_FILE
	
  sleep $RUN_INTERVAL
done
