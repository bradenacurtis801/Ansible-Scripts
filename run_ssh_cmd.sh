#!/bin/bash
# ANSI escape codes for colors
YELLOW='\033[1;33m'
LIGHT_BLUE='\033[1;34m'
LIGHT_GREEN='\033[38;2;106;255;0m'
GREEN='\033[38;2;77;255;0m'
ORANGE='\033[38;2;255;153;0m'
NC='\033[0m' # No Color

echo > /home/datacare/.ssh/known_hosts

while getopts "f:" opt; do
  case "$opt" in
    f) script_file="$OPTARG" ;;
    *) echo "Usage: $0 -f <scriptfile>"; exit 1 ;;
  esac
done

if [ -z "$script_file" ]; then
  echo "Error: -f <scriptfile> argument is required"
  exit 1
fi

# Define the list of client IPs
client_ips=(
#  "10.10.11"
#  "10.10.12"
#  "10.10.13"
#  "10.10.14"
  "10.10.21"
#  "10.10.22"
#  "10.10.23"
#  "10.10.24"
#  "10.10.25"
#  "10.10.111"
#  "10.10.112"
#  "10.10.113"
#  "10.10.121"
#  "10.10.122"
#  "10.10.123"
#  "10.10.124"
#  "10.10.125"
)

# Define a list of IPs to exclude
exclude_ips=(
  "10.10.14.1"
  "10.10.14.2"
  "10.10.14.3"
  "10.10.14.4"
  "10.10.14.5"
  "10.10.14.6"
  "10.10.14.7"
  "10.10.14.9"
  "10.10.14.10"
)

# Function to check if an IP is in the exclude list
is_excluded() {
    local ip=$1
    for excluded_ip in "${exclude_ips[@]}"; do
        if [[ "$ip" == "$excluded_ip" ]]; then
            return 0 # IP is in the exclude list
        fi
    done
    return 1 # IP is not in the exclude list
}

echo -e '\n----Runnung Script----\n'

# Run the script on each machine and categorize the output
for ip in "${client_ips[@]}"; do
  for i in {1..20}; do
    new_ip="${ip}.${i}"

    # Check if this new IP should be excluded
   # if is_excluded "$new_ip"; then
   #	echo -e "${GREEN}${new_ip}:${NC} ${ORANGE}Exluded${NC}"
   #     continue # Skip this IP
   # fi

    (
      result=$(ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null -oLogLevel=ERROR "ubuntu@$new_ip" 'bash -s' < "$script_file" 2>&1)
      if [[ "$result" == *"No route to host"* ]]; then
        echo -e "${LIGHT_BLUE}${new_ip}:${NC} ${YELLOW}No route to host.${NC}"
      elif [[ "$result" == *"kex_exchange_identification: read: Connection reset by peer"* ]]; then
        echo -e "${LIGHT_BLUE}${new_ip}:${NC} ${LIGHT_GREEN}kex_exchange_identification: read: Connection reset by peer${NC}"
      else
        echo "$result"
      fi
    ) &
  done
done

wait
