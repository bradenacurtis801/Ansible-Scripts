#!/bin/bash

parallel_ssh() {
    ip="$1"
    i="$2"
    new_ip="${ip}.${i}"
    echo "Running command in $new_ip"
    ssh "ubuntu@$new_ip" "bash -s" < ./docker_login_script.sh "; docker pull bradenacurtis801/client-base:1.0" &
}

export -f parallel_ssh

while IFS= read -r ip; do
    for i in {1..20}; do
        parallel_ssh "$ip" "$i"
    done
done < client-list

# Wait for all background jobs to finish
wait

