#!/bin/bash
# run.sh - Unified script to run Krabbel application in any environment
# Created: May 28, 2025 (updated)

# ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Display formatted message
print_header() {
    echo -e "\n${BOLD}${GREEN}$1${NC}"
    echo -e "${GREEN}$(printf '=%.0s' $(seq 1 50))${NC}\n"
}

print_step() {
    echo -e "${YELLOW}→ $1${NC}"
}

print_error() {
    echo -e "${RED}ERROR: $1${NC}" >&2
}

# Set default values
PROFILE="dev"
FRONTEND=true
BACKEND=true
TARGET_PORT=8080 # Default backend port
TEST_DB_CONNECTION=false
DEBUG_MODE=false
SETUP_ENV=false

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --profile|-p) PROFILE="$2"; shift ;;
        --frontend-only|-f) BACKEND=false ;;
        --backend-only|-b) FRONTEND=false ;;
        --port) TARGET_PORT="$2"; shift ;;
        --test-db) TEST_DB_CONNECTION=true ;;
        --debug) DEBUG_MODE=true ;;
        --setup) SETUP_ENV=true ;;
        --help|-h) 
            echo -e "${BOLD}Usage: ./run.sh [options]${NC}"
            echo -e "${BOLD}Options:${NC}"
            echo "  --profile, -p <profile>   Set Spring Boot profile (dev/prod, default: dev)"
            echo "  --frontend-only, -f       Run only the frontend"
            echo "  --backend-only, -b        Run only the backend"
            echo "  --port <port_number>      Set the backend port (default: 8080)"
            echo "  --test-db                 Test database connection before starting"
            echo "  --debug                   Enable debug mode with enhanced logging"
            echo "  --setup                   Run environment setup before starting"
            echo "  --help, -h                Display this help message"
            exit 0
            ;;
        *) echo -e "${RED}Unknown parameter: $1${NC}"; exit 1 ;;
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

# Determine project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${PROJECT_ROOT}/.env"

print_header "🚀 Starting Krabbel Application"
echo -e "${GREEN}Operating System:${NC} $OS"
echo -e "${GREEN}Profile:${NC} ${BOLD}$PROFILE${NC}"
echo -e "${GREEN}Target Backend Port:${NC} $TARGET_PORT"

# Run environment setup if requested
if [ "$SETUP_ENV" = true ]; then
    print_step "Running environment setup..."
    if [ -f "${PROJECT_ROOT}/setup-env.sh" ]; then
        bash "${PROJECT_ROOT}/setup-env.sh"
    else
        print_error "setup-env.sh not found in ${PROJECT_ROOT}"
    fi
fi

