#!/bin/bash

# Script to run Flyway migrations manually
# Created: May 22, 2025

echo "Loading environment variables..."
if [ -f ../.env ]; then
  export $(grep -v '^#' ../.env | xargs)
  echo "Loaded environment from .env"
else
  echo "Warning: .env not found, using default values"
fi

echo "Running Flyway migrations..."
cd ../backend

# Set database connection properties
DB_URL="${AZURE_MYSQL_URL:-jdbc:mysql://krabbeldb.mysql.database.azure.com:3306/krabbeldb?useSSL=true&requireSSL=true&serverTimezone=UTC&createDatabaseIfNotExist=true}"
DB_USER="${AZURE_MYSQL_USERNAME:-krabbel_user}"
DB_PASSWORD="${AZURE_MYSQL_PASSWORD:-HM]{yQ8k7hrt-0F25$-y/PF}"

# Run Flyway manually
./mvnw flyway:migrate \
  -Dflyway.url="$DB_URL" \
  -Dflyway.user="$DB_USER" \
  -Dflyway.password="$DB_PASSWORD" \
  -Dflyway.baselineOnMigrate=true \
  -Dflyway.locations="classpath:db/migration"

echo "Flyway migrations completed."
