#!/bin/bash
# This script records all network connections (in/out) on the interface

REPORT_DIR=`pwd`
REPORT_FILE="report_iftop_connections.txt"
RUN_INTERVAL=10
INTERFACE="eth0"


while getopts f:i:p:r:h flag
do
    case "${flag}" in
        f) REPORT_FILE=${OPTARG};;
        i) RUN_INTERVAL=${OPTARG};;
		p) INTERFACE=${OPTARG};;
        r) REPORT_DIR=${OPTARG};;
        h) echo "Usage: script.sh [OPTIONS] 
		
Example: script.sh -p eth0 -i 5  
		
Options: 
  -p Network interface name (Default: eth0)
  -r Directory where resulting report will be saved (default: current dir) 
  -f Resulting report filename (default: iftop_connections.txt) 
  -i Script run interval. Every X seconds (default: 10) 
  
  ----------------- 
  SUDO required. iftop must be installed.
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
	sudo iftop -nN -bP -i $INTERFACE -t   >>  $REPORT_DIR/$REPORT_FILE
  sleep $RUN_INTERVAL
done
