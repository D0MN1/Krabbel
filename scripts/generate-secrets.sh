#!/bin/bash
# Script to generate secure secrets for production deployment

echo "Generating secure credentials for Krabbel production deployment"
echo "=============================================================="

# Function to generate a random string of specified length
generate_secret() {
  local length=$1
  cat /dev/urandom | tr -dc 'a-zA-Z0-9!@#$%^&*()-_=+[]{}|;:,.<>?' | head -c "$length"
  echo
}

# Generate JWT Secret (64 characters)
JWT_SECRET=$(generate_secret 64)

# Generate Database Password (24 characters)
DB_PASSWORD=$(generate_secret 24)

# Create .env file for local development
echo "Creating .env file for local development..."
cat > .env << EOF
# Krabbel Application Environment Variables
# Generated on $(date)
# IMPORTANT: Do not commit this file to version control!

# Database Configuration
MYSQL_USERNAME=krabbel_user
MYSQL_PASSWORD=$DB_PASSWORD

# JWT Configuration
JWT_SECRET=$JWT_SECRET
JWT_EXPIRATION=86400000

# Other Settings
CORS_ALLOWED_ORIGINS=http://localhost:5173
EOF

echo ""
echo "Azure Environment Variables"
echo "=========================="
echo "Use these values when configuring your Azure App Service:"
echo ""
echo "AZURE_MYSQL_USERNAME: krabbel_user"
echo "AZURE_MYSQL_PASSWORD: $DB_PASSWORD"
echo "JWT_SECRET: $JWT_SECRET"
echo ""
echo "Production-ready secrets have been generated and saved to .env file"
echo "IMPORTANT: Do not commit the .env file to version control!"
