#!/bin/bash
set -e  # Exit on any error

echo "Starting infrastructure deployment..."
terraform init
terraform apply -auto-approve

# Get the IP address from Terraform output
INSTANCE_IP=$(terraform output -raw public_ip)

# Wait for SSH to become available
echo "Waiting for SSH to become available..."
while ! nc -z $INSTANCE_IP 22; do
  sleep 5
done

# Create or update inventory file
echo "Updating inventory with new IP: $INSTANCE_IP"
echo "[aws-vm]
$INSTANCE_IP ansible_user=ubuntu" > inventory

# Wait a bit for the system to fully boot
echo "Waiting for system initialization..."
sleep 30

# Run Ansible playbook
echo "Starting configuration with Ansible..."
cd /home/omer/ansible
ansible-playbook site.yaml

echo "Deployment complete!"