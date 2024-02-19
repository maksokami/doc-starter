#!/bin/bash
HOME_DIR=`pwd`
FILENAME="pids"
FULL_PATH=$HOME_DIR/$FILENAME
echo $FULL_PATH

while IFS= read -r line
do
  echo "Attempting to kill process with PID: $line"
  kill $line
done < "$FULL_PATH"
