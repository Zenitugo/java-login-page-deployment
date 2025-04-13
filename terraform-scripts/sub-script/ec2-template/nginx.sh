#!/bin/bash

# Update the system and install nginx
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Nginx
sudo apt-get install nginx -y

# Start and enable Nginx to run at boot
sudo systemctl start nginx
sudo systemctl enable nginx

# Allow Nginx through the firewall (if firewall is enabled)
sudo ufw allow 'Nginx HTTP'

# Check the status of Nginx
sudo systemctl status nginx

# Print the Nginx version to confirm installation
nginx -v

echo "Nginx has been installed and started."
