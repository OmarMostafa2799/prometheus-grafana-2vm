#!/bin/bash

USER="ec2-user"

# Set Grafana hostname
sudo hostnamectl set-hostname grafana-vm

# Set Prometheus hostname
ssh "$USER@10.20.1.12" \
  "sudo hostnamectl set-hostname prometheus-vm"

# Set Worker1 hostname
ssh "$USER@10.20.1.13" \
  "sudo hostnamectl set-hostname worker1"

# Set Worker2 hostname
ssh "$USER@10.20.1.14" \
  "sudo hostnamectl set-hostname worker2"


echo "Hostnames configured successfully."
