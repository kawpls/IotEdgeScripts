#!/bin/bash

# Define variables
IOTHUB_HOSTNAME=""
DEVICE_ID=""
CERTIFICATE_PATH=""
PRIVATE_KEY_PATH=""

# Step 1: Download IoT Edge
read -p "Press Enter to download IoT Edge..."
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

# Step 2: Install Moby Engine
read -p "Press Enter to install Moby Engine..."
sudo apt-get update
sudo apt-get install moby-engine

# Step 3: Install IoT Edge Runtime
read -p "Press Enter to install IoT Edge Runtime..."
sudo apt-get update
sudo apt-get install aziot-edge

# Step 4: Configure Your IoT Edge Device

# Prompt the user for input
read -p "Enter your IoT Hub hostname: " IOTHUB_HOSTNAME
read -p "Enter your device ID: " DEVICE_ID
read -p "Enter the path to your device identity certificate: " CERTIFICATE_PATH
read -p "Enter the path to your device identity private key: " PRIVATE_KEY_PATH

# Create the IoT Edge configuration file with the correct layout and user input
cat <<EOF | sudo tee /etc/aziot/config.toml
# Manual provisioning with x.509 certificates
 [provisioning]
 source = "manual"
 iothub_hostname = "$IOTHUB_HOSTNAME"
 device_id = "$DEVICE_ID"

 [provisioning.authentication]
 method = "x509"
 identity_cert = "$CERTIFICATE_PATH"
 identity_pk = "$PRIVATE_KEY_PATH"
EOF

# Step 5: Apply the Configuration
read -p "Press Enter to apply the configuration..."
sudo iotedge config apply