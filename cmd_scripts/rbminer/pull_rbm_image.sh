#!/bin/bash

GREEN='\033[38;2;0;255;0m'
RED='\033[38;2;255;0;0m'
TEAL='\e[38;2;0;255;187m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
HOSTNAME=$(hostname)

echo -e "${GREEN}Pulling image on${NC}${TEAL} $HOSTNAME${NC}"
pull_output=$(sudo docker pull bradenacurtis801/client-base:1.0 2>&1)

if [[ $pull_output == *"Image is up to date"* ]]; then
    echo -e "${GREEN}$HOSTNAME:${NC} ${TEAL}Image is already up to date${NC}"
else
    echo -e "${GREEN}$HOSTNAME:${NC} ${YELLOW}$pull_output${NC}"
fi

