#!/bin/bash

# Define the Docker image name and tag to check
IMAGE_NAME="bradenacurtis801/client-base"
IMAGE_TAG="1.0"

# Get the hostname and use it as the IP
ip="$(hostname)"

# Check if the image exists locally
if sudo docker images | grep -q "$IMAGE_NAME\s*$IMAGE_TAG"; then
  # Output in green if the image exists
  echo -e "\e[32m$ip has image\e[0m"  # \e[32m sets color to green, \e[0m resets to default
else
  # Output in red if the image doesn't exist
  echo -e "\e[31m$ip does not have image\e[0m"  # \e[31m sets color to red, \e[0m resets to default
fi

