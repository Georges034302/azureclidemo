#!/bin/bash

# Create resource group
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION

# Create virtual network with subnet
az network vnet create \
  --resource-group $RESOURCE_GROUP \
  --name $VNET_NAME \
  --location $LOCATION \
  --address-prefix $VNET_ADDRESS_PREFIX \
  --subnet-name $SUBNET1_NAME \
  --subnet-prefix $SUBNET1_PREFIX

# Create network security group
az network nsg create \
  --resource-group $RESOURCE_GROUP \
  --name $NSG_NAME \
  --location $LOCATION

# Add HTTP rule to NSG
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

# Associate NSG with subnet
az network vnet subnet update \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_NAME \
  --name $SUBNET1_NAME \
  --network-security-group $NSG_NAME

# Create route table
az network route-table create \
  --resource-group $RESOURCE_GROUP \
  --name $ROUTE_TABLE_NAME \
  --location $LOCATION

# Add route to route table
az network route-table route create \
  --resource-group $RESOURCE_GROUP \
  --route-table-name $ROUTE_TABLE_NAME \
  --name $ROUTE_NAME \
  --address-prefix 0.0.0.0/0 \
  --next-hop-type Internet

# Associate route table with subnet
az network vnet subnet update \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_NAME \
  --name $SUBNET1_NAME \
  --route-table $ROUTE_TABLE_NAME
