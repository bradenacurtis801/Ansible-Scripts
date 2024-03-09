#!/bin/bash

# Define the container name as a variable
CONTAINER_NAME="0000"

# Find and stop all containers with the specified name
docker ps -q --filter "name=^${CONTAINER_NAME}$" | while read container_id; do
    echo "Stopping container with ID $container_id (Name: $CONTAINER_NAME)"
    docker stop $container_id
done

