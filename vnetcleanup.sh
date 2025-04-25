#!/bin/bash

# Disassociate NSG from the subnet
az network vnet subnet update \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_NAME \
  --name $SUBNET1_NAME \
  --network-security-group ""

# Disassociate route table from the subnet
az network vnet subnet update \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_NAME \
  --name $SUBNET1_NAME \
  --route-table ""

# Delete the NSG
az network nsg delete \
  --resource-group $RESOURCE_GROUP \
  --name $NSG_NAME

# Delete the route table
az network route-table delete \
  --resource-group $RESOURCE_GROUP \
  --name $ROUTE_TABLE_NAME

# Delete the virtual network (including the subnet)
az network vnet delete \
  --resource-group $RESOURCE_GROUP \
  --name $VNET_NAME

# Finally, delete the resource group (optional — deletes all resources within it)
az group delete \
  --name $RESOURCE_GROUP \
  --yes --no-wait
