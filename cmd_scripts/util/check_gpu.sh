#!/bin/bash

# Define color codes
GREEN='\033[38;2;0;255;0m'
YELLOW='\033[38;2;255;255;0m'
RED='\033[38;2;255;0;0m'
TEAL='\e[38;2;0;255;187m'
NC='\033[0m' # No Color

# Set this to true to enable the fix, or false to disable it
ENABLE_FIX=false

# Get the hostname
HOST=$(hostname)

timestamp() {
  date +"%Y-%m-%d %H:%M:%S"
}

# Check the nvidia-smi command locally
nvidia-smi > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo -e "${TEAL}${HOST}:${NC} ${GREEN}[INFO] nvidia-smi command works locally. GPU information is available.${NC}"l
else    
    if [ "$ENABLE_FIX" = true ]; then
        echo -e "${TEAL}${HOST}:${NC} ${YELLOW}[WARN] nvidia-smi command failed locally. Attempting to fix...${NC}"

	sudo systemctl stop unattended-upgrades
        sudo systemctl disable unattended-upgrades

        # Run the series of commands to fix the issue
#        sudo apt-get update
#        sudo apt-get install -y nfs-common docker.io
#        sudo usermod -aG docker ubuntu
#        sudo swapoff -a
#        sudo sed -i '/swap/d' /etc/fstab
#        sudo apt-get upgrade -y
#        sudo apt-get install -y nvidia-driver-535
#        sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
#
#        distribution=$(. /etc/os-release; echo $ID$VERSION_ID)
#        curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
#        curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
#
#        sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
        sudo reboot
    else
        echo -e "${TEAL}${HOST}${NC} ${RED}[ERROR] nvidia-smi command failed locally. Fix is disabled.${NC}"
    fi
fi
