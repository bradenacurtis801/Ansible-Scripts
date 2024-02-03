#!/bin/bash

# Define the image name
IMAGE_NAME="bradenacurtis801/client-base:1.0"

# Check if a container with the specified image is running
if docker ps | grep -q "$IMAGE_NAME"; then
    echo "A container with the image $IMAGE_NAME is already running."
else
    # Get the most recently stopped container
    CONTAINER_ID=$(docker ps -a --filter "status=exited" --format '{{.ID}}' | 
                  xargs -I {} docker inspect --format='{{.State.FinishedAt}} {}' {} | 
                  sort -r | head -n 1 | awk '{print $2}')

    if [ -n "$CONTAINER_ID" ]; then
        echo "Starting the most recently stopped container ($CONTAINER_ID)."
        docker start "$CONTAINER_ID"
    else
        echo "No recently stopped containers found."
    fi
fi

