#!/bin/bash
# This script periodically pings a specified destination and outputs results to a CSV file 
PING_DST="8.8.8.8"
REPORT_DIR=`pwd`
REPORT_FILE="report_ping_test.csv"
TEMP_FILE="/tmp/.tmp_ping_test"
RUN_INTERVAL=10
PING_TIMEOUT=10


while getopts d:f:i:r:t:p:h flag
do
    case "${flag}" in
	d) PING_DST=${OPTARG};;
    f) REPORT_FILE=${OPTARG};;
    i) RUN_INTERVAL=${OPTARG};;
    r) REPORT_DIR=${OPTARG};;
    t) TEMP_FILE=${OPTARG};;
	p) PING_TIMEOUT=${OPTARG};;
    h) echo "Usage: script.sh [OPTIONS]

Example: script.sh -d 1.1.1.1 -i 15

Options:
  -d Ping destination (default: 8.8.8.8)
  -f Resulting report filename (default: report_ping_test.csv)
  -i Script run interval. Every X seconds (default: 10)
  -p Ping timeout. How long to wait if no response received. Seconds. (default: 10)
  -r Directory where resulting report will be saved (default: current dir)
  -t Temporary file used to speed up script execution (default: /tmp/.tmp_ping_test)

  -----------------
  no sudo privileges required
  -----------------
 
  * STATUS - ping status field can be: success, failure, error. Error may signal that DNS resolution did not work if you're using FQDN as a destination.
  * RTT - if RTT is empty there was an error parsing it"
  exit 0;;
    esac
done

#echo "$PING_DST; $RUN_INTERVAL; $PING_TIMEOUT; $TEMP_FILE; $REPORT_FILE; $REPORT_DIR"

# Get first line with CSV column headers
headers="datetime,epoch,status,rtt(ms)"
# write headers to the report file
echo $headers > $REPORT_DIR/$REPORT_FILE


while :
do
    DATE_TIME=$(date +"%m-%d-%Y %H:%M:%S")
    LINUX_TIME=$(date +%s)
    ping -c1 -W 1 $PING_DST > $TEMP_FILE
    data_row="$DATE_TIME,$LINUX_TIME,"
	STATUS="success"
	RTT=""

	no_error=`cat $TEMP_FILE | grep -i received | wc -l`
	no_loss=`cat $TEMP_FILE | grep -oiP "\s+0\%.+packet.+loss" | wc -l`
	if [ $no_error -eq 0 ]
	then
		STATUS="error"
	elif [ $no_loss -eq 1 ]
	then
               STATUS="success"

		rtt_present=`cat $TEMP_FILE | grep -oiP "rtt.+\=" | wc -l`
		if [ $rtt_present -eq 1 ]
		then
			RTT=`cat $TEMP_FILE | grep -oiP "rtt.+\=\s+[\d.]+\/\K([\d.]+)"`
		fi
	else
		STATUS="failure"
	fi

	data_row+="$STATUS,$RTT"

  echo $data_row >> $REPORT_DIR/$REPORT_FILE
  sleep $RUN_INTERVAL
done
