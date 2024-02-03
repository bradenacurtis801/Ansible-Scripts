#!/bin/bash

# Define the target machine's SSH details
target_user="ubuntu"  # Replace with the target machine's username
target_host="10.10.11.20"  # Replace with the target machine's hostname or IP address
ssh_key_path="/home/datacare/.ssh/id_rsa"  # Replace with the path to your SSH private key

# List of commands to execute before reboot
commands_before_reboot=(
    "sudo apt-get update"
    "sudo apt-get install -y nfs-common docker.io"
    "sudo usermod -aG docker ubuntu"
    "sudo swapoff -a"
    "sudo sed -i '/swap/d' /etc/fstab"
    "sudo apt-get upgrade -y"
    "sudo apt-get install -y nvidia-driver-535"
    "sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target"
    "sudo apt install -y docker.io"
    "distribution=\$(. /etc/os-release; echo \$ID\$VERSION_ID) && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - && curl -s -L https://nvidia.github.io/nvidia-docker/\$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list"
    "sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit"
    "sudo docker pull bradenacurtis801/rbm-client-test:1.3"
    "sudo reboot"
)

# Execute the commands on the target machine before reboot
for command in "${commands_before_reboot[@]}"; do
    echo "Running '$command'"
    ssh -i "$ssh_key_path" "$target_user@$target_host" "$command" &>/dev/null
    wait
done

# Wait for the target machine to become reachable
while true; do
    if ping -c 1 -W 1 "$target_host" &>/dev/null; then
        break  # Exit the loop when the target machine is reachable
    fi
        echo "Waiting for the target machine to become reachable..."
        sleep 1
done

echo "Target machine is now reachable."

# List of commands to execute after the machine is back online
commands_after_reboot=(
    "sudo docker run --gpus all -it --rm -p 4000:4000 --network host bradenacurtis801/rbm-client-test:1.3 ./inject_init_bc.sh"
)

# Execute the commands on the target machine after reboot
for command in "${commands_after_reboot[@]}"; do
    echo "Running '$command'"
    ssh -i "$ssh_key_path" "$target_user@$target_host" "$command" &>/dev/null
done