# Load environment variables
if [ -f "$ENV_FILE" ]; then
    print_step "Loading environment variables from $ENV_FILE"
    
    # Better method to extract and export variables while preserving special characters
    # Skip comment lines and empty lines
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip lines that start with # or //
        [[ $line =~ ^#.* ]] && continue
        [[ $line =~ ^//.* ]] && continue
        # Skip empty lines
        [[ -z "$line" ]] && continue
        
        # Extract variable name and value
        if [[ $line =~ ^([A-Za-z_][A-Za-z0-9_]*)=(.*)$ ]]; then
            name="${BASH_REMATCH[1]}"
            value="${BASH_REMATCH[2]}"
            # Export the variable with its value
            export "$name"="$value"
            echo "Exported: $name"
        fi
    done < "$ENV_FILE"
    
    # Always set Spring profile explicitly
    export SPRING_PROFILES_ACTIVE=$PROFILE
    echo "Exported: SPRING_PROFILES_ACTIVE=$PROFILE"
else
    print_error "Environment file '$ENV_FILE' not found"
    echo -e "${YELLOW}Run with --setup to create a new .env file${NC}"
    exit 1
fi

# Show key environment variables for debug purposes
if [ "$PROFILE" == "prod" ]; then
    echo -e "\n${GREEN}Production environment variables:${NC}"
    echo "Effective PORT: ${PORT:-$TARGET_PORT}"
    echo "AZURE_MYSQL_URL: ${AZURE_MYSQL_URL}"
    echo "AZURE_MYSQL_USERNAME: ${AZURE_MYSQL_USERNAME}"
    # Do not echo password
fi

# Function to test database connection
test_database_connection() {
    if [ "$PROFILE" == "prod" ]; then
        print_step "Testing MySQL production database connectivity..."
        if command -v mysql &> /dev/null; then
            # Extract hostname, port, and database name from JDBC URL
            if [[ $AZURE_MYSQL_URL =~ jdbc:mysql://([^:/]+)(:([0-9]+))?/([^?]+) ]]; then
                host="${BASH_REMATCH[1]}"
                port="${BASH_REMATCH[3]:-3306}"
                db="${BASH_REMATCH[4]}"
                
                echo -e "Attempting to connect to MySQL at ${BOLD}$host:$port/$db${NC}..."
                if mysql -h "$host" -P "$port" -u "$AZURE_MYSQL_USERNAME" -p"$AZURE_MYSQL_PASSWORD" -e "SELECT 1;" "$db" &> /dev/null; then
                    echo -e "${GREEN}MySQL connection successful!${NC}"
                    return 0
                else
                    print_error "Could not connect to MySQL. The application may fail to start."
                    if [ "$DEBUG_MODE" = true ]; then
                        echo "Connection details:"
                        echo "Host: $host"
                        echo "Port: $port"
                        echo "Database: $db"
                        echo "Username: $AZURE_MYSQL_USERNAME"
                        echo "URL: $AZURE_MYSQL_URL"
                        # Don't print password
                    fi
                    return 1
                fi
            else
                print_error "Could not parse MySQL URL for testing. URL format may be invalid."
                echo "URL: $AZURE_MYSQL_URL"
                return 1
            fi
        else
            echo -e "${YELLOW}MySQL client not installed, skipping connectivity test.${NC}"
            return 0
        fi
    else
        print_step "Testing MySQL development database connectivity..."
        if command -v mysql &> /dev/null; then
            echo -e "Attempting to connect to MySQL with dev credentials..."
            if mysql -u "${MYSQL_USERNAME:-testuser}" -p"${MYSQL_PASSWORD:-password}" -e "SELECT 1;" &> /dev/null; then
                echo -e "${GREEN}MySQL connection successful!${NC}"
                return 0
            else
                print_error "Could not connect to MySQL. The application may fail to start."
                return 1
            fi
        else
            echo -e "${YELLOW}MySQL client not installed, skipping connectivity test.${NC}"
            return 0
        fi
    fi
}

# Function to run backend
run_backend() {
    print_header "Starting Backend Server"
    echo -e "Profile: ${BOLD}$PROFILE${NC}"
    echo -e "Port: ${BOLD}$TARGET_PORT${NC}"
    
    cd "${PROJECT_ROOT}/backend" || { print_error "Failed to change directory to backend from $(pwd)"; exit 1; }

    # Test database connection if requested
    if [ "$TEST_DB_CONNECTION" = true ]; then
        test_database_connection
        if [ $? -ne 0 ] && [ "$DEBUG_MODE" != true ]; then
            print_error "Database connection test failed. Use --debug for more information."
            echo -e "${YELLOW}Continuing anyway. Application may fail to start properly.${NC}"
        fi
    fi

    # Find and kill processes using the target port
    print_step "Checking if port $TARGET_PORT is in use..."
    if [ "$OS" == "Windows" ]; then
        # For Windows, use netstat and taskkill
        PID_USING_PORT=$(netstat -ano | findstr ":$TARGET_PORT" | findstr "LISTENING" | awk '{print $5}' | head -n 1)
        if [ -n "$PID_USING_PORT" ] && [ "$PID_USING_PORT" -ne "0" ]; then
            echo -e "${YELLOW}Port $TARGET_PORT is in use by PID $PID_USING_PORT. Attempting to terminate...${NC}"
            taskkill /F /PID "$PID_USING_PORT"
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}Process $PID_USING_PORT terminated.${NC}"
            else
                print_error "Failed to terminate process $PID_USING_PORT. Manual intervention may be required."
            fi
        else
            echo -e "${GREEN}Port $TARGET_PORT is free.${NC}"
        fi
    else
        # For Linux/macOS, use lsof and kill
        PID_USING_PORT=$(lsof -t -i:"$TARGET_PORT" 2>/dev/null)
        if [ -n "$PID_USING_PORT" ]; then
            echo -e "${YELLOW}Port $TARGET_PORT is in use by PID(s) $PID_USING_PORT. Attempting to terminate...${NC}"
            # Kill all PIDs found for the port
            for pid_to_kill in $PID_USING_PORT; do
                kill -9 "$pid_to_kill" 2>/dev/null
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}Process $pid_to_kill terminated.${NC}"
                else
                    print_error "Failed to terminate process $pid_to_kill. Manual intervention may be required."
                fi
            done
            sleep 2 # Give a moment for the port to be released
        else
            echo -e "${GREEN}Port $TARGET_PORT is free.${NC}"
        fi
    fi

    # Set environment variables for the backend
    export SPRING_PROFILES_ACTIVE=$PROFILE
    export SERVER_PORT=$TARGET_PORT # Ensure Spring Boot uses this port

    # Run with debug logging if debug mode is enabled
    JAVA_OPTS=""
    if [ "$DEBUG_MODE" = true ]; then
        echo -e "${YELLOW}Running with enhanced debug logging${NC}"
        JAVA_OPTS="-Dlogging.level.org.springframework=DEBUG \
        -Dlogging.level.com.zaxxer.hikari=DEBUG \
        -Dlogging.level.org.flywaydb=DEBUG \
        -Dlogging.level.org.hibernate=DEBUG \
        -Dspring.datasource.hikari.leak-detection-threshold=2000"
    fi

    # Run the backend based on OS
    print_step "Launching Spring Boot application..."
    if [ "$OS" == "Windows" ]; then
        ./mvnw.cmd spring-boot:run -Dspring-boot.run.profiles=$PROFILE -Dserver.port=$TARGET_PORT -Dspring-boot.run.jvmArguments="$JAVA_OPTS"
    else
        ./mvnw spring-boot:run -Dspring-boot.run.profiles=$PROFILE -Dserver.port=$TARGET_PORT -Dspring-boot.run.jvmArguments="$JAVA_OPTS"
    fi
}

# Function to run frontend
run_frontend() {
    print_header "Starting Frontend Development Server"
    cd "${PROJECT_ROOT}/frontend" || { print_error "Failed to change directory to frontend from $(pwd)"; exit 1; }
    
    # Check if node_modules exists, if not install dependencies
    if [ ! -d "node_modules" ]; then
        print_step "Installing frontend dependencies..."
        npm install
    fi

    print_step "Launching Vue.js development server..."
    npm run dev
}

# Main execution logic
if [ "$BACKEND" = true ] && [ "$FRONTEND" = true ]; then
    # Run both services concurrently
    if [ "$OS" == "Windows" ]; then
        print_header "Starting Services Concurrently"
        # Use start command on Windows
        SCRIPT_PATH=$(cygpath -w "${PROJECT_ROOT}/run.sh" 2>/dev/null || echo "${PROJECT_ROOT}/run.sh")
        start "Krabbel Backend" bash -c "$SCRIPT_PATH --backend-only --profile $PROFILE --port $TARGET_PORT $([ "$DEBUG_MODE" = true ] && echo '--debug') $([ "$TEST_DB_CONNECTION" = true ] && echo '--test-db')"
        start "Krabbel Frontend" bash -c "$SCRIPT_PATH --frontend-only"
    else
        # Use background processes on Unix-like systems
        print_header "Starting Services Concurrently"
        # Create command strings with appropriate flags
        BACKEND_CMD="${PROJECT_ROOT}/run.sh --backend-only --profile $PROFILE --port $TARGET_PORT"
        [ "$DEBUG_MODE" = true ] && BACKEND_CMD+=" --debug"
        [ "$TEST_DB_CONNECTION" = true ] && BACKEND_CMD+=" --test-db"
        
        # Run in background with proper error handling
        (bash -c "$BACKEND_CMD" || echo -e "${RED}Backend process failed${NC}") &
        BACKEND_PID=$!
        (bash -c "${PROJECT_ROOT}/run.sh --frontend-only" || echo -e "${RED}Frontend process failed${NC}") &
        FRONTEND_PID=$!
        
        echo -e "${GREEN}Backend process started with PID: $BACKEND_PID${NC}"
        echo -e "${GREEN}Frontend process started with PID: $FRONTEND_PID${NC}"
        
        # Trap SIGINT (Ctrl+C) to properly kill child processes
        trap 'echo -e "\n${YELLOW}Stopping all processes...${NC}"; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit 0' SIGINT
        
        # Wait for both background processes
        wait $BACKEND_PID $FRONTEND_PID
        echo -e "\n${GREEN}All processes completed${NC}"
    fi
elif [ "$BACKEND" = true ]; then
    run_backend
elif [ "$FRONTEND" = true ]; then
    run_frontend
else
    print_error "No services selected to run"
    echo -e "Run with --help to see available options"
    exit 1
fi
