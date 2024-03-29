#!/bin/bash

GREEN='\033[38;2;0;255;0m'
RED='\033[38;2;255;0;0m'
TEAL='\e[38;2;0;255;187m'
NC='\033[0m' # No Color

HOSTNAME=$(hostname)
# Get the hostname of the machine
echo --------------------------------------------------------------------------------------------------
echo -e "$<==========={GREEN}$HOSTNAME:${NC}===========>"
sudo docker ps
echo --------------------------------------------------------------------------------------------------

