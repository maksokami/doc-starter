# debian_monitoring
Collection of scripts to capture various information for performance and connectivity troubleshooting.

# Start/stop scripts
## script_runall.sh
Offers an interactive dialog to start all or specific groups of scripts with default settings. Records PIDs to "pids" file.

## script_killall.sh
Kills processes listed in "pids" file.

# Docker performance
## track_docker_disk_space.sh
The script shows results of the 'df /storage/var/lib/docker/' command.

OUTPUT EXAMPLE
```
datetime,         epoch,      Filesystem,              1K-blocks,  Used,     Available,  Use%, Mounted
11-23-2020 19:37, 1606160247, /dev/mapper/cryptostore, 89874296,   12381940, 72883948,   15%,  /storage
. . .
```

## track_container_stats.sh
**sudo or a user in the docker group required.** 

THe script creates a CSV file for each running module with the following data:
`{{.Name}},{{.ID}},{{.CPUPerc}}\t{{.MemUsage}},{{ .NetIO}},{{.MemPerc}},{{.BlockIO}},{{.PIDs}}`

OUTPUT EXAMPLE

hello-world.csv
```
datetime,epoch,NAME,CONTAINER ID,CPU %, MEM USAGE , LIMIT,NET I,O,MEM %,BLOCK I,O,PIDS
11-23-2020 19:41,1606160502,hello-world,b31c407117e1,0.00%, 35.04MiB , 7.653GiB,991kB , 922kB,0.45%,173MB , 28.7kB,17
11-23-2020 19:42,1606160535,hello-world,b31c407117e1,2.97%, 35.07MiB , 7.653GiB,991kB , 922kB,0.45%,173MB , 28.7kB,19
```
nginx.csv
```
datetime,epoch,NAME,CONTAINER ID,CPU %, MEM USAGE , LIMIT,NET I,O,MEM %,BLOCK I,O,PIDS
11-23-2020 19:41,1606160502,nginx,54194c40b417,0.23%, 59.32MiB , 190.7MiB,2.39MB , 2.41MB,31.10%,336MB , 508kB,30
11-23-2020 19:42,1606160535,nginx,54194c40b417,0.25%, 59.34MiB , 190.7MiB,2.39MB , 2.41MB,31.11%,336MB , 508kB,29
```


# OS performance
## track_os_stats.sh
CPU, RAM, SWAP details, root fs utilization.

OUTPUT EXAMPLE

```
datetime,         epoch,      CPU_avg_1min, CPU_avg_5min, CPU_avg_15min, RAM,  SWAP,   ROOT_FS
11-23-2020 19:47, 1606160865, 0.39%,        0.29%,        0.21%,         4.30%, 0.03%, 9%
11-23-2020 19:48, 1606160896, 0.24%,        0.26%,        0.20%,         4.31%, 0.03%, 9%
11-23-2020 19:48, 1606160927, 0.13%,        0.23%,        0.19%,         4.24%, 0.03%, 9%
. . .
```

# Traffic on interfaces
## track_interface_rates.sh
This script reports difference in received and transmitted bytes for each system interface every REFRESH_INTERVAL

**PLEASE REMOVE FIRST AND LAST LINES FROM THE RESULTING CSV**
 
How to interpret the results:
Each row value shows how many bytes was transmitted for the last REFRESH_INTERVAL seconds.
If you need to find out and plot data rate at each specific REFRESH_INTERVAL, calculate it as below:
 = row_value(bytes)*8 / REFRESH_INTERVAL

Example: 
row_value == 400 bytes
data_rate (bits per second) = 400*8 / 10 = 320 bps

```
Time (sec) ens2 rx	 ens2 tx	enp0s10f0u2i8 rx	enp0s12f0u2i8 tx
20         1940	     2880	        96.8            	52
30	       27573	   17664	      176	              330
40	       2078	     2880	        0               	121
```

# General connectivity monitoring scripts
## test_tracert.sh
Continuously performs "tracert" to 8.8.8.8 or a specified destination.

## track_ping_test.sh
This script periodically pings a specified destination and plots the results to a CSV file 


- STATUS - ping status field can be: success, failure, error. Error may signal that DNS resolution didn't work if you're using FQDN as a destination.
- RTT - if RTT is empty there was an error parsing it
  

OUTPUT EXAMPLE

```
datetime,            epoch,      status,  rtt(ms)
11-23-2020 20:02:42, 1606161762, success, 17.882
11-23-2020 20:02:52, 1606161772, success, 16.674
```

## track_curl_test.sh
This script periodically sends an HTTP GET to a specified destination and stores results to a CSV file. It is suited for tracking connectivity, but not network performance.
  
STATUS:  
 - success (200) = Page was loaded correctly. 
 - failure-[error code]
  
OUTPUT EXAMPLE
```
datetime,            epoch,     status
11-23-2020 19:30:21,1606159821, success
. . .
```

## track_curl_test_performance.sh
This script periodically sends an HTTP GET to a specified destination and stores results to a CSV file. It is suited for tracking connectivity and performance.
  
Status:
- success (200) - The page was loaded correctly. 
- failure-[error code].
  
More about curl performance metrics:   
https://ops.tips/gists/measuring-http-response-times-curl/
  
OUTPUT EXAMPLE
```
datetime,            epoch,      status,  TCP(sec), DNS(sec), Total(sec)
11-23-2020 19:31:30, 1606159890, success, 0.147557, 0.012584, 0.292898
11-23-2020 19:31:40, 1606159900, success, 0.147508, 0.012553, 0.332410
. . .
```

## track_iftop_connections.sh
Repetedly record "iftop" output for eth0 or another specified interface.  

Example of the output:
```
11-22-202o 22:45:50 - [epoch here]
Listening on eth0
   # Host name (port/service if enabled)            last 2s   last 10s   last 40s cumulative
--------------------------------------------------------------------------------------------
   1 192.168.60.100:22                         =>     18.7Kb     18.7Kb     18.7Kb     4.68KB
     10.10.1.10:60161                        <=     20.4Kb     20.4Kb     20.4Kb     5.10KB
   2 192.168.60.100:22                         =>         0b         0b         0b         0B
     10.10.1.10:58159                        <=       160b       160b       160b        40B
--------------------------------------------------------------------------------------------
Total send rate:                                     18.7Kb     18.7Kb     18.7Kb
Total receive rate:                                  20.6Kb     20.6Kb     20.6Kb
Total send and receive rate:                         39.3Kb     39.3Kb     39.3Kb
--------------------------------------------------------------------------------------------
Peak rate (sent/received/total):                     18.7Kb     20.6Kb     39.3Kb
Cumulative (sent/received/total):                    4.68KB     5.14KB     9.82KB
============================================================================================

   # Host name (port/service if enabled)            last 2s   last 10s   last 40s cumulative
--------------------------------------------------------------------------------------------
   1 192.168.60.100:22                         =>     27.8Kb     23.2Kb     23.2Kb     11.6KB
     10.10.1.10:60161                        <=     30.5Kb     25.5Kb     25.5Kb     12.7KB
   2 192.168.60.100:22                         =>         0b         0b         0b         0B
     10.10.1.10:58159                        <=         0b        80b        80b        40B
--------------------------------------------------------------------------------------------
Total send rate:                                     27.8Kb     23.2Kb     23.2Kb
Total receive rate:                                  30.5Kb     25.5Kb     25.5Kb
Total send and receive rate:                         58.3Kb     48.8Kb     48.8Kb
--------------------------------------------------------------------------------------------
. . .
```
