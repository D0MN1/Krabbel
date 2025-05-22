#!/bin/bash

# Script to run the Krabbel application in production mode locally
# Created: May 22, 2025

echo "Loading environment variables..."
if [ -f .env.fixed ]; then
  export $(grep -v '^#' .env.fixed | xargs)
  echo "Loaded environment from .env.fixed"
else
  echo "Warning: .env.fixed not found, using default values"
fi

# Set additional variables for production testing
export SPRING_PROFILES_ACTIVE=prod
export ADMIN_PASSWORD="S@cur3Adm1nP@s5w0rd!"
export USER_PASSWORD="S@cur3Us3rP@s5w0rd!"

echo "Starting Krabbel backend in production mode..."
echo "Active profile: $SPRING_PROFILES_ACTIVE"
echo "Using database: $AZURE_MYSQL_URL"
echo ""
echo "NOTE: Make sure you've set up your database correctly and it's running"
echo "You can verify your environment with: env | grep -E 'MYSQL|JWT|ADMIN|USER'"
echo ""

cd backend
./mvnw spring-boot:run -Dspring-boot.run.profiles=prod
