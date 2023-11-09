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
## Manual provisioning with X.509 certificate
 [provisioning]
 source = "manual"
 iothub_hostname = "example.azure-devices.net"
 device_id = "my-device"
#
 [provisioning.authentication]
 method = "x509"
#
## identity key
 identity_pk = "file:///var/secrets/device-id.key.pem"              # file URI, or...
# identity_pk = "pkcs11:slot-id=0;object=device%20id?pin-value=1234" # PKCS#11 URI
#
## identity certificate
 identity_cert = "file:///var/secrets/device-id.pem"                # file URI, or...
# [provisioning.authentication.identity_cert]                        # dynamically issued via...
# method = "est"                                                     # - EST
# method = "local_ca"                                                # - a local CA
# common_name = "my-device"                                          # with the given common name, or...
# subject = { L = "AQ", ST = "Antarctica", CN = "my-device" }        # with the given DN fields
EOF

# Step 5: Apply the Configuration
read -p "Press Enter to apply the configuration..."
sudo iotedge config apply# 
