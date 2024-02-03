#!/bin/bash

# Initialize variables
master_ip=""
worker_ip=""

# Process command-line options
while getopts "m:w:" opt; do
  case $opt in
    m)
      master_ip="$OPTARG"
      ;;
    w)
      worker_ip="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Check if master_ip and worker_ip are provided
if [ -z "$master_ip" ] || [ -z "$worker_ip" ]; then
    echo "Usage: $0 -m <master_ip> -w <worker_ip>"
    exit 1
fi

# Load environment variables from .env file
source .env

# Remote machine details
remote_user="ubuntu"
remote_ip="$worker_ip"
remote_kube_dir="/home/ubuntu/.kube"
remote_kube_file="${remote_kube_dir}/config"
script_file="k3s_install_script.sh"

# Update k3s.yaml content with master IP and certificate data
yml_content=$(cat <<EOF
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: $CERTIFICATE_AUTHORITY_DATA
    server: https://$master_ip:6443
  name: default
contexts:
- context:
    cluster: default
    user: default
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: default
  user:
    client-certificate-data: $CLIENT_CERTIFICATE_DATA
    client-key-data: $CLIENT_KEY_DATA
EOF
)

# Create the .kube directory on the remote machine and write the file
# Execute commands and the contents of the script on the remote machine in one SSH session
ssh "${remote_user}@${remote_ip}" "
    mkdir -p ${remote_kube_dir} &&
    echo \"$yml_content\" > ${remote_kube_file} &&
    chmod 600 ${remote_kube_file} &&
    $(<"$script_file")
"
# Check if ssh command was successful
if [ $? -eq 0 ]; then
    echo "k3s.yaml content written to remote machine successfully."
else
    echo "Error writing k3s.yaml content to remote machine."
fi

