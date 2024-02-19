#!/bin/bash

HOME_DIR=`pwd`
PIDS_FILE="pids"
PIDS_PATH=$HOME_DIR/$PIDS_FILE

echo -n "" | tee $PIDS_PATH

function runDockerStats() {
  nohup $HOME_DIR/track_container_stats.sh &
  echo $! | tee -a $PIDS_PATH
  nohup $HOME_DIR/track_docker_disk_space.sh &
  echo $! | tee -a $PIDS_PATH
}

function runOSStats() {
  nohup $HOME_DIR/track_os_stats.sh &
  echo $! | tee -a $PIDS_PATH
}

function runTrafficStats() {
  nohup $HOME_DIR/track_interface_rates.sh &
  echo $! | tee -a $PIDS_PATH
}

function runConnectivityStats() {
  nohup $HOME_DIR/track_iftop_connections.sh &
  echo $! | tee -a $PIDS_PATH
  nohup $HOME_DIR/track_network_info.sh &
  echo $! | tee -a $PIDS_PATH
  nohup $HOME_DIR/track_ping_test.sh &
  echo $! | tee -a $PIDS_PATH
  nohup $HOME_DIR/test_tracert.sh &
  echo $! | tee -a $PIDS_PATH
  nohup $HOME_DIR/track_curl_test.sh &
  echo $! | tee -a $PIDS_PATH
  nohup $HOME_DIR/track_curl_test_performance.sh &
  echo $! | tee -a $PIDS_PATH
}

  echo "Do you want to track docker performance?"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) runDockerStats; break;;
      No ) break;;
    esac
  done

  echo "Do you want to track OS performance?"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) runOSStats; break;;
      No ) break;;
    esac
  done
  
  echo "Do you want to track traffic on interfaces?"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) runTrafficStats; break;;
      No ) break;;
    esac
  done
  
  echo "Do you want to track traffic on interfaces?"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) runTrafficStats; break;;
      No ) break;;
    esac
  done
  
  echo "Do you want to start connectivity monitoring scripts?"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) runConnectivityStats; break;;
      No ) break;;
    esac
  done
