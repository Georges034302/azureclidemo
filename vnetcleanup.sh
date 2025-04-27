#!/bin/bash

# Load variables from setup.sh
source ./setup.sh

# Normalize resource names with Azure naming conventions
RESOURCE_GROUP=$(echo "$RESOURCE_GROUP" | tr '[:lower:]' '[:upper:]')
VNET_NAME=$(echo "$VNET_NAME" | tr '[:lower:]' '[:upper:]')
NSG_NAME=$(echo "$NSG_NAME" | tr '[:lower:]' '[:upper:]')
ROUTE_TABLE_NAME=$(echo "$ROUTE_TABLE_NAME" | tr '[:lower:]' '[:upper:]')

# Clear NSG reference from the subnet
echo "Clearing NSG reference from the subnet..."
az network vnet subnet update \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_NAME \
  --name $SUBNET1_NAME \
  --network-security-group "" 2>/dev/null

# Clear route table reference from the subnet
echo "Clearing route table reference from the subnet..."
az network vnet subnet update \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_NAME \
  --name $SUBNET1_NAME \
  --route-table "" 2>/dev/null

# Delete the route table
echo "Deleting the route table..."
az network route-table delete \
  --resource-group $RESOURCE_GROUP \
  --name $ROUTE_TABLE_NAME 2>/dev/null

# Delete the network security group
echo "Deleting the network security group..."
az network nsg delete \
  --resource-group $RESOURCE_GROUP \
  --name $NSG_NAME 2>/dev/null

# Delete the virtual network
echo "Deleting the virtual network..."
az network vnet delete \
  --resource-group $RESOURCE_GROUP \
  --name $VNET_NAME 2>/dev/null

# Delete the resource group
echo "Deleting the resource group..."
az group delete \
  --name $RESOURCE_GROUP \
  --yes \
  --no-wait 2>/dev/null
