#!/bin/bash

# Load variables from vnet-setup.sh
source ./vnet-setup.sh

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
