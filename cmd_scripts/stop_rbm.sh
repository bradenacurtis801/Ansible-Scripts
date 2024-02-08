#!/bin/bash

GREEN='\033[38;2;0;255;0m'
RED='\033[38;2;255;0;0m'
TEAL='\e[38;2;0;255;187m'
YELLOW="\033[38;5;11m"
NC='\033[0m' # No Color

# Define variables for image names
IMAGE_NAME="bradenacurtis801"
CONTAINER_IMAGE_NAME="$IMAGE_NAME/client-base"

# Function to delete all images with specified name pattern
delete_images() {
    echo -e "${YELLOW}Deleting all Docker images with name containing${NC}${TEAL} '$IMAGE_NAME'${NC}${YELLOW} on \${HOSTNAME}...${NC}"
    images=$(sudo docker images | grep "$IMAGE_NAME" | awk '{print $3}')
    if [ -n "$images" ]; then
        sudo docker rmi -f $images
    fi
}

# Function to stop all containers based on image name pattern
stop_all_containers() {
    echo "Stopping all containers with image name containing '$IMAGE_NAME' on ${HOSTNAME}..."
    output=$(sudo docker ps -a | grep "$CONTAINER_IMAGE_NAME" | awk '{print $1}' | xargs -r sudo docker stop 2>&1)
    echo "$output"
    if echo "$output" | grep -q "Error response from daemon: cannot stop container"; then
        echo "Error encountered. Rebooting ${HOSTNAME}..."
        sudo reboot
    fi
}

stop_all_containers

# Check command-line parameters and call appropriate functions
#while getopts ":d:s:" opt; do
#    case ${opt} in
#        d)  echo -d worked #delete_images
#            ;;
#        s)  echo -s worked #stop_all_containers
#            ;;
#        \?) echo "Invalid option: -$OPTARG" >&2
#            ;;
#    esac
#done

