#!/bin/bash
# This script periodically sends an HTTP GET to a specified destination and plots the results to a CSV file. It is suited for tracking connectivity, but not network performance.

HTTP_DST="http://your_url/your_test_page.htm"

REPORT_DIR=`pwd`
REPORT_FILE="report_curl_test.csv"
RUN_INTERVAL=10


while getopts f:i:r:h flag
do
    case "${flag}" in
        f) REPORT_FILE=${OPTARG};;
        i) RUN_INTERVAL=${OPTARG};;
        r) REPORT_DIR=${OPTARG};;
        h) echo "Usage: script.sh [OPTIONS] 

Example: script.sh -f curl-res.txt

Options:
  -r Directory where resulting report will be saved (default: current dir)
  -f Resulting report filename (default: report_curl_test.csv) 
  -i Script run interval. Every X seconds (default: 10)

  -----------------
  no sudo privileges required
  -----------------

  * STATUS - success (200) = Page was loaded correctly. failure-<error code>."
  exit 0;;
    esac
done

# Get first line with CSV column headers
headers="datetime,epoch,status"
# write headers to the report file
echo $headers > $REPORT_DIR/$REPORT_FILE


while :
do
    DATE_TIME=$(date +"%m-%d-%Y %H:%M:%S")
    LINUX_TIME=$(date +%s)
	resp=$(curl --write-out "%{http_code}\n" --silent --output /dev/null "$HTTP_DST")
    data_row="$DATE_TIME,$LINUX_TIME,"
	STATUS="success"

	if [ $resp -eq 200 ]
	then
		STATUS="success"
	else
		STATUS="fail-$resp"
	fi

	data_row+="$STATUS"

  echo $data_row >> $REPORT_DIR/$REPORT_FILE
  sleep $RUN_INTERVAL
done
