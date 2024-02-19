#!/bin/bash
# This script periodically sends an HTTP GET to a specified destination and plots the results to a CSV file. It is suited for tracking connectivity and performance.

HTTP_DST="http://your_url/your_test_page.htm"

REPORT_DIR=`pwd`
REPORT_FILE="report_curl_test_performance.csv"
TEMP_FILE="/tmp/.tmp_curl_test_performance"
RUN_INTERVAL=10


while getopts f:i:r:t:h flag
do
    case "${flag}" in
        f) REPORT_FILE=${OPTARG};;
        i) RUN_INTERVAL=${OPTARG};;
        r) REPORT_DIR=${OPTARG};;
        t) TEMP_FILE=${OPTARG};;
        h) echo "Usage: script.sh [OPTIONS] 
		
Example: script.sh -f curl-res.txt -i 20
		
Options: 
  -r Directory where resulting report will be saved (default: current dir) 
  -f Resulting report filename (default: report_curl_test_performance.csv) 
  -t Path and name of a temporary file required for the script execution (default: /tmp/.tmp_curl_test_performance)
  -i Script run interval. Every X seconds (default: 10) 
  
  ----------------- 
  no sudo privileges required
  -----------------  
  
  * STATUS - success (200) = Page was loaded correctly. failure-<error code>.
  
  More about curl performance metrics: 
  https://ops.tips/gists/measuring-http-response-times-curl/
  "
  exit 0;;
    esac
done

# Get first line with CSV column headers
headers="datetime,epoch,status,TCP(sec),DNS(sec),Total(sec)"
# write headers to the report file
echo $headers > $REPORT_DIR/$REPORT_FILE


while :
do
    DATE_TIME=$(date +"%m-%d-%Y %H:%M:%S")
    LINUX_TIME=$(date +%s)
	data_row="$DATE_TIME,$LINUX_TIME,"
	
	curl --write-out "%{http_code}\n%{time_connect}\n%{time_namelookup}\n%{time_total}\n" --silent --output /dev/null "$HTTP_DST" > $TEMP_FILE
	
	resp_code=`sed -n '1p' $TEMP_FILE`
	time_connect=`sed -n '2p' $TEMP_FILE`
	time_namelookup=`sed -n '3p' $TEMP_FILE`
	time_total=`sed -n '4p' $TEMP_FILE`
    STATUS="success"

	if [ $resp_code -eq 200 ]
	then
		STATUS="success"
	else
		STATUS="fail-$resp_code"
	fi

	data_row+="$STATUS,$time_connect,$time_namelookup,$time_total"
	
	# Performance metrics
	
	
  echo $data_row >> $REPORT_DIR/$REPORT_FILE
  sleep $RUN_INTERVAL
done
