#!/bin/bash

# Check if the script is being run with root privileges
if [[ $EUID -ne 0 ]]; then
  echo "This script requires root privileges. Please use sudo."
  exit 1
fi

# Update package lists
echo "Updating package lists..."
apt update

# Install software-properties-common (if not already installed)
if ! dpkg -l | grep -q software-properties-common; then
  echo "Installing software-properties-common..."
  apt install -y software-properties-common
fi

# Add Ansible PPA
echo "Adding Ansible PPA..."
add-apt-repository --yes ppa:ansible/ansible

# Update package lists again
echo "Updating package lists..."
apt update

# Install Ansible
echo "Installing Ansible..."
apt install -y ansible

# Verify Ansible installation
echo "Verifying Ansible installation..."
ansible --version

echo "Ansible has been successfully installed."