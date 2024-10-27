#!/bin/bash
# See https://medium.com/devsecops-community/only-one-script-you-need-for-monitor-linux-aa106e883d51
# Colors for readability
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
echo -e "${GREEN}===== System Monitoring Script =====${NC}"
# 1. CPU Usage
echo -e "${YELLOW}\n>> CPU Usage: ${NC}"
mpstat | awk '/all/ {print "CPU Load: " $3 "% idle"}'
# 2. Memory Usage
echo -e "${YELLOW}\n>> Memory Usage: ${NC}"
free -h | awk '/Mem/ {print "Total Memory: " $2 "\nUsed: " $3 "\nFree: " $4}'
echo -e "Swap:\n"$(free -h | awk '/Swap/ {print "Total: " $2 ", Used: " $3 ", Free: " $4}')
# 3. Disk Usage
echo -e "${YELLOW}\n>> Disk Usage: ${NC}"
df -h | grep '^/dev' | awk '{print $1 ": " $5 " used, " $4 " available"}'
# 4. Network Traffic
echo -e "${YELLOW}\n>> Network Traffic: ${NC}"
ifstat -i eth0 1 1 | awk 'NR==3 {print "RX: " $1 " KB/s, TX: " $2 " KB/s"}'
# 5. Top 5 Memory Consuming Processes
echo -e "${YELLOW}\n>> Top 5 Memory Consuming Processes: ${NC}"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6
# 6. Top 5 CPU Consuming Processes
echo -e "${YELLOW}\n>> Top 5 CPU Consuming Processes: ${NC}"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
# 7. System Logs Monitoring
echo -e "${YELLOW}\n>> Recent Errors in System Logs: ${NC}"
journalctl -p 3 -xb | tail -n 10
echo -e "${GREEN}===== Monitoring Completed =====${NC}"
