#!/bin/bash

# Variables
RESOURCE_GROUP="MyResourceGroup"
LOCATION="australiaeast"
VNET_NAME="MyVNet"
SUBNET_NAME="MySubnet"
NSG_NAME="MyNSG"
VM_NAME="MyVM"
VM_IMAGE="UbuntuLTS"
VM_SIZE="Standard_B1s"
VM_USERNAME="azureuser"
VM_PUBLIC_IP_NAME="MyPublicIP"
NIC_NAME="MyVMNIC"
HTML_FILE_PATH="/var/www/html/index.html"  # Path to HTML file

# 1. Create Resource Group
az group create --name $RESOURCE_GROUP --location $LOCATION

# 2. Create Virtual Network (VNet)
az network vnet create \
  --resource-group $RESOURCE_GROUP \
  --name $VNET_NAME \
  --location $LOCATION \
  --address-prefix "10.0.0.0/16" \
  --subnet-name $SUBNET_NAME \
  --subnet-prefix "10.0.0.0/24"

# 3. Create Network Security Group (NSG)
az network nsg create \
  --resource-group $RESOURCE_GROUP \
  --name $NSG_NAME \
  --location $LOCATION

# 4. Add NSG Rule for HTTP (Port 80)
az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $NSG_NAME \
  --name AllowHTTP \
  --protocol tcp \
  --direction inbound \
  --priority 1000 \
  --source-address-prefixes '*' \
  --source-port-ranges '*' \
  --destination-port-ranges 80 \
  --access allow

# 5. Create Public IP Address
az network public-ip create \
  --resource-group $RESOURCE_GROUP \
  --name $VM_PUBLIC_IP_NAME \
  --allocation-method Dynamic \
  --sku Basic

# 6. Create Network Interface Card (NIC)
az network nic create \
  --resource-group $RESOURCE_GROUP \
  --name $NIC_NAME \
  --vnet-name $VNET_NAME \
  --subnet $SUBNET_NAME \
  --network-security-group $NSG_NAME \
  --public-ip-address $VM_PUBLIC_IP_NAME

# 7. Create Virtual Machine (VM)
az vm create \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --image $VM_IMAGE \
  --size $VM_SIZE \
  --admin-username $VM_USERNAME \
  --authentication-type password \
  --nics $NIC_NAME \
  --no-wait

# 8. Install Apache Web Server and Ensure it's Running
az vm run-command invoke \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --command-id RunShellScript \
  --scripts \
    "sudo apt-get update" \
    "sudo apt-get install -y apache2" \
    "sudo systemctl enable apache2" \
    "sudo systemctl start apache2"

# 9. Create HTML Page to Serve on the Web Server
az vm run-command invoke \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --command-id RunShellScript \
  --scripts \
    "echo '<html><body><h1>Hello from my VM!</h1></body></html>' | sudo tee $HTML_FILE_PATH"

# 10. Get the VM Public IP to Access HTTP
VM_PUBLIC_IP=$(az vm show \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --query "publicIps" \
  --output tsv)

# Output VM public IP for HTTP access
echo "Your VM is accessible at: http://$VM_PUBLIC_IP"