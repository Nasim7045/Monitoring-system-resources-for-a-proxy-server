#!/bin/bash

# Function to display the top 10 applications by CPU and Memory usage
top_10_apps() {
  echo "Top 10 Applications by CPU and Memory Usage:"
  ps aux --sort=-%cpu,-%mem | head -n 11
}

# Function to monitor network resources
network_monitoring() {
  echo "Network Monitoring:"
  echo "Concurrent Connections:"
  netstat -an | grep ESTABLISHED | wc -l

  echo "Packet Drops:"
  netstat -s | grep 'packet receive errors'

  echo "MB In and Out:"
  ifconfig | awk '/RX bytes/ {print "Received: " $2/1048576 " MB"} /TX bytes/ {print "Transmitted: " $6/1048576 " MB"}'

  echo "Disk Usage by Mounted Partitions:"
  df -h | awk '$5 > 80 {print $0 " <-- High Usage"}'

  echo "Current Load Average:"
  uptime

  echo "CPU Usage Breakdown:"
  mpstat
}

# Function to display disk usage
disk_usage() {
  echo "Disk Usage:"
  df -h
}

# Function to display system load
system_load() {
  echo "System Load:"
  uptime
}

# Function to display memory usage
memory_usage() {
  echo "Memory Usage:"
  free -h
}

# Function to monitor processes
process_monitoring() {
  echo "Process Monitoring:"
  echo "Number of Active Processes:"
  ps aux | wc -l

  echo "Top 5 Processes by CPU and Memory Usage:"
  ps aux --sort=-%cpu,-%mem | head -n 6
}

# Function to monitor the status of essential services
service_monitoring() {
  echo "Service Monitoring:"
  for service in sshd nginx apache2 iptables; do
    systemctl is-active --quiet $service && echo "$service is running" || echo "$service is not running"
  done
}

# Function to display the custom dashboard
dashboard() {
  echo "Custom Dashboard:"
  top_10_apps
  network_monitoring
  disk_usage
  system_load
  memory_usage
  process_monitoring
  service_monitoring
}

# Command-line interface
while getopts ":a:n:d:l:m:p:s:c" opt; do
  case $opt in
    a) top_10_apps ;;
    n) network_monitoring ;;
    d) disk_usage ;;
    l) system_load ;;
    m) memory_usage ;;
    p) process_monitoring ;;
    s) service_monitoring ;;
    c) dashboard ;;
    \?) echo "Invalid option: -$OPTARG" ;;
  esac
done
