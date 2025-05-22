#!/bin/bash
# run.sh - Cross-platform script to run Krabbel application
# Created: May 22, 2025

# Set default values
PROFILE="dev"
FRONTEND=true
BACKEND=true

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --profile|-p) PROFILE="$2"; shift ;;
        --frontend-only|-f) BACKEND=false ;;
        --backend-only|-b) FRONTEND=false ;;
        --help|-h) 
            echo "Usage: ./run.sh [options]"
            echo "Options:"
            echo "  --profile, -p <profile>   Set Spring Boot profile (dev/prod, default: dev)"
            echo "  --frontend-only, -f       Run only the frontend"
            echo "  --backend-only, -b        Run only the backend"
            echo "  --help, -h                Display this help message"
            exit 0
            ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

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

echo "🚀 Starting Krabbel Application"
echo "📊 Operating System: $OS"
echo "⚙️ Profile: $PROFILE"

# Load environment variables
if [ -f .env ]; then
    echo "🔑 Loading environment variables from .env"
    if [ "$OS" == "Windows" ]; then
        # On Windows, we need a different approach to source .env
        set -a
        source .env
        set +a
    else
        export $(grep -v '^#' .env | xargs)
    fi
else
    echo "⚠️ Warning: .env file not found. Using default values."
fi

# Function to run backend
run_backend() {
    echo "🔄 Starting backend server (profile: $PROFILE)"
    cd backend || exit 1
    
    # Set environment variables for the backend
    export SPRING_PROFILES_ACTIVE=$PROFILE
    
    # Run the backend based on OS
    if [ "$OS" == "Windows" ]; then
        ./mvnw.cmd spring-boot:run -Dspring-boot.run.profiles=$PROFILE
    else
        ./mvnw spring-boot:run -Dspring-boot.run.profiles=$PROFILE
    fi
}

# Function to run frontend
run_frontend() {
    echo "🔄 Starting frontend development server"
    cd frontend || exit 1
    npm install
    npm run dev
}

# Run services based on flags
if [ "$BACKEND" = true ] && [ "$FRONTEND" = true ]; then
    # Run both concurrently
    if [ "$OS" == "Windows" ]; then
        start "Krabbel Backend" bash -c "cd $(pwd) && ./run.sh --backend-only --profile $PROFILE"
        start "Krabbel Frontend" bash -c "cd $(pwd) && ./run.sh --frontend-only"
    else
        # Use background process on Unix-like systems
        echo "🔄 Starting services concurrently"
        (cd "$(pwd)" && ./run.sh --backend-only --profile "$PROFILE" &)
        (cd "$(pwd)" && ./run.sh --frontend-only &)
        wait
    fi
elif [ "$BACKEND" = true ]; then
    run_backend
elif [ "$FRONTEND" = true ]; then
    run_frontend
fi
