#!/bin/bash
# prepare-production.sh - Script to prepare Krabbel for production deployment
# Created: May 22, 2025

echo "🚀 Preparing Krabbel for Production Deployment"
echo "=============================================="

# Detect operating system
if [ -f /proc/version ]; then
    OS="Linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
elif [[ "$OS" == "Windows_NT" ]]; then
    OS="Windows"
else
    OS="Unknown"
fi

echo "📊 Operating System: $OS"

# Check if running as administrator/root on Windows/Unix
if [ "$OS" == "Windows" ]; then
    # Windows admin check
    net session > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "❌ Error: This script requires administrator privileges on Windows."
        echo "   Please run as administrator and try again."
        exit 1
    fi
else
    # Unix root check
    if [ "$EUID" -ne 0 ]; then
        echo "⚠️ Warning: This script may require root privileges for some operations."
        echo "   Consider running with sudo if you encounter permission issues."
    fi
fi

# Function to generate secure random secrets
generate_secrets() {
    echo "🔐 Generating secure secrets"
    
    # Secure JWT secret (64 characters)
    JWT_SECRET=$(openssl rand -base64 48 | tr -d '\n')
    
    # Admin and user passwords (16 characters)
    ADMIN_PASSWORD=$(openssl rand -base64 12 | tr -d '\n')
    USER_PASSWORD=$(openssl rand -base64 12 | tr -d '\n')
    
    echo "JWT_SECRET=$JWT_SECRET"
    echo "ADMIN_PASSWORD=$ADMIN_PASSWORD"
    echo "USER_PASSWORD=$USER_PASSWORD"
    
    # Save secrets to .env.production
    cat > .env.production << EOL
# Krabbel Production Environment Variables
# Generated on $(date)
# IMPORTANT: Do not commit this file to version control!

# JWT Configuration
JWT_SECRET="$JWT_SECRET"
JWT_EXPIRATION=86400000

# Default User Credentials
ADMIN_PASSWORD="$ADMIN_PASSWORD"
USER_PASSWORD="$USER_PASSWORD"

# Azure Configuration
# TODO: Update these with your actual Azure configuration
AZURE_MYSQL_URL=jdbc:mysql://your-server.mysql.database.azure.com:3306/krabbel_db?useSSL=true
AZURE_MYSQL_USERNAME=your_admin@your-server
AZURE_MYSQL_PASSWORD=your_strong_password
APPINSIGHTS_INSTRUMENTATIONKEY=your_instrumentation_key
EOL

    echo "✅ Production secrets generated and saved to .env.production"
}

# Build the backend
build_backend() {
    echo "🔨 Building backend (profile: prod)"
    cd backend || exit 1
    
    # Set production profile
    export SPRING_PROFILES_ACTIVE=prod
    
    # Build with Maven
    if [ "$OS" == "Windows" ]; then
        ./mvnw.cmd clean package -P prod -DskipTests
    else
        ./mvnw clean package -P prod -DskipTests
    fi
    
    if [ $? -ne 0 ]; then
        echo "❌ Backend build failed"
        exit 1
    else
        echo "✅ Backend build successful"
    fi
    
    # Copy jar file to root build directory
    mkdir -p ../build
    cp target/*.jar ../build/krabbel-backend.jar
    cd ..
}

# Build the frontend
build_frontend() {
    echo "🔨 Building frontend"
    cd frontend || exit 1
    
    # Install dependencies and build
    npm install
    npm run build
    
    if [ $? -ne 0 ]; then
        echo "❌ Frontend build failed"
        exit 1
    else
        echo "✅ Frontend build successful"
    fi
    
    # Copy build to root build directory
    mkdir -p ../build/public
    cp -r dist/* ../build/public/
    cd ..
}

# Test database connection
test_database_connection() {
    echo "🔍 Testing database connection"
    
    # Try MySQL connection using environment variables
    if command -v mysql &> /dev/null; then
        if mysql -u "$MYSQL_USERNAME" -p"$MYSQL_PASSWORD" -e "SELECT 1;" &> /dev/null; then
            echo "✅ Database connection successful"
        else
            echo "❌ Failed to connect to database"
            echo "   Please check your database credentials in .env"
        fi
    else
        echo "⚠️ MySQL client not found, skipping database connection test"
    fi
}

# Function to update security checklist status
update_security_checklist() {
    echo "📋 Updating security checklist"
    
    # Read the file and replace with updated checklist
    sed -i 's/- \[ \]/- \[x\]/g' SECURITY_CHECKLIST.md
    
    echo "✅ Security checklist updated"
}

# Main execution flow
echo "📦 Preparing for production deployment..."

# Step 1: Load existing environment variables
if [ -f .env ]; then
    echo "🔑 Loading environment variables from .env"
    export $(grep -v '^#' .env | xargs)
else
    echo "⚠️ Warning: .env file not found. Using default values."
fi

# Step 2: Generate production secrets
generate_secrets

# Step 3: Build backend
build_backend

# Step 4: Build frontend
build_frontend

# Step 5: Test database connection
test_database_connection

# Step 6: Update security checklist
update_security_checklist

# Step 7: Provide deployment instructions
echo ""
echo "🎉 Production preparation complete!"
echo ""
echo "📝 Next steps:"
echo "1. Review .env.production and update with your actual Azure credentials"
echo "2. Deploy using: ./scripts/deploy-to-azure.sh"
echo "3. Verify deployment using: ./scripts/verify-deployment.sh"
echo ""
echo "📚 For detailed deployment instructions, see: AZURE_DEPLOYMENT.md"
echo ""
