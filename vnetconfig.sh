#!/bin/bash

# Load variables from vnet-setup.sh
source ./setup.sh

# Normalize resource names with Azure naming conventions
RESOURCE_GROUP=$(echo "$RESOURCE_GROUP" | tr '[:lower:]' '[:upper:]')
VNET_NAME=$(echo "$VNET_NAME" | tr '[:lower:]' '[:upper:]')
NSG_NAME=$(echo "$NSG_NAME" | tr '[:lower:]' '[:upper:]')
ROUTE_TABLE_NAME=$(echo "$ROUTE_TABLE_NAME" | tr '[:lower:]' '[:upper:]')

# Retrieve the subscription ID
SUBSCRIPTION_ID=$(az account show --query id --output tsv)

# Create a resource group
echo "Creating resource group: $RESOURCE_GROUP in $LOCATION"
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create a virtual network and a subnet
echo "Creating virtual network: $VNET_NAME with subnet: $SUBNET1_NAME"
az network vnet create \
  --resource-group $RESOURCE_GROUP \
  --name $VNET_NAME \
  --address-prefix $VNET_ADDRESS_PREFIX \
  --subnet-name $SUBNET1_NAME \
  --subnet-prefix $SUBNET1_PREFIX \
  --location $LOCATION

# Create a network security group
echo "Creating network security group: $NSG_NAME"
az network nsg create \
  --resource-group $RESOURCE_GROUP \
  --name $NSG_NAME \
  --location $LOCATION

# Add HTTP rule to NSG
echo "Creating NSG rule to allow HTTP traffic"
az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $NSG_NAME \
  --name Allow-HTTP \
  --priority 200 \
  --direction Inbound \
  --access Allow \
  --protocol Tcp \
  --destination-port-ranges 80 \
  --source-address-prefixes '*' \
  --destination-address-prefixes '*' \
  --description "Allow inbound HTTP traffic on port 80"

# Create a route table
echo "Creating route table: $ROUTE_TABLE_NAME"
az network route-table create \
  --resource-group $RESOURCE_GROUP \
  --name $ROUTE_TABLE_NAME \
  --location $LOCATION

# Add a route to the route table (open to internet)
echo "Adding route to route table: $ROUTE_TABLE_NAME"
az network route-table route create \
  --resource-group $RESOURCE_GROUP \
  --route-table-name $ROUTE_TABLE_NAME \
  --name $ROUTE_NAME \
  --address-prefix 0.0.0.0/0 \
  --next-hop-type Internet

# Debugging: Print the resource IDs being passed
echo "Using NSG Resource ID: $NSG_RESOURCE_ID"
echo "Using Route Table Resource ID: $ROUTE_TABLE_RESOURCE_ID"

# Associate the NSG and route table with the subnet
echo "Associating network $NSG_NAME and $ROUTE_TABLE_NAME with subnet: $SUBNET1_NAME"
az network vnet subnet update \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_NAME \
  --name $SUBNET1_NAME \
  --network-security-group "$NSG_NAME" \
  --route-table "$ROUTE_TABLE_NAME"

echo "Azure VNet configuration completed successfully."
