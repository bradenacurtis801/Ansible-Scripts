#!/bin/bash
HOST=$(hostname)

# Check if the container with name "0000" is already running
if ! docker ps --format '{{.Names}}' | grep -q "^0000$"; then
    echo "Container '0000' is not running. Starting it now..."
    docker run -d \
      --name 0000 \
      --env MINING_ADDRESS="bc1qnp2jkflt6xvzt5nclzguhy44jkmmfh5869qn9d" \
      --env MINING_WORKER_NAME=$(hostname) \
      --env NVIDIA_VISIBLE_DEVICES=all \
      --gpus all \
      --rm \
      dockerhubnh/nicehash:latest
else
    echo "$(hostname): Container '0000' is already running."
fi

