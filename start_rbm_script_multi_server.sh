#!/bin/bash

# Server IPs
server_ips=(
    "10.10.111.1"
    "10.10.111.3"
    "10.10.112.1"
    "10.10.112.2"
    "10.10.113.1"
    "10.10.113.2"
)

# Function to run the Docker command for servers
start_server() {
    local server_ip="$1"
    echo "Starting server on ${server_ip}..."
    ssh -o StrictHostKeyChecking=no "ubuntu@${server_ip}" <<EOF
        sudo docker run --gpus all -d -p 4000:4000 --network host bradenacurtis801/rbm-server:1.0 ./inject_init_bc.sh
EOF
}

# Function to run the Docker command for clients
start_client() {
    local client_ip="$1"
    local server_ip="$2"
    local container_image="$3"
    local script="./inject_init_bc.sh -s ${server_ip}"

    echo "Processing client ${client_ip} for server ${server_ip}..."

    ssh -o StrictHostKeyChecking=no "ubuntu@${client_ip}" <<EOF
    if sudo docker ps --format "{{.Image}}" | grep -q "${container_image}"; then
        echo "Container with image ${container_image} is already running on ${client_ip}"
    else
        echo "Starting Docker container on ${client_ip}"
        sudo docker run --gpus all -d -p 4000:4000 --network host ${container_image} ${script}
        echo "Docker command executed on ${client_ip}"
    fi
EOF
}

# Start server containers
for server_ip in "${server_ips[@]}"; do
    start_server "${server_ip}"
done

# Client IP ranges
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
    # ... (remaining ranges)
)
# Start client containers in parallel
for server_ip in "${server_ips[@]}"; do
    for ((i = 0; i < ${#ip_ranges[@]}; i+=3)); do
        for j in $(seq 0 2); do
            range_index=$((i + j))
            [ $range_index -ge ${#ip_ranges[@]} ] && break
            range=${ip_ranges[$range_index]}
            for k in $(seq 1 20); do
                client_ip="${range}.${k}"
                if [[ " ${server_ips[@]} " =~ " ${client_ip} " ]]; then
                     echo "Skipping server IP ${client_ip}"
                     continue
                fi
                if [[ "$client_ip" == 10.10.12[1-5].* ]]; then
                    container_image="bradenacurtis801/rbm-client-a4000x2:1.0"
                else
                    container_image="bradenacurtis801/rbm-client:1.0"
                fi
                start_client "${client_ip}" "${server_ip}" "${container_image}" &
            done
        done
    done
done

# Wait for all background processes to finish
wait
