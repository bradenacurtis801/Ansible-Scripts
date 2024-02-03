server_ip='10.10.111.3'
server_image='bradenacurtis801/rbm-server:1.0'
client_image='bradenacurtis801/client-base:1.1'
echo > /home/datacare/.ssh/known_hosts

# ANSI escape codes for colors
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    LIGHT_CYAN='\e[96m'
    CYAN='\033[0;36m'
    LIGHT_GREEN='\e[92m'
    YELLOW='\033[1;33m'
    LIGHT_BLUE='\033[1;34m'
    NC='\033[0m' # No Color

# Function to run the docker command on a remote machine
run_docker_command() {
    local ip="$1"
    local docker_usrname='bradenacurtis801'
    local container_image="${docker_usrname}/client-base:1.0"
    local server_image='bradenacurtis801/rbm-server:1.0'
    local script="./inject_init_bc.sh -s 10.10.111.3"

    ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR "ubuntu@${ip}" bash -s <<EOF
        if sudo docker ps --format "" | grep -q "${container_image}"; then 
            echo -e "${GREEN}Container with image ${container_image} is already running on ${ip}${NC}"
        elif sudo docker ps --format "" | grep -q "$server_image"; then
            echo -e "${GREEN}Container with image ${server_image} is already running on ${ip}${NC}"
        else
            output=\$(sudo docker run --gpus all -d --rm -p 4000:4000 --network host ${container_image} ${script} 2>&1)
            if [[ "\$output" == *"could not select device driver"* ]]; then
                echo -e "${RED}\$output${NC}"
            else
                echo -e "${GREEN}Docker command executed on ${ip}${NC}"
            fi
        fi
EOF

    if [ $? -ne 0 ]; then
        echo "SSH command failed on ${ip}."
    fi
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

# Loop through the IP ranges
for range in "${ip_ranges[@]}"; do
    for i in $(seq 1 20); do
        ip="${range}.${i}"
        run_docker_command "${ip}" &
    done
  done

# Wait for all background processes to complete
wait

