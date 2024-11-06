#!/bin/bash
# Define the shell interpreter to use for executing this script

# Function to get total CPU usage
get_cpu_usage() {
  # Display a label for CPU usage
  echo "Total CPU Usage:"
  # Get the CPU load percentage using 'top' command output
  top -bn1 | grep "Cpu(s)" | awk '{printf "  CPU Load: %.2f%%\n", 100 - $8}'
  # Explanation: The 'top' command is run in batch mode (-b) for one iteration (-n1).
  #              'grep' extracts the line containing CPU usage stats.
  #              'awk' calculates the CPU load as (100 - idle%), formatting it to 2 decimal places.
}

# Function to get memory usage
get_memory_usage() {
  # Display a label for memory usage stats
  echo "Memory Usage (Free vs Used):"
  # Extract memory usage data from 'free' command output
  free -m | awk 'NR==2{printf "  Used: %sMB / %sMB (%.2f%%)\n", $3, $2, $3*100/$2}'
  # Explanation: 'free -m' shows memory info in MB. The second line (NR==2) contains used/free values.
  #              'awk' prints used, total, and used percentage.
}

# Function to get disk usage
get_disk_usage() {
  # Display a label for disk usage stats
  echo "Disk Usage (Free vs Used):"
  # Extract disk usage information from the 'df' command output
  df -h | awk '$NF=="/"{printf "  Used: %s / %s (%s)\n", $3, $2, $5}'
  # Explanation: 'df -h' gives disk usage in human-readable format.
  #              'awk' filters for the root filesystem and prints used/total size and usage percent.
}

# Function to get top 5 processes by CPU usage
get_top_cpu_processes() {
  # Display a label for CPU-intensive processes
  echo "Top 5 Processes by CPU Usage:"
  # Use 'ps' to list processes sorted by CPU usage
  ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | awk '{if(NR>1) printf "  PID: %s, Command: %s, CPU: %s%%\n", $1, $2, $3}'
  # Explanation: 'ps -eo' lists PID, command, and CPU percentage of each process.
  #              '--sort=-%cpu' sorts in descending order by CPU usage.
  #              'head -n 6' limits to top 5 processes (+1 for header).
  #              'awk' formats and skips the header row.
}

# Function to get top 5 processes by memory usage
get_top_memory_processes() {
  # Display a label for memory-intensive processes
  echo "Top 5 Processes by Memory Usage:"
  # Use 'ps' to list processes sorted by memory usage
  ps -eo pid,comm,%mem --sort=-%mem | head -n 6 | awk '{if(NR>1) printf "  PID: %s, Command: %s, Memory: %s%%\n", $1, $2, $3}'
  # Explanation: 'ps -eo' lists PID, command, and memory percentage of each process.
  #              '--sort=-%mem' sorts in descending order by memory usage.
  #              'head -n 6' limits to top 5 processes (+1 for header).
  #              'awk' formats and skips the header row.
}

# Optional: Function to show OS version, uptime, load average, and logged-in users
get_additional_stats() {
  # Display additional system stats
  echo "Additional Stats:"
  # Get the OS version from /etc/os-release
  echo "  OS Version: $(cat /etc/os-release | grep -w 'PRETTY_NAME' | cut -d= -f2 | tr -d '\"')"
  # Explanation: 'cat /etc/os-release' outputs OS details.
  #              'grep -w' finds 'PRETTY_NAME' for OS name/version.
  #              'cut -d= -f2' gets the value after '=', and 'tr -d' removes quotes.

  # Get system uptime in a readable format
  echo "  Uptime: $(uptime -p)"
  # Explanation: 'uptime -p' gives uptime in human-readable format.

  # Get load averages (1, 5, and 15 minutes)
  echo "  Load Average: $(uptime | awk -F'load average:' '{print $2}')"
  # Explanation: 'uptime' outputs system load averages.
  #              'awk' extracts load averages by splitting on 'load average:'.

  # Get the number of logged-in users
  echo "  Logged-in Users: $(who | wc -l)"
  # Explanation: 'who' lists logged-in users.
  #              'wc -l' counts the number of logged-in users.

  # Display the last 10 failed login attempts (requires appropriate permissions)
  echo "  Failed Login Attempts (last 10):"
  grep "Failed password" /var/log/auth.log | tail -n 10
  # Explanation: 'grep' finds failed login attempts in the authentication log.
  #              'tail -n 10' shows the last 10 entries.
}

# Main script execution
echo "===== Server Performance Stats ====="
# Call each function in order to display performance stats
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
# End of script
