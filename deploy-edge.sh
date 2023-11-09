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
sudo cp /etc/aziot/config.toml.edge.template /etc/aziot/config.toml

# Prompt the user for input
read -p "Enter your IoT Hub hostname: " IOTHUB_HOSTNAME
read -p "Enter your device ID: " DEVICE_ID
read -p "Enter the path to your device identity certificate: " CERTIFICATE_PATH
read -p "Enter the path to your device identity private key: " PRIVATE_KEY_PATH

# Use 'sed' to replace the placeholders with user input
sudo sed -i "s|REQUIRED_IOTHUB_HOSTNAME|${IOTHUB_HOSTNAME}|" /etc/aziot/config.toml
sudo sed -i "s|REQUIRED_DEVICE_ID_PROVISIONED_IN_IOTHUB|${DEVICE_ID}|" /etc/aziot/config.toml
sudo sed -i "s|REQUIRED_URI_OR_POINTER_TO_DEVICE_IDENTITY_CERTIFICATE|${CERTIFICATE_PATH}|" /etc/aziot/config.toml
sudo sed -i "s|REQUIRED_URI_TO_DEVICE_IDENTITY_PRIVATE_KEY|${PRIVATE_KEY_PATH}|" /etc/aziot/config.toml

# Step 5: Apply the Configuration
read -p "Press Enter to apply the configuration..."
sudo iotedge config apply