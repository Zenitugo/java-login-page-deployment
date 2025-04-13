#!/bin/bash

# Update the system and install Java (Tomcat requires Java)
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install openjdk-11-jdk -y

# Verify Java installation
java -version

# Install wget to download Tomcat
sudo apt-get install wget -y

# Install Maven
sudo apt-get install maven -y

# Verify Maven installation
mvn -v

# Download and install Tomcat (version 9)
cd /opt
sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.58/bin/apache-tomcat-9.0.58.tar.gz

# Extract the Tomcat archive
sudo tar -xvzf apache-tomcat-9.0.58.tar.gz
sudo mv apache-tomcat-9.0.58 tomcat

# Set permissions
sudo chown -R $USER:$USER /opt/tomcat

# Start Tomcat
cd /opt/tomcat/bin
./startup.sh

# Enable Tomcat to start at boot by creating a systemd service
echo "[Unit]
Description=Tomcat
After=network.target

[Service]
Type=forking
PIDFile=/opt/tomcat/tomcat.pid
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
User=$USER
Group=$USER
Ulimits=1024
TimeoutStartSec=0
TimeoutStopSec=60
Restart=always

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/tomcat.service

# Reload systemd, enable and start the Tomcat service
sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat

# Check Tomcat status
sudo systemctl status tomcat

echo "Tomcat and Maven have been installed and started."
