#!/bin/bash

# Step 1: Define and export temporary variables for Azure setup
export RESOURCE_GROUP="myresourcegroup"
export LOCATION="australiaeast"  # Sydney location
export VNET_NAME="myvnet"
export VNET_ADDRESS_PREFIX="10.0.0.0/16"
export SUBNET1_NAME="subnet1"
export SUBNET1_PREFIX="10.0.1.0/24"
export NSG_NAME="mynsg"
export PUBLIC_IP_NAME="mypublicip"
export ROUTE_TABLE_NAME="myroutetable"
export ROUTE_NAME="internetroute"


# Display the variables (optional, to confirm)
echo "Resource Group: $RESOURCE_GROUP"
echo "Location: $LOCATION"
echo "VNet Name: $VNET_NAME"
echo "VNet Address Prefix: $VNET_ADDRESS_PREFIX"
echo "Subnet Name: $SUBNET1_NAME"
echo "Subnet Prefix: $SUBNET1_PREFIX"
echo "NSG Name: $NSG_NAME"
echo "Public IP Name: $PUBLIC_IP_NAME"
echo "Route Table = $ROUTE_TABLE_NAME"
echo "Route = $ROUTE_NAME"
