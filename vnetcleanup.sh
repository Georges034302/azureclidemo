#!/bin/bash

# Load variables from vnet-setup.sh
source ./vnet-setup.sh

# Normalize resource names with Azure naming conventions
RESOURCE_GROUP=$(echo "$RESOURCE_GROUP" | tr '[:lower:]' '[:upper:]')
VNET_NAME=$(echo "$VNET_NAME" | tr '[:lower:]' '[:upper:]')
NSG_NAME=$(echo "$NSG_NAME" | tr '[:lower:]' '[:upper:]')
ROUTE_TABLE_NAME=$(echo "$ROUTE_TABLE_NAME" | tr '[:lower:]' '[:upper:]')

# Disassociate NSG from the subnet
echo "Disassociate NSG from the subnet"
 az network vnet subnet update \
   --resource-group $RESOURCE_GROUP \
   --vnet-name $VNET_NAME \
   --name $SUBNET1_NAME \
   --network-security-group "$NSG_NAME"
 
 # Disassociate route table from the subnet
 echo "Disassociate route table from the subnet"
 az network vnet subnet update \
   --resource-group $RESOURCE_GROUP \
   --vnet-name $VNET_NAME \
   --name $SUBNET1_NAME \
   --route-table "$ROUTE_TABLE_NAME"
   
# Delete the route table
echo "Deleting the route table: $ROUTE_TABLE_NAME"
az network route-table delete \
  --resource-group $RESOURCE_GROUP \
  --name $ROUTE_TABLE_NAME

# Delete the network security group
echo "Deleting the network security group: $NSG_NAME"
az network nsg delete \
  --resource-group $RESOURCE_GROUP \
  --name $NSG_NAME

# Delete the virtual network
echo "Deleting the virtual network: $VNET_NAME"
az network vnet delete \
  --resource-group $RESOURCE_GROUP \
  --name $VNET_NAME

# Delete the resource group
echo "Deleting the resource group: $RESOURCE_GROUP"
az group delete \
  --name $RESOURCE_GROUP \
  --yes --no-wait

echo "Cleanup completed successfully."
