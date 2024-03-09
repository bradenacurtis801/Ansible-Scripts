#!/bin/bash

LIGHT_BLUE='\033[1;34m'
GREEN='\033[38;2;77;255;0m'
NC='\033[0m' # It seems the NC (No Color) variable was used but not defined in your original script, adding it here for completeness.

HOSTNAME=$(hostname)

echo -e "${LIGHT_BLUE}$HOSTNAME:${NC} ${GREEN}Stopping unattended-upgrades.${NC}"
sudo systemctl stop unattended-upgrades > /dev/null 2>&1
sudo systemctl disable unattended-upgrades > /dev/null 2>&1
sudo systemctl status unattended-upgrades > /dev/null 2>&1

