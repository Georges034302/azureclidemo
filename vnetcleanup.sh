#!/bin/bash

# Load variables from setup.sh
source ./setup.sh

# Normalize resource names with Azure naming conventions
RESOURCE_GROUP=$(echo "$RESOURCE_GROUP" | tr '[:lower:]' '[:upper:]')
VNET_NAME=$(echo "$VNET_NAME" | tr '[:lower:]' '[:upper:]')
NSG_NAME=$(echo "$NSG_NAME" | tr '[:lower:]' '[:upper:]')
ROUTE_TABLE_NAME=$(echo "$ROUTE_TABLE_NAME" | tr '[:lower:]' '[:upper:]')

# Disassociate NSG from the subnet
echo "Disassociating NSG from the subnet: $SUBNET1_NAME"
az network vnet subnet update \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_NAME \
  --name $SUBNET1_NAME \
  --network-security-group "" || echo "NSG already disassociated or does not exist."

# Disassociate route table from the subnet
echo "Disassociating route table from the subnet: $SUBNET1_NAME"
az network vnet subnet update \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_NAME \
  --name $SUBNET1_NAME \
  --route-table "" || echo "Route table already disassociated or does not exist."

# Delete the route table
echo "Deleting the route table: $ROUTE_TABLE_NAME"
az network route-table delete \
  --resource-group $RESOURCE_GROUP \
  --name $ROUTE_TABLE_NAME || echo "Route table already deleted or does not exist."

# Delete the network security group
echo "Deleting the network security group: $NSG_NAME"
az network nsg delete \
  --resource-group $RESOURCE_GROUP \
  --name $NSG_NAME || echo "NSG already deleted or does not exist."

# Delete the virtual network
echo "Deleting the virtual network: $VNET_NAME"
az network vnet delete \
  --resource-group $RESOURCE_GROUP \
  --name $VNET_NAME || echo "Virtual network already deleted or does not exist."

# Delete the resource group
echo "Deleting the resource group: $RESOURCE_GROUP"
az group delete \
  --name $RESOURCE_GROUP \
  --yes --no-wait || echo "Resource group already deleted or does not exist."

echo "Cleanup completed successfully."
