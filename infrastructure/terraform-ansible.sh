#!/bin/bash
terraform init
terraform apply -auto-approve
sleep 60  # Wait for instance to fully boot
ansible-playbook -i inventory site.yaml