#!/bin/bash

# Redirect all output (stdout and stderr) to a debug file
#exec > stop_all_debug_output.log 2>&1

# Enable debugging
set -x

# Function to delete all images with specified name pattern
delete_images() {
    local ip="$1"
    ssh -o StrictHostKeyChecking=no -t "ubuntu@${ip}" << 'EOF'
    echo "Deleting all Docker images with name containing 'bradenacurtis801' on ${HOSTNAME}..."
    images=$(sudo docker images | grep "bradenacurtis801" | awk '{print $3}')
    if [ -n "$images" ]; then
        sudo docker rmi -f $images
    fi
EOF
}

# Function to stop all containers based on image name pattern
stop_all_containers() {
    local ip="$1"
    ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 "ubuntu@${ip}" << 'EOF' || echo "SSH command failed or host ${ip} is not reachable."
    echo "Stopping all containers with image name containing 'bradenacurtis801' on ${HOSTNAME}..."
    output=$(sudo docker ps -a | grep "bradenacurtis801" | awk '{print $1}' | xargs -r sudo docker stop 2>&1)
    echo "$output"
    if echo "$output" | grep -q "Error response from daemon: cannot stop container"; then
        echo "Error encountered. Rebooting ${HOSTNAME}..."
        sudo reboot
    fi
EOF
#    delete_images "$ip"
}

exclude_ips=(
	"10.10.111.3"
)

# Function to execute the stop_all_containers on a range of IPs
execute_on_range() {
    local range="$1"
    # Define an array of IPs to exclude

    for i in $(seq 1 20); do
        local ip="${range}.${i}"

        # Check if the IP is in the exclude list
        if [[ " ${exclude_ips[@]} " =~ " ${ip} " ]]; then
            echo "Skipping ${ip}..."
            continue
        fi

        echo "Processing ${ip}..."
        stop_all_containers "${ip}" &
    done
}
# List of IP address ranges
ip_ranges=(
    "10.10.11"
    "10.10.12"
    "10.10.13"
    "10.10.14"
    "10.10.21"
    "10.10.22"
    "10.10.23"
    "10.10.24"
    "10.10.25"
    "10.10.111"
    "10.10.112"
    "10.10.113"
    "10.10.121"
    "10.10.122"
    "10.10.123"
    "10.10.124"
    "10.10.125"
)

# Loop through the IP ranges and execute stop_all_containers
for range in "${ip_ranges[@]}"; do
    execute_on_range "${range}"
done

# Wait for all background processes to complete
wait
echo "All containers have been processed."

