#!/bin/bash

# Define color codes
GREEN='\033[38;2;0;255;0m'
RED='\033[38;2;255;0;0m'
NC='\033[0m' # No Color

# Set this to true to enable the fix, or false to disable it
ENABLE_FIX=false

# Check the nvidia-smi command
nvidia-smi > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo -e "${GREEN}nvidia-smi command works. GPU information is available.${NC}"
elif [ "$ENABLE_FIX" = true ]; then
    echo -e "${RED}nvidia-smi command failed. Attempting to fix...${NC}"

    # Run the series of commands to fix the issue
    sudo apt-get update
    sudo apt-get install -y nfs-common docker.io
    sudo usermod -aG docker ubuntu
    sudo swapoff -a
    sudo sed -i '/swap/d' /etc/fstab
    sudo apt-get upgrade -y
    sudo apt-get install -y nvidia-driver-535
    sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
    
    distribution=$(. /etc/os-release; echo $ID$VERSION_ID)
    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
    curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
    
    sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
    sudo reboot
else
    echo -e "${RED}nvidia-smi command failed. Fix is disabled.${NC}"
fi

