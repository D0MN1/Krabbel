#!/bin/bash
# setup-env.sh - Script to set up the environment for Krabbel application
# Created: May 22, 2025

# ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Function to display section header
display_header() {
    echo -e "\n${BOLD}${GREEN}$1${NC}"
    echo -e "${GREEN}$(printf '=%.0s' $(seq 1 50))${NC}\n"
}

# Function to display step
display_step() {
    echo -e "${YELLOW}→ $1${NC}"
}

# Function to display error
display_error() {
    echo -e "${RED}ERROR: $1${NC}"
}

# Display greeting
display_header "Krabbel Environment Setup"
echo -e "This script will help you set up the Krabbel application environment."

# Check for .env file and create if not exists
display_step "Checking environment configuration..."
if [ ! -f .env ]; then
    display_step "Creating .env file from template..."
    if [ -f .env.template ]; then
        cp .env.template .env
        echo -e "${GREEN}Created .env file from template. Please edit it with your settings.${NC}"
        echo -e "You can use: ${YELLOW}nano .env${NC}"
    else
        display_error ".env.template not found. Creating basic .env file..."
        cat > .env << EOL
# Krabbel Application Environment Variables
# Generated on $(date)
# IMPORTANT: Do not commit this file to version control!

# Database Configuration
MYSQL_USERNAME=krabbel_user
MYSQL_PASSWORD=password

# JWT Configuration
JWT_SECRET=your_very_secure_jwt_secret_key_here
JWT_EXPIRATION=86400000

# Frontend URL for CORS
CORS_ALLOWED_ORIGINS=http://localhost:5173

# Default User Credentials
ADMIN_PASSWORD=admin_password
USER_PASSWORD=user_password

# Azure MySQL Configuration (for production profile)
AZURE_MYSQL_URL=jdbc:mysql://localhost:3306/krabbeldb?useSSL=false&allowPublicKeyRetrieval=true&createDatabaseIfNotExist=true
AZURE_MYSQL_USERNAME=krabbel_user
AZURE_MYSQL_PASSWORD=password
EOL
        echo -e "${YELLOW}Created basic .env file. Please edit it with your settings.${NC}"
        echo -e "You can use: ${YELLOW}nano .env${NC}"
    fi
else
    echo -e "${GREEN}.env file already exists.${NC}"
fi

# Check if MySQL is installed and running
display_step "Checking MySQL/MariaDB installation..."
if command -v mysql &> /dev/null; then
    echo -e "${GREEN}MySQL/MariaDB client found.${NC}"
    
    # Test connection
    if mysql -u "$MYSQL_USERNAME" -p"$MYSQL_PASSWORD" -e "SELECT 1;" &> /dev/null; then
        echo -e "${GREEN}Database connection successful.${NC}"
    else
        display_error "Failed to connect to database with current credentials."
        echo -e "Please check your database settings in .env file."
    fi
else
    display_error "MySQL/MariaDB client not found."
    echo -e "Please install MySQL or MariaDB to continue."
fi

# Check Java installation
display_step "Checking Java installation..."
if command -v java &> /dev/null; then
    java_version=$(java -version 2>&1 | head -1 | cut -d'"' -f2 | sed 's/^1\.//' | cut -d'.' -f1)
    echo -e "${GREEN}Java found (version: $java_version).${NC}"
    
    if [ "$java_version" -lt 17 ]; then
        display_error "Java version $java_version is too old. Krabbel requires Java 17+."
        echo -e "Please upgrade your Java installation."
    fi
else
    display_error "Java not found."
    echo -e "Please install Java 17 or higher to continue."
fi

# Check Node.js installation
display_step "Checking Node.js installation..."
if command -v node &> /dev/null; then
    node_version=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    echo -e "${GREEN}Node.js found (version: $node_version).${NC}"
    
    if [ "$node_version" -lt 16 ]; then
        display_error "Node.js version $node_version is too old. Krabbel requires Node.js 16+."
        echo -e "Please upgrade your Node.js installation."
    fi
else
    display_error "Node.js not found."
    echo -e "Please install Node.js 16 or higher to continue."
fi

# Install frontend dependencies
display_step "Checking frontend dependencies..."
if [ -d "frontend" ] && [ -f "frontend/package.json" ]; then
    echo -e "${GREEN}Frontend project found.${NC}"
    read -p "Do you want to install frontend dependencies now? (y/n): " install_frontend
    if [[ "$install_frontend" =~ ^[Yy]$ ]]; then
        (cd frontend && npm install)
        echo -e "${GREEN}Frontend dependencies installed.${NC}"
    else
        echo -e "Skipping frontend dependency installation."
    fi
else
    display_error "Frontend project not found."
fi

# Success message
display_header "Environment Setup Complete"
echo -e "${GREEN}You can now run the application using:${NC}"
echo -e "  ${YELLOW}./run.sh${NC}                    # Run both backend and frontend"
echo -e "  ${YELLOW}./run.sh --backend-only${NC}     # Run only backend"
echo -e "  ${YELLOW}./run.sh --frontend-only${NC}    # Run only frontend"
echo -e "  ${YELLOW}./run.sh --profile prod${NC}     # Run with production profile"
echo -e "\n${GREEN}For production preparation:${NC}"
echo -e "  ${YELLOW}./prepare-production.sh${NC}"
echo -e "\n${GREEN}Happy coding!${NC}\n"
