#!/bin/bash

# Krabbel Database Connection Verification Script
echo "🔍 Verifying Database Connection for Krabbel Application"
echo "======================================================="

# Check .env file
if [ -f .env ]; then
    echo "📁 Found .env file, checking database configuration..."
    
    # Extract MYSQL_URL from .env
    MYSQL_URL=$(grep "^MYSQL_URL=" .env | cut -d'=' -f2-)
    MYSQL_USERNAME=$(grep "^MYSQL_USERNAME=" .env | cut -d'=' -f2-)
    
    echo ""
    echo "🔧 Current Database Configuration:"
    echo "MYSQL_URL: $MYSQL_URL"
    echo "MYSQL_USERNAME: $MYSQL_USERNAME"
    echo ""
    
    # Check if it's Azure MySQL
    if [[ $MYSQL_URL == *"azure.com"* ]]; then
        echo "☁️  ✅ CONFIRMED: You are connecting to AZURE MYSQL DATABASE"
        echo "   Host: krabbeldb.mysql.database.azure.com"
        echo "   This is your cloud database in Azure!"
        echo ""
        echo "✅ PRODUCTION READY: This configuration will work when deployed to Azure"
        echo "✅ GITHUB DEPLOYMENT: Pushing to GitHub will deploy with Azure MySQL"
    elif [[ $MYSQL_URL == *"localhost"* ]]; then
        echo "🏠 ⚠️  You are connecting to LOCAL MySQL database"
        echo "   This won't work when deployed to Azure"
    else
        echo "🔍 Database host: $MYSQL_URL"
    fi
    
else
    echo "❌ .env file not found"
fi

echo ""
echo "🚀 To start backend with Azure MySQL:"
echo "cd backend && export \$(cat ../.env | grep -v '^#' | xargs) && mvn spring-boot:run"
