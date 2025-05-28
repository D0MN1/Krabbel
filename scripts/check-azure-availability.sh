#!/bin/bash

# Script to check Azure MySQL availability in EU regions
echo "Checking Azure MySQL Flexible Server availability in EU regions..."

# EU Regions to check
REGIONS=("westeurope" "northeurope" "francecentral" "uksouth" "germanywestcentral" "swedencentral")

echo "Checking available locations for MySQL Flexible Server..."
az mysql flexible-server list-skus --location westeurope --output table 2>/dev/null | head -20

echo ""
echo "Checking resource providers..."
az provider show --namespace Microsoft.DBforMySQL --query "registrationState"

echo ""
echo "Available MySQL versions in West Europe:"
az mysql flexible-server list-skus --location westeurope --query "[].{Name:name,Tier:tier,Size:size}" --output table

echo ""
echo "Quota information for your subscription in West Europe:"
az vm list-usage --location westeurope --query "[?contains(name.value, 'cores')]" --output table
