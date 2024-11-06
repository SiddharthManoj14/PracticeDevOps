#!/bin/bash

# Function to get total CPU usage
get_cpu_usage() {
  echo "Total CPU Usage:"
  top -bn1 | grep "Cpu(s)" | awk '{printf "  CPU Load: %.2f%%\n", 100 - $8}'
}

# Function to get memory usage
get_memory_usage() {
  echo "Memory Usage (Free vs Used):"
  free -m | awk 'NR==2{printf "  Used: %sMB / %sMB (%.2f%%)\n", $3, $2, $3*100/$2}'
}

# Function to get disk usage
get_disk_usage() {
  echo "Disk Usage (Free vs Used):"
  df -h | awk '$NF=="/"{printf "  Used: %s / %s (%s)\n", $3, $2, $5}'
}

# Function to get top 5 processes by CPU usage
get_top_cpu_processes() {
  echo "Top 5 Processes by CPU Usage:"
  ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | awk '{if(NR>1) printf "  PID: %s, Command: %s, CPU: %s%%\n", $1, $2, $3}'
}

# Function to get top 5 processes by memory usage
get_top_memory_processes() {
  echo "Top 5 Processes by Memory Usage:"
  ps -eo pid,comm,%mem --sort=-%mem | head -n 6 | awk '{if(NR>1) printf "  PID: %s, Command: %s, Memory: %s%%\n", $1, $2, $3}'
}

# Optional: Function to show OS version, uptime, load average, and logged-in users
get_additional_stats() {
  echo "Additional Stats:"
  echo "  OS Version: $(cat /etc/os-release | grep -w 'PRETTY_NAME' | cut -d= -f2 | tr -d '\"')"
  echo "  Uptime: $(uptime -p)"
  echo "  Load Average: $(uptime | awk -F'load average:' '{print $2}')"
  echo "  Logged-in Users: $(who | wc -l)"
  echo "  Failed Login Attempts (last 10):"
  grep "Failed password" /var/log/auth.log | tail -n 10
}

# Main script execution
echo "===== Server Performance Stats ====="
get_cpu_usage
echo
get_memory_usage
echo
get_disk_usage
echo
get_top_cpu_processes
echo
get_top_memory_processes
echo
get_additional_stats
echo "====================================="
