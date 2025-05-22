#!/bin/bash
# Krabbel Azure Deployment Script
# Created on May 22, 2025

set -e  # Exit on error

# Define variables
RESOURCE_GROUP="krabbel-resource-group"
LOCATION="westeurope"  # Change as needed
APP_SERVICE_PLAN="krabbel-service-plan"
WEBAPP_NAME="krabbel-backend"
MYSQL_SERVER_NAME="krabbel-mysql-server"  # Change to your desired name
MYSQL_ADMIN_USER="krabbeladmin"  # Azure MySQL admin user
MYSQL_ADMIN_PASSWORD="ComplexAdminPw123!"  # Azure MySQL admin password
DB_NAME="krabbel_db"
APP_DB_USER="krabbel_user"
APP_DB_PASSWORD="HM]{yQ8k7hrt-0F25\$-y/PF}"
JWT_SECRET="?:!cAx8-r9BrdDq9V!\\Bbl6H!Xro@7-}q%k(55!o[40EEt-(GxXelFR?svva8L@s"
FRONTEND_URL="https://krabbel-frontend.azurewebsites.net"  # Change to your frontend URL

# Step 1: Build the application
echo "Step 1: Building the Spring Boot application..."
cd /home/op/Documents/Code/Krabbel/backend
./mvnw clean package -DskipTests

echo "Step 2: Building the Vue.js frontend..."
cd /home/op/Documents/Code/Krabbel/frontend
npm run build

# Step 3: Create Azure resources
echo "Step 3: Creating Azure resources..."
echo "Creating resource group..."
az group create --name "$RESOURCE_GROUP" --location "$LOCATION"

echo "Creating Azure Database for MySQL server..."
az mysql server create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$MYSQL_SERVER_NAME" \
  --location "$LOCATION" \
  --admin-user "$MYSQL_ADMIN_USER" \
  --admin-password "$MYSQL_ADMIN_PASSWORD" \
  --sku-name GP_Gen5_2 \
  --version 5.7 \
  --ssl-enforcement Enabled

echo "Configuring firewall rules for MySQL server..."
az mysql server firewall-rule create \
  --resource-group "$RESOURCE_GROUP" \
  --server "$MYSQL_SERVER_NAME" \
  --name AllowAzureServices \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 0.0.0.0

echo "Creating database..."
az mysql db create \
  --resource-group "$RESOURCE_GROUP" \
  --server-name "$MYSQL_SERVER_NAME" \
  --name "$DB_NAME"

echo "Creating App Service Plan..."
az appservice plan create \
  --name "$APP_SERVICE_PLAN" \
  --resource-group "$RESOURCE_GROUP" \
  --sku B1 \
  --is-linux

echo "Creating Web App..."
az webapp create \
  --name "$WEBAPP_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --plan "$APP_SERVICE_PLAN" \
  --runtime "JAVA|17"

# Step 4: Configure environment variables
echo "Step 4: Configuring environment variables..."
MYSQL_URL="jdbc:mysql://${MYSQL_SERVER_NAME}.mysql.database.azure.com:3306/${DB_NAME}?useSSL=true&requireSSL=true"
MYSQL_USERNAME="${APP_DB_USER}@${MYSQL_SERVER_NAME}"

az webapp config appsettings set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$WEBAPP_NAME" \
  --settings \
  SPRING_PROFILES_ACTIVE="prod" \
  AZURE_MYSQL_URL="$MYSQL_URL" \
  AZURE_MYSQL_USERNAME="$MYSQL_USERNAME" \
  AZURE_MYSQL_PASSWORD="$APP_DB_PASSWORD" \
  JWT_SECRET="$JWT_SECRET" \
  CORS_ALLOWED_ORIGINS="$FRONTEND_URL"

# Step 5: Deploy the application
echo "Step 5: Deploying the backend application..."
cd /home/op/Documents/Code/Krabbel/backend
az webapp deploy \
  --resource-group "$RESOURCE_GROUP" \
  --name "$WEBAPP_NAME" \
  --src-path "target/krabbel-backend-0.0.1-SNAPSHOT.jar"

echo "Step 6: Deploying frontend to Azure Static Web Apps..."
echo "For frontend deployment, use the Azure Portal or GitHub Actions"
echo "Follow the guide at: https://docs.microsoft.com/en-us/azure/static-web-apps/get-started-portal"

echo "Deployment script completed!"
echo "To check your backend status, visit: https://${WEBAPP_NAME}.azurewebsites.net/actuator/health"
echo "-----------------------------------------"
echo "IMPORTANT SECURITY NOTES:"
echo "1. Once verified working, change the default admin/user passwords!"
echo "2. Set up Azure Monitor alerts for your resources"
echo "3. Configure regular database backups"
echo "4. Consider moving secrets to Azure Key Vault"
