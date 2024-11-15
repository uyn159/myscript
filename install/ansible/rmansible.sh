#!/bin/bash

# Check if the script is being run with root privileges
if [[ $EUID -ne 0 ]]; then
  echo "This script requires root privileges. Please use sudo."
  exit 1
fi

# Uninstall Ansible (if installed)
if dpkg -l | grep -q ansible; then
  echo "Uninstalling Ansible..."
  apt remove -y ansible
fi

# Remove Ansible PPAs (if added)
if grep -q "ppa:ansible/ansible" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
  echo "Removing Ansible PPAs..."
  add-apt-repository --remove ppa:ansible/ansible -y
fi

# Update package lists
echo "Updating package lists..."
apt update

# Remove Ansible configuration files
echo "Removing Ansible configuration files..."
rm -rf /etc/ansible

# Remove Ansible user data
echo "Removing Ansible user data..."
rm -rf ~/.ansible

echo "Ansible has been completely uninstalled."