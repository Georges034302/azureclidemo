#!/bin/bash

# Step 1: Define and export temporary variables for Azure setup
export RESOURCE_GROUP="MyResourceGroup"  # Lowercase with no spaces
export LOCATION="australiaeast"
export VNET_NAME="MyVNet"  # Lowercase
export VNET_ADDRESS_PREFIX="10.0.0.0/16"
export SUBNET_NAME="FrontendSubnet"  # Lowercase
export SUBNET_PREFIX="10.0.1.0/24"    # Fixed here
export NSG_NAME="MyNSG"  # Lowercase
export VM_NAME="webserver"  # Lowercase, typically valid as is
export VM_IMAGE="Ubuntu2404"  # Azure uses the image names in a case-insensitive way
export VM_SIZE="Standard_B2ms"  # Azure VM sizes use a specific naming convention
export VM_USERNAME="azureuser"  # Valid username
export VM_PUBLIC_IP_NAME="MyPublicIP"  # Lowercase with no spaces
export NIC_NAME="MyNIC"  # Lowercase
export HTML_FILE_PATH="/var/www/html/index.html"  # Valid as is


# Display the variables (optional, to confirm)
echo "Setup Environment Variables ..."
echo "Resource Group: $RESOURCE_GROUP"
echo "Location: $LOCATION"
echo "VNet Name: $VNET_NAME"
echo "VNet Address Prefix: $VNET_ADDRESS_PREFIX"
echo "Subnet Name: $SUBNET_NAME"
echo "Subnet Prefix: $SUBNET_PREFIX"
echo "NSG Name: $NSG_NAME"
echo "Webserver Name: $VM_NAME"
echo "VM Size: $VM_SIZE"
echo "NIC Name: $NIC_NAME"
echo "Public IP Name: $VM_PUBLIC_IP_NAME"
echo "Username: $VM_USERNAME"
echo "Website: $HTML_FILE_PATH"
