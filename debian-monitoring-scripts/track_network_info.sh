#!/bin/bash

HOP_NUMBER=17
REPORT_DIR=`pwd`
REPORT_FILE="network_info.txt"
RUN_INTERVAL=4


while getopts f:i:r:h flag
do
    case "${flag}" in
        f) REPORT_FILE=${OPTARG};;
        i) RUN_INTERVAL=${OPTARG};;
        r) REPORT_DIR=${OPTARG};;
        h) echo "Usage: script.sh [OPTIONS] 
		
Example: script.sh -i 10  
		
Options: 
  -r Directory where resulting report will be saved (default: current dir) 
  -f Resulting report filename (default: ping_test.csv) 
  -i Script run interval. Every X seconds (default: 10) 
  
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
	ip --brief address >> $REPORT_DIR/$REPORT_FILE
	echo " " >> $REPORT_DIR/$REPORT_FILE
	ip route >> $REPORT_DIR/$REPORT_FILE
	
  sleep $RUN_INTERVAL
done
