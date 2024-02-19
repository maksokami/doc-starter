#!/bin/bash
# This script reports difference in received and transmitted bytes for each system interface every REFRESH_INTERVAL
#
# **PLEASE REMOVE FIRST AND LAST LINES FROM THE RESULTING CSV**
# 
# How to interpret the results:
#  Each row value shows how many bytes was transmitted for the last REFRESH_INTERVAL seconds.
#  If you need to find out and plot data rate at each specific REFRESH_INTERVAL, calculate it as below:
#  = row_value(bytes)*8 / REFRESH_INTERVAL
# 
# Example: 
# row_value == 400 bytes
# data_rate (bits per second) = 400*8 / 10 = 320 bps

REPORT_DIR=`pwd`
REPORT_NAME="report_interface_rates"
REFRESH_INTERVAL=10

while getopts f:i:r:h flag
do
    case "${flag}" in
        f) REPORT_NAME=${OPTARG};;
        i) REFRESH_INTERVAL=${OPTARG};;
        r) REPORT_DIR=${OPTARG};;
        h) echo "Usage: script.sh [OPTIONS] 
		
Options: 
  -f Resulting report filename. CSV extention is auto-added. (default: report_interface_rates) 
  -r Directory where resulting report will be saved (default: current dir) 
  -i Script run interval. Seconds (default: 10) 
  
  ----------------- 
  no sudo privileges required
  
  Please see the script code for more details on how to interpret data.
  "
  exit 0;;
    esac
done


# Get all interfaces names
ifaces=$(ip addr | grep -E "^[0-9]:" | cut -d" " -f2 | tr -d \:)

headers+=""
for INTERFACE in $ifaces;
do
        headers+="$INTERFACE rx, $INTERFACE tx,"
done;
# Prepare the report file
echo $headers > $REPORT_DIR/$REPORT_NAME.csv

declare -A RX2 TX2;

while :
do
    DATE_TIME=$(date +"%m-%d-%Y %H:%M")
    LINUX_TIME=$(date +%s)
        data_row=""
    for INTERFACE in $ifaces;
    do
        RX1=$(cat /sys/class/net/${INTERFACE}/statistics/rx_bytes)
        TX1=$(cat /sys/class/net/${INTERFACE}/statistics/tx_bytes)
        DOWN=$(( RX1 - RX2[$INTERFACE] ))
        UP=$(( TX1 - TX2[$INTERFACE] ))
        data_row+="$DOWN,$UP,"
        RX2[$INTERFACE]=$RX1; TX2[$INTERFACE]=$TX1
    done;
    echo $data_row >> $REPORT_DIR/$REPORT_NAME.csv

    sleep $REFRESH_INTERVAL
done;
