#!/bin/bash
REPORT_DIR=`pwd`
TEMP_FILE="/tmp/.track_docker_stats"
DOCKER_STATS_FORMAT="table {{.Name}},{{.ID}},{{.CPUPerc}}\t{{.MemUsage}},{{ .NetIO}},{{.MemPerc}},{{.BlockIO}},{{.PIDs}}"
DOCKER_STATS_INTERVAL=30


while getopts i:r:t:h flag
do
    case "${flag}" in
        i) DOCKER_STATS_INTERVAL=${OPTARG};;
        r) REPORT_DIR=${OPTARG};;
        t) TEMP_FILE=${OPTARG};;
        h) echo "Usage: script.sh [OPTIONS] 

Example: script.sh -i 40 -r /tmp/final_report

Options:
  -r Directory where resulting report will be saved (default: current dir)
  -t Temporary file used to speed up script execution (default: /tmp/.track_docker_stats)
  -i Script run interval. Every X seconds (default: 30)

  -----------------
  no sudo privileges required

  exit 0;;
    esac
done



# Create a temp file to make the script faster
docker stats --no-stream --format  "$DOCKER_STATS_FORMAT" > $TEMP_FILE
# Count number of containers
line_num=`cat $TEMP_FILE | wc -l`
#((line_num-=1))
echo $line_num

# Get first line with CSV column headers
headers="datetime,epoch,"
headers+=`cat $TEMP_FILE | sed '1!d'`
# Replace all / with ,
headers_result1=${headers//\//\,}
# Replace '% ' with '%, '
headers_result2=${headers_result1//\%\ /\%\, }

# Prepare report files
for i in  $( seq 2 $line_num ) 
do
  container_name=`sed -n "$i"p $TEMP_FILE | awk -F, '{print $1}'`
  echo $headers_result2 > $REPORT_DIR/$container_name.csv
done

while :
do
    DATE_TIME=$(date +"%m-%d-%Y %H:%M")
    LINUX_TIME=$(date +%s)
    docker stats --no-stream --format  "$DOCKER_STATS_FORMAT" > $TEMP_FILE

    # Export each container to a different CSV file
    for i in  $( seq 2 $line_num ) 
    do
    container_name=`sed -n "$i"p $TEMP_FILE | awk -F, '{print $1}'`
    data_row="$DATE_TIME,$LINUX_TIME,"
    data_row+=`cat $TEMP_FILE | awk "NR==$i"`
	# Replace all / with ,
	data_result1=${data_row//\//\,}
	# Replace '% ' with '%, '
	data_result2=${data_result1//\%\ /\%\, }
    echo $data_result2 >> $REPORT_DIR/$container_name.csv
    done

  sleep $DOCKER_STATS_INTERVAL
done
