#!/bin/bash

# Script to create Azure Database for MySQL Flexible Server
# This script tries different regions and SKUs to find an available option

echo "Creating Azure Database for MySQL Flexible Server for Krabbel..."

# Variables
RESOURCE_GROUP="krabbel-project"
SERVER_NAME="krabbel-mysql"
ADMIN_USER="krabbel_user"
ADMIN_PASSWORD="HM]{yQ8k7hrt-0F25$-y/PF}"
DATABASE_NAME="krabbeldb"

# Regions to try (in order of preference for EU West)
REGIONS=("westeurope" "northeurope" "francecentral" "uksouth" "germanywestcentral" "swedencentral")

# SKUs to try (updated for current availability)
SKUS=("Standard_B1ms" "Standard_B2s" "Standard_B1s" "Burstable_B1ms" "Burstable_B2s")

echo "Checking if resource group exists..."
az group show --name "$RESOURCE_GROUP" --output none 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Creating resource group $RESOURCE_GROUP..."
    az group create --name "$RESOURCE_GROUP" --location "westeurope"
fi

# Function to attempt database creation
create_database() {
    local region=$1
    local sku=$2
    
    echo "Attempting to create MySQL server in $region with SKU $sku..."
    
    az mysql flexible-server create \
        --resource-group "$RESOURCE_GROUP" \
        --name "$SERVER_NAME" \
        --location "$region" \
        --admin-user "$ADMIN_USER" \
        --admin-password "$ADMIN_PASSWORD" \
        --sku-name "$sku" \
        --storage-size 32 \
        --version "8.0.21" \
        --public-access "All" \
        --high-availability "Disabled" \
        --yes
    
    return $?
}

# Try different combinations
for region in "${REGIONS[@]}"; do
    for sku in "${SKUS[@]}"; do
        echo "Trying region: $region, SKU: $sku"
        if create_database "$region" "$sku"; then
            echo "✅ Successfully created MySQL server in $region with SKU $sku"
            
            # Create the database
            echo "Creating database $DATABASE_NAME..."
            az mysql flexible-server db create \
                --resource-group "$RESOURCE_GROUP" \
                --server-name "$SERVER_NAME" \
                --database-name "$DATABASE_NAME"
            
            # Configure firewall rules
            echo "Configuring firewall rules..."
            az mysql flexible-server firewall-rule create \
                --resource-group "$RESOURCE_GROUP" \
                --name "$SERVER_NAME" \
                --rule-name "AllowAzureServices" \
                --start-ip-address "0.0.0.0" \
                --end-ip-address "0.0.0.0"
            
            echo "✅ Database setup complete!"
            echo "Connection string: jdbc:mysql://$SERVER_NAME.mysql.database.azure.com:3306/$DATABASE_NAME?useSSL=true&requireSSL=false&serverTimezone=UTC"
            exit 0
        else
            echo "❌ Failed with region: $region, SKU: $sku"
        fi
    done
done

echo "❌ Could not create MySQL server in any region/SKU combination"
echo "You may need to try manually with different parameters or contact Azure support"
